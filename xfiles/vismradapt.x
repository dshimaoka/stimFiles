#
#	vismradapt.x
#
#		for drifting sine gratings in circular windows.
#		for adaptation experiments that simulate the events in the mr scan
#

foo periodic	14

#

0	dur		"Stimulus duration (s *10)"	40	1-600 1+
1	tf		"Temporal frequency (Hz *10)"	40	1-400 1+
2	sf		"Spatial frequency (cpd *10)"	10	1-200 1+
3	x		"Center, x (deg*10)"		0	-200-200 1+
4	y		"Center, y (deg*10)"		0	-200-200 1+
5	diam		"Diameter (deg*10)"		20	0-200 1+
6	cadapt		"Contrast of adaptor (%)"	75	0-100 1+
7	oriadapt	"Orientation of adaptor (deg)"	90	0-360 1+
8	ctest		"Contrast of test (%)"		20	0-100 1+
9	oritest		"Orientation of test (deg)"	0	0-360 1+
10	ntests		"Number of test stimuli"	1	0-10 1+
11 	testdur		"Duration of test stimuli (s *10)"	10	1-600 1+
12 	blankdur	"Duration of blank stimuli (s *10)"	10	1-600 1+
13 	revdur		"Interval between reversals (s *10)"	5	1-600 1+


	

