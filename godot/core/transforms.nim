# Copyright (c) 2018 Xored Software, Inc.

import hashes

import internal/godotinternaltypes, internal/godotstrings
import godotcoretypes, gdnativeapi
import basis, vector3

proc initTransform*(): Transform {.inline.} =
  result.basis = initBasis()

proc initTransform*(xAxis, yAxis, zAxis,
                    origin: Vector3): Transform {.inline.} =
  var basis: Basis
  basis.setAxis(0, xAxis)
  basis.setAxis(1, yAxis)
  basis.setAxis(2, zAxis)
  Transform(basis: basis, origin: origin)

proc initTransform*(basis: Basis, origin: Vector3): Transform {.inline.} =
  Transform(basis: basis, origin: origin)

proc `$`*(self: Transform): string {.inline.} =
  $getGDNativeAPI().transformAsString(self)

proc hash*(self: Transform): Hash {.inline.} =
  !$(self.basis.hash() !& self.origin.hash())

proc inverse*(self: Transform): Transform {.inline.} =
  getGDNativeAPI().transformInverse(self).toTransform()

proc affineInverse*(self: Transform): Transform {.inline.} =
  getGDNativeAPI().transformAffineInverse(self).toTransform()

proc orthonormalized*(self: Transform): Transform {.inline.} =
  getGDNativeAPI().transformOrthonormalized(self).toTransform()

proc rotated*(self: Transform; axis: Vector3;
              phi: float32): Transform {.inline.} =
  getGDNativeAPI().transformRotated(self, axis, phi).toTransform()

proc scaled*(self: Transform; scale: Vector3): Transform {.inline.} =
  getGDNativeAPI().transformScaled(self, scale).toTransform()

proc translated*(self: Transform; offset: Vector3): Transform {.inline.} =
  getGDNativeAPI().transformTranslated(self, offset).toTransform()

proc lookingAt*(self: Transform; target, up: Vector3): Transform {.inline.} =
  getGDNativeAPI().transformLookingAt(self, target, up).toTransform()

proc xformPlane*(self: Transform; plane: Plane): Plane {.inline.} =
  getGDNativeAPI().transformXformPlane(self, plane).toPlane()

proc xformInvPlane*(self: Transform; plane: Plane): Plane {.inline.} =
  getGDNativeAPI().transformXformInvPlane(self, plane).toPlane()

proc xformVector3*(self: Transform; v: Vector3): Vector3 {.inline.} =
  getGDNativeAPI().transformXformVector3(self, v).toVector3()

proc xformInvVector3*(self: Transform; v: Vector3): Vector3 {.inline.} =
  getGDNativeAPI().transformXformInvVector3(self, v).toVector3()

proc xformAABB*(self: Transform; rect: AABB): AABB {.inline.} =
  getGDNativeAPI().transformXformAABB(self, rect).toAABB()

proc xformInvAABB*(self: Transform; rect: AABB): AABB {.inline.} =
  getGDNativeAPI().transformXformInvAABB(self, rect).toAABB()

proc `==`*(self: Transform; b: Transform): bool {.inline.} =
  getGDNativeAPI().transformOperatorEqual(self, b)

proc `*`*(self, other: Transform): Transform {.inline.} =
  getGDNativeAPI().transformOperatorMultiply(self, other).toTransform()

proc `*=`*(self: var Transform, other: Transform) {.inline.} =
  self = self * other
