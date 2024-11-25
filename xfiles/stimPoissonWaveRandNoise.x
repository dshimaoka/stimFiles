#
#	stimPoissonWaveRandNoise
#
#
foo nonperiodic 15
#
0  dur		"Stimulus duration	(s*10)"		50	1-6000	1+
1  Vamp		"Pulse amplitude	(mV)"		2000	0-5000	1+
2  f		"Mean Poisson rate	(Hz*10)"	10	0-20000 1+
3  durT		"Pulse duration 	(ms)"		5	1-1000	1+
4  seedp	"Poisson train random # seed"		1	1-100	1+
5  trigType	"Manual(1), HwDigital(2), Immediate(3)"	2	1-3	1+
6  x1	"Left border from center	(deg*10)"	-400	-1000-500 1+
7  x2	"Right border from center	(deg*10)"	800	-500-1000 1+
8  y1	"Bottom border from center	(deg*10)"	-400	-1000-500 1+
9  y2	"Top border from center		(deg*10)"	400	-500-1000 1+
10 nfr	"Number of frames per stimulus"			10	1-70	  1+
11 sqsz	"Size of squares 		(deg*10)"	30	1-100	  1+
12 ncs	"Number of contrasts (choose 2 for b&w)"	3	2-16	  1+
13 c	"Contrast 			(%)"		100	0-100	  1+
14 seedw	"White noise random # seed"		1	1-100	  1+
