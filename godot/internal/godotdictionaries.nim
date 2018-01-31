# Copyright (c) 2018 Xored Software, Inc.

import godotinternaltypes, gdnativeapi

proc initGodotDictionary*(dest: var GodotDictionary) {.inline.} =
  getGDNativeAPI().dictionaryNew(dest)

proc initGodotDictionary*(dest: var GodotDictionary;
                          src: GodotDictionary) {.inline.} =
  getGDNativeAPI().dictionaryNewCopy(dest, src)

proc deinit*(self: var GodotDictionary) {.inline.} =
  getGDNativeAPI().dictionaryDestroy(self)

proc len*(self: GodotDictionary): cint {.inline.} =
  getGDNativeAPI().dictionarySize(self)

proc isEmpty*(self: GodotDictionary): bool {.inline.} =
  getGDNativeAPI().dictionaryEmpty(self)

proc clear*(self: var GodotDictionary) {.inline.} =
  getGDNativeAPI().dictionaryClear(self)

proc contains*(self: GodotDictionary; key: GodotVariant): bool {.inline.} =
  getGDNativeAPI().dictionaryHas(self, key)

proc contains*(self: GodotDictionary; keys: GodotArray): bool {.inline.} =
  getGDNativeAPI().dictionaryHasAll(self, keys)

proc del*(self: var GodotDictionary; key: GodotVariant) {.inline.} =
  getGDNativeAPI().dictionaryErase(self, key)

proc godotHash*(self: GodotDictionary): cint {.inline.} =
  getGDNativeAPI().dictionaryHash(self, )

proc keys*(self: GodotDictionary): GodotArray {.inline.} =
  getGDNativeAPI().dictionaryKeys(self)

proc values*(self: GodotDictionary): GodotArray {.inline.} =
  getGDNativeAPI().dictionaryValues(self)

proc `[]`*(self: GodotDictionary; key: GodotVariant): GodotVariant {.inline.} =
  getGDNativeAPI().dictionaryGet(self, key)

proc `[]=`*(self: var GodotDictionary; key, value: GodotVariant) {.inline.} =
  getGDNativeAPI().dictionarySet(self, key, value)

proc mget*(self: var GodotDictionary;
           key: GodotVariant): ptr GodotVariant {.inline.} =
  getGDNativeAPI().dictionaryOperatorIndex(self, key)

proc `==`*(self, other: GodotDictionary): bool {.inline.} =
  getGDNativeAPI().dictionaryOperatorEqual(self, other)

proc toJson*(self: GodotDictionary): GodotString {.inline.} =
  getGDNativeAPI().dictionaryToJson(self)
