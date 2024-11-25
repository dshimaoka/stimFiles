#
#	v2luts1grat1tex.x
#
#		sine grating + textured mask
#

foo periodic	18

#

0	dur		"Stimulus duration (s *10)"		20	1-600 1+
1	x		"Center, x (deg*10)"			0	-200-200 1+
2	y		"Center, y (deg*10)"			0	-200-200 1+
1	tf1		"Grating Temporal Frequency (Hz *10)"	40	1-400 1+
2	sf100_1		"Grating Spatial Frequency (cpd *10)"	10	1-200 1+
3	ph1		"Grating Phase (deg)"			0	0-360 1+
4	c1		"Grating Contrast (%)"			50	0-50 1+
5	ori1		"Grating Orientation (deg)"		90	0-360 1+
8	idiam1		"Grating Inner Diameter (deg*10)"	0	0-400 1+
9	odiam1		"Grating Outer Diameter (deg*10)"	40	0-400 1+
10	texsiz		"Texture Texel Size (deg*10)"		5	1-64 1+
11	tf2		"Texture Temporal Frequency (Hz*10)"	130	0-400 1+
12	idiam2		"Texture Inner Diameter (deg*10)"	40	0-400 1+
13	odiam2		"Texture Outer Diameter (deg*10)"	80	0-400 1+
14	moment		"Texture Order of Moment"		1	1-6 1+
15	magni		"Texture Modulation Depth (%)"		0	-100-100 1+
16	seed		"Texture Spatial seed"			1	1-9999 1+
17	sqwv		"Texture Waveform (0:sine,1:sqwv)"	0	0-1 1+


	

