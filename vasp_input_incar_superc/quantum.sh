
#!/bin/bash

#PJM -L "vnode=4"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-a"
#PJM -L "rscgrp=ito-a-oc170105"
#PJM -L "elapse=168:00:00"
#PJM --no-stging
#PJM -j

module load qe/6.7.0_intel2018.3

NUM_PROCS=16
export I_MPI_PERHOST=4
export OMP_NUM_THREADS=9

export I_MPI_FABRICS=shm:ofa
export I_MPI_PIN_DOMAIN=omp
export I_MPI_PIN_CELL=core
export KMP_STACKSIZE=8m
export KMP_AFFINITY=compact
export I_MPI_HYDRA_BOOTSTRAP=rsh
export I_MPI_HYDRA_BOOTSTRAP_EXEC=/bin/pjrsh
export I_MPI_HYDRA_HOST_FILE=${PJM_O_NODEINF}

mpiexec.hydra -n ${NUM_PROCS} pw.x -inp pwscf.in > pwscf.out