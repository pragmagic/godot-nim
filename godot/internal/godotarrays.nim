# Copyright (c) 2017 Xored Software, Inc.

type
  GodotArray* {.byref.} = object
    data: array[sizeof(int), byte]

proc len*(self: GodotArray): cint {.
    noSideEffect,
    importc: "godot_array_size".}

import hashes
import godotobjects, godotpoolarrays, godotvariants, godotstrings

proc initGodotArray*(dest: var GodotArray) {.
    importc: "godot_array_new".}
proc initGodotArray*(dest: var GodotArray; pca: GodotPoolColorArray) {.
    importc: "godot_array_new_pool_coloarray".}
proc initGodotArray*(dest: var GodotArray; pv3a: GodotPoolVector3Array) {.
    importc: "godot_array_new_pool_vector3_array".}
proc initGodotArray*(dest: var GodotArray; pv2a: GodotPoolVector2Array) {.
    importc: "godot_array_new_pool_vector2_array".}
proc initGodotArray*(dest: var GodotArray; psa: GodotPoolStringArray) {.
    importc: "godot_array_new_pool_string_array".}
proc initGodotArray*(dest: var GodotArray; pra: GodotPoolRealArray) {.
    importc: "godot_array_new_pool_real_array".}
proc initGodotArray*(dest: var GodotArray; pia: GodotPoolIntArray) {.
    importc: "godot_array_new_pool_int_array".}
proc initGodotArray*(dest: var GodotArray; pba: GodotPoolByteArray) {.
    importc: "godot_array_new_pool_byte_array".}
proc iniGodotArray*(dest: var GodotArray; src: GodotArray) {.
    importc: "godot_array_new_copy".}

proc deinit*(self: var GodotArray) {.importc: "godot_array_destroy".}

proc `[]=`*(self: var GodotArray; idx: cint;
            value: GodotVariant) {.
    noSideEffect,
    importc: "godot_array_set".}
proc `[]`*(self: GodotArray; idx: cint): GodotVariant {.
    noSideEffect,
    importc: "godot_array_get".}
proc mget*(self: var GodotArray; idx: cint): ptr GodotVariant {.
    importc: "godot_array_operator_index".}

proc add*(self: var GodotArray; value: GodotVariant) {.
    noSideEffect,
    importc: "godot_array_append".}
proc clear*(self: var GodotArray) {.importc: "godot_array_clear".}
proc count*(self: GodotArray; value: GodotVariant): cint {.
    noSideEffect,
    importc: "godot_array_count".}
proc isEmpty*(self: GodotArray): bool {.
    noSideEffect,
    importc: "godot_array_empty".}
proc erase*(self: var GodotArray; value: GodotVariant) {.
    importc: "godot_array_erase".}
proc first*(self: GodotArray): GodotVariant {.
    noSideEffect,
    importc: "godot_array_front".}
proc last*(self: GodotArray): GodotVariant {.
    noSideEffect,
    importc: "godot_array_back".}
proc find*(self: GodotArray; what: GodotVariant;
           f: cint): cint {.
    noSideEffect,
    importc: "godot_array_find".}
proc findLast*(self: GodotArray; what: GodotVariant): cint {.
    noSideEffect,
    importc: "godot_array_find_last".}
proc contains*(self: GodotArray; value: GodotVariant): bool {.
    noSideEffect,
    importc: "godot_array_has".}

proc godotHash*(self: GodotArray): cint {.
    noSideEffect,
    importc: "godot_array_hash".}
proc hash*(self: GodotArray): Hash {.inline.} =
  hash(godotHash(self))

proc insert*(self: var GodotArray; pos: cint;
             value: GodotVariant) {.
    importc: "godot_array_insert".}
proc reverse*(self: var GodotArray) {.importc: "godot_array_invert".}
proc popLast*(self: var GodotArray): GodotVariant {.
    importc: "godot_array_pop_back".}
proc popFirst*(self: var GodotArray): GodotVariant {.
    importc: "godot_array_pop_front".}
proc addLast*(self: var GodotArray; value: GodotVariant) {.
    importc: "godot_array_push_back".}
proc addFirst*(self: var GodotArray; value: GodotVariant) {.
    importc: "godot_array_push_front".}

proc delete*(self: var GodotArray; idx: cint) {.
    importc: "godot_array_remove".}
proc setLen*(self: var GodotArray; size: cint) {.
    importc: "godot_array_resize".}
proc rfind*(self: GodotArray; what: GodotVariant;
            f: cint): cint {.
    noSideEffect,
    importc: "godot_array_rfind".}
proc sort*(self: var GodotArray) {.importc: "godot_array_sort".}
proc sortCustom*(self: var GodotArray; obj: var GodotObject;
                 funcName: GodotString) {.
    importc: "godot_array_sort_custom".}

iterator items*(self: GodotArray): GodotVariant =
  for i in 0..<self.len:
    yield self[i]

iterator mitems*(self: var GodotArray): var GodotVariant =
  for i in 0..<self.len:
    yield self.mget(i)[]

iterator pairs*(self: GodotArray): tuple[key: cint, val: GodotVariant] =
  for i in 0..<self.len:
    yield (i, self[i])

iterator mpairs*(self: var GodotArray): tuple[key: cint,
                                              val: var GodotVariant] =
  for i in 0..<self.len:
    yield (i, self.mget(i)[])

proc `$`*(self: GodotArray): string =
  result = newStringOfCap(32)
  result.add('[')
  for item in self:
    if result.len > 1:
      result.add(", ")
    result.add($item)
  result.add(']')
