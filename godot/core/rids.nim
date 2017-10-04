# Copyright (c) 2017 Xored Software, Inc.

import godotcoretypes, internal.godotinternaltypes, gdnativeapi

proc initRID*(): RID {.inline.} =
  getGDNativeAPI().ridNew(result)

proc initRID*(obj: ptr GodotObject): RID {.inline.} =
  getGDNativeAPI().ridNewWithResource(result, obj)

proc id*(self: RID): uint32 {.inline.} =
  cast[uint32](getGDNativeAPI().ridGetId(self))

proc `$`*(self: RID): string {.inline.} =
  $self.id

proc `==`*(a, b: RID): bool {.inline.} =
  getGDNativeAPI().ridOperatorEqual(a, b)

proc `<`*(a, b: RID): bool {.inline.} =
  getGDNativeAPI().ridOperatorLess(a, b)
