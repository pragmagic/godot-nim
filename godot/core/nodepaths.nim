# Copyright 2018 Xored Software, Inc.

import hashes

import internal/godotinternaltypes, internal/godotnodepaths,
       internal/godotstrings

type
  NodePath* = ref object
    path: GodotNodePath

proc nodePathFinalizer(path: NodePath) =
  path.path.deinit()

proc newNodePath*(path: GodotNodePath): NodePath =
  ## Moves the GodotNodePath into Nim wrapper. The ``path`` will be destroyed
  ## automatically when the result is no longer referenced.
  new(result, nodePathFinalizer)
  result.path = path

proc newNodePath*(s: string): NodePath =
  new(result, nodePathFinalizer)
  var str = s.toGodotString()
  initGodotNodePath(result.path, str)
  str.deinit()

proc godotNodePath*(path: NodePath): ptr GodotNodePath {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## ``path``
  result = addr path.path

proc `$`*(self: NodePath): string {.inline.} =
  var s = self.path.toGodotString()
  result = $s
  s.deinit()

proc hash*(self: NodePath): Hash {.inline.} =
  ($self).hash()

proc isAbsolute*(self: NodePath): bool {.inline.} =
  self.path.isAbsolute()

proc nameCount*(self: NodePath): int {.inline.} =
  int(self.path.nameCount())

proc getName*(self: NodePath; idx: int): string {.inline.} =
  var s = self.path.getName(idx.cint)
  result = $s
  s.deinit()

proc subnameCount*(self: NodePath): int {.inline.} =
  int(self.path.subnameCount())

proc getSubname*(self: NodePath; idx: int): string {.inline.} =
  var s = self.path.getSubname(idx.cint)
  result = $s
  s.deinit()

proc getConcatenatedSubnames*(self: NodePath): string {.inline.} =
  var s = self.path.getConcatenatedSubnames()
  result = $s
  s.deinit()

proc isEmpty*(self: NodePath): bool {.inline.} =
  self.path.isEmpty()

proc `==`*(a, b: NodePath): bool =
  if a.isNil and b.isNil: return true
  if a.isNil != b.isNil: return false
  result = a.path == b.path

converter fromString*(s: string): NodePath =
  newNodePath(s)
