import godotbase

type
  RID* {.importc: "godot_rid", header: "godot_rid.h", byref.} = object

proc initRID(dest: var RID) {.
    importc: "godot_rid_new",
    header: "godot_rid.h".}
proc initRID(dest: var RID; obj: ptr GodotObject) {.
    importc: "godot_rid_new_with_resource", header: "godot_rid.h".}

proc initRID*(): RID {.inline.} =
  initRID(result)

proc initRID*(obj: ptr GodotObject): RID {.inline.} =
  initRID(result, obj)

proc idCInt(self: RID): cint {.
    noSideEffect,
    importc: "godot_rid_get_id", header: "godot_rid.h".}

proc id*(self: RID): uint32 {.inline.} =
  cast[uint32](self.idCInt())

proc `==`*(a, b: RID): bool {.
    importc: "godot_rid_operator_equal", header: "godot_rid.h".}
proc `<`*(a, b: RID): bool {.
    importc: "godot_rid_operator_less", header: "godot_rid.h".}
