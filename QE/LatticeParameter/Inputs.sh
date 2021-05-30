#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #        Simple Quantum Espresso  Input Generator            #
 #                        May - 2021                          # 
 #  ----------------------------------------------------------#
# List of elements 
tabl=(H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I Xe Cs Ba La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg Ti Pb Bi Po At Rn)
tablm=(1.00794 4.002602 6.941 9.012182 10.811 12.0107 14.0067 15.9994 18.9984 20.1797 22.9898 24.305 26.982 28.085 30.9738 32.065 35.453 39.948 39.098 40.078 44.956 47.867 50.9415 51.9961 54.938 55.845 58.933 58.693 63.546 65.38 69.723 72.64 74.921 78.96 79.904 83.798 85.4678 87.62 88.906 91.224 92.906 95.96 98 101.07 102.906 106.42 107.868 112.411 114.818 118.710 121.760 127.60 126.904 131.293 132.905 137.327 138.905 140.116 140.908 144.242 145 150.36 151.964 157.25 158.925 162.500 164.930 167.259 168.934 173.054 174.967 174.49 180.948 183.84 186.207 190.23 192.217 195.084 196.967 200.59)
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
PotDIR= ../Pseudo/ #Absolute Path to the pseudopotential PBE  (required : editable)
FC=pw.x # executable to run

echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do
  echo "Latice Param. : " $x "Ang"
  mkdir $elm$x


echo   "&control">input
echo   "  calculation='scf'">>input
echo   "  tstress=.true.">>input
echo   "  restart_mode='from_scratch'">>input
echo   "  pseudo_dir = './'">>input
echo   "/">>input
echo   " ">>input
# lattice parameter in Bohr
lp=$( echo "scale=3; $x/0.529177" | bc )


# lattice vectors for FCC/BCC/HCP
echo   "&system">>input
if [ $pack  -eq   1  ]
then
  echo  "   ibrav=3,  celldm(1) ="$lp"," >>input
  echo  "   nat=1, ntyp=1," >>input
elif [  $pack  -eq  2   ]
then 
  echo  "   ibrav=2,  celldm(1) ="$lp"," >>input
  echo  "   nat=1, ntyp=1," >>input
else
  echo  "   ibrav=4,  celldm(1) ="$lp",  celldm(3) = 1.62," >>input
  echo  "   nat=2, ntyp=1," >>input
fi 
echo    "   ecutwfc =100.0,"  >>input
echo    "   occupations='smearing', smearing='marzari-vanderbilt', degauss=0.01,"  >>input
echo    "   nspin = 1"  >>input
echo    "/"  >>input
echo    "&electrons"  >>input
echo    "  /"         >>input
echo    "ATOMIC_SPECIES" >>input
echo    "  "$elm"  "${tablm[n]}"  "$elm".pbe.UPF" >>input
echo    "ATOMIC_POSITIONS (crystal)">>input

# atomic positions 
if [ $pack  -eq   1  ]
then
    echo $elm"   0.00 0.00 0.00" >>input
elif [  $pack  -eq  2   ]
then
    echo $elm"   0.00 0.00 0.00">>input
else
    echo $elm"   0.00 0.00 0.00">>input
    echo $elm"   0.33 0.66 0.50">>input
fi
    echo   "" >>input
    echo   "">>input
    echo   "K_POINTS {automatic}">>input
    echo   "    11 11 11 1 1 1  ">>input


   mv input $elm$x/input.in
   cp $PotDIR/$elm.pbe.UPF   ./$elm$x

  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo "mpirun -n 2 pw.x <input.in > qe.out " >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh

  chmod +x run.sh
  x=$( echo "$x + $st" | bc )

done


