#!/bin/sh
#SBATCH -J test
#SBATCH -p L1cpu
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -t 24:00:00
#SBATCH --exclusive

ulimit -s unlimited

ulimit -s unlimited
module purge
module load oneapi_compiler/2023.0.0 oneapi_mkl/2023.0.0 openmpi/4.1.5-oneapi-2023.0.0-classic
export KMP_STACKSIZE=512m
export UCX_TLS='self,sm,ud'
export PATH=$PATH:/home/k0710/k071001/bin/qe-7.3.1/bin

srun  ~/bin/qe-7.3.1/bin/pw.x -in pwscf.in