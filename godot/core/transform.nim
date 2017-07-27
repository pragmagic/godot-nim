# Copyright (c) 2017 Xored Software, Inc.

import godotbase, basis, vector3, strings, plane, rect3

type
  Transform* {.byref.} = object
    basis*: Basis
    origin*: Vector3

proc initTransform*(): Transform {.inline.} =
  discard

proc initTransform*(xAxis, yAxis, zAxis,
                    origin: Vector3): Transform {.inline.} =
  var basis: Basis
  basis.setAxis(0, xAxis)
  basis.setAxis(1, yAxis)
  basis.setAxis(2, zAxis)
  Transform(basis: basis, origin: origin)

proc initTransform*(basis: Basis, origin: Vector3): Transform {.inline.} =
  Transform(basis: basis, origin: origin)

proc toGodotString*(self: Transform): GodotString {.
    importc: "godot_transform_as_string".}
proc `$`*(self: Transform): string {.inline.} =
  $self.toGodotString()

proc inverse*(self: Transform): Transform {.
    importc: "godot_transform_inverse".}
proc affineInverse*(self: Transform): Transform {.
    importc: "godot_transform_affine_inverse".}
proc orthonormalized*(self: Transform): Transform {.
    importc: "godot_transform_orthonormalized".}
proc rotated*(self: Transform; axis: Vector3;
              phi: float32): Transform {.
    importc: "godot_transform_rotated".}
proc scaled*(self: Transform; scale: Vector3): Transform {.
    importc: "godot_transform_scaled".}
proc translated*(self: Transform; offset: Vector3): Transform {.
    importc: "godot_transform_translated".}
proc lookingAt*(self: Transform;
                target, up: Vector3): Transform {.
    importc: "godot_transform_looking_at".}

proc xformPlane*(self: Transform; v: Plane): Plane {.
    importc: "godot_transform_xform_plane".}
proc xformInvPlane*(self: Transform; v: Plane): Plane {.
    importc: "godot_transform_xform_inv_plane".}
proc xformVector3*(self: Transform; v: Vector3): Vector3 {.
    importc: "godot_transform_xform_vector3".}
proc xformInvVector3*(self: Transform; v: Vector3): Vector3 {.
    importc: "godot_transform_xform_inv_vector3".}
proc xformRect3*(self: Transform; v: Vector3): Rect3 {.
    importc: "godot_transform_xform_rect3".}
proc xformInvRect3*(self: Transform; v: Vector3): Vector3 {.
    importc: "godot_transform_xform_inv_rect3".}

proc `==`*(self: Transform; b: Transform): bool {.
    importc: "godot_transform_operator_equal".}
proc `*`*(a, b: Transform): Transform {.
    importc: "godot_transform_operator_multiply".}
proc `*=`*(a: var Transform, b: Transform) {.inline.} =
  a = a * b
