# Copyright (c) 2017 Xored Software, Inc.

import godotbase, color, vector2, vector3, strings

type
  PoolByteArray* {.importc: "godot_pool_byte_array",
                   header: "godot_pool_arrays.h", byref.} = object
  PoolIntArray* {.importc: "godot_pool_int_array",
                  header: "godot_pool_arrays.h", byref.} = object
  PoolRealArray* {.importc: "godot_pool_real_array",
                   header: "godot_pool_arrays.h", byref.} = object
  PoolStringArray* {.importc: "godot_pool_string_array",
                     header: "godot_pool_arrays.h", byref.} = object
  PoolVector2Array* {.importc: "godot_pool_vector2_array",
                      header: "godot_pool_arrays.h", byref.} = object
  PoolVector3Array* {.importc: "godot_pool_vector3_array",
                      header: "godot_pool_arrays.h", byref.} = object
  PoolColorArray* {.importc: "godot_pool_color_array",
                    header: "godot_pool_arrays.h", byref.} = object

# byte

proc initPoolByteArray(dest: var PoolByteArray) {.
    importc: "godot_pool_byte_array_new", header: "godot_pool_arrays.h".}
proc initPoolByteArray(dest: var PoolByteArray;
                       src: PoolByteArray) {.
    importc: "godot_pool_byte_array_new_copy",
    header: "godot_pool_arrays.h".}
proc initPoolByteArray(dest: var PoolByteArray; arr: Array) {.
    importc: "godot_pool_byte_array_new_with_array",
    header: "godot_pool_arrays.h".}

proc deinit(self: var PoolByteArray) {.
    importc: "godot_pool_byte_array_destroy", header: "godot_pool_arrays.h".}

proc initPoolByteArray*(): PoolByteArray {.inline.} =
  initPoolByteArray(result)

proc initPoolByteArray*(arr: Array): PoolByteArray {.inline.} =
  initPoolByteArray(result, arr)

proc `=`(self: var PoolByteArray, other: PoolByteArray) {.inline.} =
  initPoolByteArray(self, other)

proc `=destroy`(self: PoolByteArray) {.inline.} =
  unsafeAddr(self).deinit()

proc add*(self: var PoolByteArray;
          data: uint8) {.
    importc: "godot_pool_byte_array_append", header: "godot_pool_arrays.h".}
proc addFirst*(self: var PoolByteArray, data: uint8) {.
    importc: "godot_pool_byte_array_push_back", header: "godot_pool_arrays.h".}
proc add*(self: var PoolByteArray;
          arr: PoolByteArray) {.
    importc: "godot_pool_byte_array_append_array",
    header: "godot_pool_arrays.h".}
proc insert*(self: var PoolByteArray; idx: cint;
             data: uint8): Error {.
    importc: "godot_pool_byte_array_insert", header: "godot_pool_arrays.h".}
proc delete*(self: var PoolByteArray; idx: cint) {.
    importc: "godot_pool_byte_array_remove", header: "godot_pool_arrays.h".}

proc reverse*(self: var PoolByteArray) {.
    importc: "godot_pool_byte_array_invert", header: "godot_pool_arrays.h".}
proc setLen*(self: var PoolByteArray; size: cint) {.
    importc: "godot_pool_byte_array_resize", header: "godot_pool_arrays.h".}

proc `[]=`*(self: var PoolByteArray; idx: cint; data: uint8) {.
    importc: "godot_pool_byte_array_set", header: "godot_pool_arrays.h".}
proc `[]`*(self: PoolByteArray; idx: cint): uint8 {.
    noSideEffect,
    importc: "godot_pool_byte_array_get",
    header: "godot_pool_arrays.h".}
proc len*(self: PoolByteArray): cint {.
    noSideEffect,
    importc: "godot_pool_byte_array_size", header: "godot_pool_arrays.h".}

iterator items*(arr: PoolByteArray): byte =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolByteArray): tuple[key: cint, val: byte] =
  for i in 0..<arr.len:
    yield (i, arr[i])

proc initPoolIntArray(dest: var PoolIntArray) {.
    importc: "godot_pool_int_array_new", header: "godot_pool_arrays.h".}
proc initPoolIntArray(dest: var PoolIntArray;
                      src: PoolIntArray) {.
    importc: "godot_pool_int_array_new_copy", header: "godot_pool_arrays.h".}
proc initPoolIntArray(dest: var PoolIntArray;
                      arr: Array) {.
   importc: "godot_pool_int_array_new_with_array",
   header: "godot_pool_arrays.h".}
proc deinit(self: var PoolIntArray) {.
   importc: "godot_pool_int_array_destroy", header: "godot_pool_arrays.h".}

proc initPoolIntArray*(): PoolIntArray {.inline.} =
  initPoolIntArray(result)

proc initPoolIntArray*(arr: Array): PoolIntArray {.inline.} =
  initPoolIntArray(result, arr)

proc `=`(self: var PoolIntArray, other: PoolIntArray) {.inline.} =
  initPoolIntArray(self, other)

proc `=destroy`(self: PoolIntArray) {.inline.} =
  unsafeAddr(self).deinit()

proc add*(self: var PoolIntArray; data: cint) {.
    importc: "godot_pool_int_array_append", header: "godot_pool_arrays.h".}
proc addFirst*(self: var PoolIntArray; data: cint) {.
    importc: "godot_pool_int_array_push_back", header: "godot_pool_arrays.h".}
proc add*(self: var PoolIntArray; arr: PoolIntArray) {.
    importc: "godot_pool_int_array_append_array",
    header: "godot_pool_arrays.h".}
proc insert*(self: var PoolIntArray; idx: cint;
             data: cint): Error {.
    importc: "godot_pool_int_array_insert", header: "godot_pool_arrays.h".}
proc delete*(self: var PoolIntArray; idx: cint) {.
    importc: "godot_pool_int_array_remove", header: "godot_pool_arrays.h".}
proc reverse*(self: var PoolIntArray) {.
    importc: "godot_pool_int_array_invert", header: "godot_pool_arrays.h".}

proc setLen*(self: var PoolIntArray; size: cint) {.
    importc: "godot_pool_int_array_resize", header: "godot_pool_arrays.h".}
proc `[]=`*(self: var PoolIntArray; idx: cint; data: cint) {.
    importc: "godot_pool_int_array_set", header: "godot_pool_arrays.h".}
proc `[]`*(self: PoolIntArray; idx: cint): cint {.
    noSideEffect,
    importc: "godot_pool_int_array_get",
    header: "godot_pool_arrays.h".}
proc len*(self: PoolIntArray): cint {.
    noSideEffect,
    importc: "godot_pool_int_array_size",
    header: "godot_pool_arrays.h".}

iterator items*(arr: PoolIntArray): cint =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolIntArray): tuple[key: cint, val: cint] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Real

proc initPoolRealArray(dest: var PoolRealArray) {.
    importc: "godot_pool_real_array_new", header: "godot_pool_arrays.h".}
proc initPoolRealArray(dest: var PoolRealArray;
                       src: PoolRealArray) {.
    importc: "godot_pool_real_array_new_copy",
    header: "godot_pool_arrays.h".}
proc initPoolRealArray(dest: var PoolRealArray; arr: Array) {.
    importc: "godot_pool_real_array_new_with_array",
    header: "godot_pool_arrays.h".}

proc deinit(self: var PoolRealArray) {.
    importc: "godot_pool_real_array_destroy", header: "godot_pool_arrays.h".}

proc initPoolRealArray*(): PoolRealArray {.inline.} =
  initPoolRealArray(result)

proc initPoolRealArray*(arr: Array): PoolRealArray {.inline.} =
  initPoolRealArray(result, arr)

proc `=`(self: var PoolRealArray, other: PoolRealArray) {.inline.} =
  initPoolRealArray(self, other)

proc `=destroy`(self: PoolRealArray) {.inline.} =
  unsafeAddr(self).deinit()

proc add*(self: var PoolRealArray; data: float32) {.
    importc: "godot_pool_real_array_append",
    header: "godot_pool_arrays.h".}
proc addFirst*(self: var PoolRealArray; data: float32) {.
    importc: "godot_pool_real_array_push_back", header: "godot_pool_arrays.h".}
proc add*(self: var PoolRealArray; arr: PoolRealArray) {.
    importc: "godot_pool_real_array_append_array",
    header: "godot_pool_arrays.h".}
proc insert*(self: var PoolRealArray;
             idx: cint; data: float32): Error {.
    importc: "godot_pool_real_array_insert", header: "godot_pool_arrays.h".}
proc delete*(self: var PoolRealArray; idx: cint) {.
    importc: "godot_pool_real_array_remove", header: "godot_pool_arrays.h".}
proc reverse*(self: var PoolRealArray) {.
    importc: "godot_pool_real_array_invert", header: "godot_pool_arrays.h".}
proc setLen*(self: var PoolRealArray; size: cint) {.
    importc: "godot_pool_real_array_resize", header: "godot_pool_arrays.h".}
proc `[]=`*(self: var PoolRealArray; idx: cint; data: float32) {.
    importc: "godot_pool_real_array_set", header: "godot_pool_arrays.h".}
proc `[]`*(self: PoolRealArray; idx: cint): float32 {.
    noSideEffect,
    importc: "godot_pool_real_array_get",
    header: "godot_pool_arrays.h".}
proc len*(self: PoolRealArray): cint {.
    noSideEffect,
    importc: "godot_pool_real_array_size", header: "godot_pool_arrays.h".}

iterator items*(arr: PoolRealArray): float32 =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolRealArray): tuple[key: cint, val: float32] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# String

proc initPoolStringArray(dest: var PoolStringArray) {.
    importc: "godot_pool_string_array_new", header: "godot_pool_arrays.h".}
proc initPoolStringArray(dest: var PoolStringArray;
                         src: PoolStringArray) {.
    importc: "godot_pool_string_array_new_copy",
    header: "godot_pool_arrays.h".}
proc initPoolStringArray(dest: var PoolStringArray; arr: Array) {.
    importc: "godot_pool_string_array_new_with_array",
    header: "godot_pool_arrays.h".}

proc deinit(self: var PoolStringArray) {.
    importc: "godot_pool_string_array_destroy",
    header: "godot_pool_arrays.h".}

proc initPoolStringArray*(): PoolStringArray {.inline.} =
  initPoolStringArray(result)

proc initPoolStringArray*(arr: Array): PoolStringArray {.inline.} =
  initPoolStringArray(result, arr)

proc `=`(self: var PoolStringArray, other: PoolStringArray) {.inline.} =
  initPoolStringArray(self, other)

proc `=destroy`(self: PoolStringArray) {.inline.} =
  unsafeAddr(self).deinit()

proc add*(self: var PoolStringArray; data: GodotString) {.
    importc: "godot_pool_string_array_append",
    header: "godot_pool_arrays.h".}
proc addFirst*(self: var PoolStringArray; data: GodotString) {.
    importc: "godot_pool_string_array_push_back",
    header: "godot_pool_arrays.h".}
proc add*(self: var PoolStringArray; arr: PoolStringArray) {.
    importc: "godot_pool_string_array_append_array",
    header: "godot_pool_arrays.h".}
proc insert*(self: var PoolStringArray;
             idx: cint; data: GodotString): Error {.
    importc: "godot_pool_string_array_insert",
    header: "godot_pool_arrays.h".}
proc delete*(self: var PoolStringArray; idx: cint) {.
    importc: "godot_pool_string_array_remove", header: "godot_pool_arrays.h".}
proc reverse*(self: var PoolStringArray) {.
    importc: "godot_pool_string_array_invert", header: "godot_pool_arrays.h".}
proc setLen*(self: var PoolStringArray; size: cint) {.
    importc: "godot_pool_string_array_resize", header: "godot_pool_arrays.h".}
proc `[]=`*(self: var PoolStringArray; idx: cint;
            data: GodotString) {.
    importc: "godot_pool_string_array_set",
    header: "godot_pool_arrays.h".}
proc `[]`*(self: PoolStringArray; idx: cint): GodotString {.
    noSideEffect,
    importc: "godot_pool_string_array_get",
    header: "godot_pool_arrays.h".}
proc len*(self: PoolStringArray): cint {.
    noSideEffect,
    importc: "godot_pool_string_array_size",
    header: "godot_pool_arrays.h".}

iterator items*(arr: PoolStringArray): GodotString =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolStringArray): tuple[key: cint, val: GodotString] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Vector2

proc initPoolVector2Array(dest: var PoolVector2Array) {.
    importc: "godot_pool_vector2_array_new", header: "godot_pool_arrays.h".}
proc initPoolVector2Array(dest: var PoolVector2Array;
                          src: PoolVector2Array) {.
    importc: "godot_pool_vector2_array_new_copy",
    header: "godot_pool_arrays.h".}
proc initPoolVector2Array(dest: var PoolVector2Array; arr: Array) {.
    importc: "godot_pool_vector2_array_new_with_array",
    header: "godot_pool_arrays.h".}

proc deinit(self: var PoolVector2Array) {.
    importc: "godot_pool_vector2_array_destroy", header: "godot_pool_arrays.h".}

proc initPoolVector2Array*(): PoolVector2Array {.inline.} =
  initPoolVector2Array(result)

proc initPoolVector2Array*(arr: Array): PoolVector2Array {.inline.} =
  initPoolVector2Array(result, arr)

proc `=`(self: var PoolVector2Array, other: PoolVector2Array) {.inline.} =
  initPoolVector2Array(self, other)

proc `=destroy`(self: PoolVector2Array) {.inline.} =
  unsafeAddr(self).deinit()

proc add*(self: var PoolVector2Array; data: Vector2) {.
    importc: "godot_pool_vector2_array_append",
    header: "godot_pool_arrays.h".}
proc addFirst*(self: var PoolVector2Array; data: Vector2) {.
    importc: "godot_pool_vector2_array_push_back",
    header: "godot_pool_arrays.h".}
proc add*(self: var PoolVector2Array;
          arr: PoolVector2Array) {.
    importc: "godot_pool_vector2_array_append_array",
    header: "godot_pool_arrays.h".}
proc insert*(self: var PoolVector2Array;
             idx: cint; data: Vector2): Error {.
    importc: "godot_pool_vector2_array_insert",
    header: "godot_pool_arrays.h".}
proc delete*(self: var PoolVector2Array; idx: cint) {.
    importc: "godot_pool_vector2_array_remove", header: "godot_pool_arrays.h".}
proc reverse*(self: var PoolVector2Array) {.
    importc: "godot_pool_vector2_array_invert",
    header: "godot_pool_arrays.h".}
proc setLen*(self: var PoolVector2Array; size: cint) {.
    importc: "godot_pool_vector2_array_resize", header: "godot_pool_arrays.h".}
proc `[]=`*(self: var PoolVector2Array; idx: cint;
            data: ptr Vector2) {.
    importc: "godot_pool_vector2_array_set", header: "godot_pool_arrays.h".}
proc `[]`*(self: PoolVector2Array; idx: cint): Vector2 {.
    noSideEffect,
    importc: "godot_pool_vector2_array_get", header: "godot_pool_arrays.h".}
proc len*(self: PoolVector2Array): cint {.
    noSideEffect,
    importc: "godot_pool_vector2_array_size", header: "godot_pool_arrays.h".}

iterator items*(arr: PoolVector2Array): Vector2 =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolVector2Array): tuple[key: cint, val: Vector2] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Vector3

proc initPoolVector3Array*(dest: var PoolVector3Array) {.
    importc: "godot_pool_vector3_array_new", header: "godot_pool_arrays.h".}
proc initPoolVector3Array*(dest: var PoolVector3Array;
                           src: PoolVector3Array) {.
    importc: "godot_pool_vector3_array_new_copy",
    header: "godot_pool_arrays.h".}
proc initPoolVector3Array*(dest: var PoolVector3Array; arr: Array) {.
    importc: "godot_pool_vector3_array_new_with_array",
    header: "godot_pool_arrays.h".}

proc deinit(self: var PoolVector3Array) {.
    importc: "godot_pool_vector3_array_destroy",
    header: "godot_pool_arrays.h".}

proc initPoolVector3Array*(): PoolVector3Array {.inline.} =
  initPoolVector3Array(result)

proc initPoolVector3Array*(arr: Array): PoolVector3Array {.inline.} =
  initPoolVector3Array(result, arr)

proc `=`(self: var PoolVector3Array, other: PoolVector3Array) {.inline.} =
  initPoolVector3Array(self, other)

proc `=destroy`(self: PoolVector3Array) {.inline.} =
  unsafeAddr(self).deinit()

proc add*(self: var PoolVector3Array;
          data: Vector3) {.
    importc: "godot_pool_vector3_array_append",
    header: "godot_pool_arrays.h".}
proc addFirst*(self: var PoolVector3Array;
               data: Vector3) {.
    importc: "godot_pool_vector3_array_push_back",
    header: "godot_pool_arrays.h".}
proc add*(self: var PoolVector3Array;
          arr: PoolVector3Array) {.
    importc: "godot_pool_vector3_array_append_array",
    header: "godot_pool_arrays.h".}
proc insert*(self: var PoolVector3Array;
             idx: cint; data: Vector3): Error {.
    importc: "godot_pool_vector3_array_insert",
    header: "godot_pool_arrays.h".}
proc delete*(self: var PoolVector3Array; idx: cint) {.
    importc: "godot_pool_vector3_array_remove", header: "godot_pool_arrays.h".}
proc reverse*(self: var PoolVector3Array) {.
    importc: "godot_pool_vector3_array_invert", header: "godot_pool_arrays.h".}
proc setLen*(self: var PoolVector3Array; size: cint) {.
    importc: "godot_pool_vector3_array_resize", header: "godot_pool_arrays.h".}
proc `[]=`*(self: var PoolVector3Array;
            idx: cint; data: Vector3) {.
    importc: "godot_pool_vector3_array_set",
    header: "godot_pool_arrays.h".}
proc `[]`*(self: PoolVector3Array;
           idx: cint): Vector3 {.
    noSideEffect,
    importc: "godot_pool_vector3_array_get",
    header: "godot_pool_arrays.h".}
proc len*(self: PoolVector3Array): cint {.
    noSideEffect,
    importc: "godot_pool_vector3_array_size",
    header: "godot_pool_arrays.h".}

iterator items*(arr: PoolVector3Array): Vector3 =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolVector3Array): tuple[key: cint, val: Vector3] =
  for i in 0..<arr.len:
    yield (i, arr[i])

# Color

proc initPoolColorArray(dest: var PoolColorArray) {.
    importc: "godot_pool_color_array_new", header: "godot_pool_arrays.h".}
proc initPoolColorArray(dest: var PoolColorArray;
                        src: PoolColorArray) {.
    importc: "godot_pool_color_array_new_copy",
    header: "godot_pool_arrays.h".}
proc initPoolColorArray(dest: var PoolColorArray; arr: Array) {.
    importc: "godot_pool_color_array_new_with_array",
    header: "godot_pool_arrays.h".}

proc deinit(self: var PoolColorArray) {.
    importc: "godot_pool_color_array_destroy", header: "godot_pool_arrays.h".}

proc initPoolColorArray*(): PoolColorArray {.inline.} =
  initPoolColorArray(result)

proc initPoolColorArray*(arr: Array): PoolColorArray {.inline.} =
  initPoolColorArray(result, arr)

proc `=`(self: var PoolColorArray, other: PoolColorArray) {.inline.} =
  initPoolColorArray(self, other)

proc `=destroy`(self: PoolColorArray) {.inline.} =
  unsafeAddr(self).deinit()

proc add*(self: var PoolColorArray; data: Color) {.
    importc: "godot_pool_color_array_append",
    header: "godot_pool_arrays.h".}
proc addFirst*(self: var PoolColorArray; data: Color) {.
    importc: "godot_pool_color_array_push_back",
    header: "godot_pool_arrays.h".}
proc add*(self: var PoolColorArray; arr: PoolColorArray) {.
    importc: "godot_pool_color_array_append_array",
    header: "godot_pool_arrays.h".}
proc insert*(self: var PoolColorArray;
             idx: cint; data: Color): Error {.
    importc: "godot_pool_color_array_insert",
    header: "godot_pool_arrays.h".}
proc delete*(self: var PoolColorArray; idx: cint) {.
    importc: "godot_pool_color_array_remove", header: "godot_pool_arrays.h".}
proc reverse*(self: var PoolColorArray) {.
    importc: "godot_pool_color_array_invert", header: "godot_pool_arrays.h".}
proc setLen*(self: var PoolColorArray; size: cint) {.
    importc: "godot_pool_color_array_resize", header: "godot_pool_arrays.h".}
proc `[]=`*(self: var PoolColorArray; idx: cint;
            data: Color) {.
    importc: "godot_pool_color_array_set", header: "godot_pool_arrays.h".}
proc `[]`*(self: PoolColorArray; idx: cint): Color {.
    noSideEffect,
    importc: "godot_pool_color_array_get", header: "godot_pool_arrays.h".}
proc len*(self: PoolColorArray): cint {.
    noSideEffect,
    importc: "godot_pool_color_array_size", header: "godot_pool_arrays.h".}

iterator items*(arr: PoolColorArray): Color =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolColorArray): tuple[key: cint, val: Color] =
  for i in 0..<arr.len:
    yield (i, arr[i])