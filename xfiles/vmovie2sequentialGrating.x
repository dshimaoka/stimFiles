#
#	vmovie2sequentialGrating.x
#
#	2 gratings in 1 window. not LUT animation not interleaved
#

foo periodic	30

#

0	dur		"Stimulus duration (s *10)"		40	1-600 1+
1	swT		"Time stimulus switches (s *10)"	20	1-600 1+
2	tf1		"Patch 1: Temporal frequency (Hz *10)"	40	0-400 1+
3	sf1		"Patch 1: Spatial frequency (cpd *100)"	10	1-200 1+
4 	tph1		"Patch 1: Temporal phase (deg)"		0	0-360 1+
5 	sph1		"Patch 1: Spatial phase (deg)"		0	0-360 1+
6	c1		"Patch 1: Contrast (%)"			50	0-100 1+
7	ori1		"Patch 1: Orientation (deg)"		90	0-360 1+
8 	dima1		"Patch 1: Inner Diam or Size X (deg *10)"	30	0-2000 1+
9	dimb1		"Patch 1: Outer Diam or Size Y (deg *10)"	100	1-2000 1+
10	x1		"Patch 1: Center, x (deg *10)"		0	-1500-1500 1+
11	y1		"Patch 1: Center, y (deg *10)"		0	-500-500 1+
12	flick1 		"Patch 1: Drift (0) or Flicker (1)"	0	0-1 1+
13	sqwv1		"Patch 1: Sine (0) or Square (1)"	0	0-1 1+
14	duty1 		"Patch 1: Duty cycle (%)"		100	1-100 1+
15	shape1 		"Patch 1: Annulus (0) or Rectangle (1)"	0	0-1 1+
16	tf2		"Patch 2: Temporal frequency (Hz *10)"	50	1-400 1+
17	sf2		"Patch 2: Spatial frequency (cpd *100)"	50	1-200 1+
18 	tph2		"Patch 2: Temporal phase (deg)"		0	0-360 1+
19 	sph2		"Patch 2: Spatial phase (deg)"		0	0-360 1+
20	c2		"Patch 2: Contrast (%)"			50	0-100 1+
21	ori2		"Patch 2: Orientation (deg)"		90	0-360 1+
22 	dima2		"Patch 2: Inner Diam or Size X (deg *10)"	50	0-2000 1+
23	dimb2		"Patch 2: Outer Diam or Size Y (deg *10)"	100	1-2000 1+
24	x2		"Patch 2: Center, x (deg *10)"		-30	-1500-1500 1+
25	y2		"Patch 2: Center, y (deg *10)"		50	-500-500 1+
26	flick2 		"Patch 2: Drift (0) or Flicker (1)"	1	0-1 1+
27	sqwv2		"Patch 2: Sine (0) or Square (1)"	1	0-1 1+
28	duty2 		"Patch 2: Duty cycle (%)"		60 	1-100 1+
29	shape2 		"Patch 2: Annulus (0) or Rectangle (1)"	1	0-1 1+

