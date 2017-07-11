# Copyright (c) 2017 Xored Software, Inc.

type
  Vector2* {.importc: "godot_vector2", header: "godot_vector2.h",
             byref.} = object

import godotbase, strings

proc initVector2(dest: var Vector2; x, y: float32) {.
    importc: "godot_vector2_new", header: "godot_vector2.h".}

proc vec2*(x, y: float32): Vector2 {.inline.} =
  initVector2(result, x, y)

proc toGodotString*(self: Vector2): GodotString {.
    importc: "godot_vector2_as_string", header: "godot_vector2.h".}
proc `$`*(self: Vector2): string {.inline.} =
  $self.toGodotString()

proc normalized*(self: Vector2): Vector2 {.
    importc: "godot_vector2_normalized", header: "godot_vector2.h".}
proc length*(self: Vector2): float32 {.
    importc: "godot_vector2_length", header: "godot_vector2.h".}
proc angle*(self: Vector2): float32 {.
    importc: "godot_vector2_angle", header: "godot_vector2.h".}
proc lengthSquared*(self: Vector2): float32 {.
    importc: "godot_vector2_length_squared", header: "godot_vector2.h".}
proc isNormalized*(self: Vector2): bool {.
    importc: "godot_vector2_is_normalized", header: "godot_vector2.h".}
proc distanceTo*(self, to: Vector2): float32 {.
    importc: "godot_vector2_distance_to",
    header: "godot_vector2.h".}
proc distanceSquaredTo*(self, to: Vector2): float32 {.
    importc: "godot_vector2_distance_squared_to",
    header: "godot_vector2.h".}
proc angleTo*(self, to: Vector2): float32 {.
    importc: "godot_vector2_angle_to", header: "godot_vector2.h".}
proc angleToPoint*(self, to: Vector2): float32 {.
    importc: "godot_vector2_angle_to_point",
    header: "godot_vector2.h".}
proc lerp*(self, b: Vector2; t: float32): Vector2 {.
    importc: "godot_vector2_linear_interpolate",
    header: "godot_vector2.h".}
proc cubicInterpolate*(self, b, pre_a, post_b: Vector2; t: float32): Vector2 {.
    importc: "godot_vector2_cubic_interpolate",
    header: "godot_vector2.h".}
proc rotated*(self: Vector2; phi: float32): Vector2 {.
    importc: "godot_vector2_rotated", header: "godot_vector2.h".}
proc tangent*(self: Vector2): Vector2 {.
    importc: "godot_vector2_tangent", header: "godot_vector2.h".}
proc floor*(self: Vector2): Vector2 {.
    importc: "godot_vector2_floor", header: "godot_vector2.h".}
proc snapped*(self: Vector2; by: Vector2): Vector2 {.
    importc: "godot_vector2_snapped", header: "godot_vector2.h".}
proc aspect*(self: Vector2): float32 {.
    importc: "godot_vector2_aspect", header: "godot_vector2.h".}
proc dot*(a, b: Vector2): float32 {.
    importc: "godot_vector2_dot", header: "godot_vector2.h".}
proc slide*(self, n: Vector2): Vector2 {.
    importc: "godot_vector2_slide", header: "godot_vector2.h".}
proc bounce*(self, n: Vector2): Vector2 {.
    importc: "godot_vector2_bounce", header: "godot_vector2.h".}
proc reflect*(self, n: Vector2): Vector2 {.
    importc: "godot_vector2_reflect", header: "godot_vector2.h".}
proc abs*(self: Vector2): Vector2 {.
    importc: "godot_vector2_abs", header: "godot_vector2.h".}
proc clamped*(self: Vector2; length: float32): Vector2 {.
    importc: "godot_vector2_clamped", header: "godot_vector2.h".}

proc `+`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_add", header: "godot_vector2.h".}
proc `+=`*(a: var Vector2, b: Vector2) {.inline.} =
  a += b

proc `-`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_substract", header: "godot_vector2.h".}
proc `-=`*(a: var Vector2, b: Vector2) {.inline.} =
  a = a - b

proc `*`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_multiply_vector",
    header: "godot_vector2.h".}

proc `*=`*(a: var Vector2, b: Vector2) {.inline.} =
  a = a * b

proc `*`*(self: Vector2, scalar: float32): Vector2 {.
    importc: "godot_vector2_operator_multiply_scalar",
    header: "godot_vector2.h".}
proc `*=`*(self: var Vector2, scalar: float32) {.inline.} =
  self = self * scalar

proc `/`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_divide_vector", header: "godot_vector2.h".}
proc `/=`*(a: var Vector2, b: Vector2) {.inline.} =
  a = a / b

proc `/`*(self: Vector2; scalar: float32): Vector2 {.
    importc: "godot_vector2_operator_divide_scalar", header: "godot_vector2.h".}
proc `/=`*(self: var Vector2; scalar: float32) {.inline.} =
  self = self / scalar

proc `==`*(a, b: Vector2): bool {.
    importc: "godot_vector2_operator_equal", header: "godot_vector2.h".}
proc `<`*(a, b: Vector2): bool {.
    importc: "godot_vector2_operator_less", header: "godot_vector2.h".}
proc `-`*(self: Vector2): Vector2 {.
    importc: "godot_vector2_operator_neg", header: "godot_vector2.h".}

proc `x=`*(self: var Vector2; x: float32) {.
    importc: "godot_vector2_set_x", header: "godot_vector2.h".}
proc `y=`*(self: var Vector2; y: float32) {.
    importc: "godot_vector2_set_y", header: "godot_vector2.h".}
proc x*(self: Vector2): float32 {.
    importc: "godot_vector2_get_x", header: "godot_vector2.h".}
proc y*(self: Vector2): float32 {.
    importc: "godot_vector2_get_y", header: "godot_vector2.h".}
