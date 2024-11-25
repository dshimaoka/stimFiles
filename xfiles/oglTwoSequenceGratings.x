#
#	oglTwoSequenceGratings.x
#
#	2 gratings in 2 windows.
#

foo periodic	30

#

0	dur		"Stimulus duration (s *10)"		25	1-600 1+
1   StTE    "Start time of Early stim (s*10)"   5   1-600 1+ 
2   EnTE    "End time of Early stim (s*10)"   10   1-600 1+ 
3   StTL    "Start time of Late stim (s*10)"   15   1-600 1+ 
4   EnTL    "ENd time of Late stim (s*10)"   20   1-600 1+ 
5	duty 		"Duty cycle (%)"		100	1-100 1+
6	tf1		"Patch 1: Temporal frequency (Hz *10)"	40	1-400 1+
7	sf1		"Patch 1: Spatial frequency (cpd *100)"	10	1-200 1+
8 	tph1		"Patch 1: Temporal phase (deg)"		0	0-360 1+
9 	sph1		"Patch 1: Spatial phase (deg)"		0	0-360 1+
10	cE1		"Patch 1: Contrast of Early stim(%)"			50	0-100 1+
11	cL1		"Patch 1: Contrast of Late stim(%)"			50	0-100 1+
12	ori1		"Patch 1: Orientation (deg)"		90	0-360 1+
13 	dima1		"Patch 1: Diameter X (deg *10)"	30	0-1199 1+
14	dimb1		"Patch 1: Diameter Y (deg *10)"	100	1-1200 1+
15	x1		"Patch 1: Center, x (deg *10)"		0	-1000-1000 1+
16	y1		"Patch 1: Center, y (deg *10)"		0	-500-500 1+
17	shape1 		"Patch 1: Annulus (0) or Rectangle (1)"	0	0-1 1+
18	tf2		"Patch 2: Temporal frequency (Hz *10)"	50	1-400 1+
19	sf2		"Patch 2: Spatial frequency (cpd *100)"	50	1-200 1+
20 	tph2		"Patch 2: Temporal phase (deg)"		0	0-360 1+
21 	sph2		"Patch 2: Spatial phase (deg)"		0	0-360 1+
22	cE2		"Patch 2: Contrast of Early stim(%)"			50	0-100 1+
23	cL2		"Patch 2: Contrast of Late stim(%)"			50	0-100 1+
24	ori2		"Patch 2: Orientation (deg)"		90	0-360 1+
25 	dima2		"Patch 2: Diameter X (deg *10)"	50	0-1199 1+
26	dimb2		"Patch 2: Diameter Y (deg *10)"	100	1-1200 1+
27	x2		"Patch 2: Center, x (deg *10)"		-30	-1000-1000 1+
28	y2		"Patch 2: Center, y (deg *10)"		50	-500-500 1+
29	shape2 		"Patch 2: Annulus (0) or Rectangle (1)"	1	0-1 1+

