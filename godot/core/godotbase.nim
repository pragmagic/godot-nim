# Copyright (c) 2017 Xored Software, Inc.

type
  Error* {.importc: "godot_error", header: "godot/gdnative.h",
           size: sizeof(cint), pure.} = enum
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
  GodotObject* {.importc: "godot_object", header: "godot/gdnative.h".} = object
  Array* {.importc: "godot_array", header: "godot/array.h", byref.} = object
  Variant* {.importc: "godot_variant",
             header: "godot/variant.h", byref.} = object

proc initArray(dest: var Array, src: Array) {.
    importc: "godot_array_new_copy",
    header: "godot/array.h".}

proc deinit(self: var Array) {.importc: "godot_array_destroy",
    header: "godot/array.h".}

proc `=`(self: var Array, other: Array) {.inline.} =
  initArray(self, other)

proc `=destroy`(self: Array) {.inline.} =
  unsafeAddr(self).deinit()

proc initVariant(dest: var Variant; src: Variant) {.
    importc: "godot_variant_new_copy", header: "godot/variant.h".}

proc deinit*(self: var Variant) {.
    importc: "godot_variant_destroy", header: "godot/variant.h".}

proc `=`(self: var Variant, other: Variant) {.inline.} =
  initVariant(self, other)

proc `=destroy`(self: Variant) {.inline.} =
  unsafeAddr(self).deinit()

# System Functions

proc godotAlloc*(bytes: cint): pointer {.
  importc: "godot_alloc", header: "godot/gdnative.h".}
  ## Allocates the specified number of bytes.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
proc godotRealloc*(p: pointer; bytes: cint): pointer {.
  importc: "godot_realloc", header: "godot/gdnative.h".}
  ## Reallocates the pointer for the specified number of bytes.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
proc godotFree*(p: pointer) {.importc: "godot_free", header: "godot/gdnative.h".}
  ## Frees the memory pointed to by the pointer.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
