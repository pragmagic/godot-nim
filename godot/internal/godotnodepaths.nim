# Copyright 2018 Xored Software, Inc.

import godotinternaltypes, gdnativeapi

proc initGodotNodePath*(dest: var GodotNodePath; s: GodotString) {.inline.} =
  getGDNativeAPI().nodePathNew(dest, s)

proc initGodotNodePath*(dest: var GodotNodePath;
                        src: GodotNodePath) {.inline.} =
  getGDNativeAPI().nodePathNewCopy(dest, src)

proc deinit*(self: var GodotNodePath) {.inline.} =
  getGDNativeAPI().nodePathDestroy(self)

proc toGodotString*(self: GodotNodePath): GodotString {.inline.} =
  getGDNativeAPI().nodePathAsString(self)

proc isAbsolute*(self: GodotNodePath): bool {.inline.} =
  getGDNativeAPI().nodePathIsAbsolute(self)

proc nameCount*(self: GodotNodePath): cint {.inline.} =
  getGDNativeAPI().nodePathGetNameCount(self)

proc getName*(self: GodotNodePath; idx: cint): GodotString {.inline.} =
  getGDNativeAPI().nodePathGetName(self, idx)

proc subnameCount*(self: GodotNodePath): cint {.inline.} =
  getGDNativeAPI().nodePathGetSubnameCount(self)

proc getSubname*(self: GodotNodePath; idx: cint): GodotString {.inline.} =
  getGDNativeAPI().nodePathGetSubname(self, idx)

proc getConcatenatedSubnames*(self: GodotNodePath): GodotString {.inline.} =
  getGDNativeAPI().nodePathGetConcatenatedSubnames(self)

proc isEmpty*(self: GodotNodePath): bool {.inline.} =
  getGDNativeAPI().nodePathIsEmpty(self)

proc `==`*(a, b: GodotNodePath): bool {.inline.} =
  getGDNativeAPI().nodePathOperatorEqual(a, b)
