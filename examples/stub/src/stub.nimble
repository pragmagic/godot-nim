version       = "0.1.0"
author        = "Xored Software, Inc."
description   = "Godot-Nim Project Stub"
license       = "MIT"
bin           = @["stub"]

requires "godot >= 0.3.0 & < 0.4.0"

task make, "build":
  const bitsPostfix = when sizeof(int) == 8: "_64" else: "_32"
  const libFile =
    when defined(windows):
      "nim" & bitsPostfix & ".dll"
    elif defined(ios):
      "nim_ios.dylib"
    elif defined(macosx):
      "nim_mac.dylib"
    elif defined(android):
      "nim_android.so"
    elif defined(linux):
      "nim_linux" & bitsPostfix & ".so"
    else: nil
  if libFile.isNil:
    raise newException(OSError, "Unsupported platform")

  exec "nimble build -y"
  const dir = "../project/_dlls/"
  const target = dir & libFile
  mkDir(dir)
  when defined(windows):
    rmFile(target)
    mvFile(bin[0] & ".exe", target)
  else:
    mvFile(bin[0], target)
