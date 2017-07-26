Simple project just to demonstrate usage of the library.

Prerequisites:

1. Install [nake](https://github.com/fowlmouth/nake): `nimble install nake -n`.
2. Ensure `~/.nimble/bin` is in your PATH.
3. Set `GODOT_BIN` environment varible to point to Godot executable (currently requires Godot fork - see below).

Run `nake build` in this directory to compile for the current platform.

**NOTE:** Currently this only works with `kingdom` branch of Godot fork: https://github.com/endragor/godot. However, there are pending PRs to make this work with Godot mainline version.