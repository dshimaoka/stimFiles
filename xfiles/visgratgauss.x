#
#	visgratgauss.x
#
#		for gratings multiplied by Gaussians
#		2002-05 Matteo Carandini
#

foo periodic	11

#

0	dur		"Stimulus duration (s *10)"		10	1-600 1+
1	x		"Center, x (deg*10)"			0	-200-200 1+
2	y		"Center, y (deg*10)"			0	-200-200 1+
3	diam		"Diameter (deg*10)"			100	0-500 1+
4	tf		"Temporal frequency (Hz *10)"		40	1-400 1+
5	c		"Contrast (%)"				10	0-100 1+
6	sf100		"Spatial frequency (cpd *100)"		70	1-2000 1+
7	ph		"Phase (deg)"				45	0-360 1+
8	ori		"Orientation (deg)"			90	0-360 1+
9	gsigma		"Sigma of gaussian (deg*10)"		30	0-200 1+
10	gc		"Contrast of gaussian (%)"		-80	-100-100 1+

	

