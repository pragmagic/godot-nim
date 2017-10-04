# Copyright (c) 2017 Xored Software, Inc.

import godotinternaltypes, gdnativeapi

proc initGodotString(dest: var GodotString) {.inline, raises: [].} =
  getGDNativeAPI().stringNew(dest)

proc initGodotString(dest: var GodotString; contents: cstring;
                     size: cint) {.inline.} =
  ## Initializes ``dest`` from UTF-8 ``contents``
  getGDNativeAPI().stringNewData(dest, contents, size)

proc getData(self: GodotString; dest: cstring;
             size: var cint) {.inline.} =
  ## Converts ``self`` into UTF-8 encoding, putting the result into ``dest``.
  getGDNativeAPI().stringGetData(self, dest, size)

proc len*(self: GodotString): cint {.inline.} =
  ## Returns the length of string in bytes if it is represented as UTF-8.
  getData(self, nil, result)

proc cstring*(self: GodotString): cstring {.inline.} =
  getGDNativeAPI().stringCStr(self)

proc `==`*(self, b: GodotString): bool {.inline.} =
  getGDNativeAPI().stringOperatorEqual(self, b)

proc `<`*(self, b: GodotString): bool {.inline.} =
  getGDNativeAPI().stringOperatorLess(self, b)

proc `&`*(self, b: GodotString): GodotString {.inline.} =
  getGDNativeAPI().stringOperatorPlus(self, b)

proc deinit*(self: var GodotString) {.inline.} =
  getGDNativeAPI().stringDestroy(self)

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
