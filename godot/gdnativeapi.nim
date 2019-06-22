# Copyright 2018 Xored Software, Inc.

import internal/godotinternaltypes, core/godotcoretypes, macros

type
  ColorData* {.byref.} = object
    data: array[16, uint8]

  Vector3Data* {.byref.} = object
    data: array[12, uint8]

  Vector2Data* {.byref.} = object
    data: array[8, uint8]

  PlaneData* {.byref.} = object
    data: array[16, uint8]

  BasisData* {.byref.} = object
    data: array[36, uint8]

  QuatData* {.byref.} = object
    data: array[16, uint8]

  AABBData* {.byref.} = object
    data: array[24, uint8]

  Rect2Data* {.byref.} = object
    data: array[16, uint8]

  Transform2DData* {.byref.} = object
    data: array[24, uint8]

  TransformData* {.byref.} = object
    data: array[48, uint8]

  GDNativeAPIType {.size: sizeof(cuint).} = enum
    GDNativeCore,
    GDNativeExtNativeScript,
    GDNativeExtPluginScript,
    GDNativeExtNativeARVR

  GDNativeAPIHeader = object
    typ: cuint
    version: GDNativeAPIVersion
    next: pointer

  GDNativeNativeScriptAPI1 = object
    typ: cuint
    version: GDNativeAPIVersion
    next: pointer
    nativeScriptRegisterClass: proc (gdnativeHandle: pointer,
                                     name, base: cstring,
                                     createFunc: GodotInstanceCreateFunc,
                                     destroyFunc: GodotInstanceDestroyFunc)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    nativeScriptRegisterToolClass: proc (gdnativeHandle: pointer,
                                         name, base: cstring,
                                         createFunc: GodotInstanceCreateFunc,
                                         destroyFunc: GodotInstanceDestroyFunc)
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    nativeScriptRegisterMethod: proc (gdnativeHandle: pointer,
                                      name, functionName: cstring,
                                      attr: GodotMethodAttributes,
                                      meth: GodotInstanceMethod)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    nativeScriptRegisterProperty: proc (gdnativeHandle: pointer,
                                        name, path: cstring,
                                        attr: ptr GodotPropertyAttributes,
                                        setFunc: GodotPropertySetFunc,
                                        getFunc: GodotPropertyGetFunc)
                                       {.noconv, raises: [], gcsafe, tags: [],
                                         locks: 0.}
    nativeScriptRegisterSignal: proc (gdnativeHandle: pointer, name: cstring,
                                      signal: GodotSignal)
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    nativeScriptGetUserdata: proc (obj: ptr GodotObject): pointer
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

  GDNativeCoreAPI1 = object
    typ: cuint
    version: GDNativeAPIVersion
    next: pointer
    numExtensions: cuint
    extensions: ptr array[100_000, pointer]

    # Color API
    colorNewRGBA: proc (dest: var Color, r, g, b, a: float32)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorNewRGB: proc (dest: var Color, r, g, b: float32)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetR: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetR: proc (self: var Color, r: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetG: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetG: proc (self: var Color, g: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetB: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetB: proc (self: var Color, b: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetA: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetA: proc (self: var Color, a: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetH: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetS: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetV: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorAsString: proc (self: Color): GodotString
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorToRGBA32: proc (self: Color): cint
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorAsARGB32: proc (self: Color): cint
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGray: proc (self: Color): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorInverted: proc (self: Color): ColorData
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorContrasted: proc (self: Color): ColorData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorLinearInterpolate: proc (self, other: Color, t: float32): ColorData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    colorBlend: proc (self, other: Color): ColorData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorToHtml: proc (self: Color, withAlpha: bool): GodotString
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorOperatorEqual: proc (self, other: Color): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorOperatorLess: proc (self, other: Color): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Vector2 API
    vector2New: proc (dest: var Vector2, x, y: float32)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2AsString: proc (self: Vector2): GodotString
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Normalized: proc (self: Vector2): Vector2Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Length: proc (self: Vector2): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Angle: proc (self: Vector2): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2LengthSquared: proc (self: Vector2): float32
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2IsNormalized: proc (self: Vector2): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2DistanceTo: proc (self, to: Vector2): float32
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2DistanceSquaredTo: proc (self, to: Vector2): float32
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    vector2AngleTo: proc (self, to: Vector2): float32
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2AngleToPoint: proc (self, to: Vector2): float32
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2LinearInterpolate: proc (self, b: Vector2, t: float32): Vector2Data
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    vector2CubicInterpolate: proc (self, b, preA, postB: Vector2,
                                    t: float32): Vector2Data
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    vector2Rotated: proc (self: Vector2, phi: float32): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Tangent: proc (self: Vector2): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Floor: proc (self: Vector2): Vector2Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Snapped: proc (self, by: Vector2): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Aspect: proc (self: Vector2): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Dot: proc (self, other: Vector2): float32
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Slide: proc (self, n: Vector2): Vector2Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Bounce: proc (self, n: Vector2): Vector2Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Reflect: proc (self, n: Vector2): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Abs: proc (self: Vector2): Vector2Data
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Clamped: proc (self: Vector2, length: float32): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorAdd: proc (self, other: Vector2): Vector2Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorSubtract: proc (self, other: Vector2): Vector2Data
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    vector2OperatorMultiplyVector: proc (self, other: Vector2): Vector2Data
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    vector2OperatorMultiplyScalar: proc (self: Vector2, scalar: float32): Vector2Data
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    vector2OperatorDivideVector: proc (self, other: Vector2): Vector2Data
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    vector2OperatorDivideScalar: proc (self: Vector2, scalar: float32): Vector2Data
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    vector2OperatorEqual: proc (self, other: Vector2): bool
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorLess: proc (self, other: Vector2): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorNeg: proc (self: Vector2): Vector2Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2SetX: pointer
    vector2SetY: pointer
    vector2GetX: pointer
    vector2GetY: pointer

    # Quat API
    quatNew: proc (dest: var Quat, x, y, z, w: float32)
                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatNewWithAxisAngle: proc (dest: Quat, axis: Vector3,
                                angle: float32)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetX: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetX: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetY: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetY: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetZ: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetZ: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetW: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetW: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatAsString: proc (self: Quat): GodotString
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatLength: proc (self: Quat): float32
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatLengthSquared: proc (self: Quat): float32
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatNormalized: proc (self: Quat): QuatData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatIsNormalized: proc (self: Quat): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatInverse: proc (self: Quat): QuatData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatDot: proc (self, other: Quat): float32
                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatXform: proc (self: Quat, v: Vector3): Vector3Data
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSlerp: proc (self, other: Quat, t: float32): QuatData
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSlerpni: proc (self, other: Quat, t: float32): QuatData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatCubicSlerp: proc (self, other, preA, postB: Quat, t: float32): QuatData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorMultiply: proc (self: Quat, b: float32): QuatData
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorAdd: proc (self, other: Quat): QuatData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorSubtract: proc (self, other: Quat): QuatData
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorDivide: proc (self: Quat, divider: float32): QuatData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorEqual: proc (self, other: Quat): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorNeg: proc (self: Quat): QuatData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Basis API
    basisNewWithRows: pointer
    basisNewWithAxisAndAngle: pointer
    basisNewWithEuler: pointer
    basisAsString: pointer
    basisInverse: pointer
    basisTransposed: pointer
    basisOrthonormalized: pointer
    basisDeterminant: pointer
    basisRotated: pointer
    basisScaled: pointer
    basisGetScale: pointer
    basisGetEuler: pointer
    basisTdotx: pointer
    basisTdoty: pointer
    basisTdotz: pointer
    basisXform: pointer
    basisXformInv: pointer
    basisGetOrthogonalIndex: pointer
    basisNew: pointer
    basisNewWithEulerQuat: pointer
    basisGetElements: pointer
    basisGetAxis: pointer
    basisSetAxis: pointer
    basisGetRow: pointer
    basisSetRow: pointer
    basisOperatorEqual: pointer
    basisOperatorAdd: pointer
    basisOperatorSubstract: pointer
    basisOperatorMultiplyVector: pointer
    basisOperatorMultiplyScalar: pointer

    # Vector3 API
    vector3New: pointer
    vector3AsString: pointer
    vector3MinAxis: pointer
    vector3MaxAxis: pointer
    vector3Length: pointer
    vector3Length_squared: pointer
    vector3IsNormalized: pointer
    vector3Normalized: pointer
    vector3Inverse: pointer
    vector3Snapped: pointer
    vector3Rotated: pointer
    vector3LinearInterpolate: pointer
    vector3CubicInterpolate: pointer
    vector3Dot: pointer
    vector3Cross: pointer
    vector3Outer: pointer
    vector3ToDiagonalMatrix: pointer
    vector3Abs: pointer
    vector3Floor: pointer
    vector3Ceil: pointer
    vector3DistanceTo: pointer
    vector3DistanceSquaredTo: pointer
    vector3AngleTo: pointer
    vector3Slide: pointer
    vector3Bounce: pointer
    vector3Reflect: pointer
    vector3OperatorAdd: pointer
    vector3OperatorSubstract: pointer
    vector3OperatorMultiplyVector: pointer
    vector3OperatorMultiplyScalar: pointer
    vector3OperatorDivideVector: pointer
    vector3OperatorDivideScalar: pointer
    vector3OperatorEqual: pointer
    vector3OperatorLess: pointer
    vector3OperatorNeg: pointer
    vector3SetAxis: pointer
    vector3GetAxis: pointer

    # PoolByteArray API
    poolByteArrayNew: proc (dest: var GodotPoolByteArray)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayNewCopy: proc (dest: var GodotPoolByteArray,
                                src: GodotPoolByteArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayNewWithArray: proc (dest: var GodotPoolByteArray,
                                      src: GodotArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolByteArrayAppend: proc (self: var GodotPoolByteArray,
                                val: byte)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayAppendArray: proc (self: var GodotPoolByteArray,
                                    arr: GodotPoolByteArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolByteArrayInsert: proc (self: var GodotPoolByteArray,
                                idx: cint, val: byte): Error
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayInvert: proc (self: var GodotPoolByteArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayPushBack: proc (self: var GodotPoolByteArray, val: byte)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolByteArrayRemove: proc (self: var GodotPoolByteArray, idx: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayResize: proc (self: var GodotPoolByteArray, size: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayRead: proc (self: GodotPoolByteArray): ptr GodotPoolByteArrayReadAccess
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWrite: proc (self: var GodotPoolByteArray): ptr GodotPoolByteArrayWriteAccess
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArraySet: proc (self: var GodotPoolByteArray, idx: cint, data: byte)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayGet: proc (self: GodotPoolByteArray, idx: cint): byte
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArraySize: proc (self: GodotPoolByteArray): cint
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayDestroy: proc (self: GodotPoolByteArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # PoolIntArray API
    poolIntArrayNew: proc (dest: var GodotPoolIntArray)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayNewCopy: proc (dest: var GodotPoolIntArray,
                                src: GodotPoolIntArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayNewWithArray: proc (dest: var GodotPoolIntArray, src: GodotArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolIntArrayAppend: proc (self: var GodotPoolIntArray, val: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayAppendArray: proc (self: var GodotPoolIntArray,
                                    arr: GodotPoolIntArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolIntArrayInsert: proc (self: var GodotPoolIntArray, idx: cint,
                              val: cint): Error
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayInvert: proc (self: var GodotPoolIntArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayPushBack: proc (self: var GodotPoolIntArray, val: cint)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayRemove: proc (self: var GodotPoolIntArray, idx: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayResize: proc (self: var GodotPoolIntArray, size: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayRead: proc (self: GodotPoolIntArray): ptr GodotPoolIntArrayReadAccess
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWrite: proc (self: var GodotPoolIntArray): ptr GodotPoolIntArrayWriteAccess
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArraySet: proc (self: var GodotPoolIntArray, idx: cint, data: cint)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayGet: proc (self: GodotPoolIntArray, idx: cint): cint
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArraySize: proc (self: GodotPoolIntArray): cint
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayDestroy: proc (self: GodotPoolIntArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # PoolRealArray API
    poolRealArrayNew: proc (dest: var GodotPoolRealArray)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayNewCopy: proc (dest: var GodotPoolRealArray,
                                src: GodotPoolRealArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayNewWithArray: proc (dest: var GodotPoolRealArray,
                                      src: GodotArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolRealArrayAppend: proc (self: var GodotPoolRealArray, val: float32)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayAppendArray: proc (self: var GodotPoolRealArray,
                                    arr: GodotPoolRealArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolRealArrayInsert: proc (self: var GodotPoolRealArray,
                                idx: cint, val: float32): Error
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayInvert: proc (self: var GodotPoolRealArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayPushBack: proc (self: var GodotPoolRealArray, val: float32)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolRealArrayRemove: proc (self: var GodotPoolRealArray, idx: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayResize: proc (self: var GodotPoolRealArray, size: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayRead: proc (self: GodotPoolRealArray): ptr GodotPoolRealArrayReadAccess
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWrite: proc (self: var GodotPoolRealArray): ptr GodotPoolRealArrayWriteAccess
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArraySet: proc (self: var GodotPoolRealArray, idx: cint,
                            data: float32)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayGet: proc (self: GodotPoolRealArray, idx: cint): float32
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArraySize: proc (self: GodotPoolRealArray): cint
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayDestroy: proc (self: GodotPoolRealArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # PoolStringArray API
    poolStringArrayNew: proc (dest: var GodotPoolStringArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayNewCopy: proc (dest: var GodotPoolStringArray,
                                  src: GodotPoolStringArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolStringArrayNewWithArray: proc (dest: var GodotPoolStringArray,
                                        src: GodotArray)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    poolStringArrayAppend: proc (self: var GodotPoolStringArray,
                                  val: GodotString)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolStringArrayAppendArray: proc (self: var GodotPoolStringArray,
                                      arr: GodotPoolStringArray)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    poolStringArrayInsert: proc (self: var GodotPoolStringArray,
                                  idx: cint, val: GodotString): Error
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolStringArrayInvert: proc (self: var GodotPoolStringArray)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolStringArrayPushBack: proc (self: var GodotPoolStringArray,
                                    val: GodotString)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolStringArrayRemove: proc (self: var GodotPoolStringArray, idx: cint)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolStringArrayResize: proc (self: var GodotPoolStringArray, size: cint)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolStringArrayRead: proc (self: GodotPoolStringArray): ptr GodotPoolStringArrayReadAccess
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWrite: proc (self: var GodotPoolStringArray): ptr GodotPoolStringArrayWriteAccess
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArraySet: proc (self: var GodotPoolStringArray, idx: cint,
                              data: GodotString)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayGet: proc (self: GodotPoolStringArray, idx: cint): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArraySize: proc (self: GodotPoolStringArray): cint
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayDestroy: proc (self: GodotPoolStringArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

    # PoolVector2 API
    poolVector2ArrayNew: proc (dest: var GodotPoolVector2Array)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayNewCopy: proc (dest: var GodotPoolVector2Array,
                                    src: GodotPoolVector2Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayNewWithArray: proc (dest: var GodotPoolVector2Array,
                                        src: GodotArray)
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    poolVector2ArrayAppend: proc (self: var GodotPoolVector2Array, val: Vector2)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayAppendArray: proc (self: var GodotPoolVector2Array,
                                        arr: GodotPoolVector2Array)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    poolVector2ArrayInsert: proc (self: var GodotPoolVector2Array, idx: cint,
                                  val: Vector2): Error
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayInvert: proc (self: var GodotPoolVector2Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayPushBack: proc (self: var GodotPoolVector2Array,
                                    val: Vector2)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolVector2ArrayRemove: proc (self: var GodotPoolVector2Array, idx: cint)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayResize: proc (self: var GodotPoolVector2Array, size: cint)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayRead: proc (self: GodotPoolVector2Array): ptr GodotPoolVector2ArrayReadAccess
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWrite: proc (self: var GodotPoolVector2Array): ptr GodotPoolVector2ArrayWriteAccess
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArraySet: proc (self: var GodotPoolVector2Array, idx: cint,
                                data: Vector2)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayGet: proc (self: GodotPoolVector2Array, idx: cint): Vector2Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArraySize: proc (self: GodotPoolVector2Array): cint
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayDestroy: proc (self: GodotPoolVector2Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

    # PoolVector3 API
    poolVector3ArrayNew: proc (dest: var GodotPoolVector3Array)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayNewCopy: proc (dest: var GodotPoolVector3Array,
                                    src: GodotPoolVector3Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector3ArrayNewWithArray: proc (dest: var GodotPoolVector3Array,
                                        src: GodotArray)
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    poolVector3ArrayAppend: proc (self: var GodotPoolVector3Array, val: Vector3)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector3ArrayAppendArray: proc (self: var GodotPoolVector3Array,
                                        arr: GodotPoolVector3Array)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    poolVector3ArrayInsert: proc (self: var GodotPoolVector3Array, idx: cint,
                                  val: Vector3): Error
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector3ArrayInvert: proc (self: var GodotPoolVector3Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector3ArrayPushBack: proc (self: var GodotPoolVector3Array,
                                    val: Vector3) {.noconv, raises: [], gcsafe,
                                                    tags: [], locks: 0.}
    poolVector3ArrayRemove: proc (self: var GodotPoolVector3Array,
                                  idx: cint) {.noconv, raises: [], gcsafe,
                                                tags: [], locks: 0.}
    poolVector3ArrayResize: proc (self: var GodotPoolVector3Array,
                                  size: cint) {.noconv, raises: [], gcsafe,
                                                tags: [], locks: 0.}
    poolVector3ArrayRead: proc (self: GodotPoolVector3Array): ptr GodotPoolVector3ArrayReadAccess
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWrite: proc (self: var GodotPoolVector3Array): ptr GodotPoolVector3ArrayWriteAccess
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArraySet: proc (self: var GodotPoolVector3Array, idx: cint,
                                data: Vector3) {.noconv, raises: [], gcsafe,
                                                tags: [], locks: 0.}
    poolVector3ArrayGet: proc (self: GodotPoolVector3Array, idx: cint): Vector3Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArraySize: proc (self: GodotPoolVector3Array): cint
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayDestroy: proc (self: GodotPoolVector3Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

    # PoolColorArray API
    poolColorArrayNew: proc (dest: var GodotPoolColorArray)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayNewCopy: proc (dest: var GodotPoolColorArray,
                                  src: GodotPoolColorArray)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    poolColorArrayNewWithArray: proc (dest: var GodotPoolColorArray,
                                      src: GodotArray)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    poolColorArrayAppend: proc (self: var GodotPoolColorArray,
                                val: Color)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayAppendArray: proc (self: var GodotPoolColorArray,
                                      arr: GodotPoolColorArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolColorArrayInsert: proc (self: var GodotPoolColorArray,
                                idx: cint, val: Color): Error
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayInvert: proc (self: var GodotPoolColorArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayPushBack: proc (self: var GodotPoolColorArray, val: Color)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolColorArrayRemove: proc (self: var GodotPoolColorArray, idx: cint)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayResize: proc (self: var GodotPoolColorArray, size: cint)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayRead: proc (self: GodotPoolColorArray): ptr GodotPoolColorArrayReadAccess
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWrite: proc (self: var GodotPoolColorArray): ptr GodotPoolColorArrayWriteAccess
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArraySet: proc (self: var GodotPoolColorArray, idx: cint,
                              data: Color)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayGet: proc (self: GodotPoolColorArray, idx: cint): ColorData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArraySize: proc (self: GodotPoolColorArray): cint
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayDestroy: proc (self: GodotPoolColorArray)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}

    # Pool Array Read/Write Access API

    poolByteArrayReadAccessCopy: proc (self: ptr GodotPoolByteArrayReadAccess): ptr GodotPoolByteArrayReadAccess
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayReadAccessPtr: proc (self: ptr GodotPoolByteArrayReadAccess): ptr byte
                                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayReadAccessOperatorAssign: proc (self, other: ptr GodotPoolByteArrayReadAccess)
                                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayReadAccessDestroy: proc (self: ptr GodotPoolByteArrayReadAccess)
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolIntArrayReadAccessCopy: proc (self: ptr GodotPoolIntArrayReadAccess): ptr GodotPoolIntArrayReadAccess
                                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayReadAccessPtr: proc (self: ptr GodotPoolIntArrayReadAccess): ptr cint
                                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayReadAccessOperatorAssign: proc (self, other: ptr GodotPoolIntArrayReadAccess)
                                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayReadAccessDestroy: proc (self: ptr GodotPoolIntArrayReadAccess)
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolRealArrayReadAccessCopy: proc (self: ptr GodotPoolRealArrayReadAccess): ptr GodotPoolRealArrayReadAccess
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayReadAccessPtr: proc (self: ptr GodotPoolRealArrayReadAccess): ptr float32
                                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayReadAccessOperatorAssign: proc (self, other: ptr GodotPoolRealArrayReadAccess)
                                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayReadAccessDestroy: proc (self: ptr GodotPoolRealArrayReadAccess)
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolStringArrayReadAccessCopy: proc (self: ptr GodotPoolStringArrayReadAccess): ptr GodotPoolStringArrayReadAccess
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayReadAccessPtr: proc (self: ptr GodotPoolStringArrayReadAccess): ptr GodotString
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayReadAccessOperatorAssign: proc (self, other: ptr GodotPoolStringArrayReadAccess)
                                                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayReadAccessDestroy: proc (self: ptr GodotPoolStringArrayReadAccess)
                                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector2ArrayReadAccessCopy: proc (self: ptr GodotPoolVector2ArrayReadAccess): ptr GodotPoolVector2ArrayReadAccess
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayReadAccessPtr: proc (self: ptr GodotPoolVector2ArrayReadAccess): ptr Vector2
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayReadAccessOperatorAssign: proc (self, other: ptr GodotPoolVector2ArrayReadAccess)
                                                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayReadAccessDestroy: proc (self: ptr GodotPoolVector2ArrayReadAccess)
                                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector3ArrayReadAccessCopy: proc (self: ptr GodotPoolVector3ArrayReadAccess): ptr GodotPoolVector3ArrayReadAccess
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayReadAccessPtr: proc (self: ptr GodotPoolVector3ArrayReadAccess): ptr Vector3
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayReadAccessOperatorAssign: proc (self, other: ptr GodotPoolVector3ArrayReadAccess)
                                                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayReadAccessDestroy: proc (self: ptr GodotPoolVector3ArrayReadAccess)
                                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolColorArrayReadAccessCopy: proc (self: ptr GodotPoolColorArrayReadAccess): ptr GodotPoolColorArrayReadAccess
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayReadAccessPtr: proc (self: ptr GodotPoolColorArrayReadAccess): ptr Color
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayReadAccessOperatorAssign: proc (self, other: ptr GodotPoolColorArrayReadAccess)
                                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayReadAccessDestroy: proc (self: ptr GodotPoolColorArrayReadAccess)
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolByteArrayWriteAccessCopy: proc (self: ptr GodotPoolByteArrayWriteAccess): ptr GodotPoolByteArrayWriteAccess
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWriteAccessPtr: proc (self: ptr GodotPoolByteArrayWriteAccess): ptr byte
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWriteAccessOperatorAssign: proc (self, other: ptr GodotPoolByteArrayWriteAccess)
                                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWriteAccessDestroy: proc (self: ptr GodotPoolByteArrayWriteAccess)
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolIntArrayWriteAccessCopy: proc (self: ptr GodotPoolIntArrayWriteAccess): ptr GodotPoolIntArrayWriteAccess
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWriteAccessPtr: proc (self: ptr GodotPoolIntArrayWriteAccess): ptr cint
                                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWriteAccessOperatorAssign: proc (self, other: ptr GodotPoolIntArrayWriteAccess)
                                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWriteAccessDestroy: proc (self: ptr GodotPoolIntArrayWriteAccess)
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolRealArrayWriteAccessCopy: proc (self: ptr GodotPoolRealArrayWriteAccess): ptr GodotPoolRealArrayWriteAccess
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWriteAccessPtr: proc (self: ptr GodotPoolRealArrayWriteAccess): ptr float32
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWriteAccessOperatorAssign: proc (self, other: ptr GodotPoolRealArrayWriteAccess)
                                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWriteAccessDestroy: proc (self: ptr GodotPoolRealArrayWriteAccess)
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolStringArrayWriteAccessCopy: proc (self: ptr GodotPoolStringArrayWriteAccess): ptr GodotPoolStringArrayWriteAccess
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWriteAccessPtr: proc (self: ptr GodotPoolStringArrayWriteAccess): ptr GodotString
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWriteAccessOperatorAssign: proc (self, other: ptr GodotPoolStringArrayWriteAccess)
                                                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWriteAccessDestroy: proc (self: ptr GodotPoolStringArrayWriteAccess)
                                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector2ArrayWriteAccessCopy: proc (self: ptr GodotPoolVector2ArrayWriteAccess): ptr GodotPoolVector2ArrayWriteAccess
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWriteAccessPtr: proc (self: ptr GodotPoolVector2ArrayWriteAccess): ptr Vector2
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWriteAccessOperatorAssign: proc (self, other: ptr GodotPoolVector2ArrayWriteAccess)
                                                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWriteAccessDestroy: proc (self: ptr GodotPoolVector2ArrayWriteAccess)
                                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector3ArrayWriteAccessCopy: proc (self: ptr GodotPoolVector3ArrayWriteAccess): ptr GodotPoolVector3ArrayWriteAccess
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWriteAccessPtr: proc (self: ptr GodotPoolVector3ArrayWriteAccess): ptr Vector3
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWriteAccessOperatorAssign: proc (self, other: ptr GodotPoolVector3ArrayWriteAccess)
                                                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWriteAccessDestroy: proc (self: ptr GodotPoolVector3ArrayWriteAccess)
                                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolColorArrayWriteAccessCopy: proc (self: ptr GodotPoolColorArrayWriteAccess): ptr GodotPoolColorArrayWriteAccess
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWriteAccessPtr: proc (self: ptr GodotPoolColorArrayWriteAccess): ptr Color
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWriteAccessOperatorAssign: proc (self, other: ptr GodotPoolColorArrayWriteAccess)
                                                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWriteAccessDestroy: proc (self: ptr GodotPoolColorArrayWriteAccess)
                                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Array API
    arrayNew: proc (dest: var GodotArray)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayNewCopy: proc (dest: var GodotArray, src: GodotArray)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayNewPoolColorArray: proc (dest: var GodotArray, src: GodotPoolColorArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    arrayNewPoolVector3Array: proc (dest: var GodotArray,
                                    src: GodotPoolVector3Array)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    arrayNewPoolVector2Array: proc (dest: var GodotArray,
                                    src: GodotPoolVector2Array)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    arrayNewPoolStringArray: proc (dest: var GodotArray,
                                    src: GodotPoolStringArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    arrayNewPoolRealArray: proc (dest: var GodotArray, src: GodotPoolRealArray)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    arrayNewPoolIntArray: proc (dest: var GodotArray, src: GodotPoolIntArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayNewPoolByteArray: proc (dest: var GodotArray, src: GodotPoolByteArray)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    arraySet: proc (self: var GodotArray, idx: cint, val: GodotVariant)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayGet: proc (self: GodotArray, idx: cint): GodotVariant
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayOperatorIndex: proc (self: var GodotArray, idx: cint): ptr GodotVariant
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayOperatorIndexConst: pointer
    arrayAppend: proc (self: var GodotArray, val: GodotVariant)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayClear: proc (self: var GodotArray)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayCount: proc (self: GodotArray, val: GodotVariant): cint
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayEmpty: proc (self: GodotArray): bool
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayErase: proc (self: var GodotArray, val: GodotVariant)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayFront: proc (self: GodotArray): GodotVariant
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayBack: proc (self: GodotArray): GodotVariant
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayFind: proc (self: GodotArray, what: GodotVariant, fromIdx: cint): cint
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayFindLast: proc (self: GodotArray, what: GodotVariant): cint
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayHas: proc (self: GodotArray, val: GodotVariant): bool
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayHash: proc (self: GodotArray): cint
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayInsert: proc (self: var GodotArray, pos: cint, val: GodotVariant): Error
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayInvert: proc (self: var GodotArray)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPopBack: proc (self: GodotArray): GodotVariant
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPopFront: proc (self: GodotArray): GodotVariant
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPushBack: proc (self: var GodotArray, val: GodotVariant)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPushFront: proc (self: var GodotArray, val: GodotVariant)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayRemove: proc (self: var GodotArray, idx: cint)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayResize: proc (self: var GodotArray, size: cint)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayRFind: proc (self: GodotArray, what: GodotVariant, fromIdx: cint): cint
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arraySize: proc (self: GodotArray): cint
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arraySort: proc (self: var GodotArray)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arraySortCustom: proc (self: var GodotArray, obj: ptr GodotObject,
                            f: GodotString)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayBSearch: proc (self: var GodotArray, val: ptr GodotVariant,
                        before: bool)
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayBSearchCustom: proc (self: var GodotArray, val: ptr GodotVariant,
                              obj: ptr GodotObject, f: GodotString,
                              before: bool)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayDestroy: proc (self: var GodotArray)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Dictionary API
    dictionaryNew: proc (dest: var GodotDictionary)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryNewCopy: proc (dest: var GodotDictionary, src: GodotDictionary)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryDestroy: proc (self: var GodotDictionary)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionarySize: proc (self: GodotDictionary): cint
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryEmpty: proc (self: GodotDictionary): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryClear: proc (self: var GodotDictionary)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryHas: proc (self: GodotDictionary, key: GodotVariant): bool
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryHasAll: proc (self: GodotDictionary, keys: GodotArray): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryErase: proc (self: var GodotDictionary, key: GodotVariant)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryHash: proc (self: GodotDictionary): cint
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryKeys: proc (self: GodotDictionary): GodotArray
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryValues: proc (self: GodotDictionary): GodotArray
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryGet: proc (self: GodotDictionary, key: GodotVariant): GodotVariant
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionarySet: proc (self: var GodotDictionary, key, value: GodotVariant)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryOperatorIndex: proc (self: var GodotDictionary,
                                   key: GodotVariant): ptr GodotVariant
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    dictionaryOperatorIndexConst: pointer
    dictionaryNext: proc (self: GodotDictionary,
                          key: GodotVariant): ptr GodotVariant
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryOperatorEqual: proc (self, other: GodotDictionary): bool
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    dictionaryToJson: proc (self: GodotDictionary): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # NodePath API
    nodePathNew: proc (dest: var GodotNodePath, src: GodotString)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathNewCopy: proc (dest: var GodotNodePath, src: GodotNodePath)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathDestroy: proc (self: var GodotNodePath)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathAsString: proc (self: GodotNodePath): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathIsAbsolute: proc (self: GodotNodePath): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetNameCount: proc (self: GodotNodePath): cint
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetName: proc (self: GodotNodePath, idx: cint): GodotString
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetSubnameCount: proc (self: GodotNodePath): cint
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    nodePathGetSubname: proc (self: GodotNodePath, idx: cint): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetConcatenatedSubnames: proc (self: GodotNodePath): GodotString
                                          {.noconv, raises: [], gcsafe,
                                            tags: [], locks: 0.}
    nodePathIsEmpty: proc (self: GodotNodePath): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathOperatorEqual: proc (self, other: GodotNodePath): bool
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}

    # Plane API
    planeNewWithReals: proc (dest: var Plane, a, b, c, d: float32)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeNewWithVectors: proc (dest: var Plane, v1, v2, v3: Vector3)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeNewWithNormal: proc (dest: var Plane, normal: Vector3, d: float32)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeAsString: proc (self: Plane): GodotString
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeNormalized: proc (self: Plane): PlaneData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeCenter: proc (self: Plane): Vector3Data
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeGetAnyPoint: proc (self: Plane): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIsPointOver: proc (self: Plane, point: Vector3): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeDistanceTo: proc (self: Plane, point: Vector3): float32
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeHasPoint: proc (self: Plane, point: Vector3, epsilon: float32): bool
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeProject: proc (self: Plane, point: Vector3): Vector3Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIntersect3: proc (self: Plane, dest: var Vector3, b, c: Plane): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIntersectsRay: proc (self: Plane, dest: var Vector3,
                              point, dir: Vector3): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIntersectsSegment: proc (self: Plane, dest: var Vector3,
                                  segmentBegin, segmentEnd: Vector3): bool
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    planeOperatorNeg: proc (self: Plane): PlaneData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeOperatorEqual: proc (self, other: Plane): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeSetNormal: proc (self: var Plane, normal: Vector3)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeGetNormal: proc (self: Plane): Vector3Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeGetD: proc (self: Plane): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeSetD: proc (self: var Plane, d: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Rect2 API
    rect2NewWithPositionAndSize: proc (dest: var Rect2, pos, size: Vector2)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    rect2New: proc (dest: var Rect2, x, y, width, height: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2AsString: proc (self: Rect2): GodotString
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2GetArea: proc (self: Rect2): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Intersects: proc (self, other: Rect2): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Encloses: proc (self, other: Rect2): bool
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2HasNoArea: proc (self: Rect2): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Clip: proc (self, other: Rect2): Rect2Data
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Merge: proc (self, other: Rect2): Rect2Data
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2HasPoint: proc (self: Rect2, point: Vector2): bool
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Grow: proc (self: Rect2, by: float32): Rect2Data
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Expand: proc (self: Rect2, to: Vector2): Rect2Data
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2OperatorEqual: proc (self, other: Rect2): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2GetPosition: proc (self: Rect2): Vector2Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2GetSize: proc (self: Rect2): Vector2Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2SetPosition: proc (self: var Rect2, pos: Vector2)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2SetSize: proc (self: var Rect2, size: Vector2)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # AABB API
    aabbNew: proc (dest: var AABB, pos, size: Vector3)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetPosition: proc (self: AABB): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbSetPosition: proc (self: var AABB, pos: Vector3)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetSize: proc (self: AABB): Vector3Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbSetSize: proc (self: var AABB, pos: Vector3)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbAsString: proc (self: AABB): GodotString
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetArea: proc (self: AABB): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbHasNoArea: proc (self: AABB): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbHasNoSurface: proc (self: AABB): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersects: proc (self, other: AABB): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbEncloses: proc (self, other: AABB): bool
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbMerge: proc (self, other: AABB): AABBData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersection: proc (self, other: AABB): AABBData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersectsPlane: proc (self: AABB, plane: Plane): bool
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersectsSegment: proc (self: AABB, vFrom, vTo: Vector3): bool
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    aabbHasPoint: proc (self: AABB, point: Vector3): bool
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetSupport: proc (self: AABB, dir: Vector3): Vector3Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetLongestAxis: proc (self: AABB): Vector3Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetLongestAxisIndex: proc (self: AABB): cint
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    aabbGetLongestAxisSize: proc (self: AABB): float32
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    aabbGetShortestAxis: proc (self: AABB): Vector3Data
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetShortestAxisIndex: proc (self: AABB): cint
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    aabbGetShortestAxisSize: proc (self: AABB): float32
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    aabbExpand: proc (self: AABB, toPoint: Vector3): AABBData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGrow: proc (self: AABB, by: float32): AABBData
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetEndpoint: proc (self: AABB, idx: cint): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbOperatorEqual: proc (self, other: AABB): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # RID API
    ridNew: proc (dest: var RID)
                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridGetID: proc (self: RID): cint
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridNewWithResource: proc (dest: var RID, obj: ptr GodotObject)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridOperatorEqual: proc (self, other: RID): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridOperatorLess: proc (self, other: RID): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Transform API
    transformNewWithAxisOrigin: proc (dest: var Transform,
                                      xAxis, yAxis, zAxis, origin: Vector3)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transformNew: proc (dest: var Transform, basis: Basis, origin: Vector3)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformGetBasis: proc (self: Transform): BasisData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformSetBasis: proc (self: var Transform, basis: Basis)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformGetOrigin: proc (self: Transform): Vector3Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformSetOrigin: proc (self: var Transform, v: Vector3)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformAsString: proc (self: Transform): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformInverse: proc (self: Transform): TransformData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformAffineInverse: proc (self: Transform): TransformData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transformOrthonormalized: proc (self: Transform): TransformData
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transformRotated: proc (self: Transform, axis: Vector3,
                            phi: float32): TransformData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformScaled: proc (self: Transform, scale: Vector3): TransformData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformTranslated: proc (self: Transform, offset: Vector3): TransformData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformLookingAt: proc (self: Transform, target, up: Vector3): TransformData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformXformPlane: proc (self: Transform, plane: Plane): PlaneData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformXformInvPlane: proc (self: Transform, plane: Plane): PlaneData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transformNewIdentity: proc (dest: var Transform)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformOperatorEqual: proc (self, other: Transform): bool
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transformOperatorMultiply: proc (self, other: Transform): TransformData
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transformXformVector3: proc (self: Transform, v: Vector3): Vector3Data
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    transformXformInvVector3: proc (self: Transform, v: Vector3): Vector3Data
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transformXformAABB: proc (self: Transform, v: AABB): AABBData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformXformInvAABB: proc (self: Transform, v: AABB): AABBData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

    # Transform2D API
    transform2DNew: proc (dest: var Transform2D, rot: float32, pos: Vector2)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DNewAxisOrigin: proc (dest: var Transform2D,
                                    xAxis, yAxis, origin: Vector2)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transform2DAsString: proc (self: Transform2D): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DInverse: proc (self: Transform2D): Transform2DData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DAffineInverse: proc (self: Transform2D): Transform2DData
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transform2DGetRotation: proc (self: Transform2D): float32
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transform2DGetOrigin: proc (self: Transform2D): Vector2Data
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DGetScale: proc (self: Transform2D): Vector2Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DOrthonormalized: proc (self: Transform2D): Transform2DData
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DRotated: proc (self: Transform2D, phi: float32): Transform2DData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DScaled: proc (self: Transform2D, scale: Vector2): Transform2DData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DTranslated: proc (self: Transform2D, offset: Vector2): Transform2DData
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    transform2DXformVector2: proc (self: Transform2D, v: Vector2): Vector2Data
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transform2DXformInvVector2: proc (self: Transform2D, v: Vector2): Vector2Data
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DBasisXformVector2: proc (self: Transform2D, v: Vector2): Vector2Data
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    transform2DBasisXformInvVector2: proc (self: Transform2D,
                                            v: Vector2): Vector2Data
                                          {.noconv, raises: [], gcsafe, tags: [],
                                            locks: 0.}
    transform2DInterpolateWith: proc (self, other: Transform2D,
                                      t: float32): Transform2DData
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DOperatorEqual: proc (self, other: Transform2D): bool
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transform2DOperatorMultiply: proc (self, other: Transform2D): Transform2DData
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DNewIdentity: proc (dest: var Transform2D)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transform2DXformRect2: proc (self: Transform2D, v: Rect2): Rect2Data
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    transform2DXformInvRect2: proc (self: Transform2D, v: Rect2): Rect2Data
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}

    # Variant API
    variantGetType: proc (v: GodotVariant): VariantType
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewCopy: proc (dest: var GodotVariant, src: GodotVariant)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewNil: proc (dest: var GodotVariant)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewBool: proc (dest: var GodotVariant, val: bool)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewUInt: proc (dest: var GodotVariant, val: uint64)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewInt: proc (dest: var GodotVariant, val: int64)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewReal: proc (dest: var GodotVariant, val: float64)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewString: proc (dest: var GodotVariant, val: GodotString)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewVector2: proc (dest: var GodotVariant, val: Vector2)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewRect2: proc (dest: var GodotVariant, val: Rect2)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewVector3: proc (dest: var GodotVariant, val: Vector3)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewTransform2D: proc (dest: var GodotVariant, val: Transform2D)
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    variantNewPlane: proc (dest: var GodotVariant, val: Plane)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewQuat: proc (dest: var GodotVariant, val: Quat)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewAABB: proc (dest: var GodotVariant, val: AABB)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewBasis: proc (dest: var GodotVariant, val: Basis)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewTransform: proc (dest: var GodotVariant, val: Transform)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewColor: proc (dest: var GodotVariant, val: Color)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewNodePath: proc (dest: var GodotVariant, val: GodotNodePath)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewRID: proc (dest: var GodotVariant, val: RID)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewObject: proc (dest: var GodotVariant, val: ptr GodotObject)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewDictionary: proc (dest: var GodotVariant, val: GodotDictionary)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewArray: proc (dest: var GodotVariant, val: GodotArray)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewPoolByteArray: proc (dest: var GodotVariant,
                                    val: GodotPoolByteArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantNewPoolIntArray: proc (dest: var GodotVariant, val: GodotPoolIntArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantNewPoolRealArray: proc (dest: var GodotVariant,
                                    val: GodotPoolRealArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantNewPoolStringArray: proc (dest: var GodotVariant,
                                      val: GodotPoolStringArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    variantNewPoolVector2Array: proc (dest: var GodotVariant,
                                      val: GodotPoolVector2Array)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    variantNewPoolVector3Array: proc (dest: var GodotVariant,
                                      val: GodotPoolVector3Array)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    variantNewPoolColorArray: proc (dest: var GodotVariant,
                                    val: GodotPoolColorArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    variantAsBool: proc (self: GodotVariant): bool
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsUInt: proc (self: GodotVariant): uint64
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsInt: proc (self: GodotVariant): int64
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsReal: proc (self: GodotVariant): float64
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsString: proc (self: GodotVariant): GodotString
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsVector2: proc (self: GodotVariant): Vector2Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsRect2: proc (self: GodotVariant): Rect2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsVector3: proc (self: GodotVariant): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsTransform2D: proc (self: GodotVariant): Transform2DData
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsPlane: proc (self: GodotVariant): PlaneData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsQuat: proc (self: GodotVariant): QuatData
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsAABB: proc (self: GodotVariant): AABBData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsBasis: proc (self: GodotVariant): BasisData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsTransform: proc (self: GodotVariant): TransformData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsColor: proc (self: GodotVariant): ColorData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsNodePath: proc (self: GodotVariant): GodotNodePath
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsRID: proc (self: GodotVariant): RID
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsObject: proc (self: GodotVariant): ptr GodotObject
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsDictionary: proc (self: GodotVariant): GodotDictionary
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsArray: proc (self: GodotVariant): GodotArray
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsPoolByteArray: proc (self: GodotVariant): GodotPoolByteArray
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantAsPoolIntArray: proc (self: GodotVariant): GodotPoolIntArray
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    variantAsPoolRealArray: proc (self: GodotVariant): GodotPoolRealArray
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantAsPoolStringArray: proc (self: GodotVariant): GodotPoolStringArray
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    variantAsPoolVector2Array: proc (self: GodotVariant): GodotPoolVector2Array
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    variantAsPoolVector3Array: proc (self: GodotVariant): GodotPoolVector3Array
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    variantAsPoolColorArray: proc (self: GodotVariant): GodotPoolColorArray
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantCall: proc (self: var GodotVariant, meth: GodotString,
                        args: ptr array[MAX_ARG_COUNT, ptr GodotVariant],
                        argcount: cint,
                        callError: var VariantCallError): GodotVariant
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantHasMethod: proc (self: GodotVariant, meth: GodotString): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantOperatorEqual: proc (self, other: GodotVariant): bool
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantOperatorLess: proc (self, other: GodotVariant): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantHashCompare: proc (self, other: GodotVariant): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantBooleanize: proc (self: GodotVariant): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantDestroy: proc (self: var GodotVariant)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # String API
    charStringLength: proc (self: GodotCharString): cint
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    charStringGetData: proc (self: GodotCharString): cstring
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    charStringDestroy: proc (self: var GodotCharString)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringNew: proc (dest: var GodotString)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringNewCopy: proc (dest: var GodotString, src: GodotString)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringNewWithWideString: pointer
    stringOperatorIndex: pointer
    stringOperatorIndexConst: pointer
    stringWideStr: proc (self: GodotString): ptr cwchar_t
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringOperatorEqual: proc (self, other: GodotString): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringOperatorLess: proc (self, other: GodotString): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringOperatorPlus: proc (self, other: GodotString): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringLength: proc (self: GodotString): cint
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringCasecmpTo: pointer
    stringNocasecmpTo: pointer
    stringNaturalnocasecmpTo: pointer
    stringBeginsWith: pointer
    stringBeginsWithCharArray: pointer
    stringBigrams: pointer
    stringChr: pointer
    stringEndsWith: pointer
    stringFind: pointer
    stringFindFrom: pointer
    stringFindmk: pointer
    stringFindmkFrom: pointer
    stringFindmkFromInPlace: pointer
    stringFindn: pointer
    stringFindnFrom: pointer
    stringFindLast: pointer
    stringFormat: pointer
    stringFormatWithCustomPlaceholder: pointer
    stringHexEncodeBuffer: pointer
    stringHexToInt: pointer
    stringHexToIntWithoutPrefix: pointer
    stringInsert: pointer
    stringIsNumeric: pointer
    stringIsSubsequenceOf: pointer
    stringIsSubsequenceOfi: pointer
    stringLpad: pointer
    stringLpadWithCustomCharacter: pointer
    stringMatch: pointer
    stringMatchn: pointer
    stringMd5: pointer
    stringNum: pointer
    stringNumInt64: pointer
    stringNumInt64Capitalized: pointer
    stringNumReal: pointer
    stringNumScientific: pointer
    stringNumWithDecimals: pointer
    stringPadDecimals: pointer
    stringPadZeros: pointer
    stringReplaceFirst: pointer
    stringReplace: pointer
    stringReplacen: pointer
    stringRfind: pointer
    stringRfindn: pointer
    stringRfindFrom: pointer
    stringRfindnFrom: pointer
    stringRpad: pointer
    stringRpadWithCustomCharacter: pointer
    stringSimilarity: pointer
    stringSprintf: pointer
    stringSubstr: pointer
    stringToDouble: pointer
    stringToFloat: pointer
    stringToInt: pointer
    stringCamelcaseToUnderscore: pointer
    stringCamelcaseToUnderscoreLowercased: pointer
    stringCapitalize: pointer
    stringCharToDouble: pointer
    stringCharToInt: pointer
    stringWcharToInt: pointer
    stringCharToIntWithLen: pointer
    stringCharToInt64WithLen: pointer
    stringHexToInt64: pointer
    stringHexToInt64WithPrefix: pointer
    stringToInt64: pointer
    stringUnicodeCharToDouble: pointer
    stringGetSliceCount: pointer
    stringGetSlice: pointer
    stringGetSlicec: pointer
    stringSplit: pointer
    stringSplitAllowEmpty: pointer
    stringSplitFloats: pointer
    stringSplitFloatsAllowsEmpty: pointer
    stringSplitFloatsMk: pointer
    stringSplitFloatsMkAllowsEmpty: pointer
    stringSplitInts: pointer
    stringSplitIntsAllowsEmpty: pointer
    stringSplitIntsMk: pointer
    stringSplitIntsMkAllowsEmpty: pointer
    stringSplitSpaces: pointer
    stringCharLowercase: pointer
    stringCharUppercase: pointer
    stringToLower: pointer
    stringToUpper: pointer
    stringGetBasename: pointer
    stringGetExtension: pointer
    stringLeft: pointer
    stringOrdAt: pointer
    stringPlusFile: pointer
    stringRight: pointer
    stringStripEdges: pointer
    stringStripEscapes: pointer
    stringErase: pointer
    stringAscii: pointer
    stringAsciiExtended: pointer
    stringUtf8: proc (self: GodotString): GodotCharString
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringParseUtf8: pointer
    stringParseUtf8WithLen: pointer
    stringCharsToUtf8: proc (str: cstring): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringCharsToUtf8WithLen: proc (str: cstring, len: cint): GodotString
                                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringHash: pointer
    stringHash64: pointer
    stringHashChars: pointer
    stringHashCharsWithLen: pointer
    stringHashUtf8Chars: pointer
    stringHashUtf8CharsWithLen: pointer
    stringMd5Buffer: pointer
    stringMd5Text: pointer
    stringSha256Buffer: pointer
    stringSha256Text: pointer
    stringEmpty: pointer
    stringGetBaseDir: pointer
    stringGetFile: pointer
    stringHumanizeSize: pointer
    stringIsAbsPath: pointer
    stringIsRelPath: pointer
    stringIsResourceFile: pointer
    stringPathTo: pointer
    stringPathToFile: pointer
    stringSimplifyPath: pointer
    stringCEscape: pointer
    stringCEscapeMultiline: pointer
    stringCUnescape: pointer
    stringHttpEscape: pointer
    stringHttpUnescape: pointer
    stringJsonEscape: pointer
    stringWordWrap: pointer
    stringXmlEscape: pointer
    stringXmlEscapeWithQuotes: pointer
    stringXmlUnescape: pointer
    stringPercentDecode: pointer
    stringPercentEncode: pointer
    stringIsValidFloat: pointer
    stringIsValidHexNumber: pointer
    stringIsValidHtmlColor: pointer
    stringIsValidIdentifier: pointer
    stringIsValidInteger: pointer
    stringIsValidIpAddress: pointer
    stringDestroy: proc (self: var GodotString)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # StringName API
    stringNameNew: pointer
    stringNameNewData: pointer
    stringNameGetName: pointer
    stringNameGetHash: pointer
    stringNameGetDataUniquePointer: pointer
    stringNameOperatorEqual: pointer
    stringNameOperatorLess: pointer
    stringNameDestroy: pointer

    # Misc API
    objectDestroy: proc (self: ptr GodotObject)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    globalGetSingleton: proc (name: cstring): ptr GodotObject
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    methodBindGetMethod: proc (className,
                                methodName: cstring): ptr GodotMethodBind
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    methodBindPtrCall: proc (methodBind: ptr GodotMethodBind,
                              obj: ptr GodotObject,
                              args: ptr array[MAX_ARG_COUNT, pointer],
                              ret: pointer)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    methodBindCall: proc (methodBind: ptr GodotMethodBind, obj: ptr GodotObject,
                          args: ptr array[MAX_ARG_COUNT, ptr GodotVariant],
                          argCount: cint,
                          callError: var VariantCallError): GodotVariant
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    getClassConstructor: proc (className: cstring): GodotClassConstructor
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    getGlobalConstants: pointer
    registerNativeCallType: proc (callType: cstring,
                                  cb: proc (procHandle: pointer,
                                            args: ptr GodotArray): GodotVariant
                                           {.noconv.}) {.noconv.}
    alloc: proc (bytes: cint): pointer
                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    realloc: proc (p: pointer, bytes: cint): pointer
                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    free: proc (p: pointer) {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    printError: proc (description, function, file: cstring, line: cint)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    printWarning: proc (description, function, file: cstring, line: cint)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    print: proc (message: GodotString)
                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

  GDNativeAPI* = object
    # Color API
    colorNewRGBA*: proc (dest: var Color, r, g, b, a: float32)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorNewRGB*: proc (dest: var Color, r, g, b: float32)
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetR*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetR*: proc (self: var Color, r: float32)
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetG*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetG*: proc (self: var Color, g: float32)
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetB*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetB*: proc (self: var Color, b: float32)
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetA*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorSetA*: proc (self: var Color, a: float32)
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetH*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetS*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGetV*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorAsString*: proc (self: Color): GodotString
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorToRGBA32*: proc (self: Color): cint
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorAsARGB32*: proc (self: Color): cint
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorGray*: proc (self: Color): float32
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorInverted*: proc (self: Color): ColorData
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorContrasted*: proc (self: Color): ColorData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorLinearInterpolate*: proc (self, other: Color, t: float32): ColorData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    colorBlend*: proc (self, other: Color): ColorData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorToHtml*: proc (self: Color, withAlpha: bool): GodotString
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorOperatorEqual*: proc (self, other: Color): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    colorOperatorLess*: proc (self, other: Color): bool
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Vector2 API
    vector2New*: proc (dest: var Vector2, x, y: float32)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2AsString*: proc (self: Vector2): GodotString
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Normalized*: proc (self: Vector2): Vector2Data
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Length*: proc (self: Vector2): float32
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Angle*: proc (self: Vector2): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2LengthSquared*: proc (self: Vector2): float32
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2IsNormalized*: proc (self: Vector2): bool
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2DistanceTo*: proc (self, to: Vector2): float32
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2DistanceSquaredTo*: proc (self, to: Vector2): float32
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    vector2AngleTo*: proc (self, to: Vector2): float32
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2AngleToPoint*: proc (self, to: Vector2): float32
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2LinearInterpolate*: proc (self, b: Vector2, t: float32): Vector2Data
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    vector2CubicInterpolate*: proc (self, b, preA, postB: Vector2,
                                    t: float32): Vector2Data
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    vector2Rotated*: proc (self: Vector2, phi: float32): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Tangent*: proc (self: Vector2): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Floor*: proc (self: Vector2): Vector2Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Snapped*: proc (self, by: Vector2): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Aspect*: proc (self: Vector2): float32
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Dot*: proc (self, other: Vector2): float32
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Slide*: proc (self, n: Vector2): Vector2Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Bounce*: proc (self, n: Vector2): Vector2Data
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Reflect*: proc (self, n: Vector2): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Abs*: proc (self: Vector2): Vector2Data
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2Clamped*: proc (self: Vector2, length: float32): Vector2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorAdd*: proc (self, other: Vector2): Vector2Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorSubtract*: proc (self, other: Vector2): Vector2Data
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    vector2OperatorMultiplyVector*: proc (self, other: Vector2): Vector2Data
                                         {.noconv, raises: [], gcsafe, tags: [],
                                           locks: 0.}
    vector2OperatorMultiplyScalar*: proc (self: Vector2, scalar: float32): Vector2Data
                                         {.noconv, raises: [], gcsafe, tags: [],
                                           locks: 0.}
    vector2OperatorDivideVector*: proc (self, other: Vector2): Vector2Data
                                       {.noconv, raises: [], gcsafe, tags: [],
                                         locks: 0.}
    vector2OperatorDivideScalar*: proc (self: Vector2, scalar: float32): Vector2Data
                                       {.noconv, raises: [], gcsafe, tags: [],
                                         locks: 0.}
    vector2OperatorEqual*: proc (self, other: Vector2): bool
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorLess*: proc (self, other: Vector2): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    vector2OperatorNeg*: proc (self: Vector2): Vector2Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Quat API
    quatNew*: proc (dest: var Quat, x, y, z, w: float32)
                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatNewWithAxisAngle*: proc (dest: Quat, axis: Vector3,
                                 angle: float32)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetX*: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetX*: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetY*: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetY*: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetZ*: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetZ*: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatGetW*: proc (self: Quat): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSetW*: proc (self: var Quat, val: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatAsString*: proc (self: Quat): GodotString
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatLength*: proc (self: Quat): float32
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatLengthSquared*: proc (self: Quat): float32
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatNormalized*: proc (self: Quat): QuatData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatIsNormalized*: proc (self: Quat): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatInverse*: proc (self: Quat): QuatData
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatDot*: proc (self, other: Quat): float32
                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatXform*: proc (self: Quat, v: Vector3): Vector3Data
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSlerp*: proc (self, other: Quat, t: float32): QuatData
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatSlerpni*: proc (self, other: Quat, t: float32): QuatData
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatCubicSlerp*: proc (self, other, preA, postB: Quat, t: float32): QuatData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorMultiply*: proc (self: Quat, b: float32): QuatData
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorAdd*: proc (self, other: Quat): QuatData
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorSubtract*: proc (self, other: Quat): QuatData
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorDivide*: proc (self: Quat, divider: float32): QuatData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorEqual*: proc (self, other: Quat): bool
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    quatOperatorNeg*: proc (self: Quat): QuatData
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # PoolByteArray API
    poolByteArrayNew*: proc (dest: var GodotPoolByteArray)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayNewCopy*: proc (dest: var GodotPoolByteArray,
                                 src: GodotPoolByteArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayNewWithArray*: proc (dest: var GodotPoolByteArray,
                                      src: GodotArray)
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    poolByteArrayAppend*: proc (self: var GodotPoolByteArray,
                                val: byte)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayAppendArray*: proc (self: var GodotPoolByteArray,
                                     arr: GodotPoolByteArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolByteArrayInsert*: proc (self: var GodotPoolByteArray,
                                idx: cint, val: byte): Error
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayInvert*: proc (self: var GodotPoolByteArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayPushBack*: proc (self: var GodotPoolByteArray, val: byte)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolByteArrayRemove*: proc (self: var GodotPoolByteArray, idx: cint)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayResize*: proc (self: var GodotPoolByteArray, size: cint)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayRead*: proc (self: GodotPoolByteArray): ptr GodotPoolByteArrayReadAccess
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWrite*: proc (self: var GodotPoolByteArray): ptr GodotPoolByteArrayWriteAccess
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArraySet*: proc (self: var GodotPoolByteArray, idx: cint, data: byte)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayGet*: proc (self: GodotPoolByteArray, idx: cint): byte
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArraySize*: proc (self: GodotPoolByteArray): cint
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayDestroy*: proc (self: GodotPoolByteArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # PoolIntArray API
    poolIntArrayNew*: proc (dest: var GodotPoolIntArray)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayNewCopy*: proc (dest: var GodotPoolIntArray,
                                src: GodotPoolIntArray)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayNewWithArray*: proc (dest: var GodotPoolIntArray, src: GodotArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolIntArrayAppend*: proc (self: var GodotPoolIntArray, val: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayAppendArray*: proc (self: var GodotPoolIntArray,
                                    arr: GodotPoolIntArray)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    poolIntArrayInsert*: proc (self: var GodotPoolIntArray, idx: cint,
                               val: cint): Error
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayInvert*: proc (self: var GodotPoolIntArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayPushBack*: proc (self: var GodotPoolIntArray, val: cint)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayRemove*: proc (self: var GodotPoolIntArray, idx: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayResize*: proc (self: var GodotPoolIntArray, size: cint)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayRead*: proc (self: GodotPoolIntArray): ptr GodotPoolIntArrayReadAccess
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWrite*: proc (self: var GodotPoolIntArray): ptr GodotPoolIntArrayWriteAccess
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArraySet*: proc (self: var GodotPoolIntArray, idx: cint, data: cint)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayGet*: proc (self: GodotPoolIntArray, idx: cint): cint
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArraySize*: proc (self: GodotPoolIntArray): cint
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayDestroy*: proc (self: GodotPoolIntArray)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # PoolRealArray API
    poolRealArrayNew*: proc (dest: var GodotPoolRealArray)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayNewCopy*: proc (dest: var GodotPoolRealArray,
                                 src: GodotPoolRealArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayNewWithArray*: proc (dest: var GodotPoolRealArray,
                                      src: GodotArray)
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    poolRealArrayAppend*: proc (self: var GodotPoolRealArray, val: float32)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayAppendArray*: proc (self: var GodotPoolRealArray,
                                     arr: GodotPoolRealArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolRealArrayInsert*: proc (self: var GodotPoolRealArray,
                                idx: cint, val: float32): Error
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayInvert*: proc (self: var GodotPoolRealArray)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayPushBack*: proc (self: var GodotPoolRealArray, val: float32)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolRealArrayRemove*: proc (self: var GodotPoolRealArray, idx: cint)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayResize*: proc (self: var GodotPoolRealArray, size: cint)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayRead*: proc (self: GodotPoolRealArray): ptr GodotPoolRealArrayReadAccess
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWrite*: proc (self: var GodotPoolRealArray): ptr GodotPoolRealArrayWriteAccess
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArraySet*: proc (self: var GodotPoolRealArray, idx: cint,
                             data: float32)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayGet*: proc (self: GodotPoolRealArray, idx: cint): float32
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArraySize*: proc (self: GodotPoolRealArray): cint
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayDestroy*: proc (self: GodotPoolRealArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # PoolStringArray API
    poolStringArrayNew*: proc (dest: var GodotPoolStringArray)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayNewCopy*: proc (dest: var GodotPoolStringArray,
                                   src: GodotPoolStringArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolStringArrayNewWithArray*: proc (dest: var GodotPoolStringArray,
                                        src: GodotArray)
                                       {.noconv, raises: [], gcsafe, tags: [],
                                         locks: 0.}
    poolStringArrayAppend*: proc (self: var GodotPoolStringArray,
                                  val: GodotString)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolStringArrayAppendArray*: proc (self: var GodotPoolStringArray,
                                       arr: GodotPoolStringArray)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    poolStringArrayInsert*: proc (self: var GodotPoolStringArray,
                                  idx: cint, val: GodotString): Error
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolStringArrayInvert*: proc (self: var GodotPoolStringArray)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolStringArrayPushBack*: proc (self: var GodotPoolStringArray,
                                    val: GodotString)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    poolStringArrayRemove*: proc (self: var GodotPoolStringArray, idx: cint)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolStringArrayResize*: proc (self: var GodotPoolStringArray, size: cint)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolStringArrayRead*: proc (self: GodotPoolStringArray): ptr GodotPoolStringArrayReadAccess
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWrite*: proc (self: var GodotPoolStringArray): ptr GodotPoolStringArrayWriteAccess
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArraySet*: proc (self: var GodotPoolStringArray, idx: cint,
                               data: GodotString)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayGet*: proc (self: GodotPoolStringArray, idx: cint): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArraySize*: proc (self: GodotPoolStringArray): cint
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayDestroy*: proc (self: GodotPoolStringArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

    # PoolVector2 API
    poolVector2ArrayNew*: proc (dest: var GodotPoolVector2Array)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayNewCopy*: proc (dest: var GodotPoolVector2Array,
                                    src: GodotPoolVector2Array)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    poolVector2ArrayNewWithArray*: proc (dest: var GodotPoolVector2Array,
                                         src: GodotArray)
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    poolVector2ArrayAppend*: proc (self: var GodotPoolVector2Array, val: Vector2)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayAppendArray*: proc (self: var GodotPoolVector2Array,
                                        arr: GodotPoolVector2Array)
                                       {.noconv, raises: [], gcsafe, tags: [],
                                         locks: 0.}
    poolVector2ArrayInsert*: proc (self: var GodotPoolVector2Array, idx: cint,
                                   val: Vector2): Error
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayInvert*: proc (self: var GodotPoolVector2Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayPushBack*: proc (self: var GodotPoolVector2Array,
                                     val: Vector2)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    poolVector2ArrayRemove*: proc (self: var GodotPoolVector2Array, idx: cint)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayResize*: proc (self: var GodotPoolVector2Array, size: cint)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector2ArrayRead*: proc (self: GodotPoolVector2Array): ptr GodotPoolVector2ArrayReadAccess
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWrite*: proc (self: var GodotPoolVector2Array): ptr GodotPoolVector2ArrayWriteAccess
                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArraySet*: proc (self: var GodotPoolVector2Array, idx: cint,
                                data: Vector2)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayGet*: proc (self: GodotPoolVector2Array, idx: cint): Vector2Data
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArraySize*: proc (self: GodotPoolVector2Array): cint
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayDestroy*: proc (self: GodotPoolVector2Array)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}

    # PoolVector3 API
    poolVector3ArrayNew*: proc (dest: var GodotPoolVector3Array)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayNewCopy*: proc (dest: var GodotPoolVector3Array,
                                    src: GodotPoolVector3Array)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    poolVector3ArrayNewWithArray*: proc (dest: var GodotPoolVector3Array,
                                         src: GodotArray)
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    poolVector3ArrayAppend*: proc (self: var GodotPoolVector3Array, val: Vector3)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector3ArrayAppendArray*: proc (self: var GodotPoolVector3Array,
                                        arr: GodotPoolVector3Array)
                                       {.noconv, raises: [], gcsafe, tags: [],
                                         locks: 0.}
    poolVector3ArrayInsert*: proc (self: var GodotPoolVector3Array, idx: cint,
                                   val: Vector3): Error
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector3ArrayInvert*: proc (self: var GodotPoolVector3Array)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolVector3ArrayPushBack*: proc (self: var GodotPoolVector3Array,
                                     val: Vector3) {.noconv, raises: [], gcsafe,
                                                    tags: [], locks: 0.}
    poolVector3ArrayRemove*: proc (self: var GodotPoolVector3Array,
                                  idx: cint) {.noconv, raises: [], gcsafe,
                                                tags: [], locks: 0.}
    poolVector3ArrayResize*: proc (self: var GodotPoolVector3Array,
                                   size: cint) {.noconv, raises: [], gcsafe,
                                                tags: [], locks: 0.}
    poolVector3ArrayRead*: proc (self: GodotPoolVector3Array): ptr GodotPoolVector3ArrayReadAccess
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWrite*: proc (self: var GodotPoolVector3Array): ptr GodotPoolVector3ArrayWriteAccess
                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArraySet*: proc (self: var GodotPoolVector3Array, idx: cint,
                                data: Vector3) {.noconv, raises: [], gcsafe,
                                                tags: [], locks: 0.}
    poolVector3ArrayGet*: proc (self: GodotPoolVector3Array, idx: cint): Vector3Data
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArraySize*: proc (self: GodotPoolVector3Array): cint
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayDestroy*: proc (self: GodotPoolVector3Array)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

    # PoolColorArray API
    poolColorArrayNew*: proc (dest: var GodotPoolColorArray)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayNewCopy*: proc (dest: var GodotPoolColorArray,
                                  src: GodotPoolColorArray)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    poolColorArrayNewWithArray*: proc (dest: var GodotPoolColorArray,
                                       src: GodotArray)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    poolColorArrayAppend*: proc (self: var GodotPoolColorArray,
                                 val: Color)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayAppendArray*: proc (self: var GodotPoolColorArray,
                                      arr: GodotPoolColorArray)
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    poolColorArrayInsert*: proc (self: var GodotPoolColorArray,
                                 idx: cint, val: Color): Error
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayInvert*: proc (self: var GodotPoolColorArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayPushBack*: proc (self: var GodotPoolColorArray, val: Color)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    poolColorArrayRemove*: proc (self: var GodotPoolColorArray, idx: cint)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayResize*: proc (self: var GodotPoolColorArray, size: cint)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayRead*: proc (self: GodotPoolColorArray): ptr GodotPoolColorArrayReadAccess
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWrite*: proc (self: var GodotPoolColorArray): ptr GodotPoolColorArrayWriteAccess
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArraySet*: proc (self: var GodotPoolColorArray, idx: cint,
                              data: Color)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayGet*: proc (self: GodotPoolColorArray, idx: cint): ColorData
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArraySize*: proc (self: GodotPoolColorArray): cint
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayDestroy*: proc (self: GodotPoolColorArray)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}

    # Pool Array Read/Write Access API

    poolByteArrayReadAccessCopy*: proc (self: ptr GodotPoolByteArrayReadAccess): ptr GodotPoolByteArrayReadAccess
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayReadAccessPtr*: proc (self: ptr GodotPoolByteArrayReadAccess): ptr byte
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayReadAccessOperatorAssign*: proc (self, other: ptr GodotPoolByteArrayReadAccess)
                                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayReadAccessDestroy*: proc (self: ptr GodotPoolByteArrayReadAccess)
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolIntArrayReadAccessCopy*: proc (self: ptr GodotPoolIntArrayReadAccess): ptr GodotPoolIntArrayReadAccess
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayReadAccessPtr*: proc (self: ptr GodotPoolIntArrayReadAccess): ptr cint
                                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayReadAccessOperatorAssign*: proc (self, other: ptr GodotPoolIntArrayReadAccess)
                                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayReadAccessDestroy*: proc (self: ptr GodotPoolIntArrayReadAccess)
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolRealArrayReadAccessCopy*: proc (self: ptr GodotPoolRealArrayReadAccess): ptr GodotPoolRealArrayReadAccess
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayReadAccessPtr*: proc (self: ptr GodotPoolRealArrayReadAccess): ptr float32
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayReadAccessOperatorAssign*: proc (self, other: ptr GodotPoolRealArrayReadAccess)
                                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayReadAccessDestroy*: proc (self: ptr GodotPoolRealArrayReadAccess)
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolStringArrayReadAccessCopy*: proc (self: ptr GodotPoolStringArrayReadAccess): ptr GodotPoolStringArrayReadAccess
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayReadAccessPtr*: proc (self: ptr GodotPoolStringArrayReadAccess): ptr GodotString
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayReadAccessOperatorAssign*: proc (self, other: ptr GodotPoolStringArrayReadAccess)
                                                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayReadAccessDestroy*: proc (self: ptr GodotPoolStringArrayReadAccess)
                                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector2ArrayReadAccessCopy*: proc (self: ptr GodotPoolVector2ArrayReadAccess): ptr GodotPoolVector2ArrayReadAccess
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayReadAccessPtr*: proc (self: ptr GodotPoolVector2ArrayReadAccess): ptr Vector2
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayReadAccessOperatorAssign*: proc (self, other: ptr GodotPoolVector2ArrayReadAccess)
                                                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayReadAccessDestroy*: proc (self: ptr GodotPoolVector2ArrayReadAccess)
                                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector3ArrayReadAccessCopy*: proc (self: ptr GodotPoolVector3ArrayReadAccess): ptr GodotPoolVector3ArrayReadAccess
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayReadAccessPtr*: proc (self: ptr GodotPoolVector3ArrayReadAccess): ptr Vector3
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayReadAccessOperatorAssign*: proc (self, other: ptr GodotPoolVector3ArrayReadAccess)
                                                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayReadAccessDestroy*: proc (self: ptr GodotPoolVector3ArrayReadAccess)
                                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolColorArrayReadAccessCopy*: proc (self: ptr GodotPoolColorArrayReadAccess): ptr GodotPoolColorArrayReadAccess
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayReadAccessPtr*: proc (self: ptr GodotPoolColorArrayReadAccess): ptr Color
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayReadAccessOperatorAssign*: proc (self, other: ptr GodotPoolColorArrayReadAccess)
                                                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayReadAccessDestroy*: proc (self: ptr GodotPoolColorArrayReadAccess)
                                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolByteArrayWriteAccessCopy*: proc (self: ptr GodotPoolByteArrayWriteAccess): ptr GodotPoolByteArrayWriteAccess
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWriteAccessPtr*: proc (self: ptr GodotPoolByteArrayWriteAccess): ptr byte
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWriteAccessOperatorAssign*: proc (self, other: ptr GodotPoolByteArrayWriteAccess)
                                                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolByteArrayWriteAccessDestroy*: proc (self: ptr GodotPoolByteArrayWriteAccess)
                                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolIntArrayWriteAccessCopy*: proc (self: ptr GodotPoolIntArrayWriteAccess): ptr GodotPoolIntArrayWriteAccess
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWriteAccessPtr*: proc (self: ptr GodotPoolIntArrayWriteAccess): ptr cint
                                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWriteAccessOperatorAssign*: proc (self, other: ptr GodotPoolIntArrayWriteAccess)
                                                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolIntArrayWriteAccessDestroy*: proc (self: ptr GodotPoolIntArrayWriteAccess)
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolRealArrayWriteAccessCopy*: proc (self: ptr GodotPoolRealArrayWriteAccess): ptr GodotPoolRealArrayWriteAccess
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWriteAccessPtr*: proc (self: ptr GodotPoolRealArrayWriteAccess): ptr float32
                                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWriteAccessOperatorAssign*: proc (self, other: ptr GodotPoolRealArrayWriteAccess)
                                                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolRealArrayWriteAccessDestroy*: proc (self: ptr GodotPoolRealArrayWriteAccess)
                                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolStringArrayWriteAccessCopy*: proc (self: ptr GodotPoolStringArrayWriteAccess): ptr GodotPoolStringArrayWriteAccess
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWriteAccessPtr*: proc (self: ptr GodotPoolStringArrayWriteAccess): ptr GodotString
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWriteAccessOperatorAssign*: proc (self, other: ptr GodotPoolStringArrayWriteAccess)
                                                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolStringArrayWriteAccessDestroy*: proc (self: ptr GodotPoolStringArrayWriteAccess)
                                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector2ArrayWriteAccessCopy*: proc (self: ptr GodotPoolVector2ArrayWriteAccess): ptr GodotPoolVector2ArrayWriteAccess
                                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWriteAccessPtr*: proc (self: ptr GodotPoolVector2ArrayWriteAccess): ptr Vector2
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWriteAccessOperatorAssign*: proc (self, other: ptr GodotPoolVector2ArrayWriteAccess)
                                                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector2ArrayWriteAccessDestroy*: proc (self: ptr GodotPoolVector2ArrayWriteAccess)
                                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolVector3ArrayWriteAccessCopy*: proc (self: ptr GodotPoolVector3ArrayWriteAccess): ptr GodotPoolVector3ArrayWriteAccess
                                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWriteAccessPtr*: proc (self: ptr GodotPoolVector3ArrayWriteAccess): ptr Vector3
                                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWriteAccessOperatorAssign*: proc (self, other: ptr GodotPoolVector3ArrayWriteAccess)
                                                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolVector3ArrayWriteAccessDestroy*: proc (self: ptr GodotPoolVector3ArrayWriteAccess)
                                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    poolColorArrayWriteAccessCopy*: proc (self: ptr GodotPoolColorArrayWriteAccess): ptr GodotPoolColorArrayWriteAccess
                                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWriteAccessPtr*: proc (self: ptr GodotPoolColorArrayWriteAccess): ptr Color
                                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWriteAccessOperatorAssign*: proc (self, other: ptr GodotPoolColorArrayWriteAccess)
                                                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    poolColorArrayWriteAccessDestroy*: proc (self: ptr GodotPoolColorArrayWriteAccess)
                                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Array API
    arrayNew*: proc (dest: var GodotArray)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayNewCopy*: proc (dest: var GodotArray, src: GodotArray)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayNewPoolColorArray*: proc (dest: var GodotArray, src: GodotPoolColorArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    arrayNewPoolVector3Array*: proc (dest: var GodotArray,
                                     src: GodotPoolVector3Array)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    arrayNewPoolVector2Array*: proc (dest: var GodotArray,
                                     src: GodotPoolVector2Array)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    arrayNewPoolStringArray*: proc (dest: var GodotArray,
                                    src: GodotPoolStringArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    arrayNewPoolRealArray*: proc (dest: var GodotArray, src: GodotPoolRealArray)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    arrayNewPoolIntArray*: proc (dest: var GodotArray, src: GodotPoolIntArray)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayNewPoolByteArray*: proc (dest: var GodotArray, src: GodotPoolByteArray)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    arraySet*: proc (self: var GodotArray, idx: cint, val: GodotVariant)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayGet*: proc (self: GodotArray, idx: cint): GodotVariant
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayOperatorIndex*: proc (self: var GodotArray, idx: cint): ptr GodotVariant
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayAppend*: proc (self: var GodotArray, val: GodotVariant)
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayClear*: proc (self: var GodotArray)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayCount*: proc (self: GodotArray, val: GodotVariant): cint
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayEmpty*: proc (self: GodotArray): bool
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayErase*: proc (self: var GodotArray, val: GodotVariant)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayFront*: proc (self: GodotArray): GodotVariant
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayBack*: proc (self: GodotArray): GodotVariant
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayFind*: proc (self: GodotArray, what: GodotVariant, fromIdx: cint): cint
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayFindLast*: proc (self: GodotArray, what: GodotVariant): cint
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayHas*: proc (self: GodotArray, val: GodotVariant): bool
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayHash*: proc (self: GodotArray): cint
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayInsert*: proc (self: var GodotArray, pos: cint, val: GodotVariant): Error
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayInvert*: proc (self: var GodotArray)
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPopFront*: proc (self: GodotArray): GodotVariant
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPopBack*: proc (self: GodotArray): GodotVariant
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPushBack*: proc (self: var GodotArray, val: GodotVariant)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayPushFront*: proc (self: var GodotArray, val: GodotVariant)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayRemove*: proc (self: var GodotArray, idx: cint)
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayResize*: proc (self: var GodotArray, size: cint)
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayRFind*: proc (self: GodotArray, what: GodotVariant, fromIdx: cint): cint
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arraySize*: proc (self: GodotArray): cint
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arraySort*: proc (self: var GodotArray)
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arraySortCustom*: proc (self: var GodotArray, obj: ptr GodotObject,
                            f: GodotString)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayBSearch*: proc (self: var GodotArray, val: ptr GodotVariant,
                         before: bool)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayBSearchCustom*: proc (self: var GodotArray, val: ptr GodotVariant,
                               obj: ptr GodotObject, f: GodotString,
                               before: bool)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    arrayDestroy*: proc (self: var GodotArray)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Dictionary API
    dictionaryNew*: proc (dest: var GodotDictionary)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryNewCopy*: proc (dest: var GodotDictionary, src: GodotDictionary)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryDestroy*: proc (self: var GodotDictionary)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionarySize*: proc (self: GodotDictionary): cint
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryEmpty*: proc (self: GodotDictionary): bool
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryClear*: proc (self: var GodotDictionary)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryHas*: proc (self: GodotDictionary, key: GodotVariant): bool
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryHasAll*: proc (self: GodotDictionary, keys: GodotArray): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryErase*: proc (self: var GodotDictionary, key: GodotVariant)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryHash*: proc (self: GodotDictionary): cint
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryKeys*: proc (self: GodotDictionary): GodotArray
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryValues*: proc (self: GodotDictionary): GodotArray
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryGet*: proc (self: GodotDictionary, key: GodotVariant): GodotVariant
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionarySet*: proc (self: var GodotDictionary, key, value: GodotVariant)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryOperatorIndex*: proc (self: var GodotDictionary,
                                    key: GodotVariant): ptr GodotVariant
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    dictionaryNext*: proc (self: GodotDictionary,
                           key: GodotVariant): ptr GodotVariant
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    dictionaryOperatorEqual*: proc (self, other: GodotDictionary): bool
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    dictionaryToJson*: proc (self: GodotDictionary): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # NodePath API
    nodePathNew*: proc (dest: var GodotNodePath, src: GodotString)
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathNewCopy*: proc (dest: var GodotNodePath, src: GodotNodePath)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathDestroy*: proc (self: var GodotNodePath)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathAsString*: proc (self: GodotNodePath): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathIsAbsolute*: proc (self: GodotNodePath): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetNameCount*: proc (self: GodotNodePath): cint
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetName*: proc (self: GodotNodePath, idx: cint): GodotString
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetSubnameCount*: proc (self: GodotNodePath): cint
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    nodePathGetSubname*: proc (self: GodotNodePath, idx: cint): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathGetConcatenatedSubnames*: proc (self: GodotNodePath): GodotString
                                           {.noconv, raises: [], gcsafe,
                                             tags: [], locks: 0.}
    nodePathIsEmpty*: proc (self: GodotNodePath): bool
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    nodePathOperatorEqual*: proc (self, other: GodotNodePath): bool
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}

    # Plane API
    planeNewWithReals*: proc (dest: var Plane, a, b, c, d: float32)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeNewWithVectors*: proc (dest: var Plane, v1, v2, v3: Vector3)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeNewWithNormal*: proc (dest: var Plane, normal: Vector3, d: float32)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeAsString*: proc (self: Plane): GodotString
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeNormalized*: proc (self: Plane): PlaneData
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeCenter*: proc (self: Plane): Vector3Data
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeGetAnyPoint*: proc (self: Plane): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIsPointOver*: proc (self: Plane, point: Vector3): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeDistanceTo*: proc (self: Plane, point: Vector3): float32
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeHasPoint*: proc (self: Plane, point: Vector3, epsilon: float32): bool
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeProject*: proc (self: Plane, point: Vector3): Vector3Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIntersect3*: proc (self: Plane, dest: var Vector3, b, c: Plane): bool
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIntersectsRay*: proc (self: Plane, dest: var Vector3,
                               point, dir: Vector3): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeIntersectsSegment*: proc (self: Plane, dest: var Vector3,
                                   segmentBegin, segmentEnd: Vector3): bool
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    planeOperatorNeg*: proc (self: Plane): PlaneData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeOperatorEqual*: proc (self, other: Plane): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeSetNormal*: proc (self: var Plane, normal: Vector3)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeGetNormal*: proc (self: Plane): Vector3Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeGetD*: proc (self: Plane): float32
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    planeSetD*: proc (self: var Plane, d: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Rect2 API
    rect2NewWithPositionAndSize*: proc (dest: var Rect2, pos, size: Vector2)
                                       {.noconv, raises: [], gcsafe, tags: [],
                                         locks: 0.}
    rect2New*: proc (dest: var Rect2, x, y, width, height: float32)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2AsString*: proc (self: Rect2): GodotString
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2GetArea*: proc (self: Rect2): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Intersects*: proc (self, other: Rect2): bool
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Encloses*: proc (self, other: Rect2): bool
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2HasNoArea*: proc (self: Rect2): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Clip*: proc (self, other: Rect2): Rect2Data
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Merge*: proc (self, other: Rect2): Rect2Data
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2HasPoint*: proc (self: Rect2, point: Vector2): bool
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Grow*: proc (self: Rect2, by: float32): Rect2Data
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2Expand*: proc (self: Rect2, to: Vector2): Rect2Data
                       {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2OperatorEqual*: proc (self, other: Rect2): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2GetPosition*: proc (self: Rect2): Vector2Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2GetSize*: proc (self: Rect2): Vector2Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2SetPosition*: proc (self: var Rect2, pos: Vector2)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    rect2SetSize*: proc (self: var Rect2, size: Vector2)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # AABB API
    aabbNew*: proc (dest: var AABB, pos, size: Vector3)
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetPosition*: proc (self: AABB): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbSetPosition*: proc (self: var AABB, pos: Vector3)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetSize*: proc (self: AABB): Vector3Data
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbSetSize*: proc (self: var AABB, pos: Vector3)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbAsString*: proc (self: AABB): GodotString
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetArea*: proc (self: AABB): float32
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbHasNoArea*: proc (self: AABB): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbHasNoSurface*: proc (self: AABB): bool
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersects*: proc (self, other: AABB): bool
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbEncloses*: proc (self, other: AABB): bool
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbMerge*: proc (self, other: AABB): AABBData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersection*: proc (self, other: AABB): AABBData
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersectsPlane*: proc (self: AABB, plane: Plane): bool
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbIntersectsSegment*: proc (self: AABB, vFrom, vTo: Vector3): bool
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    aabbHasPoint*: proc (self: AABB, point: Vector3): bool
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetSupport*: proc (self: AABB, dir: Vector3): Vector3Data
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetLongestAxis*: proc (self: AABB): Vector3Data
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetLongestAxisIndex*: proc (self: AABB): cint
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    aabbGetLongestAxisSize*: proc (self: AABB): float32
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    aabbGetShortestAxis*: proc (self: AABB): Vector3Data
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetShortestAxisIndex*: proc (self: AABB): cint
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    aabbGetShortestAxisSize*: proc (self: AABB): float32
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    aabbExpand*: proc (self: AABB, toPoint: Vector3): AABBData
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGrow*: proc (self: AABB, by: float32): AABBData
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbGetEndpoint*: proc (self: AABB, idx: cint): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    aabbOperatorEqual*: proc (self, other: AABB): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # RID API
    ridNew*: proc (dest: var RID)
                  {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridGetID*: proc (self: RID): cint
                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridNewWithResource*: proc (dest: var RID, obj: ptr GodotObject)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridOperatorEqual*: proc (self, other: RID): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    ridOperatorLess*: proc (self, other: RID): bool
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Transform API
    transformNewWithAxisOrigin*: proc (dest: var Transform,
                                       xAxis, yAxis, zAxis, origin: Vector3)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transformNew*: proc (dest: var Transform, basis: Basis, origin: Vector3)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformGetBasis*: proc (self: Transform): BasisData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformSetBasis*: proc (self: var Transform, basis: Basis)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformGetOrigin*: proc (self: Transform): Vector3Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformSetOrigin*: proc (self: var Transform, v: Vector3)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformAsString*: proc (self: Transform): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformInverse*: proc (self: Transform): TransformData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformAffineInverse*: proc (self: Transform): TransformData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transformOrthonormalized*: proc (self: Transform): TransformData
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transformRotated*: proc (self: Transform, axis: Vector3,
                             phi: float32): TransformData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformScaled*: proc (self: Transform, scale: Vector3): TransformData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformTranslated*: proc (self: Transform, offset: Vector3): TransformData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformLookingAt*: proc (self: Transform, target, up: Vector3): TransformData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformXformPlane*: proc (self: Transform, plane: Plane): PlaneData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformXformInvPlane*: proc (self: Transform, plane: Plane): PlaneData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transformNewIdentity*: proc (dest: var Transform)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformOperatorEqual*: proc (self, other: Transform): bool
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transformOperatorMultiply*: proc (self, other: Transform): TransformData
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transformXformVector3*: proc (self: Transform, v: Vector3): Vector3Data
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    transformXformInvVector3*: proc (self: Transform, v: Vector3): Vector3Data
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transformXformAABB*: proc (self: Transform, v: AABB): AABBData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transformXformInvAABB*: proc (self: Transform, v: AABB): AABBData
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}

    # Transform2D API
    transform2DNew*: proc (dest: var Transform2D, rot: float32, pos: Vector2)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DNewAxisOrigin*: proc (dest: var Transform2D,
                                     xAxis, yAxis, origin: Vector2)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transform2DAsString*: proc (self: Transform2D): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DInverse*: proc (self: Transform2D): Transform2DData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DAffineInverse*: proc (self: Transform2D): Transform2DData
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transform2DGetRotation*: proc (self: Transform2D): float32
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transform2DGetOrigin*: proc (self: Transform2D): Vector2Data
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DGetScale*: proc (self: Transform2D): Vector2Data
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DOrthonormalized*: proc (self: Transform2D): Transform2DData
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DRotated*: proc (self: Transform2D, phi: float32): Transform2DData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DScaled*: proc (self: Transform2D, scale: Vector2): Transform2DData
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    transform2DTranslated*: proc (self: Transform2D, offset: Vector2): Transform2DData
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    transform2DXformVector2*: proc (self: Transform2D, v: Vector2): Vector2Data
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transform2DXformInvVector2*: proc (self: Transform2D, v: Vector2): Vector2Data
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DBasisXformVector2*: proc (self: Transform2D, v: Vector2): Vector2Data
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    transform2DBasisXformInvVector2*: proc (self: Transform2D,
                                            v: Vector2): Vector2Data
                                          {.noconv, raises: [], gcsafe, tags: [],
                                            locks: 0.}
    transform2DInterpolateWith*: proc (self, other: Transform2D,
                                      t: float32): Transform2DData
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DOperatorEqual*: proc (self, other: Transform2D): bool
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    transform2DOperatorMultiply*: proc (self, other: Transform2D): Transform2DData
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    transform2DNewIdentity*: proc (dest: var Transform2D)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    transform2DXformRect2*: proc (self: Transform2D, v: Rect2): Rect2Data
                                {.noconv, raises: [], gcsafe, tags: [],
                                  locks: 0.}
    transform2DXformInvRect2*: proc (self: Transform2D, v: Rect2): Rect2Data
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}

    # Variant API
    variantGetType*: proc (v: GodotVariant): VariantType
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewCopy*: proc (dest: var GodotVariant, src: GodotVariant)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewNil*: proc (dest: var GodotVariant)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewBool*: proc (dest: var GodotVariant, val: bool)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewUInt*: proc (dest: var GodotVariant, val: uint64)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewInt*: proc (dest: var GodotVariant, val: int64)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewReal*: proc (dest: var GodotVariant, val: float64)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewString*: proc (dest: var GodotVariant, val: GodotString)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewVector2*: proc (dest: var GodotVariant, val: Vector2)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewRect2*: proc (dest: var GodotVariant, val: Rect2)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewVector3*: proc (dest: var GodotVariant, val: Vector3)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewTransform2D*: proc (dest: var GodotVariant, val: Transform2D)
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    variantNewPlane*: proc (dest: var GodotVariant, val: Plane)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewQuat*: proc (dest: var GodotVariant, val: Quat)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewAABB*: proc (dest: var GodotVariant, val: AABB)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewBasis*: proc (dest: var GodotVariant, val: Basis)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewTransform*: proc (dest: var GodotVariant, val: Transform)
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewColor*: proc (dest: var GodotVariant, val: Color)
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewNodePath*: proc (dest: var GodotVariant, val: GodotNodePath)
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewRID*: proc (dest: var GodotVariant, val: RID)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewObject*: proc (dest: var GodotVariant, val: ptr GodotObject)
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewDictionary*: proc (dest: var GodotVariant, val: GodotDictionary)
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewArray*: proc (dest: var GodotVariant, val: GodotArray)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantNewPoolByteArray*: proc (dest: var GodotVariant,
                                    val: GodotPoolByteArray)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    variantNewPoolIntArray*: proc (dest: var GodotVariant, val: GodotPoolIntArray)
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantNewPoolRealArray*: proc (dest: var GodotVariant,
                                    val: GodotPoolRealArray)
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    variantNewPoolStringArray*: proc (dest: var GodotVariant,
                                      val: GodotPoolStringArray)
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    variantNewPoolVector2Array*: proc (dest: var GodotVariant,
                                       val: GodotPoolVector2Array)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    variantNewPoolVector3Array*: proc (dest: var GodotVariant,
                                       val: GodotPoolVector3Array)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    variantNewPoolColorArray*: proc (dest: var GodotVariant,
                                     val: GodotPoolColorArray)
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    variantAsBool*: proc (self: GodotVariant): bool
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsUInt*: proc (self: GodotVariant): uint64
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsInt*: proc (self: GodotVariant): int64
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsReal*: proc (self: GodotVariant): float64
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsString*: proc (self: GodotVariant): GodotString
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsVector2*: proc (self: GodotVariant): Vector2Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsRect2*: proc (self: GodotVariant): Rect2Data
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsVector3*: proc (self: GodotVariant): Vector3Data
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsTransform2D*: proc (self: GodotVariant): Transform2DData
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsPlane*: proc (self: GodotVariant): PlaneData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsQuat*: proc (self: GodotVariant): QuatData
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsAABB*: proc (self: GodotVariant): AABBData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsBasis*: proc (self: GodotVariant): BasisData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsTransform*: proc (self: GodotVariant): TransformData
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsColor*: proc (self: GodotVariant): ColorData
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsNodePath*: proc (self: GodotVariant): GodotNodePath
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsRID*: proc (self: GodotVariant): RID
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsObject*: proc (self: GodotVariant): ptr GodotObject
                           {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsDictionary*: proc (self: GodotVariant): GodotDictionary
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsArray*: proc (self: GodotVariant): GodotArray
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantAsPoolByteArray*: proc (self: GodotVariant): GodotPoolByteArray
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantAsPoolIntArray*: proc (self: GodotVariant): GodotPoolIntArray
                                 {.noconv, raises: [], gcsafe, tags: [],
                                   locks: 0.}
    variantAsPoolRealArray*: proc (self: GodotVariant): GodotPoolRealArray
                                  {.noconv, raises: [], gcsafe, tags: [],
                                    locks: 0.}
    variantAsPoolStringArray*: proc (self: GodotVariant): GodotPoolStringArray
                                    {.noconv, raises: [], gcsafe, tags: [],
                                      locks: 0.}
    variantAsPoolVector2Array*: proc (self: GodotVariant): GodotPoolVector2Array
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    variantAsPoolVector3Array*: proc (self: GodotVariant): GodotPoolVector3Array
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    variantAsPoolColorArray*: proc (self: GodotVariant): GodotPoolColorArray
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}
    variantCall*: proc (self: var GodotVariant, meth: GodotString,
                        args: ptr array[MAX_ARG_COUNT, ptr GodotVariant],
                        argcount: cint,
                        callError: var VariantCallError): GodotVariant
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantHasMethod*: proc (self: GodotVariant, meth: GodotString): bool
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantOperatorEqual*: proc (self, other: GodotVariant): bool
                                {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantOperatorLess*: proc (self, other: GodotVariant): bool
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantHashCompare*: proc (self, other: GodotVariant): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantBooleanize*: proc (self: GodotVariant): bool
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    variantDestroy*: proc (self: var GodotVariant)
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # String API
    charStringLength*: proc (self: GodotCharString): cint
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    charStringGetData*: proc (self: GodotCharString): cstring
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    charStringDestroy*: proc (self: var GodotCharString)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringNew*: proc (dest: var GodotString)
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringNewCopy*: proc (dest: var GodotString, src: GodotString)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringWideStr*: proc (self: GodotString): ptr cwchar_t
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringOperatorEqual*: proc (self, other: GodotString): bool
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringOperatorLess*: proc (self, other: GodotString): bool
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringOperatorPlus*: proc (self, other: GodotString): GodotString
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringLength*: proc (self: GodotString): cint
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringDestroy*: proc (self: var GodotString)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringUtf8*: proc (self: GodotString): GodotCharString
                     {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringCharsToUtf8*: proc (str: cstring): GodotString
                            {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    stringCharsToUtf8WithLen*: proc (str: cstring, len: cint): GodotString
                                    {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    # Misc API
    objectDestroy*: proc (self: ptr GodotObject)
                         {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    globalGetSingleton*: proc (name: cstring): ptr GodotObject
                              {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    methodBindGetMethod*: proc (className,
                                methodName: cstring): ptr GodotMethodBind
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    methodBindPtrCall*: proc (methodBind: ptr GodotMethodBind,
                              obj: ptr GodotObject,
                              args: ptr array[MAX_ARG_COUNT, pointer],
                              ret: pointer)
                             {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    methodBindCall*: proc (methodBind: ptr GodotMethodBind, obj: ptr GodotObject,
                           args: ptr array[MAX_ARG_COUNT, ptr GodotVariant],
                           argCount: cint,
                           callError: var VariantCallError): GodotVariant
                          {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    getClassConstructor*: proc (className: cstring): GodotClassConstructor
                               {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    alloc*: proc (bytes: cint): pointer
                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    realloc*: proc (p: pointer, bytes: cint): pointer
                   {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    free*: proc (p: pointer) {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    printError*: proc (description, function, file: cstring, line: cint)
                      {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    printWarning*: proc (description, function, file: cstring, line: cint)
                        {.noconv, raises: [], gcsafe, tags: [], locks: 0.}
    print*: proc (message: GodotString)
                 {.noconv, raises: [], gcsafe, tags: [], locks: 0.}

    nativeScriptRegisterClass*: proc (gdnativeHandle: pointer,
                                      name, base: cstring,
                                      createFunc: GodotInstanceCreateFunc,
                                      destroyFunc: GodotInstanceDestroyFunc)
                                     {.noconv, raises: [], gcsafe, tags: [],
                                       locks: 0.}
    nativeScriptRegisterToolClass*: proc (gdnativeHandle: pointer,
                                          name, base: cstring,
                                          createFunc: GodotInstanceCreateFunc,
                                          destroyFunc: GodotInstanceDestroyFunc)
                                         {.noconv, raises: [], gcsafe, tags: [],
                                           locks: 0.}
    nativeScriptRegisterMethod*: proc (gdnativeHandle: pointer,
                                       name, functionName: cstring,
                                       attr: GodotMethodAttributes,
                                       meth: GodotInstanceMethod)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    nativeScriptRegisterProperty*: proc (gdnativeHandle: pointer,
                                         name, path: cstring,
                                         attr: ptr GodotPropertyAttributes,
                                         setFunc: GodotPropertySetFunc,
                                         getFunc: GodotPropertyGetFunc)
                                        {.noconv, raises: [], gcsafe, tags: [],
                                          locks: 0.}
    nativeScriptRegisterSignal*: proc (gdnativeHandle: pointer, name: cstring,
                                       signal: GodotSignal)
                                      {.noconv, raises: [], gcsafe, tags: [],
                                        locks: 0.}
    nativeScriptGetUserdata*: proc (obj: ptr GodotObject): pointer
                                   {.noconv, raises: [], gcsafe, tags: [],
                                     locks: 0.}

{.push stackTrace: off.}
proc toColor*(val: ColorData): Color {.inline, noinit.} =
  cast[Color](val)

proc toVector3*(val: Vector3Data): Vector3 {.inline, noinit.} =
  cast[Vector3](val)

proc toVector2*(val: Vector2Data): Vector2 {.inline, noinit.} =
  cast[Vector2](val)

proc toPlane*(val: PlaneData): Plane {.inline, noinit.} =
  cast[Plane](val)

proc toBasis*(val: BasisData): Basis {.inline, noinit.} =
  cast[Basis](val)

proc toQuat*(val: QuatData): Quat {.inline, noinit.} =
  cast[Quat](val)

proc toAABB*(val: AABBData): AABB {.inline, noinit.} =
  cast[AABB](val)

proc toRect2*(val: Rect2Data): Rect2 {.inline, noinit.} =
  cast[Rect2](val)

proc toTransform2D*(val: Transform2DData): Transform2D {.inline, noinit.} =
  cast[Transform2D](val)

proc toTransform*(val: TransformData): Transform {.inline, noinit.} =
  cast[Transform](val)
{.pop.}

macro assign(dest, src: typed, values: untyped): typed =
  result = newStmtList()
  for val in values:
    result.add(newNimNode(nnkAsgn).add(
      newNimNode(nnkDotExpr).add(dest, val),
      newNimNode(nnkDotExpr).add(src, val)))

var gdNativeAPI: GDNativeAPI

proc getGDNativeAPI*(): ptr GDNativeAPI {.inline.} =
  addr gdNativeAPI

proc setGDNativeAPIInternal(apiStruct: pointer, initOptions: ptr GDNativeInitOptions,
                            foundCoreApi: var bool, foundNativeScriptApi: var bool) =
  let header = cast[ptr GDNativeAPIHeader](apiStruct)

  if header.typ >= ord(low(GDNativeAPIType)).cuint and header.typ <= ord(high(GDNativeAPIType)).cuint:
    let typ = GDNativeAPIType(header.typ)
    case typ:
    of GDNativeCore:
      let coreApi = cast[ptr GDNativeCoreAPI1](apiStruct)
      if coreApi[].version.major == 1 and coreApi[].version.minor == 0:
        assign(gdNativeApi, coreApi[]):
          # Color API
          colorNewRGBA
          colorNewRGB
          colorGetR
          colorSetR
          colorGetG
          colorSetG
          colorGetB
          colorSetB
          colorGetA
          colorSetA
          colorGetH
          colorGetS
          colorGetV
          colorAsString
          colorToRGBA32
          colorAsARGB32
          colorGray
          colorInverted
          colorContrasted
          colorLinearInterpolate
          colorBlend
          colorToHtml
          colorOperatorEqual
          colorOperatorLess

          # Vector 2 API
          vector2New
          vector2AsString
          vector2Normalized
          vector2Length
          vector2Angle
          vector2LengthSquared
          vector2IsNormalized
          vector2DistanceTo
          vector2DistanceSquaredTo
          vector2AngleTo
          vector2AngleToPoint
          vector2LinearInterpolate
          vector2CubicInterpolate
          vector2Rotated
          vector2Tangent
          vector2Floor
          vector2Snapped
          vector2Aspect
          vector2Dot
          vector2Slide
          vector2Bounce
          vector2Reflect
          vector2Abs
          vector2Clamped
          vector2OperatorAdd
          vector2OperatorSubtract
          vector2OperatorMultiplyVector
          vector2OperatorMultiplyScalar
          vector2OperatorDivideVector
          vector2OperatorDivideScalar
          vector2OperatorEqual
          vector2OperatorLess
          vector2OperatorNeg

          # Quat API
          quatNew
          quatNewWithAxisAngle
          quatGetX
          quatSetX
          quatGetY
          quatSetY
          quatGetZ
          quatSetZ
          quatGetW
          quatSetW
          quatAsString
          quatLength
          quatLengthSquared
          quatNormalized
          quatIsNormalized
          quatInverse
          quatDot
          quatXform
          quatSlerp
          quatSlerpni
          quatCubicSlerp
          quatOperatorMultiply
          quatOperatorAdd
          quatOperatorSubtract
          quatOperatorDivide
          quatOperatorEqual
          quatOperatorNeg

          # PoolByteArray API
          poolByteArrayNew
          poolByteArrayNewCopy
          poolByteArrayNewWithArray
          poolByteArrayAppend
          poolByteArrayAppendArray
          poolByteArrayInsert
          poolByteArrayInvert
          poolByteArrayPushBack
          poolByteArrayRemove
          poolByteArrayResize
          poolByteArrayRead
          poolByteArrayWrite
          poolByteArraySet
          poolByteArrayGet
          poolByteArraySize
          poolByteArrayDestroy

          # PoolIntArray API
          poolIntArrayNew
          poolIntArrayNewCopy
          poolIntArrayNewWithArray
          poolIntArrayAppend
          poolIntArrayAppendArray
          poolIntArrayInsert
          poolIntArrayInvert
          poolIntArrayPushBack
          poolIntArrayRemove
          poolIntArrayResize
          poolIntArrayRead
          poolIntArrayWrite
          poolIntArraySet
          poolIntArrayGet
          poolIntArraySize
          poolIntArrayDestroy

          # PoolRealArray API
          poolRealArrayNew
          poolRealArrayNewCopy
          poolRealArrayNewWithArray
          poolRealArrayAppend
          poolRealArrayAppendArray
          poolRealArrayInsert
          poolRealArrayInvert
          poolRealArrayPushBack
          poolRealArrayRemove
          poolRealArrayResize
          poolRealArrayRead
          poolRealArrayWrite
          poolRealArraySet
          poolRealArrayGet
          poolRealArraySize
          poolRealArrayDestroy

          # PoolStringArray API
          poolStringArrayNew
          poolStringArrayNewCopy
          poolStringArrayNewWithArray
          poolStringArrayAppend
          poolStringArrayAppendArray
          poolStringArrayInsert
          poolStringArrayInvert
          poolStringArrayPushBack
          poolStringArrayRemove
          poolStringArrayResize
          poolStringArrayRead
          poolStringArrayWrite
          poolStringArraySet
          poolStringArrayGet
          poolStringArraySize
          poolStringArrayDestroy


          # PoolVector2 API
          poolVector2ArrayNew
          poolVector2ArrayNewCopy
          poolVector2ArrayNewWithArray
          poolVector2ArrayAppend
          poolVector2ArrayAppendArray
          poolVector2ArrayInsert
          poolVector2ArrayInvert
          poolVector2ArrayPushBack
          poolVector2ArrayRemove
          poolVector2ArrayResize
          poolVector2ArrayRead
          poolVector2ArrayWrite
          poolVector2ArraySet
          poolVector2ArrayGet
          poolVector2ArraySize
          poolVector2ArrayDestroy

          # PoolVector3 API
          poolVector3ArrayNew
          poolVector3ArrayNewCopy
          poolVector3ArrayNewWithArray
          poolVector3ArrayAppend
          poolVector3ArrayAppendArray
          poolVector3ArrayInsert
          poolVector3ArrayInvert
          poolVector3ArrayPushBack
          poolVector3ArrayRemove
          poolVector3ArrayResize
          poolVector3ArrayRead
          poolVector3ArrayWrite
          poolVector3ArraySet
          poolVector3ArrayGet
          poolVector3ArraySize
          poolVector3ArrayDestroy

          # PoolColorArray API
          poolColorArrayNew
          poolColorArrayNewCopy
          poolColorArrayNewWithArray
          poolColorArrayAppend
          poolColorArrayAppendArray
          poolColorArrayInsert
          poolColorArrayInvert
          poolColorArrayPushBack
          poolColorArrayRemove
          poolColorArrayResize
          poolColorArrayRead
          poolColorArrayWrite
          poolColorArraySet
          poolColorArrayGet
          poolColorArraySize
          poolColorArrayDestroy

          # Array API
          arrayNew
          arrayNewCopy
          arrayNewPoolColorArray
          arrayNewPoolVector3Array
          arrayNewPoolVector2Array
          arrayNewPoolStringArray
          arrayNewPoolRealArray
          arrayNewPoolIntArray
          arrayNewPoolByteArray
          arraySet
          arrayGet
          arrayOperatorIndex
          arrayAppend
          arrayClear
          arrayCount
          arrayEmpty
          arrayErase
          arrayFront
          arrayBack
          arrayFind
          arrayFindLast
          arrayHas
          arrayHash
          arrayInsert
          arrayInvert
          arrayPopFront
          arrayPopBack
          arrayPushBack
          arrayPushFront
          arrayRemove
          arrayResize
          arrayRFind
          arraySize
          arraySort
          arraySortCustom
          arrayBSearch
          arrayBSearchCustom
          arrayDestroy

          # Pool Array Read/Write Access API

          poolByteArrayReadAccessCopy
          poolByteArrayReadAccessPtr
          poolByteArrayReadAccessOperatorAssign
          poolByteArrayReadAccessDestroy

          poolIntArrayReadAccessCopy
          poolIntArrayReadAccessPtr
          poolIntArrayReadAccessOperatorAssign
          poolIntArrayReadAccessDestroy

          poolRealArrayReadAccessCopy
          poolRealArrayReadAccessPtr
          poolRealArrayReadAccessOperatorAssign
          poolRealArrayReadAccessDestroy

          poolStringArrayReadAccessCopy
          poolStringArrayReadAccessPtr
          poolStringArrayReadAccessOperatorAssign
          poolStringArrayReadAccessDestroy

          poolVector2ArrayReadAccessCopy
          poolVector2ArrayReadAccessPtr
          poolVector2ArrayReadAccessOperatorAssign
          poolVector2ArrayReadAccessDestroy

          poolVector3ArrayReadAccessCopy
          poolVector3ArrayReadAccessPtr
          poolVector3ArrayReadAccessOperatorAssign
          poolVector3ArrayReadAccessDestroy

          poolColorArrayReadAccessCopy
          poolColorArrayReadAccessPtr
          poolColorArrayReadAccessOperatorAssign
          poolColorArrayReadAccessDestroy

          poolByteArrayWriteAccessCopy
          poolByteArrayWriteAccessPtr
          poolByteArrayWriteAccessOperatorAssign
          poolByteArrayWriteAccessDestroy

          poolIntArrayWriteAccessCopy
          poolIntArrayWriteAccessPtr
          poolIntArrayWriteAccessOperatorAssign
          poolIntArrayWriteAccessDestroy

          poolRealArrayWriteAccessCopy
          poolRealArrayWriteAccessPtr
          poolRealArrayWriteAccessOperatorAssign
          poolRealArrayWriteAccessDestroy

          poolStringArrayWriteAccessCopy
          poolStringArrayWriteAccessPtr
          poolStringArrayWriteAccessOperatorAssign
          poolStringArrayWriteAccessDestroy

          poolVector2ArrayWriteAccessCopy
          poolVector2ArrayWriteAccessPtr
          poolVector2ArrayWriteAccessOperatorAssign
          poolVector2ArrayWriteAccessDestroy

          poolVector3ArrayWriteAccessCopy
          poolVector3ArrayWriteAccessPtr
          poolVector3ArrayWriteAccessOperatorAssign
          poolVector3ArrayWriteAccessDestroy

          poolColorArrayWriteAccessCopy
          poolColorArrayWriteAccessPtr
          poolColorArrayWriteAccessOperatorAssign
          poolColorArrayWriteAccessDestroy

          # Dictionary API
          dictionaryNew
          dictionaryNewCopy
          dictionaryDestroy
          dictionarySize
          dictionaryEmpty
          dictionaryClear
          dictionaryHas
          dictionaryHasAll
          dictionaryErase
          dictionaryHash
          dictionaryKeys
          dictionaryValues
          dictionaryGet
          dictionarySet
          dictionaryOperatorIndex
          dictionaryNext
          dictionaryOperatorEqual
          dictionaryToJson

          # NodePath API
          nodePathNew
          nodePathNewCopy
          nodePathDestroy
          nodePathAsString
          nodePathIsAbsolute
          nodePathGetNameCount
          nodePathGetName
          nodePathGetSubnameCount
          nodePathGetSubname
          nodePathGetConcatenatedSubnames
          nodePathIsEmpty
          nodePathOperatorEqual

          # Plane API
          planeNewWithReals
          planeNewWithVectors
          planeNewWithNormal
          planeAsString
          planeNormalized
          planeCenter
          planeGetAnyPoint
          planeIsPointOver
          planeDistanceTo
          planeHasPoint
          planeProject
          planeIntersect3
          planeIntersectsRay
          planeIntersectsSegment
          planeOperatorNeg
          planeOperatorEqual
          planeSetNormal
          planeGetNormal
          planeGetD
          planeSetD

          # Rect2 API
          rect2NewWithPositionAndSize
          rect2New
          rect2AsString
          rect2GetArea
          rect2Intersects
          rect2Encloses
          rect2HasNoArea
          rect2Clip
          rect2Merge
          rect2HasPoint
          rect2Grow
          rect2Expand
          rect2OperatorEqual
          rect2GetPosition
          rect2GetSize
          rect2SetPosition
          rect2SetSize

          # AABB API
          aabbNew
          aabbGetPosition
          aabbSetPosition
          aabbGetSize
          aabbSetSize
          aabbAsString
          aabbGetArea
          aabbHasNoArea
          aabbHasNoSurface
          aabbIntersects
          aabbEncloses
          aabbMerge
          aabbIntersection
          aabbIntersectsPlane
          aabbIntersectsSegment
          aabbHasPoint
          aabbGetSupport
          aabbGetLongestAxis
          aabbGetLongestAxisIndex
          aabbGetLongestAxisSize
          aabbGetShortestAxis
          aabbGetShortestAxisIndex
          aabbGetShortestAxisSize
          aabbExpand
          aabbGrow
          aabbGetEndpoint
          aabbOperatorEqual

          # RID API
          ridNew
          ridGetID
          ridNewWithResource
          ridOperatorEqual
          ridOperatorLess

          # Transform API
          transformNewWithAxisOrigin
          transformNew
          transformGetBasis
          transformSetBasis
          transformGetOrigin
          transformSetOrigin
          transformAsString
          transformInverse
          transformAffineInverse
          transformOrthonormalized
          transformRotated
          transformScaled
          transformTranslated
          transformLookingAt
          transformXformPlane
          transformXformInvPlane
          transformNewIdentity
          transformOperatorEqual
          transformOperatorMultiply
          transformXformVector3
          transformXformInvVector3
          transformXformAABB
          transformXformInvAABB

          # Transform2D API
          transform2DNew
          transform2DNewAxisOrigin
          transform2DAsString
          transform2DInverse
          transform2DAffineInverse
          transform2DGetRotation
          transform2DGetOrigin
          transform2DGetScale
          transform2DOrthonormalized
          transform2DRotated
          transform2DScaled
          transform2DTranslated
          transform2DXformVector2
          transform2DXformInvVector2
          transform2DBasisXformVector2
          transform2DBasisXformInvVector2
          transform2DInterpolateWith
          transform2DOperatorEqual
          transform2DOperatorMultiply
          transform2DNewIdentity
          transform2DXformRect2
          transform2DXformInvRect2

          # Variant API
          variantGetType
          variantNewCopy
          variantNewNil
          variantNewBool
          variantNewUInt
          variantNewInt
          variantNewReal
          variantNewString
          variantNewVector2
          variantNewRect2
          variantNewVector3
          variantNewTransform2D

          variantNewPlane
          variantNewQuat
          variantNewAABB
          variantNewBasis
          variantNewTransform
          variantNewColor
          variantNewNodePath
          variantNewRID
          variantNewObject
          variantNewDictionary
          variantNewArray
          variantNewPoolByteArray
          variantNewPoolIntArray
          variantNewPoolRealArray
          variantNewPoolStringArray
          variantNewPoolVector2Array
          variantNewPoolVector3Array
          variantNewPoolColorArray
          variantAsBool
          variantAsUInt
          variantAsInt
          variantAsReal
          variantAsString
          variantAsVector2
          variantAsRect2
          variantAsVector3
          variantAsTransform2D
          variantAsPlane
          variantAsQuat
          variantAsAABB
          variantAsBasis
          variantAsTransform
          variantAsColor
          variantAsNodePath
          variantAsRID
          variantAsObject
          variantAsDictionary
          variantAsArray
          variantAsPoolByteArray
          variantAsPoolIntArray
          variantAsPoolRealArray
          variantAsPoolStringArray
          variantAsPoolVector2Array
          variantAsPoolVector3Array
          variantAsPoolColorArray
          variantCall
          variantHasMethod
          variantOperatorEqual
          variantOperatorLess
          variantHashCompare
          variantBooleanize
          variantDestroy

          # String API
          charStringLength
          charStringGetData
          charStringDestroy

          stringNew
          stringNewCopy
          stringWideStr
          stringOperatorEqual
          stringOperatorLess
          stringOperatorPlus
          stringLength
          stringDestroy
          stringUtf8
          stringCharsToUtf8
          stringCharsToUtf8WithLen

          # Misc API
          objectDestroy
          globalGetSingleton
          methodBindGetMethod
          methodBindPtrCall
          methodBindCall
          getClassConstructor

          alloc
          realloc
          free

          printError
          printWarning
          print

        foundCoreApi = true
        for i in 0.cuint..<coreApi.numExtensions:
          setGDNativeAPIInternal(coreApi.extensions[][i.int], initOptions,
                                 foundCoreApi, foundNativeScriptApi)
    of GDNativeExtNativeScript:
      let nativeScriptApi = cast[ptr GDNativeNativeScriptAPI1](apiStruct)
      if nativeScriptApi[].version.major == 1 and
         nativeScriptApi[].version.minor == 0:
        assign(gdNativeApi, nativeScriptApi[]):
          nativeScriptRegisterClass
          nativeScriptRegisterToolClass
          nativeScriptRegisterMethod
          nativeScriptRegisterProperty
          nativeScriptRegisterSignal
          nativeScriptGetUserdata
        foundNativeScriptApi = true

    of GDNativeExtPluginScript, GDNativeExtNativeARVR:
      # Not used
      discard

  if not header.next.isNil and header != header.next:
    setGDNativeAPIInternal(header.next, initOptions,
                           foundCoreApi, foundNativeScriptApi)

proc setGDNativeAPI*(apiStruct: pointer, initOptions: ptr GDNativeInitOptions) =
  var foundCoreApi: bool
  var foundNativeScriptApi: bool

  setGDNativeAPIInternal(apiStruct, initOptions,
                         foundCoreApi, foundNativeScriptApi)

  if not foundCoreApi:
    let want = GDNativeAPIVersion(major: 1, minor: 0)
    initOptions[].reportVersionMismatch(
      initOptions[].gdNativeLibrary, cstring"Core", want,
      GDNativeAPIVersion(major: 0, minor: 0))

  if not foundNativeScriptApi:
    let want = GDNativeAPIVersion(major: 1, minor: 0)
    initOptions[].reportVersionMismatch(
      initOptions[].gdNativeLibrary, cstring"NativeScript",
      want, GDNativeAPIVersion(major: 0, minor: 0))
