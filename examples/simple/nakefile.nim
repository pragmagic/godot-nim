# Copyright 2017 Xored Software, Inc.

import nake
import os, ospaths, times
import apigen.apigen

proc cmdParams(): string =
  let params = commandLineParams()
  assert(params.len > 0)
  result = params[1..<params.len].join(" ")

proc genGodotApi() =
  let godotBin = getEnv("GODOT_BIN")
  if godotBin.isNil or godotBin.len == 0:
    echo "GODOT_BIN environment variable is not set"
    quit(-1)
  if not fileExists(godotBin):
    echo "Invalid GODOT_BIN path: " & godotBin
    quit(-1)

  const targetDir = "godotapi"
  createDir(targetDir)
  const jsonFile = "godotapi"/"api.json"
  if not fileExists(jsonFile) or
     godotBin.getLastModificationTime() > jsonFile.getLastModificationTime():
    direShell(godotBin, "--gdnative-generate-json-api", jsonFile)
    if not fileExists(jsonFile):
      echo "Failed to generate api.json"
      quit(-1)

    genApi(targetDir, jsonFile)

task "build", "Builds the client for the current platform":
  genGodotApi()
  withDir "src":
    direShell("nimble", "make")
