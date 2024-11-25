#
#	stimOptiWaveOutput_GalvoTest
#
#
foo nonperiodic	8
#
0	dur	"                Stimulus duration (s*10)"	70	1-600 1+
1	tstart1	"                         Start time (ms)"	1000	0-60000 1+
2	tend1	"                           End time (ms)"	6000	0-60000 1+
3	amp1	"                          Amplitude (mV)"	0	0-5000 1+
4	freq1	"                       Frequency (Hz*10)"	10	0-10000 1+
5	tailDuration	"          Tail Duration (ms, 0 for none)"	200	0-10000 1+
6	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
7	shape	"           Sine (1), GalvoSimulation (2)"	1	1-2 1+
