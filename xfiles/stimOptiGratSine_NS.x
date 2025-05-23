#
#	stimOptiGratSine_NS
#
#
foo nonperiodic	18
#
0	dur	"               Stimulus duration (s *10)"	3	1-6000 1+
1	tf1	"              Temporal frequency (Hz*10)"	10	1-200 1+
2	sf1	"             Spatial frequency (cpd*100)"	5	0-1000 1+
3	c1	"                            Contrast (%)"	50	0-100 1+
4	ori1	"                       Orientation (deg)"	45	0-360 1+
5	dim1	"                       Diameter (deg*10)"	0	0-50000 1+
6	dim2	"                       Diameter (deg*10)"	250	1-50000 1+
7	x1	"              Focus position, x (deg*10)"	0	-900-900 1+
8	y1	"              Focus position, y (deg*10)"	0	-300-300 1+
9	ton	"                          onset time(ms)"	100	1-6000 1+
10	toff	"                         offset time(ms)"	200	1-6000 1+
11	shape	" shape (0 = circle; 1 = rect; 2 = gauss)"	0	0-2 1+
12	tstart1	"                  WAVE1: Start time (ms)"	1000	0-60000 1+
13	tend1	"                    WAVE1: End time (ms)"	3000	0-60000 1+
14	amp1	"                   WAVE1: Amplitude (mV)"	0	0-5000 1+
15	freq1	"      WAVE1: Frequency of pulses (Hz*10)"	10	0-1000 1+
16	tailDuration	"   WAVE1: Tail Duration (ms, 0 for none)"	200	0-10000 1+
17	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
