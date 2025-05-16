#
#	vmovie3sequentialFlickering.x
#
#	a sequence of 3 flickerings in 1 window
#

foo periodic	25

#

0	dur		"Stimulus duration (s *10)"		60	1-1200 1+
1	swT1		"Time of switch from 1 to 2 (s *10)"	20	1-1200 1+
2	swT2		"Time of switch from 2 to 3 (s *10)"	40	1-1200 1+
3 	dima		"Inner Diam or Size X (deg *10)"	30	0-2000 1+
4	dimb		"Outer Diam or Size Y (deg *10)"	100	1-2000 1+
5	x		"Center, x (deg *10)"			-50	-1500-1500 1+
6	y		"Center, y (deg *10)"			0	-800-800 1+
7	flick 		"Drift (0) or s-Flicker (1) or st-Flicker (2)"		1	0-2 1+
8	sqwv		"Sine (0) or Square (1)"		1	0-1 1+
9	shape 		"Annulus (0) or Rectangle (1)"		1	0-1 1+
10	tf1		"Patch 1: Temporal frequency (Hz *10)"	40	1-400 1+
11	tph1		"Patch 1: Temporal phase (deg)"		0	0-360 1+
12	sph1		"Patch 1: Spatial phase (deg)"		0	0-360 1+
13	c1		"Patch 1: Contrast (%)"			50	0-100 1+
14	ori1		"Patch 1: Orientation (deg)"		90	0-360 1+
15	tf2		"Patch 2: Temporal frequency (Hz *10)"	50	1-400 1+
16 	tph2		"Patch 2: Temporal phase (deg)"		0	0-360 1+
17	sph2		"Patch 2: Spatial phase (deg)"		0	0-360 1+
18	c2		"Patch 2: Contrast (%)"			50	0-100 1+
19	ori2		"Patch 2: Orientation (deg)"		0	0-360 1+
20	tf3		"Patch 3: Temporal frequency (Hz *10)"	50	1-400 1+
21	tph3		"Patch 3: Temporal phase (deg)"		0	0-360 1+
22	sph3		"Patch 3: Spatial phase (deg)"		0	0-360 1+
23	c3		"Patch 3: Contrast (%)"			50	0-100 1+
24	ori3		"Patch 3: Orientation (deg)"		45	0-360 1+
