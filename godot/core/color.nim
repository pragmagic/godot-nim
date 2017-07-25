# Copyright (c) 2017 Xored Software, Inc.

import godotbase, strings

type
  Color* {.importc: "godot_color", header: "godot/color.h", byref.} = object

proc initColor(dest: var Color; r, g, b, a: float32) {.
    importc: "godot_color_new_rgba", header: "godot/color.h".}
proc initColor(dest: var Color; r, g, b: float32) {.
    importc: "godot_color_new_rgb",
    header: "godot/color.h".}

proc initColor*(r, g, b, a: float32): Color {.inline.} =
  initColor(result, r, g, b, a)

proc initColor*(r, g, b: float32): Color {.inline.} =
  initColor(result, r, g, b)

proc r*(self: Color): float32 {.
    importc: "godot_color_get_r", header: "godot/color.h".}
proc `r=`*(self: var Color; r: float32) {.
    importc: "godot_color_set_r", header: "godot/color.h".}
proc g*(self: Color): float32 {.
    importc: "godot_color_get_g", header: "godot/color.h".}
proc `g=`*(self: var Color; g: float32) {.
    importc: "godot_color_set_g", header: "godot/color.h".}
proc b*(self: Color): float32 {.
    importc: "godot_color_get_b", header: "godot/color.h".}
proc `b=`*(self: var Color; b: float32) {.
    importc: "godot_color_set_b", header: "godot/color.h".}
proc a*(self: Color): float32 {.
    importc: "godot_color_get_a", header: "godot/color.h".}
proc `a=`*(self: var Color; a: float32) {.
    importc: "godot_color_set_a", header: "godot/color.h".}

proc h*(self: Color): float32 {.
    importc: "godot_color_get_h", header: "godot/color.h".}
proc s*(self: Color): float32 {.
    importc: "godot_color_get_s", header: "godot/color.h".}
proc v*(self: Color): float32 {.
    importc: "godot_color_get_v", header: "godot/color.h".}

proc toGodotString*(self: Color): GodotString {.
    importc: "godot_color_as_string", header: "godot/color.h".}
proc `$`*(self: Color): string {.inline.} =
  $self.toGodotString()

proc toHtml*(self: Color; with_alpha: bool): GodotString {.
    importc: "godot_color_to_html", header: "godot/color.h".}

proc to32CInt(self: Color): cint {.
    importc: "godot_color_to_32", header: "godot/color.h".}
proc toARGB32CInt(self: Color): cint {.
    importc: "godot_color_to_ARGB32", header: "godot/color.h".}

proc to32*(self: Color): uint32 {.inline.}=
  cast[uint32](to32CInt(self))
proc toARGB32*(self: Color): uint32 {.inline.} =
  cast[uint32](toARGB32CInt(self))

proc gray*(self: Color): float32 {.
    importc: "godot_color_gray", header: "godot/color.h".}
proc inverted*(self: Color): Color {.
    importc: "godot_color_inverted", header: "godot/color.h".}
proc contrasted*(self: Color): Color {.
    importc: "godot_color_contrasted", header: "godot/color.h".}
proc lerp*(self: Color; b: Color; t: float32): Color {.
    importc: "godot_color_linear_interpolate", header: "godot/color.h".}
proc blend*(self: Color; over: Color): Color {.
    importc: "godot_color_blend", header: "godot/color.h".}

proc `==`*(self, b: Color): bool {.
    importc: "godot_color_operator_equal", header: "godot/color.h".}
proc `<`*(self, b: Color): bool {.
    importc: "godot_color_operator_less", header: "godot/color.h".}
