# Copyright (c) 2018 Xored Software, Inc.

import godotinternaltypes, gdnativeapi

proc initGodotString(dest: var GodotString) {.inline, raises: [].} =
  getGDNativeAPI().stringNew(dest)

proc initGodotString(dest: var GodotString; contents: cstring;
                     size: cint) {.inline.} =
  ## Initializes ``dest`` from UTF-8 ``contents``
  dest = getGDNativeAPI().stringCharsToUtf8WithLen(contents, size)

proc `==`*(self, b: GodotString): bool {.inline.} =
  getGDNativeAPI().stringOperatorEqual(self, b)

proc `<`*(self, b: GodotString): bool {.inline.} =
  getGDNativeAPI().stringOperatorLess(self, b)

proc `&`*(self, b: GodotString): GodotString {.inline.} =
  getGDNativeAPI().stringOperatorPlus(self, b)

proc deinit*(self: var GodotString) {.inline.} =
  getGDNativeAPI().stringDestroy(self)

proc len*(self: GodotString): cint {.inline.} =
  getGDNativeAPI().stringLength(self)

proc dataPtr*(self: GodotString): ptr cwchar_t {.inline.} =
  getGDNativeAPI().stringWideStr(self)

proc `$`*(self: GodotString): string =
  ## Converts the ``GodotString`` into Nim string
  var charStr = getGDNativeAPI().stringUtf8(self)
  let length = getGDNativeAPI().charStringLength(charStr)
  result = newString(length)
  if length > 0:
    copyMem(addr result[0], getGDNativeAPI().charStringGetData(charStr), length)
  getGDNativeAPI().charStringDestroy(charStr)

proc toGodotString*(s: string): GodotString {.inline.} =
  ## Converts the Nim string into ``GodotString``
  when (NimMajor, NimMinor, NimPatch) < (0, 19, 0):
    if s.isNil:
      initGodotString(result)
    else:
      initGodotString(result, cstring(s), cint(s.len + 1))
  else:
    initGodotString(result, cstring(s), cint(s.len + 1))

proc toGodotString*(s: cstring): GodotString {.inline.} =
  ## Converts the cstring into ``GodotString``
  if s.isNil:
    initGodotString(result)
  else:
    initGodotString(result, s, cint(s.len + 1))
