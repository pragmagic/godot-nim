# Copyright (c) 2018 Xored Software, Inc.

import math, hashes

import godotbase, vector3, quats
import godotcoretypes

{.push stackTrace: off.}

proc setCells*(basis: var Basis, xx, xy, xz, yx, yy, yz, zx, zy, zz: float32) =
  basis.elements[0].x = xx
  basis.elements[0].y = xy
  basis.elements[0].z = xz
  basis.elements[1].x = yx
  basis.elements[1].y = yy
  basis.elements[1].z = yz
  basis.elements[2].x = zx
  basis.elements[2].y = zy
  basis.elements[2].z = zz

proc `[]`*(self: Basis; row: range[0..2]): Vector3 {.inline.} =
  self.elements[row]

proc `[]`*(self: var Basis; row: range[0..2]): var Vector3 {.inline.} =
  self.elements[row]

proc `[]=`*(self: var Basis; row: range[0..2];
            value: Vector3) {.inline.} =
  self.elements[row] = value

proc `==`*(self, other: Basis): bool =
  for i in 0..2:
    for j in 0..2:
      if self[i][j] != other[i][j]:
        return false
  result = true

proc isEqualApprox*(self, other: Basis): bool =
  for i in 0..2:
    for j in 0..2:
      if not self[i][j].isEqualApprox(other[i][j]):
        return false
  result = true

proc tdotx*(self: Basis; v: Vector3): float32 {.inline.} =
  self.elements[0].x * v.x + self.elements[1].x * v.y + self.elements[2].x * v.z

proc tdoty*(self: Basis; v: Vector3): float32 {.inline.} =
  self.elements[0].y * v.x + self.elements[1].y * v.y + self.elements[2].y * v.z

proc tdotz*(self: Basis; v: Vector3): float32 {.inline.} =
  self.elements[0].z * v.x + self.elements[1].z * v.y + self.elements[2].z * v.z

proc `+`*(self, other: Basis): Basis {.inline.} =
  result[0] = self[0] + other[0]
  result[1] = self[1] + other[1]
  result[2] = self[2] + other[2]

proc `+=`*(self: var Basis, other: Basis) {.inline.} =
  self[0] += other[0]
  self[1] += other[1]
  self[2] += other[2]

proc `-`*(self, other: Basis): Basis {.inline.} =
  result[0] = self[0] - other[0]
  result[1] = self[1] - other[1]
  result[2] = self[2] - other[2]

proc `-=`*(self: var Basis, other: Basis) {.inline.} =
  self[0] -= other[0]
  self[1] -= other[1]
  self[2] -= other[2]

proc `*`*(self, other: Basis): Basis {.inline.} =
  result.setCells(
    other.tdotx(self[0]), other.tdoty(self[0]), other.tdotz(self[0]),
    other.tdotx(self[1]), other.tdoty(self[1]), other.tdotz(self[1]),
    other.tdotx(self[2]), other.tdoty(self[2]), other.tdotz(self[2])
  )

proc `*=`*(self: var Basis, other: Basis) {.inline.} =
  self.setCells(
    other.tdotx(self[0]), other.tdoty(self[0]), other.tdotz(self[0]),
    other.tdotx(self[1]), other.tdoty(self[1]), other.tdotz(self[1]),
    other.tdotx(self[2]), other.tdoty(self[2]), other.tdotz(self[2])
  )

proc `*=`*(self: var Basis; b: float32) {.inline.} =
  self[0] *= b
  self[1] *= b
  self[2] *= b

proc `*`*(self: Basis; b: float32): Basis {.inline.} =
  result = self
  result *= b

proc initBasis*(): Basis {.inline.} =
  result.setCells(
    1, 0, 0,
    0, 1, 0,
    0, 0, 1
  )

proc initBasis*(row0, row1, row2: Vector3): Basis {.inline.} =
  Basis(elements: [row0, row1, row2])

proc initBasis*(xx, xy, xz, yx, yy, yz, zx, zy, zz: float32): Basis =
  result.setCells(xx, xy, xz, yx, yy, yz, zx, zy, zz)

proc initBasis*(euler: Quat): Basis {.inline.} =
  let d = euler.lengthSquared()
  let s = 2.0 / d
  let xs = euler.x * s
  let ys = euler.y * s
  let zs = euler.z * s
  let wx = euler.w * xs
  let wy = euler.w * ys
  let wz = euler.w * zs
  let xx = euler.x * xs
  let xy = euler.x * ys
  let xz = euler.x * zs
  let yy = euler.y * ys
  let yz = euler.y * zs
  let zz = euler.z * zs
  result.setCells(
    1.0 - (yy + zz), xy - wz, xz + wy,
    xy + wz, 1.0 - (xx + zz), yz - wx,
    xz - wy, yz + wx, 1.0 - (xx + yy))

proc setAxisAngle(self: var Basis, axis: Vector3, phi: float32) =
  assert(axis.isNormalized())
  let axisSq = vec3(axis.x * axis.x, axis.y * axis.y, axis.z * axis.z)

  let cosine = cos(phi);
  let sine = sin(phi);

  self.elements[0].x = axisSq.x + cosine * (1.0 - axisSq.x)
  self.elements[0].y = axis.x * axis.y * (1.0 - cosine) - axis.z * sine
  self.elements[0].z = axis.z * axis.x * (1.0 - cosine) + axis.y * sine

  self.elements[1].x = axis.x * axis.y * (1.0 - cosine) + axis.z * sine
  self.elements[1].y = axisSq.y + cosine * (1.0 - axisSq.y)
  self.elements[1].z = axis.y * axis.z * (1.0 - cosine) - axis.x * sine

  self.elements[2].x = axis.z * axis.x * (1.0 - cosine) - axis.y * sine
  self.elements[2].y = axis.y * axis.z * (1.0 - cosine) + axis.x * sine
  self.elements[2].z = axisSq.z + cosine * (1.0 - axisSq.z)

proc initBasis*(axis: Vector3, phi: float32): Basis  {.inline.} =
  result.setAxisAngle(axis, phi)

proc setEuler*(self: var Basis, euler: Vector3) =
  var c = cos(euler.x)
  var s = sin(euler.x)

  let xmat = initBasis(1.0, 0.0, 0.0, 0.0, c, -s, 0.0, s, c)

  c = cos(euler.y)
  s = sin(euler.y)
  let ymat = initBasis(c, 0.0, s, 0.0, 1.0, 0.0, -s, 0.0, c)

  c = cos(euler.z)
  s = sin(euler.z)
  let zmat = initBasis(c, -s, 0.0, s, c, 0.0, 0.0, 0.0, 1.0)

  self = xmat * (ymat * zmat)

proc getEuler*(self: Basis): Vector3 =
  result.y = arcsin(self.elements[0].z)
  if result.y < PI * 0.5:
    if result.y > -PI * 0.5:
      result.x = arctan2(-self.elements[1].z, self.elements[2].z)
      result.z = arctan2(-self.elements[0].y, self.elements[0].x)
    else:
      let r = arctan2(self.elements[1].x, self.elements[1].y)
      result.x = -r
  else:
    let r = arctan2(self.elements[0].y, self.elements[1].y)
    result.x = r

proc initBasis*(euler: Vector3): Basis {.inline.} =
  result.setEuler(euler)

proc outer*(self, other: Vector3): Basis {.inline.} =
  let row0 = vec3(self.x * other.x, self.x * other.y, self.x * other.z)
  let row1 = vec3(self.y * other.x, self.y * other.y, self.y * other.z)
  let row2 = vec3(self.z * other.x, self.z * other.y, self.z * other.z)
  initBasis(row0, row1, row2)

proc toDiagonalMatrix*(self: Vector3): Basis {.inline.} =
  initBasis(
    self.x, 0, 0,
    0, self.y, 0,
    0, 0, self.z
  )

proc `$`*(self: Basis): string {.inline.} =
  result = newStringOfCap(128)
  for i in 0..2:
    for j in 0..2:
      if i != 0 or j != 0:
        result.add(", ")
      result.add($self[i][j])

proc hash*(self: Basis): Hash {.inline.} =
  !$(self.elements[0].hash() !& self.elements[1].hash() !& self.elements[2].hash())

template cofac(row1, col1, row2, col2: int): float32 =
  self.elements[row1][col1] * self.elements[row2][col2] -
    self.elements[row1][col2] * self.elements[row2][col1]

proc determinant(self: Basis): float32 {.inline.} =
  self[0][0] * cofac(1, 1, 2, 2) -
    self[1][0] * cofac(0, 1, 2, 2) +
    self[2][0] * cofac(0, 1, 1, 2)

proc invert*(self: var Basis) =
  let co = [cofac(1, 1, 2, 2), cofac(1, 2, 2, 0), cofac(1, 0, 2, 1)]
  let det = self.elements[0][0] * co[0] +
            self.elements[0][1] * co[1] +
            self.elements[0][2] * co[2]
  assert(det != 0)
  let s = 1.0'f32 / det
  self.setCells(
    co[0] * s, cofac(0, 2, 2, 1) * s, cofac(0, 1, 1, 2) * s,
    co[1] * s, cofac(0, 0, 2, 2) * s, cofac(0, 2, 1, 0) * s,
    co[2] * s, cofac(0, 1, 2, 0) * s, cofac(0, 0, 1, 1) * s
  )

proc inverse*(self: Basis): Basis {.inline.} =
  result = self
  result.invert()

proc axis*(self: Basis; idx: range[0..2]): Vector3 {.inline.} =
  vec3(self[0][idx], self[1][idx], self[2][idx])

proc setAxis*(self: var Basis; idx: range[0..2]; value: Vector3) {.inline.} =
  self.elements[0][idx] = value.x
  self.elements[1][idx] = value.y
  self.elements[2][idx] = value.z

proc row*(self: Basis; row: range[0..2]): Vector3 {.inline.} =
  self.elements[row]

proc setRow*(self: var Basis; row: range[0..2]; value: Vector3) {.inline.} =
  self.elements[row] = value

proc getMainDiagonal*(self: Basis): Vector3 {.inline.} =
  vec3(self.elements[0][0], self.elements[1][1], self.elements[2][2])

proc zero*(self: var Basis) {.inline.} =
  self.elements[0].zero()
  self.elements[1].zero()
  self.elements[2].zero()

proc orthonormalize(self: var Basis) =
  var x = self.axis(0)
  var y = self.axis(1)
  var z = self.axis(2)

  x.normalize()
  y = y - x * x.dot(y)
  y.normalize()
  z = z - x * x.dot(z) - y * y.dot(z)
  z.normalize()

  self.setAxis(0, x)
  self.setAxis(1, y)
  self.setAxis(2, z)

proc orthonormalized*(self: Basis): Basis {.inline.} =
  result = self
  result.orthonormalize()

proc transpose*(self: var Basis) {.inline.} =
  swap(self.elements[0].x, self.elements[1].x)
  swap(self.elements[0].z, self.elements[2].x)
  swap(self.elements[1].z, self.elements[2].y)

proc transposed*(self: Basis): Basis {.inline.} =
  result = self
  result.transpose()

proc isOrthogonal*(self: Basis): bool {.inline.} =
  let id = initBasis()
  let m = self * self.transposed()
  result = id.isEqualApprox(m)

proc isRotation*(self: Basis): bool {.inline.} =
  self.determinant().isEqualApprox(1.0) and self.isOrthogonal()

proc isSymmetric*(self: Basis): bool {.inline.} =
  if not self.elements[0][1].isEqualApprox(self.elements[1][0]):
    return false
  if not self.elements[0][2].isEqualApprox(self.elements[2][0]):
    return false
  if not self.elements[1][2].isEqualApprox(self.elements[2][1]):
    return false
  result = true

proc scale*(self: var Basis, scale: Vector3) =
  self[0].x *= scale.x
  self[0].y *= scale.x
  self[0].z *= scale.x
  self[1].x *= scale.y
  self[1].y *= scale.y
  self[1].z *= scale.y
  self[2].x *= scale.z
  self[2].y *= scale.z
  self[2].z *= scale.z

proc scaled*(self: Basis, scale: Vector3): Basis =
  result = self
  result.scale(scale)

proc rotated*(self: Basis; axis: Vector3; phi: float32): Basis {.inline.} =
  initBasis(axis, phi) * self

proc rotate*(self: var Basis; axis: Vector3; phi: float32) {.inline.} =
  self = self.rotated(axis, phi)

proc rotated*(self: Basis; euler: Vector3): Basis {.inline.} =
  initBasis(euler) * self

proc rotate*(self: var Basis; euler: Vector3) {.inline.} =
  self = self.rotated(euler)

proc getScale*(self: Basis): Vector3 =
  let detSign = if self.determinant() > 0: 1'f32 else: -1'f32
  result = detSign * vec3(
    vec3(self.elements[0].x, self.elements[1].x, self.elements[2].x).length(),
    vec3(self.elements[0].y, self.elements[1].y, self.elements[2].y).length(),
    vec3(self.elements[0].z, self.elements[1].z, self.elements[2].z).length(),
  )

proc getRotation*(self: Basis): Vector3 {.inline.} =
  var m = self.orthonormalized()
  let det = m.determinant()
  if det < 0:
    m.scale(vec3(-1, -1, -1))
  result = m.getEuler()

proc setScale*(self: var Basis; scale: Vector3) =
  let e = self.getEuler()
  self = initBasis() # reset to identity
  self.scale(scale)
  self.rotate(e)

proc setRotationEuler*(self: var Basis; euler: Vector3) =
  let s = self.getScale()
  self = initBasis()
  self.scale(s)
  self.rotate(euler)

proc setRotationAxisAngle*(self: var Basis; axis: Vector3; angle: float32) =
  let s = self.getScale()
  self = initBasis()
  self.scale(s)
  self.rotate(axis, angle)

proc asQuat*(self: Basis): Quat =
  let trace = self.elements[0].x + self.elements[1].y + self.elements[2].z
  var temp: array[4, float32]
  if trace > 0'f32:
    var s = sqrt(trace + 1.0)
    temp[3] = s * 0.5
    s = 0.5 / s

    temp[0] = (self.elements[2].y - self.elements[1].z) * s
    temp[1] = (self.elements[0].z - self.elements[2].x) * s
    temp[2] = (self.elements[1].x - self.elements[0].y) * s
  else:
    let i = if self.elements[0].x < self.elements[1].y:
              if self.elements[1].y < self.elements[2].z: 2 else: 1
            else:
              if self.elements[0].x < self.elements[2].z: 2 else: 0
    let j = (i + 1) mod 3
    let k = (i + 2) mod 3

    var s = sqrt(self.elements[i][i] - self.elements[j][j] -
                 self.elements[k][k] + 1.0)
    temp[i] = s * 0.5
    s = 0.5 / s

    temp[3] = (self.elements[k][j] - self.elements[j][k]) * s
    temp[j] = (self.elements[j][i] + self.elements[i][j]) * s
    temp[k] = (self.elements[k][i] + self.elements[i][k]) * s

  result = initQuat(temp[0], temp[1], temp[2], temp[3])

proc xform*(self: Basis; v: Vector3): Vector3 {.inline.} =
  vec3(
    self.elements[0].dot(v),
    self.elements[1].dot(v),
    self.elements[2].dot(v)
  )

proc xformInv*(self: Basis; v: Vector3): Vector3 {.inline.} =
  vec3(
    self.elements[0].x * v.x + self.elements[1].x * v.y + self.elements[2].x * v.z,
    self.elements[0].y * v.x + self.elements[1].y * v.y + self.elements[2].y * v.z,
    self.elements[0].z * v.x + self.elements[1].z * v.y + self.elements[2].z * v.z,
  )

const orthoBases = [
  initBasis(1, 0, 0, 0, 1, 0, 0, 0, 1),
  initBasis(0, -1, 0, 1, 0, 0, 0, 0, 1),
  initBasis(-1, 0, 0, 0, -1, 0, 0, 0, 1),
  initBasis(0, 1, 0, -1, 0, 0, 0, 0, 1),
  initBasis(1, 0, 0, 0, 0, -1, 0, 1, 0),
  initBasis(0, 0, 1, 1, 0, 0, 0, 1, 0),
  initBasis(-1, 0, 0, 0, 0, 1, 0, 1, 0),
  initBasis(0, 0, -1, -1, 0, 0, 0, 1, 0),
  initBasis(1, 0, 0, 0, -1, 0, 0, 0, -1),
  initBasis(0, 1, 0, 1, 0, 0, 0, 0, -1),
  initBasis(-1, 0, 0, 0, 1, 0, 0, 0, -1),
  initBasis(0, -1, 0, -1, 0, 0, 0, 0, -1),
  initBasis(1, 0, 0, 0, 0, 1, 0, -1, 0),
  initBasis(0, 0, -1, 1, 0, 0, 0, -1, 0),
  initBasis(-1, 0, 0, 0, 0, -1, 0, -1, 0),
  initBasis(0, 0, 1, -1, 0, 0, 0, -1, 0),
  initBasis(0, 0, 1, 0, 1, 0, -1, 0, 0),
  initBasis(0, -1, 0, 0, 0, 1, -1, 0, 0),
  initBasis(0, 0, -1, 0, -1, 0, -1, 0, 0),
  initBasis(0, 1, 0, 0, 0, -1, -1, 0, 0),
  initBasis(0, 0, 1, 0, -1, 0, 1, 0, 0),
  initBasis(0, 1, 0, 0, 0, 1, 1, 0, 0),
  initBasis(0, 0, -1, 0, 1, 0, 1, 0, 0),
  initBasis(0, -1, 0, 0, 0, -1, 1, 0, 0)
]

proc orthogonalIndex*(self: Basis): int =
  var orth = self
  for i in 0..2:
    for j in 0..2:
      var v = orth[i][j]
      if v > 0.5:
        v = 1.0'f32
      elif v < -0.5:
        v = -1.0'f32
      else:
        v = 0'f32
      orth[i][j] = v

  for idx, base in orthoBases:
    if base == orth:
      return idx

proc setOrthogonalIndex*(self: var Basis, idx: range[0..23]) =
  self = orthoBases[idx]

proc rotate*(self: var Vector3; axis: Vector3; phi: float32) =
  self = initBasis(axis, phi).xform(self)

proc rotated*(self: Vector3; axis: Vector3; phi: float32): Vector3 =
  result = self
  result.rotate(axis, phi)

{.pop.} # stackTrace: off