#
#	vXYCMSeqGratVer2.x
#
#		square grating where the contrast polarity of small squares are modulated by mseq
#		contrast is now a variable
#

foo periodic	13

#

0	dur		"Stimulus duration (s *10)"		21	1-600 1+
1	sf100		"Spatial Frequency (cpd * 10)"		100	1-1000 1+
2	ori		"Orientation (deg)"			0	0-360 1+
3	sph		"Spatial Phase(deg)"			0	-180-180 1+
4	x		"Center, x (deg*10)"			0	-200-200 1+
5	y		"Center, y (deg*10)"			0	-200-200 1+
6	sqsz		"Small square size (deg*10)"		10	0-100 1+
7	nsquaresx	"Number of squares, x-dim"		3	1-15 2+
8	nsquaresy	"Number of squares, y-dim"		3	1-15 2+
9	nfrms		"Number of frames stim is constant"	1	1-50 1+
10	seed		"Which m-sequence do you want"		1	1-50 1+
11	cent		"Center Only?"				0	0-1 1+
12	c		"Contrast (%)"				50	0-100 1+



	

