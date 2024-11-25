#
#	stimFlashedGrat
#
#
foo nonperiodic	12
#
0	dur	"               Stimulus duration (s *10)"	3	1-6000 1+
1	tf1	"              Temporal frequency (Hz*10)"	10	1-200 1+
2	sf1	"             Spatial frequency (cpd*100)"	5	0-1000 1+
3	c1	"                            Contrast (%)"	50	0-100 1+
4	ori1	"                       Orientation (deg)"	45	0-360 1+
5	dim1	"                       Diameter (deg*10)"	0	0-50000 1+
6	dim2	"                       Diameter (deg*10)"	250	1-50000 1+
7	x1	"              Focus position, x (deg*10)"	0	-900-900 1+
8	y1	"              Focus position, y (deg*10)"	0	-300-300 1+
9	ton	"                          onset time(ms)"	100	1-6000 1+
10	toff	"                         offset time(ms)"	200	1-6000 1+
11	shape	" shape (0 = circle; 1 = rect; 2 = gauss)"	0	0-2 1+
