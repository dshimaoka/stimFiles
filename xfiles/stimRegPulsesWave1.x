#
#	stimRegPulsesWave1
#
#
foo nonperiodic	6
#
0  dur		"Stimulus duration	(s*10)"		50	1-6000	1+
1  Vamp		"Pulse amplitude	(mV)"		2000	0-5000	1+
2  f		"Frequency of pulses	(Hz*10)"	200	0-20000 1+
3  durT		"Pulse duration 	(ms*10)"	5	1-1000	1+
4  seed		"Random number generator seed"		1	1-100	1+
5  trigType	"Manual(1), HwDigital(2), Immediate(3)"	2	1-3	1+
