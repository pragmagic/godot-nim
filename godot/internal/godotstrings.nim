# Copyright (c) 2017 Xored Software, Inc.

type
  GodotString* {.byref.} = object
    p: pointer

proc initGodotString(dest: var GodotString) {.
    importc: "godot_string_new".}
proc initGodotString(dest: var GodotString; contents: cstring;
                      size: cint) {.
    importc: "godot_string_new_data".}
  ## Initializes ``dest`` from UTF-8 ``contents``
proc getData(self: GodotString; dest: cstring;
             size: var cint) {.
    noSideEffect
    importc: "godot_string_get_data".}
  ## Converts ``self`` into UTF-8 encoding, putting the result into ``dest``.

proc len*(self: GodotString): cint {.inline.} =
  ## Returns the length of string in bytes if it is represented as UTF-8.
  getData(self, nil, result)

proc cstring*(self: GodotString): cstring {.
    importc: "godot_string_c_str".}
proc `==`*(self, b: GodotString): bool {.
    importc: "godot_string_operator_equal".}
proc `<`*(self, b: GodotString): bool {.
    importc: "godot_string_operator_less".}
proc `&`*(self, b: GodotString): GodotString {.
    importc: "godot_string_operator_plus".}

proc deinit*(self: var GodotString) {.importc: "godot_string_destroy".}

proc `$`*(self: GodotString): string =
  ## Converts the ``GodotString`` into Nim string
  var length = self.len
  result = newStringOfCap(length)
  getData(self, addr result[0], length)
  result.setLen(length)
  assert(result[length] == '\0')

proc toGodotString*(s: string): GodotString {.inline.} =
  ## Converts the Nim string into ``GodotString``
  if s.isNil:
    initGodotString(result)
  else:
    initGodotString(result, unsafeAddr s[0], cint(s.len + 1))

proc toGodotString*(s: cstring): GodotString {.inline.} =
  ## Converts the cstring into ``GodotString``
  if s.isNil:
    initGodotString(result)
  else:
    initGodotString(result, s, cint(s.len + 1))
