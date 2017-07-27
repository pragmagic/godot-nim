# Copyright 2017 Xored Software, Inc.

import godotstrings

type
  GodotNodePath* {.byref.} = object
    p: pointer

proc initGodotNodePath*(dest: var GodotNodePath; s: GodotString) {.
    importc: "godot_node_path_new".}
proc deinit*(self: var GodotNodePath) {.
    importc: "godot_node_path_destroy".}
proc toGodotString*(self: GodotNodePath): GodotString {.
    importc: "godot_node_path_as_string".}

proc isAbsolute*(self: GodotNodePath): bool {.
    noSideEffect, importc: "godot_node_path_is_absolute".}
proc nameCount*(self: GodotNodePath): cint {.
    noSideEffect, importc: "godot_node_path_get_name_count".}
proc getName*(self: GodotNodePath; idx: cint): GodotString {.
    noSideEffect, importc: "godot_node_path_get_name".}
proc subnameCount*(self: GodotNodePath): cint {.
    noSideEffect, importc: "godot_node_path_get_subname_count".}
proc getSubname*(self: GodotNodePath; idx: cint): GodotString {.
    noSideEffect, importc: "godot_node_path_get_subname".}
proc property*(self: GodotNodePath): GodotString {.
    noSideEffect, importc: "godot_node_path_get_property".}
proc isEmpty*(self: GodotNodePath): bool {.
    noSideEffect, importc: "godot_node_path_is_empty".}

proc `==`*(a, b: GodotNodePath): bool {.
    noSideEffect, importc: "godot_node_path_operator_equal".}
