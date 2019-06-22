# Copyright (c) 2018 Xored Software, Inc.

import hashes

import internal/godotinternaltypes, internal/godotstrings
import godotcoretypes, gdnativeapi

proc initQuat*(x, y, z, w: float32): Quat {.inline.} =
  result = Quat(
    x: x,
    y: y,
    z: z,
    w: w
  )

proc initQuat*(axis: Vector3; angle: float32): Quat {.inline.} =
  getGDNativeAPI().quatNewWithAxisAngle(result, axis, angle)

proc `$`*(self: Quat): string {.inline.} =
  $getGDNativeAPI().quatAsString(self)

proc hash*(self: Quat): Hash {.inline.} =
  !$(self.x.hash() !& self.y.hash() !& self.z.hash() !& self.w.hash())

proc length*(self: Quat): float32 {.inline.} =
  getGDNativeAPI().quatLength(self)

proc lengthSquared*(self: Quat): float32 {.inline.} =
  getGDNativeAPI().quatLengthSquared(self)

proc normalized*(self: Quat): Quat {.inline.} =
  getGDNativeAPI().quatNormalized(self).toQuat()

proc isNormalized*(self: Quat): bool {.inline.} =
  getGDNativeAPI().quatIsNormalized(self)

proc inverse*(self: Quat): Quat {.inline.} =
  getGDNativeAPI().quatInverse(self).toQuat()

proc dot*(a, b: Quat): float32 {.inline.} =
  getGDNativeAPI().quatDot(a, b)

proc xform*(self: Quat; v: Vector3): Vector3 {.inline.} =
  getGDNativeAPI().quatXform(self, v).toVector3()

proc slerp*(self: Quat; b: Quat; t: float32): Quat {.inline.} =
  getGDNativeAPI().quatSlerp(self, b, t).toQuat()

proc slerpni*(self: Quat; b: Quat; t: float32): Quat {.inline.} =
  getGDNativeAPI().quatSlerpni(self, b, t).toQuat()

proc cubicSlerp*(self, b, preA, postB: Quat;
                 t: float32): Quat {.inline.} =
  getGDNativeAPI().quatCubicSlerp(self, b, preA, postB, t).toQuat()

proc `*`*(a: Quat, b: float32): Quat {.inline.} =
  getGDNativeAPI().quatOperatorMultiply(a, b).toQuat()

proc `*=`*(a: var Quat, b: float32) {.inline.} =
  a = a * b

proc `+`*(a, b: Quat): Quat {.inline.} =
  getGDNativeAPI().quatOperatorAdd(a, b).toQuat()

proc `+=`*(a: var Quat, b: Quat) {.inline.} =
  a = a + b

proc `-`*(a, b: Quat): Quat {.inline.} =
  getGDNativeAPI().quatOperatorSubtract(a, b).toQuat()

proc `-=`* (a: var Quat, b: Quat) {.inline.} =
  a = a - b

proc `/`*(self: Quat; b: float32): Quat {.inline.} =
  getGDNativeAPI().quatOperatorDivide(self, b).toQuat()

proc `/=`*(self: var Quat, b: float32) {.inline.} =
  self = self / b

proc `==`*(a, b: Quat): bool {.inline.} =
  getGDNativeAPI().quatOperatorEqual(a, b)

proc `-`*(self: Quat): Quat {.inline.} =
  getGDNativeAPI().quatOperatorNeg(self).toQuat()
