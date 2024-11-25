function SS = stimWavePulseVisPulseOne_IC1013(myScreenInfo,Pars)
% stimWavePulseVisPulseOne_IC1013b makes a visual stimulus pulse
% and a waveout pulse that can be triggered by photodiode
%
% SS = stimWavePulseVisPulseOne_IC1013b(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimWavePulseVisPulsePlaidsOne_IC1013b(myScreenInfo) uses the default parameters
%
% 2011-03 MC wrote stimFlashedBarWaveOutput.m
% 2012-02 ND modified to create stimWavePulseVisPulse.m
% 2013-10 IC modified so it uses oglOneGrating_IC1013.m (one grating only) and
% stimOptWaveOutputIC1013 (blue light trigger by photodiode)

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)', 50, 1, 600};
pp{2}  = {'tf1',	'Patch 1: Temporal frequency (Hz *10)', 40, 1, 400};
pp{3}  = {'sf1',	'Patch 1: Spatial frequency (cpd *100)', 10, 1, 200};
pp{4}  = {'tph1',	'Patch 1: Temporal phase (deg)', 0, 0, 360};
pp{5}  = {'sph1',	'Patch 1: Spatial phase (deg)', 0, 0, 360};
pp{6}  = {'c1',		'Patch 1: Contrast (%)', 50, 0, 100};
pp{7}  = {'ori1',	'Patch 1: Orientation (deg)', 45, 0, 360};
pp{8}  = {'dima1',	'Patch 1: Inner Diam or Size X (deg*10)', 30, 0, 1199};
pp{9}  = {'dimb1',	'Patch 1: Outer Diam or Size Y (deg*10)', 100, 1, 1200};
pp{10} = {'x1',         'Patch 1: Center, x (deg*10)', 0, -1000, 1000};
pp{11} = {'y1',         'Patch 1: Center, y (deg*10)', 0, -500, 500};
pp{12} = {'flick1', 	'Patch 1: Drift (0) or Flicker (1)', 0, 0, 1};
pp{13} = {'sqwv1',	'Patch 1: Sine (0) or Square (1)', 0, 0, 1};
pp{14} = {'duty1',	'Patch 1: Duty cycle (%)', 100, 1, 100}; 
pp{15} = {'shape1',	'Patch 1: Annulus (0) or Rectangle (1)', 0, 0, 1};
pp{16} = {'tonwav',      'Onset time for wave (ms)', 500, 0, 6000};
pp{17} = {'toffwav',     'Offset time for wave (ms)', 900, 0, 6000};
pp{18} = {'WavSineAmp',  'WAVE: Amplitude of sinusoid (mV)', 1, 0, 5000};
pp{19} = {'WavSineFreq', 'WAVE: Frequency (Hz*10)', 4400, 0, 20000};
pp{20} = {'WavMean',     'WAVE: Value at 1st event (mV)', 1000, 0, 5000};

x = XFile('stimWavePulseVisPulseOne_IC1013',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% get the parameters relevant for the visual stimulus and the wave

% IC first for the visual stimulus (see oglOneGrating_IC1013.x)
ParsVis = Pars([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]);

% next for the Wav (see stimWaveOutputIC1013.x)
% IC setting t4 to Pars(1)*100-5 will cause the stimulus to misbehave if 
% toffwav is the same as dur
ParsWav = [Pars([1 18 19]); Pars([16 20 17 20 17]); 0; Pars(1)*100-5; 0; 2];
%ParsWav = [Pars([1 18 19]); Pars([16 20 17 20 17]); 0; Pars(17); 0; 2];

myScreenStimVis=ScreenStim.Make( myScreenInfo,'oglOneGrating_IC1013',ParsVis );
myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimWaveOutputIC1013',ParsWav );
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;

return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimWavePulseVisPulseOne_IC1013'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
