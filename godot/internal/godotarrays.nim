# Copyright (c) 2018 Xored Software, Inc.

import godotinternaltypes, gdnativeapi, core/godotcoretypes

proc len*(self: GodotArray): cint {.inline.} =
  getGDNativeAPI().arraySize(self)

import hashes

proc initGodotArray*(dest: var GodotArray) {.inline.} =
  getGDNativeAPI().arrayNew(dest)

proc initGodotArray*(dest: var GodotArray;
                     pca: GodotPoolColorArray) {.inline.} =
  getGDNativeAPI().arrayNewPoolColorArray(dest, pca)

proc initGodotArray*(dest: var GodotArray;
                     pv3a: GodotPoolVector3Array) {.inline.} =
  getGDNativeAPI().arrayNewPoolVector3Array(dest, pv3a)

proc initGodotArray*(dest: var GodotArray;
                     pv2a: GodotPoolVector2Array) {.inline.} =
  getGDNativeAPI().arrayNewPoolVector2Array(dest, pv2a)

proc initGodotArray*(dest: var GodotArray;
                     psa: GodotPoolStringArray) {.inline.} =
  getGDNativeAPI().arrayNewPoolStringArray(dest, psa)

proc initGodotArray*(dest: var GodotArray;
                     pra: GodotPoolRealArray) {.inline.} =
  getGDNativeAPI().arrayNewPoolRealArray(dest, pra)

proc initGodotArray*(dest: var GodotArray;
                     pia: GodotPoolIntArray) {.inline.} =
  getGDNativeAPI().arrayNewPoolIntArray(dest, pia)

proc initGodotArray*(dest: var GodotArray;
                     pba: GodotPoolByteArray) {.inline.} =
  getGDNativeAPI().arrayNewPoolByteArray(dest, pba)

proc initGodotArray*(dest: var GodotArray; src: GodotArray) {.inline.} =
  getGDNativeAPI().arrayNewCopy(dest, src)

proc deinit*(self: var GodotArray) {.inline.} =
  getGDNativeAPI().arrayDestroy(self)

proc `[]=`*(self: var GodotArray; idx: cint; value: GodotVariant) {.inline.} =
  getGDNativeAPI().arraySet(self, idx, value)

proc `[]`*(self: GodotArray; idx: cint): GodotVariant {.inline.} =
  getGDNativeAPI().arrayGet(self, idx)

proc mget*(self: var GodotArray; idx: cint): ptr GodotVariant {.inline.} =
  getGDNativeAPI().arrayOperatorIndex(self, idx)

proc add*(self: var GodotArray; value: GodotVariant) {.inline.} =
  getGDNativeAPI().arrayPushBack(self, value)

proc clear*(self: var GodotArray) {.inline.} =
  getGDNativeAPI().arrayClear(self)

proc count*(self: GodotArray; value: GodotVariant): cint {.inline.} =
  getGDNativeAPI().arrayCount(self, value)

proc isEmpty*(self: GodotArray): bool {.inline.} =
  getGDNativeAPI().arrayEmpty(self)

proc erase*(self: var GodotArray; value: GodotVariant) {.inline.} =
  getGDNativeAPI().arrayErase(self, value)

proc first*(self: GodotArray): GodotVariant {.inline.} =
  getGDNativeAPI().arrayFront(self)

proc last*(self: GodotArray): GodotVariant {.inline.} =
  getGDNativeAPI().arrayBack(self)

proc find*(self: GodotArray; what: GodotVariant;
           fromIdx: cint): cint {.inline.} =
  getGDNativeAPI().arrayFind(self, what, fromIdx)

proc findLast*(self: GodotArray; what: GodotVariant): cint {.inline.} =
  getGDNativeAPI().arrayFindLast(self, what)

proc contains*(self: GodotArray; value: GodotVariant): bool {.inline.} =
  getGDNativeAPI().arrayHas(self, value)

proc godotHash*(self: GodotArray): cint {.inline.} =
  getGDNativeAPI().arrayHash(self)

proc hash*(self: GodotArray): Hash {.inline.} =
  hash(godotHash(self))

proc insert*(self: var GodotArray; pos: cint;
             value: GodotVariant): Error {.discardable, inline.} =
  getGDNativeAPI().arrayInsert(self, pos, value)

proc reverse*(self: var GodotArray) {.inline.} =
  getGDNativeAPI().arrayInvert(self)

proc popLast*(self: var GodotArray): GodotVariant {.inline.} =
  getGDNativeAPI().arrayPopBack(self)

proc popFirst*(self: var GodotArray): GodotVariant {.inline.} =
  getGDNativeAPI().arrayPopFront(self)

proc addLast*(self: var GodotArray; value: GodotVariant) {.inline.} =
  getGDNativeAPI().arrayPushBack(self, value)

proc addFirst*(self: var GodotArray; value: GodotVariant) {.inline.} =
  getGDNativeAPI().arrayPushFront(self, value)

proc delete*(self: var GodotArray; idx: cint) {.inline.} =
  getGDNativeAPI().arrayRemove(self, idx)

proc setLen*(self: var GodotArray; size: cint) {.inline.} =
  getGDNativeAPI().arrayResize(self, size)

proc rfind*(self: GodotArray; what: GodotVariant;
            fromIdx: cint): cint {.inline.} =
  getGDNativeAPI().arrayRFind(self, what, fromIdx)

proc sort*(self: var GodotArray) {.inline.} =
  getGDNativeAPI().arraySort(self)

proc sortCustom*(self: var GodotArray; obj: ptr GodotObject;
                 funcName: GodotString) {.inline.} =
  getGDNativeAPI().arraySortCustom(self, obj, funcName)

proc binarySearch*(self: var GodotArray, val: ptr GodotVariant,
                   before: bool) {.inline.} =
  getGDNativeAPI().arrayBSearch(self, val, before)

proc binarySearchCustom*(self: var GodotArray, val: ptr GodotVariant,
                         obj: ptr GodotObject, funcName: GodotString,
                         before: bool) {.inline.} =
  getGDNativeAPI().arrayBSearchCustom(self, val, obj, funcName, before)

iterator items*(self: GodotArray): GodotVariant =
  for i in 0.cint..<self.len:
    yield self[i]

iterator mitems*(self: var GodotArray): var GodotVariant =
  for i in 0.cint..<self.len:
    yield self.mget(i)[]

iterator pairs*(self: GodotArray): tuple[key: cint, val: GodotVariant] =
  for i in 0.cint..<self.len:
    yield (i, self[i])

iterator mpairs*(self: var GodotArray): tuple[key: cint,
                                              val: var GodotVariant] =
  for i in 0.cint..<self.len:
    yield (i, self.mget(i)[])

proc `$`*(self: GodotArray): string =
  result = newStringOfCap(32)
  result.add('[')
  for item in self:
    if result.len > 1:
      result.add(", ")
    result.add($item)
  result.add(']')
