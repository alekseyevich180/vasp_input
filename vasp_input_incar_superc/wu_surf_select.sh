#!/bin/bash
#PJM -L "rscunit=ito-a"
#PJM -L "rscgrp=ito-a-oc170105"
#PJM -L "vnode=4"
#PJM -L "vnode-core=36"
#PJM -L "elapse=168:00:00"
#PJM --no-stging
#PJM -S
#PJM -j

for i in 

do
  
rename ./$i/* ./$i/POSCAR ./$i/* 

done 


LANG=C
module load vasp/5.4.4-cpu
cd $PJM_O_WORKDIR
export I_MPI_HYDRA_BOOTSTRAP_EXEC=pjrsh
export I_MPI_HYDRA_HOST_FILE=$PJM_O_NODEINF
export I_MPI_DEVICE=rdma
export I_MPI_PERHOST=36

for i in 
do

cp INCAR ./$i/INCAR

cp KPOINTS ./$i/

cp ./POTCAR ./$i/POTCAR

cp vdw_kernel.bindat ./$i/

cd ./$i/


mpirun -n 144 ~/vasp.5.4.4_vtst/bin/vasp_std >& log

vef.pl

cp log fe.dat OUTCAR  ../

cd ../

A=`tail -1 log`
echo $i $A >> check.txt

B=`awk 'END {print $3}' fe.dat`

C=`cat OUTCAR | grep Edisp | tail -1 | awk '{print $3}'`
echo $i $B  $C >> energy.txt

D=`tail -1 fe.dat`
echo $i $D >> energy_check.txt

rm log OUTCAR fe.dat

done


