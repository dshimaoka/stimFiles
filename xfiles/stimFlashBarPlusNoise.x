#
#	stimFlashBarPlusNoise
#
#
foo nonperiodic	18
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	ori	"                       Orientation (deg)"	45	0-360 1+
2	len	"                     Bar length (deg*10)"	300	1-900 1+
3	wid	"                      Bar width (deg*10)"	50	1-900 1+
4	pos	"Position relative to center of screen (deg*10)"	200	-900-900 1+
5	ton1	"                      1st onset time(ms)"	300	1-6000 1+
6	toff1	"                     1st offset time(ms)"	2300	1-6000 1+
7	ton2	"                      2nd onset time(ms)"	2400	1-6000 1+
8	toff2	"                     2nd offset time(ms)"	4400	1-6000 1+
9	lum1	"                       1st luminance (%)"	50	-100-100 1+
10	lum2	"                       2nd luminance (%)"	-50	-100-100 1+
11	x1	"       Left border, from center (deg*10)"	-400	-2000-2000 1+
12	x2	"      Right border, from center (deg*10)"	400	-2000-2000 1+
13	nfr	"    NOISE: Number of frames per stimulus"	20	1-70 1+
14	sqsz	"         NOISE: Size of squares (deg*10)"	40	1-400 1+
15	ncs	"NOISE: Number of contrasts (choose 2 for b&w)"	3	2-50 1+
16	c	"                     NOISE: Contrast (%)"	50	0-100 1+
17	seed	"  NOISE: Seed of random number generator"	1	1-100 1+
