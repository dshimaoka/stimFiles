#
#	stimORsequence
#
#
foo nonperiodic	16
#
0	dur	"               Stimulus duration (s *10)"	50	1-12000 1+
1	tf	"             Temporal frequency (Hz *10)"	20	0-4000 1+
2	sf	"           Spatial frequency (cpd *1000)"	80	0-1000 1+
3	stimOnRatio	"                    Stim On percentile (%)"	0	0-100 1+
4	stimMode	"                     0: equiprob, 1: novel/adaptor"	0	0-1 1+
5	novelOri	"                       Novel Orientation (deg)"	0	0-360 1+
6	seed	"                 Seed integer for rand"	0	0-10000 1+
7	dB	"                 Diameter (deg*10)"	200	0-2700 1+
8	xc	"                      Center, x (deg*10)"	-100	-1400-1400 1+
9	yc	"                      Center, y (deg*10)"	0	-450-450 1+
10	cr	"                 Contrast of red gun (%)"	100	0-100 1+
11	cg	"               Contrast of green gun (%)"	100	0-100 1+
12	cb	"                Contrast of blue gun (%)"	100	0-100 1+
13	lr	"           Mean luminance of red gun (%)"	50	0-100 1+
14	lg	"         Mean luminance of green gun (%)"	50	0-100 1+
15	lb	"          Mean luminance of blue gun (%)"	50	0-100 1+
