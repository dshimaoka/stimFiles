#
#	stimTTLChirp
#
#
foo nonperiodic	5
#
0	dur	"                Stimulus duration (s*10)"	20	1-12000 1+
1	WaveAmp	"         Amplitude of sinusoidal wave (mV*1000)"	100	0-5000 1+
2	WaveFreqInit	"          Initial Wave Frequency (Hz*1000)"	1	0-200000 1+
3	WaveFreqLast	"          Last Wave Frequency (Hz*1000)"	1	0-200000 1+
4	chirpType	"          '0:linear, 1:exponential"	1	0-1 1+

