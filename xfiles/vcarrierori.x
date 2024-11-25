#
#	vcarrieriori.x
#
#		one big drifting grating that changes orientation slowly
#

foo periodic	7

#

0	dur		"Stimulus duration (s *10)"		20	1-2400 1+
1	nperiods	"Number of orientation cycles (+/-)"	-2	-60-60  1+
2	tf		"Temporal frequency (Hz *10)"		40	1-400 1+
3	sf100		"Spatial frequency (cpd *100)"		25	1-200 1+
4	ph		"Phase (deg)"				0	0-360 1+
5	c		"Contrast (%)"				50	0-50  1+
6	noris		"Number of orientations"		3	1-360  1+

