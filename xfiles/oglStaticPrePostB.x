#
#	oglStatic.x
#
#	2 gratings in 2 windows.
#

foo periodic	23

#

0	durpre		"PreStimulus duration (s *10)"		20	1-600 1+
1	durstim		"Stimulus duration (s *10)"		20	1-600 1+
2	durpost		"PostStimulus duration (s *10)"		20	1-600 1+
3	sf1		"Patch 1: Spatial frequency (cpd *100)"	10	1-200 1+
4 	sph1		"Patch 1: Spatial phase (deg)"		0	0-360 1+
5	c1		"Patch 1: Contrast (%)"			50	0-100 1+
6	ori1		"Patch 1: Orientation (deg)"		90	0-360 1+
7 	dima1		"Patch 1: Inner Diam or Size X (deg *10)"	30	0-1199 1+
8	dimb1		"Patch 1: Outer Diam or Size Y (deg *10)"	100	1-1200 1+
9	x1		"Patch 1: Center, x (deg *10)"		0	-1000-1000 1+
10	y1		"Patch 1: Center, y (deg *10)"		0	-500-500 1+
11	sqwv1		"Patch 1: Sine (0) or Square (1)"	0	0-1 1+
12	shape1 		"Patch 1: Annulus (0) or Rectangle (1)"	0	0-1 1+
13	sf2		"Patch 2: Spatial frequency (cpd *100)"	50	1-200 1+
14 	sph2		"Patch 2: Spatial phase (deg)"		0	0-360 1+
15	c2		"Patch 2: Contrast (%)"			50	0-100 1+
16	ori2		"Patch 2: Orientation (deg)"		90	0-360 1+
17 	dima2		"Patch 2: Inner Diam or Size X (deg *10)"	50	0-1199 1+
18	dimb2		"Patch 2: Outer Diam or Size Y (deg *10)"	100	1-1200 1+
19	x2		"Patch 2: Center, x (deg *10)"		-30	-1000-1000 1+
20	y2		"Patch 2: Center, y (deg *10)"		50	-500-500 1+
21	sqwv2		"Patch 2: Sine (0) or Square (1)"	1	0-1 1+
22	shape2 		"Patch 2: Annulus (0) or Rectangle (1)"	1	0-1 1+

