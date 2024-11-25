#
#	vlutgrat
#
#		for drifting/flickering sine gratings in circular windows
#

foo periodic	10

#

0	dur		"Stimulus duration (s *10)"	20	1-2400 1+
1	tf		"Temporal frequency (Hz *10)"	40	1-400 1+
2	sf100		"Spatial frequency (cpd *100)"	100	1-2000 1+
3	c		"Contrast (%)"			50	0-100 1+
4	ori		"Orientation (deg)"		90	0-360 1+
5	phase		"Spatial Phase (deg)"		0	0-360 1+
6	x		"Center, x (deg*10)"		0	-200-200 1+
7	y		"Center, y (deg*10)"		0	-200-200 1+
8	diam		"Diameter (deg*10)"		20	0-500 1+
9	flicker		"Flicker (1) or drift (0)"	0	0-1 1+

	
