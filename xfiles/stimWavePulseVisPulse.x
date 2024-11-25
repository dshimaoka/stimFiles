#
#	stimWavePulseVisPulse
#
#
foo nonperiodic	17
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	tonvis	"         Onset time for visual stim (ms)"	1000	1-6000 1+
2	toffvis	"        Offset time for visual stim (ms)"	1500	1-6000 1+
3	tonwav	"                Onset time for wave (ms)"	500	0-6000 1+
4	toffwav	"               Offset time for wave (ms)"	900	0-6000 1+
5	c1	"                Contrast visual stimulus"	50	0-100 1+
6	ori1	"                       Orientation (deg)"	45	0-360 1+
7	sf1	"             Spatial frequency (deg*100)"	5	0-1000 1+
8	tf1	"              Temporal frequency (Hz*10)"	10	1-200 1+
9	dima1	"          Size1 visual stimulus (deg*10)"	0	0-500 1+
10	dimb1	"          Size2 visual stimulus (deg*10)"	250	1-500 1+
11	x1	"                      Center, x (deg*10)"	0	-900-900 1+
12	y1	"                      Center, y (deg*10)"	0	-300-300 1+
13	WavSineAmp	"        WAVE: Amplitude of sinusoid (mV)"	1	0-5000 1+
14	WavSineFreq	"                 WAVE: Frequency (Hz*10)"	4400	0-20000 1+
15	WavMean	"           WAVE: Value at 1st event (mV)"	1000	0-5000 1+
16	shape	"            shape (0 = circle; 1 = rect)"	0	0-1 1+
