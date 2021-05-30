#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #               Simple Vasp Input Generator                  #
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
PotDIR=???/PAW_PBE  #Absolute Path to the pseudopotential   (required : editable)
FC=vasp_std # executable to run

echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do
  echo "Latice Param. : " $x "nm"
  mkdir $elm$x
  cp  $PotDIR/$elm/POTCAR ./$elm$x/POTCAR
 


  # ==================INCAR======================
  if [ $pack  -eq   1  ]
  then
        echo "System = "$elm" bcc" >input
  elif [  $pack  -eq  2   ]
  then
        echo "System = "$elm" fcc">input
  else
        echo "System = "$elm" hcp">input
  fi 
  echo "PREC   = MEDIUM">>input 
  echo "ICHARG = 2" >>input
  echo "ENCUT  = 300" >>input
  echo "ISTART = 0" >>input
  echo "ISPIN  = 1" >>input
  mv input $elm$x/INCAR
  
  
   # ==================POSCAR===================
   echo $elm":" >posit
   echo $x >>posit
   if [ $pack  -eq   1  ]
   then
      echo "0.5  0.5  0.5"  >>posit
      echo "0.5 -0.5  0.5"  >>posit
      echo "0.5  0.5 -0.5"  >>posit
      echo "1" >>posit
      echo "cartesian" >>posit
      echo  "0.00  0.00   0.00" >>posit
   elif [  $pack  -eq  2   ]
   then
      echo "0.5 0.5 0.0"  >>posit
      echo "0.0 0.5 0.5"  >>posit
      echo "0.5 0.0 0.5"  >>posit
      echo "1" >>posit
      echo "cartesian" >>posit
      echo  "0.00  0.00   0.00" >>posit
   else
      echo " 1.00    0.000   0.00000" >>posit
      echo "-0.50    0.866   0.00000" >>posit
      echo " 0.00    0.000   1.62000" >>posit
      echo "2" >>posit
      echo "direct" >>posit
      echo  "0.000   0.000   0.000" >>posit
      echo  "0.333   0.666   0.500" >>posit
   fi

   mv posit $elm$x/POSCAR
   
   # ==================KPOINTS 
  
   echo "Automatic Mesh" >  kpt
   echo "  0"            >> kpt 
   echo "Monkhorst-pack" >> kpt
   echo "  8  8  8 "     >> kpt 

   mv kpt  $elm$x/KPOINTS
  
  
  
  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo "vasp_std > vasp.out " >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh
  
  chmod +x run.sh
  x=$( echo "$x + $st" | bc )
  
done


