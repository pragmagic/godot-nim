# Copyright 2017 Xored Software, Inc.

import asyncdispatch
import godot, node

{.warning: ("NimRuntime is deprecated - it is no longer necessary to add it " &
            "as an AutoLoad class. It will be removed in v0.5.0.").}

gdobj NimRuntime of Node:
  method enterTree*() =
    discard getTree().connect("idle_frame", self, "idle", newArray())

  method exitTree*() =
    getTree().disconnect("idle_frame", self, "idle")

  proc idle*() {.gdExport.} =
    if asyncdispatch.hasPendingOperations():
      poll(0)
    GC_step(2000, false, 0)

when not defined(release):
  onUnhandledException = proc(errorMsg: string) =
    printError("Unhandled Nim exception: " & errorMsg)
