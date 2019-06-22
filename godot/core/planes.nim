# Copyright (c) 2018 Xored Software, Inc.

import hashes

import vector3

import internal/godotinternaltypes, internal/godotstrings
import godotcoretypes, gdnativeapi

proc initPlane*(a, b, c, d: float32): Plane {.inline.} =
  getGDNativeAPI().planeNewWithReals(result, a, b, c, d)

proc initPlane*(v1, v2, v3: Vector3): Plane {.inline.} =
  getGDNativeAPI().planeNewWithVectors(result, v1, v2, v3)

proc initPlane*(normal: Vector3; d: float32): Plane {.inline.} =
  result = Plane(
    normal: normal,
    d: d
  )

proc `$`*(self: Plane): string {.inline.} =
  $getGDNativeAPI().planeAsString(self)

proc hash*(self: Plane): Hash {.inline, noinit.} =
  !$(self.normal.hash() !& self.d.hash())

proc normalized*(self: Plane): Plane {.inline.} =
  getGDNativeAPI().planeNormalized(self).toPlane()

proc center*(self: Plane): Vector3 {.inline.} =
  getGDNativeAPI().planeCenter(self).toVector3()

proc getAnyPoint*(self: Plane): Vector3 {.inline.} =
  getGDNativeAPI().planeGetAnyPoint(self).toVector3()

proc isPointOver*(self: Plane; point: Vector3): bool {.inline.} =
  getGDNativeAPI().planeIsPointOver(self, point)

proc distanceTo*(self: Plane; point: Vector3): float32 {.inline.} =
  getGDNativeAPI().planeDistanceTo(self, point)

proc contains*(self: Plane; point: Vector3;
               epsilon: float32): bool {.inline.} =
  getGDNativeAPI().planeHasPoint(self, point, epsilon)

proc project*(self: Plane; point: Vector3): Vector3 {.inline.} =
  getGDNativeAPI().planeProject(self, point).toVector3()

proc intersect3*(self: Plane; dest: var Vector3;
                 b, c: Plane): bool {.inline.} =
  getGDNativeAPI().planeIntersect3(self, dest, b, c)

proc intersectsRay*(self: Plane; dest: var Vector3;
                    v, dir: Vector3): bool {.inline.} =
  getGDNativeAPI().planeIntersectsRay(self, dest, v, dir)

proc intersectsSegment*(self: Plane; dest: var Vector3;
                        segmentBegin, segmentEnd: Vector3): bool {.inline.} =
  getGDNativeAPI().planeIntersectsSegment(self, dest, segmentBegin, segmentEnd)

proc `-`*(self: Plane): Plane {.inline.} =
  getGDNativeAPI().planeOperatorNeg(self).toPlane()

proc `==`*(a, b: Plane): bool {.inline.} =
  getGDNativeAPI().planeOperatorEqual(a, b)
