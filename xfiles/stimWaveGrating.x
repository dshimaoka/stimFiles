#
#      stimWaveGrating 
#
#	1 gratings in 1 windows + wave pulse
#
foo periodic 19	
#

0	dur		"Stimulus duration (s*10)"		20 1-600 1+
1	tf1		"Patch: Temporal frequency (Hz *10)"	40 1-400 1+
2	sf1		"Patch: Spatial frequency (cpd *100)"	10 1-200 1+
3 	tph1		"Patch: Temporal phase (deg)"		0 0-360 1+
4 	sph1		"Patch: Spatial phase (deg)"		0 0-360 1+
5	c1		"Patch: Contrast (%)"			50 0-100 1+
6	ori1		"Patch: Orientation (deg)"		90 0-360 1+
7 	dima1		"Patch: Inner Diam or Size X (deg*10)"  30 0-1199 1+
8	dimb1		"Patch: Outer Diam or Size Y (deg*10)" 100 1-1200 1+
9	x1		"Patch: Center, x (deg*10)"		 0 -1000-1000 1+
10	y1		"Patch: Center, y (deg*10)"		 0 -500-500 1+
11	flick1 		"Patch: Drift (0) or Flicker (1)"	 0	0-1 1+
12	sqwv1		"Patch: Sine (0) or Square (1)"	 0	0-1 1+
13	duty1 		"Patch: Duty cycle (%)"		 100	1-100 1+
14	shape1 		"Patch: Annulus (0) or Rectangle (1)"	 0	0-1 1+
15  Vamp         "Pulse amplitude        (mV)"           3300    0-5000  1+
16  LaserOn      "Laser on time          (ms*10)"        0       0-5000  1+
17  LaserOff     "Laser off time         (ms*10)"        1000    0-50000 1+
18  trigType     "Manual(1), HwDigital(2), Immediate(3)" 2       1-3     1+

