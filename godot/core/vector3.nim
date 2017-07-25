# Copyright (c) 2017 Xored Software, Inc.

type
  Vector3* {.importc: "godot_vector3", header: "godot/vector3.h",
             byref.} = object

import godotbase, basis, strings

type
  Vector3Axis {.importc: "godot_vector3_axis", header: "godot/vector3.h",
                size: sizeof(cint), pure.} = enum
    X,
    Y,
    Z

proc initVector3*(dest: var Vector3; x, y, z: float32) {.
    importc: "godot_vector3_new", header: "godot/vector3.h".}

proc vec3*(x, y, z: float32): Vector3 {.inline.} =
  initVector3(result, x, y, z)

proc toGodotString*(self: Vector3): GodotString {.
    importc: "godot_vector3_as_string", header: "godot/vector3.h".}
proc `$`*(self: Vector3): string {.inline.} =
  $self.toGodotString()

proc minAxis*(self: Vector3): cint {.
    importc: "godot_vector3_min_axis", header: "godot/vector3.h".}
proc maxAxis*(self: Vector3): cint {.
    importc: "godot_vector3_max_axis", header: "godot/vector3.h".}
proc length*(self: Vector3): float32 {.
    importc: "godot_vector3_length", header: "godot/vector3.h".}
proc lengthSquared*(self: Vector3): float32 {.
    importc: "godot_vector3_length_squared", header: "godot/vector3.h".}
proc isNormalized*(self: Vector3): bool {.
    importc: "godot_vector3_is_normalized", header: "godot/vector3.h".}
proc normalized*(self: Vector3): Vector3 {.
    importc: "godot_vector3_normalized", header: "godot/vector3.h".}
proc inverse*(self: Vector3): Vector3 {.
    importc: "godot_vector3_inverse", header: "godot/vector3.h".}
proc snapped*(self: Vector3; by: float32): Vector3 {.
    importc: "godot_vector3_snapped", header: "godot/vector3.h".}
proc rotated*(self: Vector3; axis: Vector3;
              phi: float32): Vector3 {.
    importc: "godot_vector3_rotated", header: "godot/vector3.h".}
proc lerp*(self: Vector3; b: Vector3; t: float32): Vector3 {.
    importc: "godot_vector3_linear_interpolate", header: "godot/vector3.h".}
proc cubicInterpolate*(self, b, preA, postB: Vector3;
                       t: float32): Vector3 {.
    importc: "godot_vector3_cubic_interpolate", header: "godot/vector3.h".}
proc dot*(a, b: Vector3): float32 {.
    importc: "godot_vector3_dot", header: "godot/vector3.h".}
proc cross*(a, b: Vector3): Vector3 {.
    importc: "godot_vector3_cross", header: "godot/vector3.h".}
proc outer*(a, b: Vector3): Basis {.
    importc: "godot_vector3_outer", header: "godot/vector3.h".}
proc toDiagonalMatrix*(self: Vector3): Basis {.
    importc: "godot_vector3_to_diagonal_matrix", header: "godot/vector3.h".}
proc abs*(self: Vector3): Vector3 {.
    importc: "godot_vector3_abs", header: "godot/vector3.h".}
proc floor*(self: Vector3): Vector3 {.
    importc: "godot_vector3_floor", header: "godot/vector3.h".}
proc ceil*(self: Vector3): Vector3 {.
    importc: "godot_vector3_ceil", header: "godot/vector3.h".}
proc distanceTo*(a, b: Vector3): float32 {.
    importc: "godot_vector3_distance_to", header: "godot/vector3.h".}
proc distanceSquaredTo*(a, b: Vector3): float32 {.
    importc: "godot_vector3_distance_squared_to", header: "godot/vector3.h".}
proc angleTo*(self, to: Vector3): float32 {.
    importc: "godot_vector3_angle_to", header: "godot/vector3.h".}
proc slide*(self, n: Vector3): Vector3 {.
    importc: "godot_vector3_slide", header: "godot/vector3.h".}
proc bounce*(self, n: Vector3): Vector3 {.
    importc: "godot_vector3_bounce", header: "godot/vector3.h".}
proc reflect*(self, b: Vector3): Vector3 {.
    importc: "godot_vector3_reflect", header: "godot/vector3.h".}

proc `+`*(a, b: Vector3): Vector3 {.
    importc: "godot_vector3_operator_add", header: "godot/vector3.h".}
proc `+=`*(a: var Vector3, b: Vector3) {.inline.} =
  a = a + b

proc `-`*(a, b: Vector3): Vector3 {.
    importc: "godot_vector3_operator_substract", header: "godot/vector3.h".}
proc `-=`*(a: var Vector3, b: Vector3) {.inline.} =
  a = a - b

proc `*`*(a, b: Vector3): Vector3 {.
    importc: "godot_vector3_operator_multiply_vector",
    header: "godot/vector3.h".}
proc `*=`*(a: var Vector3, b: Vector3) {.inline.}=
  a = a * b

proc `*`*(self: Vector3; b: float32): Vector3 {.
    importc: "godot_vector3_operator_multiply_scalar",
    header: "godot/vector3.h".}
proc `*=`*(a: var Vector3; b: float32) {.inline.} =
  a = a * b

proc `/`*(a, b: Vector3): Vector3 {.
    importc: "godot_vector3_operator_divide_vector",
    header: "godot/vector3.h".}
proc `/=`*(a: var Vector3; b: Vector3) {.inline.} =
  a = a / b

proc `/`*(self: Vector3; b: float32): Vector3 {.
    importc: "godot_vector3_operator_divide_scalar",
    header: "godot/vector3.h".}
proc `/=`*(a: var Vector3; b: float32) {.inline.} =
  a = a / b

proc `==`*(a, b: Vector3): bool {.
    importc: "godot_vector3_operator_equal", header: "godot/vector3.h".}
proc `<`*(a, b: Vector3): bool {.
    importc: "godot_vector3_operator_less", header: "godot/vector3.h".}
proc `-`*(self: Vector3): Vector3 {.
    importc: "godot_vector3_operator_neg", header: "godot/vector3.h".}

proc setAxis(self: var Vector3; axis: Vector3Axis;
             val: float32) {.
    importc: "godot_vector3_set_axis", header: "godot/vector3.h".}
proc getAxis(self: Vector3; axis: Vector3Axis): float32 {.
    importc: "godot_vector3_get_axis", header: "godot/vector3.h".}

proc `[]`(self: Vector3, idx: range[0..2]): float32 {.inline.} =
  self.getAxis(Vector3Axis(idx))

proc `[]=`(self: var Vector3, idx: range[0..2],
           val: float32): float32 {.inline.} =
  self.setAxis(Vector3Axis(idx), val)

proc x*(self: Vector3): float32 {.inline.} =
  self.getAxis(Vector3Axis.X)

proc `x=`*(self: var Vector3, val: float32) {.inline.} =
  self.setAxis(Vector3Axis.X, val)

proc y*(self: Vector3): float32 {.inline.} =
  self.getAxis(Vector3Axis.Y)

proc `y=`*(self: var Vector3, val: float32) {.inline.} =
  self.setAxis(Vector3Axis.Y, val)

proc z*(self: Vector3): float32 {.inline.} =
  self.getAxis(Vector3Axis.Z)

proc `z=`*(self: var Vector3, val: float32) {.inline.} =
  self.setAxis(Vector3Axis.Z, val)
