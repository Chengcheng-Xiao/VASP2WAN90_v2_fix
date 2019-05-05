# VASP2WAN90_v2_fix
An attempt to fix the broken VAPS2WANNIER90v2 interface.

## Symptoms
In VASP (version 5.4.4), the VASP2WANNIER90v2 compiler flag was added as a interface to the [WANNIER90](https://github.com/wannier-developers/wannier90) (version 2.X) program.
However, with spin-orbital coupling turned on, this interface cannot correctly calculate the number of projections needed.

The symptom is quite obvious, wrong number of projections are done in the projection routine, causing VASP to either frozen or crashes.

For example:

*Without spinor tag*

The projection block in .win file
```
begin projections
site1: s,p
end projections
```
VASP will do the following
```
site 1 projection s  (spin_1)
site 1 projection s  (spin_2)
site 1 projection px (spin_1)
site 1 projection px (spin_2)
site 1 projection py (spin_1)
site 1 projection py (spin_2)
...
...
site 1 projection s  (spin_1) [The program got stuck here, because the num_proj has already been reached]
site 1 projection s  (spin_2)
site 1 projection px (spin_1)
site 1 projection px (spin_2)
site 1 projection py (spin_1)
site 1 projection py (spin_2)
...
```

*with spinor projection*

The projection block in .win file

```
begin projections
site1: s
site1: pz(d)
end projections
```
VASP will do the following:
```
(VASP SPINORS=1)
site 1 projection s  (WAN spin_1)
site 1 projection s  (WAN spin_2)
site 1 projection pz (WAN spin_2)
...
...
(VASP SPINORS=2)
site 1 projection s  (WAN spin_1) [The program got stuck here, because the num_proj has already been reached]
site 1 projection s  (WAN spin_2)
site 1 projection pz (WAN spin_2)
...
```

## Why?
In WANNIER90 v1.2, in the `parameters.F90` file, there is:
```
if(spinors) num_proj=num_wann/2
```
This means they treated the two spin channel the same way. Both channels will use the same projection functions.

However, in `WANNIER90 v2.1+`, changes were made in the `parameters.F90`, they added a spin counter `spn_counter`:

|          VALUE         |                MEANING                |
|:----------------------:|:-------------------------------------:|
|          1             |  only `spin_up` or only `spin_down`   |
|          2             |  both `spin_up` and only `spin_down`  |

Each projection's spin channel were then determined by:
```
if (spinors) then
  if (spn_counter == 1) then
    if (proj_u_tmp) input_proj_s(counter) = 1
    if (proj_d_tmp) input_proj_s(counter) = -1
  else
    if (loop_s == 1) input_proj_s(counter) = 1
    if (loop_s == 2) input_proj_s(counter) = -1
  endif
  input_proj_s_qaxis(:, counter) = proj_s_qaxis_tmp
```
this means the spin channels are treated separately. If the wavefunctions are spinors, each projection's spin channels are labled by `proj_s` tag.

In the VASP2WANNIER90 interface, the projection scheme loops over the spin channels and projection sites by:
```
spinor: DO ISPINOR=1,WDES%NRSPINORS
sites : DO ICNTR=1,num_bands_tot
```
Within the loop, only `proj_l` `proj_m` `proj_radial` are used.

When compiled against the `WANNIER90 v2.0+` version, the spin channel information is already included in `proj_s`. If `proj_s` is ignored, the total number of iterations are corrupted.


## Fix
Utilize `proj_s` as the spin channel indicator, project corresponding Bloch states on to the orbital functions with correct spin channel.

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

*1. VASP is a commercial package, so I cannot post its source code here. However, this fix is not a "black box", anyone with a legal copy of the VASP source code can easily see what I did.

*2. The correctness of this patch has been checked against the WANNIER90 (version 1.2) on several cases.

*3. Currently `proj_s_qaxis` cannot be specified and all spinor projection will default to `[0,0,1]` axis.

*4. Any result obtained by this patch should be carefully checked by yourself. USE THIS AT YOUR OWN RISK.
