#
#	stimVisTTLWave
#
#
foo nonperiodic	23
#
0	dur	"                Stimulus duration (s*10)"	50	1-600 1+
1	TTL	"                    Switch of TTL (0 1)"	0	0-1 1+
2	WaveAmp	"         Amplitude of sinusoid (mV*1000)"	0	0-5000 1+
3	TTLStart	"         Time of TTL onset (ms)"	0	0-60000 1+
4	TTLStop	"        Time of TTL offset (ms)"	0	0-60000 1+
5	TTLFreq	"          TTL Frequency (Hz*10)"	0	0-20000 1+
6	TTLDurOn	"           TTL On duration (ms)"	0	0-1000 1+
7	WaveStart	"         Time of Wave onset (ms)"	0	0-60000 1+
8	WaveStop	"        Time of Wave offset (ms)"	0	0-60000 1+
9	WaveFreq	"          Wave Frequency (Hz*10)"	0	0-20000 1+
10	WaveDurOn	"           Wave On duration (ms)"	0	0-1000 1
11	ToneFreq	"       Tone Freq of wave (Hz*10)"	0	0-1000000	1+
12	tf	"              Temporal frequency (Hz*10)"	20	1-200 1+
13	sf	"             Spatial frequency (cpd*100)"	10	0-1000 1+
14	c	"                            Contrast (%)"	100	0-100 1+
15	ori	"                       Orientation (deg)"	0	0-360 1+
16	dim1	"                       Diameter (deg*10)"	1	0-500 1+
17	dim2	"                       Diameter (deg*10)"	400	1-500 1+
18	x	"              Focus position, x (deg*10)"	0	-900-900 1+
19	y	"              Focus position, y (deg*10)"	0	-300-300 1+
20	ton	"                          onset time(ms)"	1000	1-6000 1+
21	toff	"                         offset time(ms)"	4000	1-6000 1+
22	shape	"            shape (0 = circle; 1 = rect)"	0	0-1 1+
