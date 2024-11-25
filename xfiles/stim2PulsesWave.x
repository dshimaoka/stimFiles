#
#	stim2PulsesWave
#
#
foo nonperiodic	6
#
0  dur		"Stimulus duration		(s*10)"	 20	1-6000	1+
1  Vamp		"Pulse amplitude		(mV)"	 3300	0-5000	1+
2  durT		"Pulse duration 		(ms*10)" 5	1-5000	1+
3  intT		"Pulse-to-pulse interval	(ms)"	 2	1-5000	1+
4  trigType	"Manual(1), HwDigital(2), Immediate(3)"	 2	1-3	1+
5  seed         "Random number generator seed"           0      0-100   1+
