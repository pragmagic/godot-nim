# Copyright (c) 2017 Xored Software, Inc.

import godotbase, strings

type
  NodePath* {.byref.} = object
    p: pointer

proc initNodePath(dest: var NodePath; s: GodotString) {.
    importc: "godot_node_path_new".}
proc initNodePath(dest: var NodePath;
                  src: NodePath) {.
    importc: "godot_node_path_new_copy".}
proc deinit(self: var NodePath) {.
    importc: "godot_node_path_destroy".}

proc initNodePath*(s: string): NodePath {.inline.} =
  initNodePath(result, s.toGodotString())

proc `=destroy`(self: NodePath) {.inline.} =
  unsafeAddr(self).deinit()

proc `=`(self: var NodePath, other: NodePath) {.inline.} =
  initNodePath(self, other)

proc toGodotString*(self: NodePath): GodotString {.
    importc: "godot_node_path_as_string".}
proc `$`*(self: NodePath): string {.inline.} =
  let s = self.toGodotString()
  result = $s

proc isAbsolute*(self: NodePath): bool {.
    importc: "godot_node_path_is_absolute".}
proc nameCount*(self: NodePath): cint {.
    importc: "godot_node_path_get_name_count".}
proc getName*(self: NodePath; idx: cint): GodotString {.
    importc: "godot_node_path_get_name".}
proc subnameCount*(self: NodePath): cint {.
    importc: "godot_node_path_get_subname_count".}
proc getSubname*(self: NodePath; idx: cint): GodotString {.
    importc: "godot_node_path_get_subname".}
proc property*(self: NodePath): GodotString {.
    importc: "godot_node_path_get_property".}
proc isEmpty*(self: NodePath): bool {.
    importc: "godot_node_path_is_empty".}

proc `==`*(a, b: NodePath): bool {.
    importc: "godot_node_path_operator_equal".}

converter fromString*(s: string): NodePath =
  initNodePath(result, s.toGodotString())
