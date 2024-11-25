#
#	vrandpos.x
#
#	noise stimulus that varies spatial position of a bar
#

foo nonperiodic	13

#

0	dur		"Stimulus duration (s *10)"		20	1-1800 1+
1	c		"Contrast (%)"				50	0-100 1+
2	x		"Center, x (deg *10)"			0	-200-200 1+
3	y		"Center, y (deg *10)"			0	-200-200 1+
4	diam		"Diameter (deg *10)"			20	1-800 1+
5	barwdth		"Bar Width (deg *10)"			20	1-400 1+
6	sf		"Spatial Frequency (cpd * 100)"		50	1-2000 1+
7	nori		"Number of orientations"		20	1-30 1+
8	npos		"Number of positions"			8	1-30 1+
9	nphase		"Number of spatial phases"		2	1-20 1+
10	seed		"Random seed"				1	1-800 1+
11	nfr		"Number of frames"			1	1-30  1+
12	bprob		"Percent Blank Frames"			10	1-100  1+
