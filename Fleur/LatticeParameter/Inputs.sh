#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #               Simple Fleur Input Generator                 #
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
PotDIR=
FC=fleur   # executable to run

echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do
  echo "Latice Param. : " $x "nm"
  mkdir $elm$x



  if [ $pack  -eq   1  ]
  then
        echo $elm" bcc" >input
  elif [  $pack  -eq  2   ]
  then
        echo $elm" fcc">input
  else
        echo $elm" hcp">input
  fi 
  
  echo "&input  cartesian=F /">>input


  lp=$( echo "scale=3; $x/0.529177" | bc )


  # lattice vectors and atomic positions for FCC/BCC/HCP
  if [ $pack  -eq   1  ]
  then
	echo "       0.5000000000     0.5000000000       0.5000000000"  >>input
	echo "       0.5000000000    -0.5000000000       0.5000000000"  >>input
	echo "       0.5000000000     0.5000000000      -0.5000000000"  >>input
	echo "       "$lp >>input
	echo "       1.0000000000     1.0000000000       1.0000000000" >>input
	echo "        " >>input
	echo "       1" >>input
	echo "       "$z"  0.0000000000  0.0000000000  0.0000000000" >>input
  elif [  $pack  -eq  2   ]
  then
	echo "       0.0000000000     0.5000000000       0.5000000000"  >>input
	echo "       0.5000000000     0.0000000000       0.5000000000"  >>input
	echo "       0.5000000000     0.5000000000       0.0000000000"  >>input
	echo "       "$lp >>input
	echo "       1.0000000000     1.0000000000       1.0000000000" >>input
	echo "        " >>input
	echo "       1" >>input
	echo "       "$z"  0.0000000000  0.0000000000  0.0000000000" >>input
  else
	echo "       1.00000         0.00000000000000      0.00000" >>input
	echo "      -0.50000         0.86602540378444      0.00000" >>input
	echo "       0.00000         0.00000000000000      1.62000" >>input
	echo "       "$lp >>input
	echo "       1.00000         1.00000000000000      1.00000" >>input
	echo "        " >>input
	echo "       2" >>input
	echo "       "$z"  0.0000000000  0.0000000000  0.0000000000" >>input
	echo "       "$z"  0.3333333333  0.6666666666  0.5000000000" >>input
  fi

  echo "">>input
  echo "">>input
  echo "&comp jspins=1 /">>input  

  mv input $elm$x/input
  cd $elm$x
  inpgen -f input
  cd ..
  
  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo "fleur  > fleur.out " >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh
  
  chmod +x run.sh
  x=$( echo "$x + $st" | bc )
  
done


