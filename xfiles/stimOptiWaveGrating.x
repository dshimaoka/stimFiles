#
#	stimOptiWaveGrating
#
#
foo nonperiodic	23
#
0	dur	"                  Total duration (s *10)"	1       1-600 1+
1	tf	"             Temporal frequency (Hz *10)"	20	0-4000 1+
2	sf	"           Spatial frequency (cpd *1000)"	80	0-1000 1+
3	tph	"                    Temporal phase (deg)"	0	0-360 1+
4	sph	"                     Spatial phase (deg)"	0	0-360 1+
5	ori	"                       Orientation (deg)"	0	0-360 1+
6	diam	"                       Diameter (deg*10)"	1400	0-2800 1+
7	xc	"                      Center, x (deg*10)"	0	-1400-1400 1+
8	yc	"                      Center, y (deg*10)"	0	-450-450 1+
9	flck	"          Flickering (1) or drifting (0)"	0	0-1 1+
10	sqwv	"         Square wave (1) or sinusoid (0)"	0	0-1 1+
11	shape	"             Rectangle (1) or circle (0)"	1	0-1 1+
12	tstart	"                         Start time (ms)"	300	0-60000 1+
13	tend	"                         End   time (ms)"	1300	0-60000 1+
14	ctst	"                            Contrast (%)"	20	0-100 1+
15	lum	"                      Mean luminance (%)"	20	0-100 1+
16	tstart1	"                  Laser: Start time (ms)"	50	0-60000 1+
17	tend1	"                    Laser: End time (ms)"	800	0-60000 1+
18	amp1	"                   Laser: Amplitude (mV)"	0	0-5000 1+
19	tstart2	"                   Puff: Start time (ms)"	0	0-60000 1+
20	tend2	"                     Puff: End time (ms)"	100	0-60000 1+
21	amp2	"                    Puff: Amplitude (mV)"	0	0-5000 1+
22	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
