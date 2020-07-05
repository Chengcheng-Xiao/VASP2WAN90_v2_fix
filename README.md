# VASP2WAN90_v2_fix
This project provides a patch for the [VASP](https://www.vasp.at/) code, fixing the `VASP2WANNIER90v2` interface with additional abilities.

## Table of Contents

* [ABILITIES](#ABILITEIS)
* [Installation](#Installation)
* [Usage](#Usage)
  * [Keywords](#Keywords)
* [Roadmap](#Roadmap)
* [Contributing](#Contributing)

## ABILITIES

- Calculate non-collinear Wannier functions ("the fix")
- New spinor projection method (specify spinor channel, quantization axis)
- Write non-collinear UNK file (`UNKxxxxx.NC`).
  - Choose the format of the `UNK` files.
  - Reduce the size of the `UNK` files.
- Write `.spn` files.
  - Choose the format of the `.spn` files
- Control which collinear spin channel to compute.
- The ability to control wether to calculate and to write `MMN` and `AMN` files.

## Installation

__THIS FIX ONLY WORKS WITH VASP v5.4.4__

For this patch to work, you have to recompile VASP from scratch.

If you are not familiar with VASP's compilation process, click [here](https://www.vasp.at/wiki/index.php/Installing_VASP.5.X.X).

Also, you should have a preinstalled `libwannier.a`.
If you don't know what it is, check out wannier90's user guide.

To apply the patch, put the `mlwf.patch` file in the root directory of your VASP distro. and type:
```
$ patch -p0 < mlwf.patch
```
Then, compile the code with `-DVASP2WANNIER90v2` precompile flag alone with the wannier90 library `libwannier.a`
```
CPP_OPTIONS+=-DVASP2WANNIER90v2
LLIBS+=/path/to/your/wannier90_distro/libwannier.a
```

## Usage
The `VASP2WANNIER90` interface is fully incorporated in the VASP package, this means we don't need another executable to run it. The interface is enabled by specific keywords in the `INCAR` file.

For full documentation, see [wiki](https://github.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/wiki).

### Keywords
A list of useful keywords:

| Tag            | meaning                                         | value                 | default          |
|:--------------:|:-----------------------------------------------:|:---------------------:|:----------------:|
|   LWANNIER90   | Do we want to use the interface?                | TRUE/FALSE            | FALSE            |
|    W90_SPIN    | Which collinear spin channel to compute?        | 0->all,1->up,2->down  | 0->all           |
|    LCALC_MMN   | Do we want calculate `mmn` matrix?              | TRUE/FALSE            | TRUE             |
|    LCALC_AMN   | Do we want calculate `amn` matrix?              | TRUE/FALSE            | TRUE             |
|   LWRITE_MMN   | Do we want to write `.mmn` file?                | TRUE/FALSE            | TRUE             |
|   LWRITE_AMN   | Do we want to write `.mmn` file?                | TRUE/FALSE            | TRUE             |
|   LWRITE_EIG   | Do we want to write `.eig` file?                | TRUE/FALSE            | TRUE             |
|   LWRITE_UNK   | Do we want the `UNK` files?                     | TRUE/FALSE            | FALSE            |
|   LUNK_FMTED   | Do we want the `UNK` files be human-readable?   | TRUE/FALSE            | FALSE            |
|   LREDUCE_UNK  | Do we want the `UNK` files be reduced in size?  | TRUE/FALSE            | FALSE            |
|   LWRITE_SPN   | Do we want the `.spn` files? (Serial only)      | TRUE/FALSE            | FALSE            |
|   LSPN_FMTED   | Do we want the `.spn` files be human-readable?  | TRUE/FALSE            | FALSE            |


## Contributing
Issues and pull-requests are welcome, feel free to ask anything [E-mail](iconxicon@me.com).
