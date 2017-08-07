# Copyright 2017 Xored Software, Inc.

import tables, typetraits, macros, asyncdispatch
import core.godotbase
import core.vector2, core.rect2,
       core.vector3, core.transform2d,
       core.planes, core.quats, core.rect3,
       core.basis, core.transforms, core.colors,
       core.nodepaths, core.rids, core.dictionaries,
       core.arrays, core.poolarrays, core.variants
import godotinternal

## This module defines ``NimGodotObject`` and ``toVariant``/``fromVariant``
## converters for Nim types. The converters are used by
## `gdobj <godotmacros.html#gdobj.m,untyped,typed>`_ macro to import/export
## values from/to Godot (editor, GDScript).
##
## You can also allow conversion of any custom type ``MyType`` by implementing:
##
## .. code-block:: nim
##   proc godotTypeInfo*(T: typedesc[MyType]): GodotTypeInfo
##   proc toVariant*(self: MyType): Variant
##   proc fromVariant*(self: var MyType, val: Variant): ConversionResult
##
## Implementing ``godotTypeInfo`` is optional and is necessary only if you want
## the type to be editable from the editor.

type
  NimGodotObject* = ref object of RootObj
    ## The base type all Godot types inherit from.
    ## Manages lifecycle of the wrapped ``GodotObject``.
    godotObject: ptr GodotObject
    linkedObject: NimGodotObject
      ## Wrapper around native object that is the container of the Nim "script"
      ## This is needed for `of` checks and `as` conversions to work as
      ## expected. For example, Nim type may inherit from ``Spatial``, but the
      ## script is attached to ``Particles``. In this case conversion to
      ## ``Particles`` is valid, but Nim type system is not aware of that.
      ## This works in both directions - for linked native object this
      ## reference points to Nim object.
    isExternalRef: bool

  ConversionResult* {.pure.} = enum
    ## Conversion result to return from ``fromVariant`` procedure.
    OK,
    TypeError,
      ## Type mismatch
    RangeError
      ## Types match, but the value is out of range.
      ## Mainly used for numeric (ordinal) types.

  SomeUnsignedInt = uint8 or uint16 or uint32 or uint64 or uint or cuint
  SomeSignedInt = int8 or int16 or int32 or int64 or int or cint
  SomeFloat = float32 or float64 or cfloat

  SomeGodot = bool or Vector2 or Rect2 or Vector3 or
              Transform2D or Plane or Quat or Rect3 or
              Basis or Transform or Color or NodePath or
              RID or GodotObject or Dictionary or Array or
              PoolByteArray or PoolIntArray or PoolRealArray or
              PoolStringArray or PoolVector2Array or PoolVector3Array or
              PoolColorArray or GodotString

  SomeGodotOrNum = SomeGodot or SomeSignedInt or SomeUnsignedInt or SomeFloat

  CallError* = object of Exception
    ## Raised by wrappers in case of an incorrect dynamic invocation.
    ## For example, if incorrect number of arguments were passed or they had
    ## unexpected types.
    err*: VariantCallError
      ## The error as returned by Godot

  ObjectInfo = object
    constructor: proc(): NimGodotObject {.gcsafe, nimcall.}
    baseNativeClass: cstring
    isNative: bool
    isRef: bool

  GodotTypeInfo* = object
    ## Type information provided to Godot editor
    variantType*: VariantType
    hint*: GodotPropertyHint
    hintStr*: string
      ## Format depends on the type and the hint.
      ## For example, for Enum ``hint`` this is a comma separated list of
      ## values.
      ## See documentation of ``GodotPropertyHint`` for description of formats.

template printWarning*(warning: typed) =
  ## Prints ``warning`` to Godot log, adding filename and line information.
  let (filename, line) = instantiationInfo()
  godotPrintWarning(cstring($warning), nil, cstring(filename), line.cint)

template printError*(error: typed) =
  ## Prints ``error`` to Godot log, adding filename and line information.
  let (filename, line) = instantiationInfo()
  godotPrintError(cstring($error), nil, cstring(filename), line.cint)

proc print*(parts: varargs[string, `$`]) =
  ## Prints concatenated ``parts`` to Godot log.
  var combined = ""
  for v in parts:
    combined.add(v)
  var s = combined.toGodotString()
  godotPrint(s)
  s.deinit()

var classRegistry {.threadvar.}: TableRef[cstring, ObjectInfo]
var classRegistryStatic* {.compileTime.}: TableRef[cstring, ObjectInfo]
  ## Compile-time variable used for implementation of several procedures
  ## and macros
static:
  classRegistryStatic = newTable[cstring, ObjectInfo]()

static:
  import sets, strutils
var nativeClasses {.compileTime.} = newSeq[string]()
var refClasses* {.compileTime.} = newSeq[string]()

proc getClassName*(o: NimGodotObject): string =
  o.godotObject.getClassName()

var unreferenceMethodBind {.threadvar.}: ptr GodotMethodBind
proc unreference(o: ptr GodotObject): bool =
  if isNil(unreferenceMethodBind):
    unreferenceMethodBind = getMethod(cstring"Reference",
        cstring"unreference")
  unreferenceMethodBind.ptrCall(o, nil, addr(result))

var referenceMethodBind {.threadvar.}: ptr GodotMethodBind
proc reference(o: ptr GodotObject) =
  if isNil(referenceMethodBind):
    referenceMethodBind = getMethod(cstring"Reference",
        cstring"reference")
  referenceMethodBind.ptrCall(o, nil, nil)

proc deinit*(obj: NimGodotObject) =
  ## Destroy the object. You only need to call this for objects not inherited
  ## from Reference, where manual lifecycle control is necessary.
  assert(not obj.godotObject.isNil)
  obj.godotObject.deinit()
  obj.godotObject = nil
  # linked object internal pointer should be unset from destructor
  assert(obj.linkedObject.isNil or obj.linkedObject.godotObject.isNil)

proc nimGodotObjectFinalizer*[T: NimGodotObject](obj: T) =
  if obj.godotObject.isNil: return
  if obj.isExternalRef and obj.godotObject.unreference():
    obj.deinit()
  elif not obj.linkedObject.isNil:
    obj.deinit()

macro baseNativeType(T: typedesc): cstring =
  var t = getType(getType(T)[1][1])
  var baseT: string
  while true:
    let typeName = ($t[1][1]).split(':')[0]
    if typeName in nativeClasses:
      baseT = typeName
      break
    if typeName == "NimGodotObject":
      break
    t = getType(t[1][1])
  if baseT.isNil:
    result = newNilLit()
  else:
    let rStr = newNimNode(nnkRStrLit)
    rStr.strVal = baseT
    result = newNimNode(nnkCallStrLit).add(ident("cstring"), rStr)

macro isReference(T: typedesc): bool =
  var isRef = false
  var t = getType(T)
  while true:
    let typeName = ($t[1][1]).split(':')[0]
    if typeName == "Reference":
      isRef = true
      break
    if typeName == "NimGodotObject":
      break
    t = getType(t[1][1])
  result = if isRef: ident("true")
           else: ident("false")

template registerClass*(T: typedesc; godotClassName: cstring,
                        native: bool) =
  ## Registers the specified Godot type.
  ## Used by ``gdobj`` macro and `godotapigen <godotapigen.html>`_.
  if classRegistry.isNil:
    classRegistry = newTable[cstring, ObjectInfo]()
  let constructor = proc(): NimGodotObject =
    var t: T
    new(t, nimGodotObjectFinalizer[T])
    result = t

  const base = baseNativeType(T)
  const isRef: bool = isReference(T)
  let objInfo = ObjectInfo(
    constructor: constructor,
    baseNativeClass: base,
    isNative: native,
    isRef: isRef
  )
  classRegistry[godotClassName] = objInfo
  static:
    let objInfoStatic = ObjectInfo(
      baseNativeClass: base,
      isNative: native,
      isRef: isRef,
    )
    classRegistryStatic[godotClassName] = objInfoStatic
  when isRef:
    static:
      refClasses.add(T.name)
  when native:
    static:
      nativeClasses.add(T.name)

proc newNimGodotObject[T: NimGodotObject](
    godotObject: ptr GodotObject, godotClassName: cstring, noRef: bool): T =
  assert(not classRegistry.isNil)
  assert(not godotObject.isNil)
  let objInfo = classRegistry.getOrDefault(godotClassName)
  if objInfo.constructor.isNil:
    printError("Nim constructor not found for class " & $godotClassName)
  else:
    result = T(objInfo.constructor())
    result.godotObject = godotObject
    if not noRef and objInfo.isRef:
      result.isExternalRef = true
      result.godotObject.reference()

proc asNimGodotObject*[T: NimGodotObject](
    godotObject: ptr GodotObject, noRef: bool = false): T =
  ## Wraps ``godotObject`` into Nim type ``T``.
  ## This is used by `godotapigen <godotapigen.html>`_ and should rarely be
  ## used by anything else.
  if godotObject.isNil: return nil
  let userDataPtr = godotObject.getUserData()
  if not userDataPtr.isNil:
    result = cast[T](userDataPtr)
    if result.godotObject != godotObject:
      # Could be data from other bindings
      result = nil
  if result.isNil:
    result = newNimGodotObject[T](
      godotObject, cstring(godotObject.getClassName()), noRef)

proc newVariant*(obj: NimGodotObject): Variant {.inline.} =
  newVariant(obj.godotObject)

proc asObject*[T: NimGodotObject](v: Variant): T {.inline.} =
  ## Converts ``v`` to object of type ``T``.
  ## Returns ``nil`` if the conversion cannot be performed
  ## (``v``'s type is not an Object or it's an object of an incompatible type)
  asNimGodotObject[T](v.asGodotObject())

proc asObject*(v: Variant, T: typedesc[NimGodotObject]): T {.inline.} =
  ## Converts ``v`` to object of type ``T``.
  ## Returns ``nil`` if the conversion cannot be performed
  ## (``v``'s type is not an Object or it's an object of an incompatible type)
  asNimGodotObject[T](v.asGodotObject())

proc `as`*[T: NimGodotObject](obj: NimGodotObject, t: typedesc[T]): T =
  ## Converts the ``obj`` into the specified type.
  ## Returns ``nil`` if the conversion cannot be performed
  ## (the ``obj`` is not of the type ``T``)
  ##
  ## This can be used either in dot notation (``node.as(Button)``) or
  ## infix notation (``node as Button``).
  if obj.isNil: return nil
  if obj of T:
    result = T(obj)
  elif not obj.linkedObject.isNil and obj.linkedObject of T:
    result = T(obj.linkedObject)
  else:
    when not defined(release):
      printError("Failed to cast object to " &
                  T.name & "\n" & getStackTrace())
    result = nil

proc `~`*[T: NimGodotObject](obj: NimGodotObject,
                             t: typedesc[T]): bool {.inline.} =
  ## Godot-specific inheritance check. You must use this over Nim's standard
  ## ``of`` operator, because Nim does not know which object your script is
  ## attached to in runtime. For example, if you create a
  ## ``gdobj Bullet of Spatial`` and the ``Bullet`` is attached to a
  ## ``MeshInstance``, ``myBullet of MeshInstance`` will return ``false``, but
  ## ``myBullet ~ MeshInstance`` will return ``true``.
  ## This is going to be changed to ``of`` in later versions, when Nim starts
  ## supporting overloading ``of`` operator.
  not obj.isNil and (obj of T or obj.linkedObject of T)

proc newRStrLit(s: string): NimNode {.compileTime.} =
  result = newNimNode(nnkRStrLit)
  result.strVal = s

static:
  import strutils

macro toGodotName(T: typedesc): cstring =
  var godotName: string
  if T is GodotString or T is string:
    godotName = "String"
  elif T is SomeFloat:
    godotName = "float"
  elif T is SomeUnsignedInt or T is SomeSignedInt:
    godotName = "int"
  if godotName.isNil:
    let nameStr: string = (($T.getType()[1][1].symbol).split(':')[0])
    godotName = case nameStr:
    of "File", "Directory", "Thread", "Mutex", "Semaphore":
      "_" & nameStr
    else:
      nameStr

  result = newNimNode(nnkCallStrLit).add(
             ident("cstring"), newRStrLit(godotName))

proc getSingleton*[T: NimGodotObject](): T =
  ## Returns singleton of type ``T``. Normally, this should not be used,
  ## because `godotapigen <godotapigen.html>`_ wraps singleton methods so that
  ## singleton objects don't have to be provided as parameters.
  const godotName = toGodotName(T)
  let singleton = getGodotSingleton(godotName)
  if singleton.isNil:
    printError("Tried to get non-existing singleton of type " & $godotName)
  else:
    result = asNimGodotObject[T](singleton)

var gdNativeLibraryObj: ptr GodotObject

var setClassNameMethod: ptr GodotMethodBind
var setLibraryMethod: ptr GodotMethodBind
var newMethod: ptr GodotMethodBind
type
  PtrCallArgType = ptr array[MAX_ARG_COUNT, pointer]
proc newOwnObj[T: NimGodotObject](name: cstring): T =
  let newNativeScript = getClassConstructor(cstring"NativeScript")()
  if setClassNameMethod.isNil:
    setClassNameMethod =
      getMethod(cstring"NativeScript", cstring"set_class_name")
  if setLibraryMethod.isNil:
    setLibraryMethod =
      getMethod(cstring"NativeScript", cstring"set_library")
  if newMethod.isNil:
    newMethod = getMethod(cstring"NativeScript", cstring"new")
  var godotStrName = name.toGodotString()
  var argPtr: pointer = addr godotStrName
  setClassNameMethod.ptrCall(
    newNativeScript, cast[PtrCallArgType](addr argPtr), nil)
  deinit(godotStrName)
  setLibraryMethod.ptrCall(
    newNativeScript, cast[PtrCallArgType](addr gdNativeLibraryObj), nil)

  var err: VariantCallError
  var ret = newMethod.call(newNativeScript, nil, 0, err)
  if err.error != VariantCallErrorType.OK:
    printError("Failed to invoke 'new' on NativeScript for " & $name)
  elif ret.getType() != VariantType.Object:
    printError("Expected that NativeScript::new returns Object, " &
               "but it returned: " & $ret.getType())
  else:
    result = asNimGodotObject[T](ret.asGodotObject())
  ret.deinit()

proc gdnew*[T: NimGodotObject](): T =
  ## Instantiates new object of type ``T``.
  const godotName = toGodotName(T)
  const objInfo = classRegistryStatic[godotName]
  result = when objInfo.isNative:
             asNimGodotObject[T](getClassConstructor(godotName)())
           else: newOwnObj[T](godotName)

proc newCallError*(err: VariantCallError): ref CallError =
  ## Instantiates ``CallError`` from Godot ``err``.
  let msg = case err.error:
  of VariantCallErrorType.OK,
     VariantCallErrorType.InvalidMethod,
     VariantCallErrorType.TooManyArguments,
     VariantCallErrorType.TooFewArguments,
     VariantCallErrorType.InstanceIsNull:
    $err.error
  of VariantCallErrorType.InvalidArgument:
    "invalid argument at position " & $err.argument & ": expected " &
      $err.expected

  result = newException(CallError, msg)
  result.err = err

proc newConversionError*(err: ConversionResult): ref ValueError =
  ## Instantiates error raised by `godotapigen <godotapigen.html>`_
  ## generated code in case of a conversion error.
  let msg = case err:
    of ConversionResult.TypeError:
      "Failed to convert the return value into Nim type"
    of ConversionResult.RangeError:
      "The returned value was out of bounds"
    of ConversionResult.OK:
      "OK"

  result = newException(ValueError, msg)

proc setGodotObject*(nimObj: NimGodotObject, obj: ptr GodotObject) {.inline.} =
  ## Used from Godot constructor produced by ``gdobj`` macro. Do not call.
  assert(not obj.isNil)
  assert(nimObj.godotObject.isNil) # reassignment is not allowed
  nimObj.godotObject = obj

proc setNativeObject*(nimObj: NimGodotObject,
                      nativeObj: NimGodotObject) {.inline.} =
  ## Used from Godot constructor produced by ``gdobj`` macro. Do not call.
  nimObj.linkedObject = nativeObj
  nativeObj.linkedObject = nimObj

proc removeGodotObject*(nimObj: NimGodotObject) {.inline.} =
  ## Used from Godot destructor produced by ``gdobj`` macro. Do not call.
  nimObj.godotObject = nil
  nimObj.linkedObject.godotObject = nil

proc `==`*(self, other: NimGodotObject): bool {.inline.} =
  ## Compares objects by referential equality.
  if self.isNil and other.isNil: return true
  if self.isNil != other.isNil: return false
  result = (self.godotObject == other.godotObject)

proc godotObject*(nimObj: NimGodotObject): ptr GodotObject {.inline.} =
  ## Returns raw poitner to ``GodotObject``. Use only if you know what
  ## you are doing.
  nimObj.godotObject

proc godotTypeInfo*(T: typedesc[NimGodotObject]): GodotTypeInfo {.inline.} =
  GodotTypeInfo(
    variantType: VariantType.Object,
    hint: GodotPropertyHint.None,
    hintStr: toGodotName(T)
  )

proc toVariant*(self: NimGodotObject): Variant {.inline.} =
  newVariant(self.godotObject)

proc fromVariant*[T: NimGodotObject](self: var T,
                                     val: Variant): ConversionResult =
  if val.getType() == VariantType.Object:
    let objPtr = val.asGodotObject()
    self = asNimGodotObject[T](objPtr)
    if self.isNil:
      result = ConversionResult.TypeError
  elif val.getType() == VariantType.Nil:
    self = nil
  else:
    result = ConversionResult.TypeError

proc toVariant*(self: Variant): Variant {.inline.} =
  self

proc fromVariant*(self: var Variant,
                  val: Variant): ConversionResult {.inline.} =
  self = newVariant(val)

proc godotTypeInfo*(T: typedesc[SomeGodotOrNum]): GodotTypeInfo {.inline.} =
  result.variantType =
    when T is SomeSignedInt or T is SomeUnsignedInt:
      VariantType.Int
    elif T is bool:
      VariantType.Bool
    elif T is SomeFloat:
      VariantType.Real
    elif T is string or T is GodotString:
      VariantType.String
    elif T is Vector2:
      VariantType.Vector2
    elif T is Rect2:
      VariantType.Rect2
    elif T is Vector3:
      VariantType.Vector3
    elif T is Transform2D:
      VariantType.Transform2D
    elif T is Plane:
      VariantType.Plane
    elif T is Quat:
      VariantType.Quat
    elif T is Rect3:
      VariantType.Rect3
    elif T is Basis:
      VariantType.Basis
    elif T is Transform:
      VariantType.Transform
    elif T is Color:
      VariantType.Color
    elif T is RID:
      VariantType.RID
    elif T is ptr GodotObject:
      VariantType.Object
    elif T is NodePath:
      VariantType.NodePath
    elif T is Dictionary:
      VariantType.Dictionary
    elif T is Array:
      VariantType.Array
    elif T is PoolByteArray:
      VariantType.PoolByteArray
    elif T is PoolIntArray:
      VariantType.PoolIntArray
    elif T is PoolRealArray:
      VariantType.PoolRealArray
    elif T is PoolStringArray:
      VariantType.PoolStringArray
    elif T is PoolVector2Array:
      VariantType.PoolVector2Array
    elif T is PoolVector3Array:
      VariantType.PoolVector3Array
    elif T is PoolColorArray:
      VariantType.PoolColorArray
    else:
      VariantType.Nil

proc godotTypeInfo*(T: typedesc[range]): VariantType {.inline.} =
  GodotTypeInfo(
    variantType: VariantType.Int,
    hint: GodotPropertyHint.Range,
    hintStr: $low(T) & "," & $high(T) & ",1"
  )

proc toVariant*[T: SomeGodotOrNum](val: T): Variant {.inline.} =
  newVariant(val)

proc fromVariant*[T: SomeSignedInt or SomeUnsignedInt](
    self: var T, val: Variant): ConversionResult =
  if val.getType() == VariantType.Nil:
    self = 0
  elif val.getType() == VariantType.Int or val.getType() == VariantType.Real:
    # Real is allowed, because that's what the editor sets for Int values
    var intVal: (when T is SomeSignedInt: int64
                 else: uint64)
    intVal = when T is SomeSignedInt: val.asInt()
             else: val.asUint()
    if intVal > high(T) or intVal < low(T):
      result = ConversionResult.RangeError
    else:
      self = T(intVal)
  else:
    result = ConversionResult.TypeError

proc godotTypeInfo*(T: typedesc[enum]): GodotTypeInfo =
  result = GodotTypeInfo(
    variantType: VariantType.Int,
    hint: GodotPropertyHint.Enum,
    hintStr: ""
  )
  for val in T:
    if result.hintStr.len > 0:
      result.hintStr.add(',')
    result.hintStr.add($val)

proc toVariant*[T: enum](self: T): Variant {.inline.} =
  newVariant(int64(ord(self)))

proc fromVariant*[T: enum](self: var T,
                           val: Variant): ConversionResult {.inline.} =
  var intConv: int64
  result = fromVariant(intConv, val)
  if result == ConversionResult.OK:
    self = T(intConv)

proc fromVariant*[T: SomeFloat](self: var T, val: Variant): ConversionResult =
  if val.getType() == VariantType.Nil:
    self = 0
  elif val.getType() == VariantType.Real or val.getType() == VariantType.Int:
    self = T(val.asReal())
  else:
    result = ConversionResult.TypeError

proc fromVariant*[T: SomeGodot](self: var T, val: Variant): ConversionResult =
  if val.getType() == VariantType.Nil:
    return
  const typeInfo = godotTypeInfo(T)
  if typeInfo.variantType != val.getType():
    return ConversionResult.TypeError
  when self is bool:
    self = val.asBool()
  elif self is Vector2:
    self = val.asVector2()
  elif self is Rect2:
    self = val.asRect2()
  elif self is Vector3:
    self = val.asVector3()
  elif self is Transform2D:
    self = val.asTransform2D()
  elif self is Plane:
    self = val.asPlane()
  elif self is Quat:
    self = val.asQuat()
  elif self is Rect3:
    self = val.asRect3()
  elif self is Basis:
    self = val.asBasis()
  elif self is Transform:
    self = val.asTransform()
  elif self is Color:
    self = val.asColor()
  elif self is NodePath:
    self = val.asNodePath()
  elif self is RID:
    self = val.asRID()
  elif self is ptr GodotObject:
    self = val.asObject()
  elif self is Dictionary:
    self = val.asDictionary()
  elif self is Array:
    self = val.asArray()
  elif self is PoolByteArray:
    self = val.asPoolByteArray()
  elif self is PoolIntArray:
    self = val.asPoolIntArray()
  elif self is PoolRealArray:
    self = val.asPoolRealArray()
  elif self is PoolStringArray:
    self = val.asPoolStringArray()
  elif self is PoolVector2Array:
    self = val.asPoolVector2Array()
  elif self is PoolVector3Array:
    self = val.asPoolVector3Array()
  elif self is PoolColorArray:
    self = val.asPoolColorArray()
  elif self is GodotString:
    self = val.asGodotString()
  else:
    # mustn't reach this
    result = ConversionError.TypeError

proc godotTypeInfo*(T: typedesc[string]): GodotTypeInfo  {.inline.} =
  result.variantType = VariantType.String

proc toVariant*(s: string): Variant {.inline.} =
  newVariant(s)

proc fromVariant*(s: var string, val: Variant): ConversionResult =
  if val.getType() == VariantType.String:
    s = val.asString()
  elif val.getType() == VariantType.Nil:
    s = nil
  else:
    result = ConversionResult.TypeError

template arrTypeInfo(T) =
  result.variantType = VariantType.Array
  mixin godotTypeInfo
  type ItemT = type((
    block:
      var s: T;
      when T is seq: s[0] else: s[low(s)]))
  when compiles(godotTypeInfo(ItemT)):
    let itemTypeInfo = godotTypeInfo(ItemT)
    result.hintStr = $ord(itemTypeInfo.variantType)
    result.hintStr.add('/')
    result.hintStr.add($ord(itemTypeInfo.hint))
    result.hintStr.add(':')
    if not itemTypeInfo.hintStr.isNil:
      result.hintStr.add(itemTypeInfo.hintStr)

proc godotTypeInfo*(T: typedesc[seq]): GodotTypeInfo =
  arrTypeInfo(T)

proc godotTypeInfo*(T: typedesc[array]): GodotTypeInfo =
  arrTypeInfo(T)

proc toVariant*[T](s: openarray[T]): Variant =
  var arr = newArray()
  mixin toVariant
  for item in s:
    arr.add(toVariant(item))
  result = newVariant(arr)

proc fromVariant*[T](s: var seq[T], val: Variant): ConversionResult =
  if val.getType() == VariantType.Nil:
    s = nil
  elif val.getType() == VariantType.Array:
    let arr = val.asArray()
    var newS = newSeq[T](arr.len)
    for idx, item in arr:
      mixin fromVariant
      let convResult = fromVariant(newS[idx], item)
      if convResult != ConversionResult.OK:
        return convResult
    shallowCopy(s, newS)
  else:
    result = ConversionResult.TypeError

proc fromVariant*[T: array](s: var T, val: Variant): ConversionResult =
  if val.getType() == VariantType.Nil:
    discard
  elif val.getType() == VariantType.Array:
    let arr = val.asArray()
    if s.len != arr.len:
      return ConversionResult.TypeError
    var nimIdx = low(s) # may not start from 0 and may even be an enum
    for item in arr:
      mixin fromVariant
      let convResult = fromVariant(s[nimIdx], item)
      if convResult != ConversionResult.OK:
        return convResult
      if nimIdx != high(s):
        inc nimIdx
  else:
    result = ConversionResult.TypeError

proc godotTypeInfo*(T: typedesc[Table|TableRef]): GodotTypeInfo {.inline.} =
  result.variantType = VariantType.Dictionary

proc toVariant*[T: Table or TableRef](t: T): Variant =
  var dict = newDictionary()
  mixin toVariant
  for k, v in t.pairs():
    dict[toVariant(k)] = toVariant(v)
  result = newVariant(dict)

proc fromVariant*[T: Table or TableRef](t: var T,
                                        val: Variant): ConversionResult =
  if val.getType() == VariantType.Nil:
    when t is ref:
      t = nil
  elif val.getType() == VariantType.Dictionary:
    let dict = val.asDictionary()
    mixin fromVariant
    when t is Table:
      t = initTable[type(t.keys()), type(t.values())]()
    else:
      t = newTable[type(t.keys()), type(t.values())]()
    for k, v in dict:
      var nimKey: type(t.keys())
      var nimVal: type(t.values())
      let keyResult = fromVariant(nimKey, k)
      if keyResult != ConversionResult.OK:
        when t is ref:
          t = nil
        return keyResult
      let valResult = fromVariant(nimVal, v)
      if valResult != ConversionResult.OK:
        when t is ref:
          t = nil
        return valResult
      t[nimKey] = nimVal
  else:
    result = ConversionResult.TypeError

{.emit: """/*TYPESECTION*/
void NimMain(void);
N_NOINLINE(void, setStackBottom)(void* thestackbottom);
""".}

var nativeLibHandle: pointer
proc getNativeLibHandle*(): pointer =
  ## Returns NativeScript library handle used to register type information
  ## in Godot.
  return nativeLibHandle

proc godot_nativescript_init(handle: pointer) {.
    cdecl, exportc, dynlib.} =
  nativeLibHandle = handle

  let stackBottom = godotStackBottom()
  {.emit: """
    NimMain();
    setStackBottom(`stackBottom`);
  """.}
  GC_fullCollect()
  GC_disable()

proc godot_gdnative_init(options: ptr GodotNativeInitOptions) {.
    cdecl, exportc, dynlib.} =
  gdNativeLibraryObj = options.gdNativeLibrary

proc godot_gdnative_terminate(options: ptr GodotNativeTerminateOptions) {.
    cdecl, exportc, dynlib.} =
  deallocHeap(runFinalizers = not options[].inEditor, allowGcAfterwards = false)

const nimGcStepLengthUs {.intdefine.} = 2000
proc godot_nativescript_frame() {.cdecl, exportc, dynlib.} =
  if asyncdispatch.hasPendingOperations():
    poll(0)
  GC_step(nimGcStepLengthUs, true, 0)

when not defined(release):
  onUnhandledException = proc(errorMsg: string) =
    printError("Unhandled Nim exception: " & errorMsg)

proc godot_nativescript_thread_enter() {.cdecl, exportc, dynlib.} =
  when compileOption("threads"):
    setupForeignThreadGc()
  else:
    print(cstring"A foreign thread is created, but app is compiled without --threads:on. Bad things will happen if Nim code is invoked from this thread.")

proc godot_nativescript_thread_exit() {.cdecl, exportc, dynlib.} =
  when compileOption("threads"):
    teardownForeignThreadGc()
