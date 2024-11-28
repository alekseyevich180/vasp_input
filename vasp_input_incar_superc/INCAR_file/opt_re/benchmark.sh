#!/bin/bash
#PJM -L rscgrp=a-pj24001724
#PJM -L node=1
#PJM --mpi proc=120
#PJM -L elapse=24:00:00
#PJM -j

module load intel
module load impi
module load vasp

for i in 2 3 4 5 6 8 10 12 15 20 24 30 40 60 120
do

cat >INCAR <<!
# SGGA calc
# Basic setup:
 ISPIN = 2

# Electronic loop controls:
 ENCUT = 450
 ALGO = Normal    # 
 EDIFF = 1E-5
 NELM = 500
 ISMEAR = 0        
 SIGMA = 0.050000   # eV

# Mixer
# AMIX      = 0.2
# BMIX      = 0.00001
# AMIX_MAG  = 0.8
# BMIX_MAG  = 0.00001
# GGA+U
  LDAU      = .TRUE.
  LDAUTYPE  = 2
  LDAUL     = 3 -1 -1 -1
  LDAUU     = 7.00 0.00 0.00 0.00
  LDAUJ     = 0.70 0.00 0.00 0.00
  LDAUPRINT = 0
  LMAXMIX   = 6

# Relaxation control:
 IBRION = 2    # Conjugate gradients
 NSW = 0
 POTIM = 0.500000
 ISIF = 0     
 EDIFFG = -0.050000

# NEB 
# IMAGES = 4
# SPRING = -5
# LCLIMB = .TRUE.

# Parallelization
 NPAR = $i
 LREAL = AUTO
 NSIM = 1
 LPLANE = .TRUE.

# vdW correction
# IVDW = 12

# Properties:
 LAECHG = .FALSE.
 LCHARG = .FALSE.
 LWAVE = .FALSE.
 LELF = .FALSE.
 LVTOT = .FALSE.
 LVHAR = .FALSE.

# Dipole correction
# IDIPOL = 3
!

mpiexec ~/vasp_6.4.3_vtst_genkai_0725/bin/vasp_std >& log

cp OUTCAR OUTCAR_$i
cp OSZICAR OSZICAR_$i

vef.pl

A=`tail -1 log`
echo $i $A >> check.txt

B=`awk 'END {print $3}' fe.dat`
C=`cat OUTCAR | grep Edisp | tail -1 | awk '{print $3}'`
echo $i $B  $C >> energy.txt

D=`tail -1 fe.dat`
echo $i $D >> energy_check.txt

done

grep 'Elapsed time' OUTCAR_* | sort -k 5n > result.txt
