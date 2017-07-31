Stub project to demonstrate usage of the godot-nim library.

Prerequisites:

1. Install [nake](https://github.com/fowlmouth/nake): `nimble install nake -n`.
2. Ensure `~/.nimble/bin` is in your PATH.
3. Set `GODOT_BIN` environment varible to point to Godot executable (requires Godot 3.0 changeset [d28e9c3](https://github.com/godotengine/godot/commit/d28e9c3c0813e729195357dbb9ccd337494bc6d7) or newer).
4. (Windows only) Set `GODOT_LIB` to point to Godot's .lib file. It should be in the `bin` folder after you build Godot.
5. Install godot-nim: `nimble install godot`

Run `nake build` in any directory within the project to compile for the current platform.
