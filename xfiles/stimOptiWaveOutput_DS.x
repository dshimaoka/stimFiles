#
#	stimOptiWaveOutput_DS
#
#
foo nonperiodic	14
#
0	dur	"                Stimulus duration (s*10)"	70	1-600 1+
1	tstart1	"                         Start time (ms)"	1000	0-60000 1+
2	tend1	"                           End time (ms)"	6000	0-60000 1+
3	amp1	"                          Amplitude (mV)"	5000	0-5000 1+
4	shape1	"        Ramp(1), Step(2) or Half-Sine(3)"	3	1-3 1+
5	freq1	"             Frequency of pulses (Hz*10)"	10	0-1000 1+
6	dcyc1	"                Pulses Duty Cycle (%*10)"	200	0-1000 1+
7	tstart2	"                         Start time (ms)"	1000	0-60000 1+
8	tend2	"                           End time (ms)"	6000	0-60000 1+
9	amp2	"                          Amplitude (mV)"	3000	0-5000 1+
10	shape2	"        Ramp(1), Step(2) or Half-Sine(3)"	1	1-3 1+
11	freq2	"             Frequency of pulses (Hz*10)"	0	0-1000 1+
12	dcyc2	"                Pulses Duty Cycle (%*10)"	200	0-1000 1+
13	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
