#
#	stimGratingRandom
#
#
foo nonperiodic	20
#
0	dur	"               Stimulus duration (s *10)"	20	1-12000 1+
1	tf	"             Temporal frequency (Hz *10)"	20	0-4000 1+
2	sf	"           Spatial frequency (cpd *1000)"	80	0-1000 1+
3	tph	"                    Temporal phase (deg)"	0	0-360 1+
4	sph	"                     Spatial phase (deg)"	0	0-360 1+
5	ori	"                      Orientation (seed)"	1	1-100000 1+
6	dA	"                 Inner diameter (deg*10)"	0	0-1200 1+
7	dB	"                 Outer diameter (deg*10)"	200	0-2700 1+
8	xc	"                      Center, x (deg*10)"	-100	-1400-1400 1+
9	yc	"                      Center, y (deg*10)"	0	-450-450 1+
10	flck	"          Flickering (1) or drifting (0)"	0	0-1 1+
11	sqwv	"         Square wave (1) or sinusoid (0)"	0	0-1 1+
12	duty	"                       Duty cycle (*100)"	100	0-100 1+
13	shape	"             Rectangle (1) or circle (0)"	0	0-1 1+
14	cr	"                 Contrast of red gun (%)"	100	0-100 1+
15	cg	"               Contrast of green gun (%)"	100	0-100 1+
16	cb	"                Contrast of blue gun (%)"	100	0-100 1+
17	lr	"           Mean luminance of red gun (%)"	50	0-100 1+
18	lg	"         Mean luminance of green gun (%)"	50	0-100 1+
19	lb	"          Mean luminance of blue gun (%)"	50	0-100 1+
