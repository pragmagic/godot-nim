# Copyright 2017 Xored Software, Inc.

import macros, tables, typetraits
import godotinternal, internal.godotvariants
import godotnim, core.variants

type
  VarDecl = ref object
    name: NimNode
    typ: NimNode
    defaultValue: NimNode
    isNoGodot: bool
    hint: string
    hintTip: string
    usage: string
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

template parseError(node: NimNode, msg: string) =
  raise newException(ParseError, lineinfo(node) & ": " & msg)

proc extractNames(definition: NimNode):
    tuple[name, parentName: string] =
  if definition.kind == nnkIdent:
    result.name = $(definition.ident)
  else:
    if not (definition.kind == nnkInfix and definition[0].ident == !"of"):
      parseError(definition, "invalid type definition")
    result.name = $(definition[1].ident)
    case definition[2].kind:
      of nnkIdent:
        result.parentName = $definition[2].ident
      else:
        parseError(definition[2], "parent type expected")

proc newRStrLit(s: string): NimNode {.compileTime.} =
  result = newNimNode(nnkRStrLit)
  result.strVal = s

proc newCStringLit(s: string): NimNode {.compileTime.} =
  newNimNode(nnkCallStrLit).add(ident("cstring"), newRStrLit(s))

iterator pragmas(node: NimNode):
      tuple[key: NimIdent, value: string, index: int] =
  assert node.kind in {nnkPragma, nnkEmpty}
  for index in countdown(node.len - 1, 0):
    if node[index].kind == nnkExprColonExpr:
      let val = $(node[index][1])
      yield (node[index][0].ident, val, index)
    elif node[index].kind == nnkIdent:
      yield (node[index].ident, nil, index)

proc removePragma(statement: NimNode, pname: string): bool =
  ## Removes the pragma from the node and returns whether pragma was removed
  if not (RoutineNodes.contains(statement.kind) or
          statement.kind == nnkPragmaExpr):
    return false
  var pragmas = if RoutineNodes.contains(statement.kind): statement.pragma()
                else: statement[1]
  let pnameIdent = !pname
  for ident, val, i in pragmas(pragmas):
    if ident == pnameIdent:
      pragmas.del(i)
      return true

proc removeStrPragma(statement: NimNode,
                     pname: string): string {.compileTime.} =
  ## Removes the pragma from the node and returns value of the pragma
  ## Works for routine nodes or nnkPragmaExpr
  if not (RoutineNodes.contains(statement.kind) or
          statement.kind == nnkPragmaExpr):
    return nil

  result = nil
  var pragmas = if RoutineNodes.contains(statement.kind): statement.pragma()
                else: statement[1]
  let pnameIdent = !pname
  for ident, val, i in pragmas(pragmas):
    if ident == pnameIdent:
      pragmas.del(i)
      return (if val.isNil: "" else: val)

proc isExported(node: NimNode): bool {.compileTime.} =
  if node.kind == nnkPragmaExpr:
    result = isExported(node[0])
  elif node.kind == nnkPostfix:
    result = ($node[0] == "*")

proc identDefsToVarDecls(identDefs: NimNode): seq[VarDecl] =
  assert(identDefs.kind == nnkIdentDefs)
  result = newSeqOfCap[VarDecl](identDefs.len - 2)

  for i in 0..<(identDefs.len - 2):
    let nameNode = identDefs[i].copyNimTree()
    let hint = removeStrPragma(nameNode, "hint")
    let hintTip = removeStrPragma(nameNode, "tip")
    let usage = removeStrPragma(nameNode, "usage")
    let isGdExport = removePragma(nameNode, "gdExport")
    if not nameNode.isExported() and isGdExport:
      parseError(nameNode, "gdExport is not applicable for private fields")

    let isNoGodot = not nameNode.isExported() or not isGdExport

    result.add(VarDecl(
      name: if nameNode.kind == nnkPragmaExpr: nameNode[0].basename()
            else: nameNode.basename(),
      typ: identDefs[identDefs.len - 2],
      defaultValue: identDefs[identDefs.len - 1],
      hint: hint,
      hintTip: hintTip,
      isNoGodot: isNoGodot,
      usage: usage,
      isExported: nameNode.isExported()
    ))

proc parseMethod(meth: NimNode): MethodDecl =
  assert(meth.kind in {nnkProcDef, nnkMethodDef})
  let methName = meth[0]
  let isGdExport = removePragma(meth, "gdExport")
  if not methName.isExported() and isGdExport:
    parseError(meth, "gdExport is not applicable for private procs/methods")
  let isNoGodot = meth.kind != nnkMethodDef and (
                    not methName.isExported() or
                    not isGdExport
                  ) or removePragma(meth, "noExport")
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
  result = identDefsToVarDecls(decl[0])

proc parseType(definition, callSite: NimNode): ObjectDecl =
  let body = callSite[^1]
  result = ObjectDecl(
    fields: newSeq[VarDecl](),
    methods: newSeq[MethodDecl]()
  )
  (result.name, result.parentName) = extractNames(definition)

  var isTool = false
  for i in 2..(callSite.len - 2):
    let option = callSite[i]
    if option.kind != nnkIdent:
      parseError(option, "type specifier expected")
    if option.ident == !"tool":
      isTool = true
    else:
      parseError(option, "valid type specifier expected")
  result.isTool = isTool

  if result.parentName.isNil: result.parentName = "Object"
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
                    hasReturnValue: static[bool]): typed =
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
    let invocation = newNimNode(nnkCall)
    invocation.add(procIdent)
    invocation.add(objIdent) # self
    for idx in 0..<i:
      let argIdent = genSym(nskLet, "arg")
      let errIdent = genSym(nskLet, "err")
      let argT = argTypes[idx]
      branchBody.add(getAst(conv($procIdent, argT,
                                 argSeqIdent, idx, argIdent, errIdent)))
      invocation.add(argIdent)
    if hasReturnValue:
      let theCall = newNimNode(nnkBracketExpr).add(newNimNode(nnkDotExpr).add(
        newCall("toGodot", invocation), ident("godotVariant")))
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
    printInvokeErr($procIdent.ident, minArgs, maxArgs, numArgsIdent))))

proc typeError(nimType: cstring, value: string, godotType: VariantType,
               className: cstring, propertyName: cstring): string =
  result = "Tried to assign incompatible value " & value & " (" & $godotType &
            ") to field \"" & $propertyName & "\" (" & $nimType & ") of " &
            $className

proc rangeError(nimType: cstring, value: string, className: cstring,
                propertyName: cstring): string =
  result = "Tried to assign the out-of-range value " & value &
            " to field \"" & $propertyName & "\" (" & $nimType & ") of " &
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

proc refcountIncremented*(obj: NimGodotObject) =
  GC_ref(obj)

proc refcountDecremented*(obj: NimGodotObject): bool =
  GC_unref(obj)

template registerGodotClass(classNameIdent, classNameLit, isRef,
                            baseNameLit, createFuncIdent; isTool: bool) =
  proc createFuncIdent(obj: ptr GodotObject,
                       methData: pointer): pointer {.noconv.} =
    let nimObj = new(classNameIdent)
    nimObj.setOwn()
    nimObj.setGodotObject(obj)
    GC_ref(nimObj)
    result = cast[pointer](nimObj)

  let createFuncObj = GodotInstanceCreateFunc(
    createFunc: createFuncIdent
  )
  let destroyFuncObj = GodotInstanceDestroyFunc(
    destroyFunc: when isRef: nimDestroyRefFunc else: nimDestroyFunc
  )
  registerClass(classNameIdent, classNameLit, false)
  when isTool:
    godotScriptRegisterToolClass(getNativeLibHandle(), classNameLit, baseNameLit,
                                 createFuncObj, destroyFuncObj)
  else:
    godotScriptRegisterClass(getNativeLibHandle(), classNameLit, baseNameLit,
                            createFuncObj, destroyFuncObj)

template registerGodotField(classNameLit, classNameIdent, propNameLit,
                            propNameIdent, propTypeLit, propTypeIdent,
                            setFuncIdent, getFuncIdent, hintTipLit,
                            hintIdent, usageIdent, hasDefaultValue,
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
  var attr = GodotPropertyAttributes(
    typ: ord(godotVariantType(propTypeIdent)),
    hintString: hintTipLit.toGodotString(),
    hint: GodotPropertyHint.hintIdent,
    usage: GodotPropertyUsageFlags.usageIdent
  )
  when hasDefaultValue:
    attr.defaultValue = (defaultValueNode).toGodot()
  godotScriptRegisterProperty(getNativeLibHandle(), classNameLit, propNameLit,
                              attr, setFunc, getFunc)
static:
  import strutils, sets
proc toGodotStyle(s: string): string {.compileTime.} =
  result = newStringOfCap(s.len + 10)
  for c in s:
    if c.isUpperAscii():
      result.add('_')
      result.add(c.toLowerAscii())
    else:
      result.add(c)

proc genType(obj: ObjectDecl): NimNode {.compileTime.} =
  result = newNimNode(nnkStmtList)

  # 1. Nim type definition
  let typeDef = newNimNode(nnkTypeDef)
  result.add(newNimNode(nnkTypeSection).add(typeDef))
  typeDef.add(postfix(ident(obj.name), "*"))
  typeDef.add(newEmptyNode())
  let objTy = newNimNode(nnkObjectTy)
  typeDef.add(newNimNode(nnkRefTy).add(objTy))
  objTy.add(newEmptyNode())
  if obj.parentName.isNil:
    objTy.add(newEmptyNode())
  else:
    objTy.add(newNimNode(nnkOfInherit).add(ident(obj.parentName)))

  let recList = newNimNode(nnkRecList)
  objTy.add(recList)
  for decl in obj.fields:
    if not decl.defaultValue.isNil and decl.defaultValue.kind != nnkEmpty:
      parseError(decl.defaultValue,
                 "Default values are not supported for fields for now.")
    let name = if not decl.isExported: decl.name
               else: postfix(decl.name, "*")
    recList.add(newIdentDefs(name, decl.typ))

  # 2. {.this: self.} for convenience
  result.add(newNimNode(nnkPragma).add(newNimNode(nnkExprColonExpr).add(
    ident("this"), ident("self")
  )))

  # 3. Nim proc defintions
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

  # 4. Register Godot object
  let parentName = if obj.parentName.isNil: newStrLitNode("Object")
                   else: newStrLitNode(obj.parentName)
  let classNameLit = newCStringLit(obj.name)
  let classNameIdent = ident(obj.name)
  let isRef: bool = if obj.parentName.isNil: false
                    else: obj.parentName in refClasses
  result.add(getAst(
    registerGodotClass(classNameIdent, classNameLit, isRef, parentName,
                       genSym(nskProc, "createFunc"), obj.isTool)))

  # 5. Register fields (properties)
  for field in obj.fields:
    if field.isNoGodot: continue
    let hintTip = if field.hintTip.isNil: ""
                  else: field.hintTip
    let hint = if field.hint.isNil: "None"
               else: field.hint
    let usage = if field.usage.isNil: "Default"
                else: field.usage
    let hasDefaultValue = not field.defaultValue.isNil and
                          field.defaultValue.kind != nnkEmpty
    let hintIdent = ident(hint)
    let usageIdent = ident(usage)
    result.add(getAst(
      registerGodotField(classNameLit, classNameIdent,
                         newCStringLit(toGodotStyle($field.name.basename())),
                         ident(field.name), newCStringLit($field.typ),
                         field.typ, genSym(nskProc, "setFunc"),
                         genSym(nskProc, "getFunc"),
                         newStrLitNode(hintTip), hintIdent, usageIdent,
                         ident($hasDefaultValue), field.defaultValue)))

  # 6. Register methods
  template registerGodotMethod(classNameLit, classNameIdent, methodNameIdent,
                               methodNameLit, minArgs, maxArgs,
                               argTypes, methFuncIdent, hasReturnValue) =
    proc methFuncIdent(obj: ptr GodotObject, methodData: pointer,
                       userData: pointer, numArgs: cint,
                       args: var array[MAX_ARG_COUNT, ptr GodotVariant]):
                      GodotVariant {.noconv.} =
      let self = cast[classNameIdent](userData)
      when defined(release):
        invokeVarArgs(methodNameIdent, self, minArgs, maxArgs, numArgs,
                      args, argTypes, hasReturnValue)
      else:
        try:
          invokeVarArgs(methodNameIdent, self, minArgs, maxArgs, numArgs,
                        args, argTypes, hasReturnValue)
        except:
          let ex = getCurrentException()
          printError("Unhandled Nim exception (" & $ex.name & "): " &
                     ex.msg & "\n" & ex.getStackTrace())

    let meth = GodotInstanceMethod(
      meth: methFuncIdent
    )
    godotScriptRegisterMethod(getNativeLibHandle(), classNameLit, methodNameLit,
                              GodotMethodAttributes(), meth)

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
                          meth.returnType.ident == !"void"))
    let hasReturnValue = if hasReturnValueBool: ident("true")
                         else: ident("false")
    result.add(getAst(
      registerGodotMethod(classNameLit, classNameIdent, ident(meth.name),
                          newCStringLit(godotMethodName), minArgs, maxArgs,
                          argTypes, genSym(nskProc, "methFunc"),
                          hasReturnValue)))

  if isRef:
    # add ref/unref for types inherited from Reference
    let noArgs = newSeq[NimNode]()
    result.add(getAst(
        registerGodotMethod(classNameLit, classNameIdent, ident("refcountIncremented"),
                            cstring"_refcount_incremented", 0, 0,
                            noArgs, genSym(nskProc, "refcount_incremented"),
                            ident("false"))))
    result.add(getAst(
        registerGodotMethod(classNameLit, classNameIdent, ident("refcountDecremented"),
                            cstring"_refcount_decremented", 0, 0,
                            noArgs, genSym(nskProc, "refcount_decremented"),
                            ident("true"))))

{.push warning[Deprecated]: off.}
# immediate macros are deprecated, but `untyped` doesnt make it immediate,
# as the warning and the documentation claim.

macro gdobj*(definition: untyped, body: typed): typed {.immediate.} =
  let typeDef = parseType(definition, callsite())
  result = genType(typeDef)

{.push warning[Deprecated]: on.}

