#!/bin/bash
#PJM -L "rscunit=ito-a"
#PJM -L "rscgrp=ito-a-oc170105"
#PJM -L "vnode=1"
#PJM -L "vnode-core=36"
#PJM -L "elapse=168:00:00"
#PJM --no-stging
#PJM -S
#PJM -j

LANG=C
module load vasp/5.4.4-cpu
cd $PJM_O_WORKDIR
export I_MPI_HYDRA_BOOTSTRAP_EXEC=pjrsh
export I_MPI_HYDRA_HOST_FILE=$PJM_O_NODEINF
export I_MPI_DEVICE=rdma
export I_MPI_PERHOST=36

limit stacksize    unlimited
mpirun -n 36 ~/vasp.5.4.4_vtst/bin/vasp_std >& log


