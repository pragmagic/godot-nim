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

proc `$`*(self: GodotString): string =
  ## Converts the ``GodotString`` into Nim string
  var charStr = getGDNativeAPI().stringUtf8(self)
  let length = getGDNativeAPI().charStringLength(charStr)
  result = newString(length)
  copyMem(addr result[0], getGDNativeAPI().charStringGetData(charStr), length)
  getGDNativeAPI().charStringDestroy(charStr)
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
