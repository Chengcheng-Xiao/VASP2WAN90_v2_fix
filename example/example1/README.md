# Bi_example
A simple example using the interface.

- Bi[1 1 1] monolayer with spin-orbital coupling
- Bi[1 1 1] monolayer with collinear spin
- Bi[1 1 1] monolayer without spin polarization

## Run
### Bi_monolayer_soc
__NOTE__: `ISYM=-1` is recommended for SOC calculations.
1. Generate PBE `POTCAR` file.
2. Run VASP in `1-scf` to get `WAVECAR` and `CHGCAR` files.
3. Run VASP in `2-band` to get bandstructure. Inspect which band do we want to wannierize.
4. Copy `WAVECAR` and `CHGCAR` to `3-wannier_gen` and VASP  to get `UNK`, `.mmn`, `.amn`, `.spn` file.
5. Run wannier90.x in `3-wannier_gen` to get `wannier90_00001.xsf` plot.
6. Run postw90.x in `3-wannier_gen` to get plottable bandstructure colored with spin expectations.

#### More ideas
- Inspect the shape of the 1st wannier function. Does it look like `pz` orbital on the first Bi atom?
- Change `wannier_plot_spinor_mode` to `up` or `down`, re-run `wannier90.x`, can you spot the difference?
- Change spin quantization axis, then re-run `wannier90.x`. Check the shape of the 1st Wannier function.
- Change `LUNK_FMTED` to `.TRUE.` and re-run step 4. Can you plot the periodical part of the Bloch function?

### Bi_monolayer_spin
1. Generate PBE `POTCAR` file.
2. Run VASP in `1-scf` to get `WAVECAR` and `CHGCAR` files.
4. Copy `WAVECAR` and `CHGCAR` to `3-wannier_gen` and VASP  to get `UNK`, `.mmn`, `.amn`, `.spn` file.
5. Run wannier90.x in `2-wannier_gen` to get `wannier90.up_00001.xsf` plot.

#### More ideas
- Inspect the shape of the 1st Wannier function (up-spin channel). Does it look like `pz` orbital on the first Bi atom?
- Inspect the shape of the 1st Wannier function (dn-spin channel). Does it look like `s` orbital on the first Bi atom?
- Change `W90_SPIN` to `1` or `2`, re-run VASP, can you spot the difference in the stdout?

### Bi_monolayer_nospin
1. Generate PBE `POTCAR` file.
2. Run VASP in `1-scf` to get `WAVECAR` and `CHGCAR` files.
4. Copy `WAVECAR` and `CHGCAR` to `3-wannier_gen` and VASP  to get `UNK`, `.mmn`, `.amn`, `.spn` file.
5. Run wannier90.x in `2-wannier_gen` to get `wannier90_00001.xsf` plot.

#### More ideas
- Inspect the shape of the 1st wannier function. Does it look like `pz` orbital on the first Bi atom?
