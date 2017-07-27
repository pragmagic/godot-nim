# Copyright (c) 2017 Xored Software, Inc.

import godotbase

import "../internal/godotstrings.nim"

type
  Vector2* {.byref.} = object
    x*: float32
    y*: float32

proc vec2*(x, y: float32): Vector2 {.inline.} =
  Vector2(x: x, y: y)

proc toGodotString(self: Vector2): GodotString {.
    importc: "godot_vector2_as_string".}

proc `$`*(self: Vector2): string {.inline.} =
  $self.toGodotString()

proc normalized*(self: Vector2): Vector2 {.
    importc: "godot_vector2_normalized".}
proc length*(self: Vector2): float32 {.
    importc: "godot_vector2_length".}
proc angle*(self: Vector2): float32 {.
    importc: "godot_vector2_angle".}
proc lengthSquared*(self: Vector2): float32 {.
    importc: "godot_vector2_length_squared".}
proc isNormalized*(self: Vector2): bool {.
    importc: "godot_vector2_is_normalized".}
proc distanceTo*(self, to: Vector2): float32 {.
    importc: "godot_vector2_distance_to".}
proc distanceSquaredTo*(self, to: Vector2): float32 {.
    importc: "godot_vector2_distance_squared_to".}
proc angleTo*(self, to: Vector2): float32 {.
    importc: "godot_vector2_angle_to".}
proc angleToPoint*(self, to: Vector2): float32 {.
    importc: "godot_vector2_angle_to_point".}
proc lerp*(self, b: Vector2; t: float32): Vector2 {.
    importc: "godot_vector2_linear_interpolate".}
proc cubicInterpolate*(self, b, pre_a, post_b: Vector2; t: float32): Vector2 {.
    importc: "godot_vector2_cubic_interpolate".}
proc rotated*(self: Vector2; phi: float32): Vector2 {.
    importc: "godot_vector2_rotated".}
proc tangent*(self: Vector2): Vector2 {.
    importc: "godot_vector2_tangent".}
proc floor*(self: Vector2): Vector2 {.
    importc: "godot_vector2_floor".}
proc snapped*(self: Vector2; by: Vector2): Vector2 {.
    importc: "godot_vector2_snapped".}
proc aspect*(self: Vector2): float32 {.
    importc: "godot_vector2_aspect".}
proc dot*(a, b: Vector2): float32 {.
    importc: "godot_vector2_dot".}
proc slide*(self, n: Vector2): Vector2 {.
    importc: "godot_vector2_slide".}
proc bounce*(self, n: Vector2): Vector2 {.
    importc: "godot_vector2_bounce".}
proc reflect*(self, n: Vector2): Vector2 {.
    importc: "godot_vector2_reflect".}
proc abs*(self: Vector2): Vector2 {.
    importc: "godot_vector2_abs".}
proc clamped*(self: Vector2; length: float32): Vector2 {.
    importc: "godot_vector2_clamped".}

proc `+`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_add".}
proc `+=`*(a: var Vector2, b: Vector2) {.inline.} =
  a += b

proc `-`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_substract".}
proc `-=`*(a: var Vector2, b: Vector2) {.inline.} =
  a = a - b

proc `*`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_multiply_vector".}

proc `*=`*(a: var Vector2, b: Vector2) {.inline.} =
  a = a * b

proc `*`*(self: Vector2, scalar: float32): Vector2 {.
    importc: "godot_vector2_operator_multiply_scalar".}
proc `*=`*(self: var Vector2, scalar: float32) {.inline.} =
  self = self * scalar

proc `/`*(a, b: Vector2): Vector2 {.
    importc: "godot_vector2_operator_divide_vector".}
proc `/=`*(a: var Vector2, b: Vector2) {.inline.} =
  a = a / b

proc `/`*(self: Vector2; scalar: float32): Vector2 {.
    importc: "godot_vector2_operator_divide_scalar".}
proc `/=`*(self: var Vector2; scalar: float32) {.inline.} =
  self = self / scalar

proc `==`*(a, b: Vector2): bool {.
    importc: "godot_vector2_operator_equal".}
proc `<`*(a, b: Vector2): bool {.
    importc: "godot_vector2_operator_less".}
proc `-`*(self: Vector2): Vector2 {.
    importc: "godot_vector2_operator_neg".}

proc `x=`*(self: var Vector2; x: float32) {.
    importc: "godot_vector2_set_x".}
proc `y=`*(self: var Vector2; y: float32) {.
    importc: "godot_vector2_set_y".}
proc x*(self: Vector2): float32 {.
    importc: "godot_vector2_get_x".}
proc y*(self: Vector2): float32 {.
    importc: "godot_vector2_get_y".}
