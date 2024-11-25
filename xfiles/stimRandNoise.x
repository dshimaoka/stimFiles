#
#	stimRandNoise
#
#
foo nonperiodic	10
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	x1	"       Left border, from center (deg*10)"	-400	-1000-500 1+
2	x2	"      Right border, from center (deg*10)"	400	-500-1000 1+
3	y1	"     Bottom border, from center (deg*10)"	-200	-1000-500 1+
4	y2	"        Top border, from center (deg*10)"	200	-500-1000 1+
5	nfr	"           Number of frames per stimulus"	10	1-70 1+
6	sqsz	"                Size of squares (deg*10)"	30	1-100 1+
7	ncs	"  Number of contrasts (choose 2 for b&w)"	3	2-16 1+
8	c	"                            Contrast (%)"	100	0-100 1+
9	seed	"         Seed of random number generator"	1	1-100 1+
