#
#	stimWaveOutputIC1013
#
#
foo nonperiodic	12
#
0	dur	"                Stimulus duration (s*10)"	50	1-600 1+
1	SineAmp	"              Amplitude of sinusoid (mV)"	100	0-5000 1+
2	SineFreq	"                       Frequency (Hz*10)"	4400	0-20000 1+
3	t1	"                  Time of 1st event (ms)"	2000	0-6000 1+
4	v1	"                 Value at 1st event (mV)"	-1000	-5000-5000 1+
5	t2	"                  Time of 2nd event (ms)"	3000	0-6000 1+
6	v2	"                 Value at 2nd event (mV)"	-2000	-5000-5000 1+
7	t3	"                  Time of 3rd event (ms)"	3000	0-6000 1+
8	v3	"                 Value at 3rd event (mV)"	1000	-5000-5000 1+
9	t4	"                  Time of 4th event (ms)"	4000	0-6000 1+
10	v4	"                 Value at 4th event (mV)"	2000	-5000-5000 1+
11	trigtype " 'Manual(1), HwDigital(2), Immediate(3)" 	1	1-3 1+