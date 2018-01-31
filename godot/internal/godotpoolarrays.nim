# Copyright (c) 2018 Xored Software, Inc.

import godotinternaltypes, gdnativeapi
import core.godotcoretypes

template genPoolArrayAPI(ArrayT, initIdent, DataT,
                         newProc, newCopyProc, newWithArrayProc, appendProc,
                         appendArrayProc, insertProc, invertProc, pushBackProc,
                         removeProc, resizeProc, setProc, getProc, sizeProc,
                         destroyProc) =
  proc initIdent*(dest: var ArrayT) {.inline.} =
    getGDNativeAPI().newProc(dest)

  proc initIdent*(dest: var ArrayT; src: ArrayT) {.inline.} =
    getGDNativeAPI().newCopyProc(dest, src)

  proc initIdent*(dest: var ArrayT; arr: GodotArray) {.inline.} =
    getGDNativeAPI().newWithArrayProc(dest, arr)

  proc deinit*(self: var ArrayT) {.inline.} =
    getGDNativeAPI().destroyProc(self)

  proc add*(self: var ArrayT; data: DataT) {.inline.} =
    getGDNativeAPI().pushBackProc(self, data)

  proc add*(self: var ArrayT; arr: ArrayT) {.inline.} =
    getGDNativeAPI().appendArrayProc(self, arr)

  proc insert*(self: var ArrayT; idx: cint;
               data: DataT): Error {.inline.} =
    getGDNativeAPI().insertProc(self, idx, data)

  proc delete*(self: var ArrayT; idx: cint) {.inline.} =
    getGDNativeAPI().removeProc(self, idx)

  proc reverse*(self: var ArrayT) {.inline.} =
    getGDNativeAPI().invertProc(self)

  proc setLen*(self: var ArrayT; size: cint) {.inline.} =
    getGDNativeAPI().resizeProc(self, size)

  proc `[]=`*(self: var ArrayT; idx: cint; data: DataT) {.inline.} =
    getGDNativeAPI().setProc(self, idx, data)

  proc `[]`*(self: ArrayT; idx: cint): DataT {.inline.} =
    getGDNativeAPI().getProc(self, idx)

  proc len*(self: ArrayT): cint {.inline.} =
    getGDNativeAPI().sizeProc(self)

  iterator items*(arr: ArrayT): DataT =
    for i in 0.cint..<arr.len:
      yield arr[i]

  iterator pairs*(arr: ArrayT): tuple[key: cint, val: DataT] =
    for i in 0.cint..<arr.len:
      yield (i, arr[i])

genPoolArrayAPI(GodotPoolByteArray, initGodotPoolByteArray, byte,
                poolByteArrayNew,
                poolByteArrayNewCopy,
                poolByteArrayNewWithArray,
                poolByteArrayAppend,
                poolByteArrayAppendArray,
                poolByteArrayInsert,
                poolByteArrayInvert,
                poolByteArrayPushBack,
                poolByteArrayRemove,
                poolByteArrayResize,
                poolByteArraySet,
                poolByteArrayGet,
                poolByteArraySize,
                poolByteArrayDestroy)

genPoolArrayAPI(GodotPoolIntArray, initGodotPoolIntArray, cint,
                poolIntArrayNew,
                poolIntArrayNewCopy,
                poolIntArrayNewWithArray,
                poolIntArrayAppend,
                poolIntArrayAppendArray,
                poolIntArrayInsert,
                poolIntArrayInvert,
                poolIntArrayPushBack,
                poolIntArrayRemove,
                poolIntArrayResize,
                poolIntArraySet,
                poolIntArrayGet,
                poolIntArraySize,
                poolIntArrayDestroy)

genPoolArrayAPI(GodotPoolRealArray, initGodotPoolRealArray, float32,
                poolRealArrayNew,
                poolRealArrayNewCopy,
                poolRealArrayNewWithArray,
                poolRealArrayAppend,
                poolRealArrayAppendArray,
                poolRealArrayInsert,
                poolRealArrayInvert,
                poolRealArrayPushBack,
                poolRealArrayRemove,
                poolRealArrayResize,
                poolRealArraySet,
                poolRealArrayGet,
                poolRealArraySize,
                poolRealArrayDestroy)

genPoolArrayAPI(GodotPoolStringArray, initGodotPoolStringArray, GodotString,
                poolStringArrayNew,
                poolStringArrayNewCopy,
                poolStringArrayNewWithArray,
                poolStringArrayAppend,
                poolStringArrayAppendArray,
                poolStringArrayInsert,
                poolStringArrayInvert,
                poolStringArrayPushBack,
                poolStringArrayRemove,
                poolStringArrayResize,
                poolStringArraySet,
                poolStringArrayGet,
                poolStringArraySize,
                poolStringArrayDestroy)

genPoolArrayAPI(GodotPoolVector2Array, initGodotPoolVector2Array, Vector2,
                poolVector2ArrayNew,
                poolVector2ArrayNewCopy,
                poolVector2ArrayNewWithArray,
                poolVector2ArrayAppend,
                poolVector2ArrayAppendArray,
                poolVector2ArrayInsert,
                poolVector2ArrayInvert,
                poolVector2ArrayPushBack,
                poolVector2ArrayRemove,
                poolVector2ArrayResize,
                poolVector2ArraySet,
                poolVector2ArrayGet,
                poolVector2ArraySize,
                poolVector2ArrayDestroy)

genPoolArrayAPI(GodotPoolVector3Array, initGodotPoolVector3Array, Vector3,
                poolVector3ArrayNew,
                poolVector3ArrayNewCopy,
                poolVector3ArrayNewWithArray,
                poolVector3ArrayAppend,
                poolVector3ArrayAppendArray,
                poolVector3ArrayInsert,
                poolVector3ArrayInvert,
                poolVector3ArrayPushBack,
                poolVector3ArrayRemove,
                poolVector3ArrayResize,
                poolVector3ArraySet,
                poolVector3ArrayGet,
                poolVector3ArraySize,
                poolVector3ArrayDestroy)

genPoolArrayAPI(GodotPoolColorArray, initGodotPoolColorArray, Color,
                poolColorArrayNew,
                poolColorArrayNewCopy,
                poolColorArrayNewWithArray,
                poolColorArrayAppend,
                poolColorArrayAppendArray,
                poolColorArrayInsert,
                poolColorArrayInvert,
                poolColorArrayPushBack,
                poolColorArrayRemove,
                poolColorArrayResize,
                poolColorArraySet,
                poolColorArrayGet,
                poolColorArraySize,
                poolColorArrayDestroy)
