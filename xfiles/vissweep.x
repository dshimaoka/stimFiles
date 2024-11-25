#
#	vissweep.x
#
#		a temporal frequency sweep
#		2002-7 Valerio Mante

foo nonperiodic	21

#

0	tadapt		"Duration of adapt stimulus (s *10)"	5	1-100 1+
1	tsweep		"Duration of sweep (s *10)"		20	1-600 1+
2	twait		"Duration after sweep (s *10)"		5	1-100 1+
11	ori		"Orientation (deg)"			90	0-360 1+
5	x		"Center, x (deg *10)"			0	-200-200 1+
6	y		"Center, y (deg *10)"			0	-200-200 1+
13	sf100		"Spatial frequency (cpd *100)"		100	1-2000 1+
15	ph		"Spatial phase (deg*10)"		0	0-360 1+
7	tfmin		"Min temporal frequency (Hz *10)"	5	1-400 1+
9	tfmax		"Max temporal frequency (Hz *10)"	5	1-400 1+
17	lmean		"Mean luminance (%)"			70	0-100 1+
19	c		"Contrast (%)"				30	0-100 1+
3	idiam		"Inner diameter (deg*10)"		30	1-500 1+
4	odiam		"Outer diameter (deg*10)"		60	1-500 1+


	

