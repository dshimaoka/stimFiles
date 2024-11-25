#
#	v2luts1grat1tex.x
#
#		sine grating + textured mask
#

foo periodic	16

#

0	dur		"Stimulus duration (s *10)"		20	1-600 1+
1	x		"Center, x (deg*10)"			0	-200-200 1+
2	y		"Center, y (deg*10)"			0	-200-200 1+
1	tf1		"Grating Temporal Frequency (Hz *10)"	40	1-400 1+
2	sf100_1		"Grating Spatial Frequency (cpd *10)"	10	1-200 1+
3	ph1		"Grating Phase (deg)"			0	0-360 1+
4	c1		"Grating Contrast (%)"			50	0-100 1+
5	ori1		"Grating Orientation (deg)"		90	0-360 1+
8	idiam1		"Grating Inner Diameter (deg*10)"	0	0-400 1+
9	odiam1		"Grating Outer Diameter (deg*10)"	40	0-400 1+
10	tf2		"Noise Temporal Frequency (Hz*10)"	130	0-400 1+
11	idiam2		"Noise Inner Diameter (deg*10)"		40	0-400 1+
12	odiam2		"Noise Outer Diameter (deg*10)"		80	0-400 1+
13	alpha		"Noise Slope i.e. f^alpha (*10)"	0	-100-0 1+
14	magni		"Noise Modulation Depth (%)"		0	-100-100 1+
15	seed		"Noise Spatial seed"			1	1-9999 1+


	

