#
#	visgratgauss.x
#
#		for gratings multiplied by Gaussians
#		2002-05 Matteo Carandini
#

foo periodic	17

#

0	dur		"Stimulus duration (s *10)"		10	1-600 1+
1	x		"Center, x (deg*10)"			0	-1000-1000 1+
2	y		"Center, y (deg*10)"			0	-1000-1000 1+
3	ldiam		"Diameter Luminance Patch (deg*10)"	100	1-500 1+
4	lsigma		"Width Luminance Gaussian (deg*10)"	20	0-200 1+
5	lbase		"Base luminance (%)"			50	0-100 1+
6	linstep		"Luminance increment at center (%)"	0	-100-100 1+
7	loutstep	"Luminance increment at periphery (%)"	0	-100-100 1+
8	cdiam		"Diameter Contrast Patch (deg*10)"	100	1-500 1+
9	csigma		"Width Contrast Gaussian (deg*10)"	20	0-200 1+
10	cbase		"Base contrast at center (%)"		50	0-100 1+
11	cinstep		"Contrast increment at center (%)"	0	-100-100 1+
12	coutstep	"Contrast increment at periphery (%)"	50	-100-100 1+
13	tf		"Temporal frequency (Hz *10)"		40	1-400 1+
14	sf100		"Spatial frequency (cpd *100)"		70	1-2000 1+
15	ph		"Phase (deg)"				45	0-360 1+
16	ori		"Orientation (deg)"			90	0-360 1+

	

