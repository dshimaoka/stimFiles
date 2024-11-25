#
#	oglRandpos_sparse2_alphaTS2.x
#
#	noise stimulus that varies the position of a bar
#	random phase assignment.
#	blanks and adapters in stimulus.
#	overlap parameter.
#	can limit width and specify center of array (x-dimension)
#

foo nonperiodic	13

#

0	dur		"Stimulus duration (s *10)"		200	1-1800 1+
1	c		"Contrast (%)"				100	0-100 1+
2	width		"Width of bars (deg *10)"		150	1-200 1+
3	overlap		"Overlap of stimuli (%)"		50	0-99 1+
4	baseori		"Base orientation of stimuli (deg)"	0	0-179 1+
5	seed		"Seed for random number generator"	1	1-32700 1+
6	nfr		"Number of interpolated frames"		25	1-75 1+
7	bprob_orig	"Base blank probability (%)"		1   	0-100 1+
8	ac		"Adaptor contrast (%)"			0	0-100 1+
9	aprobfactor	"Adaptor probability factor (%)"	0	0-2000 1+
10	apos		"Adaptor position (deg *10)"		0	-1000-1000 1+
11	arraywidth	"Width of stimulus array (deg*10)"	900	20-1000 1+
12	array_ctr	"Array offset from screen ctr (deg*10)"	0	-800-800 1+