# Copyright (c) 2017 Xored Software, Inc.

import godotbase, vector3, strings

type
  Quat* {.byref.} = object
    x*: float32
    y*: float32
    z*: float32
    w*: float32

proc initQuat(dest: var Quat; x, y, z, w: float32) {.
    importc: "godot_quat_new".}
proc initQuat(dest: var Quat; axis: Vector3; angle: float32) {.
    importc: "godot_quat_new_with_axis_angle".}

proc initQuat*(x, y, z, w: float32): Quat {.inline.} =
  initQuat(result, x, y, z, w)

proc initQuat*(axis: Vector3; angle: float32): Quat {.inline.} =
  initQuat(result, axis, angle)

proc x*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_x".}
proc `x=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_x".}
proc y*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_y".}
proc `y=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_y".}
proc z*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_z".}
proc `z=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_z".}
proc w*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_w".}
proc `w=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_w".}

proc toGodotString*(self: Quat): GodotString {.
    noSideEffect,
    importc: "godot_quat_as_string".}
proc `$`*(self: Quat): string {.inline.} =
  $self.toGodotString()

proc length*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_length".}
proc lengthSquared*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_length_squared".}
proc normalized*(self: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_normalized".}
proc isNormalized*(self: Quat): bool {.
    noSideEffect,
    importc: "godot_quat_is_normalized".}
proc inverse*(self: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_inverse".}
proc dot*(a, b: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_dot".}
proc xform*(self: Quat; v: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_quat_xform".}
proc slerp*(self: Quat; b: Quat; t: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_slerp".}
proc slerpni*(self: Quat; b: Quat; t: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_slerpni".}
proc cubicSlerp*(self, b, pre_a, post_b: Quat;
                 t: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_cubic_slerp".}
proc `*`*(a: Quat, b: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_multiply".}
proc `*=`*(a: var Quat, b: float32) {.inline.} =
  a = a * b

proc `+`*(a, b: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_add".}
proc `+=`*(a: var Quat, b: Quat) {.inline.} =
  a = a + b

proc `-`*(a, b: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_substract".}
proc `-=`* (a: var Quat, b: Quat) {.inline.} =
  a = a - b

proc `/`*(self: Quat; b: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_divide".}
proc `/=`*(self: var Quat, b: float32) {.inline.} =
  self = self / b

proc `==`*(a, b: Quat): bool {.
    noSideEffect,
    importc: "godot_quat_operator_equal".}
proc `-`*(self: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_neg".}
