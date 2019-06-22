# Copyright 2018 Xored Software, Inc.

import core/godotcoretypes, godotinternaltypes, gdnativeapi

proc getType*(p: GodotVariant): VariantType {.inline.} =
  getGDNativeAPI().variantGetType(p)

proc initGodotVariant*(dest: var GodotVariant) {.inline.} =
  getGDNativeAPI().variantNewNil(dest)

proc initGodotVariant*(dest: var GodotVariant, src: GodotVariant) {.inline.} =
  getGDNativeAPI().variantNewCopy(dest, src)

proc initGodotVariant*(dest: var GodotVariant; b: bool) {.inline.} =
  getGDNativeAPI().variantNewBool(dest, b)

proc initGodotVariant*(dest: var GodotVariant; i: uint64) {.inline.} =
  getGDNativeAPI().variantNewUInt(dest, i)

proc initGodotVariant*(dest: var GodotVariant; i: int64) {.inline.} =
  getGDNativeAPI().variantNewInt(dest, i)

proc initGodotVariant*(dest: var GodotVariant; r: cdouble) {.inline.} =
  getGDNativeAPI().variantNewReal(dest, r)

proc initGodotVariant*(dest: var GodotVariant; s: GodotString) {.inline.} =
  getGDNativeAPI().variantNewString(dest, s)

proc initGodotVariant*(dest: var GodotVariant; v2: Vector2) {.inline.} =
  getGDNativeAPI().variantNewVector2(dest, v2)

proc initGodotVariant*(dest: var GodotVariant; rect2: Rect2) {.inline.} =
  getGDNativeAPI().variantNewRect2(dest, rect2)

proc initGodotVariant*(dest: var GodotVariant; v3: Vector3) {.inline.} =
  getGDNativeAPI().variantNewVector3(dest, v3)

proc initGodotVariant*(dest: var GodotVariant; t2d: Transform2D) {.inline.} =
  getGDNativeAPI().variantNewTransform2D(dest, t2d)

proc initGodotVariant*(dest: var GodotVariant; plane: Plane) {.inline.} =
  getGDNativeAPI().variantNewPlane(dest, plane)

proc initGodotVariant*(dest: var GodotVariant; quat: Quat) {.inline.} =
  getGDNativeAPI().variantNewQuat(dest, quat)

proc initGodotVariant*(dest: var GodotVariant; aabb: AABB) {.inline.} =
  getGDNativeAPI().variantNewAABB(dest, aabb)

proc initGodotVariant*(dest: var GodotVariant; basis: Basis) {.inline.} =
  getGDNativeAPI().variantNewBasis(dest, basis)

proc initGodotVariant*(dest: var GodotVariant; trans: Transform) {.inline.} =
  getGDNativeAPI().variantNewTransform(dest, trans)

proc initGodotVariant*(dest: var GodotVariant; color: Color) {.inline.} =
  getGDNativeAPI().variantNewColor(dest, color)

proc initGodotVariant*(dest: var GodotVariant;
                       nodePath: GodotNodePath) {.inline.} =
  getGDNativeAPI().variantNewNodePath(dest, nodePath)

proc initGodotVariant*(dest: var GodotVariant; rid: RID) {.inline.} =
  getGDNativeAPI().variantNewRID(dest, rid)

proc initGodotVariant*(dest: var GodotVariant;
                       obj: ptr GodotObject) {.inline.} =
  getGDNativeAPI().variantNewObject(dest, obj)

proc initGodotVariant*(dest: var GodotVariant; arr: GodotArray) {.inline.} =
  getGDNativeAPI().variantNewArray(dest, arr)

proc initGodotVariant*(dest: var GodotVariant;
                       pba: GodotPoolByteArray) {.inline.} =
  getGDNativeAPI().variantNewPoolByteArray(dest, pba)

proc initGodotVariant*(dest: var GodotVariant;
                       pia: GodotPoolIntArray) {.inline.} =
  getGDNativeAPI().variantNewPoolIntArray(dest, pia)

proc initGodotVariant*(dest: var GodotVariant;
                       pra: GodotPoolRealArray) {.inline.} =
  getGDNativeAPI().variantNewPoolRealArray(dest, pra)

proc initGodotVariant*(dest: var GodotVariant;
                       psa: GodotPoolStringArray) {.inline.} =
  getGDNativeAPI().variantNewPoolStringArray(dest, psa)

proc initGodotVariant*(dest: var GodotVariant;
                       pv2a: GodotPoolVector2Array) {.inline.} =
  getGDNativeAPI().variantNewPoolVector2Array(dest, pv2a)

proc initGodotVariant*(dest: var GodotVariant;
                       pv3a: GodotPoolVector3Array) {.inline.} =
  getGDNativeAPI().variantNewPoolVector3Array(dest, pv3a)

proc initGodotVariant*(dest: var GodotVariant;
                       pca: GodotPoolColorArray) {.inline.} =
  getGDNativeAPI().variantNewPoolColorArray(dest, pca)

proc initGodotVariant*(dest: var GodotVariant;
                       dict: GodotDictionary) {.inline.} =
  getGDNativeAPI().variantNewDictionary(dest, dict)

proc deinit*(v: var GodotVariant) {.inline.} =
  getGDNativeAPI().variantDestroy(v)

proc asBool*(self: GodotVariant): bool {.inline.} =
  getGDNativeAPI().variantAsBool(self)

proc asUInt*(self: GodotVariant): uint64 {.inline.} =
  getGDNativeAPI().variantAsUInt(self)

proc asInt*(self: GodotVariant): int64 {.inline.} =
  getGDNativeAPI().variantAsInt(self)

proc asReal*(self: GodotVariant): cdouble {.inline.} =
  getGDNativeAPI().variantAsReal(self)

proc asGodotString*(self: GodotVariant): GodotString {.inline.} =
  getGDNativeAPI().variantAsString(self)

proc asVector2*(self: GodotVariant): Vector2 {.inline.} =
  getGDNativeAPI().variantAsVector2(self).toVector2()

proc asRect2*(self: GodotVariant): Rect2 {.inline.} =
  getGDNativeAPI().variantAsRect2(self).toRect2()

proc asVector3*(self: GodotVariant): Vector3 {.inline.} =
  getGDNativeAPI().variantAsVector3(self).toVector3()

proc asTransform2D*(self: GodotVariant): Transform2D {.inline.} =
  getGDNativeAPI().variantAsTransform2D(self).toTransform2D()

proc asPlane*(self: GodotVariant): Plane {.inline.} =
  getGDNativeAPI().variantAsPlane(self).toPlane()

proc asQuat*(self: GodotVariant): Quat {.inline.} =
  getGDNativeAPI().variantAsQuat(self).toQuat()

proc asAABB*(self: GodotVariant): AABB {.inline.} =
  getGDNativeAPI().variantAsAABB(self).toAABB()

proc asBasis*(self: GodotVariant): Basis {.inline.} =
  getGDNativeAPI().variantAsBasis(self).toBasis()

proc asTransform*(self: GodotVariant): Transform {.inline.} =
  getGDNativeAPI().variantAsTransform(self).toTransform()

proc asColor*(self: GodotVariant): Color {.inline.} =
  getGDNativeAPI().variantAsColor(self).toColor()

proc asNodePath*(self: GodotVariant): GodotNodePath {.inline.} =
  getGDNativeAPI().variantAsNodePath(self)

proc asRID*(self: GodotVariant): RID {.inline.} =
  getGDNativeAPI().variantAsRID(self)

proc asGodotObject*(self: GodotVariant): ptr GodotObject {.inline.} =
  getGDNativeAPI().variantAsObject(self)

proc asGodotArray*(self: GodotVariant): GodotArray {.inline.} =
  getGDNativeAPI().variantAsArray(self)

proc asGodotPoolByteArray*(self: GodotVariant): GodotPoolByteArray {.inline.} =
  getGDNativeAPI().variantAsPoolByteArray(self)

proc asGodotPoolIntArray*(self: GodotVariant): GodotPoolIntArray {.inline.} =
  getGDNativeAPI().variantAsPoolIntArray(self)

proc asGodotPoolRealArray*(self: GodotVariant): GodotPoolRealArray {.inline.} =
  getGDNativeAPI().variantAsPoolRealArray(self)

proc asGodotPoolStringArray*(self: GodotVariant): GodotPoolStringArray
                            {.inline.} =
  getGDNativeAPI().variantAsPoolStringArray(self)

proc asGodotPoolVector2Array*(self: GodotVariant): GodotPoolVector2Array
                             {.inline.} =
  getGDNativeAPI().variantAsPoolVector2Array(self)

proc asGodotPoolVector3Array*(self: GodotVariant): GodotPoolVector3Array
                             {.inline.} =
  getGDNativeAPI().variantAsPoolVector3Array(self)

proc asGodotPoolColorArray*(self: GodotVariant): GodotPoolColorArray
                           {.inline.} =
  getGDNativeAPI().variantAsPoolColorArray(self)

proc asGodotDictionary*(self: GodotVariant): GodotDictionary {.inline.} =
  getGDNativeAPI().variantAsDictionary(self)

proc call*(self: var GodotVariant; meth: GodotString;
           args: ptr array[256, ptr GodotVariant]; argCount: cint;
           error: var VariantCallError): GodotVariant {.inline.} =
  getGDNativeAPI().variantCall(self, meth, args, argCount, error)

proc hasMethod*(self: GodotVariant; meth: GodotString): bool {.inline.} =
  getGDNativeAPI().variantHasMethod(self, meth)

proc `==`*(self, other: GodotVariant): bool {.inline.} =
  getGDNativeAPI().variantOperatorEqual(self, other)

proc `<`*(self, other: GodotVariant): bool {.inline.} =
  getGDNativeAPI().variantOperatorLess(self, other)

proc hashCompare*(self, other: GodotVariant): bool {.inline.} =
  getGDNativeAPI().variantHashCompare(self, other)

proc booleanize*(self: GodotVariant): bool {.inline.} =
  getGDNativeAPI().variantBooleanize(self)

import godotstrings
proc `$`*(self: GodotVariant): string =
  var s = self.asGodotString()
  result = $s
  s.deinit()
