#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #                 Simple Abinit Input Generator              #
 #                        May - 2021                          # 
 #  ----------------------------------------------------------#
# List of elements 
tabl=(H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I Xe Cs Ba La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg Ti Pb Bi Po At Rn)
strct=(bcc fcc hcp)
echo "Atomic number : "
read z
echo ""
echo "Packing : 1. BCC  2. FCC  3. HCP"
read pack
echo "Lattice Par. start (Ang)  : "
read a1
echo "Lattice Par. end (Ang)  : "
read a2
echo "Step : (Ang) "
read st



n=z-1
elm=${tabl[n]}
PotDIR=./Pseudo # Path of the pseudopotential file psp8 (required : editable)
FC=pw.x   # executable to run 

echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do
  echo "Latice Param. : " $x "Ang" 
  mkdir $elm$x
  # lattice parameter in Bohr
  lp=$( echo "scale=3; $x/0.529177" | bc ) 
# Abinit parameters (editable)
echo   " ndtset 2">input
echo   " nsppol2   1">>input
echo   " nstep    30">>input
echo   " ">>input
echo   " ">>input
echo   " toldfe  1.0d-4">>input
echo   " acell   3*"$lp>>input
echo   " ecut    700 eV">>input
echo   " ">>input
echo   " ">>input

# lattice vectors and atomic positions for FCC/BCC/HCP
if [ $pack  -eq   1  ]
then
  echo  " natom   1" >>input
  echo  " ntypat  1" >>input
  echo  " rprim    0.500   0.500  -0.500" >>input
  echo  "         -0.500   0.500   0.500" >>input
  echo  "          0.500  -0.500   0.500" >>input
  echo  " typat   1  " >>input
  echo  " xred    0.000  0.000  0.000" >>input
elif [  $pack  -eq  2   ]
then 
  echo  " natom   1" >>input
  echo  " ntypat  1" >>input
  echo  " rprim    0.500   0.500   0.000" >>input
  echo  "          0.000   0.500   0.500" >>input
  echo  "          0.500   0.000   0.500" >>input
  echo  " typat   1  " >>input
  echo  " xred    0.000  0.000  0.000" >>input
else
  echo  " natom   2" >>input
  echo  " ntypat  1" >>input
  echo  " rprim   1.000   0.000   0.000" >>input
  echo  "        -0.500   0.866   0.000" >>input
  echo  "         0.000   0.000   1.620" >>input
  echo  " typat   1 1 " >>input
  echo  " xred    0.000  0.000  0.000" >>input
  echo  "         0.333  0.666  0.555" >>input
fi 

# Abinit parameters (editable)
echo    " ">>input
echo    " ngkpt   11 11 11">>input
echo    " nshiftk 1">>input
echo    " shiftk  0.0 0.0 0.0" >>input
echo    " occopt  3" >>input
echo    " tsmear  0.01" >>input
echo    " ">>input
echo    " Chksymbreak  0" >>input
echo    " ixc     11" >>input
echo    " nband   20" >>input
echo    " znucl  "$z >>input

# input fime  
echo $elm".in" > $elm.files
echo $elm".out" >> $elm.files
echo $elm"_i"  >> $elm.files
echo $elm"_1o" >> $elm.files
echo $elm"_1"  >> $elm.files
echo $elm".psp8" >> $elm.files



   mv input $elm$x/$elm.in
   mv $elm.files ./$elm$x
   cp $PotDIR/$elm.psp8   ./$elm$x

  

  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo "abinit <"$elm".files > ab.out " >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh

  chmod +x run.sh
  x=$( echo "$x + $st" | bc )

done

#echo "cd ./"$elm"  ">>Runall.sh
#echo "./run.sh">>Runall.sh
#echo "cd ..">>Runall.sh


