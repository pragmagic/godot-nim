# Copyright 2017 Xored Software, Inc.

import internal / [
       godotobjects, godotarrays, godotnodepaths, godotpoolarrays,
       godotstrings, godotvariants, godotdictionaries]

export godotobjects, godotarrays, godotnodepaths, godotpoolarrays,
       godotstrings, godotvariants, godotdictionaries

const MAX_ARG_COUNT* = 128

# MethodBind API

type GodotMethodBind* = object

proc getMethod*(className: cstring; methodName: cstring): ptr GodotMethodBind {.
    importc: "godot_method_bind_get_method".}
proc ptrCall*(methodBind: ptr GodotMethodBind;
              instance: ptr GodotObject;
              args: ptr array[MAX_ARG_COUNT, pointer];
              ret: pointer) {.
    importc: "godot_method_bind_ptrcall".}
proc call*(methodBind: ptr GodotMethodBind;
           instance: ptr GodotObject;
           args: ptr array[MAX_ARG_COUNT, ptr GodotVariant]; argCount: cint;
           callError: var VariantCallError): GodotVariant {.
    importc: "godot_method_bind_call".}

# Script API

type
  GodotNativeInitOptions* = object
    inEditor*: bool
    coreApiHash*: uint64
    editorApiHash*: uint64
    noApiHash*: uint64
    gdNativeLibrary*: ptr GodotObject

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
  GodotPropertyUsageFlags* {.size: sizeof(cint), pure.} = enum
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
    usage*: GodotPropertyUsageFlags
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

proc godotScriptRegisterClass*(libHandle: pointer; name, base: cstring;
                               create_func: GodotInstanceCreateFunc;
                               destroy_func: GodotInstanceDestroyFunc) {.
    importc: "godot_nativescript_register_class".}
proc godotScriptRegisterToolClass*(libHandle: pointer; name, base: cstring;
                                   createFunc: GodotInstanceCreateFunc;
                                   destroyFunc: GodotInstanceDestroyFunc) {.
    importc: "godot_nativescript_register_tool_class".}
type
  GodotInstanceMethod* {.bycopy.} = object
    meth*:
      proc (obj: ptr GodotObject; methodData: pointer;
            userData: pointer; numArgs: cint;
            args: var array[MAX_ARG_COUNT, ptr GodotVariant]):
              GodotVariant {.noconv.}
    methodData*: pointer
    freeFunc*: proc (a2: pointer) {.noconv.}

proc godotScriptRegisterMethod*(libHandle: pointer;
                                name: cstring; function_name: cstring;
                                attr: GodotMethodAttributes;
                                meth: GodotInstanceMethod) {.
    importc: "godot_nativescript_register_method".}
type
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

proc godotScriptRegisterProperty*(libHandle: pointer;
                                  name: cstring; path: cstring;
                                  attr: var GodotPropertyAttributes;
                                  setFunc: GodotPropertySetFunc;
                                  getFunc: GodotPropertyGetFunc) {.
    importc: "godot_nativescript_register_property".}

type
  GodotSignalArgument* {.bycopy.} = object
    name*: GodotString
    typ*: cint
    hint*: GodotPropertyHint
    hintString*: GodotString
    usage*: GodotPropertyUsageFlags
    defaultValue*: GodotVariant

  GodotSignal* = object
    name*: GodotString
    numArgs*: cint
    args*: ptr GodotSignalArgument
    numDefaultArgs*: cint
    defaultArgs*: ptr GodotVariant


proc godotScriptRegisterSignal*(libHandle: pointer; name: cstring;
                                signal: GodotSignal) {.
    importc: "godot_nativescript_register_signal".}

proc getUserdata*(instance: ptr GodotObject): pointer {.
    importc: "godot_nativescript_get_userdata".}

type ClassConstructor = proc (): ptr GodotObject {.noconv.}
proc getClassConstructor*(className: cstring): ClassConstructor {.
  importc: "godot_get_class_constructor".}

proc godotStackBottom*(): pointer {.
  importc: "godot_get_stack_bottom".}

proc deinit*(o: ptr GodotObject) {.
    importc: "godot_object_destroy".}

# print using Godot's error handler list

proc godotPrintError*(description: cstring; function: cstring; file: cstring;
                      line: cint) {.
  importc: "godot_print_error".}

proc godotPrintWarning*(description: cstring; function: cstring;
                        file: cstring; line: cint) {.
  importc: "godot_print_warning".}

proc godotPrint*(message: GodotString) {.
  importc: "godot_print".}

var getClassMethodBind: ptr GodotMethodBind
proc getClassName*(o: ptr GodotObject): string =
  if getClassMethodBind.isNil:
    getClassMethodBind = getMethod(cstring"Object", cstring"get_class")
  var ret: GodotString
  getClassMethodBind.ptrCall(o, nil, addr ret)
  result = $ret
  deinit(ret)
  if result.len > 2 and result[^2] == 'S' and result[^1] == 'W':
    # There are physics type not known by ClassDB
    result = result[0..result.len-3]

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
