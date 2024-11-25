#
#	stimkalatskyauditory
#
#
foo nonperiodic	12
#
0	dur	"                   Stimulus duration (s*10)"	10	1-600 1+
1	WaveAmp	"            Amplitude of sinusoid (mV*1000)"	100	0-5000 1+
2	WaveStart	"            Time of wave onset (ms)"	2000	0-60000 1+
3	WaveStop	"            Time of wave offset (ms)"	4000	0-60000 1+
4	StairFreq	"       Slow staircase freq (Hz*100)"	20	1-400 1+
5	EnvFreq	"          Envelop Frequency for tone(Hz*10)"	60	1-200 1+
6	ToneOn	"               Duration of single tone (ms)"	50	1-1000 1+
7	minToneFreq	"            minimum tone freq (Hz)"	1000	1000-64000 1+
8	maxToneFreq	"            maximum tone freq (Hz)"	32000	1000-64000 1+
9	NumTones	"                    Number of tones"	1	1-64 1+
10	RiseTime	"	     Rise and fall time (ms)"	5	1-500	1+
11	Direction	"Tone direction. (1:ascending, 0:descending)"	1	0-1 1+
