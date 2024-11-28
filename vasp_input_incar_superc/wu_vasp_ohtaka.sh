#!/bin/sh
#SBATCH -J test
#SBATCH -p L1cpu
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



srun ~/vasp.5.4.1/bin/vasp_gam > log 2>&1 




