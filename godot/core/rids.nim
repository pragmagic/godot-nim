# Copyright (c) 2018 Xored Software, Inc.

import hashes

import godotcoretypes, internal/godotinternaltypes, gdnativeapi

proc initRID*(): RID {.inline.} =
  getGDNativeAPI().ridNew(result)

proc initRID*(obj: ptr GodotObject): RID {.inline.} =
  getGDNativeAPI().ridNewWithResource(result, obj)

proc id*(self: RID): uint32 {.inline.} =
  cast[uint32](getGDNativeAPI().ridGetId(self))

proc `$`*(self: RID): string {.inline.} =
  $self.id

proc hash*(self: RID): Hash {.inline.} =
  self.id.hash()

proc `==`*(a, b: RID): bool {.inline.} =
  getGDNativeAPI().ridOperatorEqual(a, b)

proc `<`*(a, b: RID): bool {.inline.} =
  getGDNativeAPI().ridOperatorLess(a, b)
