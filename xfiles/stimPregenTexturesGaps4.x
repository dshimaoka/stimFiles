#
#	stimPregenTexturesGaps4
#
#
foo nonperiodic	13
#
0	dur	"                   Stimulus duration (s *10)"	100	1-36000 1+
1	x1	"           Left border, from center (deg*10)"	-1400	-1400-1400 1+
2	x2	"          Right border, from center (deg*10)"	1400	-1400-1400 1+
3	y1	"         Bottom border, from center (deg*10)"	-1000	-1000-1000 1+
4	y2	"            Top border, from center (deg*10)"	1000	-1000-1000 1+
5	nFR1    " 		       number of slow repeats"	10	1-2000 1+
6	nFR2    "                      number of fast repeats"	1	1-2000 1+
7	c	"                                Contrast (%)"	100	0-100 1+
8	seed	"             Seed of random number generator"	1	1-100 1+
9	stimF   "                Stimulus frequency in frames"	10	0-100 1+
10	stimD   "                 Stimulus duration in frames"	3	0-100 1+
11	stimOFF "                   OFF frames after stimulus"	2	0-100 1+
12	slowFR  "                   frequency of slow repeats"	4	0-1000 1+