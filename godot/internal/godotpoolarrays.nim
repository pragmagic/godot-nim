# Copyright (c) 2017 Xored Software, Inc.

type
  GodotPoolByteArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolIntArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolRealArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolStringArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolVector2Array* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolVector3Array* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolColorArray* {.byref.} = object
    data: array[sizeof(int), byte]

import godotstrings, godotarrays
import core.godotbase, core.colors, core.vector2, core.vector3

# byte

proc initGodotPoolByteArray*(dest: var GodotPoolByteArray) {.
    importc: "godot_pool_byte_array_new".}
proc initGodotPoolByteArray*(dest: var GodotPoolByteArray;
                       src: GodotPoolByteArray) {.
    importc: "godot_pool_byte_array_new_copy".}
proc initGodotPoolByteArray*(dest: var GodotPoolByteArray; arr: GodotArray) {.
    importc: "godot_pool_byte_array_new_with_array".}

proc deinit*(self: var GodotPoolByteArray) {.
    importc: "godot_pool_byte_array_destroy".}

proc add*(self: var GodotPoolByteArray;
          data: uint8) {.
    importc: "godot_pool_byte_array_append".}
proc addFirst*(self: var GodotPoolByteArray, data: uint8) {.
    importc: "godot_pool_byte_array_push_back".}
proc add*(self: var GodotPoolByteArray;
          arr: GodotPoolByteArray) {.
    importc: "godot_pool_byte_array_append_array".}
proc insert*(self: var GodotPoolByteArray; idx: cint;
             data: uint8): Error {.
    importc: "godot_pool_byte_array_insert".}
proc delete*(self: var GodotPoolByteArray; idx: cint) {.
    importc: "godot_pool_byte_array_remove".}

proc reverse*(self: var GodotPoolByteArray) {.
    importc: "godot_pool_byte_array_invert".}
proc setLen*(self: var GodotPoolByteArray; size: cint) {.
    importc: "godot_pool_byte_array_resize".}

proc `[]=`*(self: var GodotPoolByteArray; idx: cint; data: uint8) {.
    importc: "godot_pool_byte_array_set".}
proc `[]`*(self: GodotPoolByteArray; idx: cint): uint8 {.
    noSideEffect,
    importc: "godot_pool_byte_array_get".}
proc len*(self: GodotPoolByteArray): cint {.
    noSideEffect,
    importc: "godot_pool_byte_array_size".}

iterator items*(arr: GodotPoolByteArray): byte =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: GodotPoolByteArray): tuple[key: cint, val: byte] =
  for i in 0..<arr.len:
    yield (i, arr[i])

proc initGodotPoolIntArray*(dest: var GodotPoolIntArray) {.
    importc: "godot_pool_int_array_new".}
proc initGodotPoolIntArray*(dest: var GodotPoolIntArray;
                      src: GodotPoolIntArray) {.
    importc: "godot_pool_int_array_new_copy".}
proc initGodotPoolIntArray*(dest: var GodotPoolIntArray;
                           arr: GodotArray) {.
   importc: "godot_pool_int_array_new_with_array".}
proc deinit*(self: var GodotPoolIntArray) {.
   importc: "godot_pool_int_array_destroy".}

proc add*(self: var GodotPoolIntArray; data: cint) {.
    importc: "godot_pool_int_array_append".}
proc addFirst*(self: var GodotPoolIntArray; data: cint) {.
    importc: "godot_pool_int_array_push_back".}
proc add*(self: var GodotPoolIntArray; arr: GodotPoolIntArray) {.
    importc: "godot_pool_int_array_append_array".}
proc insert*(self: var GodotPoolIntArray; idx: cint;
             data: cint): Error {.
    importc: "godot_pool_int_array_insert".}
proc delete*(self: var GodotPoolIntArray; idx: cint) {.
    importc: "godot_pool_int_array_remove".}
proc reverse*(self: var GodotPoolIntArray) {.
    importc: "godot_pool_int_array_invert".}

proc setLen*(self: var GodotPoolIntArray; size: cint) {.
    importc: "godot_pool_int_array_resize".}
proc `[]=`*(self: var GodotPoolIntArray; idx: cint; data: cint) {.
    importc: "godot_pool_int_array_set".}
proc `[]`*(self: GodotPoolIntArray; idx: cint): cint {.
    noSideEffect,
    importc: "godot_pool_int_array_get".}
proc len*(self: GodotPoolIntArray): cint {.
    noSideEffect,
    importc: "godot_pool_int_array_size".}

iterator items*(arr: GodotPoolIntArray): cint =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: GodotPoolIntArray): tuple[key: cint, val: cint] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Real

proc initGodotPoolRealArray*(dest: var GodotPoolRealArray) {.
    importc: "godot_pool_real_array_new".}
proc initGodotPoolRealArray*(dest: var GodotPoolRealArray;
                       src: GodotPoolRealArray) {.
    importc: "godot_pool_real_array_new_copy".}
proc initGodotPoolRealArray*(dest: var GodotPoolRealArray; arr: GodotArray) {.
    importc: "godot_pool_real_array_new_with_array".}

proc deinit*(self: var GodotPoolRealArray) {.
    importc: "godot_pool_real_array_destroy".}

proc add*(self: var GodotPoolRealArray; data: float32) {.
    importc: "godot_pool_real_array_append".}
proc addFirst*(self: var GodotPoolRealArray; data: float32) {.
    importc: "godot_pool_real_array_push_back".}
proc add*(self: var GodotPoolRealArray; arr: GodotPoolRealArray) {.
    importc: "godot_pool_real_array_append_array".}
proc insert*(self: var GodotPoolRealArray;
             idx: cint; data: float32): Error {.
    importc: "godot_pool_real_array_insert".}
proc delete*(self: var GodotPoolRealArray; idx: cint) {.
    importc: "godot_pool_real_array_remove".}
proc reverse*(self: var GodotPoolRealArray) {.
    importc: "godot_pool_real_array_invert".}
proc setLen*(self: var GodotPoolRealArray; size: cint) {.
    importc: "godot_pool_real_array_resize".}
proc `[]=`*(self: var GodotPoolRealArray; idx: cint; data: float32) {.
    importc: "godot_pool_real_array_set".}
proc `[]`*(self: GodotPoolRealArray; idx: cint): float32 {.
    noSideEffect,
    importc: "godot_pool_real_array_get".}
proc len*(self: GodotPoolRealArray): cint {.
    noSideEffect,
    importc: "godot_pool_real_array_size".}

iterator items*(arr: GodotPoolRealArray): float32 =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: GodotPoolRealArray): tuple[key: cint, val: float32] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# String

proc initGodotPoolStringArray*(dest: var GodotPoolStringArray) {.
    importc: "godot_pool_string_array_new".}
proc initGodotPoolStringArray*(dest: var GodotPoolStringArray;
                         src: GodotPoolStringArray) {.
    importc: "godot_pool_string_array_new_copy".}
proc initGodotPoolStringArray*(dest: var GodotPoolStringArray; arr: GodotArray) {.
    importc: "godot_pool_string_array_new_with_array".}

proc deinit*(self: var GodotPoolStringArray) {.
    importc: "godot_pool_string_array_destroy".}

proc initGodotPoolStringArray*(): GodotPoolStringArray {.inline.} =
  initGodotPoolStringArray(result)

proc initGodotPoolStringArray*(arr: GodotArray): GodotPoolStringArray {.inline.} =
  initGodotPoolStringArray(result, arr)

proc add*(self: var GodotPoolStringArray; data: GodotString) {.
    importc: "godot_pool_string_array_append".}
proc addFirst*(self: var GodotPoolStringArray; data: GodotString) {.
    importc: "godot_pool_string_array_push_back".}
proc add*(self: var GodotPoolStringArray; arr: GodotPoolStringArray) {.
    importc: "godot_pool_string_array_append_array".}
proc insert*(self: var GodotPoolStringArray;
             idx: cint; data: GodotString): Error {.
    importc: "godot_pool_string_array_insert".}
proc delete*(self: var GodotPoolStringArray; idx: cint) {.
    importc: "godot_pool_string_array_remove".}
proc reverse*(self: var GodotPoolStringArray) {.
    importc: "godot_pool_string_array_invert".}
proc setLen*(self: var GodotPoolStringArray; size: cint) {.
    importc: "godot_pool_string_array_resize".}
proc `[]=`*(self: var GodotPoolStringArray; idx: cint;
            data: GodotString) {.
    importc: "godot_pool_string_array_set".}
proc `[]`*(self: GodotPoolStringArray; idx: cint): GodotString {.
    noSideEffect,
    importc: "godot_pool_string_array_get".}
proc len*(self: GodotPoolStringArray): cint {.
    noSideEffect,
    importc: "godot_pool_string_array_size".}

iterator items*(arr: GodotPoolStringArray): GodotString =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: GodotPoolStringArray): tuple[key: cint, val: GodotString] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Vector2

proc initGodotPoolVector2Array*(dest: var GodotPoolVector2Array) {.
    importc: "godot_pool_vector2_array_new".}
proc initGodotPoolVector2Array*(dest: var GodotPoolVector2Array;
                          src: GodotPoolVector2Array) {.
    importc: "godot_pool_vector2_array_new_copy".}
proc initGodotPoolVector2Array*(dest: var GodotPoolVector2Array;
                                arr: GodotArray) {.
    importc: "godot_pool_vector2_array_new_with_array".}

proc deinit*(self: var GodotPoolVector2Array) {.
    importc: "godot_pool_vector2_array_destroy".}

proc initGodotPoolVector2Array*(): GodotPoolVector2Array {.inline.} =
  initGodotPoolVector2Array(result)

proc initGodotPoolVector2Array*(arr: GodotArray): GodotPoolVector2Array {.inline.} =
  initGodotPoolVector2Array(result, arr)

proc add*(self: var GodotPoolVector2Array; data: Vector2) {.
    importc: "godot_pool_vector2_array_append".}
proc addFirst*(self: var GodotPoolVector2Array; data: Vector2) {.
    importc: "godot_pool_vector2_array_push_back".}
proc add*(self: var GodotPoolVector2Array;
          arr: GodotPoolVector2Array) {.
    importc: "godot_pool_vector2_array_append_array".}
proc insert*(self: var GodotPoolVector2Array;
             idx: cint; data: Vector2): Error {.
    importc: "godot_pool_vector2_array_insert".}
proc delete*(self: var GodotPoolVector2Array; idx: cint) {.
    importc: "godot_pool_vector2_array_remove".}
proc reverse*(self: var GodotPoolVector2Array) {.
    importc: "godot_pool_vector2_array_invert".}
proc setLen*(self: var GodotPoolVector2Array; size: cint) {.
    importc: "godot_pool_vector2_array_resize".}
proc `[]=`*(self: var GodotPoolVector2Array; idx: cint;
            data: Vector2) {.
    importc: "godot_pool_vector2_array_set".}
proc `[]`*(self: GodotPoolVector2Array; idx: cint): Vector2 {.
    noSideEffect,
    importc: "godot_pool_vector2_array_get".}
proc len*(self: GodotPoolVector2Array): cint {.
    noSideEffect,
    importc: "godot_pool_vector2_array_size".}

iterator items*(arr: GodotPoolVector2Array): Vector2 =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: GodotPoolVector2Array): tuple[key: cint, val: Vector2] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Vector3

proc initGodotPoolVector3Array*(dest: var GodotPoolVector3Array) {.
    importc: "godot_pool_vector3_array_new".}
proc initGodotPoolVector3Array*(dest: var GodotPoolVector3Array;
                           src: GodotPoolVector3Array) {.
    importc: "godot_pool_vector3_array_new_copy".}
proc initGodotPoolVector3Array*(dest: var GodotPoolVector3Array;
                                arr: GodotArray) {.
    importc: "godot_pool_vector3_array_new_with_array".}

proc deinit*(self: var GodotPoolVector3Array) {.
    importc: "godot_pool_vector3_array_destroy".}

proc initGodotPoolVector3Array*(): GodotPoolVector3Array {.inline.} =
  initGodotPoolVector3Array(result)

proc initGodotPoolVector3Array*(arr: GodotArray):
    GodotPoolVector3Array {.inline.} =
  initGodotPoolVector3Array(result, arr)

proc add*(self: var GodotPoolVector3Array;
          data: Vector3) {.
    importc: "godot_pool_vector3_array_append".}
proc addFirst*(self: var GodotPoolVector3Array;
               data: Vector3) {.
    importc: "godot_pool_vector3_array_push_back".}
proc add*(self: var GodotPoolVector3Array;
          arr: GodotPoolVector3Array) {.
    importc: "godot_pool_vector3_array_append_array".}
proc insert*(self: var GodotPoolVector3Array;
             idx: cint; data: Vector3): Error {.
    importc: "godot_pool_vector3_array_insert".}
proc delete*(self: var GodotPoolVector3Array; idx: cint) {.
    importc: "godot_pool_vector3_array_remove".}
proc reverse*(self: var GodotPoolVector3Array) {.
    importc: "godot_pool_vector3_array_invert".}
proc setLen*(self: var GodotPoolVector3Array; size: cint) {.
    importc: "godot_pool_vector3_array_resize".}
proc `[]=`*(self: var GodotPoolVector3Array;
            idx: cint; data: Vector3) {.
    importc: "godot_pool_vector3_array_set".}
proc `[]`*(self: GodotPoolVector3Array;
           idx: cint): Vector3 {.
    noSideEffect,
    importc: "godot_pool_vector3_array_get".}
proc len*(self: GodotPoolVector3Array): cint {.
    noSideEffect,
    importc: "godot_pool_vector3_array_size".}

iterator items*(arr: GodotPoolVector3Array): Vector3 =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: GodotPoolVector3Array): tuple[key: cint, val: Vector3] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Color

proc initGodotPoolColorArray*(dest: var GodotPoolColorArray) {.
    importc: "godot_pool_color_array_new".}
proc initGodotPoolColorArray*(dest: var GodotPoolColorArray;
                        src: GodotPoolColorArray) {.
    importc: "godot_pool_color_array_new_copy".}
proc initGodotPoolColorArray*(dest: var GodotPoolColorArray; arr: GodotArray) {.
    importc: "godot_pool_color_array_new_with_array".}

proc deinit*(self: var GodotPoolColorArray) {.
    importc: "godot_pool_color_array_destroy".}

proc initGodotPoolColorArray*(): GodotPoolColorArray {.inline.} =
  initGodotPoolColorArray(result)

proc initGodotPoolColorArray*(arr: GodotArray): GodotPoolColorArray {.inline.} =
  initGodotPoolColorArray(result, arr)

proc add*(self: var GodotPoolColorArray; data: Color) {.
    importc: "godot_pool_color_array_append".}
proc addFirst*(self: var GodotPoolColorArray; data: Color) {.
    importc: "godot_pool_color_array_push_back".}
proc add*(self: var GodotPoolColorArray; arr: GodotPoolColorArray) {.
    importc: "godot_pool_color_array_append_array".}
proc insert*(self: var GodotPoolColorArray;
             idx: cint; data: Color): Error {.
    importc: "godot_pool_color_array_insert".}
proc delete*(self: var GodotPoolColorArray; idx: cint) {.
    importc: "godot_pool_color_array_remove".}
proc reverse*(self: var GodotPoolColorArray) {.
    importc: "godot_pool_color_array_invert".}
proc setLen*(self: var GodotPoolColorArray; size: cint) {.
    importc: "godot_pool_color_array_resize".}
proc `[]=`*(self: var GodotPoolColorArray; idx: cint;
            data: Color) {.
    importc: "godot_pool_color_array_set".}
proc `[]`*(self: GodotPoolColorArray; idx: cint): Color {.
    noSideEffect,
    importc: "godot_pool_color_array_get".}
proc len*(self: GodotPoolColorArray): cint {.
    noSideEffect,
    importc: "godot_pool_color_array_size".}

iterator items*(arr: GodotPoolColorArray): Color =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: GodotPoolColorArray): tuple[key: cint, val: Color] =
  for i in 0..<arr.len:
    yield (i, arr[i])
