#
#	stimGratingAndLaser_GalvoTest
#
#
foo nonperiodic	29
#
0	dur	"               Stimulus duration (s *10)"	20	1-12000 1+
1	tf	"             Temporal frequency (Hz *10)"	20	0-4000 1+
2	sf	"           Spatial frequency (cpd *1000)"	80	0-1000 1+
3	tph	"                    Temporal phase (deg)"	0	0-360 1+
4	sph	"                     Spatial phase (deg)"	0	0-360 1+
5	ori	"                       Orientation (deg)"	0	0-360 1+
6	dA	"                 Inner diameter (deg*10)"	0	0-1200 1+
7	dB	"                 Outer diameter (deg*10)"	200	0-2700 1+
8	xc	"                      Center, x (deg*10)"	-100	-1400-1400 1+
9	yc	"                      Center, y (deg*10)"	0	-450-450 1+
10	flck	"          Flickering (1) or drifting (0)"	0	0-1 1+
11	sqwv	"         Square wave (1) or sinusoid (0)"	0	0-1 1+
12	duty	"                       Duty cycle (*100)"	100	0-100 1+
13	shape	"             Rectangle (1) or circle (0)"	0	0-1 1+
14	cr	"                 Contrast of red gun (%)"	100	0-100 1+
15	cg	"               Contrast of green gun (%)"	100	0-100 1+
16	cb	"                Contrast of blue gun (%)"	100	0-100 1+
17	lr	"           Mean luminance of red gun (%)"	50	0-100 1+
18	lg	"         Mean luminance of green gun (%)"	50	0-100 1+
19	lb	"          Mean luminance of blue gun (%)"	50	0-100 1+
20	ton	"                  Onset of stimulus (ms)"	0	0-10000 1+
21	toff	"                 Offset of stimulus (ms)"	2000	0-100000 1+
22	tstart1	"                  WAVE1: Start time (ms)"	500	0-60000 1+
23	tend1	"                    WAVE1: End time (ms)"	1500	0-60000 1+
24	amp1	"                   WAVE1: Amplitude (mV)"	0	0-5000 1+
25	freq1	"      WAVE1: Frequency of pulses (Hz*10)"	10	0-1000 1+
26	tailDuration	"   WAVE1: Tail Duration (ms, 0 for none)"	200	0-10000 1+
27	trigtype	"   Manual(1), HwDigital(2), Immediate(3)"	1	1-3 1+
28	shape	"           Sine (1), GalvoSimulation (2)"	1	1-2 1+
