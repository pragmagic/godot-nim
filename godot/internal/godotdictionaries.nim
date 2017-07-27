# Copyright (c) 2017 Xored Software, Inc.

type
  GodotDictionary* {.byref.} = object
    p: pointer

import godotinternaltypes, godotarrays, godotvariants, godotstrings

proc initGodotDictionary*(dest: var GodotDictionary; src: GodotDictionary) {.
    importc: "godot_dictionary_new_copy".}

proc deinit*(self: var GodotDictionary) {.
    importc: "godot_dictionary_destroy".}

proc initGodotDictionary*(dest: var GodotDictionary) {.
    importc: "godot_dictionary_new".}

proc len*(self: GodotDictionary): cint {.
    importc: "godot_dictionary_size".}
proc isEmpty*(self: GodotDictionary): bool {.
    importc: "godot_dictionary_empty".}
proc clear*(self: var GodotDictionary) {.
    importc: "godot_dictionary_clear".}
proc contains*(self: GodotDictionary; key: GodotVariant): bool {.
    importc: "godot_dictionary_has".}
proc contains*(self: GodotDictionary; keys: GodotArray): bool {.
    importc: "godot_dictionary_has_all".}
proc del*(self: var GodotDictionary; key: GodotVariant) {.
    importc: "godot_dictionary_erase".}

proc godotHash*(self: GodotDictionary): cint {.
    importc: "godot_dictionary_hash".}
proc keys*(self: GodotDictionary): GodotArray {.
    importc: "godot_dictionary_keys".}
proc values*(self: GodotDictionary): GodotArray {.
    importc: "godot_dictionary_values".}
proc `[]`*(self: GodotDictionary; key: GodotVariant): GodotVariant {.
    importc: "godot_dictionary_get".}
proc `[]=`*(self: var GodotDictionary; key, value: GodotVariant) {.
    importc: "godot_dictionary_set".}
proc mget*(self: var GodotDictionary; key: GodotVariant): ptr GodotVariant {.
    importc: "godot_dictionary_operator_index".}

proc `==`*(self, other: GodotDictionary): bool {.
    importc: "godot_dictionary_operator_equal".}

proc toJson*(self: GodotDictionary): GodotString {.
    importc: "godot_dictionary_to_json".}
