import internal.godotobjects

type
  RID* {.byref.} = object
    p: pointer

proc initRID(dest: var RID) {.
    importc: "godot_rid_new".}
proc initRID(dest: var RID; obj: ptr GodotObject) {.
    importc: "godot_rid_new_with_resource".}

proc initRID*(): RID {.inline.} =
  initRID(result)

proc initRID*(obj: ptr GodotObject): RID {.inline.} =
  initRID(result, obj)

proc idCInt(self: RID): cint {.
    noSideEffect,
    importc: "godot_rid_get_id".}

proc id*(self: RID): uint32 {.inline.} =
  cast[uint32](self.idCInt())

proc `==`*(a, b: RID): bool {.
    importc: "godot_rid_operator_equal".}
proc `<`*(a, b: RID): bool {.
    importc: "godot_rid_operator_less".}
