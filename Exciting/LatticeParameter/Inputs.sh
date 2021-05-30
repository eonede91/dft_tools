#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #            Simple Exciting Input Generator                 #
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
FC=excitingser # executable to run 

echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do
  echo "Latice Param. : " $x "nm"
  mkdir $elm$x
  
  
  echo "<input>" >input.xml
  echo "">>input.xml
  echo "    <title>"$elm"</title>">>input.xml 
  
  
  lp=$( echo "scale=3; $x/0.529177" | bc ) 
  
  # lattice vectors for FCC/BCC/HCP
  echo '    <structure speciespath="'$SpDIR'">'>>input.xml 
  if [ $pack  -eq   1  ]
  then
	  echo '	<crystal scale="'$lp'">'>>input.xml 
	  echo "		<basevect> 0.5     0.5    -0.5 </basevect>">>input.xml 
	  echo "		<basevect> 0.5    -0.5     0.5 </basevect>">>input.xml 
	  echo "		<basevect>-0.5     0.5     0.5 </basevect>">>input.xml 
	  echo "	</crystal>">>input.xml 
  elif [  $pack  -eq  2   ]
  then
	  echo '	<crystal scale="'$lp'">'>>input.xml 
	  echo "		<basevect>0.0   0.5   0.5</basevect>">>input.xml 
	  echo "		<basevect>0.5   0.0   0.5</basevect>">>input.xml 
	  echo "		<basevect>0.5   0.5   0.0</basevect>">>input.xml 
	  echo "	</crystal>">>input.xml 
  else
	  echo '	<crystal scale="'$lp'">'>>input.xml 
	  echo "		<basevect> 1.0   0.0      0.00</basevect>">>input.xml 
	  echo "		<basevect>-0.5   0.8666   0.50</basevect>">>input.xml 
	  echo "		<basevect> 0.0   0.0      1.62</basevect>">>input.xml 
	  echo "	</crystal>">>input.xml 
  fi
  

  # atomic positions 
  if [ $pack  -eq   1  ]
  then
          echo      '	<species speciesfile="'$elm'.xml" rmt="1.5">'>>input.xml 
          echo      '		<atom coord="0.00 0.00 0.00"/>'>>input.xml 
          echo      '	</species>'>>input.xml 
  
  elif [  $pack  -eq  2   ]
  then
          echo      '	<species speciesfile="'$elm'.xml" rmt="1.5">'>>input.xml 
          echo      '		<atom coord="0.00 0.00 0.00"/>'>>input.xml 
          echo      '	</species>'>>input.xml 
  else
          echo      '	<species speciesfile="'$elm'.xml" rmt="1.5">'>>input.xml 
          echo      '		<atom coord="0.00 0.00 0.00"/>'>>input.xml 
          echo      '		<atom coord="0.33 0.66 0.50"/>'>>input.xml 
          echo      '	</species>'>>input.xml   
  fi  
  
  echo "   </structure> ">>input.xml

  # exciting parameters 
  echo "     <groundstate ">>input.xml
  echo '       ngridk="8 8 8"'>>input.xml
  echo '        outputlevel="normal"'>>input.xml
  echo '        xctype="GGA_PBE"'>>input.xml
  echo '        swidth="0.01"'>>input.xml
  echo '        rgkmax="8.0"'>>input.xml
  echo '        nempty="10">'>>input.xml
  echo "     </groundstate>">>input.xml

  echo  "">>input.xml
  echo  " </input>">>input.xml


  
  mv input.xml  $elm$x/
  
  
  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo "excitingser " >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh
  
  chmod +x run.sh
  x=$( echo "$x + $st" | bc )
  
done


