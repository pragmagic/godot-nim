# Copyright (c) 2017 Xored Software, Inc.

import godotbase

type
  GodotString* {.importc: "godot_string", header: "godot/string.h",
                 byref.} = object

proc initGodotString(dest: var GodotString) {.
    importc: "godot_string_new", header: "godot/string.h".}
proc initGodotString(dest: var GodotString; src: GodotString) {.
    importc: "godot_string_new_copy", header: "godot/string.h".}
proc initGodotString(dest: var GodotString; contents: cstring;
                      size: cint) {.
    importc: "godot_string_new_data", header: "godot/string.h".}
  ## Initializes ``dest`` from UTF-8 ``contents``
proc getData(self: GodotString; dest: cstring;
             size: var cint) {.
    noSideEffect
    importc: "godot_string_get_data",
    header: "godot/string.h".}
  ## Converts ``self`` into UTF-8 encoding, putting the result into ``dest``.

proc len*(self: GodotString): cint {.inline.} =
  ## Returns the length of string in bytes if it is represented as UTF-8.
  getData(self, nil, result)

proc cstring*(self: GodotString): cstring {.
    importc: "godot_string_c_str", header: "godot/string.h".}
proc `==`*(self, b: GodotString): bool {.
    importc: "godot_string_operator_equal",
    header: "godot/string.h".}
proc `<`*(self, b: GodotString): bool {.
    importc: "godot_string_operator_less",
    header: "godot/string.h".}
proc `&`*(self, b: GodotString): GodotString {.
    importc: "godot_string_operator_plus",
    header: "godot/string.h".}

proc deinit*(self: var GodotString) {.importc: "godot_string_destroy",
                                      header: "godot/string.h".}
proc `=destroy`(self: GodotString) {.inline.} =
  unsafeAddr(self).deinit()

proc `=`(self: var GodotString, other: GodotString) {.inline.} =
  initGodotString(self, other)

proc `$`*(self: GodotString): string =
  ## Converts the ``GodotString`` into Nim string
  var length = self.len
  result = newStringOfCap(length)
  getData(self, addr result[0], length)
  result.setLen(length)
  assert(result[length] == '\0')

proc toGodotString*(s: string): GodotString {.inline.} =
  ## Converts the Nim string into ``GodotString``
  initGodotString(result, unsafeAddr s[0], cint(s.len + 1))

proc toGodotString*(s: cstring): GodotString {.inline.} =
  ## Converts the cstring into ``GodotString``
  initGodotString(result, s, cint(s.len + 1))
