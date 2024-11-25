#
#	stimVisTTL
#
#
foo nonperiodic	23
#
0	dur	"                Stimulus duration (s*10)"	100	1-600 1+
1	TTL1	"                    Switch of TTL1 (0 1)"	0	0-1 1+
2	WaveAmp	"         Amplitude of sinusoid (mV*1000)"	100	0-5000 1+
3	TTL1Start	"         Time of TTL1 onset (ms)"	2000	0-60000 1+
4	TTL1Stop	"        Time of TTL1 offset (ms)"	4000	0-60000 1+
5	TTL1Freq	"          TTL1 Frequency (Hz*10)"	4400	0-20000 1+
6	TTL1DurOn	"           TTL1 On duration (ms)"	20	0-1000 1+
7	WaveStart	"         Time of Wave onset (ms)"	2000	0-60000 1+
8	WaveStop	"        Time of Wave offset (ms)"	4000	0-60000 1+
9	WaveFreq	"          Wave Frequency (Hz*10)"	4400	0-20000 1+
10	WaveDurOn	"           Wave On duration (ms)"	20	0-1000 1
11	ToneFreq	"       Tone Freq of wave (Hz*10)"	200	0-1000000	1+
12	tf1	"              Temporal frequency (Hz*10)"	10	1-200 1+
13	sf1	"             Spatial frequency (cpd*100)"	5	0-1000 1+
14	c1	"                            Contrast (%)"	50	0-100 1+
15	ori1	"                       Orientation (deg)"	45	0-360 1+
16	dim1	"                       Diameter (deg*10)"	0	0-500 1+
17	dim2	"                       Diameter (deg*10)"	250	1-500 1+
18	x1	"              Focus position, x (deg*10)"	0	-900-900 1+
19	y1	"              Focus position, y (deg*10)"	0	-300-300 1+
20	ton	"                          onset time(ms)"	2000	1-6000 1+
21	toff	"                         offset time(ms)"	3000	1-6000 1+
22	shape	"            shape (0 = circle; 1 = rect)"	0	0-1 1+
