# Copyright (c) 2017 Xored Software, Inc.

import vector2

import "../internal/godotstrings.nim"

type
  Rect2* {.byref.} = object
    position*: Vector2
    size*: Vector2

proc initRect2*(pos, size: Vector2): Rect2 {.inline.} =
  Rect2(position: pos, size: size)

proc initRect2*(x, y, sizeX, sizeY: float32): Rect2 {.inline.} =
  Rect2(position: vec2(x, y), size: vec2(sizeX, sizeY))

proc toGodotString(self: Rect2): GodotString {.
    noSideEffect,
    importc: "godot_rect2_as_string".}

proc `$`*(self: Rect2): string {.inline.} =
  $self.toGodotString()

proc area*(self: Rect2): float32 {.
    noSideEffect,
    importc: "godot_rect2_get_area".}
proc intersects*(a, b: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_intersects".}
proc encloses*(a, b: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_encloses".}
proc hasNoArea*(self: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_has_no_area".}
proc clip*(a, b: Rect2): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_clip".}
proc merge*(a, b: Rect2): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_merge".}
proc contains*(self: Rect2; point: Vector2): bool {.
    noSideEffect,
    importc: "godot_rect2_has_point".}
proc grow*(self: Rect2; by: float32): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_grow".}
proc expand*(self: Rect2; to: Vector2): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_expand".}
proc `==`*(a, b: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_operator_equal".}
