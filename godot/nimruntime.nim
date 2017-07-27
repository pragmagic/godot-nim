# Copyright 2017 Xored Software, Inc.

import asyncdispatch
import godot, node

gdobj NimRuntime of Node:
  method process*(delta: float64) =
    if asyncdispatch.hasPendingOperations():
      poll(0)
    GC_step(2000, false, 0)

when not defined(release):
  onUnhandledException = proc(errorMsg: string) =
    printError("Unhandled Nim exception: " & errorMsg)
