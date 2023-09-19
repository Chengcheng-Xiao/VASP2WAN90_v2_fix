<table align="center"><tr><td align="center" width="9999">

# VASP2WAN90_v2_fix


<a href="https://github.com/Chengcheng-Xiao/VASP2WAN90_v2_fix" alt="Star">
<img src="https://img.shields.io/github/stars/Chengcheng-Xiao/VASP2WAN90_v2_fix?style=flat-square" /></a>

<a href="https://github.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/fork" alt="Fork">
<img src="https://img.shields.io/github/forks/Chengcheng-Xiao/VASP2WAN90_v2_fix?style=flat-square" /></a>

<a href="https://github.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/wiki" alt="Wiki">
<img src="https://img.shields.io/badge/-wiki-brightgreen?style=flat-square" /></a>

<a href="https://raw.githubusercontent.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/dev/vasp2wan90.bib" alt="Cite">
<img src="https://img.shields.io/badge/-cite-ff69b4?style=flat-square" /></a>

<a href="https://twitter.com/iconxicon" alt="Twitter">
<img src="https://img.shields.io/twitter/follow/iconxicon ?style=flat-square&logo=twitter" /></a>



This project provides a patch for the [VASP](https://www.vasp.at/) code, fixing the `VASP2WANNIER90v2` interface with additional abilities.
</td></tr></table>


<!-- ## Table of Contents

* [Abilities](#Abilities)
* [Installation](#Installation)
* [Usage](#Usage)
  * [Keywords](#Keywords)
* [Roadmap](#Roadmap)
* [Contributing](#Contributing) -->

## Abilities

- Calculate non-collinear Wannier functions.
- Support spinor projection method (specify spinor channel, quantization axis).
- New and improved UNK files:
  - Write non-collinear UNK files (`UNKxxxxx.NC`).
  - Choose the format of the `UNK` files.
  - Reduce the size of the `UNK` files.
- Write `.spn` files.
  - Choose the format of the `.spn` files
- Control which collinear spin channel to compute.
- Control whether to calculate/write `.mmn` and `.amn` files.

## Installation

> [!IMPORTANT]
> THIS FIX ONLY WORKS WITH VASP v5.4.4.pl2

For this patch to work, you have to __recompile VASP__.
If you are not familiar with VASP's compilation process, click [:link: HERE](https://www.vasp.at/wiki/index.php/Installing_VASP.5.X.X).
Also, you need a compiled `libwannier.a`.
If you don't know what it is, check out wannier90's user guide.

To apply the patch, put the `mlwf.patch` file in the __root__ directory (not under `src`) of your VASP distro and type:
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
|   LWRITE_SPN   | Do we want the `.spn` files? (__Serial only__)  | TRUE/FALSE            | FALSE            |
|   LSPN_FMTED   | Do we want the `.spn` files be human-readable?  | TRUE/FALSE            | FALSE            |

## How to cite
Citation of the code is not mandatory but would be appreciated. A reference to this website using this [BibTeX entry](./vasp2wan90.bib) will suffice.

## Contributing
Issues and pull-requests are welcome, feel free to ask anything [E-mail](iconxicon@me.com).
