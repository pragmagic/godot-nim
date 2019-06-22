import tables, hashes

import godotcoretypes
import internal/godotinternaltypes, internal/godotvariants,
       internal/godotstrings, internal/godotdictionaries,
       internal/godotarrays

type
  Variant* = ref object
    godotVariant: GodotVariant
    noDeinit: bool # used to avoid copying when passing the variant to Godot

export VariantType, VariantCallErrorType, VariantCallError

proc markNoDeinit*(v: Variant) {.inline.} =
  ## Makes it so that internal GodotVariant object will not be destroyed
  ## when the reference is gone. Use only if you know what you are doing.
  v.noDeinit = true

proc godotVariant*(v: Variant): ptr GodotVariant {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## ``v``
  addr v.godotVariant

proc getType*(v: Variant): VariantType =
  v.godotVariant.getType()

proc variantFinalizer*(v: Variant) =
  if not v.noDeinit:
    v.godotVariant.deinit()

proc `$`*(self: Variant): string {.inline.} =
  $self.godotVariant

proc newVariant*(): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant)

proc newVariant*(v: Variant): Variant {.inline.} =
  ## Makes a copy
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, v.godotVariant)

proc newVariant*(v: GodotVariant): Variant {.inline.} =
  new(result, variantFinalizer)
  result.godotVariant = v

proc newVariant*(b: bool): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, b)

# resolves Nim call ambiguities well
template numConstructor(T, ConvT) =
  proc newVariant*(i: T): Variant {.inline.} =
    new(result, variantFinalizer)
    initGodotVariant(result.godotVariant, ConvT(i))

numConstructor(uint8, uint64)
numConstructor(uint16, uint64)
numConstructor(uint32, uint64)
numConstructor(uint64, uint64)
numConstructor(uint, uint64)

numConstructor(int8, int64)
numConstructor(int16, int64)
numConstructor(int32, int64)
numConstructor(int64, int64)
numConstructor(int, int64)

proc newVariant*(r: cdouble): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, r)

proc newVariant*(s: string): Variant {.inline.} =
  new(result, variantFinalizer)
  var godotStr = s.toGodotString()
  initGodotVariant(result.godotVariant, godotStr)
  godotStr.deinit()

import basis, nodepaths
import planes, quats, rect2, aabb, rids
import transforms, transform2d, vector2
import vector3, colors

proc newVariant*(v2: Vector2): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, v2)

proc newVariant*(rect2: Rect2): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, rect2)

proc newVariant*(v3: Vector3): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, v3)

proc newVariant*(t2d: Transform2D): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, t2d)

proc newVariant*(plane: Plane): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, plane)

proc newVariant*(quat: Quat): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, quat)

proc newVariant*(aabb: AABB): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, aabb)

proc newVariant*(basis: Basis): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, basis)

proc newVariant*(trans: Transform): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, trans)

proc newVariant*(color: Color): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, color)

proc newVariant*(nodePath: NodePath): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, nodePath.godotNodePath[])

proc newVariant*(godotNodePath: GodotNodePath): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, godotNodePath)

proc newVariant*(rid: RID): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, rid)

proc newVariant*(obj: ptr GodotObject): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, obj)

import poolarrays

proc newVariant*(pba: PoolByteArray): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, pba.godotPoolByteArray[])

proc newVariant*(pia: PoolIntArray): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, pia.godotPoolIntArray[])

proc newVariant*(pra: PoolRealArray): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, pra.godotPoolRealArray[])

proc newVariant*(psa: PoolStringArray): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, psa.godotPoolStringArray[])

proc newVariant*(pv2a: PoolVector2Array): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, pv2a.godotPoolVector2Array[])

proc newVariant*(pv3a: PoolVector3Array): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, pv3a.godotPoolVector3Array[])

proc newVariant*(pca: PoolColorArray): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, pca.godotPoolColorArray[])

proc asBool*(self: Variant): bool {.inline.} =
  self.godotVariant.asBool()

proc asUInt*(self: Variant): uint64 {.inline.} =
  self.godotVariant.asUInt()

proc asInt*(self: Variant): int64 {.inline.} =
  self.godotVariant.asInt()

proc asReal*(self: Variant): cdouble {.inline.} =
  self.godotVariant.asReal()

proc asString*(self: Variant): string {.inline.} =
  $self

proc asVector2*(self: Variant): Vector2 {.inline.} =
  self.godotVariant.asVector2()

proc asRect2*(self: Variant): Rect2 {.inline.} =
  self.godotVariant.asRect2()

proc asVector3*(self: Variant): Vector3 {.inline.} =
  self.godotVariant.asVector3()

proc asTransform2D*(self: Variant): Transform2D {.inline.} =
  self.godotVariant.asTransform2D()

proc asPlane*(self: Variant): Plane {.inline.} =
  self.godotVariant.asPlane()

proc asQuat*(self: Variant): Quat {.inline.} =
  self.godotVariant.asQuat()

proc asAABB*(self: Variant): AABB {.inline.} =
  self.godotVariant.asAABB()

proc asBasis*(self: Variant): Basis {.inline.} =
  self.godotVariant.asBasis()

proc asTransform*(self: Variant): Transform {.inline.} =
  self.godotVariant.asTransform()

proc asColor*(self: Variant): Color {.inline.} =
  self.godotVariant.asColor()

proc asNodePath*(self: Variant): NodePath {.inline.} =
  result = newNodePath(self.godotVariant.asNodePath())

proc asRID*(self: Variant): RID {.inline.} =
  self.godotVariant.asRID()

proc asGodotObject*(self: Variant): ptr GodotObject {.inline.} =
  self.godotVariant.asGodotObject()

proc asPoolByteArray*(self: Variant): PoolByteArray {.inline.} =
  newPoolByteArray(self.godotVariant.asGodotPoolByteArray())

proc asPoolIntArray*(self: Variant): PoolIntArray {.inline.} =
  newPoolIntArray(self.godotVariant.asGodotPoolIntArray())

proc asPoolRealArray*(self: Variant): PoolRealArray {.inline.} =
  newPoolRealArray(self.godotVariant.asGodotPoolRealArray())

proc asPoolStringArray*(self: Variant): PoolStringArray {.inline.} =
  newPoolStringArray(self.godotVariant.asGodotPoolStringArray())

proc asPoolVector2Array*(self: Variant): PoolVector2Array {.inline.} =
  newPoolVector2Array(self.godotVariant.asGodotPoolVector2Array())

proc asPoolVector3Array*(self: Variant): PoolVector3Array {.inline.} =
  newPoolVector3Array(self.godotVariant.asGodotPoolVector3Array())

proc asPoolColorArray*(self: Variant): PoolColorArray {.inline.} =
  newPoolColorArray(self.godotVariant.asGodotPoolColorArray())

proc hash*(self: Variant): Hash =
  proc objectHash(obj: ptr GodotObject): Hash =
    if not obj.isNil: cast[int](obj).hash() else: 0.hash()
  result = case self.getType():
  of VariantType.Nil: Hash(0)
  of VariantType.Bool: self.asBool().hash()
  of VariantType.Int: self.asInt().hash()
  of VariantType.Real: self.asReal().hash()
  of VariantType.String: self.asString().hash()
  of VariantType.Vector2: self.asVector2().hash()
  of VariantType.Rect2: self.asRect2().hash()
  of VariantType.Vector3: self.asVector3().hash()
  of VariantType.Transform2D: self.asTransform2D().hash()
  of VariantType.Plane: self.asPlane().hash()
  of VariantType.Quat: self.asQuat().hash()
  of VariantType.AABB: self.asAABB().hash()
  of VariantType.Basis: self.asBasis().hash()
  of VariantType.Transform: self.asTransform().hash()
  of VariantType.Color: self.asColor().hash()
  of VariantType.NodePath: self.asNodePath().hash()
  of VariantType.RID: self.asRID().hash()
  of VariantType.Object: self.asGodotObject().objectHash()
  of VariantType.Dictionary: hash(self.godotVariant.asGodotDictionary().godotHash())
  of VariantType.Array: hash(self.godotVariant.asGodotArray().godotHash())
  of VariantType.PoolByteArray: self.asPoolByteArray().hash()
  of VariantType.PoolIntArray: self.asPoolIntArray().hash()
  of VariantType.PoolRealArray: self.asPoolRealArray().hash()
  of VariantType.PoolStringArray: self.asPoolStringArray().hash()
  of VariantType.PoolVector2Array: self.asPoolVector2Array().hash()
  of VariantType.PoolVector3Array: self.asPoolVector3Array().hash()
  of VariantType.PoolColorArray: self.asPoolColorArray().hash()

import arrays

proc newVariant*(arr: Array): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant, arr.godotArray[])

proc asArray*(self: Variant): Array {.inline.} =
  newArray(self.godotVariant.asGodotArray())

proc hasMethod*(self: Variant; meth: string): bool =
  var s = meth.toGodotString()
  result = self.godotVariant.hasMethod(s)
  s.deinit()

proc `==`*(self, other: Variant): bool =
  if self.isNil and other.isNil: return true
  if self.isNil != other.isNil: return false
  result = self.godotVariant == other.godotVariant

proc `<`*(self, other: Variant): bool =
  result = self.godotVariant < other.godotVariant

proc hashCompare*(self, other: Variant): bool =
  self.godotVariant.hashCompare(other.godotVariant)

proc booleanize*(self: Variant): bool =
  self.godotVariant.booleanize()
