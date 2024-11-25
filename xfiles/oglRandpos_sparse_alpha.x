#
#	oglRandpos_sparse_alpha.x
#
#	noise stimulus that varies the position of a bar
#	random phase assignment.
#	blanks and adapters in stimulus.
#	overlap parameter
#

foo nonperiodic	11

#

0	dur		"Stimulus duration (s *10)"		20	1-1800 1+
1	c		"Contrast (%)"				75	0-100 1+
2	width		"Width of bars (deg *10)"		40	1-200 1+
3	overlap		"Overlap of stimuli (%)"		0	0-99 1+
4	baseori		"Base orientation of stimuli (deg)"	0	0-179 1+
5	seed		"Seed for random number generator"	1	1-32700 1+
6	nfr		"Number of interpolated frames"		1	1-30 1+
7	bprob_orig	"Base blank probability (%)"		10   	0-100 1+
8	ac		"Adaptor contrast (%)"			50	0-100 1+
9	aprobfactor	"Adaptor probability factor (%)"	100	0-2000 1+
10	apos		"Adaptor position (deg *10)"		0	-500-500 1+
