#
#	stimTextureWater
#
#
foo nonperiodic	18
#
0	dur	"               Stimulus duration (s *10)"	2	1-18000 1+
1	x1	"       Left border, from center (deg*10)"	-1400	-1400-1400 1+
2	x2	"      Right border, from center (deg*10)"	1400	-1400-1400 1+
3	y1	"     Bottom border, from center (deg*10)"	-1000	-1000-1000 1+
4	y2	"        Top border, from center (deg*10)"	1000	-1000-1000 1+
5	c	"                            Contrast (%)"	100	0-100 1+
6	seed	"         Seed of random number generator"	1	1-1000 1+
7	repn	"which image in the sequence (0 is random)"	1	0-10000 1+
8	ip	"                    which image database"	1	1-1000 1+
9	nimg	"                  total number of images"	1400	1-10000 1+
10	pbl	"                       percentage blanks"	5	0-100 1+
11	tstart1	"                  Wave1: Start time (ms)"	50	0-60000 1+
12	tend1	"                    Wave1: End time (ms)"	800	0-60000 1+
13	amp1	"                   Wave1: Amplitude (mV)"	0	0-50000 1+
14	tstart2	"                  Wave2: Start time (ms)"	0	0-60000 1+
15	tend2	"                    Wave2: End time (ms)"	100	0-60000 1+
16	amp2	"                   Wave2: Amplitude (mV)"	0	0-50000 1+
17	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
