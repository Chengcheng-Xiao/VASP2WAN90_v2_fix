# w90unk2unk

Transcode the unformatted `UNK` file to formatted one.

Can be used to transfer binary files between machines.

## Compile
```
gfortran -o w90unk2unk w90unk2unk.f90
```

## Usage
for collinear spin/spin degenerate systems:
```
w90unk2unk 0 UNKxxxxx.1
```
will generate a new formatted file `UNKxxxxx.1.formatted`

for collinear spin/spin degenerate systems:
```
w90unk2unk 1 UNKxxxxx.NC
```
will generate a new formatted file `UNKxxxxx.NC.formatted`
