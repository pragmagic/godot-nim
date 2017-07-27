# Copyright (c) 2017 Xored Software, Inc.

import hashes
import godotbase, poolarray, variant, strings

proc initArray(dest: var Array) {.
    importc: "godot_array_new".}
proc initArray(dest: var Array; pca: PoolColorArray) {.
    importc: "godot_array_new_pool_coloarray".}
proc initArray(dest: var Array; pv3a: PoolVector3Array) {.
    importc: "godot_array_new_pool_vector3_array".}
proc initArray(dest: var Array; pv2a: PoolVector2Array) {.
    importc: "godot_array_new_pool_vector2_array".}
proc initArray(dest: var Array; psa: PoolStringArray) {.
    importc: "godot_array_new_pool_string_array".}
proc initArray(dest: var Array; pra: PoolRealArray) {.
    importc: "godot_array_new_pool_real_array".}
proc initArray(dest: var Array; pia: PoolIntArray) {.
    importc: "godot_array_new_pool_int_array".}
proc initArray(dest: var Array; pba: PoolByteArray) {.
    importc: "godot_array_new_pool_byte_array".}

proc initArray*(): Array {.inline.} =
  initArray(result)

proc initArray*(pca: PoolColorArray): Array {.inline.} =
  initArray(result, pca)

proc initArray*(pv3a: PoolVector3Array): Array {.inline.} =
  initArray(result, pv3a)

proc initArray*(pv2a: PoolVector2Array): Array {.inline.} =
  initArray(result, pv2a)

proc initArray*(psa: PoolStringArray): Array {.inline.} =
  initArray(result, psa)

proc initArray*(pra: PoolRealArray): Array {.inline.} =
  initArray(result, pra)

proc initArray*(pia: PoolIntArray): Array {.inline.} =
  initArray(result, pia)

proc initArray*(pba: PoolByteArray): Array {.inline.} =
  initArray(result, pba)

proc `[]=`*(self: var Array; idx: cint;
            value: Variant) {.
    noSideEffect,
    importc: "godot_array_set".}
proc `[]`*(self: Array; idx: cint): Variant {.
    noSideEffect,
    importc: "godot_array_get".}
proc mget*(self: var Array; idx: cint): ptr Variant {.
    importc: "godot_array_operator_index".}

proc add*(self: var Array; value: Variant) {.
    noSideEffect,
    importc: "godot_array_append".}
proc clear*(self: var Array) {.importc: "godot_array_clear".}
proc count*(self: Array; value: Variant): cint {.
    noSideEffect,
    importc: "godot_array_count".}
proc isEmpty*(self: Array): bool {.
    noSideEffect,
    importc: "godot_array_empty".}
proc erase*(self: var Array; value: Variant) {.
    importc: "godot_array_erase".}
proc first*(self: Array): Variant {.
    noSideEffect,
    importc: "godot_array_front".}
proc last*(self: Array): Variant {.
    noSideEffect,
    importc: "godot_array_back".}
proc find*(self: Array; what: Variant;
           f: cint): cint {.
    noSideEffect,
    importc: "godot_array_find".}
proc findLast*(self: Array; what: Variant): cint {.
    noSideEffect,
    importc: "godot_array_find_last".}
proc contains*(self: Array; value: Variant): bool {.
    noSideEffect,
    importc: "godot_array_has".}

proc godotHash*(self: Array): cint {.
    noSideEffect,
    importc: "godot_array_hash".}
proc hash*(self: Array): Hash {.inline.} =
  hash(godotHash(self))

proc insert*(self: var Array; pos: cint;
             value: Variant) {.
    importc: "godot_array_insert".}
proc reverse*(self: var Array) {.importc: "godot_array_invert".}
proc popLast*(self: var Array): Variant {.
    importc: "godot_array_pop_back".}
proc popFirst*(self: var Array): Variant {.
    importc: "godot_array_pop_front".}
proc addLast*(self: var Array; value: Variant) {.
    importc: "godot_array_push_back".}
proc addFirst*(self: var Array; value: Variant) {.
    importc: "godot_array_push_front".}

proc delete*(self: var Array; idx: cint) {.
    importc: "godot_array_remove".}
proc setLen*(self: var Array; size: cint) {.
    importc: "godot_array_resize".}
proc rfind*(self: Array; what: Variant;
            f: cint): cint {.
    noSideEffect,
    importc: "godot_array_rfind".}
proc len*(self: Array): cint {.
    noSideEffect,
    importc: "godot_array_size".}
proc sort*(self: var Array) {.importc: "godot_array_sort".}
proc sortCustom*(self: var Array; obj: var GodotObject;
                 funcName: GodotString) {.
    importc: "godot_array_sort_custom".}

iterator items*(arr: Array): Variant =
  for i in 0..<arr.len:
    yield arr[i]

iterator mitems*(arr: var Array): var Variant =
  for i in 0..<arr.len:
    yield arr.mget(i)[]

iterator pairs*(arr: Array): tuple[key: cint, val: Variant] =
  for i in 0..<arr.len:
    yield (i, arr[i])

iterator mpairs*(arr: var Array): tuple[key: cint, val: var Variant] =
  for i in 0..<arr.len:
    yield (i, arr.mget(i)[])
