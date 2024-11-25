#
#	stim2PulsesRandNoise	
#
#
foo nonperiodic	16
#
0  dur		"Stimulus duration		(s*10)"	   20	1-6000	1+
1  Vamp		"Pulse amplitude		(mV)"	   3300	0-5000	1+
2  durT		"Pulse duration 		(ms*10)"   5	1-5000	1+
3  intT		"Pulse-to-pulse interval	(ms)"	   2	0-5000	1+
4  trigType	"Manual(1), HwDigital(2), Immediate(3)"	   2	1-3	1+
5  pulseType    "BB(1), GG(2), BG(3), GB(4); B: A0, G: A1" 1    1-4     1+ 
6  Tp           "Time of pulse          (ms)",          500     1-10000 1+
7  x1   "Left border from center        (deg*10)"      -400    -1000-500 1+
8  x2   "Right border from center       (deg*10)"       1000   -500-1000 1+
9  y1   "Bottom border from center      (deg*10)"      -400    -1000-500 1+
10 y2   "Top border from center         (deg*10)"       400    -500-1000 1+
11 nfr  "Number of frames per stimulus"                 10      1-70      1+
12 sqsz "Size of squares                (deg*10)"       30      1-100     1+
13 ncs  "Number of contrasts (choose 2 for b&w)"        3       2-16      1+
14 c    "Contrast                       (%)"            100     0-100     1+
15 seedw        "White noise random # seed"             1       1-100     1+
