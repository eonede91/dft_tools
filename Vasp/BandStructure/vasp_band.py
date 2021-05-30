#!/usr/bin/env python
#  ----------------------------------------------------------#
#                     Jacques R. Eone                        #
#           Vasp band generator (from  vasprun.xml)          #
#                        May - 2021                          # 
#  ----------------------------------------------------------#
from xml.dom import minidom
xmldoc = minidom.parse('vasprun.xml')
eig = xmldoc.getElementsByTagName('eigenvalues')[0]
spin1 = eig.getElementsByTagName('set')


f = open("plot.gnuplot", "w+")
f.seek(0)
f1 = open("Bands.bd", "w+")
f1.seek(0)
nkpts=0
for root in spin1:
	comment = root.getAttribute('comment')
	comment = comment[0:6]
	if(comment == "kpoint"):	
		bands = root.getElementsByTagName('r')
		bandlist = ""
		nbands=0
		for band in bands: 
			bandlist = bandlist + str(format(float(band.firstChild.data[0:11]),'.4f'))+"     "
			nbands=nbands+1
		print(bandlist)
		f1.write(bandlist+"\n")
		nkpts=nkpts+1


f.write(' set xrange [0:'+str(nkpts)+']\n')
f.write(' plot "Bands.bd" u 1 w l   title "band 1", \\'+'\n')
for i in range(nbands-1):
	f.write('      "Bands.bd" u '+str(i+2)+' w l   title "band '+str(i+2)+'", \\'+'\n')

f.close()
			
