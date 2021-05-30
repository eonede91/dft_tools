program exciting_bands
 !  ----------------------------------------------------------#
 !                     Jacques R. Eone                        #
 !                 Elk/Exciting band generator                #
 !                        May - 2021                          # 
 !  ----------------------------------------------------------#
integer                     :: nbands,nkpts
real*8,dimension(1000,100)  :: bands ! 1000 kpoints max and 100 bands max 
real*8,dimension(1000)      :: kbands
character(len=80)           :: nfile,flouput
character(len=3)            :: nb,nb1
character(len=11)           :: nk


! Parameters 
print "(a26)","Input File (ex : BAND.OUT)"
read(*,*) nfile
print "(a18)", "Number of bands : "
read(*,*) nbands
print "(a20)", "Number of kpoints : "
read(*,*) nkpts

print "(a21)","Ouput File : Bands.bd"
flouput="Bands.bd"


open(1,file=nfile,status="old")
open(2,file=flouput)
open(3,file="plot.gnuplot")

do i = 1,nbands
	do j=1,nkpts
		read(1,*) kbands(j),bands(j,i)
	enddo 
	read(1,*)
enddo 

do i=1,nkpts
	write(2,"(100(f8.5,2x))") kbands(i),bands(i,1:nbands)
enddo


write(nk,'(f11.5)') kbands(nkpts)
write(3,*) 'set xrange [0:'//nk//']'
write(3,*) 'plot "Bands.bd" u 1:2 w l   title "band 1", \'
do i=3,nbands
	write(nb,'(i2)') i
	write(nb1,'(i2)') i-1	
	write(3,*) '     "Bands.bd" u 1:'//nb//' w l   title "band '//nb1//'", \'
enddo




end program exciting_bands
