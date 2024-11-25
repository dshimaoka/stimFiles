#
#	stimATCGrat
#
#
foo nonperiodic	21
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	tf	"             Temporal frequency (Hz *10)"	40	1-400 1+
2	sf	"            Spatial frequency (cpd *100)"	10	1-200 1+
3	tph	"                    Temporal phase (deg)"	0	0-360 1+
4	sph	"                     Spatial phase (deg)"	0	0-360 1+
5	c	"                            Contrast (%)"	50	0-100 1+
6	ori	"                       Orientation (deg)"	45	0-360 1+
7	dima	"           Inner Diam or Size X (deg*10)"	30	0-1199 1+
8	dimb	"           Outer Diam or Size Y (deg*10)"	100	1-1200 1+
9	x	"                      Center, x (deg*10)"	0	-1000-1000 1+
10	y	"                      Center, y (deg*10)"	0	-500-500 1+
11	flick	"                Drift (0) or Flicker (1)"	0	0-1 1+
12	sqwv	"                  Sine (0) or Square (1)"	0	0-1 1+
13	duty	"                          Duty cycle (%)"	100	1-100 1+
14	shape	"            Annulus (0) or Rectangle (1)"	0	0-1 1+
15	SineAmp	"                  Amplitude of tone (mV)"	100	0-5000 1+
16	SineFreq	"                  Frequency of tone (Hz)"	9500	0-30000 1+
17	tTone	"    Time of onset of auditory event (ms)"	1000	0-60000 1+
18	durTone	"         Duration of auditory event (ms)"	350	0-1000 1+
19	durInt	"               Duration of interval (ms)"	250	0-600 1+
20	durPuff	"                   Duration of puff (ms)"	100	0-500 1+
