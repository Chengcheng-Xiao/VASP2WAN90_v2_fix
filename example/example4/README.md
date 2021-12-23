# Iron - Berry curvature, anomalous Hall conductivity and optical conductivity

A simple example using the interface.
See Wannier90's `example18` for more details.

## Run
__NOTE__: `ISYM=-1` is recommended for SOC calculations.
1. Generate PBE `POTCAR` file. [PAW_PBE Fe]
2. Run VASP in `1-scf` to get `WAVECAR` and `CHGCAR` files.
3. Copy `WAVECAR` and `CHGCAR` to `2-wannier_gen` and run VASP to get `.mmn`, `.amn` file.
4. Run wannier90.x in `2-wannier_gen` to get `wannier90.chk` file.

5. Un-comment the following in `wannier90.win` in `2-wannier_gen`:
```
fermi_energy = 5.4020
kpath = true
kpath_task = bands+curv
kpath_bands_colour = none
kpath_num_points = 1000
begin kpoint_path
G 0.0000 0.0000 0.0000   H 0.500 -0.5000 -0.5000
H 0.500 -0.5000 -0.5000  P 0.7500 0.2500 -0.2500
P 0.7500 0.2500 -0.2500  N 0.5000 0.0000 -0.5000
N 0.5000 0.0000 -0.5000  G 0.0000 0.0000 0.000
G 0.0000 0.0000 0.000    H 0.5 0.5 0.5
H 0.5 0.5 0.5            N 0.5 0.0 0.0
N 0.5 0.0 0.0            G 0.0 0.0 0.0
G 0.0 0.0 0.0            P 0.75 0.25 -0.25
P 0.75 0.25 -0.25        N 0.5 0.0 0.0
end kpoint_path
```
Then, run postw90.x in `2-wannier_gen` to calculate the energy bands and the Berry curvature along high-symmetry lines in k-space.
After executing postw90.x, plot the Berry curvature component \Omega_z(\vec K) = \Omega_{xy}(\vec K) along the magnetization direction using the script generated at runtime,
```
myshell> python wannier90-bands+curv_z.py
```
and compare with Fig. 2 of [Ref](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.92.037204).

<img src="https://raw.githubusercontent.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/dev/example/example4/pic/wannier90-bands+curv_z.png" width="50%" height="50%">


6. Comment out what we uncommented in step 5, then, uncomment the following in `wannier90.win` in `2-wannier_gen`:
```
kslice = true
kslice_task = curv+fermi_lines
kslice_corner = 0.0 0.0 0.0
kslice_b1 = 0.5 -0.5 -0.5
kslice_b2 = 0.5 0.5 0.5
kslice_2dkmesh = 200 200
```
Then, re-run postw90.x in `2-wannier_gen` to get a slice of band structure in k-space combined with a heatmap plot of (minus) the Berry curvature.
After executing postw90.x, to plot:
```
myshell> python wannier90-kslice-curv_z+fermi_lines.py
```
and compare with Fig. 3 in [Ref](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.92.037204).

<img src="https://raw.githubusercontent.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/dev/example/example4/pic/wannier90-kslice-curv_z.png" width="50%" height="50%">

7. Comment out what we uncommented in step 6, then, uncomment the following in `wannier90.win` in `2-wannier_gen`:
```
fermi_energy = 5.4020
berry = true
berry_task = ahc
berry_kmesh = 25 25 25
berry_curv_adpt_kmesh = 5
berry_curv_adpt_kmesh_thresh = 100.0
```
Then re-run postw90.x in `2-wannier_gen` to get the intrinsic anomalous Hall conductivity (AHC).
Compare the calculated value to the converged value in [Ref](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.92.037204).

8. Comment out what we uncommented in step 7, then, uncomment the following in `wannier90.win` in `2-wannier_gen`:
```
berry = true
berry_task = kubo
kubo_freq_max = 7.0
berry_kmesh = 125 125 125
berry_curv_adpt_kmesh = 5
berry_curv_adpt_kmesh_thresh = 100.0
```
Then, re-run postw90.x in `2-wannier_gen` to get the frequency depended anomalous Hall conductivity.
After executing postw90.x, to plot the ac AHC in S/cm:
```
myshell> gnuplot
gnuplot> plot ‘wannier90-kubo_A_xy.dat’ u 1:2 w l
```
and compare with Fig. 5(lower panel) in [Ref](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.92.037204).

<img src="https://raw.githubusercontent.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/dev/example/example4/pic/Fe-kubo_A_xy.png" width="50%" height="50%">

To plot the MCD spectrum:
```
gnuplot> plot ‘Fe-kubo_A_xy.dat’ u 1:($1)*($3)*0.0137 w l
```

<img src="https://raw.githubusercontent.com/Chengcheng-Xiao/VASP2WAN90_v2_fix/dev/example/example4/pic/Fe-kubo_A_xy_MCD.png" width="50%" height="50%">
