#
#	stimCorrectedKalatsky2_bilateral
#
#
foo nonperiodic	13
#
0	dur	"               Stimulus duration (s *10)"	1  1-600 1+
1	bdur	"	blank duration of each sweep (ms)"	500	1-600	1+
2	start	"                    Stimulus start (deg)"	0	-450-450 1+
3	end	"                      Stimulus end (deg)"	0	-450-450 1+
4	tf	"            Temporal frequency (Hz *100)"	400	1-400 1+
5	sf	"            Spatial frequency (cpd *100)"	20	1-200 1+
6	dir	"                   Direction of movement"	1	-1-1 1+
7	cyN	"                 Cycles number (integer)"	1	1-100 1+
8	flickfreq	"  Temporal frequency of flicker (Hz *10)"	40 0-400 1+
9	maxL	"                 Contrast of guns (%)"	100	0-100 1+
10	meanL	"           Mean luminance of guns (%)"	50	0-100 1+
11	ori	"         Orientation (xpos = 1;ypos = 2; eccentricity = 3; polar = 4)"  1   1-4 1+
12  lumFactor   "Luminance Correction factor (0(nothing)-1(full correction))"   0   0-10 1+