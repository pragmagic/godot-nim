# Copyright 2017 Xored Software, Inc.

import hashes
import internal.godotinternaltypes, internal.godotarrays

type
  Array* = ref object
    godotArray: GodotArray

proc godotArray*(arr: Array): ptr GodotArray {.inline.} =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## ``arr``
  addr arr.godotArray

proc arrayFinalizer(arr: Array) =
  arr.godotArray.deinit()

proc newArray*(): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray)

proc newArray*(arr: GodotArray): Array {.inline.} =
  new(result, arrayFinalizer)
  result.godotArray = arr

import poolarrays

proc newArray*(pca: PoolColorArray): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray, pca.godotPoolColorArray[])

proc newArray*(pv3a: PoolVector3Array): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray, pv3a.godotPoolVector3Array[])

proc newArray*(pv2a: PoolVector2Array): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray, pv2a.godotPoolVector2Array[])

proc newArray*(psa: PoolStringArray): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray, psa.godotPoolStringArray[])

proc newArray*(pra: PoolRealArray): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray, pra.godotPoolRealArray[])

proc newArray*(pia: PoolIntArray): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray, pia.godotPoolIntArray[])

proc newArray*(pba: PoolByteArray): Array {.inline.} =
  new(result, arrayFinalizer)
  initGodotArray(result.godotArray, pba.godotPoolByteArray[])

import variants

proc `[]=`*(self: var Array; idx: int; value: Variant) {.inline.} =
  self.godotArray[idx.cint] = value.godotVariant[]

proc `[]`*(self: Array; idx: int): Variant {.inline.} =
  newVariant(self.godotArray[idx.cint])

proc add*(self: var Array; value: Variant) {.inline.} =
  self.godotArray.add(value.godotVariant[])

proc clear*(self: var Array) {.inline.} =
  self.godotArray.clear()

proc count*(self: Array; value: Variant): int {.inline.} =
  self.godotArray.count(value.godotVariant[]).int

proc isEmpty*(self: Array): bool {.inline.} =
  self.godotArray.isEmpty()

proc erase*(self: var Array; value: Variant) {.inline.} =
  self.godotArray.erase(value.godotVariant[])

proc first*(self: Array): Variant {.inline.} =
  newVariant(self.godotArray.first())

proc last*(self: Array): Variant {.inline.} =
  newVariant(self.godotArray.last())

proc find*(self: Array; what: Variant; f: int): int {.inline.} =
  self.godotArray.find(what.godotVariant[], f.cint).int

proc findLast*(self: Array; what: Variant): int {.inline.} =
  self.godotArray.findLast(what.godotVariant[]).int

proc contains*(self: Array; value: Variant): bool {.inline.} =
  self.godotArray.contains(value.godotVariant[])

proc hash*(self: Array): Hash {.inline.} =
  hash(self.godotArray.godotHash())

proc insert*(self: var Array; pos: int; value: Variant) {.inline.} =
  self.godotArray.insert(pos.cint, value.godotVariant[])

proc reverse*(self: var Array) {.inline.} =
  self.godotArray.reverse()

proc popLast*(self: var Array): Variant {.inline.} =
  newVariant(self.godotArray.popLast())

proc popFirst*(self: var Array): Variant {.inline.} =
  newVariant(self.godotArray.popFirst())

proc addLast*(self: var Array; value: Variant) {.inline.} =
  self.godotArray.addLast(value.godotVariant[])

proc addFirst*(self: var Array; value: Variant) {.inline.} =
  self.godotArray.addFirst(value.godotVariant[])

proc delete*(self: var Array; idx: int) {.inline.} =
  self.godotArray.delete(idx.cint)

proc setLen*(self: var Array; size: int) {.inline.} =
  self.godotArray.setLen(size.cint)

proc rfind*(self: Array; what: Variant; f: int): int {.inline.} =
  self.godotArray.rfind(what.godotVariant[], f.cint).int

proc len*(self: Array): int {.inline.} =
  self.godotArray.len.int

proc sort*(self: var Array) {.inline.} =
  self.godotArray.sort()

iterator items*(arr: Array): Variant =
  for i in 0..<arr.len:
    yield arr[i]

iterator pairs*(arr: Array): tuple[key: int, val: Variant] =
  for i in 0..<arr.len:
    yield (i, arr[i])
