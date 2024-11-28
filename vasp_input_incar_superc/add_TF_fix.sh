#!/bin/bash
cp POSCAR POSCAR_orig
rm POSCAR
awk 'NR <= 7 {print $0}' POSCAR_orig >> POSCAR
echo 'Selective dynamics' >> POSCAR
awk 'NR == 8 {print $0}' POSCAR_orig >> POSCAR
awk 'NR >= 9 {if($3 < 0.12){print "     " $1 "     " $2 "     " $3 "     F F F     "}else{print "     " $1 "     " $2 "     " $3 "     T T T     "}}' POSCAR_orig >> POSCAR
sed -i -e "s// /g" POSCAR
