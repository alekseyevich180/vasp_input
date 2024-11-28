#!/bin/sh
#SBATCH -J test
#SBATCH -p F1cpu
#SBATCH -N 1
#SBATCH -n 128
#SBATCH -c 1
#SBATCH -t 24:00:00
#SBATCH --exclusive

# Option to use dual rail
#export MPI_IB_RAILS=2


#MKL_DEBUG_CPU_TYPE=5
ulimit -s unlimited
module purge
module load oneapi_compiler/2023.0.0 oneapi_mkl/2023.0.0 openmpi/4.1.5-oneapi-2023.0.0-classic
export KMP_STACKSIZE=512m
export UCX_TLS='self,sm,ud'

#LANG=C

#cd $PBS_O_WORKDIR

for i in 1
do

rm POSCAR
cp $i.vasp POSCAR
add_fix.sh 0.15

# standard version
srun ~/vasp.5.4.4/bin/vasp_std > log 2>&1

# mpirun -np 128 /uhome/a01576/syc/vasp_5.4.4_nec/bin/vasp_std > log

vef.pl

cp CONTCAR CONTCAR_opt_$i.vasp
cp log log_opt_$i
cp OSZICAR OSZICAR_opt_$i
cp OUTCAR OUTCAR_opt_$i

A=`tail -1 log`
echo $i $A >> check.txt

B=`awk 'END {print $3}' fe.dat`
C=`cat OUTCAR | grep Edisp | tail -1 | awk '{print $3}'`
echo $i $B  $C >> energy.txt

D=`tail -1 fe.dat`
echo $i $D >> energy_check.txt

done

sort -k2n energy.txt > energy_sorted.txt


# standard version
#srun ~/vasp.5.4.4/bin/vasp_std > log 2>&1 

# gamma-point only
# srun /home/issp/vasp/vasp5/vasp.5.4.4.pl2/bin/vasp_gam > stdout.log 2>&1 

# noncollinear
# srun /home/issp/vasp/vasp5/vasp.5.4.4.pl2/bin/vasp_ncl > stdout.log 2>&1

