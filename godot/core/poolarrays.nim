# Copyright 2018 Xored Software, Inc.

import hashes

import godotcoretypes
import internal/godotinternaltypes, internal/godotpoolarrays,
       internal/godotstrings
import vector2, vector3, colors

template definePoolArrayBase(T, GodotT, DataT, fieldName, newProcName,
                             initProcName) =
  type
    T* = ref object
      fieldName: GodotT

  proc poolArrayFinalizer(arr: T) =
    arr.fieldName.deinit()

  proc fieldName*(self: T): ptr GodotT {.inline.} =
    ## WARNING: do not keep the returned value for longer than the lifetime of
    ## the array.
    addr self.fieldName

  proc newProcName*(arr: GodotT): T {.inline.} =
    new(result, poolArrayFinalizer)
    result.fieldName = arr

  proc hash*(arr: T): Hash =
    for item in arr.fieldName.items():
      result = result !&
        (when type(item) is GodotString: ($item).hash() else: item.hash())
    result = !$result

definePoolArrayBase(PoolByteArray, GodotPoolByteArray, uint8,
                    godotPoolByteArray, newPoolByteArray,
                    initGodotPoolByteArray)
definePoolArrayBase(PoolIntArray, GodotPoolIntArray, cint,
                    godotPoolIntArray, newPoolIntArray,
                    initGodotPoolIntArray)
definePoolArrayBase(PoolRealArray, GodotPoolRealArray, float32,
                    godotPoolRealArray, newPoolRealArray,
                    initGodotPoolRealArray)
definePoolArrayBase(PoolVector2Array, GodotPoolVector2Array, Vector2,
                    godotPoolVector2Array, newPoolVector2Array,
                    initGodotPoolVector2Array)
definePoolArrayBase(PoolVector3Array, GodotPoolVector3Array, Vector3,
                    godotPoolVector3Array, newPoolVector3Array,
                    initGodotPoolVector3Array)
definePoolArrayBase(PoolColorArray, GodotPoolColorArray, Color,
                    godotPoolColorArray, newPoolColorArray,
                    initGodotPoolColorArray)
definePoolArrayBase(PoolStringArray, GodotPoolStringArray, string,
                    godotPoolStringArray, newPoolStringArray,
                    initGodotPoolStringArray)

import arrays

template definePoolArray(T, GodotT, DataT, fieldName, newProcName, initProcName;
                         noData = false) =

  proc newProcName*(arr: Array): T {.inline.} =
    new(result, poolArrayFinalizer)
    initProcName(result.fieldName, arr.godotArray[])

  proc add*(self: T; arr: T) {.inline.} =
    self.fieldName.add(arr.fieldName)

  proc delete*(self: T; idx: int) {.inline.} =
    self.fieldName.delete(idx.cint)

  proc reverse*(self: T) {.inline.} =
    self.fieldName.reverse()

  proc setLen*(self: T; size: int) {.inline.} =
    self.fieldName.setLen(size.cint)

  proc len*(self: T): int {.inline.} =
    self.fieldName.len.int

  proc subarray*(self: T, idxFrom, idxTo: int): T {.inline.} =
    ## Indexes are inclusive, negative values count from the end of the array.
    assert(idxFrom >= low(cint) and idxFrom <= high(cint) and
           idxTo >= low(cint) and idxTo <= high(cint))
    newProcName(self.fieldName.subarray(idxFrom.cint, idxTo.cint))

  when not noData:
    proc newProcName*(s: varargs[DataT]): T {.inline.} =
      new(result)
      initProcName(result.fieldName)
      result.fieldName.setLen(s.len.cint)
      for idx, data in s:
        result.fieldName[idx.cint] = data

    proc add*(self: T; data: DataT) {.inline.} =
      self.fieldName.add(data)

    proc insert*(self: T; idx: int; data: DataT): Error {.inline.} =
      self.fieldName.insert(idx.cint, data)

    proc `[]=`*(self: T; idx: int; data: DataT) {.inline.} =
      self.fieldName[idx.cint] = data

    proc `[]`*(self: T; idx: int): DataT {.inline.} =
      self.fieldName[idx.cint]

    iterator items*(arr: T): DataT =
      for item in arr.fieldName.items:
        yield item

    iterator pairs*(arr: T): tuple[key: int, val: DataT] =
      for pair in arr.fieldName.pairs:
        yield (pair[0].int, pair[1])

    iterator mitems*(arr: T): var DataT =
      for item in arr.fieldName.mitems:
        yield item

    iterator mpairs*(arr: T): tuple[key: int, val: var DataT] =
      for pair in arr.fieldName.mpairs:
        yield (pair[0].int, pair[1])

definePoolArray(PoolByteArray, GodotPoolByteArray, uint8,
                godotPoolByteArray, newPoolByteArray,
                initGodotPoolByteArray)
definePoolArray(PoolIntArray, GodotPoolIntArray, cint,
                godotPoolIntArray, newPoolIntArray,
                initGodotPoolIntArray)
definePoolArray(PoolRealArray, GodotPoolRealArray, float32,
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

proc newPoolStringArray*(s: varargs[string]): PoolStringArray {.inline.} =
  new(result)
  initGodotPoolStringArray(result.godotPoolStringArray)
  result.godotPoolStringArray.setLen(s.len.cint)
  for idx, str in s:
    var gstr = str.toGodotString()
    result.godotPoolStringArray[idx.cint] = gstr
    gstr.deinit()

proc add*(self: PoolStringArray; data: string) =
  var s = data.toGodotString()
  self.godotPoolStringArray.add(s)
  s.deinit()

proc insert*(self: PoolStringArray; idx: int; data: string): Error =
  var s = data.toGodotString()
  result = self.godotPoolStringArray.insert(idx.cint, s)
  s.deinit()

proc `[]=`*(self: PoolStringArray; idx: int; data: string) =
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
