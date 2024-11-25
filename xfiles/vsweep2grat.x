#
#	vsweep2grat.x
#
#		a temporal frequency sweep
#		2002-7 Valerio Mante

foo nonperiodic	21

#

0	tadapt		"Duration of adapt stimulus (s *10)"	5	1-100 1+
1	tsweep		"Duration of sweep (s *10)"		10	1-600 1+
2	twait		"Duration after sweep (s *10)"		5	1-100 1+
3	idiam		"Inner diameter (deg*10)"		30	1-500 1+
4	odiam		"Outer diameter (deg*10)"		60	1-500 1+
5	x		"Center, x (deg *10)"			0	-200-200 1+
6	y		"Center, y (deg *10)"			0	-200-200 1+
7	tfminc		"Min center tf (Hz *10)"		5	1-400 1+
8	tfmins		"Min surround tf (Hz *10)"		5	0-400 1+
9	tfmaxc		"Max center tf (Hz *10)"		20	1-400 1+
10	tfmaxs		"Max surround tf (Hz *10)"		20	0-400 1+
11	orictr		"Orientation center (deg)"		90	0-360 1+
12	orisrd		"Orientation surround (deg)"		90	0-360 1+
13	sf100c		"Spatial frequency center (cpd *100)"	100	0-2000 1+
14	sf100s		"Spatial frequency surround (cpd *100)"	100	0-2000 1+
15	phctr		"Spatial phase center (deg*10)"		0	0-360 1+
16	phsrd		"Spatial phase surround (deg*10)"	0	0-360 1+
17	lctr		"Mean luminance center (%)"		70	0-100 1+
18	lsrd		"Mean luminance surround (%)"		70	0-100 1+
19	cctr		"Contrast center (%)"			30	0-100 1+
20	csrd		"Contrast surround (%)"			30	0-100 1+


	

