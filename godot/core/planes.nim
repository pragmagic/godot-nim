# Copyright (c) 2017 Xored Software, Inc.

import godotbase, vector3

import "../internal/godotstrings.nim"

type
  Plane* {.byref.} = object
    normal*: Vector3
    d*: float32

proc initPlane(dest: var Plane; a, b, c, d: float32) {.
    importc: "godot_plane_new_with_reals".}
proc initPlane(dest: var Plane; v1, v2, v3: Vector3) {.
    importc: "godot_plane_new_with_vectors".}
proc initPlane(dest: var Plane; normal: Vector3; d: float32) {.
    importc: "godot_plane_new_with_normal".}

proc initPlane*(a, b, c, d: float32): Plane =
  initPlane(result, a, b, c, d)

proc initPlane*(v1, v2, v3: Vector3): Plane =
  initPlane(result, v1, v2, v3)

proc initPlane*(normal: Vector3; d: float32): Plane =
  initPlane(result, normal, d)

proc toGodotString(self: Plane): GodotString {.
    noSideEffect,
    importc: "godot_plane_as_string".}

proc `$`*(self: Plane): string {.inline.} =
  $self.toGodotString()

proc normalized*(self: Plane): Plane {.
    noSideEffect,
    importc: "godot_plane_normalized".}
proc center*(self: Plane): Vector3 {.
    noSideEffect,
    importc: "godot_plane_center".}
proc getAnyPoint*(self: Plane): Vector3 {.
    noSideEffect,
    importc: "godot_plane_get_any_point".}
proc isPointOver*(self: Plane; point: Vector3): bool {.
    noSideEffect,
    importc: "godot_plane_is_point_over".}
proc distanceTo*(self: Plane; point: Vector3): float32 {.
    noSideEffect,
    importc: "godot_plane_distance_to".}
proc contains*(self: Plane; point: Vector3;
               epsilon: float32): bool {.
    noSideEffect,
    importc: "godot_plane_has_point".}
proc project*(self: Plane; point: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_plane_project".}
proc intersect3*(self: Plane; dest: var Vector3;
                 b, c: Plane): bool {.
    noSideEffect,
    importc: "godot_plane_intersect_3".}
proc intersectsRay*(self: Plane; dest: var Vector3;
                    v, dir: Vector3): bool {.
    noSideEffect,
    importc: "godot_plane_intersects_ray".}
proc intersectsSegment*(self: Plane; dest: var Vector3;
                        segmentBegin, segmentEnd: Vector3): bool {.
    noSideEffect, importc: "godot_plane_intersects_segment".}
proc `-`*(self: Plane): Plane {.
    noSideEffect,
    importc: "godot_plane_operator_neg".}
proc `==`*(a, b: Plane): bool {.
    noSideEffect,
    importc: "godot_plane_operator_equal".}
