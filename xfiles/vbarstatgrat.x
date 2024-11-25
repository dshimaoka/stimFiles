#
#	vbarstatgrat
#
#	For gratings moving together with horizontal or vertical bars

foo periodic	13

#

0	dur		"Stimulus duration (s *10)"		10	1-600 1+
1	ori		"Grating Orientation (deg)"		90	0-360 1+
2	sf100		"Grating Spatial frequency (cpd *100)"	50	1-200 1+
3	phase		"Grating Phase (deg)"			0	0-360 1+
4	c		"Grating Contrast (%)"			50	0-50 1+
5	sqwv		"Sinusoidal: 0 Square:1"		1	0-1 1+
6	Etf		"Bar Temporal frequency (Hz *10)"	10	1-400 1+
7	Ewidth		"Bar width (deg*10)"		10	0-400 1+
8	Eori		"Bar Orientation (0-90-180-270)"	90	0-270 90+
9	Enbars		"Number of bars"			2	1-5 1+
10	x		"Window Center, x (deg*10)"		0	-200-200 1+
11	y		"Window Center, y (deg*10)"		0	-200-200 1+
12	size		"Window size"				50	1-400 1+

