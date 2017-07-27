import godotbase

import arrays, basis, nodepath
import plane, poolarray, quat, rect2, rect3, rid
import strings, transform, transform2d, vector2
import vector3, color

type
  VariantType* {.size: sizeof(cint), pure.} = enum
    Nil,   ##  atomic types
    Bool,
    Int,
    Real,
    String,
    # math types
    Vector2, ##  5
    Rect2,
    Vector3,
    Transform2D,
    Plane,
    Quat, ##  10
    Rect3,
    Basis,
    Transform, ##  misc types
    Color,
    NodePath, ##  15
    RID,
    Object,
    Dictionary,
    Array, ##  20
    # arrays
    PoolByteArray,
    PoolIntArray,
    PoolRealArray,
    PoolStringArray,
    PoolVector2Array, ##  25
    PoolVector3Array,
    PoolColorArray

  VariantCallErrorType* {.size: sizeof(cint), pure.} = enum
    OK,
    InvalidMethod,
    InvalidArgument,
    TooManyArguments,
    TooFewArguments,
    InstanceIsNull

  VariantCallError* = object
    error*: VariantCallErrorType
    argument*: cint
    expected*: VariantType

proc getType*(p: Variant): VariantType {.
    importc: "godot_variant_get_type".}

proc initNilVariant(dest: var Variant) {.
    importc: "godot_variant_new_nil".}
proc initVariant(dest: var Variant; b: bool) {.
    importc: "godot_variant_new_bool".}
proc initVariant(dest: var Variant; i: uint64) {.
    importc: "godot_variant_new_uint".}
proc initVariant(dest: var Variant; i: int64) {.
    importc: "godot_variant_new_int".}
proc initVariant(dest: var Variant; r: cdouble) {.
    importc: "godot_variant_new_real".}
proc initVariant(dest: var Variant; s: GodotString) {.
    importc: "godot_variant_new_string".}
proc initVariant(dest: var Variant; v2: Vector2) {.
    importc: "godot_variant_new_vector2".}
proc initVariant(dest: var Variant; rect2: Rect2) {.
    importc: "godot_variant_new_rect2".}
proc initVariant(dest: var Variant; v3: Vector3) {.
    importc: "godot_variant_new_vector3".}
proc initVariant(dest: var Variant; t2d: Transform2D) {.
    importc: "godot_variant_new_transform2d".}
proc initVariant(dest: var Variant; plane: Plane) {.
    importc: "godot_variant_new_plane".}
proc initVariant(dest: var Variant; quat: Quat) {.
    importc: "godot_variant_new_quat".}
proc initVariant(dest: var Variant; rect3: Rect3) {.
    importc: "godot_variant_new_rect3".}
proc initVariant(dest: var Variant; basis: Basis) {.
    importc: "godot_variant_new_basis".}
proc initVariant(dest: var Variant;
                 trans: Transform) {.
    importc: "godot_variant_new_transform".}
proc initVariant(dest: var Variant; color: Color) {.
    importc: "godot_variant_new_color".}
proc initVariant(dest: var Variant; nodePath: NodePath) {.
    importc: "godot_variant_new_node_path".}
proc initVariant(dest: var Variant; rid: RID) {.
    importc: "godot_variant_new_rid".}
proc initVariant(dest: var Variant; obj: ptr GodotObject) {.
    importc: "godot_variant_new_object".}
proc initVariant(dest: var Variant; arr: Array) {.
    importc: "godot_variant_new_array".}
proc initVariant(dest: var Variant; pba: PoolByteArray) {.
    importc: "godot_variant_new_pool_byte_array".}
proc initVariant(dest: var Variant; pia: PoolIntArray) {.
    importc: "godot_variant_new_pool_int_array".}
proc initVariant(dest: var Variant; pra: PoolRealArray) {.
    importc: "godot_variant_new_pool_real_array".}
proc initVariant(dest: var Variant; psa: PoolStringArray) {.
    importc: "godot_variant_new_pool_string_array".}
proc initVariant(dest: var Variant; pv2a: PoolVector2Array) {.
    importc: "godot_variant_new_pool_vector2_array".}
proc initVariant(dest: var Variant; pv3a: PoolVector3Array) {.
    importc: "godot_variant_new_pool_vector3_array".}
proc initVariant(dest: var Variant; pca: PoolColorArray) {.
    importc: "godot_variant_new_pool_color_array".}

proc variant*(): Variant {.inline.} =
  initNilVariant(result)

proc variant*(b: bool): Variant {.inline.} =
  initVariant(result, b)

proc variant*(i: uint64): Variant {.inline.} =
  initVariant(result, i)

proc variant*(i: int64): Variant {.inline.} =
  initVariant(result, i)

proc variant*(r: cdouble): Variant {.inline.} =
  initVariant(result, r)

proc variant*(s: GodotString): Variant {.inline.} =
  initVariant(result, s)

proc variant*(s: string): Variant {.inline.} =
  let godotStr = s.toGodotString()
  initVariant(result, godotStr)

proc variant*(v2: Vector2): Variant {.inline.} =
  initVariant(result, v2)

proc variant*(rect2: Rect2): Variant {.inline.} =
  initVariant(result, rect2)

proc variant*(v3: Vector3): Variant {.inline.} =
  initVariant(result, v3)

proc variant*(t2d: Transform2D): Variant {.inline.} =
  initVariant(result, t2d)

proc variant*(plane: Plane): Variant {.inline.} =
  initVariant(result, plane)

proc variant*(quat: Quat): Variant {.inline.} =
  initVariant(result, quat)

proc variant*(rect3: Rect3): Variant {.inline.} =
  initVariant(result, rect3)

proc variant*(basis: Basis): Variant {.inline.} =
  initVariant(result, basis)

proc variant*(trans: Transform): Variant {.inline.} =
  initVariant(result, trans)

proc variant*(color: Color): Variant {.inline.} =
  initVariant(result, color)

proc variant*(nodePath: NodePath): Variant {.inline.} =
  initVariant(result, nodePath)

proc variant*(rid: RID): Variant {.inline.} =
  initVariant(result, rid)

proc variant*(obj: ptr GodotObject): Variant {.inline.} =
  initVariant(result, obj)

proc variant*(arr: Array): Variant {.inline.} =
  initVariant(result, arr)

proc variant*(pba: PoolByteArray): Variant {.inline.} =
  initVariant(result, pba)

proc variant*(pia: PoolIntArray): Variant {.inline.} =
  initVariant(result, pia)

proc variant*(pra: PoolRealArray): Variant {.inline.} =
  initVariant(result, pra)

proc variant*(psa: PoolStringArray): Variant {.inline.} =
  initVariant(result, psa)

proc variant*(pv2a: PoolVector2Array): Variant {.inline.} =
  initVariant(result, pv2a)

proc variant*(pv3a: PoolVector3Array): Variant {.inline.} =
  initVariant(result, pv3a)

proc variant*(pca: PoolColorArray): Variant {.inline.} =
  initVariant(result, pca)

proc asBool*(self: Variant): bool {.
    importc: "godot_variant_as_bool".}
proc asUint*(self: Variant): uint64 {.
    importc: "godot_variant_as_uint".}
proc asInt*(self: Variant): int64 {.
    importc: "godot_variant_as_int".}
proc asReal*(self: Variant): cdouble {.
    importc: "godot_variant_as_real".}
proc asGodotString*(self: Variant): GodotString {.
    importc: "godot_variant_as_string".}

proc asString*(self: Variant): string =
  let s = self.asGodotString()
  result = $s

proc asVector2*(self: Variant): Vector2 {.
    importc: "godot_variant_as_vector2".}
proc asRect2*(self: Variant): Rect2 {.
    importc: "godot_variant_as_rect2".}
proc asVector3*(self: Variant): Vector3 {.
    importc: "godot_variant_as_vector3".}
proc asTransform2D*(self: Variant): Transform2D {.
    importc: "godot_variant_as_transform2d".}
proc asPlane*(self: Variant): Plane {.
    importc: "godot_variant_as_plane".}
proc asQuat*(self: Variant): Quat {.
    importc: "godot_variant_as_quat".}
proc asRect3*(self: Variant): Rect3 {.
    importc: "godot_variant_as_rect3".}
proc asBasis*(self: Variant): Basis {.
    importc: "godot_variant_as_basis".}
proc asTransform*(self: Variant): Transform {.
    importc: "godot_variant_as_transform".}
proc asColor*(self: Variant): Color {.
    importc: "godot_variant_as_color".}
proc asNodePath*(self: Variant): NodePath {.
    importc: "godot_variant_as_node_path".}
proc asRid*(self: Variant): RID {.
    importc: "godot_variant_as_rid".}
proc asObject*(self: Variant): ptr GodotObject {.
    importc: "godot_variant_as_object".}
proc asArray*(self: Variant): Array {.
    importc: "godot_variant_as_array".}
proc asPoolByteArray*(self: Variant): PoolByteArray {.
    importc: "godot_variant_as_pool_byte_array".}
proc asPoolIntArray*(self: Variant): PoolIntArray {.
    importc: "godot_variant_as_pool_int_array".}
proc asPoolRealArray*(self: Variant): PoolRealArray {.
    importc: "godot_variant_as_pool_real_array".}
proc asPoolStringArray*(self: Variant): PoolStringArray {.
    importc: "godot_variant_as_pool_string_array".}
proc asPoolVector2Array*(self: Variant): PoolVector2Array {.
    importc: "godot_variant_as_pool_vector2_array".}
proc asPoolVector3Array*(self: Variant): PoolVector3Array {.
    importc: "godot_variant_as_pool_vector3_array".}
proc asPoolColorArray*(self: Variant): PoolColorArray {.
    importc: "godot_variant_as_pool_color_array".}

proc call*(self: Variant; meth: GodotString;
           args: var array[MAX_ARG_COUNT, Variant]; argCount: cint;
           error: var VariantCallError): Variant {.
    importc: "godot_variant_call".}

proc hasMethod*(self: Variant; meth: GodotString): bool {.
    importc: "godot_variant_has_method".}
proc `==`*(self, other: Variant): bool {.
    importc: "godot_variant_operator_equal".}
proc `<`*(self, other: Variant): bool {.
    importc: "godot_variant_operator_less".}
proc hashCompare*(self, other: Variant): bool {.
    importc: "godot_variant_hash_compare".}
proc booleanize*(self: Variant; isValid: var bool): bool {.
    importc: "godot_variant_booleanize".}
