program abibands
 !  ----------------------------------------------------------#
 !                     Jacques R. Eone                        #
 !                  Abinit band generator from EIG            #
 !                        May - 2021                          # 
 !  ----------------------------------------------------------#
integer                     :: nbands,nkpts
real*8,dimension(1000,100)  :: bands ! 1000 kpoints max and 100 bands max 
character(len=40)           :: nfile
character(len=3)            :: nb,nk


print "(a21)", "Input file (?_EIG) : "
read(*,*) nfile
print "(a18)", "Number of bands : "
read(*,*) nbands
print "(a20)", "Number of kpoints : "
read(*,*) nkpts

open(1,file=nfile,status="old")
open(2,file="Bands.bd")
open(3,file="plot.gnuplot")

read(1,*)  
read(1,*)
do i=1,nkpts	
	read(1,*) bands(i,1:nbands)
	if(i .lt. nkpts) read(1,*) 
enddo


write(2,*) "  "
do i=1,nkpts
	write(2,"(1X,100(f10.5,2x))") bands(i,1:nbands)
enddo

write(nk,'(i3)') nkpts
write(3,*) 'set xrange [0:'//nk//']'
write(3,*) 'plot "Bands.bd" u 1 w l   title "band 1", \'
do i=2,nbands
	write(nb,'(i2)') i
	write(3,*) '     "Bands.bd" u '//nb//' w l   title "band '//nb//'", \'
enddo

end program abibands 
