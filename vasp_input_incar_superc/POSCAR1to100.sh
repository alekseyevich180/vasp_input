#!/bin/bash
#PBS -T necmpi
#PBS -q sxs
#PBS --venode 4
#PBS -l elapstim_req=720:00:00

LANG=C

export PATH=/uhome/a01576/syc/vasp_6.4.1_nec/bin:$PATH
export LD_LIBRARY_PATH=/uhome/a01576/syc/vasp_6.4.1_nec/lib:$LD_LIBRARY_PATH

cd $PBS_O_WORKDIR

for i in {1..25}
do

cp POSCAR_$i POSCAR
mpirun -np 64 /uhome/a01576/syc/vasp_6.4.1_nec/bin/vasp_std > log
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
