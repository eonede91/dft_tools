#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #               Vasp Total Energy Extractor                  #
 #                        May - 2021                          # 
 #  ----------------------------------------------------------#
LANG=en_US

tabl=(H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Pd Ag Cd In Sn Sb Te I Xe Cs Ba La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg Ti Pb Bi Po At Rn)
echo "Atomic number : "
read z
echo ""
echo "Lattice Par. start (Ang)  : "
read  a1
echo "Lattice Par. end (Ang)  : "
read  a2
echo "Step : (Ang) "
read st



n=z-1
elm=${tabl[n]}
for i in `seq $a1 $st $a2`;
do 
        cd  $elm$i
	cat vasp.out |grep E0|cut -c 27-43|xargs echo $i"   "  >> ../energie.out
        #cat *out |grep 'Total =' |cut -c 25-|xargs echo $i"  " >> ../energie.out
	cd ..
	
done





