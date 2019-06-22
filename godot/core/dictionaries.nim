# Copyright 2018 Xored Software, Inc.

import hashes
import internal/godotinternaltypes, internal/godotdictionaries,
       internal/godotvariants, internal/godotstrings

type
  Dictionary* = ref object
    godotDictionary: GodotDictionary

proc dictionaryFinalizer(dict: Dictionary) =
  dict.godotDictionary.deinit()

proc newDictionary*(): Dictionary {.inline.} =
  new(result, dictionaryFinalizer)
  initGodotDictionary(result.godotDictionary)

proc newDictionary*(dict: GodotDictionary): Dictionary {.inline.} =
  new(result, dictionaryFinalizer)
  result.godotDictionary = dict

proc godotDictionary*(dict: Dictionary): ptr GodotDictionary =
  ## WARNING: do not keep the returned value for longer than the lifetime of
  ## ``dict``
  addr dict.godotDictionary

proc len*(self: Dictionary): int {.inline.} =
  self.godotDictionary.len.int

proc isEmpty*(self: Dictionary): bool {.inline.} =
  self.godotDictionary.isEmpty()

proc clear*(self: Dictionary) {.inline.} =
  self.godotDictionary.clear()

proc hash*(self: Dictionary): Hash {.inline.} =
  hash(self.godotDictionary.godotHash())

import variants, arrays

proc newVariant*(dict: Dictionary): Variant {.inline.} =
  new(result, variantFinalizer)
  initGodotVariant(result.godotVariant[], dict.godotDictionary)

proc asDictionary*(self: Variant): Dictionary {.inline.} =
  newDictionary(self.godotVariant[].asGodotDictionary())

proc contains*(self: Dictionary; key: Variant): bool {.inline.}=
  self.godotDictionary.contains(key.godotVariant[])

proc contains*(self: Dictionary; keys: Array): bool {.inline.} =
  self.godotDictionary.contains(keys.godotArray[])

proc del*(self: Dictionary; key: Variant) {.inline.} =
  self.godotDictionary.del(key.godotVariant[])

proc keys*(self: Dictionary): Array {.inline.} =
  newArray(self.godotDictionary.keys())

proc values*(self: Dictionary): Array {.inline.} =
  newArray(self.godotDictionary.values())

proc `[]`*(self: Dictionary; key: Variant): Variant {.inline.} =
  newVariant(self.godotDictionary[key.godotVariant[]])

proc `[]`*(self: Dictionary; keyStr: string): Variant {.inline.} =
  var godotVariant: GodotVariant
  var godotStr = keyStr.toGodotString()
  initGodotVariant(godotVariant, godotStr)
  result = newVariant(self.godotDictionary[godotVariant])
  godotStr.deinit()
  godotVariant.deinit()

proc `[]=`*(self: Dictionary; key, value: Variant) {.inline.} =
  self.godotDictionary[key.godotVariant[]] = value.godotVariant[]

proc `==`*(self, other: Dictionary): bool {.inline.} =
  if self.isNil and other.isNil: return true
  if self.isNil != other.isNil: return false
  result = self.godotDictionary == other.godotDictionary

proc toJson*(self: Dictionary): string {.inline.} =
  var s = self.godotDictionary.toJson()
  result = $s
  s.deinit()

iterator keys*(dict: Dictionary): Variant =
  let keyArr = dict.keys()
  for key in keyArr:
    yield key

iterator values*(dict: Dictionary): Variant =
  let valArr = dict.values()
  for val in valArr:
    yield val

iterator pairs*(dict: Dictionary): tuple[key, val: Variant] =
  for key in keys(dict):
    yield (key, dict[key])

proc `$`*(self: Dictionary): string =
  result = newStringOfCap(32)
  result.add('{')
  for k, v in self:
    if result.len > 1:
      result.add(", ")
    result.add($k)
    result.add(": ")
    result.add($v)
  result.add('}')
