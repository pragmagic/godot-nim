# Copyright (c) 2018 Xored Software, Inc.

import math
import godotbase, godotcoretypes

{.push stackTrace: off.}

proc vec3*(): Vector3 {.inline.} =
  Vector3()

proc vec3*(x, y, z: float32): Vector3 {.inline.} =
  Vector3(x: x, y: y, z: z)

proc `$`*(self: Vector3): string {.inline.} =
  result = newStringOfCap(40)
  result.add('(')
  result.add($self.x)
  result.add(", ")
  result.add($self.y)
  result.add(", ")
  result.add($self.z)
  result.add(')')

proc `+`*(a, b: Vector3): Vector3 {.inline.} =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z

proc `+=`*(a: var Vector3, b: Vector3) {.inline.} =
  a.x += b.x
  a.y += b.y
  a.z += b.z

proc `-`*(a, b: Vector3): Vector3 {.inline.} =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z

proc `-=`*(a: var Vector3, b: Vector3) {.inline.} =
  a.x -= b.x
  a.y -= b.y
  a.z -= b.z

proc `*`*(a, b: Vector3): Vector3 {.inline.} =
  result.x = a.x * b.x
  result.y = a.y * b.y
  result.z = a.z * b.z

proc `*=`*(a: var Vector3, b: Vector3) {.inline.}=
  a.x *= b.x
  a.y *= b.y
  a.z *= b.z

proc `*`*(a: Vector3; b: float32): Vector3 {.inline.} =
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b

proc `*`*(b: float32; a: Vector3): Vector3 {.inline.} =
  a * b

proc `*=`*(a: var Vector3; b: float32) {.inline.} =
  a.x *= b
  a.y *= b
  a.z *= b

proc `/`*(a, b: Vector3): Vector3 =
  result.x = a.x / b.x
  result.y = a.y / b.y
  result.z = a.z / b.z

proc `/=`*(a: var Vector3; b: Vector3) {.inline.} =
  a.x /= b.x
  a.y /= b.y
  a.z /= b.z

proc `/`*(a: Vector3; b: float32): Vector3 =
  result.x = a.x / b
  result.y = a.y / b
  result.z = a.z / b

proc `/=`*(a: var Vector3; b: float32) {.inline.} =
  a.x /= b
  a.y /= b
  a.z /= b

proc `==`*(a, b: Vector3): bool {.inline.} =
  a.x == b.x and a.y == b.y and a.z == b.z

proc `<`*(a, b: Vector3): bool =
  if a.x == b.x:
    if a.y == b.y:
      return a.z < b.z
    return a.y < b.y
  return a.x < b.x

proc `-`*(self: Vector3): Vector3 =
  result.x = -self.x
  result.y = -self.y
  result.z = -self.z

proc `[]`*(self: Vector3, idx: range[0..2]): float32 {.inline.} =
  cast[array[3, float32]](self)[idx]

proc `[]`*(self: var Vector3, idx: range[0..2]): var float32 {.inline.} =
  cast[ptr array[3, float32]](addr self)[][idx]

proc `[]=`*(self: var Vector3, idx: range[0..2],
            val: float32) {.inline.} =
  case idx:
  of 0: self.x = val
  of 1: self.y = val
  of 2: self.z = val

proc minAxis*(self: Vector3): int {.inline.} =
  if self.x < self.y:
    if self.x < self.z: 0 else: 2
  else:
    if self.y < self.z: 1 else: 2

proc maxAxis*(self: Vector3): int {.inline.} =
  if self.x < self.y:
    if self.y < self.z: 2 else: 1
  else:
    if self.x < self.z: 2 else: 0

proc length*(self: Vector3): float32 {.inline.} =
  let x2 = self.x * self.x
  let y2 = self.y * self.y
  let z2 = self.z * self.z

  result = sqrt(x2 + y2 + z2)

proc lengthSquared*(self: Vector3): float32 {.inline.} =
  let x2 = self.x * self.x
  let y2 = self.y * self.y
  let z2 = self.z * self.z

  result = x2 + y2 + z2

proc normalize*(self: var Vector3) {.inline.} =
  let len = self.length()
  if len == 0:
    self.x = 0
    self.y = 0
    self.z = 0
  else:
    self.x /= len
    self.y /= len
    self.z /= len

proc normalized*(self: Vector3): Vector3 {.inline.} =
  result = self
  result.normalize()

proc isNormalized*(self: Vector3): bool {.inline.} =
  self.lengthSquared().isEqualApprox(1.0'f32)

proc zero*(self: var Vector3) {.inline.} =
  self.x = 0
  self.y = 0
  self.z = 0

proc inverse*(self: Vector3): Vector3 {.inline.} =
  vec3(1.0'f32 / self.x, 1.0'f32 / self.y, 1.0'f32 / self.z)

proc cross*(self, other: Vector3): Vector3 {.inline.} =
  vec3(
    self.y * other.z - self.z * other.y,
    self.z * other.x - self.x * other.z,
    self.x * other.y - self.y * other.x)

proc dot*(self, other: Vector3): float32 {.inline.} =
  self.x * other.x + self.y * other.y + self.z * other.z

proc abs*(self: Vector3): Vector3 {.inline.} =
  vec3(abs(self.x), abs(self.y), abs(self.z))

proc sign*(self: Vector3): Vector3 {.inline.} =
  vec3(sign(self.x),  sign(self.y), sign(self.z))

proc floor*(self: Vector3): Vector3 {.inline.} =
  vec3(floor(self.x), floor(self.y), floor(self.z))

proc ceil*(self: Vector3): Vector3 {.inline.} =
  vec3(ceil(self.x), ceil(self.y), ceil(self.z))

proc lerp*(self: Vector3, other: Vector3, t: float32): Vector3 {.inline.} =
  vec3(
    self.x + t * (other.x - self.x),
    self.y + t * (other.y - self.y),
    self.z + t * (other.z - self.z)
  )

proc distanceTo*(self, other: Vector3): float32 {.inline.} =
  (other - self).length()

proc distanceSquaredTo*(self, other: Vector3): float32 {.inline.} =
  (other - self).lengthSquared()

proc angleTo*(self, other: Vector3): float32 {.inline.} =
  arctan2(self.cross(other).length(), self.dot(other))

proc slide*(self, n: Vector3): Vector3 {.inline.} =
  assert(n.isNormalized())
  result = self - n * self.dot(n)

proc reflect*(self, n: Vector3): Vector3 {.inline.} =
  assert(n.isNormalized())
  result = 2.0'f32 * n * self.dot(n) - self

proc bounce*(self, n: Vector3): Vector3 {.inline.} =
  -self.reflect(n)

proc snap*(self: var Vector3, other: Vector3) =
  self.x = stepify(self.x, other.x)
  self.y = stepify(self.y, other.y)
  self.z = stepify(self.z, other.z)

proc snapped*(self: Vector3, other: Vector3): Vector3 =
  result = self
  result.snap(other)

proc cubicInterpolate*(self, b, preA, postB: Vector3;
                       t: float32): Vector3 =
  let p0 = preA
  let p1 = self
  let p2 = b
  let p3 = postB

  let t2 = t * t
  let t3 = t2 * t

  result = 0.5 * ((p1 * 2.0) +
            (-p0 + p2) * t +
            (2.0 * p0 - 5.0 * p1 + 4 * p2 - p3) * t2 +
            (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3)

{.pop.} # stackTrace: off