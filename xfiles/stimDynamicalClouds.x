#
#	stimDynamicalClouds
#
#
foo nonperiodic	15
#
0	dur	"               Stimulus duration (s *10)"	90	1-600 1+
1	ss	"Spatial scale (half-width gauss) (sq*10)"	40	0-4000 1+
2	ts	"Temporal scale (half-width gauss) (fr*10)"	40	0-4000 1+
3	diam	"                       Diameter (deg*10)"	200	0-2700 1+
4	xc	"                      Center, x (deg*10)"	-100	-1400-1400 1+
5	yc	"                      Center, y (deg*10)"	0	-450-450 1+
6	tstart	"                   Drifting start (s*10)"	30	1-600 1+
7	tstop	"                    Drifting stop (s*10)"	60	1-600 1+
8	cr	"                 Contrast of red gun (%)"	100	0-100 1+
9	cg	"               Contrast of green gun (%)"	100	0-100 1+
10	cb	"                Contrast of blue gun (%)"	100	0-100 1+
11	lr	"           Mean luminance of red gun (%)"	50	0-100 1+
12	lg	"         Mean luminance of green gun (%)"	50	0-100 1+
13	lb	"          Mean luminance of blue gun (%)"	50	0-100 1+
14	seed	"         Seed of random number generator"	1	1-100 1+
