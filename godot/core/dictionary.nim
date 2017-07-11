# Copyright (c) 2017 Xored Software, Inc.

import hashes
import godotbase, arrays, variant, strings

type
  Dictionary* {.importc: "godot_dictionary",
                header: "godot_dictionary.h", byref.} = object

proc initDictionary(dest: var Dictionary;
                    src: Dictionary) {.
    importc: "godot_dictionary_new_copy",
    header: "godot_dictionary.h".}

proc deinit(self: var Dictionary) {.
    importc: "godot_dictionary_destroy", header: "godot_dictionary.h".}

proc `=`(self: var Dictionary, other: Dictionary) {.inline.} =
  initDictionary(self, other)

proc `=destroy`(self: Dictionary) {.inline.} =
  unsafeAddr(self)[].deinit()

proc initDictionary(dest: var Dictionary) {.
    importc: "godot_dictionary_new", header: "godot_dictionary.h".}
proc initDictionary*(): Dictionary {.inline.} =
  initDictionary(result)

proc len*(self: Dictionary): cint {.
    importc: "godot_dictionary_size", header: "godot_dictionary.h".}
proc isEmpty*(self: Dictionary): bool {.
    importc: "godot_dictionary_empty", header: "godot_dictionary.h".}
proc clear*(self: var Dictionary) {.
    importc: "godot_dictionary_clear", header: "godot_dictionary.h".}
proc contains*(self: Dictionary; key: Variant): bool {.
    importc: "godot_dictionary_has",
    header: "godot_dictionary.h".}
proc contains*(self: Dictionary; keys: Array): bool {.
    importc: "godot_dictionary_has_all",
    header: "godot_dictionary.h".}
proc del*(self: var Dictionary; key: Variant) {.
    importc: "godot_dictionary_erase", header: "godot_dictionary.h".}

proc godotHash*(self: Dictionary): cint {.
    importc: "godot_dictionary_hash", header: "godot_dictionary.h".}
proc hash*(self: Dictionary): Hash {.inline.} =
  hash(godotHash(self))

proc keys*(self: Dictionary): Array {.
    importc: "godot_dictionary_keys", header: "godot_dictionary.h".}
proc values*(self: Dictionary): Array {.
    importc: "godot_dictionary_values", header: "godot_dictionary.h".}
proc `[]`*(self: Dictionary; key: Variant): Variant {.
    importc: "godot_dictionary_get", header: "godot_dictionary.h".}
proc `[]=`*(self: var Dictionary; key, value: Variant) {.
    importc: "godot_dictionary_set",
    header: "godot_dictionary.h".}
proc mget*(self: var Dictionary; key: Variant): ptr Variant {.
    importc: "godot_dictionary_operator_index",
    header: "godot_dictionary.h".}

proc `==`*(self, other: Dictionary): bool {.
    importc: "godot_dictionary_operator_equal",
    header: "godot_dictionary.h".}

proc toJson*(self: Dictionary): GodotString {.
    importc: "godot_dictionary_to_json", header: "godot_dictionary.h".}

iterator keys*(dict: Dictionary): Variant =
  let keyArr = dict.keys()
  for key in keyArr:
    yield key

iterator values*(dict: Dictionary): Variant =
  let valArr = dict.values()
  for val in valArr:
    yield val

iterator pairs*(dict: Dictionary): tuple[key, val: Variant] =
  for key in keys(dict):
    yield (key, dict[key])
