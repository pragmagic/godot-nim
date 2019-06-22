# Copyright (c) 2018 Xored Software, Inc.

import math, godotbase, hashes

import internal/godotinternaltypes, internal/godotstrings
import godotcoretypes, gdnativeapi

{.push stackTrace: off.}

proc vec2*(): Vector2 {.inline, noinit.} =
  Vector2()

proc vec2*(x, y: float32): Vector2 {.inline, noinit.} =
  Vector2(x: x, y: y)

proc `$`*(self: Vector2): string {.inline, noinit.} =
  $getGDNativeAPI().vector2AsString(self)

proc hash*(self: Vector2): Hash {.inline, noinit.} =
  !$(self.x.hash() !& self.y.hash())

proc `+`*(self, other: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: self.x + other.x, y: self.y + other.y)

proc `+=`*(self: var Vector2, other: Vector2) {.inline, noinit.} =
  self.x += other.x
  self.y += other.y

proc `-`*(self, other: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: self.x - other.x, y: self.y - other.y)

proc `-=`*(self: var Vector2, other: Vector2) {.inline, noinit.} =
  self.x -= other.x
  self.y -= other.y

proc `*`*(self, other: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: self.x * other.x, y: self.y * other.y)

proc `*=`*(self: var Vector2, other: Vector2) {.inline, noinit.} =
  self.x *= other.x
  self.y *= other.y

proc `*`*(self: Vector2, scalar: float32): Vector2 {.inline, noinit.} =
  Vector2(x: self.x * scalar, y: self.y * scalar)

proc `*`*(scalar: float32, v: Vector2): Vector2 {.inline, noinit.} =
  v * scalar

proc `*=`*(self: var Vector2, scalar: float32) {.inline, noinit.} =
  self.x *= scalar
  self.y *= scalar

proc `/`*(self, other: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: self.x / other.x, y: self.y / other.y)

proc `/=`*(self: var Vector2, other: Vector2) {.inline, noinit.} =
  self.x /= other.x
  self.y /= other.y

proc `/`*(self: Vector2; scalar: float32): Vector2 {.inline, noinit.} =
  Vector2(x: self.x / scalar, y: self.y / scalar)

proc `/=`*(self: var Vector2; scalar: float32) {.inline, noinit.} =
  self = self / scalar

proc `==`*(self, other: Vector2): bool {.inline, noinit.} =
  self.x == other.x and self.y == other.y

proc `<`*(self, other: Vector2): bool {.inline, noinit.} =
  if self.x == other.x:
    self.y < other.y
  else:
    self.x < other.x

proc `>`*(self, other: Vector2): bool {.inline, noinit.} =
  if self.x == other.x:
    self.y > other.y
  else:
    self.x > other.x

proc `-`*(self: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: -self.x, y: -self.y)

proc length*(self: Vector2): float32 {.inline, noinit.} =
  sqrt(self.x * self.x + self.y * self.y)

proc lengthSquared*(self: Vector2): float32 {.inline, noinit.} =
  self.x * self.x + self.y * self.y

proc normalize*(self: var Vector2) {.inline.} =
  var len = self.x * self.x + self.y * self.y
  if len != 0:
    len = sqrt(len)
    self.x /= len
    self.y /= len

proc normalized*(self: Vector2): Vector2 {.inline, noinit.} =
  result = self
  result.normalize()

proc angle*(self: Vector2): float32 {.inline, noinit.} =
  arctan2(self.y, self.x)

proc isNormalized*(self: Vector2): bool {.inline, noinit.} =
  isEqualApprox(self.lengthSquared(), 1.0)

proc distanceTo*(self, to: Vector2): float32 {.inline, noinit.} =
  sqrt((self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y))

proc distanceSquaredTo*(self, to: Vector2): float32 {.inline, noinit.} =
  (self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y)

proc dot*(a, b: Vector2): float32 {.inline, noinit.} =
  a.x * b.x + a.y * b.y

proc cross*(a, b: Vector2): float32 {.inline, noinit.} =
  a.x * b.y - a.y * b.x

proc cross*(self: Vector2, scalar: float32): Vector2 {.inline, noinit.} =
  Vector2(x: scalar * self.y, y: -scalar * self.x)

proc angleTo*(self, to: Vector2): float32 {.noinit.} =
  arctan2(cross(self, to), dot(self, to))

proc angleToPoint*(self, to: Vector2): float32 {.inline, noinit.} =
  arctan2(self.y - to.y, self.x - to.x)

proc floor*(self: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: floor(self.x), y: floor(self.y))

proc planeProject*(self: Vector2, d: float32,
                   vec: Vector2): Vector2 {.noinit.} =
  vec - self * (self.dot(vec) - d)

proc project*(self, other: Vector2): Vector2 {.noinit.} =
  self * (other.dot(self) / self.dot(self))

proc lerp*(self, b: Vector2; t: float32): Vector2 {.inline, noinit.} =
  result = self
  result.x += t * (b.x - self.x)
  result.y += t * (b.y - self.y)

proc cubicInterpolate*(self, b, preA, postB: Vector2;
                       t: float32): Vector2 {.noinit.} =
  let p0 = preA
  let p1 = self
  let p2 = b
  let p3 = postB

  let t2 = t * t
  let t3 = t2 * t

  result = 0.5'f32 * ((p1 * 2.0'f32)) +
           (-p0 + p2) * t +
           (2.0 * p0 - 5.0 * p1 + 4 * p2 - p3) * t2 +
           (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3

proc setRotation*(self: var Vector2, radians: float32) {.inline, noinit.} =
  self.x = cos(radians)
  self.y = sin(radians)

proc rotated*(self: Vector2; phi: float32): Vector2 {.inline, noinit.} =
  result.setRotation(phi)
  result *= self.length()

proc tangent*(self: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: self.y, y: -self.x)

proc snapped*(self: Vector2; by: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: stepify(self.x, by.x), y: stepify(self.y, by.y))

proc aspect*(self: Vector2): float32 {.inline, noinit.} =
  self.x / self.y

proc slide*(self, n: Vector2): Vector2 {.noinit.} =
  when not defined(release):
    if not n.isNormalized():
      printError("Normal not normalized in slide. " & getStackTrace())
      return vec2()
  result = self - n * self.dot(n)

proc reflect*(self, n: Vector2): Vector2 {.noinit.} =
  when not defined(release):
    if not n.isNormalized():
      printError("Normal not normalized in bounce. " & getStackTrace())
      return vec2()
  result = 2.0 * n * self.dot(n) - self

proc bounce*(self, n: Vector2): Vector2 {.inline, noinit.} =
  -self.reflect(n)

proc abs*(self: Vector2): Vector2 {.inline, noinit.} =
  Vector2(x: abs(self.x), y: abs(self.y))

proc clamped*(self: Vector2; length: float32): Vector2 {.noinit.} =
  let len = self.length()
  result = self
  if len > 0 and length < len:
    result /= len
    result *= length

{.pop.} # stackTrace: off
