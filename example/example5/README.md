# Iron – Orbital magnetization

A simple example using the interface.
See Wannier90's `example19` for more details.

## Run
__NOTE__: `ISYM=-1` is recommended for SOC calculations.
1. Generate PBE `POTCAR` file. [PAW_PBE Fe]
2. Run VASP in `1-scf` to get `WAVECAR` and `CHGCAR` files.
3. Copy `WAVECAR` and `CHGCAR` to `2-wannier_gen` and run VASP to get `.mmn`, `.amn` file.
4. To generate `.uHu` file, add the following to your `INCAR` and re-run VASP:
```
LWRITE_UHU = .TRUE.
```
5. Run wannier90.x in `2-wannier_gen`.
6. Un-comment the following in `wannier90.win` in `2-wannier_gen`:
```
fermi_energy = 5.4021
berry = true
berry_task = morb
berry_kmesh = 25 25 25
```

After running postw90, compare the value of the orbital magnetization reported in Fe.wpout with the spin magnetization in OUTCAR. Set `iprint = 2` to report the decomposition of Morb into the terms J0, J1, and J2 defined in [Ref](https://journals.aps.org/prb/pdf/10.1103/PhysRevB.85.014435).

7. Comment out what we uncommented in step 6, then, uncomment the following in `wannier90.win` in `2-wannier_gen`:
```
fermi_energy = 5.4021
kpath = false
kpath_task = bands+morb
kpath_num_points=500
begin kpoint_path
G 0.0000 0.0000 0.0000   H 0.500 -0.5000 -0.5000
H 0.500 -0.5000 -0.5000  P 0.7500 0.2500 -0.2500
end kpoint_path
```

After running postw90.x, issue
```
myshell> python Fe-bands+morb_z.py
```

Compare with Fig. 2 of [Ref](https://journals.aps.org/prb/pdf/10.1103/PhysRevB.85.014435), bearing in mind the factor of −1/2 difference in the definition of Morb(k) (see Ch. 11 in the User Guide).

<img src="https://raw.githubusercontent.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/dev/example/example5/pic/wannier90-morb_z.png" width="50%" height="50%">


8. Comment out what we uncommented in step 7, then, uncomment the following in `wannier90.win` in `2-wannier_gen`:
```
kslice = true
kslice_task = morb+fermi_lines
kslice_2dkmesh = 50 50
kslice_corner = 0.0  0.0  0.0
kslice_b1 =     0.5 -0.5 -0.5
kslice_b2 =     0.5  0.5  0.5
```

After executing postw90.x, to plot:
```
myshell> python wannier90-kslice-curv_z+fermi_lines.py
```
Morb(k) is much more evenly distributed in k-space than the Berry curvature (see Example 4).
As a result, the integrated orbital magnetization converges more rapidly with the BZ sampling.

<img src="https://raw.githubusercontent.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/dev/example/example5/pic/wannier90-kslice-morb_z.png" width="50%" height="50%">
