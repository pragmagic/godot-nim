# Copyright 2018 Xored Software, Inc.

import tables, typetraits, macros, unicode
import gdnativeapi
import core.godotcoretypes, core.godotbase
import core.vector2, core.rect2,
       core.vector3, core.transform2d,
       core.planes, core.quats, core.aabb,
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
    isRef*: bool
    isFinalized: bool
    isNative: bool

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
              Transform2D or Plane or Quat or AABB or
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

  FNV1Hash = uint32

proc isFinalized*(obj: NimGodotObject): bool {.inline.} =
  obj.isFinalized

var classRegistry {.threadvar.}: TableRef[FNV1Hash, ObjectInfo]
var classRegistryStatic* {.compileTime.}: TableRef[FNV1Hash, ObjectInfo]
  ## Compile-time variable used for implementation of several procedures
  ## and macros
static:
  classRegistryStatic = newTable[FNV1Hash, ObjectInfo]()

static:
  import sets, strutils
var nativeClasses {.compileTime.} = newSeq[string]()
var refClasses* {.compileTime.} = newSeq[string]()

template initFNV1Hash(hash: var FNV1Hash) =
  hash = 0x811c9dc5'u32

template appendFNV1Hash(hash: var FNV1Hash, val: uint8) =
  block:
    let u64hash = hash.uint64
    hash = (
      u64hash +
      (u64hash shl 1'u64) +
      (u64hash shl 4'u64) +
      (u64hash shl 7'u64) +
      (u64hash shl 8'u64) +
      (u64hash shl 24'u64)).uint32 xor val

{.push stackTrace:off.}
proc lsb(c: ptr cwchar_t): char {.noinit, inline.} =
  {.emit: [result, " = (char)(", c[]," & 0xFF);"]}
{.pop.}

proc fnv1Hash(godotClassName: GodotString): FNV1Hash =
  var charsCount = godotClassName.len
  let charsPtr = godotClassName.dataPtr
  if charsCount > 2 and
     charsPtr.offset(charsCount - 2).lsb == 'S' and
     charsPtr.offset(charsCount - 1).lsb == 'W':
    charsCount -= 2

  initFNV1Hash(result)
  for i in 0..<charsCount:
    let c = charsPtr.offset(i).lsb
    appendFNV1Hash(result, c.uint8)

proc fnv1Hash(godotClassName: string): FNV1Hash {.compileTime.} =
  var charsCount = godotClassName.len
  if godotClassName.endsWith("SW"):
    charsCount -= 2

  initFNV1Hash(result)
  var i = 0
  for rune in runes(godotClassName):
    if i >= charsCount:
      break
    let firstByte = uint8(rune.uint64 and 0xFF'u64)
    appendFNV1Hash(result, firstByte)
    # We don't really need to calculate hash of other bytes,
    # since we only use hashes of ASCII strings
    inc i

proc getClassName*(o: NimGodotObject): string =
  o.godotObject.getClassName()

var unreferenceMethodBind {.threadvar.}: ptr GodotMethodBind
proc unreference(o: ptr GodotObject): bool =
  if isNil(unreferenceMethodBind):
    unreferenceMethodBind = getMethod(cstring"Reference",
        cstring"unreference")
  unreferenceMethodBind.ptrCall(o, nil, addr(result))

var referenceMethodBind {.threadvar.}: ptr GodotMethodBind
proc reference(o: ptr GodotObject): bool {.discardable.} =
  if isNil(referenceMethodBind):
    referenceMethodBind = getMethod(cstring"Reference",
        cstring"reference")
  referenceMethodBind.ptrCall(o, nil, addr result)

var initRefMethodBind {.threadvar.}: ptr GodotMethodBind
proc initRef(o: ptr GodotObject): bool {.discardable.} =
  if isNil(initRefMethodBind):
    initRefMethodBind = getMethod(cstring"Reference",
        cstring"init_ref")
  initRefMethodBind.ptrCall(o, nil, addr result)

proc deinit*(obj: NimGodotObject) =
  ## Destroy the object. You only need to call this for objects not inherited
  ## from Reference, where manual lifecycle control is necessary.
  assert(not obj.godotObject.isNil)
  obj.godotObject.deinit()
  obj.godotObject = nil

proc nimGodotObjectFinalizer*[T: NimGodotObject](obj: T) =
  if obj.godotObject.isNil or obj.isNative: return
  # important to set it before so that ``unreference`` is aware
  obj.isFinalized = true
  if (obj.isRef or not obj.linkedObject.isNil and obj.linkedObject.isRef) and 
     obj.godotObject.unreference():
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

proc inherits(t: NimNode, parent: string): bool {.compileTime.} =
  var curT = t
  while true:
    let typeName = ($curT[1][1]).split(':')[0]
    if typeName == parent:
      return true
    if typeName == "NimGodotObject":
      break
    curT = getType(curT[1][1])

macro isReference(T: typedesc): bool =
  result = if inherits(getType(T), "Reference"): ident("true")
           else: ident("false")

macro isResource(T: typedesc): bool =
  result = if inherits(getType(T), "Resource"): ident("true")
           else: ident("false")

template registerClass*(T: typedesc; godotClassName: string or cstring,
                        native: bool) =
  ## Registers the specified Godot type.
  ## Used by ``gdobj`` macro and `godotapigen <godotapigen.html>`_.
  if classRegistry.isNil:
    classRegistry = newTable[FNV1Hash, ObjectInfo]()
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
  classRegistry[fnv1Hash($godotClassName)] = objInfo
  static:
    let objInfoStatic = ObjectInfo(
      baseNativeClass: base,
      isNative: native,
      isRef: isRef,
    )
    let nameHash = fnv1Hash($godotClassName)
    if not classRegistryStatic.contains(nameHash):
      classRegistryStatic[nameHash] = objInfoStatic
    elif not endsWith($godotClassName, "SW"):
      # For simplicity we assume that all class names must have
      # different hashes
      # If this exception is ever raised, I guess, we should
      # implement a proper collision resolving
      raise newException(Exception, "Hash collision " & $godotClassName)
  when isRef:
    static:
      refClasses.add(T.name)
  when native:
    static:
      nativeClasses.add(T.name)

proc newNimGodotObject[T: NimGodotObject](
    godotObject: ptr GodotObject, godotClassName: GodotString, noRef: bool): T =
  assert(not classRegistry.isNil)
  assert(not godotObject.isNil)
  let objInfo = classRegistry.getOrDefault(fnv1Hash(godotClassName))
  if objInfo.constructor.isNil:
    printError("Nim constructor not found for class " & $godotClassName)
  else:
    result = T(objInfo.constructor())
    result.godotObject = godotObject
    result.isRef = objInfo.isRef
    if not noRef and objInfo.isRef:
      result.godotObject.reference()

proc asNimGodotObject*[T: NimGodotObject](
    godotObject: ptr GodotObject, forceNativeObject, noRef: bool = false): T =
  ## Wraps ``godotObject`` into Nim type ``T``.
  ## This is used by `godotapigen <godotapigen.html>`_ and should rarely be
  ## used by anything else.
  if godotObject.isNil: return nil
  let userDataPtr = godotObject.getUserData()
  if not userDataPtr.isNil and not forceNativeObject:
    result = cast[T](userDataPtr)
    if result.godotObject != godotObject:
      # Could be data from other bindings
      result = nil
  if result.isNil:
    var classNameStr = godotObject.getClassNameRaw()
    result = newNimGodotObject[T](
      godotObject, classNameStr,
      forceNativeObject or noRef)
    deinit(classNameStr)

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
  if system.`of`(obj, T):
    result = T(obj)
  elif not obj.linkedObject.isNil and system.`of`(obj.linkedObject, T):
    result = T(obj.linkedObject)
  else:
    when not defined(release):
      printError("Failed to cast object to " &
                  T.name & "\n" & getStackTrace())
    result = nil

proc `of`*[T1, T2: NimGodotObject](obj: T1, t: typedesc[T2]): bool {.inline.} =
  ## Godot-specific inheritance check.
  not obj.isNil and (system.`of`(obj, T2) or system.`of`(obj.linkedObject, T2))

proc newRStrLit(s: string): NimNode {.compileTime.} =
  result = newNimNode(nnkRStrLit)
  result.strVal = s

static:
  import strutils

macro toGodotName(T: typedesc): string =
  var godotName: string
  if T is GodotString or T is string:
    godotName = "String"
  elif T is SomeFloat:
    godotName = "float"
  elif T is SomeUnsignedInt or T is SomeSignedInt:
    godotName = "int"
  if godotName.isNil or godotName.len == 0:
    let nameStr = (($T.getType()[1][1].symbol).split(':')[0])
    godotName = case nameStr:
    of "File", "Directory", "Thread", "Mutex", "Semaphore":
      "_" & nameStr
    else:
      nameStr

  result = newLit(godotName)

macro asCString(s: static[string]): cstring =
  result = newNimNode(nnkCallStrLit).add(
             ident("cstring"), newRStrLit(s))

proc getSingleton*[T: NimGodotObject](): T =
  ## Returns singleton of type ``T``. Normally, this should not be used,
  ## because `godotapigen <godotapigen.html>`_ wraps singleton methods so that
  ## singleton objects don't have to be provided as parameters.
  const godotName = asCString(toGodotName(T))
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
    if result.isRef:
      result.isFinalized = true
      result.godotObject.reference()
      result.isFinalized = false
  ret.deinit()

proc gdnew*[T: NimGodotObject](): T =
  ## Instantiates new object of type ``T``.
  const godotName = toGodotName(T)
  const cGodotName = asCString(godotName)
  const objInfo = classRegistryStatic[fnv1Hash(godotName)]
  when objInfo.isNative:
    let godotObject = getClassConstructor(cGodotName)()
    new(result, nimGodotObjectFinalizer[T])
    result.godotObject = godotObject
    when objInfo.isRef:
      godotObject.initRef()
      result.isRef = true
  else:
    result = newOwnObj[T](cGodotName)

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
  nativeObj.isNative = true

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
    hint: when isResource(T): GodotPropertyHint.ResourceType
          else: GodotPropertyHint.None,
    hintStr: toGodotName(T)
  )

proc toVariant*(self: NimGodotObject): Variant {.inline.} =
  if self.isNil:
    newVariant()
  else:
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
  if self.isNil:
    newVariant()
  else:
    newVariant(self)

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
    elif T is AABB:
      VariantType.AABB
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
  when val is ref:
    if val.isNil:
      newVariant()
    else:
      newVariant(val)
  else:
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
  elif self is AABB:
    self = val.asAABB()
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

template arrayToVariant(s: untyped): Variant =
  var arr = newArray()
  mixin toVariant
  for item in s:
    arr.add(toVariant(item))
  newVariant(arr)

proc toVariant*[T](s: seq[T]): Variant =
  if s.isNil:
    return newVariant()
  result = arrayToVariant(s)

proc toVariant*[I, T](s: array[I, T]): Variant =
  result = arrayToVariant(s)

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

proc godotTypeInfo*(T: typedesc[Table|TableRef|OrderedTable|OrderedTableRef]): GodotTypeInfo {.inline.} =
  result.variantType = VariantType.Dictionary

proc toVariant*[T: Table or TableRef or OrderedTable or OrderedTableRef](t: T): Variant =
  when t is ref:
    if t.isNil:
      return newVariant()
  var dict = newDictionary()
  mixin toVariant
  for k, v in t.pairs():
    dict[toVariant(k)] = toVariant(v)
  result = newVariant(dict)

proc fromVariant*[T: Table or TableRef or OrderedTable or OrderedTableRef](t: var T,
                                        val: Variant): ConversionResult =
  if val.getType() == VariantType.Nil:
    when t is ref:
      t = nil
  elif val.getType() == VariantType.Dictionary:
    let dict = val.asDictionary()
    mixin fromVariant
    when t is Table:
      t = initTable[type(t.keys()), type(t.values())]()
    elif t is TableRef:
      t = newTable[type(t.keys()), type(t.values())]()
    elif t is OrderedTable:
      t = initOrderedTable[type(t.keys()), type(t.values())]()
    else:
      t = newOrderedTable[type(t.keys()), type(t.values())]()
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
N_LIB_EXPORT N_CDECL(void, NimMain)(void);
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

  var stackBottom {.volatile.}: pointer
  {.emit: """
    NimMain();
    setStackBottom((void*)(&`stackBottom`));
  """.}
  GC_fullCollect()
  GC_disable()

proc godot_gdnative_init(options: ptr GDNativeInitOptions) {.
    cdecl, exportc, dynlib.} =
  gdNativeLibraryObj = options.gdNativeLibrary
  setGDNativeAPI(options.gdNativeAPIStruct, options)

proc godot_gdnative_terminate(options: ptr GDNativeTerminateOptions) {.
    cdecl, exportc, dynlib.} =
  if not options[].inEditor or not compileOption("threads"):
    deallocHeap(runFinalizers = not options[].inEditor, allowGcAfterwards = false)

const nimGcStepLengthUs {.intdefine.} = 2000

var idleCallbacks {.threadvar.}: seq[proc () {.closure.}]
idleCallbacks = newSeq[proc () {.closure.}]()

var isMainThread {.threadvar.}: bool
isMainThread = true

proc registerFrameCallback*(cb: proc () {.closure.}) =
  # Registers a callback to be called on the main thread at the end
  # of each frame.
  if not isMainThread:
    const err = cstring"registerFrameIdleCallback is called from non-main thread. Ignoring."
    godotPrintError(err, cstring"registerFrameCallback",
                    cstring"godotnim.nim", 0)
  else:
    idleCallbacks.add(cb)

{.push stackTrace: off.}

proc godot_nativescript_frame() {.cdecl, exportc, dynlib.} =
  var stackBottom {.volatile.}: pointer
  {.emit: """
  setStackBottom((void*)(&`stackBottom`));
  """.}
  for cb in idleCallbacks:
    cb()
  GC_step(nimGcStepLengthUs, true, 0)

when not defined(release):
  onUnhandledException = proc(errorMsg: string) =
    printError("Unhandled Nim exception: " & errorMsg)

proc godot_nativescript_thread_enter() {.cdecl, exportc, dynlib.} =
  when compileOption("threads"):
    setupForeignThreadGc()
  else:
    const err = cstring"A foreign thread is created, but app is compiled without --threads:on. Bad things will happen if Nim code is invoked from this thread. If you see this warning when running the editor and you don't actually use threads, ignore it."
    var s = err.toGodotString()
    godotPrint(s)
    s.deinit()

proc godot_nativescript_thread_exit() {.cdecl, exportc, dynlib.} =
  when compileOption("threads"):
    teardownForeignThreadGc()

{.pop.} # stackTrace: off
