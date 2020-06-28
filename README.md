# VASP2WAN90_v2_fix
Fixing the `VAPS2WANNIER90v2` interface.

## NEW ABILITIES!

- Calculate non-collinear Wannier functions ("the fix")
- New spinor projection method (specify spinor channel, quantization axis)
- Write non-collinear UNK file (`UNKxxxxx.NC`) for plotting purpose.
  - `LWRITE_UNK=.TRUE.` now works for both `std` and `ncl` version. (`gam` version not tested)
  - additionally, change the format of the `UNK` files by adding `LUNK_FMTED = .TRUE.` to your `INACR` file.
- Write `.spn` files with `LWRITE_SPN=.TRUE.` tag. (This only works in serial)
  - additionally, change the format of the `.spn` files by adding `LSPN_FMTED = .TRUE.` to your `INACR` file.
- Control which collinear spin channel to compute by setting `W90_SPIN`
  - Can use different projections for up/down channels separately. Only need to prepare `seed_name.up.win` and `seed_name.dn.win`.

## Compile

__THIS FIX DOES NOT WORK WITH VASP v6.1.0__

Put `mlwf.patch` file in the root directory of your VASP distro. and type:
```
$ patch -p0 < mlwf.patch
```
Then, compile the code with `-DVASP2WANNIER90v2` precompile flag alone with the wannier90 library `libwannier.a`
```
CPP_OPTIONS+=-DVASP2WANNIER90v2
LLIBS+=/path/to/your/wannier90_distro/libwannier.a
```

## Keywords
A list of useful keywords:

|      Tag       |                               meaning                                    | value                 |
|:--------------:|:------------------------------------------------------------------------:|:---------------------:|
|   LWANNIER90   |                  Do we want to use the interface?                        | TRUE/FALSE            |
|   LWRITE_UNK   |                     Do we want the `UNK` files?                          | TRUE/FALSE            |
|   LUNK_FMTED   |               should the `UNK` files be human-redable?                   | TRUE/FALSE            |
|   LWRITE_SPN   |         Do we want the `.spn` files? (can only run in serial)            | TRUE/FALSE            |
|   LSPN_FMTED   |               should the `.spn` files be human-redable?                  | TRUE/FALSE            |
|    W90_SPIN    |     Which collinear spin channel to compute?                             | 0->all, 1->up, 2->down|
| LWRITE_MMN_AMN | Do we want the `.mmn` and `.amm` files? (they will still be calculated)  | TRUE/FALSE            |

## Pro Tips
1. To Calculate `.spn`, you can set `LWRITE_SPN=.TRUE.` in their `INCAR`. Since this function can only be achieved in serial (or MPI with one process), be extra careful with how many cores you are using.

2. If you have a pre-converged calculation, simply set `ALGO=None` and `NELM=1` while read in the `WAVECAR` and the `CHGCAR` to initialize `VASP2WANNIER90` interface. This will probably save you some time.

3. Dont write the `unit_cell`, `atom`, `mp_grid`, `kpoints`, and `spinors` in your `.win` file. VASP will fill in these for you automatically.

4. For collinear spin calculation, prepare two `.win` files (`wannier90.up.win` and `wannier90.dn.win`) separately for spin-up (W90_SPIN=1) and spin-down calculation(W90_SPIN=2). If you want to compute them all together (`W90_SPIN=0`), both files need to be present! Also, don't forget to put `spin=down` in your `wannier90.dn.win` file if you want to plot the WFs.

## Original Symptoms
In VASP (version 5.4.4), the VASP2WANNIER90v2 compiler flag was added as a interface to the [WANNIER90](https://github.com/wannier-developers/wannier90) (version 2.X) program.
However, with spin-orbital coupling turned on, this interface cannot correctly calculate the number of projections needed.

The symptom is quite obvious, wrong number of projections are done in the projection routine, causing VASP to either freeze or crash.

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
In `WANNIER90 v1.2`, in the `parameters.F90` file, there is:
```
if(spinors) num_proj=num_wann/2
```
This means they treated the two spin channel the same way. Both channels will use the same projection functions.

However, in `WANNIER90 v2.1+`, changes were made in the `parameters.F90`, they added a spin counter `spn_counter`:

|          VALUE         |                MEANING                |
|:----------------------:|:-------------------------------------:|
|          1             |  only `spin_up` or only `spin_down`   |
|          2             |  both `spin_up` and `spin_down`       |

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

If the spin quantization axis is set, full spinor guiding functions will be constructed, the rotation of those spinor wavefunctions are done by dotting with the eigenvectors of the Pauli matrix. PAW projector coefficients' contribution to the overlap will also be calculated for said rotations.

## Notes

*1. VASP is a commercial package, so I cannot post its source code here. However, this fix is not a "black box", anyone with a legal copy of the VASP source code can easily see what I did.

*2. The correctness of this patch has been checked against the WANNIER90 (version 1.2) on several cases.

*3. Currently, the running wannier90 in library mode using `LWANNIER90_RUN` tag is not supported. Reading AMN file using `LREAD_AMN` tag is not supported.

*3. Any result obtained by this patch should be carefully checked by yourself. USE AT YOUR OWN RISK.

*4. For V1.2, the order of the spinor WFs are:

```
site 1 projection s  (spin_1)
site 1 projection px (spin_1)
site 1 projection py (spin_1)
...
site 1 projection s  (spin_2)
site 1 projection px (spin_2)
site 1 projection py (spin_2)
```
with this fix, they are:
```
site 1 projection s  (spin_1)
site 1 projection s  (spin_2)
site 1 projection px (spin_1)
site 1 projection px (spin_2)
site 1 projection py (spin_1)
site 1 projection py (spin_2)
```
same rule applied to the `_hr.dat` file.
