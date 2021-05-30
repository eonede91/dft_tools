program band
	character(100) :: fichier
	character(2)   :: num
	real*8,dimension(:,:),allocatable :: bands
	real*8,dimension(10) :: mx
	character(len=3) :: nb
	 
	print *, "Name of the file (.band) : "
	read(*,*) fichier
	open(1,file=fichier,status="old")
	open(2,file="band_siesta.out")
	open(3,file="plot_band")
	read(1,*)
	read(1,*)
	read(1,*)
	read(1,*) nband,n1,n2
	!print *, nband,n2
	allocate(bands(n2,nband))
	
	write(nb,'(i3)') nband
	print *, nb
	do i=1,n2
		read(1,*)  rrr,bands(i,1:nband)
		write(2,"(2X,"//nb//"(f8.4,2X) )") bands(i,1:nband)
		print "(2X,"//nb//"(f8.4,2X) )",   bands(i,1:nband)
		
	enddo 
	e_min=nint(minval(bands(:,:)))-5.
	e_max=nint(maxval(bands(:,:)))+5.	

	write(3,*) "set xrange [0:240]"
	write(3,*) "set yrange [",e_min,":",e_max,"]"
 	write(3,*) "set ylabel 'Energie (eV)'"
	write(3,*) "set arrow from  40,",e_min," to  40,",e_max," nohead"
	write(3,*) "set arrow from  80,",e_min," to  80,",e_max," nohead"
	write(3,*) "set arrow from  120,",e_min," to 120,",e_max," nohead"
	write(3,*) "set arrow from  160,",e_min," to  160,",e_max," nohead"
	write(3,*) "set arrow from  200,",e_min," to  200,",e_max," nohead"
	write(3,*) "set arrow from  240,",e_min," to  240,",e_max," nohead"
	write(3,*) "set xtics ('G' 0, 'X' 40,'W' 80,'L' 120,'G' 160, 'K' 200 ,'X' 240)" 	
	do i=1,nband
		if(i==1)then	
			write(3,*) 'plot "band_siesta.out" u 1 w l lc "blue" lw 2  notitle,\'
		else
			write(3,*) '     "band_siesta.out" u ',i,' w l lc "blue" lw 2  notitle,\'
		endif
	enddo	
		

end program band
