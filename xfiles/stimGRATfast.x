#
#	stimGRATfast
#
#
foo nonperiodic	20
#
0	dur	"               Stimulus duration (s *10)"	20	1-18000 1+
1	tf	"             Temporal frequency (Hz *10)"	20	1-400 1+
2	sf	"            Spatial frequency (cpd *100)"	5	1-200 1+
3	tph	"                    Temporal phase (deg)"	0	0-360 1+
4	sph	"                     Spatial phase (deg)"	0	0-360 1+
5	nOri	"                       number of orientations"	12	1-360 1+
6	diam	"                       Diameter (deg*10)"	400	0-1200 1+
7	xc	"                      Center, x (deg*10)"	0	-1500-1500 1+
8	yc	"                      Center, y (deg*10)"	0	-900-900 1+
9	cr	"                 Contrast of red gun (%)"	0	0-100 1+
10	cg	"               Contrast of green gun (%)"	0	0-100 1+
11	cb	"                Contrast of blue gun (%)"	100	0-100 1+
12	lr	"           Mean luminance of red gun (%)"	0	0-100 1+
13	lg	"         Mean luminance of green gun (%)"	0	0-100 1+
14	lb	"          Mean luminance of blue gun (%)"	50	0-100 1+
15	stimF   "            Stimulus frequency in frames"	10	0-100 1+
16	stimD   "             Stimulus duration in frames"	3	0-100 1+
17	oriB    "           	 Orientation biased (deg)"	30	0-360 1+
18	oriF    "             	         	Bias ratio"	6	1-100 1+
19	stimOFF "               OFF frames after stimulus"	2	0-100 1+