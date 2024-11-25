#
#	vmovie3sequentialGrating_stimOptiWave.x
#
#	a sequence of 3 gratings in 1 window + analogue output(x2)
#
foo periodic	41
#
0	dur		"Stimulus duration (s *10)"		60	1-1200 1+
1	swT1		"Time of switch from 1 to 2 (s *10)"	20	1-1200 1+
2	swT2		"Time of switch from 2 to 3 (s *10)"	40	1-1200 1+
3 	dima		"Inner Diam or Size X (deg *10)"	30	0-2000 1+
4	dimb		"Outer Diam or Size Y (deg *10)"	100	1-2000 1+
5	x		"Center, x (deg *10)"			-50	-1500-1500 1+
6	y		"Center, y (deg *10)"			0	-800-800 1+
7	flick 		"Drift (0) or s-Flicker (1) or st-Flicker (2)"		1	0-2 1+
8	sqwv		"Sine (0) or Square (1)"		1	0-1 1+
9	shape 		"Annulus (0) or Rectangle (1)"		1	0-1 1+
10	tf1		"Patch 1: Temporal frequency (Hz *10)"	40	1-400 1+
11	sf1		"Patch 1: Spatial frequency (cpd *100)"	10	1-200 1+
12	tph1		"Patch 1: Temporal phase (deg)"		0	0-360 1+
13	sph1		"Patch 1: Spatial phase (deg)"		0	0-360 1+
14	c1		"Patch 1: Contrast (%)"			50	0-100 1+
15	ori1		"Patch 1: Orientation (deg)"		90	0-360 1+
16	tf2		"Patch 2: Temporal frequency (Hz *10)"	50	1-400 1+
17	sf2		"Patch 2: Spatial frequency (cpd *100)"	50	1-200 1+
18 	tph2		"Patch 2: Temporal phase (deg)"		0	0-360 1+
19	sph2		"Patch 2: Spatial phase (deg)"		0	0-360 1+
20	c2		"Patch 2: Contrast (%)"			50	0-100 1+
21	ori2		"Patch 2: Orientation (deg)"		0	0-360 1+
22	tf3		"Patch 3: Temporal frequency (Hz *10)"	50	1-400 1+
23	sf3		"Patch 3: Spatial frequency (cpd *100)"	50	1-200 1+
24	tph3		"Patch 3: Temporal phase (deg)"		0	0-360 1+
25	sph3		"Patch 3: Spatial phase (deg)"		0	0-360 1+
26	c3		"Patch 3: Contrast (%)"			50	0-100 1+
27	ori3		"Patch 3: Orientation (deg)"		45	0-360 1+
28	tstart1	"                  WAVE1: Start time (ms)"	1000	0-60000 1+
29	tend1	"                    WAVE1: End time (ms)"	3000	0-60000 1+
30	amp1	"                   WAVE1: Amplitude (mV)"	0	0-5000 1+
31	shape1	" WAVE1: Ramp(1), Step(2) or Half-Sine(3)"	3	1-3 1+
32	freq1	"      WAVE1: Frequency of pulses (Hz*10)"	10	0-1000 1+
33	dcyc1	"         WAVE1: Pulses Duty Cycle (%*10)"	200	0-1000 1+
34	tstart2	"                  WAVE2: Start time (ms)"	1000	0-60000 1+
35	tend2	"                    WAVE2: End time (ms)"	3000	0-60000 1+
36	amp2	"                   WAVE2: Amplitude (mV)"	0	0-5000 1+
37	shape2	" WAVE2: Ramp(1), Step(2) or Half-Sine(3)"	1	1-3 1+
38	freq2	"      WAVE2: Frequency of pulses (Hz*10)"	0	0-1000 1+
39	dcyc2	"         WAVE2: Pulses Duty Cycle (%*10)"	200	0-1000 1+
40	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+