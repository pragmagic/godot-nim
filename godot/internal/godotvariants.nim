# Copyright 2017 Xored Software, Inc.

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

  GodotVariant* {.byref.} = object
    data: array[4 + sizeof(int) div 4, float32]

import godotobjects, godotarrays, godotpoolarrays,
       godotstrings, godotnodepaths, godotdictionaries

import core.vector2, core.rect2,
       core.vector3, core.transform2d, core.planes,
       core.quats, core.rect3, core.basis,
       core.transforms, core.colors, core.rids,
       core.rect2

proc getType*(p: GodotVariant): VariantType {.
    importc: "godot_variant_get_type".}

proc initGodotVariant*(dest: var GodotVariant) {.
    importc: "godot_variant_new_nil".}
proc initGodotVariant*(dest: var GodotVariant, src: GodotVariant) {.
    importc: "godot_variant_new_copy".}
proc initGodotVariant*(dest: var GodotVariant; b: bool) {.
    importc: "godot_variant_new_bool".}
proc initGodotVariant*(dest: var GodotVariant; i: uint64) {.
    importc: "godot_variant_new_uint".}
proc initGodotVariant*(dest: var GodotVariant; i: int64) {.
    importc: "godot_variant_new_int".}
proc initGodotVariant*(dest: var GodotVariant; r: cdouble) {.
    importc: "godot_variant_new_real".}
proc initGodotVariant*(dest: var GodotVariant; s: GodotString) {.
    importc: "godot_variant_new_string".}
proc initGodotVariant*(dest: var GodotVariant; v2: Vector2) {.
    importc: "godot_variant_new_vector2".}
proc initGodotVariant*(dest: var GodotVariant; rect2: Rect2) {.
    importc: "godot_variant_new_rect2".}
proc initGodotVariant*(dest: var GodotVariant; v3: Vector3) {.
    importc: "godot_variant_new_vector3".}
proc initGodotVariant*(dest: var GodotVariant; t2d: Transform2D) {.
    importc: "godot_variant_new_transform2d".}
proc initGodotVariant*(dest: var GodotVariant; plane: Plane) {.
    importc: "godot_variant_new_plane".}
proc initGodotVariant*(dest: var GodotVariant; quat: Quat) {.
    importc: "godot_variant_new_quat".}
proc initGodotVariant*(dest: var GodotVariant; rect3: Rect3) {.
    importc: "godot_variant_new_rect3".}
proc initGodotVariant*(dest: var GodotVariant; basis: Basis) {.
    importc: "godot_variant_new_basis".}
proc initGodotVariant*(dest: var GodotVariant; trans: Transform) {.
    importc: "godot_variant_new_transform".}
proc initGodotVariant*(dest: var GodotVariant; color: Color) {.
    importc: "godot_variant_new_color".}
proc initGodotVariant*(dest: var GodotVariant; nodePath: GodotNodePath) {.
    importc: "godot_variant_new_node_path".}
proc initGodotVariant*(dest: var GodotVariant; rid: RID) {.
    importc: "godot_variant_new_rid".}
proc initGodotVariant*(dest: var GodotVariant; obj: ptr GodotObject) {.
    importc: "godot_variant_new_object".}
proc initGodotVariant*(dest: var GodotVariant; arr: GodotArray) {.
    importc: "godot_variant_new_array".}
proc initGodotVariant*(dest: var GodotVariant; pba: GodotPoolByteArray) {.
    importc: "godot_variant_new_pool_byte_array".}
proc initGodotVariant*(dest: var GodotVariant; pia: GodotPoolIntArray) {.
    importc: "godot_variant_new_pool_int_array".}
proc initGodotVariant*(dest: var GodotVariant; pra: GodotPoolRealArray) {.
    importc: "godot_variant_new_pool_real_array".}
proc initGodotVariant*(dest: var GodotVariant; psa: GodotPoolStringArray) {.
    importc: "godot_variant_new_pool_string_array".}
proc initGodotVariant*(dest: var GodotVariant; pv2a: GodotPoolVector2Array) {.
    importc: "godot_variant_new_pool_vector2_array".}
proc initGodotVariant*(dest: var GodotVariant; pv3a: GodotPoolVector3Array) {.
    importc: "godot_variant_new_pool_vector3_array".}
proc initGodotVariant*(dest: var GodotVariant; pca: GodotPoolColorArray) {.
    importc: "godot_variant_new_pool_color_array".}
proc initGodotVariant*(dest: var GodotVariant; dict: GodotDictionary) {.
    importc: "godot_variant_new_dictionary".}

proc deinit*(v: var GodotVariant) {.importc: "godot_variant_destroy".}

proc asBool*(self: GodotVariant): bool {.
    importc: "godot_variant_as_bool".}
proc asUInt*(self: GodotVariant): uint64 {.
    importc: "godot_variant_as_uint".}
proc asInt*(self: GodotVariant): int64 {.
    importc: "godot_variant_as_int".}
proc asReal*(self: GodotVariant): cdouble {.
    importc: "godot_variant_as_real".}
proc asGodotString*(self: GodotVariant): GodotString {.
    importc: "godot_variant_as_string".}
proc asVector2*(self: GodotVariant): Vector2 {.
    importc: "godot_variant_as_vector2".}
proc asRect2*(self: GodotVariant): Rect2 {.
    importc: "godot_variant_as_rect2".}
proc asVector3*(self: GodotVariant): Vector3 {.
    importc: "godot_variant_as_vector3".}
proc asTransform2D*(self: GodotVariant): Transform2D {.
    importc: "godot_variant_as_transform2d".}
proc asPlane*(self: GodotVariant): Plane {.
    importc: "godot_variant_as_plane".}
proc asQuat*(self: GodotVariant): Quat {.
    importc: "godot_variant_as_quat".}
proc asRect3*(self: GodotVariant): Rect3 {.
    importc: "godot_variant_as_rect3".}
proc asBasis*(self: GodotVariant): Basis {.
    importc: "godot_variant_as_basis".}
proc asTransform*(self: GodotVariant): Transform {.
    importc: "godot_variant_as_transform".}
proc asColor*(self: GodotVariant): Color {.
    importc: "godot_variant_as_color".}
proc asNodePath*(self: GodotVariant): GodotNodePath {.
    importc: "godot_variant_as_node_path".}
proc asRID*(self: GodotVariant): RID {.
    importc: "godot_variant_as_rid".}
proc asGodotObject*(self: GodotVariant): ptr GodotObject {.
    importc: "godot_variant_as_object".}
proc asGodotArray*(self: GodotVariant): GodotArray {.
    importc: "godot_variant_as_array".}
proc asGodotPoolByteArray*(self: GodotVariant): GodotPoolByteArray {.
    importc: "godot_variant_as_pool_byte_array".}
proc asGodotPoolIntArray*(self: GodotVariant): GodotPoolIntArray {.
    importc: "godot_variant_as_pool_int_array".}
proc asGodotPoolRealArray*(self: GodotVariant): GodotPoolRealArray {.
    importc: "godot_variant_as_pool_real_array".}
proc asGodotPoolStringArray*(self: GodotVariant): GodotPoolStringArray {.
    importc: "godot_variant_as_pool_string_array".}
proc asGodotPoolVector2Array*(self: GodotVariant): GodotPoolVector2Array {.
    importc: "godot_variant_as_pool_vector2_array".}
proc asGodotPoolVector3Array*(self: GodotVariant): GodotPoolVector3Array {.
    importc: "godot_variant_as_pool_vector3_array".}
proc asGodotPoolColorArray*(self: GodotVariant): GodotPoolColorArray {.
    importc: "godot_variant_as_pool_color_array".}
proc asGodotDictionary*(self: GodotVariant): GodotDictionary {.
    importc: "godot_variant_as_dictionary".}

proc call*(self: GodotVariant; meth: GodotString;
           args: var array[128, GodotVariant]; argCount: cint;
           error: var VariantCallError): GodotVariant {.
    importc: "godot_variant_call".}

proc hasMethod*(self: GodotVariant; meth: GodotString): bool {.
    importc: "godot_variant_has_method".}
proc `==`*(self, other: GodotVariant): bool {.
    importc: "godot_variant_operator_equal".}
proc `<`*(self, other: GodotVariant): bool {.
    importc: "godot_variant_operator_less".}
proc hashCompare*(self, other: GodotVariant): bool {.
    importc: "godot_variant_hash_compare".}
proc booleanize*(self: GodotVariant; isValid: var bool): bool {.
    importc: "godot_variant_booleanize".}

proc `$`*(self: GodotVariant): string =
  var s = self.asGodotString()
  result = $s
  s.deinit()
