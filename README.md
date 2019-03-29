# VASP2WAN90_v2_fix
An attempt to fix the broken VAPS2WANNIER90v2 interface.

## Why?
In VASP (version 5.4.4), the VASP2WANNIER90v2 compiler flag was added as a interface to the [WANNIER90](https://github.com/wannier-developers/wannier90) (version 2.X) program.
However, with spin-orbital coupling turned on, this interface cannot correctly calculate the number of projections needed.

The symptom is quite obvious, twice as much projection was made during the projection routine, causing vasp to either frozen or crashes.

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
(There are also some redundant proj_l=0 proj_m=0 which was ignored in the original code)

## Fix
Simply cycle over those second redundant projections.

## Useage
Put `mlwf.patch` file in the root directory of your VASP distro and type:
```
$ patch -p0 < mlwf.patch
```
Then, compile the code with `-DVASP2WANNIER90v2` precompile flag alone with the wannier90 library `libwannier.a`
```
CPP_OPTIONS+=-DVASP2WANNIER90v2
LLIBS+=/path/to/your/wannier90_distro/libwannier.a
```

## Notes

*1. VASP is a commercial package, so I cannot post any source code here. However, this fix is not a "black box", anyone with a legal copy of the VASP source code can easily see what I did.

*2. The correctness of this patch has been checked against the WANNIER90 (version 1.2) on several cases.

*2. Any result obtained by this patch should be carefully checked by yourself. USE THIS AT YOUR OWN RISK.

*3. VASP2WANNIER90v2 interface has included `proj_s_` and `proj_s_qaxis_` variables but has yet implemented corresponding projection routines. So spinor-projections will be ignored even if they are defined in the `wannier90.win` file.
