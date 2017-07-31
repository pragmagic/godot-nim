# Copyright 2017 Xored Software, Inc.

import vector2, vector3, colors
import internal.godotpoolarrays, internal.godotstrings

type
  PoolByteArray* = ref object
    godotPoolByteArray: GodotPoolByteArray
  PoolIntArray* = ref object
    godotPoolIntArray: GodotPoolIntArray
  PoolRealArray* = ref object
    godotPoolRealArray: GodotPoolRealArray
  PoolVector2Array* = ref object
    godotPoolVector2Array: GodotPoolVector2Array
  PoolVector3Array* = ref object
    godotPoolVector3Array: GodotPoolVector3Array
  PoolColorArray* = ref object
    godotPoolColorArray: GodotPoolColorArray
  PoolStringArray* = ref object
    godotPoolStringArray: GodotPoolStringArray

proc godotPoolByteArray*(self: PoolByteArray):
    ptr GodotPoolByteArray {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## the array.
  addr self.godotPoolByteArray

proc godotPoolIntArray*(self: PoolIntArray):
    ptr GodotPoolIntArray {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## the array.
  addr self.godotPoolIntArray

proc godotPoolRealArray*(self: PoolRealArray):
    ptr GodotPoolRealArray {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## the array.
  addr self.godotPoolRealArray

proc godotPoolVector2Array*(self: PoolVector2Array):
    ptr GodotPoolVector2Array {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## the array.
  addr self.godotPoolVector2Array

proc godotPoolVector3Array*(self: PoolVector3Array):
    ptr GodotPoolVector3Array {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## the array.
  addr self.godotPoolVector3Array

proc godotPoolColorArray*(self: PoolColorArray):
    ptr GodotPoolColorArray {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## the array.
  addr self.godotPoolColorArray

proc godotPoolStringArray*(self: PoolStringArray):
    ptr GodotPoolStringArray {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## the array.
  addr self.godotPoolStringArray

import godotbase, arrays

template definePoolArray(T, GodotT, DataT, fieldName, newProcName, initProcName;
                         noData = false) =

  proc poolArrayFinalizer(arr: T) =
    arr.fieldName.deinit()

  proc newProcName*(): T {.inline.} =
    new(result, poolArrayFinalizer)
    initProcName(result.fieldName)

  proc newProcName*(arr: Array): T {.inline.} =
    new(result, poolArrayFinalizer)
    initProcName(result.fieldName, arr.godotArray[])

  proc newProcName*(arr: GodotT): T {.inline.} =
    new(result, poolArrayFinalizer)
    result.fieldName = arr

  proc add*(self: var T; arr: T) {.inline.} =
    self.fieldName.add(arr.fieldName)

  proc delete*(self: var T; idx: int) {.inline.} =
    self.fieldName.delete(idx.cint)

  proc reverse*(self: var T) {.inline.} =
    self.fieldName.reverse()

  proc setLen*(self: var T; size: int) {.inline.} =
    self.fieldName.setLen(size.cint)

  proc len*(self: T): int {.inline.} =
    self.fieldName.len.int

  when not noData:
    proc add*(self: var T; data: DataT) {.inline.} =
      self.fieldName.add(data)

    proc addFirst*(self: var T, data: DataT) {.inline.} =
      self.fieldName.addFirst(data)

    proc insert*(self: var T; idx: int; data: DataT): Error {.inline.} =
      self.fieldName.insert(idx.cint, data)

    proc `[]=`*(self: var T; idx: int; data: DataT) {.inline.} =
      self.fieldName[idx.cint] = data

    proc `[]`*(self: T; idx: int): DataT {.inline.} =
      self.fieldName[idx.cint]

    iterator items*(arr: T): DataT =
      for i in 0..<arr.len:
        yield arr[i]

    iterator pairs*(arr: T): tuple[key: int, val: DataT] =
      for i in 0..<arr.len:
        yield (i, arr[i])

definePoolArray(PoolByteArray, GodotPoolByteArray, uint8,
                godotPoolByteArray, newPoolByteArray,
                initGodotPoolByteArray)
definePoolArray(PoolIntArray, GodotPoolIntArray, cint,
                godotPoolIntArray, newPoolIntArray,
                initGodotPoolIntArray)
definePoolArray(PoolRealArray, GodotPoolRealArray, float64,
                godotPoolRealArray, newPoolRealArray,
                initGodotPoolRealArray)
definePoolArray(PoolVector2Array, GodotPoolVector2Array, Vector2,
                godotPoolVector2Array, newPoolVector2Array,
                initGodotPoolVector2Array)
definePoolArray(PoolVector3Array, GodotPoolVector3Array, Vector3,
                godotPoolVector3Array, newPoolVector3Array,
                initGodotPoolVector3Array)
definePoolArray(PoolColorArray, GodotPoolColorArray, Color,
                godotPoolColorArray, newPoolColorArray,
                initGodotPoolColorArray)
definePoolArray(PoolStringArray, GodotPoolStringArray, string,
                godotPoolStringArray, newPoolStringArray,
                initGodotPoolStringArray, true)

proc add*(self: var PoolStringArray; data: string) =
  var s = data.toGodotString()
  self.godotPoolStringArray.add(s)
  s.deinit()

proc addFirst*(self: var PoolStringArray, data: string) =
  var s = data.toGodotString()
  self.godotPoolStringArray.addFirst(s)
  s.deinit()

proc insert*(self: var PoolStringArray; idx: int; data: string): Error =
  var s = data.toGodotString()
  result = self.godotPoolStringArray.insert(idx.cint, s)
  s.deinit()

proc `[]=`*(self: var PoolStringArray; idx: int; data: string) =
  var s = data.toGodotString()
  self.godotPoolStringArray[idx.cint] = s
  s.deinit()

proc `[]`*(self: PoolStringArray; idx: int): string =
  var s = self.godotPoolStringArray[idx.cint]
  result = $s
  s.deinit()

iterator items*(arr: PoolStringArray): string =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: PoolStringArray): tuple[key: int, val: string] =
  for i in 0..<arr.len:
    yield (i, arr[i])
