# Example
A simple example of using the interface.

## Run
1. Generate PBE `POTCAR` file.
2. Run VASP in `1-scf` to get `WAVECAR` and `CHGCAR` files.
3. Run VASP in `2-band` to get bandstructure. Inspect which band do we want to wannierize.
4. Run VASP in `3-wannier_gen` to get `UNK`, `.mmn`, `.amn`, `.spn` file.
5. Run wannier90.x in `3-wannier_gen` to get wannier90_00001.xsf plot.
6. Run postw90.x in `3-wannier_gen` to get plottable bandstructure with spin expectations.

## Post run
- Inspect the shape of the 1st wannier function. Does it look like `pz` orbital on the first Bi atom?
- Change `wannier_plot_spinor_mode` to `up` or `down`, rerun `wannier90.x`, can you spot the difference?
- Change spin quantization axis, then rerun `wannier90.x`. Check the shape of the 1st Wannier function.

- Change `LUNK_FMTED` to `.TRUE.` and rerun step 4. Can you plot the periodical part of the Bloch function?
