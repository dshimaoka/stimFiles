#
#	stimSweepGrating
#
#
foo nonperiodic	13
#
0	dur	"               Stimulus duration (s *10)"	80	1-600 1+
1	tf1	"              Temporal frequency (Hz*10)"	100	1-200 1+
2	tf2	"              Temporal frequency (Hz*10)"	10	1-200 1+
3	sf1	"             Spatial frequency (cpd*100)"	5	0-1000 1+
4	c1	"                            Contrast (%)"	50	-100-100 1+
5	ori1	"                       Orientation (deg)"	45	0-360 1+
6	dim1	"                       Diameter (deg*10)"	1	1-500 1+
7	dim2	"                       Diameter (deg*10)"	800	1-1000 1+
8	x1	"              Focus position, x (deg*10)"	0	-900-900 1+
9	y1	"              Focus position, y (deg*10)"	0	-300-300 1+
10	ton	"                          onset time(ms)"	1000	1-6000 1+
11	toff	"                         offset time(ms)"	4000	1-8000 1+
12	shape	"            shape (0 = circle; 1 = rect)"	0	0-1 1+
