# Copyright 2017 Xored Software, Inc.

import core.godotbase, core.godotcore
import core / [strings, vector2, rect2, vector3, transform2d, plane, quat]
import core / [rect3, basis, transform, color, nodepath, rid]
import core / [dictionary, arrays, poolarray, variant]

import nim / [godotmacros, godotnim]

export godotbase, strings, vector2, rect2, vector3, transform2d, plane, quat,
       rect3, basis, transform, color, nodepath, rid, dictionary, arrays,
       poolarray, variant
export godotmacros, godotnim

# from godotcore
export print, printWarning, printError
