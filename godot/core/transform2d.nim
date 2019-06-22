# Copyright (c) 2018 Xored Software, Inc.

import hashes, vector2

import internal/godotinternaltypes, internal/godotstrings
import godotcoretypes, gdnativeapi

proc initTransform2D*(): Transform2D {.inline.} =
  getGDNativeAPI().transform2DNewIdentity(result)

proc initTransform2D*(rot: float32; pos: Vector2): Transform2D {.inline.} =
  getGDNativeAPI().transform2DNew(result, rot, pos)

proc initTransform2D*(xAxis, yAxis, origin: Vector2): Transform2D {.inline.} =
  getGDNativeAPI().transform2DNewAxisOrigin(result, xAxis, yAxis, origin)

proc `$`*(self: Transform2D): string {.inline.} =
  $getGDNativeAPI().transform2DAsString(self)

proc hash*(self: Transform2D): Hash {.inline, noinit.} =
  !$(self.elements[0].hash() !& self.elements[1].hash() !& self.elements[2].hash())

proc inverse*(self: Transform2D): Transform2D {.inline.} =
  getGDNativeAPI().transform2DInverse(self).toTransform2D()

proc affineInverse*(self: Transform2D): Transform2D {.inline.} =
  getGDNativeAPI().transform2DAffineInverse(self).toTransform2D()

proc rotation*(self: Transform2D): float32 {.inline.} =
  getGDNativeAPI().transform2DGetRotation(self)

proc origin*(self: Transform2D): Vector2 {.inline.} =
  getGDNativeAPI().transform2DGetOrigin(self).toVector2()

proc scale*(self: Transform2D): Vector2 {.inline.} =
  getGDNativeAPI().transform2DGetScale(self).toVector2()

proc orthonormalized*(self: Transform2D): Transform2D {.inline.} =
  getGDNativeAPI().transform2DOrthonormalized(self).toTransform2D()

proc rotated*(self: Transform2D; phi: float32): Transform2D {.inline.} =
  getGDNativeAPI().transform2DRotated(self, phi).toTransform2D()

proc scaled*(self: Transform2D; scale: Vector2): Transform2D {.inline.} =
  getGDNativeAPI().transform2DScaled(self, scale).toTransform2D()

proc translated*(self: Transform2D; offset: Vector2): Transform2D {.inline.} =
  getGDNativeAPI().transform2DTranslated(self, offset).toTransform2D()

proc xformVector2*(self: Transform2D; v: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().transform2DXformVector2(self, v).toVector2()

proc xformInvVector2*(self: Transform2D; v: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().transform2DXformInvVector2(self, v).toVector2()

proc basisXformVector2*(self: Transform2D; v: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().transform2DBasisXformVector2(self, v).toVector2()

proc basisXformInvVector2*(self: Transform2D; v: Vector2): Vector2 {.inline.} =
  getGDNativeAPI().transform2DBasisXformInvVector2(self, v).toVector2()

proc xformRect2*(self: Transform2D; rect: Rect2): Rect2 {.inline.} =
  getGDNativeAPI().transform2DXformRect2(self, rect).toRect2()

proc xformInvRect2*(self: Transform2D; rect: Rect2): Rect2 {.inline.} =
  getGDNativeAPI().transform2DXformInvRect2(self, rect).toRect2()

proc interpolateWith*(self, m: Transform2D;
                      c: float32): Transform2D {.inline.} =
  getGDNativeAPI().transform2DInterpolateWith(self, m, c).toTransform2D()

proc `==`*(a, b: Transform2D): bool {.inline.} =
  getGDNativeAPI().transform2DOperatorEqual(a, b)

proc `*`*(a, b: Transform2D): Transform2D {.inline.} =
  getGDNativeAPI().transform2DOperatorMultiply(a, b).toTransform2D()

proc `*=`*(a: var Transform2D, b: Transform2D) {.inline.} =
  a = a * b
