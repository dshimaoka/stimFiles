#
#	stimTTWaveOutput
#
#
foo nonperiodic	12
#
0	dur	"                Stimulus duration (s*10)"	10	1-600 1+
1	TTL	"                    Switch of TTL (0-1)"	0	0-1 1+
2	WaveAmp	"         Amplitude of sinusoid (mV*1000)"	100	0-5000 1+
3	TTLStart	"         Time of TTL onset (ms)"	2000	0-60000 1+
4	TTLStop	"        Time of TTL offset (ms)"	4000	0-60000 1+
5	TTLFreq	"          TTL Frequency (Hz*10)"	4400	0-20000 1+
6	TTLDurOn	"           TTL On duration (ms)"	20	0-1000 1+
7	WaveStart	"         Time of Wave onset (ms)"	2000	0-60000 1+
8	WaveStop	"        Time of Wave offset (ms)"	4000	0-60000 1+
9	WaveFreq	"          Wave Frequency (Hz*10)"	4400	0-20000 1+
10	WaveDurOn	"           Wave On duration (ms)"	20	0-1000 1
11	ToneFreq	"       Tone Freq of wave (Hz*10)"	200	0-1000000	1+