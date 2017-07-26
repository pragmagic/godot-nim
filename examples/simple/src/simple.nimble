version       = "0.1.0"
author        = "Xored Software, Inc."
description   = "FPS Counter Sample"
license       = "MIT"
bin           = @["simple"]

requires "https://github.com/pragmagic/godot-nim.git >= 0.2.2 & < 0.3.0"

task make, "build":
  const archPostfix = when sizeof(int) == 8: "_64" else: "_32"
  const libFile =
    when defined(windows):
      "nim" & archPostfix & ".dll"
    elif defined(ios):
      "nim_ios.dylib"
    elif defined(macosx):
      "nim_mac.dylib"
    elif defined(android):
      "nim_android.so"
    elif defined(linux):
      "nim_linux" & archPostfix & ".so"
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
