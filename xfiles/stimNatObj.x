#
#	stimNatObj
#
#
foo nonperiodic	10
#
0	dur	"                Stimulus duration (s*10)"	5	1-100 1+
1	c	"                            Contrast (%)"	100	0-100 1+
2	xc	"                      Center, x (deg*10)"	0	-1400-1400 1+
3	yc	"                      Center, y (deg*10)"	0	-450-450 1+
4	gSTD	"            STD of Gaussian window (deg)"	10	0-100 1+
5	theta	"                          Rotation (deg)"	0	0-360 1+
6	seed	"         Seed of random number generator"	1	1-1000 1+
7	nimg	"           Number of images in directory"	10	1-2800 1+
8	repn	"Which image in the sequence (0 is random)"	0	0-10000 1+
9	pbl	"                       Percentage blanks"	5	0-100 1+
