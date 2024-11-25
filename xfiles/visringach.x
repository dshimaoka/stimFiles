#
#	visringach.x
#
#		for ringach experiments with adaptation
#	(8 oris, 4 phases, one blank, one adaptor at 4 phases)
#

foo nonperiodic	9

#

0	dur		"Stimulus duration (s *10)"		20	1-600 1+
1	sf		"Spatial frequency (cpd *10)"		10	1-200 1+
2	c		"Contrast (%)"				50	0-100 1+
3	x		"Center, x (deg *10)"			0	-200-200 1+
4	y		"Center, y (deg *10)"			0	-200-200 1+
5	diam		"Diameter (deg *10)"			20	0-400 1+
6	seed		"Seed for random number generator"	1	1-32767 1+
7	aori		"Orientation of the adaptor (deg)"	90	0-360 1+
8 	aprob		"Probability of the adaptor (%)"	50	0-100 1+

