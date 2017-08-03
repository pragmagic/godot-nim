# Copyright 2017 Xored Software, Inc.

import os, pegs, strutils
import docbuild

const indexTemplate = """<html>
<head><title>godot-nim docs index</title></head>
<body>
<h1>Documentation of Nim bindings for Godot Engine (<a href="https://github.com/$REPO_SLUG">GitHub</a>)</h1><br/>
$VERSION_LIST
</body>
</html>
"""

proc execOrQuit(cmd: string) =
  let ret = execShellCmd(cmd)
  if ret != 0:
    quit(ret)

proc walkDirRecRelative(dir: string, cb: proc (file: string), start = "") =
  for kind, path in walkDir(dir, relative = true):
    if kind in {pcFile, pcLinkToFile}:
      cb(if start.len > 0: start / path else: path)
    elif kind in {pcDir, pcLinkToDir}:
      let fullPath = if start.len > 0: start / path else: path
      walkDirRecRelative(dir / fullPath, cb, fullPath)

proc publish(docDir, gitHubToken, repoSlug, branch, tag, changeset: string) =
  let release = if branch == "master": branch else: tag
  let commitComment = if release == "master":
                        "Update master documentation for changeset " & changeset
                      else:
                        "Update documentation for " & tag

  const repoDir = "gh-pages"
  execOrQuit(
    "git clone --depth=1 --branch=gh-pages https://github.com/$#.git $#" %
    [repoSlug, repoDir])
  try:
    removeDir(repoDir/release)
    createDir(repoDir/release)
    var versionList = newStringOfCap(4096)
    for kind, path in walkDir(repoDir, relative = true):
      if kind == pcDir and not path.startsWith("."):
        versionList.add("<a href='$1/index.html'>$1</a><br/>" % path)
    let index = indexTemplate.replace("$REPO_SLUG", repoSlug).
                              replace("$VERSION_LIST", versionList)
    writeFile(repoDir/"index.html", index)

    walkDirRecRelative(docDir) do (file: string):
      createDir(parentDir(repoDir/release/file))
      copyFile(docDir/file, repoDir/release/file)

    setCurrentDir(repoDir)
    try:
      execOrQuit("git add --all")
      execOrQuit("git commit -m \"$#\"" % commitComment)
      execOrQuit("git push -fq \"https://$#@github.com/$#.git\" gh-pages" %
                [gitHubToken, repoSlug])
    finally:
      setCurrentDir("..")
  finally:
    removeDir(repoDir)

when isMainModule:
  proc getEnvOrQuit(key: string): string =
    result = getEnv(key)
    if result.len == 0:
      echo "Expected environment variable: " & key
      quit(1)

  let pr = getEnv("TRAVIS_PULL_REQUEST")
  if pr.len > 0 and pr != "false":
    echo "This is a PR build. Skipping."
    quit(0)

  let repoSlug = getEnvOrQuit("TRAVIS_REPO_SLUG")
  let branch = getEnvOrQuit("TRAVIS_BRANCH")
  let changeset = getEnvOrQuit("TRAVIS_COMMIT")
  let tag = getEnv("TRAVIS_TAG")

  # let repoSlug = "pragmagic/godot-nim"
  # let branch = "master"
  # let changeset = "0fd0101432c1fed1004f50b035fcf74f75f004a8"
  # let tag = ""

  let gitHubToken = getEnvOrQuit("GITHUB_TOKEN")

  if branch != "master" and not (tag =~ peg"^ 'v' \d+ '.' \d+ '.' \d+ $"):
    echo "This is not master or tagged changeset. Skipping."
    quit(0)

  let godotBin = getEnvOrQuit("GODOT_BIN")

  const docDir = "docgen"
  buildDocs(docDir, getCurrentDir(), godotBin)
  publish(docDir, gitHubToken, repoSlug, branch, tag, changeset)
