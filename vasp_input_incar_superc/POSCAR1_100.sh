#!/bin/bash
#PBS -T necmpi
#PBS -q sxs
#PBS --venode 8
#PBS -l elapstim_req=240:00:00

LANG=C

export PATH=/uhome/a01576/syc/vasp_5.4.4_nec/bin:$PATH
export LD_LIBRARY_PATH=/uhome/a01576/syc/vasp_5.4.4_nec/lib:$LD_LIBRARY_PATH

cd $PBS_O_WORKDIR

for i in {1..20}
do

cp POSCAR_$i POSCAR
mpirun -np 128 /uhome/a01576/syc/vasp_5.4.4_nec/bin/vasp_std > log
vef.pl

cp log log_$i
cp OSZICAR OSZICAR_$i
cp OUTCAR OUTCAR_$i
cp CONTCAR CONTCAR_$i.vasp

A=`tail -1 log`
echo $i $A >> check.txt

B=`awk 'END {print $3}' fe.dat`
echo $i $B >> energy.txt

D=`tail -1 fe.dat`
echo $i $D >> energy_check.txt

done

sort -k2n energy.txt > energy_sorted.txt
