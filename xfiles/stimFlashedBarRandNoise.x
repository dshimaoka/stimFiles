#
#	stimFlashedBarRandNoise
#
#
foo nonperiodic	18
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	ori	"                       Orientation (deg)"	45	0-360 1+
2	len	"                     Bar length (deg*10)"	300	1-900 1+
3	wid	"                      Bar width (deg*10)"	50	1-900 1+
4	pos	"     Position relative to focus (deg*10)"	200	-900-900 1+
5	xfocus	"              Focus position, x (deg*10)"	-300	-900-900 1+
6	yfocus	"              Focus position, y (deg*10)"	0	-300-300 1+
7	ton1	"                      1st onset time(ms)"	300	1-6000 1+
8	toff1	"                     1st offset time(ms)"	2300	1-6000 1+
9	ton2	"                      2nd onset time(ms)"	2400	1-6000 1+
10	toff2	"                     2nd offset time(ms)"	4400	1-6000 1+
11	lum1	"                       1st luminance (%)"	50	-100-100 1+
12	lum2	"                       2nd luminance (%)"	-50	-100-100 1+
13	nfr	"    NOISE: Number of frames per stimulus"	20	1-70 1+
14	sqsz	"         NOISE: Size of squares (deg*10)"	40	1-100 1+
15	ncs	"NOISE: Number of contrasts (choose 2 for b&w)"	3	2-16 1+
16	c	"                     NOISE: Contrast (%)"	50	0-100 1+
17	seed	"  NOISE: Seed of random number generator"	1	1-100 1+
