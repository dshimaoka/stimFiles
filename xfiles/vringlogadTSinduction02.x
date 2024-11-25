#
#	vringlogadTS4.x
#
#		for ringach experiments with adaptation
#		improved from vringlog
#

foo nonperiodic	19

#

0	dur		"Stimulus duration (s *10)"		9	1-1800 1+
1	c		"Contrast (%)"				50	0-100 1+
2	x		"Center, x (deg *10)"			0	-2000-2000 1+
3	y		"Center, y (deg *10)"			0	-2000-2000 1+
4	diam		"Diameter (deg *10)"			20	1-1500 1+
5	nori		"Number of orientations"		4	1-30 1+
6	orimin		"Smallest orientation (deg)"		0	0-360 1+
7	orimax		"Largest orientation (deg)"		0	0-360 1+
8 	sf		"spatial frequency (cpd *100)"	        50	1-2000 1+
9	visOn		"frame start (s *10) even num"          0	0-2000 1+
10	visOff		"frame end   (s *10) even num"          5	0-2000 1+
11	nstim		"number of stim"                	1	0-1000 1+
12	nphase		"number of spatial phases"		1	0-32 1+
13	seed		"Seed for random number generator"	1	-1000-1000 1+
14	nfrSpare	"NOT USED...Number of interpolated frames"		1	1-200 1+
15	aori		"Adaptor orientation (deg)"		0	0-360 1+
16	asf		"Adaptor spatial frequency (cpd *100)"	50	1-2000 1+
17	ac		"Adaptor contrast (%)"			0	0-100 1+
18	aprob		"Adaptor probability (%)"		101	0-101 1+

