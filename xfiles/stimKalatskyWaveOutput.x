#
#	stimKalatskyWaveOutput
#
#
foo nonperiodic	23
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
17	SineAmp	"        WAVE: Amplitude of sinusoid (mV)"	100	0-5000 1+
18	SineFreq	"                 WAVE: Frequency (Hz*10)"	4400	0-20000 1+
19	t1	"            WAVE: Time of 1st event (ms)"	1000	0-6000 1+
20	v1	"           WAVE: Value at 1st event (mV)"	1000	-5000-5000 1+
21	t2	"            WAVE: Time of 2nd event (ms)"	2000	0-60000 1+
22	v2	"           WAVE: Value at 2nd event (mV)"	0	-5000-5000 1+
