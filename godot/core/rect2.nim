# Copyright (c) 2018 Xored Software, Inc.

import hashes

import vector2
import internal/godotinternaltypes, internal/godotstrings
import godotcoretypes, gdnativeapi

{.push stackTrace: off.}

proc initRect2*(): Rect2 {.inline, noinit.} =
  Rect2()

proc initRect2*(pos, size: Vector2): Rect2 {.inline, noinit.} =
  Rect2(position: pos, size: size)

proc initRect2*(x, y, sizeX, sizeY: float32): Rect2 {.inline, noinit.} =
  Rect2(position: vec2(x, y), size: vec2(sizeX, sizeY))

proc `$`*(self: Rect2): string {.inline, noinit.} =
  $getGDNativeAPI().rect2AsString(self)

proc hash*(self: Rect2): Hash {.inline, noinit.} =
  !$(self.position.hash() !& self.size.hash())

proc area*(self: Rect2): float32 {.inline, noinit.} =
  self.size.x * self.size.y

proc intersects*(a, b: Rect2): bool {.inline, noinit.} =
  if a.position.x >= (b.position.x + b.size.x):
    return false
  if a.position.x + a.size.x <= b.position.x:
    return false
  if a.position.y >= (b.position.y + b.size.y):
    return false
  if a.position.y + a.size.y <= b.position.y:
    return false
  result = true

proc distanceTo*(self: Rect2, p: Vector2): float32 {.noinit.} =
  var inside = true
  if p.x < self.position.x:
    let d = self.position.x - p.x
    result = d
    inside = false
  if p.y < self.position.y:
    let d = self.position.y - p.y
    result = if inside: d else: min(result, d)
    inside = false
  if p.x >= (self.position.x + self.size.x):
    let d = p.x - (self.position.x + self.size.x)
    result = if inside: d else: min(result, d)
    inside = false
  if p.y >= (self.position.y + self.size.y):
    let d = p.y - (self.position.y + self.size.y)
    result = if inside: d else: min(result, d)
    inside = false

  if inside:
    result = 0'f32

proc encloses*(a, b: Rect2): bool {.inline, noinit.} =
  b.position.x >= a.position.x and b.position.y >= a.position.y and
    (b.position.x + b.size.x) < (a.position.x + a.size.x) and
    (b.position.y + b.size.y) < (a.position.y + a.size.y)

proc hasNoArea*(self: Rect2): bool {.inline, noinit.} =
  self.size.x <= 0 or self.size.y <= 0

proc clip*(self, b: Rect2): Rect2 {.inline, noinit.} =
  if not self.intersects(b):
    return initRect2()

  result = self

  result.position.x = max(b.position.x, self.position.x)
  result.position.y = max(b.position.y, self.position.y)

  let bEnd = b.position + b.size
  let selfEnd = self.position + self.size

  result.size.x = min(bEnd.x, selfEnd.x) - result.position.x
  result.size.y = min(bEnd.y, selfEnd.y) - result.position.y

proc merge*(self, b: Rect2): Rect2 {.inline, noinit.} =
  result.position.x = min(b.position.x, self.position.x)
  result.position.y = min(b.position.y, self.position.y)

  result.size.x = max(b.position.x + b.size.x, self.position.x + self.size.x)
  result.size.y = max(b.position.y + b.size.y, self.position.y + self.size.y)
  result.size -= result.position

proc contains*(self: Rect2; point: Vector2): bool {.inline, noinit.} =
  if point.x < self.position.x:
    return false
  if point.y < self.position.y:
    return false

  if point.x >= self.position.x + self.size.x:
    return false
  if point.y >= self.position.y + self.size.y:
    return false

  result = true

proc grow*(self: Rect2; by: float32): Rect2 {.inline, noinit.} =
  ## Returns Rect2 enlarged by the specified size in every direction.
  result = self

  result.position.x -= by
  result.position.y -= by

  result.size.x += by * 2
  result.size.y += by * 2

proc growIndividual*(self: Rect2, left, top: float32,
                     right, bottom: float32): Rect2 {.inline, noinit.} =
  result = self
  result.position.x -= left
  result.position.y -= top
  result.size.x += left + right
  result.size.y += top + bottom

proc expandTo*(self: var Rect2, to: Vector2) {.inline.} =
  var startPoint = self.position
  var endPoint = self.position + self.size

  if to.x < startPoint.x:
    startPoint.x = to.x
  if to.y < startPoint.y:
    startPoint.y = to.y

  if to.x > endPoint.x:
    endPoint.x = to.x
  if to.y > endPoint.y:
    endPoint.y = to.y

  self.position = startPoint
  self.size = endPoint - startPoint

proc expand*(self: Rect2; to: Vector2): Rect2 {.inline, noinit.} =
  result = self
  result.expandTo(to)

proc abs*(self: Rect2): Rect2 {.inline, noinit.} =
  Rect2(position: vec2(self.position.x + min(self.size.x, 0'f32),
                       self.position.y + min(self.size.y, 0'f32)),
        size: abs(self.size))

proc `==`*(a, b: Rect2): bool {.inline, noinit.} =
  a.position == b.position and a.size == b.size

{.pop.} # stackTrace: off