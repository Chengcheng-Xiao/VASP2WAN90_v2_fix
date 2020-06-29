# Iron – Spin-orbit-coupled bands and Fermi-surface contours
A simple example using the interface.
See Wannier90's `example17` for more details.

## Run
1. Generate PBE `POTCAR` file.
2. Run VASP in `1-scf` to get `WAVECAR` and `CHGCAR` files.
3. Run VASP in `2-band` to get bandstructure. Inspect which bands do we want to wannierize.
4. Copy `WAVECAR` and `CHGCAR` to `3-wannier_gen` and VASP  to get `.mmn`, `.amn`, `.spn` file.
5. Run wannier90.x in `3-wannier_gen` to get `wannier90.chk` file.
6. Run postw90.x in `3-wannier_gen` to get plottable bandstructure with spin expectations.

## More ideas
- Inspect spin decomposed bandstructure, do you see the SOC-induced avoided band crossing?
- Change spin quantization axis, then rerun `wannier90.x`. Check the shape of the 1st Wannier function.
- Change k-points density and/or total number of bands, do you see any difference in the final plot? Can you make sense of it?
