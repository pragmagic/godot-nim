# Copyright (c) 2018 Xored Software, Inc.

import hashes

import vector3
import internal/godotinternaltypes, internal/godotstrings
import godotcoretypes, gdnativeapi

proc initAABB*(pos, size: Vector3): AABB {.inline.} =
  AABB(position: pos, size: size)

proc `$`*(self: AABB): string {.inline.} =
  $getGDNativeAPI().aabbAsString(self)

proc hash*(self: AABB): Hash {.inline.} =
  !$(self.position.hash() !& self.size.hash())

proc area*(self: AABB): float32 {.inline.} =
  getGDNativeAPI().aabbGetArea(self)

proc hasNoArea*(self: AABB): bool {.inline.} =
  getGDNativeAPI().aabbHasNoArea(self)

proc hasNoSurface*(self: AABB): bool {.inline.} =
  getGDNativeAPI().aabbHasNoSurface(self)

proc intersects*(self, other: AABB): bool {.inline.} =
  getGDNativeAPI().aabbIntersects(self, other)

proc encloses*(self, other: AABB): bool {.inline.} =
  getGDNativeAPI().aabbEncloses(self, other)

proc merge*(self, other: AABB): AABB {.inline.} =
  getGDNativeAPI().aabbMerge(self, other).toAABB()

proc intersection*(self, other: AABB): AABB {.inline.} =
  getGDNativeAPI().aabbIntersection(self, other).toAABB()

proc intersectsPlane*(self: AABB; plane: Plane): bool {.inline.} =
  getGDNativeAPI().aabbIntersectsPlane(self, plane)

proc intersectsSegment*(self: AABB; start, to: Vector3): bool {.inline.} =
  getGDNativeAPI().aabbIntersectsSegment(self, start, to)

proc contains*(self: AABB; point: Vector3): bool {.inline.} =
  getGDNativeAPI().aabbHasPoint(self, point)

proc getSupport*(self: AABB; dir: Vector3): Vector3 {.inline.} =
  getGDNativeAPI().aabbGetSupport(self, dir).toVector3()

proc getLongestAxis*(self: AABB): Vector3 {.inline.} =
  getGDNativeAPI().aabbGetLongestAxis(self).toVector3()

proc getLongestAxisIndex*(self: AABB): cint {.inline.} =
  getGDNativeAPI().aabbGetLongestAxisIndex(self)

proc getLongestAxisSize*(self: AABB): float32 {.inline.} =
  getGDNativeAPI().aabbGetLongestAxisSize(self)

proc getShortestAxis*(self: AABB): Vector3 {.inline.} =
  getGDNativeAPI().aabbGetShortestAxis(self).toVector3()

proc getShortestAxisIndex*(self: AABB): cint {.inline.} =
  getGDNativeAPI().aabbGetShortestAxisIndex(self)

proc getShortestAxisSize*(self: AABB): float32 {.inline.} =
  getGDNativeAPI().aabbGetShortestAxisSize(self)

proc expand*(self: AABB; toPoint: Vector3): AABB {.inline.} =
  getGDNativeAPI().aabbExpand(self, toPoint).toAABB()

proc grow*(self: AABB; by: float32): AABB {.inline.} =
  getGDNativeAPI().aabbGrow(self, by).toAABB()

proc getEndpoint*(self: AABB; idx: cint): Vector3 {.inline.} =
  getGDNativeAPI().aabbGetEndpoint(self, idx).toVector3()

proc `==`*(a, b: AABB): bool {.inline.} =
  getGDNativeAPI().aabbOperatorEqual(a, b)
