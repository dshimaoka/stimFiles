#
#	stimSPOTSadapt
#
#
foo nonperiodic	12
#
0	dur	"              Stimuluse duration (s *10)"	10	1-6000 1+
1	x1	"       Left border, from center (deg*10)"	-1350	-1500-1500 1+
2	x2	"      Right border, from center (deg*10)"	1350	-1500-1500 1+
3	y1	"     Bottom border, from center (deg*10)"	-450	-1500-1500 1+
4	y2	"        Top border, from center (deg*10)"	450	-1500-1500 1+
5	nfr	"              Number of frames per image"	6	1-70 1+
6	sqsz	"                Size of squares (deg*10)"	75	1-100 1+
7	seed	"         Seed of random number generator"	1	1-100 1+
8	spotr	"                             Adaptor row"	1	1-100 1+
9	spotc	"                          Adaptor column"	1	1-100 1+
10	spotC	"                        Adaptor contrast"	0	0-100 1+
11	spotP	"                     Adaptor probability"	35	0-100 1+
