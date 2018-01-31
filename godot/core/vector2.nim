# Copyright (c) 2018 Xored Software, Inc.

import internal.godotinternaltypes, internal.godotstrings
import godotcoretypes, gdnativeapi

proc vec2*(): Vector2 {.inline.} =
  Vector2()

proc vec2*(x, y: float32): Vector2 {.inline.} =
  Vector2(x: x, y: y)

proc `$`*(self: Vector2): string {.inline.} =
  $getGDNativeAPI().vector2AsString(self)

proc normalized*(self: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Normalized(self)

proc length*(self: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2Length(self)

proc angle*(self: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2Angle(self)

proc lengthSquared*(self: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2LengthSquared(self)

proc isNormalized*(self: Vector2): bool {.inline.} =
  getGDNativeAPI().vector2IsNormalized(self)

proc distanceTo*(self, to: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2DistanceTo(self, to)

proc distanceSquaredTo*(self, to: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2DistanceSquaredTo(self, to)

proc angleTo*(self, to: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2AngleTo(self, to)

proc angleToPoint*(self, to: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2AngleToPoint(self, to)

proc lerp*(self, b: Vector2; t: float32): Vector2 {.inline.} =
  getGDNativeAPI().vector2LinearInterpolate(self, b, t)

proc cubicInterpolate*(self, b, preA, postB: Vector2;
                       t: float32): Vector2 {.inline.} =
  getGDNativeAPI().vector2CubicInterpolate(self, b, preA, postB, t)

proc rotated*(self: Vector2; phi: float32): Vector2 {.inline.} =
  getGDNativeAPI().vector2Rotated(self, phi)

proc tangent*(self: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Tangent(self)

proc floor*(self: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Floor(self)

proc snapped*(self: Vector2; by: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Snapped(self, by)

proc aspect*(self: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2Aspect(self)

proc dot*(a, b: Vector2): float32 {.inline.} =
  getGDNativeAPI().vector2Dot(a, b)

proc slide*(self, n: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Slide(self, n)

proc bounce*(self, n: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Bounce(self, n)

proc reflect*(self, n: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Reflect(self, n)

proc abs*(self: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2Abs(self)

proc clamped*(self: Vector2; length: float32): Vector2 {.inline.} =
  getGDNativeAPI().vector2Clamped(self, length)

proc `+`*(self, other: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2OperatorAdd(self, other)

proc `+=`*(self: var Vector2, other: Vector2) {.inline.} =
  self = self + other

proc `-`*(self, other: Vector2): Vector2 =
  getGDNativeAPI().vector2OperatorSubtract(self, other)

proc `-=`*(self: var Vector2, other: Vector2) {.inline.} =
  self = self - other

proc `*`*(self, other: Vector2): Vector2 =
  getGDNativeAPI().vector2OperatorMultiplyVector(self, other)

proc `*=`*(self: var Vector2, other: Vector2) {.inline.} =
  self = self * other

proc `*`*(self: Vector2, scalar: float32): Vector2 =
  getGDNativeAPI().vector2OperatorMultiplyScalar(self, scalar)

proc `*=`*(self: var Vector2, scalar: float32) {.inline.} =
  self = self * scalar

proc `/`*(self, other: Vector2): Vector2 =
  getGDNativeAPI().vector2OperatorDivideVector(self, other)

proc `/=`*(self: var Vector2, other: Vector2) {.inline.} =
  self = self / other

proc `/`*(self: Vector2; scalar: float32): Vector2 =
  getGDNativeAPI().vector2OperatorDivideScalar(self, scalar)

proc `/=`*(self: var Vector2; scalar: float32) {.inline.} =
  self = self / scalar

proc `==`*(self, other: Vector2): bool {.inline.} =
  getGDNativeAPI().vector2OperatorEqual(self, other)

proc `<`*(self, other: Vector2): bool {.inline.} =
  getGDNativeAPI().vector2OperatorLess(self, other)

proc `-`*(self: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().vector2OperatorNeg(self)
