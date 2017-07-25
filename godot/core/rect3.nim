# Copyright (c) 2017 Xored Software, Inc.

import godotbase, plane, vector3, strings

type
  Rect3* {.importc: "godot_rect3", header: "godot/rect3.h", byref.} = object

proc initRect3(dest: var Rect3; pos, size: Vector3) {.
    importc: "godot_rect3_new", header: "godot/rect3.h".}

proc initRect3*(pos, size: Vector3): Rect3 {.inline.} =
  initRect3(result, pos, size)

proc position*(self: Rect3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_position", header: "godot/rect3.h".}
proc setPosition*(self: var Rect3; v: Vector3) {.
    noSideEffect
    importc: "godot_rect3_set_position", header: "godot/rect3.h".}
proc size*(self: Rect3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_size", header: "godot/rect3.h".}
proc setSize*(self: var Rect3; v: Vector3) {.
    noSideEffect,
    importc: "godot_rect3_set_size", header: "godot/rect3.h".}
proc toGodotString*(self: Rect3): GodotString {.
    noSideEffect,
    importc: "godot_rect3_as_string", header: "godot/rect3.h".}
proc `$`*(self: Rect3): string {.inline.} =
  $self.toGodotString()
proc area*(self: Rect3): float32 {.
    noSideEffect,
    importc: "godot_rect3_get_area", header: "godot/rect3.h".}
proc hasNoArea*(self: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_has_no_area", header: "godot/rect3.h".}
proc hasNoSurface*(self: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_has_no_surface", header: "godot/rect3.h".}
proc intersects*(a, b: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_intersects", header: "godot/rect3.h".}
proc encloses*(self, other: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_encloses", header: "godot/rect3.h".}
proc merge*(self, other: Rect3): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_merge", header: "godot/rect3.h".}
proc intersection*(self, other: Rect3): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_intersection", header: "godot/rect3.h".}
proc intersectsPlane*(self: Rect3; plane: Plane): bool {.
    noSideEffect,
    importc: "godot_rect3_intersects_plane",
    header: "godot/rect3.h".}
proc intersectsSegment*(self: Rect3; start, to: Vector3): bool {.
    noSideEffect,
    importc: "godot_rect3_intersects_segment",
    header: "godot/rect3.h".}
proc contains*(self: Rect3; point: Vector3): bool {.
    noSideEffect,
    importc: "godot_rect3_has_point", header: "godot/rect3.h".}
proc getSupport*(self: Rect3; dir: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_support", header: "godot/rect3.h".}
proc getLongestAxis*(self: Rect3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_longest_axis", header: "godot/rect3.h".}
proc getLongestAxisIndex*(self: Rect3): cint {.
    noSideEffect,
    importc: "godot_rect3_get_longest_axis_index",
    header: "godot/rect3.h".}
proc getLongestAxisSize*(self: Rect3): float32 {.
    noSideEffect,
    importc: "godot_rect3_get_longest_axis_size",
    header: "godot/rect3.h".}
proc getShortestAxis*(self: Rect3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_shortest_axis", header: "godot/rect3.h".}
proc getShortestAxisIndex*(self: Rect3): cint {.
    noSideEffect,
    importc: "godot_rect3_get_shortest_axis_index",
    header: "godot/rect3.h".}
proc getShortestAxisSize*(self: Rect3): float32 {.
    noSideEffect,
    importc: "godot_rect3_get_shortest_axis_size",
    header: "godot/rect3.h".}
proc expand*(self: Rect3; toPoint: Vector3): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_expand", header: "godot/rect3.h".}
proc grow*(self: Rect3; by: float32): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_grow", header: "godot/rect3.h".}
proc getEndpoint*(self: Rect3; idx: cint): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_endpoint", header: "godot/rect3.h".}
proc `==`*(a, b: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_operator_equal",
    header: "godot/rect3.h".}
