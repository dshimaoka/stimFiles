#
#	stimLoadImg4
#
#
foo nonperiodic	11
#
0	dur	"               Stimulus duration (s *10)"	3   	1-18000 1+
1	x1	"       Left border, from center (deg*10)"	-1400	-1400-1400 1+
2	x2	"      Right border, from center (deg*10)"	1400	-1400-1400 1+
3	y1	"     Bottom border, from center (deg*10)"	-1000	-1000-1000 1+
4	y2	"        Top border, from center (deg*10)"	1000	-1000-1000 1+
5	c	"                            Contrast (%)"	100	0-100 1+
6	seed	"         Seed of random number generator"	2	1-1000 1+
7	repn	"which image in the sequence (0 is random)"	1	0-10000 1+
8	ip	"                    which image database"	5600	1-10000 1+
9	nimg	"                  total number of images"	5600	1-10000 1+
10	pbl	"                       percentage blanks"	5	0-100 1+