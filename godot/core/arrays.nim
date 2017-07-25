# Copyright (c) 2017 Xored Software, Inc.

import hashes
import godotbase, poolarray, variant, strings

proc initArray(dest: var Array) {.
    importc: "godot_array_new", header: "godot/array.h".}
proc initArray(dest: var Array; pca: PoolColorArray) {.
    importc: "godot_array_new_pool_coloarray",
    header: "godot/array.h".}
proc initArray(dest: var Array; pv3a: PoolVector3Array) {.
    importc: "godot_array_new_pool_vector3_array",
    header: "godot/array.h".}
proc initArray(dest: var Array; pv2a: PoolVector2Array) {.
    importc: "godot_array_new_pool_vector2_array",
    header: "godot/array.h".}
proc initArray(dest: var Array; psa: PoolStringArray) {.
    importc: "godot_array_new_pool_string_array",
    header: "godot/array.h".}
proc initArray(dest: var Array; pra: PoolRealArray) {.
    importc: "godot_array_new_pool_real_array",
    header: "godot/array.h".}
proc initArray(dest: var Array; pia: PoolIntArray) {.
    importc: "godot_array_new_pool_int_array",
    header: "godot/array.h".}
proc initArray(dest: var Array; pba: PoolByteArray) {.
    importc: "godot_array_new_pool_byte_array",
    header: "godot/array.h".}

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
    importc: "godot_array_set", header: "godot/array.h".}
proc `[]`*(self: Array; idx: cint): Variant {.
    noSideEffect,
    importc: "godot_array_get", header: "godot/array.h".}
proc mget*(self: var Array; idx: cint): ptr Variant {.
    importc: "godot_array_operator_index", header: "godot/array.h".}

proc add*(self: var Array; value: Variant) {.
    noSideEffect,
    importc: "godot_array_append", header: "godot/array.h".}
proc clear*(self: var Array) {.importc: "godot_array_clear",
                                    header: "godot/array.h".}
proc count*(self: Array; value: Variant): cint {.
    noSideEffect,
    importc: "godot_array_count", header: "godot/array.h".}
proc isEmpty*(self: Array): bool {.
    noSideEffect,
    importc: "godot_array_empty", header: "godot/array.h".}
proc erase*(self: var Array; value: Variant) {.
    importc: "godot_array_erase", header: "godot/array.h".}
proc first*(self: Array): Variant {.
    noSideEffect,
    importc: "godot_array_front", header: "godot/array.h".}
proc last*(self: Array): Variant {.
    noSideEffect,
    importc: "godot_array_back", header: "godot/array.h".}
proc find*(self: Array; what: Variant;
           f: cint): cint {.
    noSideEffect,
    importc: "godot_array_find", header: "godot/array.h".}
proc findLast*(self: Array; what: Variant): cint {.
    noSideEffect,
    importc: "godot_array_find_last", header: "godot/array.h".}
proc contains*(self: Array; value: Variant): bool {.
    noSideEffect,
    importc: "godot_array_has", header: "godot/array.h".}

proc godotHash*(self: Array): cint {.
    noSideEffect,
    importc: "godot_array_hash", header: "godot/array.h".}
proc hash*(self: Array): Hash {.inline.} =
  hash(godotHash(self))

proc insert*(self: var Array; pos: cint;
             value: Variant) {.
    importc: "godot_array_insert", header: "godot/array.h".}
proc reverse*(self: var Array) {.importc: "godot_array_invert",
    header: "godot/array.h".}
proc popLast*(self: var Array): Variant {.
    importc: "godot_array_pop_back", header: "godot/array.h".}
proc popFirst*(self: var Array): Variant {.
    importc: "godot_array_pop_front", header: "godot/array.h".}
proc addLast*(self: var Array; value: Variant) {.
    importc: "godot_array_push_back", header: "godot/array.h".}
proc addFirst*(self: var Array; value: Variant) {.
    importc: "godot_array_push_front", header: "godot/array.h".}

proc delete*(self: var Array; idx: cint) {.
    importc: "godot_array_remove", header: "godot/array.h".}
proc setLen*(self: var Array; size: cint) {.
    importc: "godot_array_resize", header: "godot/array.h".}
proc rfind*(self: Array; what: Variant;
            f: cint): cint {.
    noSideEffect,
    importc: "godot_array_rfind", header: "godot/array.h".}
proc len*(self: Array): cint {.
    noSideEffect,
    importc: "godot_array_size", header: "godot/array.h".}
proc sort*(self: var Array) {.importc: "godot_array_sort",
    header: "godot/array.h".}
proc sortCustom*(self: var Array; obj: var GodotObject;
                 funcName: GodotString) {.
    importc: "godot_array_sort_custom", header: "godot/array.h".}

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
