=============================
Nim bindings for Godot Engine
=============================

:Author: Ruslan Mustakov
:Version: |godotnimversion|
:GitHub: `$GODOTNIM_GITHUB_URL <$GODOTNIM_GITHUB_URL>`_
:License: MIT

.. contents::

``godot-nim`` library allows to create games on
`Godot Engine <https://godotengine.org/>`_ with
`Nim programming language <https://nim-lang.org/>`_. Nim is a statically typed
language with an elegant Python-like syntax that compiles to native code.
It is garbage-collected, but its GC supports real-time mode which this library
makes use of. It means the GC will never run during game frames and will use
fixed amount of frame idle time to collect garbage. This leads to no stalls
and close to zero compromise on performance comparing to native languages with
manual memory management.

If you are not familiar with Nim yet, it is recommended to go through the
`official tutorial <https://nim-lang.org/docs/tut1.html>`_.

`VSCode <https://code.visualstudio.com/>`_ is the recommended editor for
working with Nim code. It is cross-platform and has the excellent
`nim plugin <https://marketplace.visualstudio.com/items?itemName=kosz78.nim>`_
that supports most of the features you would expect from an IDE.
It also has `godot-tools plugin <https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools>`_
which adds features for editing GDScript and Godot resource files.


Getting Started
===============

Getting Godot
--------------

The library requires Godot version 3.0, which you can get here:
https://godotengine.org/download

Installing Nim
-------------

The library requires Nim version 0.18.0 or newer, which you can get here:
https://nim-lang.org/install.html

Make sure you also have ``nimble`` (Nim's package manager) installed.

Creating Project
----------------

The fastest way to set up a Godot-Nim project is to use the existing stub:

.. code-block:: bash
   git clone --depth=1 https://github.com/pragmagic/godot-nim-stub.git myproject

(you can then delete the .git directory within to untie the project from the
stub repository)

The stub contains the necessary build configuration to compile your code for
desktop and mobile platforms, as well as a couple of very simple scenes to
help you get started. Consult the stub's `README
<https://github.com/pragmagic/godot-nim-stub>`_ for information about
compiling the project.


Adding Nim to Existing Project
------------------------------

If you would like to use Nim in an existing project:

1. Copy ``nakefile.nim`` file and ``src`` directory from the stub described
   in the previous section above your Godot project folder. Adjust paths in
   build scripts (``nakefile.nim``, ``src/stub.nimble``) according to your
   own project structure.

2. Copy ``nimlib.gdnlib`` to your Godot project folder. It is a
   GDNative library resource that contains paths to dynamic libraries
   compiled by Nim.

Next Steps
----------

Once you are familiarized with the build process (it's as simple as running
``nake build`` after you are set up), it is recommended to go through
`godotmacros <godotmacros.html>`_ and `godotnim <godotnim.html>`_ module
documentations. They describe special macros and procedures needed to define
or instantiate Godot objects. After you learned that, the rest is similar to
using any Nim library. These bindings do not limit any of Nim's capabilities,
and you can use any Nim types as fields or parameters of Godot objects and
their procedures (but, obviously, you may not be able to export some of them
to Godot editor or GDScript, unless you define your own converters).


Modules
=======

The binding library consists of three major modules:

* `godot <#modules-godot-module>`_ - Contains core types and macro definitions.
  You need to import this in any module that defines or makes use of Godot
  types.

* `godotinternal <#modules-godotinternal-module>`_ - Contains raw wrappers over
  few core types, such as ``GodotVariant``, ``GodotString``, ``GodotNodePath``,
  ``GodotDictionary``, pool arrays. These are used by ``godotapigen`` and macro
  implementations, and you don't have to use them at all in your code, unless
  you want to go into low-level details for some reason. Each of those types
  needs to be destructed manually with ``deinit`` procedure.

* `godotapigen <godotapigen.html>`_ - Wrapper generator based on data from
  Godot's ``ClassDB``. You only need to use it as a part of the build process.


godot Module
------------

Contains core types and macro definitions. You need to import this in any
module that defines or makes use of Godot types. The sumbodules below are
exported and you don't have to import any of them directly.

* `godotnim <godotnim.html>`_ Defines ``NimGodotObject`` and Varaint converters
  for standard Nim types.
* `godotmacros <godotmacros.html>`_ Defines ``gdobj`` macro for defining
  Godot objects.
* `variants <variants.html>`_ ``Variant`` type represents a "dynamic object"
  that many Godot procedures make use of.
* `arrays <arrays.html>`_ Defines ``Array`` of Variants.
* `basis <basis.html>`_ Defines 3D ``Basis``.
* `colors <colors.html>`_ Defines ARGB ``Color``.
* `dictionaries <dictionaries.html>`_ Defines ``Variant`` -> ``Variant``
  ``Dictionary``.
* `nodepaths <nodepaths.html>`_ Defines ``NodePath`` - a path to a ``Node``.
* `planes <planes.html>`_ Defines 3D ``Plane``.
* `poolarrays <poolarrays.html>`_ Defines pooled arrays: ``PoolByteArray``,
  ``PoolIntArray``, ``PoolRealArray``, ``PoolVector2Array``,
  ``PoolVector3Array``, ``PoolColorArray``, ``PoolStringArray``.
* `quats <quats.html>`_ Defines ``Quat`` (quaternion) describing object
  rotation in 3D space.
* `rect2 <rect2.html>`_ Defines ``Rect2`` - a 2D rectangle.
* `aabb <aabb.html>`_ Defines ``AABB`` - a 3D box.
* `rids <rids.html>`_ Defines ``RID`` - a resource identifier.
* `transform2d <transform2d.html>`_ Defines ``Transform2D``.
* `transforms <transforms.html>`_ Defines ``Transform``.
* `vector2 <vector2.html>`_ Defines ``Vector2``.
* `vector3 <vector3.html>`_ Defines ``Vector3``.
* `godotbase <godotbase.html>`_ Defines ``Error`` type and few common math
  procedures missing in Nim's standard library.


Godot API
---------

This is an auto-generated list of Godot API modules. It's built from Godot
changeset `$GODOTAPI_CHANGESET_HASH
<https://github.com/godotengine/godot/commit/$GODOTAPI_CHANGESET_HASH>`_.

$AUTO_GENERATED_GODOTAPI_LIST


godotinternal Module
--------------------

Contains low-level wrappers over Godot types that require manual memory
management. This module is used within ``godot-nim`` implementation and you
don't need to import it unless you know what you are doing.

* `godotdictionaries <godotdictionaries.html>`_
* `godotnodepaths <godotnodepaths.html>`_
* `godotpoolarrays <godotpoolarrays.html>`_
* `godotstrings <godotstrings.html>`_
* `godotvariants <godotvariants.html>`_
