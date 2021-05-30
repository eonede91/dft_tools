#!/bin/bash
 #  ----------------------------------------------------------#
 #                     Jacques R. Eone                        #
 #               Simple OpenMx Input Generator                #
 #                        May - 2021                          # 
 #  ----------------------------------------------------------#
# List of elements 
tabl=(H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I Xe Cs Ba La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg Ti Pb Bi Po At Rn)
tablpao=(Sc7.0 Ti7.0 V6.0 Cr6.0 Mn6.0 Fe6.0S Co6.0S Ni6.0S Cu6.0S Zn6.0S Y8.0 Zr7.0 Nb7.0 Mo7.0 Tc7.0 Ru7.0 Rh7.0 Pd7.0 Ag7.0 Cd7.0 Lu8.0 Hf7.0 Ta7.0 W7.0 Re7.0 Os7.0 Ir7.0 Pt7.0 Au7.0)
tablvps=(Sc_PBE19 Ti_PBE19 V_PBE19 Cr_PBE19 Mn_PBE19 Fe_PBE19S Co_PBE19S Ni_PBE19S Cu_PBE19S Zn_PBE19S Y_PBE19 Zr_PBE19 Nb_PBE19 Mo_PBE19 Tc_PBE19 Ru_PBE19 Rh_PBE19 Pd_PBE19 Ag_PBE19 Cd_PBE19 Lu_PBE19 Hf_PBE19 Ta_PBE19 W_PBE19 Re_PBE19 Os_PBE19 Ir_PBE19 Pt_PBE19 Au_PBE19)
tablne=(11 12 13 14 15 14 15 16 11 12 11 12 13 14 15 14 15 16 17 12 11 12 13 12 15 14 15 16 17)
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
FC=openmx # executable to run

# getting the correct PAO and VPS 
if [ $z -ge 21 ] && [ $z -le 30 ]
then 
    id_p=z-21
elif [ $z -ge 39 ] && [ $z -le 48 ] 
then 
    id_p=z-21-8
else 
    id_p=z-21-18-12
fi

pao=${tablpao[id_p]}
vps=${tablvps[id_p]}
chg=${tablne[id_p]}

chg1=$( echo "scale=1; "$chg"/2" | bc )

#echo $pao" , "$vps


echo ""
echo "TODO : "  $a1  " ----> "  $a2
echo ""

echo "#!/bin/bash" > run.sh

x=$a1
while [ $(echo "$x <= $a2" |bc -l)  -eq 1 ]
do	
   echo "Latice Param. : " $x "Ang"
   mkdir $elm$x

   # Absolute path to DFT_DATA19 (required : editable)
   echo "DATA.PATH                        ???/DFT_DATA19" >input.in
   echo "System.CurrrentDirectory         ./    # default=./">>input.in
   echo "System.Name                    "$elm"_bulk">>input.in
   echo "level.of.stdout                   1    # default=1 (1-3)">>input.in
   echo "level.of.fileout                  1    # default=1 (0-2)">>input.in
   echo " ">>input.in
   echo " ">>input.in
   echo "Species.Number       1">>input.in
   echo "<Definition.of.Atomic.Species">>input.in
   echo "   "$elm"   "$pao"-s2p2d1   "$vps>>input.in
   echo "Definition.of.Atomic.Species>">>input.in
   echo " ">>input.in
   echo " ">>input.in
   if [ $pack  -eq   1  ]
   then
      hlp=$( echo "scale=4; $x/2" | bc )
      echo  "Atoms.Number         1">>input.in
      echo  "Atoms.SpeciesAndCoordinates.Unit   Ang # Ang|AU">>input.in
      echo  "<Atoms.SpeciesAndCoordinates">>input.in           
      echo  " 1  "$elm"  0.0000  0.0000  0.0000     "$chg1" "$chg1" ">>input.in
      echo  "Atoms.SpeciesAndCoordinates>">>input.in
      echo  "Atoms.UnitVectors.Unit             Ang # Ang|AU">>input.in
      echo  "<Atoms.UnitVectors">>input.in                     
      echo  "   "$hlp"   "$hlp"   "$hlp" ">>input.in
      echo  "   "$hlp"  -"$hlp"   "$hlp" ">>input.in
      echo  "   "$hlp"   "$hlp"  -"$hlp" ">>input.in
      echo  "Atoms.UnitVectors>">>input.in
   elif [  $pack  -eq  2   ]
   then 
      hlp=$( echo "scale=4; $x/2" | bc )
      echo  "Atoms.Number         1">>input.in
      echo  "Atoms.SpeciesAndCoordinates.Unit   Ang # Ang|AU">>input.in
      echo  "<Atoms.SpeciesAndCoordinates">>input.in           
      echo  " 1  "$elm"  0.0000  0.0000  0.0000     "$chg1" "$chg1" ">>input.in
      echo  "Atoms.SpeciesAndCoordinates>">>input.in
      echo  "Atoms.UnitVectors.Unit             Ang # Ang|AU">>input.in
      echo  "<Atoms.UnitVectors">>input.in                     
      echo  "   "$hlp"   "$hlp"   0.0000 ">>input.in
      echo  "   "$hlp"   0.0000   "$hlp" ">>input.in
      echo  "    0.0000  "$hlp"   "$hlp" ">>input.in
      echo  "Atoms.UnitVectors>">>input.in
  else
      hlp=$( echo "scale=4; $x/2" | bc )
      hlp1=$( echo "scale=4; $x*0.8660" | bc )
      hlp2=$( echo "scale=4; $x*1.6200" | bc )
      echo  "Atoms.Number         2">>input.in
      echo  "Atoms.SpeciesAndCoordinates.Unit   FRAC # Ang|AU">>input.in
      echo  "<Atoms.SpeciesAndCoordinates">>input.in           
      echo  " 1  "$elm"  0.0000  0.0000  0.0000     "$chg1" "$chg1" ">>input.in
      echo  " 2  "$elm"  0.3333  0.6666  0.5000     "$chg1" "$chg1" ">>input.in
      echo  "Atoms.SpeciesAndCoordinates>">>input.in
      echo  "Atoms.UnitVectors.Unit             Ang # Ang|AU">>input.in
      echo  "<Atoms.UnitVectors">>input.in                     
      echo  "   "$x"     0.0000   0.0000 ">>input.in
      echo  "  -"$hlp"  "$hlp1"   0.0000 ">>input.in
      echo  "   0.0000  0.0000   "$hlp2" ">>input.in
      echo  "Atoms.UnitVectors>">>input.in
  fi 
   echo " ">>input.in
   echo " ">>input.in
   
   echo "scf.XcType                 GGA-PBE     # LDA|LSDA-CA|LSDA-PW|GGA-PBE">>input.in
   echo "scf.SpinPolarization        Off         # On|Off|NC">>input.in
   echo "scf.ElectronicTemperature  300.0       # default=300 (K)">>input.in
   echo "scf.energycutoff           280         # default=150 (Ry)">>input.in
   echo "scf.Ngrid                 27 27 27   ">>input.in
   echo "scf.maxIter                 100        # default=40">>input.in
   echo "scf.EigenvalueSolver       band        # DC|GDC|Cluster|Band">>input.in
   echo "scf.Kgrid                 11 11 11     # means n1 x n2 x n3">>input.in
   echo "scf.ProExpn.VNA             off        # default=on ">>input.in
   echo "scf.Mixing.Type           rmm-diisk    # Simple|Rmm-Diis|Gr-Pulay|Kerker|Rmm-Diisk">>input.in
   echo "scf.Init.Mixing.Weight     0.10        # default=0.30 ">>input.in
   echo "scf.Min.Mixing.Weight      0.001       # default=0.001 ">>input.in
   echo "scf.Max.Mixing.Weight      0.300       # default=0.40 ">>input.in
   echo "scf.Mixing.History          10         # default=5">>input.in
   echo "scf.Mixing.StartPulay       5          # default=6">>input.in
   echo "scf.Mixing.EveryPulay       1          # default=5">>input.in
   echo "scf.criterion             1.0e-6       # default=1.0e-6 (Hartree) ">>input.in
   echo " ">>input.in
   echo " ">>input.in

 


   mv input.in ./$elm$x/$elm.dat

  # run file 
  echo "cd  ./"$elm$x >> run.sh
  echo 'echo "'$elm$x'"' >> run.sh
  echo "openmx "$elm".dat > openmx.out " >>run.sh 
  echo "cd .." >>run.sh
  echo " " >>run.sh

  chmod +x run.sh
  x=$( echo "$x + $st" | bc )

done

