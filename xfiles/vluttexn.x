#
#	vluttexn.x
#
#		texture scrambles using lut animation (can specify number of gray levels)
#

foo periodic	12

#

0	dur		"Stimulus duration (s *10)"		20	1-600 1+
1	x		"Center, x (deg*10)"			0	-200-200 1+
2	y		"Center, y (deg*10)"			0	-200-200 1+
3	nfr		"Repaint interval (frames)"		1	1-8 1+
4	ufr		"Unique interval (repaints)"		1	1-8 1+
5	ntexel		"Texture Number of Elements"		5	1-15 1+
6	ngrays		"Texture Number of Gray Levels"		16	4-256 1+
7	idiam2		"Texture Inner Diameter (deg*10)"	40	0-400 1+
8	odiam2		"Texture Outer Diameter (deg*10)"	80	0-400 1+
9	moment		"Texture Order of Moment"		1	1-6 1+
10	magni		"Texture Modulation Depth (%)"		0	-100-100 1+
11	seed		"Texture Spatial seed"			1	1-9999 1+


	

