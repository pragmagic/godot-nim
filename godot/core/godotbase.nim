# Copyright (c) 2018 Xored Software, Inc.

import math

# math helpers

const EPSILON = 0.00001'f32
proc isEqualApprox*(a, b: float32): bool {.inline.}  =
  abs(a - b) < EPSILON

proc isEqualApprox*(a, b: float64): bool {.inline.} =
  abs(a - b) < EPSILON

proc sign*(a: float32): float32 {.inline.} =
  if a < 0: -1.0'f32 else: 1.0'f32

proc sign*(a: float64): float64 {.inline.} =
  if a < 0: -1.0'f64 else: 1.0'f64

proc stepify*(value, step: float64): float64 =
  if step != 0'f64:
    floor(value / step + 0.5'f64) * step
  else:
    value

proc stepify*(value, step: float32): float32 =
  if step != 0'f32:
    floor(value / step + 0.5'f32) * step
  else:
    value
