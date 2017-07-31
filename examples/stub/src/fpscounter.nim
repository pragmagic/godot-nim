# Copyright 2017 Xored Software, Inc.

import strutils
import godot
import engine, label

gdobj FPSCounter of Label:
  var lastFPS: float32

  method ready*() =
    setProcess(true)

  method process*(delta: float64) =
    let fps = getFramesPerSecond()
    if int(fps * 10) != int(lastFPS * 10):
      lastFPS = fps
      self.text = "FPS: " & formatFloat(fps, ffDecimal, 1)
