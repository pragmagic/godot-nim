# Copyright 2019 Xored Software, Inc.

when (NimMajor, NimMinor, NimPatch) < (0, 19, 0):
  import macros, sets

  proc strVal(n: NimNode): string {.used.} =
    case n.kind
    of nnkIdent:
      $n.ident
    of nnkSym:
      $n.symbol
    else:
      macros.strVal(n)

  proc toHashSet[A](keys: openArray[A]): HashSet[A] {.inline, used.} =
    toSet(keys)

  proc initHashSet[A](): HashSet[A] {.inline, used.} =
    initSet[A]()
