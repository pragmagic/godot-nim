# Copyright 2018 Xored Software, Inc.

import streams, json, os, strutils, times, sets, tables, options
import sequtils, algorithm
import compiler/ast, compiler/renderer, compiler/idents, compiler/astalgo

include "internal/backwardcompat.inc.nim"

when (NimMajor, NimMinor, NimPatch) >= (0, 19, 0):
  import compiler/lineinfos

when (NimMajor, NimMinor, NimPatch) >= (0, 19, 0):
  var gic = newIdentCache()

  proc getIdent(ident: string): PIdent =
    getIdent(gic, ident)

proc ident(ident: string): PNode =
  result = PNode(kind: nkIdent, ident: getIdent(ident))

proc newPNode(kind: TNodeKind): PNode =
  when (NimMajor, NimMinor, NimPatch) < (0, 19, 0):
    result = newNode(kind)
  else:
    result = PNode(kind: kind)
    result.info.fileIndex = InvalidFileIdx
    result.info.col = int16(-1)
    result.info.line = uint16(0)

proc addChain(node: PNode, others: varargs[PNode]): PNode {.discardable.} =
  for other in others:
    node.add(other)
  result = node

proc newIdentDefs(name, typ: PNode,
                  defaultVal: PNode = nil): PNode =
  result = newPNode(nkIdentDefs)
  result.add(name)
  result.add(typ)
  if defaultVal.isNil:
    result.add(newPNode(nkEmpty))
  else:
    result.add(defaultVal)

proc newProc(name: PNode, params: openArray[PNode], body = newPNode(nkEmpty),
             procType = nkProcDef): PNode =
  result = newPNode(procType)
  result.add(name)
  result.add(newPNode(nkEmpty))
  result.add(newPNode(nkEmpty))
  let formalParams = newPNode(nkFormalParams)
  for param in params:
    formalParams.add(param)
  result.add(formalParams)
  result.add(newPNode(nkEmpty))
  result.add(newPNode(nkEmpty))
  result.add(body)

proc newIfStmt(condition, body: PNode): PNode =
  result = newPNode(nkIfStmt)
  let branch = newPNode(nkElifBranch)
  result.add(branch)
  branch.add(condition)
  branch.add(body)

proc newCall(theProc: PNode, args: varargs[PNode]): PNode =
  result = newPNode(nkCall)
  result.add(theProc)
  for arg in args:
    result.add(arg)

proc newCall(theProc: string, args: varargs[PNode]): PNode =
  newCall(ident(theProc), args)

proc newStrLit(s: string): PNode =
  result = newPNode(nkStrLit)
  result.strVal = s

proc newRStrLit(s: string): PNode =
  result = newPNode(nkRStrLit)
  result.strVal = s

proc newCStringLit(s: string): PNode =
  newPNode(nkCallStrLit).addChain(ident("cstring"), newRStrLit(s))

proc newIntLit(val: BiggestInt): PNode =
  result = newPNode(nkIntLit)
  result.intVal = val

proc newInt64Lit(val: BiggestInt): PNode =
  result = newPNode(nkInt64Lit)
  result.intVal = val

proc newFloatLit(val: BiggestFloat): PNode =
  result = newPNode(nkFloatLit)
  result.floatVal = val

proc newFloat64Lit(val: BiggestFloat): PNode =
  result = newPNode(nkFloat64Lit)
  result.floatVal = val

proc newNilLit(): PNode =
  result = newPNode(nkNilLit)

proc newDotExpr(left, right: PNode): PNode =
  result = newPNode(nkDotExpr)
  result.add(left)
  result.add(right)

proc newCommand(left, right: PNode): PNode =
  result = newPNode(nkCommand)
  result.add(left)
  result.add(right)

proc infix(left, op, right: PNode): PNode =
  result = newPNode(nkInfix)
  result.add(op)
  result.add(left)
  result.add(right)

proc postfix(left: PNode, op: string): PNode =
  result = newPNode(nkPostfix)
  result.add(ident(op))
  result.add(left)

proc prefix(op: string, right: PNode): PNode =
  result = newPNode(nkPrefix)
  result.add(ident(op))
  result.add(right)

proc newBracketExpr(first, bracket: PNode): PNode =
  newPNode(nkBracketExpr).addChain(first, bracket)

proc newEmptyNode(): PNode =
  newPNode(nkEmpty)

type GodotType = ref object
  name: string
  godotName: string
  baseName: string
  doc: string
  derivedCount: int
  isSingleton: bool
  jsonNode: JsonNode

proc findCommonRoot(typeRegistry: Table[string, GodotType],
                    types: seq[string]): string =
  if types.len == 0: return "Object"
  var chains = newSeq[seq[string]](types.len)
  for idx, typ in types:
    chains[idx] = newSeq[string]()
    chains[idx].add(typ)
    var curTyp = typeRegistry[typ]
    while curTyp.baseName != "NimGodotObject":
      chains[idx].add(curTyp.baseName)
      curTyp = typeRegistry[curTyp.baseName]
    chains[idx].reverse()

  var idx = 0
  while true:
    var curType = none(string)
    var allEqual = true
    for chain in chains:
      if idx >= chain.len:
        allEqual = false
        break
      if curType.isNone:
        curType = some(chain[idx])
      elif curType.get != chain[idx]:
        allEqual = false
        break
    if allEqual:
      result = curType.get
    else:
      break
    inc idx

proc incDerivedCount(types: var Table[string, GodotType],
                     className: string) =
  let typ = types.getOrDefault(className)
  if not typ.isNil:
    inc typ.derivedCount
    types.incDerivedCount(typ.baseName)

proc toNimType(godotType: string): string =
  result = case godotType:
  of "float": "float64"
  of "int": "int64"
  of "String": "string"
  of "File": "godottypes.File"
  else: godotType

  if result.startsWith("enum."):
    result = if result == "enum.Error": "Error" else: "int64"

proc toNimType(types: Table[string, GodotType], godotType: string): string =
  let origType =
    if godotType.contains(','):
      findCommonRoot(types, godotType.split(','))
    else:
      godotType
  result = toNimType(origType)

proc toNimStyle(name: string): string =
  result = newStringOfCap(name.len + 1)
  var i = 0
  var makeUpperCase: bool
  while i < name.len:
    if name[i] == '_':
      if result.len != 0:
        makeUpperCase = true
    elif name[i] != '/': # remove slashes
      if makeUpperCase:
        result.add(name[i].toUpperAscii())
        makeUpperCase = false
      else:
        result.add(name[i])
    inc i

  while isKeyword(getIdent(result)):
    result.add(result[result.len - 1])

  if result == "result":
    result = "resultVal"

proc newRefTypeNode(typeSection: PNode, typ, base, doc: string,
                    isExported = true) =
  let typeDef = newPNode(nkTypeDef)
  typeSection.add(typeDef)
  if isExported:
    typeDef.add(postfix(ident(typ), "*"))
  else:
    typeDef.add(ident(typ))

  typeDef.add(newPNode(nkEmpty)) # generic
  let objTy = newPNode(nkObjectTy)
  let refTy = newPNode(nkRefTy)
  refTy.add(objTy)
  typeDef.add(refTy)

  objTy.add(newPNode(nkEmpty))
  let inherit = newPNode(nkOfInherit)
  inherit.add(ident(base))
  objTy.add(inherit)

  if doc.len > 0:
    let recList = newPNode(nkRecList)
    let docNode = newPNode(nkCommentStmt)
    docNode.comment = doc
    recList.add(docNode)
    objTy.add(recList)
  else:
    objTy.add(newPNode(nkEmpty))

proc makeConstSection(constObj: JsonNode): PNode =
  if constObj.len == 0:
    return newPNode(nkEmpty)

  result = newPNode(nkConstSection)
  for field, val in constObj:
    let def = newPNode(nkConstDef)
    def.add(postfix(ident(field), "*"))
    def.add(newPNode(nkEmpty)) # infer type
    var valNode: PNode
    if val.kind == JInt:
      valNode = newInt64Lit(val.num)
      # valNode.intVal = val.num
    elif val.kind == JFloat:
      valNode = newFloat64Lit(val.fnum)
    elif val.kind == JBool:
      valNode = ident($val.bval)
    elif val.kind == JString:
      valNode = newPNode(nkStrLit)
      valNode.strVal = val.str
    else:
      raise newException(ValueError, "Unexpected constant kind: " & $val.kind)
    def.add(valNode)
    result.add(def)

type
  ArgKind = enum
    Normal,
    VarArgs
    Bound

  MethodArg = object
    name: string
    typ: string
    defaultVal: JsonNode
    kind: ArgKind

  MethodInfo = ref object
    name: PNode
    godotName: string
    typ: GodotType
    args: seq[MethodArg]
    returnType: Option[string]
    isVirtual: bool
    isBase: bool
    isDiscardable: bool

const standardTypes = toHashSet(
  ["bool", "cint", "int", "uint8", "int8", "uint16", "int16", "uint32", "int32",
   "uint64", "Error",
   "int64", "float32", "cfloat", "float64", "GodotString", "Vector2", "Rect2",
   "Vector3", "Transform2D", "Plane", "Quat", "AABB", "Basis", "Transform",
   "Color", "RID", "NodePath", "Dictionary", "Variant", "Array",
   "PoolByteArray", "PoolIntArray", "PoolRealArray", "PoolStringArray",
   "PoolVector2Array", "PoolVector3Array", "PoolColorArray"])

const variantPrimitives = [
   "bool", "cint", "int", "uint8", "int8", "uint16", "int16", "uint32", "int32",
   "uint64", "Error",
   "int64", "float32", "cfloat", "float64", "GodotString", "Vector2", "Rect2",
   "Vector3", "Transform2D", "Plane", "Quat", "AABB", "Basis", "Transform",
   "Color", "RID"]

const smallIntTypes = toHashSet(["uint8", "int8", "uint16", "int16", "uint32",
                              "int32", "cint", "int", "Error"])
const int64Types = toHashSet(["uint64", "int64"])
const intTypes = union(smallIntTypes, int64Types)
const float64Types = toHashSet(["float64", "cdouble"])
const float32Types = toHashSet(["float32", "cfloat"])
const floatTypes = union(float64Types, float32Types)
const arrayTypes = toHashSet(["Array", "PoolByteArray",
  "PoolIntArray", "PoolRealArray", "PoolStringArray", "PoolVector2Array",
  "PoolVector3Array", "PoolColorArray"])
const wrapperTypes = union(arrayTypes,
                           toHashSet(["NodePath", "Dictionary", "Variant"]))

proc getInternalPtr(varName: PNode, typ: string): PNode =
  assert(typ in wrapperTypes or typ == "Object")
  result = newDotExpr(varName, ident("godot" & typ))

proc newNilCheck(ident, toAssign: PNode): PNode =
  newIfStmt(newCall("isNil", ident),
    newPNode(nkAsgn).addChain(ident).addChain(
      toAssign
    )
  )

proc singletonName(typ: string): PNode =
  ident("singleton" & typ)

proc makeDefaultValue(arg: MethodArg): PNode =
  result = newEmptyNode()
  if not arg.defaultVal.isNil:
    var failed = false
    if arg.typ == "bool":
      result = ident(arg.defaultVal.str.toLowerAscii())
    elif arg.typ in intTypes:
      result = newInt64Lit(parseBiggestInt(arg.defaultVal.str))
    elif arg.typ == "string" or arg.typ == "NodePath":
      result = newStrLit(arg.defaultVal.str)
    elif arg.typ in floatTypes:
      result = newFloatLit(parseFloat(arg.defaultVal.str))
    elif arg.defaultVal.str == "Null":
      if arg.typ == "Variant":
        result = newCall("newVariant")
      else:
        result = newNilLit()
    elif arg.typ == "Color":
      result = newCall("initColor",
          arg.defaultVal.str.split(',').mapIt(newFloatLit(parseFloat(it))))
    elif arg.typ == "RID" and arg.defaultVal.str == "[RID]":
      result = newCall("initRID")
    elif arg.typ in arrayTypes and (arg.defaultVal.str == "[]" or
         arg.defaultVal.str == "[" & arg.typ & "]"):
      result = newCall("new" & arg.typ)
    elif arg.typ == "Vector2" or arg.typ == "Vector3" or arg.typ == "Rect2":
      let parts = arg.defaultVal.str.replace("(", "").replace(")", "").
                         replace(" ", "").
                         split(',').mapIt(newFloatLit(parseFloat(it)))
      if arg.typ.endsWith("r2"):
        result = newCall("vec2", parts)
      elif arg.typ.endsWith('3'):
        result = newCall("vec3", parts)
      else:
        result = newCall("initRect2", parts)
    elif arg.defaultVal.str == "[Object:null]":
      result = newNilLit()
    elif arg.typ == "Transform":
      let transformParts = arg.defaultVal.str.replace(" ", "").split('-')
      doAssert(transformParts.len == 2)
      let basisParts = transformParts[0].split(',').mapIt(
        newFloatLit(parseFloat(it)))
      let originParts = transformParts[1].split(',').mapIt(
        newFloatLit(parseFloat(it)))
      let basis = newCall("initBasis", basisParts)
      let origin = newCall("vec3", originParts)
      result = newCall("initTransform", basis, origin)
    elif arg.typ == "Transform2D":
      let parts = arg.defaultVal.str.
        replace(" ", "").
        replace(")", "").
        replace("(", "").
        split(',').mapIt(newFloatLit(parseFloat(it)))
      doAssert(parts.len == 6)
      let xAxis = newCall("vec2", parts[0..1])
      let yAxis = newCall("vec2", parts[2..3])
      let origin = newCall("vec2", parts[4..5])
      result = newCall("initTransform2D", xAxis, yAxis, origin)
    elif arg.typ == "Variant":
      if arg.defaultVal.str == "0":
        result = newCall("newVariant", newIntLit(0))
      elif arg.defaultVal.str == "Null":
        result = newCall("newVariant")
      else:
        failed = true
    elif arg.typ == "Dictionary":
      result = newCall("newDictionary")
    else:
      failed = true

    if failed:
      raise newException(
        ValueError,
        "Cannot build default value from \"$#\" ($#) - please report this at https://github.com/pragmagic/godot-nim/issues" %
        [$arg.defaultVal, arg.typ])

proc boundArgName(idx: int): string =
  "godotBoundArg" & $idx

proc doGenerateMethod(tree: PNode, methodBindRegistry: var HashSet[string],
                      meth: MethodInfo, withImplementation: bool) =
  var body: PNode
  if not withImplementation:
    body = newPNode(nkEmpty)
  elif meth.godotName == "_init" and meth.typ.godotName == "Object":
    # It's not real (calling it crashes) and will be removed later,
    # but we use init() convention in Nim, so it needs to work.
    body = newPNode(nkStmtList).addChain(
      newPNode(nkDiscardStmt).addChain(newPNode(nkEmpty)))
  else:
    let methGodotName = if meth.godotName.startsWith('_'):
                          "underscore" & meth.godotName[1..^1]
                        else:
                          meth.godotName
    var methodBindName = toNimStyle(
      meth.typ.name & "_" & methGodotName & "_method_bind")
    if methodBindName[0].isUpperAscii():
      methodBindName[0] = methodBindName[0].toLowerAscii()
    if methodBindName notin methodBindRegistry:
      let methodBindDecl = newPNode(nkVarSection).addChain(
        newIdentDefs(
          newPNode(nkPragmaExpr).addChain(
            ident(methodBindName)).addChain(
              newPNode(nkPragma).addChain(ident("threadvar"))),
          newPNode(nkPtrTy).addChain(ident("GodotMethodBind"))
        ))
      tree.add(methodBindDecl)
      methodBindRegistry.incl(methodBindName)

    let nilCheck = newNilCheck(ident(methodBindName),
      newCall("getMethod", newCStringLit(meth.typ.godotName),
        newCStringLit(meth.godotName))
    )
    let vars = newPNode(nkVarSection)
    var varargsName = none(string)
    var isVarargs: bool
    var staticArgsLen: int
    var argLenNode = newIntLit(0)
    let argsName = ident("argsToPassToGodot")
    if meth.args.len > 0:
      for idx, arg in meth.args:
        if arg.kind == ArgKind.VarArgs:
          varargsName = some(arg.name)
          isVarargs = true
          vars.add(newIdentDefs(ident("callError"), ident("VariantCallError")))
        elif arg.kind == ArgKind.Bound:
          let argName = boundArgName(idx)
          vars.add(newIdentDefs(
            ident(argName), newPNode(nkEmpty), arg.makeDefaultValue()))

      let argsAlloc = newPNode(nkCast).addChain(
        newPNode(nkPtrTy).addChain(
          newPNode(nkBracketExpr).addChain(
            ident("array"), ident("MAX_ARG_COUNT"),
            if isVarargs: newPNode(nkPtrTy).addChain(ident("GodotVariant"))
            else: ident("pointer"))))
      staticArgsLen = if varargsName.isNone: meth.args.len
                      else: meth.args.len - 1
      if varargsName.isSome:
        argLenNode = newCall("cint",
                      infix(newIntLit(staticArgsLen),
                            ident("+"),
                            newDotExpr(ident(varargsName.get), ident("len"))))
        argsAlloc.add(newCall("godotAlloc", newCall("cint", infix(
          newCall("sizeof", newPNode(nkPtrTy).addChain(ident("GodotVariant"))), ident("*"),
          newPNode(nkPar).addChain(argLenNode))))
        )
      else:
        argLenNode = newCall("cint", newIntLit(staticArgsLen))
        vars.add(newIdentDefs(
          ident("argsStatic"),
          newPNode(nkBracketExpr).addChain(
            ident("array"), newIntLit(staticArgsLen), ident("pointer")),
          newPNode(nkEmpty)))
        argsAlloc.add(newCommand(ident("addr"), ident("argsStatic")))
      vars.add(newIdentDefs(argsName, newPNode(nkEmpty), argsAlloc))

    let argConversions = newPNode(nkStmtList)
    let destructors = newPNode(nkStmtList)
    for idx, arg in meth.args:
      var argName = if arg.kind == ArgKind.Bound: ident(boundArgName(idx))
                    else: ident(arg.name)
      if arg.kind == ArgKind.VarArgs:
        argName = newPNode(nkBracketExpr).addChain(
          ident(varargsName.get),
          infix(ident("idx"), ident("-"), newIntLit(staticArgsLen)))
      let argIdx = if arg.kind == ArgKind.VarArgs: ident("idx") else: newIntLit(idx)
      let isStandardType = arg.typ in standardTypes
      let isWrappedType = arg.typ in wrapperTypes
      let convArg =
        if varargsName.isSome:
          let isAlreadyVariant = arg.typ == "Variant"
          let variantIdent = if isAlreadyVariant: getInternalPtr(argName, "Variant")
                             else: ident("variant" & $idx)
          if not isAlreadyVariant:
            argConversions.add(newPNode(nkVarSection).addChain(
              newIdentDefs(variantIdent, ident("GodotVariant"), newEmptyNode())
            ))
            destructors.add(
              newCall("deinit", variantIdent)
            )
            if arg.typ in variantPrimitives:
              argConversions.add(
                newCall("initGodotVariant", variantIdent, argName)
              )
            elif arg.typ in wrapperTypes or arg.typ == "Object":
              argConversions.add(
                newCall("initGodotVariant", variantIdent, getInternalPtr(argName, arg.typ))
              )
            elif arg.typ == "string":
              let stringIdent = ident("variantString" & $idx)
              argConversions.addChain(
                newPNode(nkVarSection).addChain(
                  newIdentDefs(stringIdent, ident("GodotString"), newCall("toGodotString", argName))
                )
              ).addChain(
                newCall("initGodotVariant", variantIdent, stringIdent)
              )
              destructors.add(newCall("deinit", stringIdent))
            else:
              raise newException(ValueError,
                "Non-standard type $# for varargs params of method $# of type $#" %
                [arg.typ, meth.godotName, meth.typ.godotName])

          if isAlreadyVariant: variantIdent
          else: newCall("addr", variantIdent)
        elif isWrappedType: getInternalPtr(argName, arg.typ)
        elif isStandardType: newCall("unsafeAddr", argName)
        elif arg.typ == "string": newCall("unsafeAddr",
                      ident("argToPassToGodot" & $idx))
        else: ident("argToPassToGodot" & $idx) # object
      if not isStandardType and arg.kind == ArgKind.VarArgs:
        raise newException(ValueError,
          "Non-standard type $# for varargs params of method $# of type $#" %
            [arg.typ, meth.godotName, meth.typ.godotName])
      if not isStandardType and varargsName.isNone:
        if arg.typ == "string":
          argConversions.add(newPNode(nkVarSection).addChain(
            newIdentDefs(ident("argToPassToGodot" & $idx), newEmptyNode(),
                         newCall("toGodotString", argName))))
        else:
          let objVal = newIfStmt(
            prefix("not", newDotExpr(argName, ident"isNil")),
            newDotExpr(argName, ident("godotObject"))
          ).addChain(newPNode(nkElse).addChain(newNilLit()))
          argConversions.add(newPNode(nkLetSection).addChain(
            newIdentDefs(ident("argToPassToGodot" & $idx), newEmptyNode(), objVal)))
      let argAsgn = newPNode(nkAsgn).addChain(
        newPNode(nkBracketExpr).addChain(
          newPNode(nkBracketExpr).addChain(argsName), argIdx),
          convArg
      )
      if arg.kind != ArgKind.VarArgs:
        argConversions.add(
          argAsgn
        )
      else:
        argConversions.add(newPNode(nkVarSection).addChain(
          newIdentDefs(ident("idx"), newPNode(nkEmpty),
                       newIntLit(staticArgsLen))))
        let argLoop = newPNode(nkWhileStmt)
        argConversions.add(argLoop)
        argLoop.add(infix(ident("idx"), ident("<"), argLenNode)
        )
        argLoop.add(newPNode(nkStmtList).addChain(
          argAsgn,
          newCommand(ident("inc"), ident("idx"))))

    let retName = if isVarargs: "callRet" else: "ptrCallRet"
    let theCall = newCall(
      newDotExpr(ident(methodBindName),
                 ident(if isVarargs: "call" else: "ptrCall")),
      newDotExpr(ident("self"), ident("godotObject")),
      if meth.args.len > 0: argsName else: newPNode(nkNilLit),
      argLenNode,
      if not isVarargs: ident(retName) else: ident("callError")
    )
    if not isVarargs:
      theCall.sons.delete(3)
    let freeCall = newCall("godotFree", argsName)
    body = newPNode(nkStmtList)
    if meth.typ.isSingleton:
      let varName = singletonName(meth.typ.name)
      body.add(newNilCheck(varName, newCall(
        newBracketExpr(ident("getSingleton"), ident(meth.typ.name)))))
      body.add(newPNode(nkLetSection).addChain(newIdentDefs(
        ident("self"), newPNode(nkEmpty), varName
      )))
    body.add(nilCheck)
    body.add(vars)
    body.add(argConversions)
    if not isVarargs:
      let retPtrDecl = newPNode(nkVarSection).addChain(
        newIdentDefs(ident(retName), ident("pointer"), newEmptyNode())
      )
      body.add(retPtrDecl)
    var isVariantRet: bool
    var isConversionRet: bool
    var isObjRet: bool
    var isStringRet: bool
    var isWrapperRet: bool
    let retValIdent = if not isVarargs: ident("ptrCallVal") else: ident(retName)
    if meth.returnType.isSome and not isVarargs:
      let returnType = meth.returnType.get
      var addrToAssign = newCall("addr", retValIdent)
      if returnType in smallIntTypes:
        isConversionRet = true
        body.add(newPNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, ident("int64"),
        )))
      elif returnType in float32Types:
        isConversionRet = true
        body.add(newPNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, ident("float64"),
        )))
      elif returnType in wrapperTypes:
        isWrapperRet = true
        body.add(newPNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, ident("Godot" & returnType),
        )))
      elif returnType in standardTypes:
        addrToAssign = newCall("addr", ident("result"))
      elif returnType == "string":
        isStringRet = true
        body.add(newPNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, ident("GodotString"),
        )))
      elif returnType != "void":
        isObjRet = true
        body.add(newPNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, newPNode(nkPtrTy).addChain(ident("GodotObject")),
        )))
      body.add(newPNode(nkAsgn).addChain(ident(retName), addrToAssign))

    if not isVarargs:
      body.add(theCall)
    else:
      if meth.returnType.isSome:
        isVariantRet = true
      let callStmt = newPNode(nkLetSection).addChain(
        newIdentDefs(
          newPNode(nkPragmaExpr).addChain(
            ident(retName), newPNode(nkPragma).addChain(ident("used"))),
          newPNode(nkEmpty), theCall))
      body.add(callStmt)

    if varargsName.isNone:
      for idx, arg in meth.args:
        if arg.typ == "string":
          body.add(newCall("deinit", ident("argToPassToGodot" & $idx)))

    if varargsName.isSome:
      if meth.args.len > 0:
        body.add(freeCall)
      body.add(destructors)
      let errCheck = newIfStmt(
        infix(newDotExpr(ident("callError"), ident("error")), ident("!="),
                 newDotExpr(ident("VariantCallErrorType"), ident("OK"))),
        newPNode(nkRaiseStmt).addChain(
          newCall("newCallError", ident("callError")))
      )
      body.add(errCheck)
    if isVariantRet:
      let convErrDef = newPNode(nkLetSection).addChain(
          newIdentDefs(ident("convErr"), newPNode(nkEmpty),
              newCall("fromVariant", ident("result"),
                      newCall("newVariant", retValIdent))))
      let convCheck = newIfStmt(
        infix(ident("convErr"), ident("!="),
                 newDotExpr(ident("ConversionResult"), ident("OK"))),
        newPNode(nkRaiseStmt).addChain(
          newCall("newConversionError", ident("convErr")))
      )
      body.add(convErrDef)
      body.add(convCheck)
    if isStringRet:
      body.add(newPNode(nkAsgn).addChain(
        ident("result"), prefix("$", retValIdent)))
      body.add(newCall("deinit", retValIdent))
    elif isConversionRet:
      body.add(newPNode(nkAsgn).addChain(
        ident("result"),
        newCall(meth.returnType.get, retValIdent)))
    elif isWrapperRet:
      body.add(newPNode(nkAsgn).addChain(
        ident("result"),
        newCall("new" & meth.returnType.get, retValIdent)))
    elif isObjRet:
      body.add(newPNode(nkAsgn).addChain(ident("result"),
               newCall(newBracketExpr(ident("asNimGodotObject"),
        newCall("type", ident("result"))),
        retValIdent, ident("false"), ident("true"))))
    elif isStringRet:
      body.add(newPNode(nkAsgn).addChain(ident("result"),
                                        newCall("$", retValIdent)))

  let procType = if meth.isVirtual: nkMethodDef
                 else: nkProcDef
  var params = newSeqOfCap[PNode](meth.args.len + 2)
  if meth.returnType.isSome:
    params.add(ident(meth.returnType.get))
  else:
    params.add(newPNode(nkEmpty))
  if not meth.typ.isSingleton:
    params.add(newIdentDefs(ident("self"), ident(toNimType(meth.typ.name))))

  for arg in meth.args:
    case arg.kind:
    of ArgKind.Normal:
      let defaultValue = arg.makeDefaultValue()
      params.add(newIdentDefs(ident(arg.name), ident(arg.typ), defaultValue))
    of ArgKind.VarArgs:
      params.add(newIdentDefs(ident(arg.name),
        newPNode(nkBracketExpr).addChain(ident("varargs"), ident(arg.typ))))
    of ArgKind.Bound:
      discard

  let procDecl = newProc(if not withImplementation: postfix(meth.name, "*")
                         else: meth.name,
                         params, body, procType)
  if not withImplementation:
    let pragma = newPNode(nkPragma)
    pragma.add(ident("gcsafe"))
    pragma.add(newPNode(nkExprColonExpr).addChain(ident("locks"),
                                                newIntLit(0)))
    if meth.isVirtual and meth.isBase and meth.typ.name != "PhysicsBody":
      # Nim doesn't like `base` on PhysicsBody methods - wtf
      pragma.add(ident("base"))
    if meth.isDiscardable and meth.returnType.isSome:
      pragma.add(ident("discardable"))
    procDecl.sons[4] = pragma
  tree.add(procDecl)

proc generateMethod(tree: PNode, methodBindRegistry: var HashSet[string],
                    meth: MethodInfo, withImplementation: bool) =
  doGenerateMethod(tree, methodBindRegistry, meth, withImplementation)

proc getMethodInfo(methodObj: JsonNode, types: Table[string, GodotType],
                   typ: GodotType): MethodInfo =
  var origArgs = methodObj["arguments"]
  var isBase = methodObj["is_virtual"].bval
  if methodObj["is_virtual"].bval:
    proc getMethod(typNode: JsonNode, methName: string): JsonNode =
      for meth in typNode["methods"]:
        if meth["is_virtual"].bval and
           meth["name"].str == methName: return meth
    var curTyp = types.getOrDefault(typ.baseName)
    while not curTyp.isNil:
      let meth = curTyp.jsonNode.getMethod(methodObj["name"].str)
      if not meth.isNil:
        origArgs = meth["arguments"]
        isBase = false
      curTyp = types.getOrDefault(curTyp.baseName)

  var args = newSeqOfCap[MethodArg](methodObj["arguments"].len + 1)
  for arg in origArgs:
    let typ = toNimType(types, arg["type"].str)
    let defaultVal = if arg["has_default_value"].bval: arg["default_value"]
                     else: nil
    args.add(MethodArg(
              name: toNimStyle(arg["name"].str), typ: typ,
              defaultVal: defaultVal))
  if methodObj["has_varargs"].bval:
    args.add(MethodArg(name: "variantArgs", typ: "Variant", kind: ArgKind.VarArgs))

  let godotName = methodObj["name"].str
  var nimName = toNimStyle(godotName)
  if not godotName.startsWith('_'):
    for meth in typ.jsonNode["methods"]:
      if meth["name"].str == '_' & godotName:
        nimName = nimName & "Impl"

  let returnType = if methodObj["return_type"].str != "void":
                      some(toNimType(types, methodObj["return_type"].str))
                   else: none(string)
  const discardableMethods = toHashSet(["emit_signal"])
  result = MethodInfo(
    name: ident(nimName),
    typ: typ,
    godotName: methodObj["name"].str,
    args: args,
    returnType: returnType,
    isVirtual: methodObj["is_virtual"].bval,
    isBase: isBase,
    isDiscardable: typ.godotName == "Object" and
                   methodObj["name"].str in discardableMethods
  )

proc findMethod(obj: JsonNode, methName: string): JsonNode =
  for meth in obj["methods"]:
    if meth["name"].str == methName:
      return meth

proc makeProperty(types: Table[string, GodotType], tree: PNode,
                  methodBindRegistry: var HashSet[string],
                  typ: GodotType, propertyObj: JsonNode, obj: JsonNode,
                  withImplementation: bool) =
  for meth in obj["methods"]:
    if meth["name"].str == '_' & propertyObj["name"].str:
      # Don't generate properties if there is a name clash - otherwise
      # using the property would not compile due to ambiguity.
      return
  let getterNameStr = toNimStyle(propertyObj["name"].str)
  let getterName = ident(getterNameStr)
  let setterName = newPNode(nkAccQuoted).addChain(ident(getterNameStr & "="))

  let getter = findMethod(obj, propertyObj["getter"].str)
  let nimType = if getter.isNil: toNimType(types, propertyObj["type"].str)
                else: getMethodInfo(getter, types, typ).returnType.get("void")
  let getterInfo = MethodInfo(
    name: getterName,
    typ: typ,
    godotName: propertyObj["getter"].str,
    args: newSeq[MethodArg](),
    returnType: some(nimType)
  )
  let setterInfo = MethodInfo(
    name: setterName,
    typ: typ,
    godotName: propertyObj["setter"].str,
    args: @[MethodArg(name: "val", typ: nimType)]
  )
  if "index" in propertyObj and propertyObj["index"] != newJInt(-1):
    getterInfo.args =
      @[MethodArg(defaultVal: newJString($propertyObj["index"]),
                  typ: "int", kind: ArgKind.Bound)] & getterInfo.args
    setterInfo.args =
      @[MethodArg(defaultVal: newJString($propertyObj["index"]),
                  typ: "int", kind: ArgKind.Bound)] & setterInfo.args
  generateMethod(tree, methodBindRegistry, getterInfo, withImplementation)
  generateMethod(tree, methodBindRegistry, setterInfo, withImplementation)

proc makeMethod(types: Table[string, GodotType], tree: PNode,
                methodBindRegistry: var HashSet[string],
                typ: GodotType, methodObj: JsonNode,
                withImplementation: bool) =
  if not typ.isSingleton:
    # for singletons we don't generate Nim setters/getters,
    # but use plain procedures instead. That's because setter syntax is
    # supposed to be used on an object (have at least 2 params).
    for prop in typ.jsonNode["properties"]:
      if prop["getter"].str == methodObj["name"].str or
         prop["setter"].str == methodObj["name"].str:
        var hasDuplicateMethod = false
        for meth in typ.jsonNode["methods"]:
          if meth["name"].str == '_' & prop["name"].str:
            hasDuplicateMethod = true
            break
        if not hasDuplicateMethod:
          return

  let methodInfo = getMethodInfo(methodObj, types, typ)

  generateMethod(tree, methodBindRegistry, methodInfo, withImplementation)

proc addAttributeToDoc(doc: var string, propName, propValue: string) =
  if doc.len > 0:
    doc.add("\n")
  doc.add(propName & ": " & propValue)

const classAttributes = ["singleton", "instanciable", "is_reference"]

proc typeNameToModuleName(name: string): string =
  var wasUpperOrDigit = true
  result = newStringOfCap(name.len + 10)
  for idx, c in name:
    if c.isUpperAscii() or c.isDigit():
      if not wasUpperOrDigit or idx > 0 and idx < name.len - 1 and
         name[idx + 1].isLowerAscii():
        result.add('_')
      result.add(c.toLowerAscii())
      wasUpperOrDigit = true
    else:
      result.add(c)
      wasUpperOrDigit = false
  if result == "object":
    # keyword
    result = "objects"
  if result == "os":
    # to avoid clash with stdlib
    result = "gd_os"

proc newRegisterClassNode(typ: GodotType): PNode =
  newCall("registerClass",
    ident(typ.name),
    newStrLit(typ.godotName),
    ident("true") # isNative
  )

proc genSingletonDecl(typ: string): PNode =
  result = newPNode(nkVarSection)
  let name = singletonName(typ)
  let threadvar = newPNode(nkPragma).addChain(ident("threadvar"))
  result.add(newIdentDefs(newPNode(nkPragmaExpr).addChain(name, threadvar),
             ident(typ)))

proc shouldExport(typ: GodotType, types: Table[string, GodotType]): bool =
  var curTyp = typ
  while not curTyp.isNil and not curTyp.isSingleton:
    curTyp = types.getOrDefault(curTyp.baseName)
  result = curTyp.isNil

proc sortByDerivedCount(types: Table[string, GodotType]): seq[GodotType] =
  result = toSeq(types.values())
  result.sort do (x, y: GodotType) -> int:
    cmp(y.derivedCount, x.derivedCount)

proc genTypeFile(types: Table[string, GodotType], targetDir: string) =
  let sortedTypes = sortByDerivedCount(types)

  let godotApiTypesTree = newPNode(nkStmtList)
  godotApiTypesTree.add(newPNode(nkImportStmt).addChain(ident("godot")))
  let typeSection = newPNode(nkTypeSection)
  godotApiTypesTree.add(typeSection)

  for typ in sortedTypes:
    if not typ.shouldExport(types): continue
    newRefTypeNode(typeSection, typ.name, typ.baseName, typ.doc)

  for typ in sortedTypes:
    if not typ.shouldExport(types): continue
    let regNode = newCall("registerClass",
      ident(typ.name),
      newStrLit(typ.godotName),
      ident("true") # isNative
    )
    godotApiTypesTree.add(regNode)

  writeFile(targetDir / "godottypes.nim", renderTree(godotApiTypesTree))

proc genSingletonWithDerived(tree: PNode, typ: GodotType,
                             types: Table[string, GodotType]) =
  let sortedTypes = sortByDerivedCount(types)

  var parents = initHashSet[string]()
  parents.incl(typ.name)

  let typeDecl = newPNode(nkTypeSection)
  tree.add(typeDecl)
  proc genDecl(typ: GodotType) =
    newRefTypeNode(typeDecl, typ.name, typ.baseName, typ.doc,
                   isExported = false)
    tree.add(newRegisterClassNode(typ))

  genDecl(typ)
  for otherType in sortedTypes:
    if otherType.baseName in parents:
      parents.incl(otherType.name)
      genDecl(otherType)

  tree.add(genSingletonDecl(typ.name))

proc genApi*(targetDir: string, apiJsonFile: string) =
  ## Generates .nim files in the ``targetDir`` based on the ``apiJsonFile``.
  ## The JSON file can be generated by executing Godot with
  ## ``--gdnative-generate-json-api <target_filename>`` parameters.
  let apiJson = parseJson(newFileStream(apiJsonFile),
                          apiJsonFile.extractFilename())
  var megaImport = newStringOfCap(64 * 1024)

  var types = initTable[string, GodotType]()
  for obj in apiJson:
    let godotClassName = obj["name"].str
    let className = godotClassName.replace("_", "")
    var baseClassName = obj["base_class"].str
    baseClassName = toNimType(baseClassName.replace("_", ""))
    if baseClassName.len == 0:
      baseClassName = "NimGodotObject"
    var doc = ""
    for attr in classAttributes:
      if attr in obj:
        addAttributeToDoc(doc, attr, $obj[attr])
    types[className] = GodotType(
      name: className,
      godotName: godotClassName,
      baseName: baseClassName,
      doc: doc,
      jsonNode: obj,
      isSingleton: obj["singleton"].bval
    )

  for typ in types.values():
    types.incDerivedCount(typ.baseName)

  for typ in types.values():
    let moduleName = typeNameToModuleName(typ.name)
    echo "Generating ", moduleName, ".nim..."
    let tree = newPNode(nkStmtList)
    let importStmt = newPNode(nkImportStmt)
    importStmt.add(ident("godot"))
    importStmt.add(ident("godottypes"))
    importStmt.add(ident("godotinternal"))
    tree.add(importStmt)
    let exportStmt = newPNode(nkExportStmt)
    exportStmt.add(ident("godottypes"))
    tree.add(exportStmt)

    var methodBindRegsitry = initHashSet[string]()
    let obj = typ.jsonNode
    if typ.baseName != "NimGodotObject":
      let baseModule = typeNameToModuleName(typ.baseName)
      let baseModuleNode = if getIdent(baseModule).isKeyword:
                             newStrLit(baseModule & ".nim")
                           else:
                             ident(baseModule)
      importStmt.add(baseModuleNode)
      exportStmt.add(baseModuleNode)
    let constSection = makeConstSection(obj["constants"])
    if constSection.kind != nkEmpty:
      # renderer doesn't properly render empty stmt after type section
      tree.add(makeConstSection(obj["constants"]))

    if typ.isSingleton:
      genSingletonWithDerived(tree, typ, types)

    if "enums" in obj:
      # Quite often Godot enums are flags that need to be bitwise ORed
      # Nim's enums don't serve well for that purpose, so we just generate
      # integer constants. The only enum used in API is Error.
      for enumDef in obj["enums"]:
        let uniqueConstants = newJObject()
        for k, v in enumDef["values"]:
          if k notin obj["constants"]:
            uniqueConstants[k] = v
        if uniqueConstants.len > 0:
          tree.add(makeConstSection(uniqueConstants))

    # first, generate declarations only for ease of
    # human readability of the file
    if not typ.isSingleton:
      for property in obj["properties"]:
        makeProperty(types, tree, methodBindRegsitry, typ, property,
                     obj, withImplementation = false)
    for meth in obj["methods"]:
      makeMethod(types, tree, methodBindRegsitry, typ,
                 meth, withImplementation = false)

    if not typ.isSingleton:
      for property in obj["properties"]:
        makeProperty(types, tree, methodBindRegsitry, typ,
                    property, obj, withImplementation = true)
    for meth in obj["methods"]:
      makeMethod(types, tree, methodBindRegsitry, typ, meth,
                 withImplementation = true)

    writeFile(targetDir / moduleName & ".nim", renderTree(tree))

    megaImport.add("import \"" & moduleName & "\"\n")

  genTypeFile(types, targetDir)

  writeFile(targetDir / "godotall.nim", megaImport)
  writeFile(targetDir / splitPath(targetDir)[1] & ".nimble", "")

when isMainModule:
  import os

  const usage = """Tool for wrapping Godot API into Nim
    godotapigen [godot binary path] [target directory]"""

  proc main() =
    if paramCount() < 2:
      echo usage
      quit(-1)
    let godotBin = paramStr(1)
    let targetDir = paramStr(2)

    if not dirExists(targetDir):
      echo "The specified directory does not exist"
      quit(-1)
    if not fileExists(godotBin):
      echo "Invalid godot binary path"
      quit(-1)

    let jsonFile = targetDir / "api.json"
    if fileExists(jsonFile) and
       godotBin.getLastModificationTime() <= jsonFile.getLastModificationTime():
      echo "api.json is up to date - doing nothing."
      return

    discard execShellCmd(
      "\"" & godotBin & "\" --gdnative-generate-json-api \"" & jsonFile & "\"")
    if not fileExists(jsonFile):
      echo "Failed to generate api.json"
      quit(-1)

    genApi(targetDir, jsonFile)

  main()