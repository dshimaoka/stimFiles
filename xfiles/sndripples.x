#

#	sndripples.x

#		for ripple gabor sounds 

#

foo periodic	10

#

0	nfreqs		"n of frequencies in carrier"	128	1-256 1+

1	fctr		"carrier center frequency (Hz)"	4000 	1000-10000 1+

2	noct		"carrier range (octaves)"	5	1-7 1+

3	sf		"spatial frequency (10/oct)"	10	0-50 1+

4	ph		"spatial phase"			0	0-360 10+

5	tf		"temporal frequency (10*Hz)"	40	0-1000 1+

6	c		"contrast (%)"			50	0-100 1+

7	gctr		"center of gaussian window"	4000	1000-10000 1+

8	goct		"sigma of gaussian window"	8	1-8 1+

9	imean		"mean intensity"		1000	10-10000 1+

