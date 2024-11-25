#
#	stimFlashedBarRandNoiseTS
#
#
foo nonperiodic	18
#
0	dur	"               Stimulus duration (s *10)"	30	1-600 1+
1	ori	"                       Orientation (deg)"	0	0-360 1+
2	len	"                     Bar length (deg*10)"	400	1-900 1+
3	wid	"                      Bar width (deg*10)"	128	1-900 1+
4	pos	"     Position relative to focus (deg*10)"	-455	-900-900 1+
5	xfocus	"              Focus position, x (deg*10)"	0	-900-900 1+
6	yfocus	"              Focus position, y (deg*10)"	0	-300-300 1+
7	ton1	"                      1st onset time(ms)"	1000	1-6000 1+
8	toff1	"                     1st offset time(ms)"	1100	1-6000 1+
9	ton2	"                      2nd onset time(ms)"	2000	1-6000 1+
10	toff2	"                     2nd offset time(ms)"	2100	1-6000 1+
11	lum1	"                       1st luminance (%)"	50	-100-100 1+
12	lum2	"                       2nd luminance (%)"	-50	-100-100 1+
13	nfr	"    NOISE: Number of frames per stimulus"	27	1-70 1+
14	sqsz	"         NOISE: Size of squares (deg*10)"	150	1-300 1+
15	ncs	"NOISE: Number of contrasts (choose 2 for b&w)"	3	2-16 1+
16	c	"                     NOISE: Contrast (%)"	50	0-100 1+
17	seed	"  NOISE: Seed of random number generator"	1	0-100 1+
