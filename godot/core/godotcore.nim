# Copyright (c) 2017 Xored Software, Inc.

import godotbase
import strings, vector2, rect2, vector3, transform2d, plane, quat
import rect3, basis, transform, color, nodepath, rid
import dictionary, arrays, poolarray, variant

export godotbase, strings, vector2, rect2, vector3, transform2d, plane, quat,
       rect3, basis, transform, color, nodepath, rid, dictionary, arrays,
       poolarray, variant

# MethodBind API

type
  GodotMethodBind* {.importc: "godot_method_bind",
                     header: "godot/gdnative.h".} = object

proc getMethod*(className: cstring; methodName: cstring): ptr GodotMethodBind {.
    importc: "godot_method_bind_get_method", header: "godot/gdnative.h".}
proc ptrCall*(methodBind: ptr GodotMethodBind;
              instance: ptr GodotObject;
              args: ptr array[MAX_ARG_COUNT, pointer];
              ret: pointer) {.
    importc: "godot_method_bind_ptrcall", header: "godot/gdnative.h".}
proc call*(methodBind: ptr GodotMethodBind;
           instance: ptr GodotObject;
           args: ptr array[MAX_ARG_COUNT, Variant]; argCount: cint;
           callError: var VariantCallError): Variant {.
    importc: "godot_method_bind_call", header: "godot/gdnative.h".}

# Script API

type
  GodotNativeInitOptions* {.importc: "godot_gdnative_init_options",
                            header: "godot/gdnative.h".} = object
    inEditor* {.importc: "in_editor".}: bool
    coreApiHash* {.importc: "core_api_hash".}: uint64
    editorApiHash* {.importc: "editor_api_hash".}: uint64
    noApiHash* {.importc: "no_api_hash".}: uint64

  GodotNativeTerminateOptions* {.importc: "godot_gdnative_terminate_options",
                                 header: "godot/gdnative.h".} = object
    inEditor* {.importc: "in_editor".}: bool

  GodotMethodRPCMode* {.importc: "godot_method_rpc_mode",
                        header: "godot_nativescript.h",
                        size: sizeof(cint), pure.} = enum
    Disabled,
    Remote,
    Sync,
    Master,
    Slave

  GodotMethodAttributes* {.importc: "godot_method_attributes",
                           header: "godot_nativescript.h".} = object
    rpcMode* {.importc: "rpc_type".}: GodotMethodRPCMode

  GodotPropertyHint* {.importc: "godot_property_hint",
                       header: "godot_nativescript.h",
                       size: sizeof(cint), pure.} = enum
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
  GodotPropertyUsageFlags* {.importc: "godot_property_usage_flags",
                             header: "godot_nativescript.h", size: sizeof(cint),
                             pure.} = enum
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

  GodotPropertyAttributes* {.importc: "godot_property_attributes",
                             header: "godot_nativescript.h", bycopy.} = object
    rsetType* {.importc: "rset_type".}: GodotMethodRPCMode
    typ* {.importc: "type".}: cint
    hint* {.importc: "hint".}: GodotPropertyHint
    hintString* {.importc: "hint_string".}: GodotString
    usage* {.importc: "usage".}: GodotPropertyUsageFlags
    defaultValue* {.importc: "default_value".}: Variant

  GodotInstanceCreateFunc* {.importc: "godot_instance_create_func",
                             header: "godot_nativescript.h", bycopy.} = object
    createFunc* {.importc: "create_func".}:
      proc (obj: ptr GodotObject; methodData: pointer): pointer {.noconv.}
        ## returns user data
    methodData* {.importc: "method_data".}: pointer
    freeFunc* {.importc: "free_func".}: proc (a2: pointer) {.noconv.}

  GodotInstanceDestroyFunc* {.importc: "godot_instance_destroy_func",
                              header: "godot_nativescript.h", bycopy.} = object
    destroyFunc* {.importc: "destroy_func".}:
      proc (obj: ptr GodotObject; methodData: pointer;
            userData: pointer) {.noconv.}
    methodData* {.importc: "method_data".}: pointer
    freeFunc* {.importc: "free_func".}: proc (a2: pointer) {.noconv.}

proc godotScriptRegisterClass*(libHandle: pointer; name, base: cstring;
                               create_func: GodotInstanceCreateFunc;
                               destroy_func: GodotInstanceDestroyFunc) {.
    importc: "godot_nativescript_register_class",
    header: "godot_nativescript.h".}
proc godotScriptRegisterToolClass*(libHandle: pointer; name, base: cstring;
                                   createFunc: GodotInstanceCreateFunc;
                                   destroyFunc: GodotInstanceDestroyFunc) {.
    importc: "godot_nativescript_register_tool_class",
    header: "godot_nativescript.h".}
type
  GodotInstanceMethod* {.importc: "godot_instance_method",
                         header: "godot_nativescript.h", bycopy.} = object
    meth* {.importc: "method".}:
      proc (obj: ptr GodotObject; methodData: pointer;
            userData: pointer; numArgs: cint;
            args: var ptr array[MAX_ARG_COUNT, Variant]): Variant {.noconv.}
    methodData* {.importc: "method_data".}: pointer
    freeFunc* {.importc: "free_func".}: proc (a2: pointer) {.noconv.}

proc godotScriptRegisterMethod*(libHandle: pointer;
                                name: cstring; function_name: cstring;
                                attr: GodotMethodAttributes;
                                meth: GodotInstanceMethod) {.
    importc: "godot_nativescript_register_method",
    header: "godot_nativescript.h".}
type
  GodotPropertySetFunc* {.importc: "godot_property_set_func",
                          header: "godot_nativescript.h", bycopy.} = object
    setFunc* {.importc: "set_func".}: proc (obj: ptr GodotObject;
                                            methodData: pointer;
                                            userData: pointer;
                                            value: Variant) {.noconv.}
    methodData* {.importc: "method_data".}: pointer
    freeFunc* {.importc: "free_func".}: proc (a2: pointer) {.noconv.}

  GodotPropertyGetFunc* {.importc: "godot_property_get_func",
                          header: "godot_nativescript.h", bycopy.} = object
    getFunc* {.importc: "get_func".}:
      proc (obj: ptr GodotObject; methodData: pointer;
            userData: pointer): Variant {.noconv.}
    methodData* {.importc: "method_data".}: pointer
    freeFunc* {.importc: "free_func".}: proc (a2: pointer) {.noconv.}

proc godotScriptRegisterProperty*(libHandle: pointer;
                                  name: cstring; path: cstring;
                                  attr: var GodotPropertyAttributes;
                                  setFunc: GodotPropertySetFunc;
                                  getFunc: GodotPropertyGetFunc) {.
    importc: "godot_nativescript_register_property",
    header: "godot_nativescript.h".}

type
  GodotSignalArgument* {.importc: "godot_signal_argument",
                         header: "godot_nativescript.h", bycopy.} = object
    name* {.importc: "name".}: GodotString
    typ* {.importc: "type".}: cint
    hint* {.importc: "hint".}: GodotPropertyHint
    hintString* {.importc: "hint_string".}: GodotString
    usage* {.importc: "usage".}: GodotPropertyUsageFlags
    defaultValue* {.importc: "default_value".}: Variant

  GodotSignal* {.importc: "godot_signal",
                 header: "godot_nativescript.h".} = object
    name* {.importc: "name".}: GodotString
    numArgs* {.importc: "num_args".}: cint
    args* {.importc: "args".}: ptr GodotSignalArgument
    numDefaultArgs* {.importc: "num_default_args".}: cint
    defaultArgs* {.importc: "default_args".}: ptr Variant

proc godotScriptRegisterSignal*(libHandle: pointer; name: cstring;
                                signal: GodotSignal) {.
    importc: "godot_nativescript_register_signal",
    header: "godot_nativescript.h".}

proc getUserdata*(instance: ptr GodotObject): pointer {.
    importc: "godot_nativescript_get_userdata", header: "godot_nativescript.h".}

proc godotNew*(p_classname: cstring): ptr GodotObject {.
  importc: "godot_nativescript_new", header: "godot_nativescript.h".}

proc godotStackBottom*(): pointer {.
  importc: "godot_get_stack_bottom", header: "godot/gdnative.h".}

proc deinit*(o: ptr GodotObject) {.
    importc: "godot_object_destroy", header: "godot/gdnative.h".}

# print using Godot's error handler list

proc godotPrintError(description: cstring; function: cstring; file: cstring;
                     line: cint) {.
  importc: "godot_print_error", header: "godot/gdnative.h".}

proc godotPrintWarning(description: cstring; function: cstring;
                       file: cstring; line: cint) {.
  importc: "godot_print_warning", header: "godot/gdnative.h".}

proc godotPrint(message: GodotString) {.
  importc: "godot_print", header: "godot/gdnative.h".}

proc print*(message: string) {.inline.} =
  let s = message.toGodotString()
  godotPrint(s)

template printWarning*(warn: typed) =
  let (filename, line) = instantiationInfo()
  godotPrintWarning(cstring($warn), nil, cstring(filename), line.cint)

template printError*(err: typed) =
  let (filename, line) = instantiationInfo()
  godotPrintError(cstring($err), nil, cstring(filename), line.cint)
