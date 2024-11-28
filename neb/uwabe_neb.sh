#!/bin/bash
#PJM -L "rscunit=ito-a"
#PJM -L "rscgrp=ito-a-oc170147"
#PJM -L "vnode=4"
#PJM -L "vnode-core=36"
#PJM -L "elapse=168:00:00"
#PJM --no-stging
#PJM -S
#PJM -j

LANG=C
module load intel
cd $PJM_O_WORKDIR
export I_MPI_HYDRA_BOOTSTRAP_EXEC=pjrsh
export I_MPI_HYDRA_HOST_FILE=$PJM_O_NODEINF
export I_MPI_DEVICE=rdma
export I_MPI_PERHOST=36

limit stacksize    unlimited
mpirun -n 144 ~/vasp.5.4.1.mkl3/bin/vasp_std >& log
