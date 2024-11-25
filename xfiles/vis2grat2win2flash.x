#
#	vis2grat2win2flash.x
#
#	2 gratings in 2 windows. Windows can be disk or annuli centered on same spot.
#	CAREFUL NOT TO CHOOSE 100% CONTRAST WITH OVERLAPPING GRATINGS!!!

foo nonperiodic	19

#

0	dur1000		"Stimulus duration (ms)"		500	1-5000 1+
1	t1		"Patch 1 Onset time (ms)"		50	0-1000 1+
2	t2		"Patch 2 Onset time (ms)"		250	0-1000 1+
3	dur1		"Patch 1 Duration (ms)"			150	0-1000 1+
4	dur2		"Patch 2 Duration (ms)"			150	0-1000 1+
5	sf1_100		"Patch 1 Spatial frequency (cpd *100)"	100	1-2000 1+
6	sf2_100		"Patch 2 Spatial frequency (cpd *100)"	50	1-2000 1+
7	ph1		"Patch 1 Phase (deg)"			0	-360-360 1+
8	ph2		"Patch 2 Phase (deg)"			0	-360-360 1+
9	c1		"Patch 1 Contrast (%)"			50	0-100 1+
10	c2		"Patch 2 Contrast (%)"			50	0-100 1+
11	ori1		"Patch 1 Orientation (deg)"		90	0-360 1+
12	ori2		"Patch 2 Orientation (deg)"		 0	0-360 1+
13	x		"Center, x (deg *10)"			 0	-200-200 1+
14	y		"Center, y (deg *10)"			 0	-200-200 1+
15	idiam1		"Patch 1 Inner Diameter (deg *10)"	 0	0-400 1+
16	idiam2		"Patch 2 Inner Diameter (deg *10)"	25	0-400 1+
17	odiam1		"Patch 1 Outer Diameter (deg *10)"	20	0-400 1+
18	odiam2		"Patch 2 Outer Diameter (deg *10)"	50	0-400 1+


