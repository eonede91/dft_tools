#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #               Simple Siesta  Input Generator               #
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
PotDIR=../Pseudo #Absolute Path to the pseudopotential psf  (required : editable)
FC=siesta  # executable to run

echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do
  echo "Latice Param. : " $x "nm"
  mkdir $elm$x
  cp  $PotDIR/$elm/*psf ./$elm$x/$elm.psf

  echo  "SystemName        " $elm " bulk" >elm.fdf
  echo  "SystemLabel       " $elm >>elm.fdf
  echo  "NumberOfSpecies   1" >>elm.fdf
  if [ $pack  -eq   1  ]
  then
        echo  "NumberOfAtoms     1" >>elm.fdf
  elif [  $pack  -eq  2   ]
  then
        echo  "NumberOfAtoms     1" >>elm.fdf
  else
        echo  "NumberOfAtoms     2" >>elm.fdf
  fi
  
  echo  "WriteMullikenPop  1" >>elm.fdf
  echo  " " >> elm.fdf
  echo  "%block ChemicalSpeciesLabel" >>elm.fdf
  echo  "  1  " $z  $elm  "  " >>elm.fdf
  echo  "%endblock ChemicalSpeciesLabel">>elm.fdf

# lattice vectors for FCC/BCC/HCP
  if [ $pack  -eq   1  ]
  then
        cat bcc.in >>elm.fdf
  elif [  $pack  -eq  2   ]
  then
        cat fcc.in >>elm.fdf
  else
        cat hcp.in >>elm.fdf
  fi


  echo  "LatticeConstant      " $x "Ang" >>elm.fdf

  
  mv elm.fdf  $elm$x/$elm.fdf
  
  
  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo $FC "<" $elm".fdf > siesta.out" >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh
  
  chmod +x run.sh
  x=$( echo "$x + $st" | bc )
  
done


