# Copyright (c) 2017 Xored Software, Inc.

import godotbase, strings

type
  NodePath* {.importc: "godot_node_path",
              header: "godot/node_path.h", byref.} = object

proc initNodePath(dest: var NodePath; s: GodotString) {.
    importc: "godot_node_path_new", header: "godot/node_path.h".}
proc initNodePath(dest: var NodePath;
                  src: NodePath) {.
    importc: "godot_node_path_new_copy", header: "godot/node_path.h".}
proc deinit(self: var NodePath) {.
    importc: "godot_node_path_destroy", header: "godot/node_path.h".}

proc initNodePath*(s: string): NodePath {.inline.} =
  initNodePath(result, s.toGodotString())

proc `=destroy`(self: NodePath) {.inline.} =
  unsafeAddr(self).deinit()

proc `=`(self: var NodePath, other: NodePath) {.inline.} =
  initNodePath(self, other)

proc toGodotString*(self: NodePath): GodotString {.
    importc: "godot_node_path_as_string", header: "godot/node_path.h".}
proc `$`*(self: NodePath): string {.inline.} =
  let s = self.toGodotString()
  result = $s

proc isAbsolute*(self: NodePath): bool {.
    importc: "godot_node_path_is_absolute", header: "godot/node_path.h".}
proc nameCount*(self: NodePath): cint {.
    importc: "godot_node_path_get_name_count",
    header: "godot/node_path.h".}
proc getName*(self: NodePath; idx: cint): GodotString {.
    importc: "godot_node_path_get_name", header: "godot/node_path.h".}
proc subnameCount*(self: NodePath): cint {.
    importc: "godot_node_path_get_subname_count",
    header: "godot/node_path.h".}
proc getSubname*(self: NodePath; idx: cint): GodotString {.
    importc: "godot_node_path_get_subname",
    header: "godot/node_path.h".}
proc property*(self: NodePath): GodotString {.
    importc: "godot_node_path_get_property", header: "godot/node_path.h".}
proc isEmpty*(self: NodePath): bool {.
    importc: "godot_node_path_is_empty", header: "godot/node_path.h".}

proc `==`*(a, b: NodePath): bool {.
    importc: "godot_node_path_operator_equal",
    header: "godot/node_path.h".}

converter fromString*(s: string): NodePath =
  initNodePath(result, s.toGodotString())
