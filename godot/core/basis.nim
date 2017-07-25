# Copyright (c) 2017 Xored Software, Inc.

import godotbase, vector3, quat, strings

type
  Basis* {.importc: "godot_basis", header: "godot/basis.h", byref.} = object

proc initBasis(dest: var Basis) {.importc: "godot_basis_new",
    header: "godot/basis.h".}
proc initBasis(dest: var Basis;
               xAxis: Vector3;
               yAxis: Vector3;
               zAxis: Vector3) {.
    importc: "godot_basis_new_with_rows", header: "godot/basis.h".}
proc initBasis(dest: var Basis;
               euler: Quat) {.
    importc: "godot_basis_new_with_euler_quat", header: "godot/basis.h".}
proc initBasis(dest: var Basis; axis: Vector3; phi: float32) {.
    importc: "godot_basis_new_with_axis_and_angle", header: "godot/basis.h".}
proc initBasis(dest: var Basis; euler: Vector3) {.
    importc: "godot_basis_new_with_euler", header: "godot/basis.h".}

proc initBasis*(): Basis {.inline.} =
  initBasis(result)

proc initBasis*(xAxis, yAxis, zAxis: Vector3): Basis {.inline.} =
  initBasis(result, xAxis, yAxis, zAxis)

proc initBasis*(euler: Quat): Basis {.inline.} =
  initBasis(result, euler)

proc initBasis*(axis: Vector3, phi: float32): Basis  {.inline.} =
  initBasis(result, axis, phi)

proc initBasis*(euler: Vector3): Basis {.inline.} =
  initBasis(result, euler)

proc toGodotString*(self: Basis): GodotString {.
    noSideEffect,
    importc: "godot_basis_as_string", header: "godot/basis.h".}

proc `$`*(self: Basis): string {.inline.} =
  $self.toGodotString()

proc inverse*(self: Basis): Basis {.
    noSideEffect,
    importc: "godot_basis_inverse", header: "godot/basis.h".}
proc transposed*(self: Basis): Basis {.
    noSideEffect,
    importc: "godot_basis_transposed", header: "godot/basis.h".}
proc orthonormalized*(self: Basis): Basis {.
    noSideEffect,
    importc: "godot_basis_orthonormalized", header: "godot/basis.h".}
proc determinant*(self: Basis): float32 {.
    noSideEffect,
    importc: "godot_basis_determinant", header: "godot/basis.h".}
proc rotated*(self: Basis; axis: Vector3;
              phi: float32): Basis {.
    noSideEffect,
    importc: "godot_basis_rotated", header: "godot/basis.h".}
proc scaled*(self: Basis; scale: Vector3): Basis {.
    noSideEffect,
    importc: "godot_basis_scaled", header: "godot/basis.h".}

proc setScale*(self: var Basis; scale: Vector3) {.
    noSideEffect,
    importc: "godot_basis_set_scale", header: "godot/basis.h".}
proc setRotationEuler*(self: var Basis;
                       euler: Vector3) {.
    noSideEffect,
    importc: "godot_basis_set_rotation_euler", header: "godot/basis.h".}
proc setRotationAxisAngle*(self: var Basis; axis: Vector3; angle: float32) {.
    noSideEffect,
    importc: "godot_basis_set_rotation_axis_angle", header: "godot/basis.h".}

proc scale*(self: Basis): Vector3 {.
    noSideEffect,
    importc: "godot_basis_get_scale", header: "godot/basis.h".}
proc euler*(self: Basis): Vector3 {.
    noSideEffect,
    importc: "godot_basis_get_euler", header: "godot/basis.h".}

proc tdotx*(self: Basis; x: Vector3): float32 {.
    noSideEffect,
    importc: "godot_basis_tdotx", header: "godot/basis.h".}
proc tdoty*(self: Basis; y: Vector3): float32 {.
    noSideEffect,
    importc: "godot_basis_tdoty", header: "godot/basis.h".}
proc tdotz*(self: Basis; z: Vector3): float32 {.
    noSideEffect,
    importc: "godot_basis_tdotz", header: "godot/basis.h".}

proc xform*(self: Basis; v: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_basis_xform", header: "godot/basis.h".}
proc xformInv*(self: Basis; v: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_basis_xform_inv", header: "godot/basis.h".}

proc orthogonalIndex*(self: Basis): cint {.
    noSideEffect,
    importc: "godot_basis_get_orthogonal_index", header: "godot/basis.h".}

proc godot_basis_get_elements(self: Basis;
                              elements: var array[3, Vector3]) {.
    noSideEffect,
    importc: "godot_basis_get_elements", header: "godot/basis.h".}

proc elements*(self: Basis): array[3, Vector3] {.inline.} =
 godot_basis_get_elements(self, result)

proc `[]`*(self: Basis; axis: range[0..2]): Vector3 {.
    noSideEffect,
    importc: "godot_basis_get_axis", header: "godot/basis.h".}
proc `[]=`*(self: var Basis; axis: range[0..2];
            value: Vector3) {.
    noSideEffect,
    importc: "godot_basis_set_axis", header: "godot/basis.h".}
proc row*(self: Basis; row: cint): Vector3 {.
    noSideEffect,
    importc: "godot_basis_get_row", header: "godot/basis.h".}
proc setRow*(self: var Basis; row: cint;
             value: Vector3) {.
    noSideEffect,
    importc: "godot_basis_set_row", header: "godot/basis.h".}
proc `==`*(self: Basis; b: Basis): bool {.
    noSideEffect,
    importc: "godot_basis_operator_equal", header: "godot/basis.h".}
proc `+`*(self: Basis; b: Basis): Basis {.
    noSideEffect,
    importc: "godot_basis_operator_add", header: "godot/basis.h".}
proc `-`*(self: Basis; b: Basis): Basis {.
    noSideEffect,
    importc: "godot_basis_operator_substract", header: "godot/basis.h".}
proc `*`*(self: Basis; b: Basis): Basis {.
    noSideEffect,
    importc: "godot_basis_operator_multiply_vector", header: "godot/basis.h".}
proc `*`*(self: Basis; b: float32): Basis {.
    noSideEffect,
    importc: "godot_basis_operator_multiply_scalar", header: "godot/basis.h".}
