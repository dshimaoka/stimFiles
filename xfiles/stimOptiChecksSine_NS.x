#
#	stimOptiChecksSine_NS
#
#
foo nonperiodic	15
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
11	amp1	"                   WAVE1: Amplitude (mV)"	0	0-5000 1+
12	freq1	"      WAVE1: Frequency of pulses (Hz*10)"	10	0-1000 1+
13	tailDuration	"   WAVE1: Tail Duration (ms, 0 for none)"	200	0-10000 1+
14	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
