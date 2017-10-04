# Copyright (c) 2017 Xored Software, Inc.

import vector2
import godotcoretypes, internal.godotinternaltypes, gdnativeapi

proc initRect2*(pos, size: Vector2): Rect2 {.inline.} =
  Rect2(position: pos, size: size)

proc initRect2*(x, y, sizeX, sizeY: float32): Rect2 {.inline.} =
  Rect2(position: vec2(x, y), size: vec2(sizeX, sizeY))

proc `$`*(self: Rect2): string {.inline.} =
  $getGDNativeAPI().rect2AsString(self)

proc area*(self: Rect2): float32 {.inline.} =
  getGDNativeAPI().rect2GetArea(self)

proc intersects*(a, b: Rect2): bool {.inline.} =
  getGDNativeAPI().rect2Intersects(a, b)

proc encloses*(a, b: Rect2): bool {.inline.} =
  getGDNativeAPI().rect2Encloses(a, b)

proc hasNoArea*(self: Rect2): bool {.inline.} =
  getGDNativeAPI().rect2HasNoArea(self)

proc clip*(self, b: Rect2): Rect2 {.inline.} =
  getGDNativeAPI().rect2Clip(self, b)

proc merge*(self, b: Rect2): Rect2 {.inline.} =
  getGDNativeAPI().rect2Merge(self, b)

proc contains*(self: Rect2; point: Vector2): bool {.inline.} =
  getGDNativeAPI().rect2HasPoint(self, point)

proc grow*(self: Rect2; by: float32): Rect2 {.inline.} =
  getGDNativeAPI().rect2Grow(self, by)

proc expand*(self: Rect2; to: Vector2): Rect2 {.inline.} =
  getGDNativeAPI().rect2Expand(self, to)

proc `==`*(a, b: Rect2): bool {.inline.} =
  getGDNativeAPI().rect2OperatorEqual(a, b)
