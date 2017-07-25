# Copyright (c) 2017 Xored Software, Inc.

import godotbase, vector3, strings

type
  Plane* {.importc: "godot_plane", header: "godot/plane.h", byref.} = object

proc initPlane(dest: var Plane; a, b, c, d: float32) {.
    importc: "godot_plane_new_with_reals", header: "godot/plane.h".}
proc initPlane(dest: var Plane; v1, v2, v3: Vector3) {.
    importc: "godot_plane_new_with_vectors",
    header: "godot/plane.h".}
proc initPlane(dest: var Plane; normal: Vector3; d: float32) {.
    importc: "godot_plane_new_with_normal",
    header: "godot/plane.h".}

proc initPlane*(a, b, c, d: float32): Plane =
  initPlane(result, a, b, c, d)

proc initPlane*(v1, v2, v3: Vector3): Plane =
  initPlane(result, v1, v2, v3)

proc initPlane*(normal: Vector3; d: float32): Plane =
  initPlane(result, normal, d)

proc toGodotString*(self: Plane): GodotString {.
    noSideEffect,
    importc: "godot_plane_as_string", header: "godot/plane.h".}
proc `$`*(self: Plane): string {.inline.} =
  $self.toGodotString()

proc normalized*(self: Plane): Plane {.
    noSideEffect,
    importc: "godot_plane_normalized", header: "godot/plane.h".}
proc center*(self: Plane): Vector3 {.
    noSideEffect,
    importc: "godot_plane_center", header: "godot/plane.h".}
proc getAnyPoint*(self: Plane): Vector3 {.
    noSideEffect,
    importc: "godot_plane_get_any_point", header: "godot/plane.h".}
proc isPointOver*(self: Plane; point: Vector3): bool {.
    noSideEffect,
    importc: "godot_plane_is_point_over",
    header: "godot/plane.h".}
proc distanceTo*(self: Plane; point: Vector3): float32 {.
    noSideEffect,
    importc: "godot_plane_distance_to", header: "godot/plane.h".}
proc contains*(self: Plane; point: Vector3;
               epsilon: float32): bool {.
    noSideEffect,
    importc: "godot_plane_has_point", header: "godot/plane.h".}
proc project*(self: Plane; point: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_plane_project", header: "godot/plane.h".}
proc intersect3*(self: Plane; dest: var Vector3;
                 b, c: Plane): bool {.
    noSideEffect,
    importc: "godot_plane_intersect_3",
    header: "godot/plane.h".}
proc intersectsRay*(self: Plane; dest: var Vector3;
                    v, dir: Vector3): bool {.
    noSideEffect,
    importc: "godot_plane_intersects_ray",
    header: "godot/plane.h".}
proc intersectsSegment*(self: Plane; dest: var Vector3;
                        segmentBegin, segmentEnd: Vector3): bool {.
    noSideEffect, importc: "godot_plane_intersects_segment",
    header: "godot/plane.h".}
proc `-`*(self: Plane): Plane {.
    noSideEffect,
    importc: "godot_plane_operator_neg", header: "godot/plane.h".}
proc `==`*(a, b: Plane): bool {.
    noSideEffect,
    importc: "godot_plane_operator_equal", header: "godot/plane.h".}
proc normal*(self: Plane): Vector3 {.
    noSideEffect,
    importc: "godot_plane_get_normal", header: "godot/plane.h".}
proc `normal=`*(self: var Plane; normal: Vector3) {.
    importc: "godot_plane_set_normal", header: "godot/plane.h".}
proc d*(self: Plane): float32 {.
    noSideEffect,
    importc: "godot_plane_get_d", header: "godot/plane.h".}
proc `d=`*(self: var Plane; d: float32) {.
    importc: "godot_plane_set_d", header: "godot/plane.h".}