#
#	stimGratingStopped
#
#
foo nonperiodic	21
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	tf	"             Temporal frequency (Hz *10)"	20	0-4000 1+
2	sf	"           Spatial frequency (cpd *1000)"	80	0-1000 1+
3	tph	"                    Temporal phase (deg)"	0	0-360 1+
4	sph	"                     Spatial phase (deg)"	0	0-360 1+
5	ori	"                       Orientation (deg)"	0	0-360 1+
6	diam	"                       Diameter (deg*10)"	200	0-2700 1+
7	xc	"                      Center, x (deg*10)"	-100	-1400-1400 1+
8	yc	"                      Center, y (deg*10)"	0	-450-450 1+
9	flck	"          Flickering (1) or drifting (0)"	0	0-1 1+
10	sqwv	"         Square wave (1) or sinusoid (0)"	0	0-1 1+
11	shape	"             Rectangle (1) or circle (0)"	1	0-1 1+
12	tstart	"                         Start time (ms)"	300	0-60000 1+
13	tend	"                         End   time (ms)"	1300	0-60000 1+
14	cr	"                 Contrast of red gun (%)"	100	0-100 1+
15	cg	"               Contrast of green gun (%)"	100	0-100 1+
16	cb	"                Contrast of blue gun (%)"	100	0-100 1+
17	lr	"           Mean luminance of red gun (%)"	50	0-100 1+
18	lg	"         Mean luminance of green gun (%)"	50	0-100 1+
19	lb	"          Mean luminance of blue gun (%)"	50	0-100 1+
20	dridur	"                   drift duration (s*10)"	30	0-600 1+
