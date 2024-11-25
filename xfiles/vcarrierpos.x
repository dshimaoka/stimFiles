#
#	vcarrieripos.x
#
#		one rectangle drifting grating that drifts orizontally or vertically
#

foo periodic	10

#

0	dur		"Stimulus duration (s *10)"		20	1-600 1+
1	ori		"Orientation of grating (0-360 deg)"	0	0-360 1+
2	nperiods	"N of periods of change in pos"		4	-100-100 1+
3	tf		"Temp freq of grating(Hz)"		20	1-200 1+
4	sf		"spat freq of grating (cpd)"		50	0-360 1+
5	phase		"grating Phase (radians)"		0	0-50  1+
6	c		"Contrast (%)"				50	0-50  1+
7	npos		"Number of positions"			3	1-360  1+
8	sizeX		"size of rectangle (pix)"		60	0-640  1+
9	sizeY		"size of rectangle (pix)"		0	0-480  1+
