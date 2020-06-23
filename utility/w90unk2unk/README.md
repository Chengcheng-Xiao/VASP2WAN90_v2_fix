# w90unk2unk

Transcode the unformatted `UNK` file to formatted one.

Can be used to transfer binary files between machines.

## Compile
```
gfortran -o w90unk2unk w90unk2unk.f90
```

## Usage
By default, this only works with `UNKxxxxx.NC` file.
if you want to change this behavior, simply change all `NC` inside the source code to `1` or `2` and recompile.
