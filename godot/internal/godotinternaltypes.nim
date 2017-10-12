# Copyright 2017 Xored Software, Inc.

const MAX_ARG_COUNT* = 256

type
  GodotArray* {.byref.} = object
    data: array[sizeof(int), byte]

  GodotDictionary* {.byref.} = object
    data: array[sizeof(int), byte]

  GodotNodePath* {.byref.} = object
    data: array[sizeof(int), byte]

  GodotObject* = object

  GodotPoolByteArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolIntArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolRealArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolStringArray* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolVector2Array* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolVector3Array* {.byref.} = object
    data: array[sizeof(int), byte]
  GodotPoolColorArray* {.byref.} = object
    data: array[sizeof(int), byte]

  GodotString* {.byref.} = object
    data: array[sizeof(int), byte]

  VariantType* {.size: sizeof(cint), pure.} = enum
    Nil,   ##  atomic types
    Bool,
    Int,
    Real,
    String,
    # math types
    Vector2, ##  5
    Rect2,
    Vector3,
    Transform2D,
    Plane,
    Quat, ##  10
    Rect3,
    Basis,
    Transform, ##  misc types
    Color,
    NodePath, ##  15
    RID,
    Object,
    Dictionary,
    Array, ##  20
    # arrays
    PoolByteArray,
    PoolIntArray,
    PoolRealArray,
    PoolStringArray,
    PoolVector2Array, ##  25
    PoolVector3Array,
    PoolColorArray

  VariantCallErrorType* {.size: sizeof(cint), pure.} = enum
    OK,
    InvalidMethod,
    InvalidArgument,
    TooManyArguments,
    TooFewArguments,
    InstanceIsNull

  VariantCallError* = object
    error*: VariantCallErrorType
    argument*: cint
    expected*: VariantType

  GodotVariant* {.byref.} = object
    data: array[4 + sizeof(int) div 4, float32]

type GodotMethodBind* = object

type
  GodotNativeInitOptions* = object
    inEditor*: bool
    coreApiHash*: uint64
    editorApiHash*: uint64
    noApiHash*: uint64
    gdNativeLibrary*: ptr GodotObject
    gdNativeAPIStruct*: pointer
    activeLibraryPath*: ptr GodotString

  GodotNativeTerminateOptions* = object
    inEditor*: bool

  GodotMethodRPCMode* {.size: sizeof(cint), pure.} = enum
    Disabled,
    Remote,
    Sync,
    Master,
    Slave

  GodotMethodAttributes* = object
    rpcMode*: GodotMethodRPCMode

  GodotPropertyHint* {.size: sizeof(cint), pure.} = enum
    None, ## no hint provided.
    Range, ## hint_text = "min,max,step,slider; // slider is optional"
    ExpRange, ## hint_text = "min,max,step", exponential edit
    Enum, ## hint_text= "val1,val2,val3,etc"
    ExpEasing, ## exponential easing funciton (Math::ease)
    Length, ## hint_text= "length" (as integer)
    SpriteFrame,
    KeyAccel, ## hint_text= "length" (as integer)
    Flags, ##  hint_text= "flag1,flag2,etc" (as bit flags)
    Layers2DRender,
    Layers2DPhysics,
    Layers3DRender,
    Layers3DPhysics,
    File, ## a file path must be passed, hint_text (optionally)
          ## is a filter "*.png,*.wav,*.doc,"
    Dir,  ## a directort path must be passed
    GlobalFile, ## a file path must be passed, hint_text (optionally) is a
                ## filter "*.png,*.wav,*.doc,"
    GlobalDir, ## a directort path must be passed
    ResourceType, ## a resource object type
    MultilineText, ## used for string properties that can contain multiple lines
    ColorNoAlpha, ## used for ignoring alpha component when editing a color
    ImageCompressLossy,
    ImageCompressLossless,
    ObjectId,
    TypeString, ## a type string, the hint is the base type to choose
    NodePathToEditedNode, ## so something else can provide this
                          ## (used in scripts)
    MethodOfVariantType, ## a method of a type
    MethodOfBaseType, ## a method of a base type
    MethodOfInstance, ## a method of an instance
    MethodOfScript, ## a method of a script & base
    PropertyOfVariantType, ## a property of a type
    PropertyOfBaseType, ## a property of a base type
    PropertyOfInstance, ## a property of an instance
    PropertyOfScript, ## a property of a script & base
    PropertyHintMax

const
  GODOT_PROPERTY_USAGE_STORAGE_VALUE = 1.cint
  GODOT_PROPERTY_USAGE_EDITOR_VALUE = 2.cint
  GODOT_PROPERTY_USAGE_NETWORK_VALUE = 4.cint
  GODOT_PROPERTY_USAGE_EDITOR_HELPER_VALUE = 8.cint
  GODOT_PROPERTY_USAGE_CHECKABLE_VALUE = 16.cint
  GODOT_PROPERTY_USAGE_CHECKED_VALUE = 32.cint
  GODOT_PROPERTY_USAGE_INTERNATIONALIZED_VALUE = 64.cint
  GODOT_PROPERTY_USAGE_GROUP_VALUE = 128.cint
  GODOT_PROPERTY_USAGE_CATEGORY_VALUE = 256.cint
  GODOT_PROPERTY_USAGE_STORE_IF_NONZERO_VALUE = 512.cint
  GODOT_PROPERTY_USAGE_STORE_IF_NONONE_VALUE = 1024.cint
  GODOT_PROPERTY_USAGE_NO_INSTANCE_STATE_VALUE = 2048.cint
  GODOT_PROPERTY_USAGE_RESTART_IF_CHANGED_VALUE = 4096.cint
  GODOT_PROPERTY_USAGE_SCRIPT_VARIABLE_VALUE = 8192.cint
  GODOT_PROPERTY_USAGE_STORE_IF_NULL_VALUE = 16384.cint
  GODOT_PROPERTY_USAGE_ANIMATE_AS_TRIGGER_VALUE = 32768.cint
  GODOT_PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED_VALUE = 65536.cint

  GODOT_PROPERTY_USAGE_DEFAULT_VALUE: cint =
      GODOT_PROPERTY_USAGE_STORAGE_VALUE or GODOT_PROPERTY_USAGE_EDITOR_VALUE or
      GODOT_PROPERTY_USAGE_NETWORK_VALUE
  GODOT_PROPERTY_USAGE_DEFAULT_INTL_VALUE: cint =
      GODOT_PROPERTY_USAGE_STORAGE_VALUE or
      GODOT_PROPERTY_USAGE_EDITOR_VALUE or GODOT_PROPERTY_USAGE_NETWORK_VALUE or
      GODOT_PROPERTY_USAGE_INTERNATIONALIZED_VALUE
  GODOT_PROPERTY_USAGE_NOEDITOR_VALUE: cint =
      GODOT_PROPERTY_USAGE_STORAGE_VALUE or GODOT_PROPERTY_USAGE_NETWORK_VALUE

type
  GodotPropertyUsage* {.size: sizeof(cint), pure.} = enum
    Storage = GODOT_PROPERTY_USAGE_STORAGE_VALUE
    Editor = GODOT_PROPERTY_USAGE_EDITOR_VALUE
    Network = GODOT_PROPERTY_USAGE_NETWORK_VALUE
    NoEditor = GODOT_PROPERTY_USAGE_NOEDITOR_VALUE
    Default = GODOT_PROPERTY_USAGE_DEFAULT_VALUE
    EditorHelper = GODOT_PROPERTY_USAGE_EDITOR_HELPER_VALUE
    Checkable = GODOT_PROPERTY_USAGE_CHECKABLE_VALUE
      ## used for editing global variables
    Checked = GODOT_PROPERTY_USAGE_CHECKED_VALUE
      ## used for editing global variables
    Internationalized = GODOT_PROPERTY_USAGE_INTERNATIONALIZED_VALUE
      ## hint for internationalized strings
    DefaultIntl = GODOT_PROPERTY_USAGE_DEFAULT_INTL_VALUE
    Group = GODOT_PROPERTY_USAGE_GROUP_VALUE
      ## used for grouping props in the editor
    Category = GODOT_PROPERTY_USAGE_CATEGORY_VALUE
    NonZero = GODOT_PROPERTY_USAGE_STORE_IF_NONZERO_VALUE
      ## only store if nonzero
    NonOne = GODOT_PROPERTY_USAGE_STORE_IF_NONONE_VALUE
      ## only store if false
    NoInstanceState = GODOT_PROPERTY_USAGE_NO_INSTANCE_STATE_VALUE
    RestartIfChanged = GODOT_PROPERTY_USAGE_RESTART_IF_CHANGED_VALUE
    ScriptVariable = GODOT_PROPERTY_USAGE_SCRIPT_VARIABLE_VALUE
    StoreIfNull = GODOT_PROPERTY_USAGE_STORE_IF_NULL_VALUE
    AnimateAsTrigger = GODOT_PROPERTY_USAGE_ANIMATE_AS_TRIGGER_VALUE
    UpdateAllIfModified = GODOT_PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED_VALUE

  GodotPropertyAttributes* {.bycopy.} = object
    rsetType*: GodotMethodRPCMode
    typ*: cint
    hint*: GodotPropertyHint
    hintString*: GodotString
    usage*: cint
    defaultValue*: GodotVariant

  GodotInstanceCreateFunc* {.bycopy.} = object
    createFunc*:
      proc (obj: ptr GodotObject; methodData: pointer): pointer {.noconv.}
        ## returns user data
    methodData*: pointer
    freeFunc*: proc (a2: pointer) {.noconv.}

  GodotInstanceDestroyFunc* {.bycopy.} = object
    destroyFunc*:
      proc (obj: ptr GodotObject; methodData: pointer;
            userData: pointer) {.noconv.}
    methodData*: pointer
    freeFunc*: proc (a2: pointer) {.noconv.}

  GodotInstanceMethod* {.bycopy.} = object
    meth*:
      proc (obj: ptr GodotObject; methodData: pointer;
            userData: pointer; numArgs: cint;
            args: var array[MAX_ARG_COUNT, ptr GodotVariant]):
              GodotVariant {.noconv.}
    methodData*: pointer
    freeFunc*: proc (a2: pointer) {.noconv.}

  GodotPropertySetFunc* {.bycopy.} = object
    setFunc*: proc (obj: ptr GodotObject; methodData: pointer;
                    userData: pointer; value: GodotVariant) {.noconv.}
    methodData*: pointer
    freeFunc*: proc (a2: pointer) {.noconv.}

  GodotPropertyGetFunc* {.bycopy.} = object
    getFunc*: proc (obj: ptr GodotObject; methodData: pointer;
                    userData: pointer): GodotVariant {.noconv.}
    methodData*: pointer
    freeFunc*: proc (a2: pointer) {.noconv.}

  GodotSignalArgument* {.bycopy.} = object
    name*: GodotString
    typ*: cint
    hint*: GodotPropertyHint
    hintString*: GodotString
    usage*: cint
    defaultValue*: GodotVariant

  GodotSignal* = object
    name*: GodotString
    numArgs*: cint
    args*: ptr GodotSignalArgument
    numDefaultArgs*: cint
    defaultArgs*: ptr GodotVariant

  GodotClassConstructor* = proc (): ptr GodotObject {.
    noconv, gcsafe, locks: 0, raises: [], tags: [].}
