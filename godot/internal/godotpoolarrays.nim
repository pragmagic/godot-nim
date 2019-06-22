# Copyright (c) 2018 Xored Software, Inc.

import godotinternaltypes, gdnativeapi
import core/godotcoretypes

template genPoolArrayAPI(ArrayT, initIdent, DataT,
                         newProc, newCopyProc, newWithArrayProc, appendProc,
                         appendArrayProc, insertProc, invertProc, pushBackProc,
                         removeProc, resizeProc, setProc, getProc, sizeProc,
                         destroyProc, readProc, writeProc,
                         readAccessPtrProc, writeAccessPtrProc,
                         readAccessDestroyProc, writeAccessDestroyProc) =
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
    let data = getGDNativeAPI().getProc(self, idx)
    when DataT is Color:
      data.toColor()
    elif DataT is Vector2:
      data.toVector2()
    elif DataT is Vector3:
      data.toVector3()
    else:
      data

  proc len*(self: ArrayT): cint {.inline.} =
    getGDNativeAPI().sizeProc(self)

  iterator items*(self: ArrayT): DataT =
    let readAccess = getGDNativeAPI().readProc(self)
    let readPtr = getGDNativeAPI().readAccessPtrProc(readAccess)
    for i in 0.cint..<self.len:
      yield readPtr.offset(i)[]
    getGDNativeAPI().readAccessDestroyProc(readAccess)

  iterator mitems*(self: var ArrayT): var DataT =
    let writeAccess = getGDNativeAPI().writeProc(self)
    let writePtr = getGDNativeAPI().writeAccessPtrProc(writeAccess)
    for i in 0.cint..<self.len:
      yield writePtr.offset(i)[]
    getGDNativeAPI().writeAccessDestroyProc(writeAccess)

  iterator pairs*(self: ArrayT): tuple[key: cint, val: DataT] =
    let readAccess = getGDNativeAPI().readProc(self)
    let readPtr = getGDNativeAPI().readAccessPtrProc(readAccess)
    for i in 0.cint..<self.len:
      yield (i, readPtr.offset(i)[])
    getGDNativeAPI().readAccessDestroyProc(readAccess)

  iterator mpairs*(self: var ArrayT): tuple[key: cint, val: var DataT] =
    let writeAccess = getGDNativeAPI().writeProc(self)
    let writePtr = getGDNativeAPI().writeAccessPtrProc(writeAccess)
    for i in 0.cint..<self.len:
      yield (i, writePtr.offset(i)[])
    getGDNativeAPI().writeAccessDestroyProc(writeAccess)

  proc subarray*(self: ArrayT, idxFrom, idxTo: cint): ArrayT =
    ## Indexes are inclusive, negative values count from the end of the array.
    let ownLen = self.len
    var actualIdxFrom = if idxFrom < 0: idxFrom + ownLen
                        else: idxFrom
    var actualIdxTo = if idxTo < 0: idxTo + ownLen
                      else: idxTo

    initIdent(result)
    if actualIdxFrom < 0 or actualIdxFrom >= ownLen:
      let instInfo = instantiationInfo()
      getGDNativeAPI().printError(
        cstring"Invalid subarray begin index", cstring"subarray", instInfo.filename, instInfo.line.cint)
      return
    if actualIdxTo < 0 or actualIdxTo >= ownLen:
      let instInfo = instantiationInfo()
      getGDNativeAPI().printError(
        cstring"Invalid subarray end index", cstring"subarray", instInfo.filename, instInfo.line.cint)
      return
    let span = actualIdxTo - actualIdxFrom + 1
    result.setLen(span)
    let readAccess = getGDNativeAPI().readProc(self)
    let writeAccess = getGDNativeAPI().writeProc(result)
    let readPtr = getGDNativeAPI().readAccessPtrProc(readAccess).offset(actualIdxFrom)
    copyMem(getGDNativeAPI().writeAccessPtrProc(writeAccess), readPtr, span)
    getGDNativeAPI().readAccessDestroyProc(readAccess)
    getGDNativeAPI().writeAccessDestroyProc(writeAccess)

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
                poolByteArrayDestroy,
                poolByteArrayRead,
                poolByteArrayWrite,
                poolByteArrayReadAccessPtr,
                poolByteArrayWriteAccessPtr,
                poolByteArrayReadAccessDestroy,
                poolByteArrayWriteAccessDestroy)

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
                poolIntArrayDestroy,
                poolIntArrayRead,
                poolIntArrayWrite,
                poolIntArrayReadAccessPtr,
                poolIntArrayWriteAccessPtr,
                poolIntArrayReadAccessDestroy,
                poolIntArrayWriteAccessDestroy)

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
                poolRealArrayDestroy,
                poolRealArrayRead,
                poolRealArrayWrite,
                poolRealArrayReadAccessPtr,
                poolRealArrayWriteAccessPtr,
                poolRealArrayReadAccessDestroy,
                poolRealArrayWriteAccessDestroy)

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
                poolStringArrayDestroy,
                poolStringArrayRead,
                poolStringArrayWrite,
                poolStringArrayReadAccessPtr,
                poolStringArrayWriteAccessPtr,
                poolStringArrayReadAccessDestroy,
                poolStringArrayWriteAccessDestroy)

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
                poolVector2ArrayDestroy,
                poolVector2ArrayRead,
                poolVector2ArrayWrite,
                poolVector2ArrayReadAccessPtr,
                poolVector2ArrayWriteAccessPtr,
                poolVector2ArrayReadAccessDestroy,
                poolVector2ArrayWriteAccessDestroy)

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
                poolVector3ArrayDestroy,
                poolVector3ArrayRead,
                poolVector3ArrayWrite,
                poolVector3ArrayReadAccessPtr,
                poolVector3ArrayWriteAccessPtr,
                poolVector3ArrayReadAccessDestroy,
                poolVector3ArrayWriteAccessDestroy)

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
                poolColorArrayDestroy,
                poolColorArrayRead,
                poolColorArrayWrite,
                poolColorArrayReadAccessPtr,
                poolColorArrayWriteAccessPtr,
                poolColorArrayReadAccessDestroy,
                poolColorArrayWriteAccessDestroy)
