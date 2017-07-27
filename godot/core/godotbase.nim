# Copyright (c) 2017 Xored Software, Inc.

import math

type
  Error* {.size: sizeof(cint), pure.} = enum
    OK,
    Failed,    ## Generic fail error
    Unavailable,    ## What is requested is unsupported/unavailable
    Unconfigured,   ## The object being used hasnt been properly set up yet
    Unauthorized,   ## Missing credentials for requested resource
    ParameterRangeError, ## Parameter given out of range (5)
    OutOfMemory,  ## Out of memory
    FileNotFound,
    FileBadDrive,
    FileBadPath,
    FileNoPermission, ##  (10)
    FileAlreadyInUse,
    FileCantOpen,
    FileCantWrite,
    FileCantRead,
    FileUnrecognized, ##  (15)
    FileCorrupt,
    FileMissingDependencies,
    FileEOF,
    CantOpen, ## Can't open a resource/socket/file
    CantCreate,    ##  (20)
    QueryFailed,
    AlreadyInUse,
    Locked, ## resource is locked
    Timeout,
    CantConnect, ##  (25)
    CantResolve,
    ConnectionError,
    CantAquireResource,
    CantFork,
    InvalidData, ## Data passed is invalid	(30)
    InvalidParameter, ## Parameter passed is invalid
    AlreadyExists, ## When adding, item already exists
    DoesNotExist, ## When retrieving/erasing, it item does not exist
    DatabaseCantRead, ## Database is full
    DatabaseCantWrite, ## Database is full	(35)
    CompilationFailed,
    MethodNotFound,
    LinkFailed,
    ScriptFailed,
    CyclicLink, ##  (40)
    InvalidDeclaration,
    DuplicateSymbol,
    PauseError,
    Busy,
    Skip, ##  (45)
    Help,           ## user requested help!!
    Bug,
      ## a bug in the software certainly happened, due to a double
      ## check failing or unexpected behavior.
    PrinterOnFire, ## the parallel port printer is engulfed in flames
    WTF ## shit happens, has never been used, though

const MAX_ARG_COUNT* = 128

type
  GodotObject* = object
  Array* {.byref.} = object
    p: pointer
  Variant* {.byref.} = object
    data: array[24, byte]

proc initArray(dest: var Array, src: Array) {.
    importc: "godot_array_new_copy".}

proc deinit(self: var Array) {.importc: "godot_array_destroy".}

proc `=`(self: var Array, other: Array) {.inline.} =
  initArray(self, other)

proc `=destroy`(self: Array) {.inline.} =
  unsafeAddr(self).deinit()

proc initVariant(dest: var Variant; src: Variant) {.
    importc: "godot_variant_new_copy".}

proc deinit*(self: var Variant) {.
    importc: "godot_variant_destroy".}

proc `=`(self: var Variant, other: Variant) {.inline.} =
  initVariant(self, other)

proc `=destroy`(self: Variant) {.inline.} =
  unsafeAddr(self).deinit()

# System Functions

proc godotAlloc*(bytes: cint): pointer {.
  importc: "godot_alloc".}
  ## Allocates the specified number of bytes.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
proc godotRealloc*(p: pointer; bytes: cint): pointer {.
  importc: "godot_realloc".}
  ## Reallocates the pointer for the specified number of bytes.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
proc godotFree*(p: pointer) {.importc: "godot_free".}
  ## Frees the memory pointed to by the pointer.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.

# print using Godot's error handler list

proc godotPrintError(description: cstring; function: cstring; file: cstring;
                     line: cint) {.
  importc: "godot_print_error".}

proc godotPrintWarning(description: cstring; function: cstring;
                       file: cstring; line: cint) {.
  importc: "godot_print_warning".}

template printWarning*(warn: typed) =
  let (filename, line) = instantiationInfo()
  godotPrintWarning(cstring($warn), nil, cstring(filename), line.cint)

template printError*(err: typed) =
  let (filename, line) = instantiationInfo()
  godotPrintError(cstring($err), nil, cstring(filename), line.cint)

# math helpers

const EPSILON = 0.00001'f32
proc isEqualApprox*(a, b: float32): bool {.inline.} =
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
