# Copyright (c) 2017 Xored Software, Inc.

import godotbase, vector2, strings

type
  Rect2* {.importc: "godot_rect2", header: "godot_rect2.h", byref.} = object

proc initRect2(dest: var Rect2; pos, size: Vector2) {.
    importc: "godot_rect2_new_with_position_and_size",
    header: "godot_rect2.h".}
proc initRect2(dest: var Rect2; x, y, sizeX, sizeY: float32) {.
    importc: "godot_rect2_new", header: "godot_rect2.h".}

proc initRect2*(pos, size: Vector2): Rect2 {.inline.} =
  initRect2(result, pos, size)

proc initRect2*(x, y, sizeX, sizeY: float32): Rect2 {.inline.} =
  initRect2(result, x, y, sizeX, sizeY)

proc toGodotString*(self: Rect2): GodotString {.
    noSideEffect,
    importc: "godot_rect2_as_string", header: "godot_rect2.h".}
proc `$`*(self: Rect2): string {.inline.} =
  $self.toGodotString()

proc area*(self: Rect2): float32 {.
    noSideEffect,
    importc: "godot_rect2_get_area", header: "godot_rect2.h".}
proc intersects*(a, b: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_intersects", header: "godot_rect2.h".}
proc encloses*(a, b: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_encloses", header: "godot_rect2.h".}
proc hasNoArea*(self: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_has_no_area", header: "godot_rect2.h".}
proc clip*(a, b: Rect2): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_clip", header: "godot_rect2.h".}
proc merge*(a, b: Rect2): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_merge", header: "godot_rect2.h".}
proc contains*(self: Rect2; point: Vector2): bool {.
    noSideEffect,
    importc: "godot_rect2_has_point", header: "godot_rect2.h".}
proc grow*(self: Rect2; by: float32): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_grow", header: "godot_rect2.h".}
proc expand*(self: Rect2; to: Vector2): Rect2 {.
    noSideEffect,
    importc: "godot_rect2_expand", header: "godot_rect2.h".}
proc `==`*(a, b: Rect2): bool {.
    noSideEffect,
    importc: "godot_rect2_operator_equal",
    header: "godot_rect2.h".}
proc position*(self: Rect2): Vector2 {.
    noSideEffect,
    importc: "godot_rect2_get_position", header: "godot_rect2.h".}
proc size*(self: Rect2): Vector2 {.
    noSideEffect,
    importc: "godot_rect2_get_size", header: "godot_rect2.h".}
proc setPosition*(self: var Rect2; pos: Vector2) {.
    noSideEffect,
    importc: "godot_rect2_set_position", header: "godot_rect2.h".}
proc setSize*(self: var Rect2; size: Vector2) {.
    noSideEffect,
    importc: "godot_rect2_set_size", header: "godot_rect2.h".}
