# Copyright (c) 2017 Xored Software, Inc.

import godotbase, vector3, strings

type
  Quat* {.importc: "godot_quat", header: "godot_quat.h", byref.} = object

proc initQuat(dest: var Quat; x, y, z, w: float32) {.
    importc: "godot_quat_new", header: "godot_quat.h".}
proc initQuat(dest: var Quat; axis: Vector3; angle: float32) {.
    importc: "godot_quat_new_with_axis_angle",
    header: "godot_quat.h".}

proc initQuat*(x, y, z, w: float32): Quat {.inline.} =
  initQuat(result, x, y, z, w)

proc initQuat*(axis: Vector3; angle: float32): Quat {.inline.} =
  initQuat(result, axis, angle)

proc x*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_x", header: "godot_quat.h".}
proc `x=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_x", header: "godot_quat.h".}
proc y*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_y", header: "godot_quat.h".}
proc `y=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_y", header: "godot_quat.h".}
proc z*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_z", header: "godot_quat.h".}
proc `z=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_z", header: "godot_quat.h".}
proc w*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_get_w", header: "godot_quat.h".}
proc `w=`*(self: var Quat; val: float32) {.
    noSideEffect,
    importc: "godot_quat_set_w", header: "godot_quat.h".}

proc toGodotString*(self: Quat): GodotString {.
    noSideEffect,
    importc: "godot_quat_as_string", header: "godot_quat.h".}
proc `$`*(self: Quat): string {.inline.} =
  $self.toGodotString()

proc length*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_length", header: "godot_quat.h".}
proc lengthSquared*(self: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_length_squared", header: "godot_quat.h".}
proc normalized*(self: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_normalized", header: "godot_quat.h".}
proc isNormalized*(self: Quat): bool {.
    noSideEffect,
    importc: "godot_quat_is_normalized", header: "godot_quat.h".}
proc inverse*(self: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_inverse", header: "godot_quat.h".}
proc dot*(a, b: Quat): float32 {.
    noSideEffect,
    importc: "godot_quat_dot", header: "godot_quat.h".}
proc xform*(self: Quat; v: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_quat_xform", header: "godot_quat.h".}
proc slerp*(self: Quat; b: Quat; t: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_slerp", header: "godot_quat.h".}
proc slerpni*(self: Quat; b: Quat; t: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_slerpni", header: "godot_quat.h".}
proc cubicSlerp*(self, b, pre_a, post_b: Quat;
                 t: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_cubic_slerp",
    header: "godot_quat.h".}
proc `*`*(a: Quat, b: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_multiply",
    header: "godot_quat.h".}
proc `*=`*(a: var Quat, b: float32) {.inline.} =
  a = a * b

proc `+`*(a, b: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_add", header: "godot_quat.h".}
proc `+=`*(a: var Quat, b: Quat) {.inline.} =
  a = a + b

proc `-`*(a, b: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_substract",
    header: "godot_quat.h".}
proc `-=`* (a: var Quat, b: Quat) {.inline.} =
  a = a - b

proc `/`*(self: Quat; b: float32): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_divide", header: "godot_quat.h".}
proc `/=`*(self: var Quat, b: float32) {.inline.} =
  self = self / b

proc `==`*(a, b: Quat): bool {.
    noSideEffect,
    importc: "godot_quat_operator_equal", header: "godot_quat.h".}
proc `-`*(self: Quat): Quat {.
    noSideEffect,
    importc: "godot_quat_operator_neg", header: "godot_quat.h".}
