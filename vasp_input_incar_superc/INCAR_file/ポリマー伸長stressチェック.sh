#!/bin/bash
#PJM -L "rscunit=ito-a"
#PJM -L "rscgrp=ito-a-oc170105"
#PJM -L "vnode=4"
#PJM -L "vnode-core=36"
#PJM -L "elapse=168:00:00"
#PJM --no-stging
#PJM -S
#PJM -j

LANG=C
module load vasp/5.4.4-cpu_O2_precise
cd $PJM_O_WORKDIR
export I_MPI_HYDRA_BOOTSTRAP_EXEC=pjrsh
export I_MPI_HYDRA_HOST_FILE=$PJM_O_NODEINF
export I_MPI_DEVICE=rdma
export I_MPI_PERHOST=36

for POSN in `seq 1 1 100`  
do
mpirun -n 144 ~/vasp.5.4.4/bin/vasp_gam >& log 
vef.pl
cp CONTCAR CONTCAR_$POSN.vasp
cp log log_$POSN
cp OUTCAR OUTCAR_$POSN
A=`cat OUTCAR | grep 'in kB' | tail -1 | awk '{print $5}'`
echo $POSN $A  >> stress.txt
B=`awk 'END {print $3}' fe.dat`
echo $POSN $B >> energy.txt
rm POSCAR
awk 'NR <= 4 { print $0}' CONTCAR >> POSCAR
awk 'NR == 5 { print $1,$2,$3+0.05}' CONTCAR >> POSCAR
awk 'NR >= 6 { print $0}' CONTCAR >> POSCAR
done