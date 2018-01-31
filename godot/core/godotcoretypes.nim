# Copyright 2018 Xored Software, Inc.

type
  Color* {.byref.} = object
    r*: float32
    g*: float32
    b*: float32
    a*: float32

  Vector3* {.byref.} = object
    x*: float32
    y*: float32
    z*: float32

  Vector2* {.byref.} = object
    x*: float32
    y*: float32

  Plane* {.byref.} = object
    normal*: Vector3
    d*: float32

  Basis* {.byref.} = object
    elements*: array[3, Vector3]

  Quat* {.byref.} = object
    x*: float32
    y*: float32
    z*: float32
    w*: float32

  AABB* {.byref.} = object
    position*: Vector3
    size*: Vector3

  Rect2* {.byref.} = object
    position*: Vector2
    size*: Vector2

  Transform2D* {.byref.} = object
    elements*: array[3, Vector2]

  Transform* {.byref.} = object
    basis*: Basis
    origin*: Vector3

  RID* {.byref.} = object
    data: array[sizeof(int), byte]

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
