#
#	visringnsfnori.x
#
#		for ringach experiments without adaptation
#		(noris, nsf, a blank, 4 phases)
#

foo nonperiodic	11

#

0	dur		"Stimulus duration (s *10)"		20	1-1800 1+
1	c		"Contrast (%)"				50	0-100 1+
2	x		"Center, x (deg *10)"			0	-200-200 1+
3	y		"Center, y (deg *10)"			0	-200-200 1+
4	diam		"Diameter (deg *10)"			20	0-400 1+
5	seed		"Seed for random number generator"	1	1-32767 1+
6	nori		"Number of orientations"		4	1-30 1+
7 	nsf		"Number of spatial frequencies"		1	1-20 1+
8	sfmin		"Minimum spatial frequency (cpd *10)"	10	1-200 1+
9	sfmax		"Maximum spatial frequency (cpd *10)"	10	1-200 1+
10	nfr		"Number of interpolated frames"		1	1-10 1+

