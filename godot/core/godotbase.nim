# Copyright (c) 2018 Xored Software, Inc.

import math, godotinternal

# math helpers

{.push stackTrace: off.}
const EPSILON = 0.00001'f32
proc isEqualApprox*(a, b: float32): bool {.inline, noinit.}  =
  abs(a - b) < EPSILON

proc isEqualApprox*(a, b: float64): bool {.inline, noinit.} =
  abs(a - b) < EPSILON

proc sign*(a: float32): float32 {.inline, noinit.} =
  if a < 0: -1.0'f32 else: 1.0'f32

proc sign*(a: float64): float64 {.inline, noinit.} =
  if a < 0: -1.0'f64 else: 1.0'f64

proc stepify*(value, step: float64): float64 {.inline, noinit.} =
  if step != 0'f64:
    floor(value / step + 0.5'f64) * step
  else:
    value

proc stepify*(value, step: float32): float32 {.inline, noinit.} =
  if step != 0'f32:
    floor(value / step + 0.5'f32) * step
  else:
    value

when (NimMajor, NimMinor, NimPatch) < (0, 20, 4):
  # Newer Nim has these procs in system module

  proc min*(x, y: float32): float32 {.inline, noinit.} =
    if x <= y: x else: y

  proc abs*(x: float32): float32 {.inline, noinit.} =
    if x < 0.0: -x else: x

  proc max*(x, y: float32): float32 {.inline, noinit.} =
    if y <= x: x else: y

{.pop.} # stackTrace: off

template printWarning*(warning: typed) =
  ## Prints ``warning`` to Godot log, adding filename and line information.
  let instInfo = instantiationInfo()
  godotPrintWarning(cstring($warning), cstring"", cstring(instInfo.filename), instInfo.line.cint)

template printError*(error: typed) =
  ## Prints ``error`` to Godot log, adding filename and line information.
  let instInfo = instantiationInfo()
  godotPrintError(cstring($error), cstring"", cstring(instInfo.filename), instInfo.line.cint)

proc print*(parts: varargs[string, `$`]) =
  ## Prints concatenated ``parts`` to Godot log.
  var combined = ""
  for v in parts:
    combined.add(v)
  var s = combined.toGodotString()
  godotPrint(s)
  s.deinit()
