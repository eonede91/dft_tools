#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #                 Simple ELK Input Generator                 #
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
SpDIR=../species # Path of the species folder (required : editable)
FC=elk-lapw    # executable to run 

echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do
  echo "Latice Param. : " $x "Ang"
  mkdir $elm$x
  
  echo  "tasks" > elm.in
  echo  "   0  " >> elm.in
  echo  "" >> elm.in 
  echo  "" >> elm.in 

  echo  "xctype" >> elm.in
  echo  "   20  " >> elm.in
  echo  "" >> elm.in 
  echo  "" >> elm.in   
  

   # lattice vectors for FCC/BCC/HCP
  echo  "avec ">> elm.in 
  if [ $pack  -eq   1  ]
  then
    echo  "   0.5  0.5 -0.5" >> elm.in
    echo  "   0.5 -0.5  0.5" >> elm.in
    echo  "  -0.5  0.5  0.5" >> elm.in
  elif [  $pack  -eq  2   ]
  then
    echo  "   0.5  0.5  0.0">> elm.in
    echo  "   0.5  0.0  0.5">> elm.in
    echo  "   0.0  0.5  0.5">> elm.in
  else
    echo "   1.00000         0.00000000000000      0.00000">> elm.in
    echo "  -0.50000         0.86602540378444      0.00000">> elm.in
    echo "   0.00000         0.00000000000000      1.62000">> elm.in
  fi  
  

  echo "">> elm.in 
  echo "">> elm.in 
  # lattice parameter in Bohr
  lp=$( echo "scale=3; $x/0.529177" | bc )  
  echo  "scale" >> elm.in
  echo  "  "$lp"  " >> elm.in
  echo  "" >> elm.in 
  echo  "" >> elm.in 
  
  echo  "sppath" >> elm.in
  echo  "  '$SpDIR' " >> elm.in
  echo  "" >> elm.in 
  echo  "" >> elm.in    
 
  # atomic positions 
  echo  "atoms" >>  elm.in
  if [ $pack  -eq   1  ]  
  then
    echo "   1" >> elm.in 
    echo "   '"$elm".in'"  >> elm.in  
    echo "   1" >> elm.in 
    echo "   0.0  0.0  0.0    0.0  0.0  0.0" >> elm.in
  elif [  $pack  -eq  2   ]
  then
    echo "   1" >> elm.in 
    echo "   '"$elm".in'"  >> elm.in  
    echo "   1" >> elm.in 
    echo "   0.0  0.0  0.0    0.0  0.0  0.0" >> elm.in
  else
    echo "   2" >> elm.in 
    echo "   '"$elm".in'"  >> elm.in  
    echo "   1" >> elm.in 
    echo "   0.0  0.0  0.0    0.0  0.0  0.0" >> elm.in
    echo "   '"$elm".in'"  >> elm.in  
    echo "   1" >> elm.in 
    echo "   0.333  0.666   0.500   0.0  0.0  0.0" >> elm.in
  fi
  
  
  echo  "" >> elm.in 
  echo  "" >> elm.in 

  
  echo  "ngridk" >> elm.in
  echo  "   8   8   8  " >> elm.in
  echo  "" >> elm.in 
  echo  "" >> elm.in 

  
  mv elm.in   $elm$x/elk.in
  
  
  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo $FC   >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh
  
  chmod +x run.sh
  x=$( echo "$x + $st" | bc )
  
done


