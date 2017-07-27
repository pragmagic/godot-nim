# Copyright (c) 2017 Xored Software, Inc.

import godotbase, vector2, rect2

import "../internal/godotstrings.nim"

type
  Transform2D* {.byref.} = object
    elements*: array[3, Vector2]

proc initTransform2D(dest: var Transform2D) {.
    importc: "godot_transform2d_new_identity".}
proc initTransform2D(dest: var Transform2D; rot: float32; pos: Vector2) {.
    importc: "godot_transform2d_new".}
proc initTransform2D(dest: var Transform2D; xAxis, yAxis, origin: Vector2) {.
    importc: "godot_transform2d_new_axis_origin".}

proc initTransform2D*(): Transform2D {.inline.} =
  initTransform2D(result)

proc initTransform2D*(rot: float32; pos: Vector2): Transform2D {.inline.} =
  initTransform2D(result, rot, pos)

proc initTransform2D*(xAxis, yAxis, origin: Vector2): Transform2D {.inline.} =
  initTransform2D(result, xAxis, yAxis, origin)

proc toGodotString(self: Transform2D): GodotString {.
    importc: "godot_transform2d_as_string".}

proc `$`*(self: Transform2D): string {.inline.} =
  $self.toGodotString()

proc inverse*(self: Transform2D): Transform2D {.
    importc: "godot_transform2d_inverse".}
proc affineInverse*(self: Transform2D): Transform2D {.
    importc: "godot_transform2d_affine_inverse".}
proc rotation*(self: Transform2D): float32 {.
    importc: "godot_transform2d_get_rotation".}
proc origin*(self: Transform2D): Vector2 {.
    importc: "godot_transform2d_get_origin".}
proc scale*(self: Transform2D): Vector2 {.
    importc: "godot_transform2d_get_scale".}
proc orthonormalized*(self: Transform2D): Transform2D {.
    importc: "godot_transform2d_orthonormalized".}
proc rotated*(self: Transform2D; phi: float32): Transform2D {.
    importc: "godot_transform2d_rotated".}
proc scaled*(self: Transform2D; scale: Vector2): Transform2D {.
    importc: "godot_transform2d_scaled".}
proc translated*(self: Transform2D;
                 offset: Vector2): Transform2D {.
    importc: "godot_transform2d_translated".}
proc xformVector2*(self: Transform2D; v: Vector2): Vector2 {.
    importc: "godot_transform2d_xform_vector2".}
proc xformInvVector2*(self: Transform2D; v: Vector2): Vector2 {.
    importc: "godot_transform2d_xform_inv_vector2".}
proc basisXformVector2*(self: Transform2D;
                        v: Vector2): Vector2 {.
    importc: "godot_transform2d_basis_xform_vector2".}
proc basisXformInvVector2*(self: Transform2D;
                           v: Vector2): Vector2 {.
    importc: "godot_transform2d_basis_xform_inv_vector2".}
proc xformRect2*(self: Transform2D; v: Rect2): Rect2 {.
    importc: "godot_transform2d_xform_rect2".}
proc xformInvRect2*(self: Transform2D; v: Rect2): Rect2 {.
    importc: "godot_transform2d_xform_inv_rect2".}

proc interpolateWith*(self, m: Transform2D;
                      c: float32): Transform2D {.
    importc: "godot_transform2d_interpolate_with".}
proc `==`*(a, b: Transform2D): bool {.
    importc: "godot_transform2d_operator_equal".}
proc `*`*(a, b: Transform2D): Transform2D {.
    importc: "godot_transform2d_operator_multiply".}

proc `*=`*(a: var Transform2D, b: Transform2D) {.inline.} =
  a = a * b
