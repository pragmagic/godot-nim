# Copyright 2017 Xored Software, Inc.

import tables, typetraits, macros
import "../core/godotbase.nim", "../core/godotcore.nim"
import "../core/strings.nim", "../core/vector2.nim", "../core/rect2.nim",
       "../core/vector3.nim", "../core/transform2d.nim",
       "../core/plane.nim", "../core/quat.nim", "../core/rect3.nim",
       "../core/basis.nim", "../core/transform.nim", "../core/color.nim",
       "../core/nodepath.nim", "../core/rid.nim", "../core/dictionary.nim",
       "../core/arrays.nim", "../core/poolarray.nim", "../core/variant.nim"

## Definition of NimGodotObject and converters for built-in types.

type
  NimGodotObject* = ref object of RootObj
    godotObject: ptr GodotObject

  ConversionResult* {.pure.} = enum
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
    err*: VariantCallError

  ObjectInfo = object
    constructor: proc(): NimGodotObject {.gcsafe, nimcall.}
    baseNativeClass: cstring
    isNative: bool

var classRegistry {.threadvar.}: TableRef[cstring, ObjectInfo]

static:
  import sets, strutils
var nativeClasses {.compileTime.} = initSet[string]()

proc godotFinalizer[T: NimGodotObject](obj: T) =
  # hmm, not sure yet how to deal with references correctly
  # when T is Reference:
  #   obj.godotObject.deinit()
  discard

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

template registerClass*(T: typedesc; godotClassName: cstring,
                        isNativeParam: bool) =
  if classRegistry.isNil:
    classRegistry = newTable[cstring, ObjectInfo]()
  let constructor = proc(): NimGodotObject =
    var t: T
    new(t, godotFinalizer[T])
    result = t

  const base = baseNativeType(T)
  classRegistry[godotClassName] = ObjectInfo(
    constructor: constructor,
    baseNativeClass: base,
    isNative: isNativeParam
  )
  when isNativeParam:
    static:
      nativeClasses.incl(T.name)

proc newNimGodotObject[T: NimGodotObject](
    godotObject: ptr GodotObject, godotClassName: cstring): T =
  assert(not classRegistry.isNil)
  assert(not godotObject.isNil)
  let objInfo = classRegistry.getOrDefault(godotClassName)
  if objInfo.constructor.isNil:
    printError("Nim constructor not found for class " & $godotClassName)
  else:
    result = T(objInfo.constructor())
    result.godotObject = godotObject

proc asNimGodotObject*[T: NimGodotObject](godotObject: ptr GodotObject): T =
  if godotObject.isNil: return nil
  let userDataPtr = godotObject.getUserData()
  if not userDataPtr.isNil:
    result = cast[T](userDataPtr)
    if result.godotObject != godotObject:
      # Could be data from other bindings
      result = nil
  if result.isNil:
    result = newNimGodotObject[T](
      godotObject, cstring(godotObject.getClassName()))

proc `as`*[T: NimGodotObject](obj: NimGodotObject, t: typedesc[T]): T =
  ## Converts the ``obj`` into the specified type.
  ## Returns ``nil`` if the conversion cannot be performed
  ## (the ``obj`` is not of the type ``T``)
  if obj.isNil or not (obj of T):
    when not defined(release):
      if not obj.isNil:
        printError("Failed to cast object to " &
                   t.name & "\n" & getStackTrace())
    result = nil
  else:
    result = T(obj)

proc getSingletonGodot*(name: cstring): ptr GodotObject {.
    importc: "godot_global_get_singleton", header: "../godot.h".}

proc newRStrLit(s: string): NimNode {.compileTime.} =
  result = newNimNode(nnkRStrLit)
  result.strVal = s

static:
  import strutils
macro toGodotName(T: typedesc): cstring =
  let nameStr: string = (($T.getType()[1][1].symbol).split(':')[0])
  let godotName = case nameStr:
  of "File", "Directory", "Thread", "Mutex", "Semaphore":
    "_" & nameStr
  else:
    nameStr

  result = newNimNode(nnkCallStrLit).add(
             ident("cstring"), newRStrLit(godotName))

proc getSingleton*[T: NimGodotObject](): T =
  const godotName = toGodotName(T)
  let singleton = getSingletonGodot(godotName)
  if singleton.isNil:
    printError("Tried to get non-existing singleton of type " & $godotName)
  else:
    result = asNimGodotObject[T](singleton)

proc gdnew*[T: NimGodotObject](): T =
  const godotName = toGodotName(T)
  let obj = godotNew(godotName)
  if obj.isNil:
    printError("godot_new returned nil for type " & $godotName)
  result = asNimGodotObject[T](obj)
  # const godotName = toGodotName(T)
  # let objInfo = classRegistry.getOrDefault(godotName)
  # if objInfo.constructor.isNil:
  #   printError("gdnew invoked on unregistered class: " & $godotName)
  #   return
  # let godotConstructor = getClassConstructor(
  #   if objInfo.isNative: godotName else: objInfo.baseNativeClass)
  # printError("Base native class for " & T.name & ": " & $objInfo.baseNativeClass)
  # when not defined(release):
  #   if godotConstructor.isNil:
  #     printError("Failed to obtain Godot constrcutor for type: " & $godotName)
  #     return
  # let godotObject = godotConstructor()
  # when not defined(release):
  #   if godotObject.isNil:
  #     printError("Godot constructor returned nil - must never happen")
  #     return
  # new(result, godotFinalizer[T])
  # result.setGodotObject(godotObject)

proc newCallError*(err: VariantCallError): ref CallError =
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
  let msg = case err:
    of ConversionResult.TypeError:
      "Failed to convert the return value into Nim type"
    of ConversionResult.RangeError:
      "The returned value was out of bounds"
    of ConversionResult.OK:
      "OK"

  result = newException(ValueError, msg)

proc removeGodotObject*(nimObj: NimGodotObject) =
  ## Used from destructor
  nimObj.godotObject = nil

proc setGodotObject*(nimObj: NimGodotObject, obj: ptr GodotObject) {.inline.} =
  assert(not obj.isNil)
  assert(nimObj.godotObject.isNil) # reassignment is not allowed
  nimObj.godotObject = obj

proc godotObject*(nimObj: NimGodotObject): ptr GodotObject {.inline.} =
  nimObj.godotObject

proc godotVariantType*(T: typedesc[NimGodotObject]): VariantType {.inline.} =
  VariantType.Object

proc toGodot*(self: NimGodotObject): Variant {.inline.} =
  variant(self.godotObject)

proc fromGodot*[T: NimGodotObject](self: var T,
                                   val: Variant): ConversionResult =
  if val.getType() == VariantType.Object:
    let objPtr = val.asObject()
    self = asNimGodotObject[T](objPtr)
    if self.isNil:
      result = ConversionResult.TypeError
  elif val.getType() == VariantType.Nil:
    self = nil
  else:
    result = ConversionResult.TypeError

proc godotVariantType*(T: typedesc[enum]): VariantType {.inline.} =
  VariantType.Int

proc toGodot*[T: enum](self: T): Variant {.inline.} =
  variant(ord(self))

proc fromGodot*[T: enum](self: var T, val: Variant): ConversionResult =
  if val.getType() == VariantType.Int:
    self = T(val.asInt())
  else:
    result = ConversionResult.TypeError

proc toGodot*(self: Variant): Variant {.inline.} =
  result = self

proc fromGodot*(self: var Variant, val: Variant): ConversionResult {.inline.} =
  self = val

proc godotVariantType*(T: typedesc[SomeGodotOrNum]): VariantType {.inline.} =
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
  elif T is NodePath:
    VariantType.NodePath
  elif T is RID:
    VariantType.RID
  elif T is GodotObject:
    VariantType.Object
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

proc toGodot*[T: SomeGodotOrNum](val: T): Variant {.inline.} =
  result = variant(val)

proc fromGodot*[T: SomeSignedInt or SomeUnsignedInt](
    self: var T, val: Variant): ConversionResult =
  if val.getType() != VariantType.Int:
    result = ConversionResult.TypeError
  else:
    var intVal: (when T is SomeSignedInt: int64
                 else: uint64)
    intVal = when T is SomeSignedInt: val.asInt()
             else: val.asUint()
    if intVal > high(T) or intVal < low(T):
      result = ConversionResult.RangeError
    else:
      self = T(intVal)

proc fromGodot*[T: SomeFloat](self: var T, val: Variant): ConversionResult =
  if val.getType() == VariantType.Real:
    self = val.asReal()
  elif val.getType() == VariantType.Int:
    self = T(val.asInt())
  else:
    result = ConversionResult.TypeError

proc fromGodot*[T: SomeGodot](self: var T, val: Variant): ConversionResult =
  if godotVariantType(T) != val.getType():
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

proc godotVariantType*(T: typedesc[string]): VariantType  {.inline.} =
  VariantType.String

proc toGodot*(s: string): Variant {.inline.} =
  variant(s.toGodotString())

proc fromGodot*(s: var string, val: Variant): ConversionResult =
  if val.getType() != VariantType.String:
    result = ConversionResult.TypeError
  else:
    s = $val.asGodotString()

proc godotVariantType*(T: typedesc[seq]): VariantType =
  VariantType.Array

proc godotVariantType*(T: typedesc[array]): VariantType =
  VariantType.Array

proc toGodot*[T](s: openarray[T]): Variant =
  var arr: Array
  initArray(arr)
  mixin toGodot
  for item in s:
    arr.add(toGodot(item))
  result = variant(arr)

proc fromGodot*[T](s: var seq[T], val: Variant): ConversionResult =
  if val.getType() != VariantType.Array:
    result = ConversionResult.TypeError
  else:
    let arr = val.asArray()
    s = newSeq[T](arr.len)
    for idx, item in arr:
      mixin fromGodot
      let convResult = fromGodot(s[idx], item)
      if convResult != ConversionResult.OK:
        s = nil
        return convResult

proc fromGodot*[T: array](s: var T, val: Variant): ConversionResult =
  if val.getType() != VariantType.Array:
    result = ConversionResult.TypeError
  else:
    let arr = val.asArray()
    if s.len != arr.len:
      return ConversionResult.TypeError
    for idx, item in arr:
      mixin fromGodot
      let convResult = fromGodot(s[idx], item)
      if convResult != ConversionResult.OK:
        return convResult

proc godotVariantType*(T: typedesc[Table|TableRef]): VariantType {.inline.} =
  VariantType.Dictionary

proc toGodot*[T: Table or TableRef](t: T): Variant =
  var dict: Dictionary
  initDictionary(dict)
  mixin toGodot
  for k, v in t.pairs():
    dict[toGodot(k)] = toGodot(v)
  result = variant(dict)

proc fromGodot*[T: Table or TableRef](t: var T, val: Variant): ConversionResult =
  if val.getType() != VariantType.Dictionary:
    result = ConversionResult.TypeError
  else:
    let dict = val.asDictionary()
    mixin fromGodot
    when t is Table:
      t = initTable[type(t.keys()), type(t.values())]()
    else:
      t = newTable[type(t.keys()), type(t.values())]()
    for k, v in dict:
      var nimKey: type(t.keys())
      var nimVal: type(t.values())
      let keyResult = fromGodot(nimKey, k)
      if keyResult != ConversionResult.OK:
        when t is ref:
          t = nil
        return keyResult
      let valResult = fromGodot(nimVal, v)
      if valResult != ConversionResult.OK:
        when t is ref:
          t = nil
        return valResult
      t[nimKey] = nimVal

proc godotToNim*[T](val: Variant): (T, ConversionResult) =
  mixin fromGodot
  result[1] = fromGodot(result[0], val)

proc nimToGodot*[T](val: T): Variant =
  mixin toGodot
  when compiles(toGodot(val)):
    result = toGodot(val)
  else:
    printError("Failed to convert Nim value of type " & T.name &
               " into Variant")
    initNilVariant(result)

{.emit: """/*TYPESECTION*/
void NimMain(void);
N_NOINLINE(void, setStackBottom)(void* thestackbottom);
""".}

const stackIncreases = defined(emscripten)

proc godot_native_init() {.cdecl, exportc, dynlib.} =
  let stackBottom = godotStackBottom()
  {.emit: """
    NimMain();
    setStackBottom(`stackBottom`);
  """.}
  GC_fullCollect()
  GC_disable()

proc godot_native_terminate() {.cdecl, exportc, dynlib.} =
  discard
