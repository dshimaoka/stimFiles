function SS = vmovie3sequentialGrating_stimOptiWave(myScreenInfo,Pars)
% stimOptiWaveFlickChecks makes a waveoutput pulse and a visual stimulus pulse
% This is a merge of oglFlickeringChecksTimed.m and stimOptiWaveOutput.m

% SS = stimOptiWaveFlickChecks(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimOptiWaveFlickChecks(myScreenInfo) uses the default parameters
%
% 2020-09 DS created
%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);

pp{1}  = {'dur',	'Stimulus duration (s *10)',		60,	1,1200};
pp{2}  = {'swT1',		'Time of switch from 1 to 2 (s *10)',	20,	1,1200};
pp{3}	  = {'swT2',		'Time of switch from 2 to 3 (s *10)',	40,	1,1200};
pp{4} 	  = {'dima',		'Inner Diam or Size X (deg *10)',	30,	0,2000};
pp{5}	  = {'dimb',		'Outer Diam or Size Y (deg *10)',	100,	1,2000};
pp{6}	  = {'x',		'Center, x (deg *10)',			-50,	-1500,1500};
pp{7}	  = {'y',		'Center, y (deg *10)',			0,	-800,800};
pp{8}	  = {'flick', 		'Drift (0) or s-Flicker (1) or st-Flicker (2)',		1,	0,2};
pp{9}	  = {'sqwv',		'Sine (0) or Square (1)',		1,	0,1};
pp{10}	  = {'shape', 		'Annulus (0) or Rectangle (1)',		1,	0,1};
pp{11}	  = {'tf1',		'Patch 1: Temporal frequency (Hz *10)',	40,	1,400};
pp{12}	  = {'sf1',		'Patch 1: Spatial frequency (cpd *100)',	10,	1,200};
pp{13}	  = {'tph1',		'Patch 1: Temporal phase (deg)',		0,	0,360};
pp{14}	  = {'sph1',		'Patch 1: Spatial phase (deg)',		0,	0,360};
pp{15}	  = {'c1',		'Patch 1: Contrast (%)',			50,	0,100};
pp{16}	  = {'ori1',		'Patch 1: Orientation (deg)',		90,	0,360};
pp{17}	  = {'tf2',		'Patch 2: Temporal frequency (Hz *10)',	50,	1,400};
pp{18}	  = {'sf2',		'Patch 2: Spatial frequency (cpd *100)',	50,	1,200};
pp{19} 	  = {'tph2',		'Patch 2: Temporal phase (deg)',		0,	0,360};
pp{20}	  = {'sph2',		'Patch 2: Spatial phase (deg)',		0,	0,360};
pp{21}	  = {'c2',		'Patch 2: Contrast (%)',			50,	0,100};
pp{22}	  = {'ori2',		'Patch 2: Orientation (deg)',		0,	0,360};
pp{23}	  = {'tf3',		'Patch 3: Temporal frequency (Hz *10)',	50,	1,400};
pp{24}	  = {'sf3',		'Patch 3: Spatial frequency (cpd *100)',	50,	1,200};
pp{25}	  = {'tph3',		'Patch 3: Temporal phase (deg)',		0,	0,360};
pp{26}	  = {'sph3',		'Patch 3: Spatial phase (deg)',		0,	0,360};
pp{27}	  = {'c3',		'Patch 3: Contrast (%)',			50,	0,100};
pp{28}	  = {'ori3',		'Patch 3: Orientation (deg)',		45,	0,360};

pp{29} = {'tstart1',    'WAVE1: Start time (ms)',                  1000,0,60000};
pp{30} = {'tend1',      'WAVE1: End time (ms)',                    3000,0,60000};
pp{31} = {'amp1',       'WAVE1: Amplitude (mV)',                   0,0,5000};
pp{32} = {'shape1',     'WAVE1: Ramp(1), Step(2) or Half-Sine(3)', 3,1,3};
pp{33} = {'freq1',      'WAVE1: Frequency of pulses (Hz*10)',      10,0,1000};
pp{34} = {'dcyc1',      'WAVE1: Pulses Duty Cycle (%*10)',         200, 0, 1000};
pp{35} = {'tstart2',    'WAVE2: Start time (ms)',                  1000,0,60000};
pp{36} = {'tend2',      'WAVE2: End time (ms)',                    3000,0,60000};
pp{37} = {'amp2',       'WAVE2: Amplitude (mV)',                   0,0,5000};
pp{38} = {'shape2',     'WAVE2: Ramp(1), Step(2) or Half-Sine(3)', 1,1,3};
pp{39} = {'freq2',      'WAVE2: Frequency of pulses (Hz*10)',      0,0,1000};
pp{40} = {'dcyc2',      'WAVE2: Pulses Duty Cycle (%*10)',         200, 0, 1000};
pp{41} = {'trigtype',   'Manual(1), HwDigital(2), Immediate(3)',   1, 1, 3};

x = XFile('vmovie3sequentialGrating_stimOptiWave',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% get the parameters relevant for the visual stimulus and the wave

% first for the visual stimulus
ParsVis = Pars(1:28);

% next for the Wav - parameters have to be like such
ParsWav = [Pars(1); Pars(29:41)];

myScreenStimVis = ScreenStim.Make( myScreenInfo,'vmovie3sequentialGrating', ParsVis);
myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimOptiWaveOutput_DS', ParsWav);
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'vmovie3sequentialGrating_stimOptiWave'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
