#
#	vis2grat2win.x
#
#	2 gratings in 2 windows. Windows can be disk or annuli centered on same spot.
#	CAREFUL NOT TO CHOOSE 100% CONTRAST WITH OVERLAPPING GRATINGS!!!
#	Temporal frquency of second patch can be a multiple of the first.
#

foo periodic	15

#

0	dur		"Stimulus duration (s *10)"		20	1-600 1+
1	tf		"Patch 1 Temporal frequency (Hz *10)"	20	1-400 1+
2	sf1		"Patch 1 Spatial frequency (cpd *10)"	10	1-200 1+
3	sf2		"Patch 2 Spatial frequency (cpd *10)"	10	1-200 1+
4	c1		"Patch 1 Contrast (%)"			50	0-100 1+
5	c2		"Patch 2 Contrast (%)"			50	0-100 1+
6	ori1		"Patch 1 Orientation (deg)"		90	0-360 1+
7	ori2		"Patch 2 Orientation (deg)"		 0	0-360 1+
8	x		"Center, x (deg *10)"		0	-200-200 1+
9	y		"Center, y (deg *10)"		0	-200-200 1+
10	idiam1		"Patch 1 Inner Diameter (deg *10)"	 0	0-400 1+
11	odiam1		"Patch 1 Outer Diameter (deg *10)"	20	0-400 1+
12	idiam2		"Patch 2 Inner Diameter (deg *10)"	25	0-400 1+
13	odiam2		"Patch 2 Outer Diameter (deg *10)"	50	0-400 1+
14	tfreqratio	"Temporal frequency ratio (integer)"	 2 	1-32 1+

