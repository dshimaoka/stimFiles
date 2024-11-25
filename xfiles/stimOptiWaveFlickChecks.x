#
#	stimOptiWaveFlickChecks
#
#
foo nonperiodic	22
#
0	dur	"                 Overall duration (s*10)"	50	1-600 1+
1	tf	"      Flicker temporal frequency (Hz*10)"	20	1-160 1+
2	c	"                            Contrast (%)"	100	0-100 1+
3	checkSize	"             Single square size (deg*10)"	145	5-900 1+
4	width	"                 Stimulus width (deg*10)"	580	5-1800 1+
5	ctr	"                Stimulus centre (deg*10)"	0	-900-900 1+
6	sqwv	"                  Sine (0) or Square (1)"	1	0-1 1+
7	tstart	"                  Stim start time (s*10)"	10	0-600 1+
8	tend	"                    Stim end time (s*10)"	30	0-600 1+
9	tstart1	"                  WAVE1: Start time (ms)"	1000	0-60000 1+
10	tend1	"                    WAVE1: End time (ms)"	3000	0-60000 1+
11	amp1	"                   WAVE1: Amplitude (mV)"	5000	0-5000 1+
12	shape1	" WAVE1: Ramp(1), Step(2) or Half-Sine(3)"	3	1-3 1+
13	freq1	"      WAVE1: Frequency of pulses (Hz*10)"	10	0-1000 1+
14	dcyc1	"         WAVE1: Pulses Duty Cycle (%*10)"	200	0-1000 1+
15	tstart2	"                  WAVE2: Start time (ms)"	1000	0-60000 1+
16	tend2	"                    WAVE2: End time (ms)"	3000	0-60000 1+
17	amp2	"                   WAVE2: Amplitude (mV)"	3000	0-5000 1+
18	shape2	" WAVE2: Ramp(1), Step(2) or Half-Sine(3)"	1	1-3 1+
19	freq2	"      WAVE2: Frequency of pulses (Hz*10)"	0	0-1000 1+
20	dcyc2	"         WAVE2: Pulses Duty Cycle (%*10)"	200	0-1000 1+
21	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
