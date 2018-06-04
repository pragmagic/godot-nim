# Copyright 2018 Xored Software, Inc.

import threadpool, os, osproc, strutils, sequtils, pegs

import "../godot/godotapigen.nim"

const dirs = ["godot"/"core", "godot"/"internal", "godot"/"nim"]
const files = ["godot"/"godotapigen.nim", "godot"/"godotinternal.nim",
               "godot"/"godot.nim"]
const indexFile = "docs"/"index.rst"
const gitHubUrl = "https://github.com/pragmagic/godot-nim"

proc outName(outDir, file: string): string =
  outDir / file.extractFilename().changeFileExt("html")

template quoted(s: string): string =
  ('"' & s & '"')

proc execOrFail(cmd: string) =
  echo "[exec] " & cmd
  let ret = execShellCmd(cmd)
  if ret != 0:
    raise newException(
      Exception, "Command quit with exit code " & $ret & ": " & cmd)

template withDir(dir: string, body: typed) =
  let curDir = getCurrentDir()
  setCurrentDir(dir)
  try:
    body
  finally:
    setCurrentDir(curDir)

iterator walkDirRec(dir: string, filter: set[PathComponent],
                    extensions: openarray[string]): string =
  for file in walkDirRec(dir, filter):
    if not extensions.anyIt(file.endsWith(it)): continue
    yield file

proc genApiFiles(targetDir, godotBin: string) =
  let jsonFile = targetDir / "api.json"
  try:
    execOrFail(quoted(godotBin) &
               " --gdnative-generate-json-api " & quoted(jsonFile))
  except:
    # this fails unstably even if api.json is created successfully
    discard
  if not fileExists(jsonFile):
    raise newException(Exception, "Failed to generate Godot API wrappers")

  genApi(targetDir, jsonFile)

  writeFile(targetDir / "nim.cfg", "path=\"$projectdir/../../godot\"")

proc extractVersion(nimbleFile: string): string =
  let contents = readFile(nimbleFile)
  var matches: array[1, string]
  doAssert match(contents, peg"""'version' \s* '=' \s* '"' {@} '"' """, matches)
  result = matches[0]

proc fixupHrefs(file: string) =
  var contents = readFile(file)
  contents = contents.replacef(
    peg"""'href="' ('internal'/'core'/'nim') '/' {@} '"' """,
    "href=\"$#\"")
  if file.contains("godotapi"):
    contents = contents.replacef(
      peg"""'href="' {('godotinternal' / 'godot') '.html"'} """,
      "href=\"../$#")
  writeFile(file, contents)

proc getGitHash(): string =
  result = execProcess("git rev-parse HEAD")
  if not result.isNil and result.len > 0:
    result = result.replace("\L", "").replace("\r", "")

proc buildDocs*(outDir, godotNimDir, godotBin: string) =
  removeDir(outDir)
  createDir(outDir)
  let outDirAbs = expandFilename(outDir)
  let godotBinAbs = expandFilename(godotBin)

  setCurrentDir(godotNimDir)

  let godotNimVersion = extractVersion("godot.nimble")
  putEnv("godotnimversion", godotNimVersion)
  putEnv("godotnimgithub", gitHubUrl)
  let gitCommit = getGitHash()

  var allNimFiles = newSeq[string]()
  allNimFiles.add(files)
  for dir in dirs:
    for file in walkDirRec(dir, {pcFile, pcDir}, [".nim"]):
      allNimFiles.add(file)
  for file in allNimFiles:
    spawn execOrFail(
      "nim doc -d:useRealtimeGc --path:godot -o:" &
      quoted(outName(outDirAbs, file)) &
      " --git.url:" & quoted(gitHubUrl) &
      " --git.commit:" & quoted(gitCommit) &
      ' ' & quoted(file))

  let godotApiFolder = outDirAbs / "godotapi"
  createDir(godotApiFolder)
  genApiFiles(godotApiFolder, godotBinAbs)
  for file in walkDirRec(godotApiFolder, {pcFile, pcDir}, [".nim"]):
    spawn execOrFail("nim doc -d:useRealtimeGc --path:godot -o:" &
                     quoted(outName(godotApiFolder, file)) & ' ' & quoted(file))

  sync()

  var gitHash: string
  withDir(godotBinAbs.parentDir()):
    gitHash = getGitHash()
    if gitHash.isNil or gitHash.len == 0:
      raise newException(Exception,
        "Godot executable is not under Git repository")

  var indexContent = readFile(indexFile)
  var apiList = newStringOfCap(4096)
  for file in walkDirRec(godotApiFolder, {pcFile, pcDir}):
    if not file.endsWith(".html"):
      removeFile(file)
    else:
      let moduleHtml = file.extractFileName()
      let moduleName = moduleHtml.changeFileExt("")
      apiList.add("* `" & moduleName & " <godotapi/" & moduleHtml & ">`_\L")
  indexContent = indexContent.replace("$GODOTAPI_CHANGESET_HASH", gitHash).
                              replace("$AUTO_GENERATED_GODOTAPI_LIST", apiList).
                              replace("$GODOTNIM_GITHUB_URL", gitHubUrl)

  let tmpRst = outDirAbs/"index.rst"
  writeFile(tmpRst, indexContent)
  try:
    execOrFail("nim rst2html -o:" & quoted(outName(outDirAbs, tmpRst)) &
               ' ' & quoted(tmpRst))
  finally:
    removeFile(tmpRst)

  for file in walkDirRec(outDir, {pcFile, pcDir}, [".html"]):
    spawn fixupHrefs(file)

  sync()

when isMainModule:
  const outDir = "docgen"

  if not fileExists("godot.nimble"):
    echo "Must be executed from godot-nim root dir"
    quit(-1)

  let godotBin = getEnv("GODOT_BIN")
  if godotBin.len == 0:
    echo "GODOT_BIN environment variable must point to Godot executable"
    quit(-1)

  try:
    buildDocs(outDir, getCurrentDir(), godotBin)
  except:
    echo getCurrentExceptionMsg()
    quit(-1)
