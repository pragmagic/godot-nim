# Copyright 2018 Xored Software, Inc.

import macros, tables, typetraits, strutils, sets, sequtils, options, algorithm
import godotinternal, internal/godotvariants
import godotnim, core/variants

type
  VarDecl = ref object
    name: NimNode
    typ: NimNode
    defaultValue: NimNode
    isNoGodot: bool
    hint: Option[string]
    hintStr: Option[string]
    usage: NimNode
    isExported: bool

  MethodDecl = ref object
    name: string
    args: seq[VarDecl]
    isVirtual: bool
    returnType: NimNode
    nimNode: NimNode
    isNoGodot: bool

  ObjectDecl = ref object
    name: string
    parentName: string
    fields: seq[VarDecl]
    methods: seq[MethodDecl]
    isTool: bool

  ParseError = object of Exception

proc godotToNim[T](val: Variant): (T, ConversionResult) =
  mixin fromVariant
  result[1] = fromVariant(result[0], val)

proc nimToGodot[T](val: T): Variant =
  mixin toVariant
  when compiles(toVariant(val)):
    result = toVariant(val)
  else:
    const err = "Cannot convert Nim value of type " & T.name &
                " into Variant"
    {.error: err.}

template parseError(node: NimNode, msg: string) =
  raise newException(ParseError, lineinfo(node) & ": " & msg)

proc extractNames(definition: NimNode):
    tuple[name, parentName: string] =
  if definition.kind == nnkIdent:
    result.name = definition.strVal
  else:
    if not (definition.kind == nnkInfix and
            definition[0].strVal == "of"):
      parseError(definition, "invalid type definition")
    result.name = definition[1].strVal
    case definition[2].kind:
      of nnkIdent:
        result.parentName = definition[2].strVal
      else:
        parseError(definition[2], "parent type expected")

when not declared(newRStrLit):
  proc newRStrLit(s: string): NimNode {.compileTime.} =
    result = newNimNode(nnkRStrLit)
    result.strVal = s

proc newCStringLit(s: string): NimNode {.compileTime.} =
  newNimNode(nnkCallStrLit).add(ident("cstring"), newRStrLit(s))

iterator pragmas(node: NimNode):
      tuple[key: string, value: NimNode, index: int] =
  assert node.kind in {nnkPragma, nnkEmpty}
  for index in countdown(node.len - 1, 0):
    if node[index].kind == nnkExprColonExpr:
      yield (node[index][0].strVal, node[index][1], index)
    elif node[index].kind == nnkIdent:
      yield (node[index].strVal, nil, index)

proc removePragmaNode(statement: NimNode,
                      pname: string): NimNode {.compileTime.} =
  ## Removes the pragma from the node and returns value of the pragma
  ## Works for routine nodes or nnkPragmaExpr
  if not (RoutineNodes.contains(statement.kind) or
          statement.kind == nnkPragmaExpr):
    return nil

  result = nil
  var pragmas = if RoutineNodes.contains(statement.kind): statement.pragma()
                else: statement[1]
  for ident, val, i in pragmas(pragmas):
    if ident == pname:
      pragmas.del(i)
      return val

proc removePragma(statement: NimNode, pname: string): bool =
  ## Removes the pragma from the node and returns whether pragma was removed
  if not (RoutineNodes.contains(statement.kind) or
          statement.kind == nnkPragmaExpr):
    return false
  var pragmas = if RoutineNodes.contains(statement.kind): statement.pragma()
                else: statement[1]
  for ident, val, i in pragmas(pragmas):
    if ident == pname:
      pragmas.del(i)
      return true

proc removeStrPragma(statement: NimNode,
                     pname: string): Option[string] {.compileTime.} =
  ## Removes the pragma from the node and returns value of the pragma
  ## Works for routine nodes or nnkPragmaExpr
  let node = removePragmaNode(statement, pname)
  result = if node.isNil: none(string)
           else: some($node)

proc isExported(node: NimNode): bool {.compileTime.} =
  if node.kind == nnkPragmaExpr:
    result = isExported(node[0])
  elif node.kind == nnkPostfix:
    result = ($node[0] == "*")

proc identDefsToVarDecls(identDefs: NimNode): seq[VarDecl] =
  assert(identDefs.kind == nnkIdentDefs)
  result = newSeqOfCap[VarDecl](identDefs.len - 2)

  var typ = identDefs[identDefs.len - 2]
  if typ.kind == nnkEmpty:
    let defaultValue = identDefs[identDefs.len - 1]
    if defaultValue.kind != nnkEmpty:
      typ = newCall("type", defaultValue)

  for i in 0..<(identDefs.len - 2):
    let nameNode = identDefs[i].copyNimTree()
    let hint = removeStrPragma(nameNode, "hint")
    let hintStr = removeStrPragma(nameNode, "hintStr")
    let usage = removePragmaNode(nameNode, "usage")
    let isGdExport = removePragma(nameNode, "gdExport")

    result.add(VarDecl(
      name: if nameNode.kind == nnkPragmaExpr: nameNode[0].basename()
            else: nameNode.basename(),
      typ: typ,
      defaultValue: identDefs[identDefs.len - 1],
      hint: hint,
      hintStr: hintStr,
      isNoGodot: not isGdExport,
      usage: usage,
      isExported: nameNode.isExported()
    ))

proc parseMethod(meth: NimNode): MethodDecl =
  assert(meth.kind in {nnkProcDef, nnkMethodDef})
  let isGdExport = removePragma(meth, "gdExport")
  let isNoGodot = (meth.kind != nnkMethodDef and not isGdExport) or
                  removePragma(meth, "noGdExport")
  result = MethodDecl(
    name: $meth[0].basename,
    args: newSeq[VarDecl](),
    returnType: meth[3][0],
    isVirtual: meth.kind == nnkMethodDef,
    isNoGodot: isNoGodot,
    nimNode: meth
  )
  for i in 1..<meth[3].len:
    var identDefs = meth[3][i]
    result.args.add(identDefsToVarDecls(identDefs))

proc parseVarSection(decl: NimNode): seq[VarDecl] =
  assert(decl.kind == nnkVarSection)
  for i in 0..<decl.len:
    if i == 0:
      result = identDefsToVarDecls(decl[i])
    else:
      result.add(identDefsToVarDecls(decl[i]))

proc parseType(ast: NimNode): ObjectDecl =
  let definition = ast[0]
  let body = ast[^1]
  result = ObjectDecl(
    fields: newSeq[VarDecl](),
    methods: newSeq[MethodDecl]()
  )
  (result.name, result.parentName) = extractNames(definition)

  var isTool = false
  for i in 1..(ast.len - 2):
    let option = ast[i]
    if option.kind != nnkIdent:
      parseError(option, "type specifier expected")
    if option.strVal == "tool":
      isTool = true
    else:
      parseError(option, "valid type specifier expected")
  result.isTool = isTool

  if result.parentName.len == 0: result.parentName = "Object"
  for statement in body:
    case statement.kind:
      of nnkVarSection:
        let varSection = parseVarSection(statement)
        result.fields.add(varSection)
      of nnkProcDef, nnkMethodDef:
        let meth = parseMethod(statement)
        result.methods.add(meth)
      of nnkCommentStmt:
        discard
      else:
        parseError(statement, "field or method declaration expected")

macro invokeVarArgs(procIdent, objIdent;
                    minArgs, maxArgs: static[int], numArgsIdent,
                    argSeqIdent; argTypes: seq[NimNode],
                    hasReturnValue, isStaticCall: static[bool]): untyped =
  ## Produces statement in form:
  ##
  ## .. code-block:: nim
  ##   case numArgs:
  ##   of 0:
  ##     meth(self)
  ##   of 1:
  ##     let (arg0, err) = godotToNim[ArgT](argSeq[0])
  ##     if err != ConversionResult.OK:
  ##       error(...)
  ##       return
  ##     meth(self, arg0)
  ##   else:
  ##     error(...)

  template conv(procLit, argT, argSeq, idx, argIdent, errIdent) =
    let v = newVariant(argSeq[idx][])
    v.markNoDeinit() # args will be destroyed externally
    let (argIdent, errIdent) = godotToNim[argT](v)
    if errIdent != ConversionResult.OK:
      let errorKind = if errIdent == ConversionResult.TypeError: "a type error"
                      else: "a range error"
      printError(
        "Failed to invoke Nim procedure " & $procLit &
        ": " & errorKind & " has occurred when converting argument " & $idx &
        " of Godot type " & $argSeq[idx][].getType())
      return

  # these help to avoid exporting internal modules
  # thanks to closed symbol binding
  template initGodotVariantCall(result) =
    initGodotVariant(result)

  template initGodotVariantCall(result, src) =
    initGodotVariant(result, src)

  result = newNimNode(nnkCaseStmt)
  result.add(numArgsIdent)
  for i in minArgs..maxArgs:
    let branch = newNimNode(nnkOfBranch).add(newIntLitNode(i))
    let branchBody = newStmtList()
    var invocation = newNimNode(nnkCall)
    invocation.add(procIdent)
    invocation.add(objIdent) # self
    for idx in 0..<i:
      let argIdent = genSym(nskLet, "arg")
      let errIdent = genSym(nskLet, "err")
      let argT = argTypes[idx]
      branchBody.add(getAst(conv($procIdent, argT,
                                 argSeqIdent, idx, argIdent, errIdent)))
      invocation.add(argIdent)

    if isStaticCall:
      invocation = newNimNode(nnkCall).add(ident("procCall"), invocation)

    if hasReturnValue:
      let theCall = newNimNode(nnkBracketExpr).add(newNimNode(nnkDotExpr).add(
        newCall("toVariant", invocation), ident("godotVariant")))
      branchBody.add(getAst(initGodotVariantCall(ident("result"), theCall)))
    else:
      branchBody.add(invocation)
      branchBody.add(getAst(initGodotVariantCall(ident("result"))))

    branch.add(branchBody)
    result.add(branch)
  template printInvokeErr(procName, minArgs, maxArgs, numArgs) =
    printError(
      "Failed to invoke Nim procedure " & procName &
      ": expected " & $minArgs & "-" & $maxArgs &
      " arguments, but got " & $numArgs)

  result.add(newNimNode(nnkElse).add(getAst(
    printInvokeErr(procIdent.strVal, minArgs, maxArgs, numArgsIdent))))

proc typeError(nimType: string, value: string, godotType: VariantType,
               className: cstring, propertyName: cstring): string =
  result = "Tried to assign incompatible value " & value & " (" & $godotType &
            ") to field \"" & $propertyName & ": " & $nimType & "\" of " &
            $className

proc rangeError(nimType: string, value: string, className: cstring,
                propertyName: cstring): string =
  result = "Tried to assign the out-of-range value " & value &
            " to field \"" & $propertyName & ": " & $nimType & "\" of " &
            $className


proc nimDestroyFunc(obj: ptr GodotObject, methData: pointer,
                    userData: pointer) {.noconv.} =
  let nimObj = cast[NimGodotObject](userData)
  nimObj.removeGodotObject()
  GC_unref(nimObj)

proc nimDestroyRefFunc(obj: ptr GodotObject, methData: pointer,
                       userData: pointer) {.noconv.} =
  # references are destroyed by Godot when they are already destroyed by Nim,
  # so nothing to do here.
  discard

proc refcountIncremented(obj: ptr GodotObject, methodData: pointer,
                         userData: pointer, numArgs: cint,
                         args: var array[MAX_ARG_COUNT, ptr GodotVariant]):
                      GodotVariant {.noconv.} =
  let nimObj = cast[NimGodotObject](userData)
  if not nimObj.isFinalized:
    GC_ref(nimObj)

proc refcountDecremented(obj: ptr GodotObject, methodData: pointer,
                         userData: pointer, numArgs: cint,
                         args: var array[MAX_ARG_COUNT, ptr GodotVariant]):
                      GodotVariant {.noconv.} =
  let nimObj = cast[NimGodotObject](userData)
  if not nimObj.isFinalized:
    GC_unref(nimObj)
  initGodotVariant(result, nimObj.isFinalized)

template registerGodotClass(classNameIdent, classNameLit; isRefClass: bool;
                            baseNameLit, createFuncIdent; isTool: bool) =
  proc createFuncIdent(obj: ptr GodotObject,
                       methData: pointer): pointer {.noconv.} =
    var nimObj: classNameIdent
    new(nimObj, nimGodotObjectFinalizer[classNameIdent])
    nimObj.setGodotObject(obj)
    nimObj.isRef = when isRefClass: true else: false
    nimObj.setNativeObject(asNimGodotObject[NimGodotObject](
      obj, forceNativeObject = true))
    GC_ref(nimObj)
    result = cast[pointer](nimObj)
    when compiles(nimObj.init()):
      nimObj.init()

  let createFuncObj = GodotInstanceCreateFunc(
    createFunc: createFuncIdent
  )
  let destroyFuncObj = GodotInstanceDestroyFunc(
    destroyFunc: when isRefClass: nimDestroyRefFunc else: nimDestroyFunc
  )
  registerClass(classNameIdent, classNameLit, false)
  when isTool:
    nativeScriptRegisterToolClass(getNativeLibHandle(), classNameLit,
                                  baseNameLit, createFuncObj, destroyFuncObj)
  else:
    nativeScriptRegisterClass(getNativeLibHandle(), classNameLit,
                              baseNameLit, createFuncObj, destroyFuncObj)

template registerGodotField(classNameLit, classNameIdent, propNameLit,
                            propNameIdent, propTypeLit, propTypeIdent,
                            setFuncIdent, getFuncIdent, hintStrLit,
                            hintIdent, usageExpr, hasDefaultValue,
                            defaultValueNode) =
  proc setFuncIdent(obj: ptr GodotObject, methData: pointer,
                    nimPtr: pointer, val: GodotVariant) {.noconv.} =
    let variant = newVariant(val)
    variant.markNoDeinit()
    let (nimVal, err) = godotToNim[propTypeIdent](variant)
    case err:
    of ConversionResult.OK:
      cast[classNameIdent](nimPtr).propNameIdent = nimVal
    of ConversionResult.TypeError:
      let errStr = typeError(propTypeLit, $val, val.getType(),
                             classNameLit, astToStr(propNameIdent))
      printError(errStr)
    of ConversionResult.RangeError:
      let errStr = rangeError(propTypeLit, $val,
                              classNameLit, astToStr(propNameIdent))
      printError(errStr)

  proc getFuncIdent(obj: ptr GodotObject, methData: pointer,
                    nimPtr: pointer): GodotVariant {.noconv.} =
    let variant = nimToGodot(cast[classNameIdent](nimPtr).propNameIdent)
    variant.markNoDeinit()
    result = variant.godotVariant[]

  let setFunc = GodotPropertySetFunc(
    setFunc: setFuncIdent
  )
  let getFunc = GodotPropertyGetFunc(
    getFunc: getFuncIdent
  )
  mixin godotTypeInfo
  static:
    var typeInfo: GodotTypeInfo
    when compiles(godotTypeInfo(propTypeIdent)):
      typeInfo = godotTypeInfo(propTypeIdent)
  const hintStr = when hintStrLit != "NIM":
                    hintStrLit
                  else:
                    typeInfo.hintStr
  const hint = when astToStr(hintIdent) != "NIM":
                 GodotPropertyHint.hintIdent
               else:
                 typeInfo.hint
  const variantType = typeInfo.variantType

  var hintStrGodot = hintStr.toGodotString()
  {.push warning[ProveInit]: off.} # false warning, Nim bug
  var attr = GodotPropertyAttributes(
    typ: ord(variantType),
    hint: hint,
    hintString: hintStrGodot,
    usage: usageExpr
  )
  {.push warning[ProveInit]: on.}
  when hasDefaultValue:
    attr.defaultValue = (defaultValueNode).toVariant().godotVariant[]
  nativeScriptRegisterProperty(getNativeLibHandle(), classNameLit, propNameLit,
                               unsafeAddr attr, setFunc, getFunc)
  hintStrGodot.deinit()

proc toGodotStyle(s: string): string {.compileTime.} =
  result = newStringOfCap(s.len + 10)
  for c in s:
    if c.isUpperAscii():
      result.add('_')
      result.add(c.toLowerAscii())
    else:
      result.add(c)

      # nnkNone, nnkEmpty, nnkIdent, nnkSym, nnkType, nnkCharLit, nnkIntLit, nnkInt8Lit,
      # nnkInt16Lit, nnkInt32Lit, nnkInt64Lit, nnkUIntLit, nnkUInt8Lit, nnkUInt16Lit,
      # nnkUInt32Lit, nnkUInt64Lit, nnkFloatLit, nnkFloat32Lit, nnkFloat64Lit,
      # nnkFloat128Lit, nnkStrLit, nnkRStrLit, nnkTripleStrLit, nnkNilLit, nnkComesFrom,
      # nnkDotCall, nnkCommand, nnkCall, nnkCallStrLit, nnkInfix, nnkPrefix, nnkPostfix,
      # nnkHiddenCallConv, nnkExprEqExpr, nnkExprColonExpr, nnkIdentDefs, nnkVarTuple,
      # nnkPar, nnkObjConstr, nnkCurly, nnkCurlyExpr, nnkBracket, nnkBracketExpr,
      # nnkPragmaExpr, nnkRange, nnkDotExpr, nnkCheckedFieldExpr, nnkDerefExpr, nnkIfExpr,
      # nnkElifExpr, nnkElseExpr, nnkLambda, nnkDo, nnkAccQuoted, nnkTableConstr, nnkBind,
      # nnkClosedSymChoice, nnkOpenSymChoice, nnkHiddenStdConv, nnkHiddenSubConv, nnkConv,
      # nnkCast, nnkStaticExpr, nnkAddr, nnkHiddenAddr, nnkHiddenDeref, nnkObjDownConv,
      # nnkObjUpConv, nnkChckRangeF, nnkChckRange64, nnkChckRange, nnkStringToCString,
      # nnkCStringToString, nnkAsgn, nnkFastAsgn, nnkGenericParams, nnkFormalParams,
      # nnkOfInherit, nnkImportAs, nnkProcDef, nnkMethodDef, nnkConverterDef, nnkMacroDef,
      # nnkTemplateDef, nnkIteratorDef, nnkOfBranch, nnkElifBranch, nnkExceptBranch,
      # nnkElse, nnkAsmStmt, nnkPragma, nnkPragmaBlock, nnkIfStmt, nnkWhenStmt, nnkForStmt,
      # nnkParForStmt, nnkWhileStmt, nnkCaseStmt, nnkTypeSection, nnkVarSection,
      # nnkLetSection, nnkConstSection, nnkConstDef, nnkTypeDef, nnkYieldStmt, nnkDefer,
      # nnkTryStmt, nnkFinally, nnkRaiseStmt, nnkReturnStmt, nnkBreakStmt, nnkContinueStmt,
      # nnkBlockStmt, nnkStaticStmt, nnkDiscardStmt, nnkStmtList, nnkImportStmt,
      # nnkImportExceptStmt, nnkExportStmt, nnkExportExceptStmt, nnkFromStmt,
      # nnkIncludeStmt, nnkBindStmt, nnkMixinStmt, nnkUsingStmt, nnkCommentStmt,
      # nnkStmtListExpr, nnkBlockExpr, nnkStmtListType, nnkBlockType, nnkWith, nnkWithout,
      # nnkTypeOfExpr, nnkObjectTy, nnkTupleTy, nnkTupleClassTy, nnkTypeClassTy,
      # nnkStaticTy, nnkRecList, nnkRecCase, nnkRecWhen, nnkRefTy, nnkPtrTy, nnkVarTy,
      # nnkConstTy, nnkMutableTy, nnkDistinctTy, nnkProcTy, nnkIteratorTy, nnkSharedTy,
      # nnkEnumTy, nnkEnumFieldDef, nnkArglist, nnkPattern, nnkHiddenTryStmt, nnkClosure,
      # nnkGotoState, nnkState, nnkBreakState, nnkFuncDef, nnkTupleConstr

proc checkReplaceSelfVar(node: NimNode, childIndex: int, varsList, propsList: seq[string]) {.compileTime.} =
  let identName = node[childIndex].strVal
  if varsList.binarySearch(identName) == -1 and propsList.binarySearch(identName) != -1:
    var newChild = newDotExpr(ident("self"), node[childIndex])
    node.del childIndex
    node.insert(childIndex, newChild)

proc checkReplaceSelfMethod(node: NimNode, childIndex: int, methodsList: seq[string]) {.compileTime.} =
  if methodsList.binarySearch(node[childIndex].strVal) != -1:
    var newChild = newDotExpr(ident("self"), node[childIndex])
    node.del childIndex
    node.insert(childIndex, newChild)

proc applySelf(node: NimNode, varsList: ref seq[string], propsList, methodsList: seq[string]) {.compileTime.} =
  var lowIndx = -1
  var highIndx = node.len - 1
  var isBlock: bool = false
  case node.kind:
    of nnkCommand, nnkCall:
      if node[0].kind == nnkDotExpr:
        lowIndx = 0
      elif node[0].kind == nnkIdent:
        checkReplaceSelfMethod(node, 0, methodsList)
      else:
        lowIndx = 1
    of nnkInfix..nnkPostfix, nnkExprColonExpr, nnkObjConstr, nnkCast:
      lowIndx = 1
    of nnkExprEqExpr, nnkPar, nnkCurly..nnkBracketExpr, nnkRange, nnkDerefExpr, nnkIfExpr, nnkTableConstr, nnkAddr, nnkAsgn,
        nnkIfStmt, nnkCaseStmt, nnkVarSection, nnkLetSection, nnkConstSection, nnkDefer, nnkRaiseStmt, nnkReturnStmt, nnkStmtList,
        nnkStmtListExpr, nnkTupleConstr:
      lowIndx = 0
    of nnkIdentDefs:
      lowIndx = 2
      if node[0].kind == nnkIdent:
        let index = lowerBound(varsList[], node[0].strVal)
        varsList[].insert(node[0].strVal, index)
    of nnkVarTuple:
      lowIndx = node.len - 1
      for i in 0..node.len - 3:
        if node[i].kind == nnkIdent:
          let index = lowerBound(varsList[], node[i].strVal)
          varsList[].insert(node[i].strVal, index)
    of nnkDotExpr:
      lowIndx = 0
      highIndx = 0
    of nnkElifExpr, nnkElseExpr, nnkOfBranch..nnkElse, nnkWhenStmt..nnkWhileStmt, nnkTryStmt, nnkFinally, nnkBlockStmt, nnkBlockExpr:
      isBlock = true
      lowIndx = 0
    of nnkConstDef:
      if node[0].kind == nnkIdent:
        let index = lowerBound(varsList[], node[0].strVal)
        varsList[].insert(node[0].strVal, index)
    else:
      discard
  if lowIndx != -1:
    var nodeVars = varsList
    for i in lowIndx..highIndx:
      if isBlock and i == highIndx:
        new(nodeVars)
        nodeVars[] = varsList[]
      if node[i].kind == nnkIdent:
        checkReplaceSelfVar(node, i, nodeVars[], propsList)
      else:
        applySelf(node[i], nodeVars, propsList, methodsList)

proc genType(obj: ObjectDecl): NimNode {.compileTime.} =
  result = newNimNode(nnkStmtList)

  # Nim type definition
  let typeDef = newNimNode(nnkTypeDef)
  result.add(newNimNode(nnkTypeSection).add(typeDef))
  typeDef.add(postfix(ident(obj.name), "*"))
  typeDef.add(newEmptyNode())
  let objTy = newNimNode(nnkObjectTy)
  typeDef.add(newNimNode(nnkRefTy).add(objTy))
  objTy.add(newEmptyNode())
  if obj.parentName.len == 0:
    objTy.add(newEmptyNode())
  else:
    objTy.add(newNimNode(nnkOfInherit).add(ident(obj.parentName)))

  let recList = newNimNode(nnkRecList)
  objTy.add(recList)
  let initBody = newStmtList()
  for decl in obj.fields:
    if not decl.defaultValue.isNil and decl.defaultValue.kind != nnkEmpty:
      initBody.add(newNimNode(nnkAsgn).add(decl.name, decl.defaultValue))
    let name = if not decl.isExported: decl.name
               else: postfix(decl.name, "*")
    recList.add(newIdentDefs(name, decl.typ))

  # Add default values and/or super call to init method
  initBody.insert(0, newNimNode(nnkCommand).add(ident("procCall"),
    newCall("init", newCall(obj.parentName, ident("self")))))
  var initMethod: NimNode
  for meth in obj.methods:
    if meth.name == "init" and meth.nimNode[3].len == 1:
      initMethod = meth.nimNode
      break
  if initMethod.isNil:
    obj.methods.add(MethodDecl(
      name: "init",
      args: newSeq[VarDecl](),
      returnType: newEmptyNode(),
      isVirtual: true,
      isNoGodot: false,
      nimNode: newProc(postfix(ident("init"), "*"), body = initBody,
                       procType = nnkMethodDef)
    ))
  else:
    initMethod.body.insert(0, initBody)

  # {.this: self.} for convenience
  # result.add(newNimNode(nnkPragma).add(newNimNode(nnkExprColonExpr).add(
  #   ident("this"), ident("self")
  # )))

  # Nim proc defintions
  var decls = newSeqOfCap[NimNode](obj.methods.len)
  for meth in obj.methods:
    let selfArg = newIdentDefs(ident("self"), ident(obj.name))
    meth.nimNode.params.insert(1, selfArg)
    let decl = meth.nimNode.copyNimTree()
    decl.body = newEmptyNode()
    decl.addPragma(ident("gcsafe"))
    decl.addPragma(newNimNode(nnkExprColonExpr).add(ident("locks"),
                                                newIntLitNode(0)))
    decls.add(decl)
  # add forward declarations first
  for decl in decls:
    result.add(decl)
  for meth in obj.methods:
    result.add(meth.nimNode)

  # Register Godot object
  let parentName = if obj.parentName.len == 0: newStrLitNode("Object")
                   else: newStrLitNode(obj.parentName)
  let classNameLit = newStrLitNode(obj.name)
  let classNameIdent = ident(obj.name)
  let isRef: bool = if obj.parentName.len == 0: false
                    else: obj.parentName in refClasses
  # Wrapping bools with a newLit is required as a temporary workaround for
  # https://github.com/nim-lang/Nim/issues/7375
  result.add(getAst(
    registerGodotClass(classNameIdent, classNameLit, newLit(isRef), parentName,
                       genSym(nskProc, "createFunc"), newLit(obj.isTool))))

  # Register fields (properties)
  for field in obj.fields:
    if field.isNoGodot: continue
    let hintStr = if field.hintStr.isNone: "NIM"
                  else: field.hintStr.get
    let hint = if field.hint.isNone: "NIM"
               else: field.hint.get
    let usage =
      if field.usage.isNil:
        newLit(ord(GodotPropertyUsage.Default) or
               ord(GodotPropertyUsage.ScriptVariable))
      else: field.usage
    let hasDefaultValue = not field.defaultValue.isNil and
                          field.defaultValue.kind != nnkEmpty
    let hintIdent = ident(hint)
    let nimType = repr field.typ
    result.add(getAst(
      registerGodotField(classNameLit, classNameIdent,
                         newCStringLit(toGodotStyle($field.name.basename())),
                         ident(field.name), nimType,
                         field.typ, genSym(nskProc, "setFunc"),
                         genSym(nskProc, "getFunc"),
                         newStrLitNode(hintStr), hintIdent, usage,
                         ident($hasDefaultValue), field.defaultValue)))
  
  # Keep track of object's fields and methods (used instead of deprecated this:self pragma)
  var propsList: seq[string] = @[]
  for field in obj.fields:
    let indx = lowerBound(propsList, field.name.strVal)
    propsList.insert(field.name.strVal, indx)
  var methodsList: seq[string] = @[]
  for meth in obj.methods:
    let indx = lowerBound(methodsList, meth.name)
    methodsList.insert(meth.name, indx)
  
  # Inject self to properties and methods
  for meth in obj.methods:
    let varsList = new(seq[string])
    for v in meth.nimNode[3]:
      if v.kind == nnkIdentDefs:
        varsList[].add v[0].strVal
    applySelf(meth.nimNode[6], varsList, propsList, methodsList)
        

  # Register methods
  template registerGodotMethod(classNameLit, classNameIdent, methodNameIdent,
                               methodNameLit, minArgs, maxArgs,
                               argTypes, methFuncIdent, hasReturnValue) =
    when (NimMajor, NimMinor, NimPatch) < (0, 19, 0):
      {.emit: """/*TYPESECTION*/
N_NOINLINE(void, setStackBottom)(void* thestackbottom);
""".}
    else:
      {.emit: """
N_NOINLINE(void, nimGC_setStackBottom)(void* thestackbottom);
""".}

    proc methFuncIdent(obj: ptr GodotObject, methodData: pointer,
                       userData: pointer, numArgs: cint,
                       args: var array[MAX_ARG_COUNT, ptr GodotVariant]):
                      GodotVariant {.noconv.} =
      var stackBottom {.volatile.}: pointer
      {.emit: """
      nimGC_setStackBottom((void*)(&`stackBottom`));
      """.}
      let self = cast[classNameIdent](userData)
      const isStaticCall = methodNameLit == cstring"_ready" or
                           methodNameLit == cstring"_process" or
                           methodNameLit == cstring"_fixed_process" or
                           methodNameLit == cstring"_enter_tree" or
                           methodNameLit == cstring"_exit_tree" or
                           methodNameLit == cstring"_enter_world" or
                           methodNameLit == cstring"_exit_world" or
                           methodNameLit == cstring"_draw"
      when defined(release):
        invokeVarArgs(methodNameIdent, self, minArgs, maxArgs, numArgs,
                      args, argTypes, hasReturnValue, isStaticCall)
      else:
        try:
          invokeVarArgs(methodNameIdent, self, minArgs, maxArgs, numArgs,
                        args, argTypes, hasReturnValue, isStaticCall)
        except:
          let ex = getCurrentException()
          printError("Unhandled Nim exception (" & $ex.name & "): " &
                     ex.msg & "\n" & ex.getStackTrace())

    let meth = GodotInstanceMethod(
      meth: methFuncIdent
    )
    nativeScriptRegisterMethod(getNativeLibHandle(), classNameLit,
                               methodNameLit, GodotMethodAttributes(), meth)

  for meth in obj.methods:
    if meth.isNoGodot: continue
    let maxArgs = meth.args.len
    var minArgs = maxArgs
    var argTypes = newSeq[NimNode]()
    for idx, arg in meth.args:
      if minArgs == maxArgs and not arg.defaultValue.isNil and
        arg.defaultValue.kind != nnkEmpty:
        minArgs = idx
      argTypes.add(arg.typ)

    let godotMethodName = if meth.isVirtual: "_" & toGodotStyle(meth.name)
                          else: toGodotStyle(meth.name)
    let hasReturnValueBool = not (meth.returnType.isNil or
                         meth.returnType.kind == nnkEmpty or
                         (meth.returnType.kind == nnkIdent and
                          meth.returnType.strVal == "void"))
    let hasReturnValue = if hasReturnValueBool: ident("true")
                         else: ident("false")
    result.add(getAst(
      registerGodotMethod(classNameLit, classNameIdent, ident(meth.name),
                          newCStringLit(godotMethodName), minArgs, maxArgs,
                          argTypes, genSym(nskProc, "methFunc"),
                          hasReturnValue)))

  if isRef:
    # add ref/unref for types inherited from Reference
    template registerRefIncDec(classNameLit) =
      let refInc = GodotInstanceMethod(
        meth: refcountIncremented
      )
      let refDec = GodotInstanceMethod(
        meth: refcountDecremented
      )
      nativeScriptRegisterMethod(getNativeLibHandle(), classNameLit,
                                 cstring"_refcount_incremented",
                                 GodotMethodAttributes(), refInc)
      nativeScriptRegisterMethod(getNativeLibHandle(), classNameLit,
                                 cstring"_refcount_decremented",
                                 GodotMethodAttributes(), refDec)
    result.add(getAst(registerRefIncDec(classNameLit)))

# {.push warning[Deprecated]: off.}
# immediate macros are deprecated, but `untyped` doesn't make it immediate,
# as the warning and the documentation claim.

macro gdobj*(ast: varargs[untyped]): untyped =
  ## Generates Godot type. Self-documenting example:
  ##
  ## .. code-block:: nim
  ##   import godot, node
  ##
  ##   gdobj MyObj of Node:
  ##     var myField: int
  ##       ## Not exported to Godot (i.e. editor will not see this field).
  ##
  ##     var myString* {.gdExport, hint: Length, hintStr: "20".}: string
  ##       ## Exported to Godot as ``my_string``.
  ##       ## Editor will limit this string to length 20.
  ##       ## ``hint` is a value of ``GodotPropertyHint`` enum.
  ##       ## ``hintStr`` depends on the value of ``hint``, its format is
  ##       ## described in ``GodotPropertyHint`` documentation.
  ##
  ##     method ready*() =
  ##       ## Exported methods are exported to Godot by default,
  ##       ## and their Godot names are prefixed with ``_``
  ##       ## (in this case ``_ready``)
  ##       print("I am ready! myString is: " & myString)
  ##
  ##     proc myProc*() {.gdExport.} =
  ##       ## Exported to Godot as ``my_proc``
  ##       print("myProc is called! Incrementing myField.")
  ##       inc myField
  ##
  ## If parent type is omitted, the type is inherited from ``Object``.
  ##
  ## ``tool`` specifier can be added to mark the type as an
  ## `editor plugin <https://godot.readthedocs.io/en/stable/development/plugins/making_plugins.html>`_:
  ##
  ## .. code-block:: nim
  ##   import godot, editor_plugin
  ##
  ##   gdobj(MyTool of EditorPlugin, tool):
  ##     method enterTree*() =
  ##       print("MyTool initialized!")
  ##
  ## Objects can be instantiated by invoking
  ## `gdnew <godotnim.html#gdnew>`_ or by using
  ## `load <godotapi/resource_loader.html#load,string,string,bool>`_ or any other way
  ## that you can find in `Godot API <index.html#modules-godot-api>`_.
  let typeDef = parseType(ast)
  result = genType(typeDef)

# {.push warning[Deprecated]: on.}