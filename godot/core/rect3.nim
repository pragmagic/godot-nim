# Copyright (c) 2017 Xored Software, Inc.

import internal.godotinternaltypes, internal.godotstrings
import godotcoretypes, gdnativeapi

proc initRect3*(pos, size: Vector3): Rect3 {.inline.} =
  Rect3(position: pos, size: size)

proc `$`*(self: Rect3): string {.inline.} =
  $getGDNativeAPI().rect3AsString(self)

proc area*(self: Rect3): float32 {.inline.} =
  getGDNativeAPI().rect3GetArea(self)

proc hasNoArea*(self: Rect3): bool {.inline.} =
  getGDNativeAPI().rect3HasNoArea(self)

proc hasNoSurface*(self: Rect3): bool {.inline.} =
  getGDNativeAPI().rect3HasNoSurface(self)

proc intersects*(self, other: Rect3): bool {.inline.} =
  getGDNativeAPI().rect3Intersects(self, other)

proc encloses*(self, other: Rect3): bool {.inline.} =
  getGDNativeAPI().rect3Encloses(self, other)

proc merge*(self, other: Rect3): Rect3 {.inline.} =
  getGDNativeAPI().rect3Merge(self, other)

proc intersection*(self, other: Rect3): Rect3 {.inline.} =
  getGDNativeAPI().rect3Intersection(self, other)

proc intersectsPlane*(self: Rect3; plane: Plane): bool {.inline.} =
  getGDNativeAPI().rect3IntersectsPlane(self, plane)

proc intersectsSegment*(self: Rect3; start, to: Vector3): bool {.inline.} =
  getGDNativeAPI().rect3IntersectsSegment(self, start, to)

proc contains*(self: Rect3; point: Vector3): bool {.inline.} =
  getGDNativeAPI().rect3HasPoint(self, point)

proc getSupport*(self: Rect3; dir: Vector3): Vector3 {.inline.} =
  getGDNativeAPI().rect3GetSupport(self, dir)

proc getLongestAxis*(self: Rect3): Vector3 {.inline.} =
  getGDNativeAPI().rect3GetLongestAxis(self)

proc getLongestAxisIndex*(self: Rect3): cint {.inline.} =
  getGDNativeAPI().rect3GetLongestAxisIndex(self)

proc getLongestAxisSize*(self: Rect3): float32 {.inline.} =
  getGDNativeAPI().rect3GetLongestAxisSize(self)

proc getShortestAxis*(self: Rect3): Vector3 {.inline.} =
  getGDNativeAPI().rect3GetShortestAxis(self)

proc getShortestAxisIndex*(self: Rect3): cint {.inline.} =
  getGDNativeAPI().rect3GetShortestAxisIndex(self)

proc getShortestAxisSize*(self: Rect3): float32 {.inline.} =
  getGDNativeAPI().rect3GetShortestAxisSize(self)

proc expand*(self: Rect3; toPoint: Vector3): Rect3 {.inline.} =
  getGDNativeAPI().rect3Expand(self, toPoint)

proc grow*(self: Rect3; by: float32): Rect3 {.inline.} =
  getGDNativeAPI().rect3Grow(self, by)

proc getEndpoint*(self: Rect3; idx: cint): Vector3 {.inline.} =
  getGDNativeAPI().rect3GetEndpoint(self, idx)

proc `==`*(a, b: Rect3): bool {.inline.} =
  getGDNativeAPI().rect3OperatorEqual(a, b)
