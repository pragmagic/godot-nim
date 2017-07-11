# Copyright (c) 2017 Xored Software, Inc.

type
  Transform2D* {.importc: "godot_transform2d", header: "godot_transform2d.h",
                 byref.} = object

import godotbase, strings, variant, vector2, rect2

proc initTransform2D(dest: var Transform2D) {.
    importc: "godot_transform2d_new_identity", header: "godot_transform2d.h".}
proc initTransform2D(dest: var Transform2D; rot: float32; pos: Vector2) {.
    importc: "godot_transform2d_new", header: "godot_transform2d.h".}
proc initTransform2D(dest: var Transform2D; xAxis, yAxis, origin: Vector2) {.
    importc: "godot_transform2d_new_axis_origin",
    header: "godot_transform2d.h".}

proc initTransform2D*(): Transform2D {.inline.} =
  initTransform2D(result)

proc initTransform2D*(rot: float32; pos: Vector2): Transform2D {.inline.} =
  initTransform2D(result, rot, pos)

proc initTransform2D*(xAxis, yAxis, origin: Vector2): Transform2D {.inline.} =
  initTransform2D(result, xAxis, yAxis, origin)

proc toGodotString*(self: Transform2D): GodotString {.
    importc: "godot_transform2d_as_string",
    header: "godot_transform2d.h".}
proc `$`*(self: Transform2D): string {.inline.} =
  $self.toGodotString()

proc inverse*(self: Transform2D): Transform2D {.
    importc: "godot_transform2d_inverse", header: "godot_transform2d.h".}
proc affineInverse*(self: Transform2D): Transform2D {.
    importc: "godot_transform2d_affine_inverse",
    header: "godot_transform2d.h".}
proc rotation*(self: Transform2D): float32 {.
    importc: "godot_transform2d_get_rotation",
    header: "godot_transform2d.h".}
proc origin*(self: Transform2D): Vector2 {.
    importc: "godot_transform2d_get_origin",
    header: "godot_transform2d.h".}
proc scale*(self: Transform2D): Vector2 {.
    importc: "godot_transform2d_get_scale",
    header: "godot_transform2d.h".}
proc orthonormalized*(self: Transform2D): Transform2D {.
    importc: "godot_transform2d_orthonormalized",
    header: "godot_transform2d.h".}
proc rotated*(self: Transform2D; phi: float32): Transform2D {.
    importc: "godot_transform2d_rotated",
    header: "godot_transform2d.h".}
proc scaled*(self: Transform2D; scale: Vector2): Transform2D {.
    importc: "godot_transform2d_scaled",
    header: "godot_transform2d.h".}
proc translated*(self: Transform2D;
                 offset: Vector2): Transform2D {.
    importc: "godot_transform2d_translated",
    header: "godot_transform2d.h".}
proc xformVector2*(self: Transform2D; v: Vector2): Vector2 {.
    importc: "godot_transform2d_xform_vector2",
    header: "godot_transform2d.h".}
proc xformInvVector2*(self: Transform2D; v: Vector2): Vector2 {.
    importc: "godot_transform2d_xform_inv_vector2",
    header: "godot_transform2d.h".}
proc basisXformVector2*(self: Transform2D;
                        v: Vector2): Vector2 {.
    importc: "godot_transform2d_basis_xform_vector2",
    header: "godot_transform2d.h".}
proc basisXformInvVector2*(self: Transform2D;
                           v: Vector2): Vector2 {.
    importc: "godot_transform2d_basis_xform_inv_vector2",
    header: "godot_transform2d.h".}
proc xformRect2*(self: Transform2D; v: Rect2): Rect2 {.
    importc: "godot_transform2d_xform_rect2", header: "godot_transform2d.h".}
proc xformInvRect2*(self: Transform2D; v: Rect2): Rect2 {.
    importc: "godot_transform2d_xform_inv_rect2",
    header: "godot_transform2d.h".}

proc interpolateWith*(self, m: Transform2D;
                      c: float32): Transform2D {.
    importc: "godot_transform2d_interpolate_with",
    header: "godot_transform2d.h".}
proc `==`*(a, b: Transform2D): bool {.
    importc: "godot_transform2d_operator_equal",
    header: "godot_transform2d.h".}
proc `*`*(a, b: Transform2D): Transform2D {.
    importc: "godot_transform2d_operator_multiply",
    header: "godot_transform2d.h".}

proc `*=`*(a: var Transform2D, b: Transform2D) {.inline.} =
  a = a * b

