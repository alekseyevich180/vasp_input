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
module load vasp/5.4.4-cpu
cd $PJM_O_WORKDIR
export I_MPI_HYDRA_BOOTSTRAP_EXEC=pjrsh
export I_MPI_HYDRA_HOST_FILE=$PJM_O_NODEINF
export I_MPI_DEVICE=rdma
export I_MPI_PERHOST=36

for i in 1O 2O OH OOH 
do

cp INCAR_opt ./$i/INCAR_opt

cp KPOINTS ./$i/

if [[ $i == *O ]]; then
cp ./POTCAR_Ir_O ./$i/POTCAR 
else
cp ./POTCAR_Ir_O_H ./$i/POTCAR
fi

cd ./$i/

mv INCAR_opt INCAR

add_fix.sh 0.18

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


for i in 1O 2O OH OOH 
do

cp INCAR_vib ./$i/INCAR_vib

cd ./$i/
mkdir vib

cp CONTCAR ./vib/POSCAR
cp POTCAR KPOINTS ./vib/
mv INCAR_vib ./vib/INCAR

cd ./vib/

add_fix.sh 0.58

mpirun -n 144 ~/vasp.5.4.4_vtst/bin/vasp_std >& log

grep cm OUTCAR > freq.log
echo -e "501\n298.15" | vaspkit > thermo.log

cp freq.log thermo.log ../../

cd ../../

echo $i >> freq_list.txt
cat freq.log >> freq_list.txt

A=`cat thermo.log | grep E_ZPE | awk '{print $0}'`
echo $i $A >> ZPE.txt

B=`cat thermo.log | grep 'Entropy contribution' | awk '{print $0}'`
echo $i $B >> TS.txt

rm freq.log thermo.log

done


