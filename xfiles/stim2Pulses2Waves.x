#
#	stim2Pulses2Waves
#
#
foo nonperiodic	6
#
0  dur		"Stimulus duration		(s*10)"	   20	1-6000	1+
1  Vamp		"Pulse amplitude		(mV)"	   3300	0-5000	1+
2  durT		"Pulse duration 		(ms*10)"   5	1-5000	1+
3  intT		"Pulse-to-pulse interval	(ms)"	   2	0-5000	1+
4  trigType	"Manual(1), HwDigital(2), Immediate(3)"	   2	1-3	1+
5  pulseType    "BB(1), GG(2), BG(3), GB(4); B: A0, G: A1" 1    1-4     1+ 
