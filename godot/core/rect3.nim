# Copyright (c) 2017 Xored Software, Inc.

import planes, vector3

import internal.godotstrings

type
  Rect3* {.byref.} = object
    position*: Vector3
    size*: Vector3

proc initRect3*(pos, size: Vector3): Rect3 {.inline.} =
  Rect3(position: pos, size: size)

proc toGodotString(self: Rect3): GodotString {.
    noSideEffect,
    importc: "godot_rect3_as_string".}

proc `$`*(self: Rect3): string {.inline.} =
  $self.toGodotString()

proc area*(self: Rect3): float32 {.
    noSideEffect,
    importc: "godot_rect3_get_area".}
proc hasNoArea*(self: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_has_no_area".}
proc hasNoSurface*(self: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_has_no_surface".}
proc intersects*(a, b: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_intersects".}
proc encloses*(self, other: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_encloses".}
proc merge*(self, other: Rect3): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_merge".}
proc intersection*(self, other: Rect3): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_intersection".}
proc intersectsPlane*(self: Rect3; plane: Plane): bool {.
    noSideEffect,
    importc: "godot_rect3_intersects_plane".}
proc intersectsSegment*(self: Rect3; start, to: Vector3): bool {.
    noSideEffect,
    importc: "godot_rect3_intersects_segment".}
proc contains*(self: Rect3; point: Vector3): bool {.
    noSideEffect,
    importc: "godot_rect3_has_point".}
proc getSupport*(self: Rect3; dir: Vector3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_support".}
proc getLongestAxis*(self: Rect3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_longest_axis".}
proc getLongestAxisIndex*(self: Rect3): cint {.
    noSideEffect,
    importc: "godot_rect3_get_longest_axis_index".}
proc getLongestAxisSize*(self: Rect3): float32 {.
    noSideEffect,
    importc: "godot_rect3_get_longest_axis_size".}
proc getShortestAxis*(self: Rect3): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_shortest_axis".}
proc getShortestAxisIndex*(self: Rect3): cint {.
    noSideEffect,
    importc: "godot_rect3_get_shortest_axis_index".}
proc getShortestAxisSize*(self: Rect3): float32 {.
    noSideEffect,
    importc: "godot_rect3_get_shortest_axis_size".}
proc expand*(self: Rect3; toPoint: Vector3): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_expand".}
proc grow*(self: Rect3; by: float32): Rect3 {.
    noSideEffect,
    importc: "godot_rect3_grow".}
proc getEndpoint*(self: Rect3; idx: cint): Vector3 {.
    noSideEffect,
    importc: "godot_rect3_get_endpoint".}
proc `==`*(a, b: Rect3): bool {.
    noSideEffect,
    importc: "godot_rect3_operator_equal".}
