#
#	stimGratingStartedAndStopped_withLum
#
#
foo nonperiodic	14
#
0	dur	"               Stimulus duration (s *10)"	20	1-600 1+
1	tf	"             Temporal frequency (Hz *10)"	40	0-4000 1+
2	sf	"           Spatial frequency (cpd *1000)"	100	0-1000 1+
3	tph	"                    Temporal phase (deg)"	0	0-360 1+
4	sph	"                     Spatial phase (deg)"	0	0-360 1+
5	ori	"                       Orientation (deg)"	0	0-360 1+
6	diam	"                       Diameter (deg*10)"	1050	0-2700 1+
7	xc	"                      Center, x (deg*10)"	400	-1400-1400 1+
8	yc	"                      Center, y (deg*10)"	0	-450-450 1+
9	tstart	"                   Drifting start (s*10)"	1	1-600 1+
10	tstop	"                    Drifting stop (s*10)"	20	1-600 1+
11	con	"                           Contrast  (%)"	100	0-100 1+
12	lum	"                           Luminance (%)"	50	0-100 1+
13	persist	"                Persist luminance or not"	0	0-1 1+
