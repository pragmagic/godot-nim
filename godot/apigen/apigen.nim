# Copyright 2017 Xored Software, Inc.

import streams, json, ospaths, strutils, times, sets, tables
import sequtils, algorithm
import compiler / [ast, renderer, idents, astalgo]

proc ident(ident: string): PNode =
  result = newNode(nkIdent)
  result.ident = getIdent(ident)

proc addChain(node: PNode, others: varargs[PNode]): PNode {.discardable.} =
  for other in others:
    node.add(other)
  result = node

proc newIdentDefs(name, typ: PNode,
                  defaultVal: PNode = nil): PNode =
  result = newNode(nkIdentDefs)
  result.add(name)
  result.add(typ)
  if defaultVal.isNil:
    result.add(newNode(nkEmpty))
  else:
    result.add(defaultVal)

proc newProc(name: PNode, params: openArray[PNode], body = newNode(nkEmpty),
             procType = nkProcDef): PNode =
  result = newNode(procType)
  result.add(name)
  result.add(newNode(nkEmpty))
  result.add(newNode(nkEmpty))
  let formalParams = newNode(nkFormalParams)
  for param in params:
    formalParams.add(param)
  result.add(formalParams)
  result.add(newNode(nkEmpty))
  result.add(newNode(nkEmpty))
  result.add(body)

proc newIfStmt(condition, body: PNode): PNode =
  result = newNode(nkIfStmt)
  let branch = newNode(nkElifBranch)
  result.add(branch)
  branch.add(condition)
  branch.add(body)

proc newCall(theProc: PNode, args: varargs[PNode]): PNode =
  result = newNode(nkCall)
  result.add(theProc)
  for arg in args:
    result.add(arg)

proc newCall(theProc: string, args: varargs[PNode]): PNode =
  newCall(ident(theProc), args)

proc newStrLit(s: string): PNode =
  result = newNode(nkStrLit)
  result.strVal = s

proc newRStrLit(s: string): PNode =
  result = newNode(nkRStrLit)
  result.strVal = s

proc newCStringLit(s: string): PNode =
  newNode(nkCallStrLit).addChain(ident("cstring"), newRStrLit(s))

proc newIntLit(val: BiggestInt): PNode =
  result = newNode(nkIntLit)
  result.intVal = val

proc newInt64Lit(val: BiggestInt): PNode =
  result = newNode(nkInt64Lit)
  result.intVal = val

proc newFloatLit(val: BiggestFloat): PNode =
  result = newNode(nkFloatLit)
  result.floatVal = val

proc newFloat64Lit(val: BiggestFloat): PNode =
  result = newNode(nkFloat64Lit)
  result.floatVal = val

proc newNilLit(): PNode =
  result = newNode(nkNilLit)

proc newDotExpr(left, right: PNode): PNode =
  result = newNode(nkDotExpr)
  result.add(left)
  result.add(right)

proc newCommand(left, right: PNode): PNode =
  result = newNode(nkCommand)
  result.add(left)
  result.add(right)

proc newInfix(left, op, right: PNode): PNode =
  result = newNode(nkInfix)
  result.add(op)
  result.add(left)
  result.add(right)

proc postfix(left: PNode, op: string): PNode =
  result = newNode(nkPostfix)
  result.add(ident(op))
  result.add(left)

proc newExprColonExpr(key, value: PNode): PNode =
  newNode(nkExprColonExpr).addChain(key, value)

proc pragma(key: PNode, value: PNode): PNode =
  newNode(nkPragma).addChain(key, value)

proc newBracketExpr(first, bracket: PNode): PNode =
  newNode(nkBracketExpr).addChain(first, bracket)

proc newEmptyNode(): PNode =
  newNode(nkEmpty)

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
    var curType: string
    var allEqual = true
    for chain in chains:
      if idx >= chain.len:
        allEqual = false
        break
      if curType.isNil:
        curType = chain[idx]
      elif curType != chain[idx]:
        allEqual = false
        break
    if allEqual:
      result = curType
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
  case godotType:
  of "float": "float64"
  of "int": "int64"
  of "String": "string"
  of "File": "godottypes.File"
  else: godotType

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
  let typeDef = newNode(nkTypeDef)
  typeSection.add(typeDef)
  if isExported:
    typeDef.add(postfix(ident(typ), "*"))
  else:
    typeDef.add(ident(typ))

  typeDef.add(newNode(nkEmpty)) # generic
  let objTy = newNode(nkObjectTy)
  let refTy = newNode(nkRefTy)
  refTy.add(objTy)
  typeDef.add(refTy)

  objTy.add(newNode(nkEmpty))
  let inherit = newNode(nkOfInherit)
  inherit.add(ident(base))
  objTy.add(inherit)

  if not doc.isNil:
    let recList = newNode(nkRecList)
    let docNode = newNode(nkCommentStmt)
    docNode.comment = doc
    recList.add(docNode)
    objTy.add(recList)
  else:
    objTy.add(newNode(nkEmpty))

proc makeConstSection(constObj: JsonNode): PNode =
  if constObj.len == 0:
    return newNode(nkEmpty)

  result = newNode(nkConstSection)
  for field, val in constObj:
    let def = newNode(nkConstDef)
    def.add(postfix(ident(field), "*"))
    def.add(newNode(nkEmpty)) # infer type
    var valNode: PNode
    if val.kind == JInt:
      valNode = newInt64Lit(val.num)
      # valNode.intVal = val.num
    elif val.kind == JFloat:
      valNode = newFloat64Lit(val.fnum)
    elif val.kind == JBool:
      valNode = ident($val.bval)
    elif val.kind == JString:
      valNode = newNode(nkStrLit)
      valNode.strVal = val.str
    else:
      raise newException(ValueError, "Unexpected constant kind: " & $val.kind)
    def.add(valNode)
    result.add(def)

type MethodArg = tuple[name, typ: string, defaultVal: JsonNode, isVarargs: bool]

const standardTypes = toSet(
  ["bool", "cint", "int", "uint8", "int8", "uint16", "int16", "uint32", "int32",
   "uint64",
   "int64", "float32", "cfloat", "float64", "GodotString", "Vector2", "Rect2",
   "Vector3", "Transform2D", "Plane", "Quat", "Rect3", "Basis", "Transform",
   "Color", "NodePath", "RID", "Dictionary", "Array", "PoolByteArray",
   "PoolIntArray", "PoolRealArray", "PoolStringArray", "PoolVector2Array",
   "PoolVector3Array", "PoolColorArray", "Variant"])

const smallIntTypes = toSet(["uint8", "int8", "uint16", "int16", "uint32", "int32",
                             "cint", "int", "Error"])
const int64Types = toSet(["uint64", "int64"])
const intTypes = union(smallIntTypes, int64Types)
const float64Types = toSet(["float64", "cdouble"])
const float32Types = toSet(["float32", "cfloat"])
const floatTypes = union(float64Types, float32Types)
const arrayTypes = toSet(["Array", "PoolByteArray",
  "PoolIntArray", "PoolRealArray", "PoolStringArray", "PoolVector2Array",
  "PoolVector3Array", "PoolColorArray"])

proc newNilCheck(ident, toAssign: PNode): PNode =
  newIfStmt(newCall("isNil", ident),
    newNode(nkAsgn).addChain(ident).addChain(
      toAssign
    )
  )

proc singletonName(typ: string): PNode =
  ident("singleton" & typ)

proc makeDefaultValue(arg: MethodArg): PNode =
  result = newEmptyNode()
  if not arg.defaultVal.isNil:
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
        result = newCall("variant")
      else:
        result = newNilLit()
    elif arg.typ == "Color":
      result = newCall("initColor",
          arg.defaultVal.str.split(',').mapIt(newFloatLit(parseFloat(it))))
    # elif arg.typ in arrayTypes and (arg.defaultVal.str == "[]" or
    #        arg.defaultVal.str == "[" & arg.typ & "]"):
    #   result = newCall("init" & arg.typ)
    elif arg.typ == "RID" and arg.defaultVal.str == "[RID]":
      result = newCall("initRID")
    elif arg.typ == "Vector2" or arg.typ == "Vector3" or arg.typ == "Rect2":
      let parts = arg.defaultVal.str.replace("(", "").replace(")", "").
                         replace(" ", "").
                         split(",").mapIt(newFloatLit(parseFloat(it)))
      if arg.typ.endsWith("r2"):
        result = newCall("vec2", parts)
      elif arg.typ.endsWith('3'):
        result = newCall("vec3", parts)
      else:
        result = newCall("initRect2", parts)
    elif arg.defaultVal.str == "[Object:null]":
      result = newNilLit()
    elif arg.typ != "Transform" and arg.typ != "Transform2D" and
         arg.typ != "Variant" and arg.typ notin arrayTypes: # TODO
      raise newException(
        ValueError,
        "Cannot build default value from $# ($#)" %
        [$arg.defaultVal, arg.typ])

proc doGenerateMethod(tree: PNode, methodBindRegistry: var HashSet[string],
                      name: PNode, godotMethodName: string,
                      typ: GodotType, args: seq[MethodArg],
                      returnType: string, isVirtual,
                      isBase, withImplementation: bool) =
  var body: PNode
  if not withImplementation:
    body = newNode(nkEmpty)
  else:
    var methodBindName = toNimStyle(
      typ.name & "_" & godotMethodName & "_method_bind")
    if methodBindName[0].isUpperAscii():
      methodBindName[0] = methodBindName[0].toLowerAscii()
    if methodBindName notin methodBindRegistry:
      let methodBindDecl = newNode(nkVarSection).addChain(
        newIdentDefs(
          newNode(nkPragmaExpr).addChain(
            ident(methodBindName)).addChain(
              newNode(nkPragma).addChain(ident("threadvar"))),
          newNode(nkPtrTy).addChain(ident("GodotMethodBind"))
        ))
      tree.add(methodBindDecl)
      methodBindRegistry.incl(methodBindName)

    let nilCheck = newNilCheck(ident(methodBindName),
      newCall("getMethod", newCStringLit(typ.godotName),
        newCStringLit(godotMethodName))
    )
    let vars = newNode(nkVarSection)
    var varargsName: string
    var isVarargs: bool
    var staticArgsLen: int
    var argLenNode = newIntLit(0)
    let argsName = ident("argsToPassToGodot")
    if args.len > 0:
      for arg in args:
        if arg.isVarargs:
          varargsName = arg.name
          isVarargs = true
          vars.add(newIdentDefs(ident("callError"), ident("VariantCallError")))
          break
      let argsAlloc = newNode(nkCast).addChain(
        newNode(nkPtrTy).addChain(
          newNode(nkBracketExpr).addChain(
            ident("array"), ident("MAX_ARG_COUNT"),
            if isVarargs: ident("Variant") else: ident("pointer"))))
      staticArgsLen = if varargsName.isNil: args.len
                      else: args.len - 1
      if not varargsName.isNil:
        argLenNode = newCall("cint",
                      newInfix(newIntLit(staticArgsLen),
                                ident("+"),
                                newDotExpr(ident(varargsName), ident("len"))))
        argsAlloc.add(newCall("godotAlloc", newCall("cint", newInfix(
          newCall("sizeof", ident("Variant")), ident("*"),
          newNode(nkPar).addChain(argLenNode))))
        )
      else:
        argLenNode = newCall("cint", newIntLit(staticArgsLen))
        vars.add(newIdentDefs(
          ident("argsStatic"),
          newNode(nkBracketExpr).addChain(
            ident("array"), newIntLit(staticArgsLen), ident("pointer")),
          newNode(nkEmpty)))
        argsAlloc.add(newCommand(ident("addr"), ident("argsStatic")))
      vars.add(newIdentDefs(argsName, newNode(nkEmpty), argsAlloc))

    let argConversions = newNode(nkStmtList)
    for idx, arg in args:
      var argName = ident(arg.name)
      if arg.isVarargs:
        argName = newNode(nkBracketExpr).addChain(
          ident(varargsName),
          newInfix(ident("idx"), ident("-"), newIntLit(staticArgsLen)))
      let argIdx = if arg.isVarargs: ident("idx") else: newIntLit(idx)
      let isStandardType = arg.typ in standardTypes
      let convArg = if not varargsName.isNil: newCall("toGodot", argName)
                    elif isStandardType: newCall("unsafeAddr", argName)
                    elif arg.typ == "string": newCall("unsafeAddr",
                                  ident("argToPassToGodot" & $idx))
                    else: ident("argToPassToGodot" & $idx) # object
      if not isStandardType and arg.isVarargs:
        raise newException(ValueError,
          "Non-standard type $# for varargs params of method $# of type $#" %
            [arg.typ, godotMethodName, typ.godotName])
      if not isStandardType:
        if arg.typ == "string":
          argConversions.add(newNode(nkLetSection).addChain(
            newIdentDefs(ident("argToPassToGodot" & $idx), newEmptyNode(),
                         newCall("toGodotString", argName))))
        else:
          argConversions.add(newNode(nkLetSection).addChain(
            newIdentDefs(ident("argToPassToGodot" & $idx), newEmptyNode(),
                        newDotExpr(argName, ident("godotObject")))))
      let argAsgn = newNode(nkAsgn).addChain(
        newNode(nkBracketExpr).addChain(
          newNode(nkBracketExpr).addChain(argsName), argIdx),
          convArg
      )
      if not arg.isVarargs:
        argConversions.add(
          argAsgn
        )
      else:
        argConversions.add(newNode(nkVarSection).addChain(
          newIdentDefs(ident("idx"), newNode(nkEmpty), newIntLit(staticArgsLen))))
        let argLoop = newNode(nkWhileStmt)
        argConversions.add(argLoop)
        argLoop.add(newInfix(ident("idx"), ident("<"), argLenNode)
        )
        argLoop.add(argAsgn)
        argLoop.add(newCommand(ident("inc"), ident("idx")))

    let retName = if isVarargs: "callRet" else: "ptrCallRet"
    let theCall = newCall(
      newDotExpr(ident(methodBindName),
                 ident(if isVarargs: "call" else: "ptrCall")),
      newDotExpr(ident("self"), ident("godotObject")),
      if args.len > 0: argsName else: newNode(nkNilLit),
      argLenNode,
      if not isVarargs: ident(retName) else: ident("callError")
    )
    if not isVarargs:
      theCall.sons.delete(3)
    let freeCall = newCall("godotFree", argsName)
    body = newNode(nkStmtList)
    if typ.isSingleton:
      let varName = singletonName(typ.name)
      body.add(newNilCheck(varName, newCall(
        newBracketExpr(ident("getSingleton"), ident(typ.name)))))
      body.add(newNode(nkLetSection).addChain(newIdentDefs(
        ident("self"), newNode(nkEmpty), varName
      )))
    if not varargsName.isNil:
      body.add(
        pragma(ident("push"), newExprColonExpr(
               newBracketExpr(ident("warning"), ident("Destructor")),
               ident("off"))))
    body.add(nilCheck)
    body.add(vars)
    body.add(argConversions)
    if not isVarargs:
      let retPtrDecl = newNode(nkVarSection).addChain(
        newIdentDefs(ident(retName), ident("pointer"), newEmptyNode())
      )
      body.add(retPtrDecl)
    var isVariantRet: bool
    var isConversionRet: bool
    var isObjRet: bool
    var isStringRet: bool
    let retValIdent = if not isVarargs: ident("ptrCallVal") else: ident(retName)
    if not returnType.isNil and varargsName.isNil:
      var addrToAssign = newCall("addr", ident("ptrCallVal"))
      if returnType in smallIntTypes:
        isConversionRet = true
        body.add(newNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, ident("int64"),
        )))
      elif returnType in float32Types:
        isConversionRet = true
        body.add(newNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, ident("float64"),
        )))
      elif returnType in standardTypes:
        addrToAssign = newCall("addr", ident("result"))
      elif returnType == "string":
        isStringRet = true
        body.add(newNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, ident("GodotString"),
        )))
      else:
        isObjRet = true
        body.add(newNode(nkVarSection).addChain(newIdentDefs(
          retValIdent, newNode(nkPtrTy).addChain(ident("GodotObject")),
        )))
      body.add(newNode(nkAsgn).addChain(ident(retName), addrToAssign))

    if not isVarargs:
      body.add(theCall)
    else:
      if not returnType.isNil:
        isVariantRet = true
      let callStmt = newNode(nkLetSection).addChain(
        newIdentDefs(
          newNode(nkPragmaExpr).addChain(
            ident(retName), newNode(nkPragma).addChain(ident("used"))),
          newNode(nkEmpty), theCall))
      body.add(callStmt)
    # if not returnType.isNil and not varargsName.isNil:
    #   body.add(newCall("fromGodot", ident("result"), ident(retName)))
      # body.add(newCall("deinit", ident(retName)))
    if args.len > 0 and not varargsName.isNil:
      body.add(freeCall)
    if not varargsName.isNil:
      let errCheck = newIfStmt(
        newInfix(newDotExpr(ident("callError"), ident("error")), ident("!="),
                 newDotExpr(ident("VariantCallErrorType"), ident("OK"))),
        newNode(nkRaiseStmt).addChain(
          newCall("newCallError", ident("callError")))
      )
      body.add(errCheck)
    if isVariantRet:
      let convErrDef = newNode(nkLetSection).addChain(
          newIdentDefs(ident("convErr"), newNode(nkEmpty),
              newCall("fromGodot", ident("result"), retValIdent)))
      let convCheck = newIfStmt(
        newInfix(ident("convErr"), ident("!="),
                 newDotExpr(ident("ConversionResult"), ident("OK"))),
        newNode(nkRaiseStmt).addChain(
          newCall("newConversionError", ident("convErr")))
      )
      body.add(convErrDef)
      body.add(convCheck)
    if not isVarargs and (isVariantRet or isStringRet):
      # varargs use call with "let" so destructor is invoked
      body.add(newCall("deinit", retValIdent))
    elif isConversionRet:
      body.add(newNode(nkAsgn).addChain(ident("result"),
                                        newCall(returnType, retValIdent)))
    elif isObjRet:
      body.add(newNode(nkAsgn).addChain(ident("result"),
               newCall(newBracketExpr(ident("asNimGodotObject"),
        newCall("type", ident("result"))), retValIdent)))
    elif isStringRet:
      body.add(newNode(nkAsgn).addChain(ident("result"),
                                        newCall("$", retValIdent)))
    if not varargsName.isNil:
      body.add(
        pragma(ident("push"), newExprColonExpr(
                  newBracketExpr(ident("warning"), ident("Destructor")),
                  ident("on"))))

  let procType = if isVirtual: nkMethodDef
                 else: nkProcDef
  var params = newSeqOfCap[PNode](args.len + 2)
  if not returnType.isNil:
    params.add(ident(returnType))
  else:
    params.add(newNode(nkEmpty))
  if not typ.isSingleton:
    params.add(newIdentDefs(ident("self"), ident(toNimType(typ.name))))

  for arg in args:
    if arg.isVarargs:
      params.add(newIdentDefs(ident(arg.name),
        newNode(nkBracketExpr).addChain(ident("varargs"), ident(arg.typ))))
    else:
      let defaultValue = arg.makeDefaultValue()
      params.add(newIdentDefs(ident(arg.name), ident(arg.typ), defaultValue))
  let procDecl = newProc(if not withImplementation: postfix(name, "*")
                         else: name,
                         params, body, procType)
  if not withImplementation:
    let pragma = newNode(nkPragma)
    pragma.add(ident("gcsafe"))
    pragma.add(newNode(nkExprColonExpr).addChain(ident("locks"),
                                                newIntLit(0)))
    if isVirtual and isBase:
      pragma.add(ident("base"))
    procDecl.sons[4] = pragma
  tree.add(procDecl)

proc generateMethod(tree: PNode, methodBindRegistry: var HashSet[string],
                    name: PNode, godotMethodName: string,
                    typ: GodotType, args: seq[MethodArg],
                    returnType: string, isVirtual, isBase, withImplementation: bool) =
  doGenerateMethod(
    tree, methodBindRegistry, name, godotMethodName, typ,
    args, returnType, isVirtual, isBase, withImplementation)

proc makeProperty(types: Table[string, GodotType], tree: PNode,
                  methodBindRegistry: var HashSet[string],
                  typ: GodotType,
                  propertyObj: JsonNode, withImplementation: bool) =
  let getterNameStr = toNimStyle(propertyObj["name"].str)
  let getterName = ident(toNimStyle(propertyObj["name"].str))
  let setterName = newNode(nkAccQuoted).addChain(ident(getterNameStr & "="))

  let nimType = toNimType(types, propertyObj["type"].str)
  generateMethod(tree, methodBindRegistry,
                 getterName, propertyObj["getter"].str, typ,
                 @[], nimType, isVirtual = false,
                 isBase = false, withImplementation)
  generateMethod(tree, methodBindRegistry,
                 setterName, propertyObj["setter"].str, typ,
                 @[("val", nimType, JsonNode(nil), false)],
                 nil, isVirtual = false, isBase = false, withImplementation)

proc makeMethod(types: Table[string, GodotType], tree: PNode,
                methodBindRegistry: var HashSet[string],
                typ: GodotType, methodObj: JsonNode,
                withImplementation: bool) =
  let returnType = if methodObj["return_type"].str != "void":
                      toNimType(types, methodObj["return_type"].str)
                   else: nil

  for prop in typ.jsonNode["properties"]:
    if prop["getter"].str == methodObj["name"].str or
       prop["setter"].str == methodObj["name"].str:
      return

  var args = newSeqOfCap[MethodArg](methodObj["arguments"].len + 1)
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

  for arg in origArgs:
    let typ = toNimType(types, arg["type"].str)
    let defaultVal = if arg["has_default_value"].bval: arg["default_value"]
                     else: nil
    args.add((toNimStyle(arg["name"].str), typ,
              defaultVal, false))
  if methodObj["has_varargs"].bval:
    args.add(("variantArgs", "Variant", JsonNode(nil), true))

  let godotName = methodObj["name"].str
  generateMethod(tree, methodBindRegistry,
                 ident(toNimStyle(godotName)), methodObj["name"].str,
                 typ, args,
                 returnType, methodObj["is_virtual"].bval, isBase,
                 withImplementation)

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
    newCStringLit(typ.godotName),
    ident("true") # isNative
  )

proc genSingletonDecl(typ: string): PNode =
  result = newNode(nkVarSection)
  let name = singletonName(typ)
  let threadvar = newNode(nkPragma).addChain(ident("threadvar"))
  result.add(newIdentDefs(newNode(nkPragmaExpr).addChain(name, threadvar),
             ident(typ)))

proc shouldExport(typ: GodotType, types: Table[string, GodotType]): bool =
  var curTyp = typ
  while not curTyp.isNil and not curTyp.isSingleton:
    curTyp = types.getOrDefault(curTyp.baseName)
  result = curTyp.isNil

proc genTypeFile*(types: var Table[string, GodotType], targetDir: string) =
  for typ in types.values():
    types.incDerivedCount(typ.baseName)

  var sortedTypes = toSeq(types.values())
  sortedTypes.sort do (x, y: GodotType) -> int:
    cmp(y.derivedCount, x.derivedCount)

  let godotApiTypesTree = newNode(nkStmtList)
  godotApiTypesTree.add(newNode(nkImportStmt).addChain(ident("godot")))
  let typeSection = newNode(nkTypeSection)
  godotApiTypesTree.add(typeSection)

  for typ in sortedTypes:
    if not typ.shouldExport(types): continue
    newRefTypeNode(typeSection, typ.name, typ.baseName, typ.doc)

  for typ in sortedTypes:
    if not typ.shouldExport(types): continue
    let regNode = newCall("registerClass",
      ident(typ.name),
      newCStringLit(typ.godotName),
      ident("true") # isNative
    )
    godotApiTypesTree.add(regNode)

  renderModule(godotApiTypesTree, targetDir / "godottypes.nim")

proc genApi*(targetDir: string, apiJsonFile: string) =
  let apiJson = parseJson(newFileStream(apiJsonFile),
                          apiJsonFile.extractFilename())
  var megaImport = newStringOfCap(64 * 1024)

  var types = initTable[string, GodotType]()
  for obj in apiJson:
    let godotClassName = obj["name"].str
    let className = godotClassName.replace("_", "")
    var baseClassName = obj["base_class"].str
    baseClassName = toNimType(baseClassName.replace("_", ""))
    if baseClassName.isNil or baseClassName.len == 0:
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
    let tree = newNode(nkStmtList)
    let importStmt = newNode(nkImportStmt)
    importStmt.add(ident("godot"))
    importStmt.add(ident("godottypes"))
    importStmt.add(newDotExpr(ident("core"), ident("godotcore")))
    tree.add(importStmt)
    let exportStmt = newNode(nkExportStmt)
    exportStmt.add(ident("godottypes"))
    tree.add(exportStmt)

    var methodBindRegsitry = initSet[string]()
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
      let typeDecl = newNode(nkTypeSection)
      newRefTypeNode(typeDecl, typ.name, typ.baseName, typ.doc,
                     isExported = false)
      tree.add(typeDecl)
      tree.add(newRegisterClassNode(typ))
      tree.add(genSingletonDecl(typ.name))

    # first, generate declarations only for ease of
    # human readability of the file
    for property in obj["properties"]:
      makeProperty(types, tree, methodBindRegsitry, typ, property,
                   withImplementation = false)
    for meth in obj["methods"]:
      makeMethod(types, tree, methodBindRegsitry, typ,
                 meth, withImplementation = false)

    for property in obj["properties"]:
      makeProperty(types, tree, methodBindRegsitry, typ,
                   property, withImplementation = true)
    for meth in obj["methods"]:
      makeMethod(types, tree, methodBindRegsitry, typ, meth,
                 withImplementation = true)

    let moduleName = typeNameToModuleName(typ.name)
    renderModule(tree, targetDir / moduleName & ".nim")

    megaImport.add("import \"" & moduleName & "\"\n")

  genTypeFile(types, targetDir)

  writeFile(targetDir / "godotall.nim", megaImport)

when isMainModule:
  import os

  const usage = slurp("usage.txt")

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
      echo "api.json if up to date - doing nothing."
      return

    discard execShellCmd(
      "\"" & godotBin & "\" --gdnative-generate-json-api \"" & jsonFile & "\"")
    if not fileExists(jsonFile):
      echo "Failed to generate api.json"
      quit(-1)

    genApi(targetDir, jsonFile)

  main()
