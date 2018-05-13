# VASP2WAN90_v2_fix
An attempt to fix the broken VAPS2WANNIER90v2 interface.

## Why?
In VASP (version 5.4.4), the VASP2WANNIER90v2 subroutine was added as a interface to the [WANNIER90](https://github.com/wannier-developers/wannier90) (version 2.X) program.
However, with spin-orbital coupling turned on, this interface cannot correctly produce the number of projections.

The symptom is quite obvious, twice as much projection was made during the projection routine, and vasp either frozen or crashes.

For example:
The projection block in .win file
```
begin projections
site1: s,p
end projections
```
The reasoning in the v2 interface with spinor turned on is:
```
site 1 projection s  (spin_1)
site 1 projection s  (spin_1)
site 1 projection px (spin_1)
site 1 projection px (spin_1)
site 1 projection py (spin_1)
site 1 projection py (spin_1)
...
...
site 1 projection s  (spin_2) [The code usually frozen here, because the num_proj is already reached]
site 1 projection s  (spin_2)
site 1 projection px (spin_2)
site 1 projection px (spin_2)
site 1 projection py (spin_2)
site 1 projection py (spin_2)
...
```
(There are also some redundant proj_l=0 proj_m=0 which was ignored in the interface)

## Fix
Simply cycle over the second redundant projection with same spin.

## Useage
Put `mlwf.patch` file in the root directory of your VASP distro and type:
```
$ patch -p0 < mlwf.patch
```
Then, compile the code with `-DVASP2WANNIER90v2` precompile flag and a shared library `libwannier.a`
```
CPP_OPTIONS+=-DVASP2WANNIER90v2
LLIBS+=/path/to/your/wannier90_distro/libwannier.a
```

## Notes

*1. Because VASP is a commercial package, no source code can be leaked.

*2. The correctness of this patch has been checked against the WANNIER90 (version 1.2) on several cases.

*2. This is just a trial fix, I have not (yet) get a clear picture the original intension of this interface. Any result obtained by this fix should be carefully checked by yourself.

