#
#	stim2Pulses2DurRandNoise	
#
#
foo nonperiodic	17
#
0  dur		"Stimulus duration		(s*10)"	   20	1-6000	1+
1  Vamp		"Pulse amplitude		(mV)"	   3300	0-5000	1+
2  durT1	"1st Pulse duration 		(ms*10)"   5	1-10000	1+
3  durT2	"2nd Pulse duration 		(ms*10)"   5	1-10000	1+
4  intT		"Pulse-to-pulse interval	(ms)"	   2	0-5000	1+
5  trigType	"Manual(1), HwDigital(2), Immediate(3)"	   2	1-3	1+
6  pulseType    "BB(1), GG(2), BG(3), GB(4); B: A0, G: A1" 1    1-4     1+ 
7  Tp           "Time of pulse          (ms)",          500     1-10000 1+
8  x1   "Left border from center        (deg*10)"      -400    -1000-500 1+
9  x2   "Right border from center       (deg*10)"       1000   -500-1000 1+
10 y1   "Bottom border from center      (deg*10)"      -400    -1000-500 1+
11 y2   "Top border from center         (deg*10)"       400    -500-1000 1+
12 nfr  "Number of frames per stimulus"                 10      1-70      1+
13 sqsz "Size of squares                (deg*10)"       30      1-100     1+
14 ncs  "Number of contrasts (choose 2 for b&w)"        3       2-16      1+
15 c    "Contrast                       (%)"            100     0-100     1+
16 seedw        "White noise random # seed"             1       1-100     1+
