# Copyright 2018 Xored Software, Inc.

import internal/godotinternaltypes, internal/godotarrays,
       internal/godotnodepaths, internal/godotpoolarrays, internal/godotstrings,
       internal/godotvariants, internal/godotdictionaries

import gdnativeapi
export godotinternaltypes, godotarrays, godotnodepaths, godotpoolarrays,
       godotstrings, godotvariants, godotdictionaries

proc getMethod*(className: cstring;
                methodName: cstring): ptr GodotMethodBind {.inline.} =
  getGDNativeAPI().methodBindGetMethod(className, methodName)

proc ptrCall*(methodBind: ptr GodotMethodBind;
              instance: ptr GodotObject;
              args: ptr array[MAX_ARG_COUNT, pointer];
              ret: pointer) {.inline.} =
  getGDNativeAPI().methodBindPtrCall(methodBind, instance, args, ret)

proc call*(methodBind: ptr GodotMethodBind;
           instance: ptr GodotObject;
           args: ptr array[MAX_ARG_COUNT, ptr GodotVariant]; argCount: cint;
           callError: var VariantCallError): GodotVariant {.inline.} =
  getGDNativeAPI().methodBindCall(
    methodBind, instance, args, argCount, callError)

proc nativeScriptRegisterClass*(libHandle: pointer; name, base: cstring;
                                createFunc: GodotInstanceCreateFunc;
                                destroyFunc: GodotInstanceDestroyFunc)
                               {.inline.} =
  getGDNativeAPI().nativeScriptRegisterClass(
    libHandle, name, base, createFunc, destroyFunc)

proc nativeScriptRegisterToolClass*(libHandle: pointer; name, base: cstring;
                                    createFunc: GodotInstanceCreateFunc;
                                    destroyFunc: GodotInstanceDestroyFunc)
                                   {.inline.} =
  getGDNativeAPI().nativeScriptRegisterToolClass(
    libHandle, name, base, createFunc, destroyFunc)

proc nativeScriptRegisterMethod*(libHandle: pointer;
                                 name: cstring; function_name: cstring;
                                 attr: GodotMethodAttributes;
                                 meth: GodotInstanceMethod) {.inline.} =
  getGDNativeAPI().nativeScriptRegisterMethod(
    libHandle, name, functionName, attr, meth)

proc nativeScriptRegisterProperty*(libHandle: pointer;
                                   name, path: cstring;
                                   attr: ptr GodotPropertyAttributes;
                                   setFunc: GodotPropertySetFunc;
                                   getFunc: GodotPropertyGetFunc) {.inline.} =
  getGDNativeAPI().nativeScriptRegisterProperty(
    libHandle, name, path, attr, setFunc, getFunc)

proc nativeScriptRegisterSignal*(libHandle: pointer; name: cstring;
                                 signal: GodotSignal) {.inline.} =
  getGDNativeAPI().nativeScriptRegisterSignal(libHandle, name, signal)

proc getUserdata*(instance: ptr GodotObject): pointer {.inline.} =
  getGDNativeAPI().nativeScriptGetUserdata(instance)

proc getClassConstructor*(className: cstring): GodotClassConstructor
                         {.inline.} =
  getGDNativeAPI().getClassConstructor(className)

proc deinit*(o: ptr GodotObject) {.inline.} =
  getGDNativeAPI().objectDestroy(o)

# print using Godot's error handler list

proc godotPrintError*(description, function, file: cstring;
                      line: cint) {.inline.} =
  getGDNativeAPI().printError(description, function, file, line)

proc godotPrintWarning*(description, function, file: cstring;
                        line: cint) {.inline.} =
  getGDNativeAPI().printWarning(description, function, file, line)

proc godotPrint*(message: GodotString) {.inline.} =
  getGDNativeAPI().print(message)

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

proc getClassNameRaw*(o: ptr GodotObject): GodotString =
  if getClassMethodBind.isNil:
    getClassMethodBind = getMethod(cstring"Object", cstring"get_class")
  getClassMethodBind.ptrCall(o, nil, addr result)

proc getGodotSingleton*(name: cstring): ptr GodotObject {.inline.} =
  getGDNativeAPI().globalGetSingleton(name)

# System Functions

proc godotAlloc*(bytes: cint): pointer {.inline.} =
  ## Allocates the specified number of bytes.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
  getGDNativeAPI().alloc(bytes)

proc godotRealloc*(p: pointer; bytes: cint): pointer {.inline.} =
  ## Reallocates the pointer for the specified number of bytes.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
  getGDNativeAPI().realloc(p, bytes)

proc godotFree*(p: pointer) {.inline.} =
  ## Frees the memory pointed to by the pointer.
  ## Using this instead of stdlib proc will help Godot track how much memory
  ## is in use in debug mode.
  getGDNativeAPI().free(p)
