#
#	stimLoadImg
#
#
foo nonperiodic	11
#
0	dur	"               Stimulus duration (s *10)"	2       1-18000 1+
1	x1	"       Left border, from center (deg*10)"	-1400	-1400-1400 1+
2	x2	"      Right border, from center (deg*10)"	1400	-1400-1400 1+
3	y1	"     Bottom border, from center (deg*10)"	-1000	-1000-1000 1+
4	y2	"        Top border, from center (deg*10)"	1000	-1000-1000 1+
5	c	"                            Contrast (%)"	100	0-100 1+
6	seed	"         Seed of random number generator"	1	1-1000 1+
7	repn	"             which image in the sequence"	1	1-10000 1+
8	ip	"                    which image database"	1	1-1000 1+
9	nimg	"                  total number of images"	1400	1-10000 1+
10	pbl	"                       percentage blanks"	5	1-100 1+
