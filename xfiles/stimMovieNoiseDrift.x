#
#	stimMovieNoiseDrift
#
#
foo nonperiodic	16
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	movieORnoiseORdrift	"selects which type of stimulus to present"	1	0-2 1+
2	C	"movie contrast squashing factor (in %) / contrast"	100	1-100 1+
3	x1	"       Left border, from center (deg*10)"	-400	-1000-500 1+
4	x2	"      Right border, from center (deg*10)"	400	-500-1000 1+
5	movieFile	"                          Movie filename"	8009	1-9999 1+
6	flipBW	"                    flip black and white"	0	0-1 1+
7	y1	"     Bottom border, from center (deg*10)"	-200	-1000-500 1+
8	y2	"        Top border, from center (deg*10)"	200	-500-1000 1+
9	nfr	"           Number of frames per stimulus"	10	1-70 1+
10	sqsz	"                Size of squares (deg*10)"	30	1-100 1+
11	ncs	"  Number of contrasts (choose 2 for b&w)"	3	2-16 1+
12	seed	"         Seed of random number generator"	1	1-100 1+
13	tfreq	"              temporal freq (cyc/s * 10)"	50	1-100 1+
14	sfreq 	"             spatial freq (cyc/deg* 100)"	15	5-50 1+
15	ori	"                             orientation"	225	0-359 1+
