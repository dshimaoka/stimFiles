#
#	v2lut2gratdel
#
#	for a pair of drifting/flickering sine gratings in annulus windows (with initial delay)
#

foo periodic	22

#

0	dur		"Stimulus duration (s *10)"		20	1-600 1+
1	tf1		"Patch 1 Temporal frequency (Hz *10)"	40	1-400 1+
2	sf100_1		"Patch 1 Spatial frequency (cpd *100)"	80	1-200 1+
3	ph1		"Patch 1 Phase (deg)"			0	0-360 1+
4	c1		"Patch 1 Contrast (%)"			50	0-50 1+
5	ori1		"Patch 1 Orientation (deg)"		90	0-360 1+
6	x1		"Patch 1 Center, x (deg*10)"		0	-200-200 1+
7	y1		"Patch 1 Center, y (deg*10)"		0	-200-200 1+
8	idiam1		"Patch 1 Inner Diameter (deg*10)"	0	0-300 1+
9	odiam1		"Patch 1 Outer Diameter (deg*10)"	40	0-400 1+
10	flicker1	"Patch 1: flicker (1) or drift (0)"	0	0-1 1+
11	tf2		"Patch 2 Temporal frequency (Hz *10)"	30	1-400 1+
12	sf100_2		"Patch 2 Spatial frequency (cpd *100)"	80	1-200 1+
13	ph2		"Patch 2 Phase (deg)"			0	0-360 1+
14	c2		"Patch 2 Contrast (%)"			50	0-50 1+
15	ori2		"Patch 2 Orientation (deg)"		45	0-360 1+
16	x2		"Patch 2 Center, x (deg*10)"		20	-200-200 1+
17	y2		"Patch 2 Center, y (deg*10)"		-20	-200-200 1+
18	idiam2		"Patch 2 Inner Diameter (deg*10)"	20	0-300 1+
19	odiam2		"Patch 2 Outer Diameter (deg*10)"	60	0-400 1+
20	flicker2	"Patch 2: flicker (1) or drift (0)"	0	0-1 1+
21	delay		"Delay before stimulus onset (s * 10)"  0 	0-599 1+

