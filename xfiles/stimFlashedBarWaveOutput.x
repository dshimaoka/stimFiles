#
#	stimFlashedBarWaveOutput
#
#
foo nonperiodic	19
#
0	dur	"               Stimulus duration (s *10)"	50	1-600 1+
1	ori	"                       Orientation (deg)"	45	0-360 1+
2	len	"                     Bar length (deg*10)"	300	1-900 1+
3	wid	"                      Bar width (deg*10)"	50	1-900 1+
4	pos	"     Position relative to focus (deg*10)"	200	-900-900 1+
5	xfocus	"              Focus position, x (deg*10)"	-300	-900-900 1+
6	yfocus	"              Focus position, y (deg*10)"	0	-300-300 1+
7	ton1	"                      1st onset time(ms)"	500	1-6000 1+
8	toff1	"                     1st offset time(ms)"	1000	1-6000 1+
9	ton2	"                      2nd onset time(ms)"	1000	1-60000 1+
10	toff2	"                     2nd offset time(ms)"	1500	1-60000 1+
11	lum1	"                       1st luminance (%)"	50	-100-100 1+
12	lum2	"                       2nd luminance (%)"	-50	-100-100 1+
13	SineAmp	"        WAVE: Amplitude of sinusoid (mV)"	100	0-5000 1+
14	SineFreq	"                 WAVE: Frequency (Hz*10)"	4400	0-20000 1+
15	t1	"            WAVE: Time of 1st event (ms)"	1000	0-6000 1+
16	v1	"           WAVE: Value at 1st event (mV)"	1000	-5000-5000 1+
17	t2	"            WAVE: Time of 2nd event (ms)"	2000	0-60000 1+
18	v2	"           WAVE: Value at 2nd event (mV)"	0	-5000-5000 1+
