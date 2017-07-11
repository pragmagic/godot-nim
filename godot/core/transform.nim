# Copyright (c) 2017 Xored Software, Inc.

type
  Transform* {.importc: "godot_transform", header: "godot_transform.h",
               byref.} = object

import godotbase, basis, variant, vector3, strings, plane, rect3

proc initTransform(dest: var Transform) {.
    importc: "godot_transform_new_identity", header: "godot_transform.h".}
  ## Initializes the ``dest`` as identity transform.
proc initTransform(dest: var Transform;
                   xAxis, yAxis, zAxis, origin: Vector3) {.
    importc: "godot_transform_new_with_axis_origin",
    header: "godot_transform.h".}
proc initTransform(dest: var Transform; basis: Basis;
                   origin: Vector3) {.
    importc: "godot_transform_new",
    header: "godot_transform.h".}

proc initTransform*(): Transform {.inline.} =
  initTransform(result)

proc initTransform*(xAxis, yAxis, zAxis,
                    origin: Vector3): Transform {.inline.} =
  initTransform(result, xAxis, yAxis, zAxis, origin)

proc initTransform*(basis: Basis, origin: Vector3): Transform {.inline.} =
  initTransform(result, basis, origin)

proc basis*(self: Transform): Basis {.
    importc: "godot_transform_get_basis", header: "godot_transform.h".}
proc `basis=`*(self: var Transform; v: Basis) {.
    importc: "godot_transform_set_basis", header: "godot_transform.h".}
proc origin*(self: Transform): Vector3 {.
    importc: "godot_transform_get_origin", header: "godot_transform.h".}
proc `origin=`*(self: var Transform; v: Vector3) {.
    importc: "godot_transform_set_origin", header: "godot_transform.h".}

proc toGodotString*(self: Transform): GodotString {.
    importc: "godot_transform_as_string", header: "godot_transform.h".}
proc `$`*(self: Transform): string {.inline.} =
  $self.toGodotString()

proc inverse*(self: Transform): Transform {.
    importc: "godot_transform_inverse", header: "godot_transform.h".}
proc affineInverse*(self: Transform): Transform {.
    importc: "godot_transform_affine_inverse",
    header: "godot_transform.h".}
proc orthonormalized*(self: Transform): Transform {.
    importc: "godot_transform_orthonormalized",
    header: "godot_transform.h".}
proc rotated*(self: Transform; axis: Vector3;
              phi: float32): Transform {.
    importc: "godot_transform_rotated", header: "godot_transform.h".}
proc scaled*(self: Transform; scale: Vector3): Transform {.
    importc: "godot_transform_scaled", header: "godot_transform.h".}
proc translated*(self: Transform; offset: Vector3): Transform {.
    importc: "godot_transform_translated", header: "godot_transform.h".}
proc lookingAt*(self: Transform;
                target, up: Vector3): Transform {.
    importc: "godot_transform_looking_at", header: "godot_transform.h".}

proc xformPlane*(self: Transform; v: Plane): Plane {.
    importc: "godot_transform_xform_plane", header: "godot_transform.h".}
proc xformInvPlane*(self: Transform; v: Plane): Plane {.
    importc: "godot_transform_xform_inv_plane", header: "godot_transform.h".}
proc xformVector3*(self: Transform; v: Vector3): Vector3 {.
    importc: "godot_transform_xform_vector3", header: "godot_transform.h".}
proc xformInvVector3*(self: Transform; v: Vector3): Vector3 {.
    importc: "godot_transform_xform_inv_vector3", header: "godot_transform.h".}
proc xformRect3*(self: Transform; v: Vector3): Rect3 {.
    importc: "godot_transform_xform_rect3", header: "godot_transform.h".}
proc xformInvRect3*(self: Transform; v: Vector3): Vector3 {.
    importc: "godot_transform_xform_inv_rect3", header: "godot_transform.h".}

proc `==`*(self: Transform; b: Transform): bool {.
    importc: "godot_transform_operator_equal", header: "godot_transform.h".}
proc `*`*(a, b: Transform): Transform {.
    importc: "godot_transform_operator_multiply", header: "godot_transform.h".}
proc `*=`*(a: var Transform, b: Transform) {.inline.} =
  a = a * b
