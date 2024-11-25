#
#	stimCorrectedKalatsky
#
#
foo nonperiodic	14
#
0	dur	"               Stimulus duration (s *10)"	50  1-600 1+
1	start	"                    Stimulus start (deg)"	0	-180-180 1+
2	end	"                      Stimulus end (deg)"	360	-180-180 1+
3	tf	"            Temporal frequency (Hz *100)"	1	1-400 1+
4	sf	"            Spatial frequency (cpd *100)"	20	1-200 1+
5	dir	"                   Direction of movement"	1	-1-1 1+
6	cyN	"                 Cycles number (integer)"	1	1-100 1+
7	flickfreq	"  Temporal frequency of flicker (Hz *10)"	40 0-400 1+
8	maxL	"                 Contrast of guns (%)"	100	0-100 1+
9	meanL	"           Mean luminance of guns (%)"	50	0-100 1+
10	ori	"         Orientation (xpos = 1;ypos = 2)"  1   1-2 1+
11  lumFactor   "Luminance Correction factor (0(nothing)-1(full correction))"   0   0-10 1+   