#
#	vringlogadTS.x
#
#		for ringach experiments with adaptation
#		improved from vringlog
#

foo nonperiodic	19

#

0	dur		"Stimulus duration (s *10)"		20	1-1800 1+
1	c		"Contrast (%)"				50	0-100 1+
2	x		"Center, x (deg *10)"			0	-2000-2000 1+
3	y		"Center, y (deg *10)"			0	-2000-2000 1+
4	diam		"Diameter (deg *10)"			20	1-1500 1+
5	nori		"Number of orientations"		4	1-30 1+
6	orimin		"Smallest orientation (deg)"		0	0-360 1+
7	orimax		"Largest orientation (deg)"		0	0-360 1+
8 	nsf		"Number of spatial frequencies"		1	1-20 1+
9	sfmin		"Minimum spatial frequency (cpd *100)"	50	1-2000 1+
10	sfmax		"Maximum spatial frequency (cpd *100)"	50	1-2000 1+
11	sflog		"Flag for logaritmic or linear spacing"	0	0-1 1+
12	nphase		"Number of spatial phases"		1	1-32 1+
13	seed		"Seed for random number generator"	1	0-32767 1+
14	nfr		"Number of interpolated frames"		1	1-200 1+
15	aori		"Adaptor orientation (deg)"		0	0-360 1+
16	asf		"Adaptor spatial frequency (cpd *100)"	50	1-2000 1+
17	ac		"Adaptor contrast (%)"			50	0-100 1+
18	aprob		"Adaptor probability (%)"		50	0-100 1+

