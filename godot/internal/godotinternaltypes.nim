# Copyright 2017 Xored Software, Inc.

type
  GodotObject* = object
  GodotArray* {.byref.} = object
    p: pointer
  GodotVariant* {.byref.} = object
    data: array[24, byte]