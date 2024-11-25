#
#	stimOnePulseRandNoise
#
#
foo nonperiodic 14
#
0  dur		"Stimulus duration	(s*10)"		50	1-6000	1+
1  Vamp		"Pulse amplitude	(mV)"		3300	0-5000	1+
2  durT		"Pulse duration 	(ms)"		5	1-1000	1+
3  Tp           "Time of pulse          (ms)",          500     1-10000 1+
4  trigType	"Manual(1), HwDigital(2), Immediate(3)"	2	1-3	1+
5  x1	"Left border from center	(deg*10)"	-400	-1000-500 1+
6  x2	"Right border from center	(deg*10)"	1000	-500-1000 1+
7  y1	"Bottom border from center	(deg*10)"	-400	-1000-500 1+
8  y2	"Top border from center		(deg*10)"	400	-500-1000 1+
9  nfr	"Number of frames per stimulus"			10	1-70	  1+
10 sqsz	"Size of squares 		(deg*10)"	30	1-100	  1+
11 ncs	"Number of contrasts (choose 2 for b&w)"	3	2-16	  1+
12 c	"Contrast 			(%)"		100	0-100	  1+
13 seedw	"White noise random # seed"		1	1-100	  1+
