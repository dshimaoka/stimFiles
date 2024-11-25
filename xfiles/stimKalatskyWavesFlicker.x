#
#	stimKalatskyWavesFlicker
#
#
foo nonperiodic	24
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	start	"                    Stimulus start (deg)"	0	0-360 1+
2	end	"                      Stimulus end (deg)"	360	0-360 1+
3	tf	"            Temporal frequency (Hz *100)"	1	1-400 1+
4	sf	"            Spatial frequency (cpd *100)"	20	1-200 1+
5	tph	"                    Temporal phase (deg)"	0	0-360 1+
6	sph	"                     Spatial phase (deg)"	0	0-360 1+
7	dir	"                   Direction of movement"	1	-1-1 1+
8	cyN	"                 Cycles number (integer)"	1	1-100 1+
9	flickfreq	"  Temporal frequency of flicker (Hz *10)"	40	1-400 1+
10	cr	"                 Contrast of red gun (%)"	100	0-100 1+
11	cg	"               Contrast of green gun (%)"	0	0-100 1+
12	cb	"                Contrast of blue gun (%)"	0	0-100 1+
13	lr	"           Mean luminance of red gun (%)"	50	0-100 1+
14	lg	"         Mean luminance of green gun (%)"	0	0-100 1+
15	lb	"          Mean luminance of blue gun (%)"	0	0-100 1+
16	ori	"         Orientation (xpos = 1;ypos = 2)"	1	1-2 1+
17	Wave1Amp	"                   Wave 1 amplitude (mV)"	5000	0-5000 1+
18	Wave1Dur	"              Wave 1 pulse duration (ms)"	10	0-1000 1+
19	Wave1FlickFreq	"        Wave 1 emporal frequency (Hz*10)"	250	0-20000 1+
20	Wave2Amp	"                   Wave 2 amplitude (mV)"	5000	0-5000 1+
21	Wave2Dur	"              Wave 2 pulse duration (ms)"	10	0-1000 1+
22	Wave2FlickFreq	"       Wave 2 temporal frequency (Hz*10)"	250	0-20000 1+
23	WavesShift	"Temporal Shift between Wave 1 and 2 (ms)"	20	0-1000 1+
