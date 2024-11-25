function SS = stimOptiWaveFlickChecks(myScreenInfo,Pars)
% stimOptiWaveFlickChecks makes a waveoutput pulse and a visual stimulus pulse
% This is a merge of oglFlickeringChecksTimed.m and stimOptiWaveOutput.m

% SS = stimOptiWaveFlickChecks(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimOptiWaveFlickChecks(myScreenInfo) uses the default parameters
%
% 2013-10 MK created by modifying stimWavePulseVisPulse.m

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);

pp{1}  = {'dur',        'Overall duration (s*10)',                 50,1,600};
pp{2}  = {'tf',         'Flicker temporal frequency (Hz*10)',      20,1,160};
pp{3}  = {'c',          'Contrast (%)',                            100,0,100};
pp{4}  = {'checkSize',  'Single square size (deg*10)',             145,5,900};
pp{5}  = {'width',      'Stimulus width (deg*10)',                 580,5,1800};
pp{6}  = {'ctr',        'Stimulus centre (deg*10)',                0,-900,900};
pp{7}  = {'sqwv',       'Sine (0) or Square (1)',                  1, 0, 1};
pp{8}  = {'tstart',     'Stim start time (s*10)',                  10,0,600};
pp{9}  = {'tend',       'Stim end time (s*10)',                    30,0,600};
pp{10} = {'tstart1',    'WAVE1: Start time (ms)',                  1000,0,60000};
pp{11} = {'tend1',      'WAVE1: End time (ms)',                    3000,0,60000};
pp{12} = {'amp1',       'WAVE1: Amplitude (mV)',                   5000,0,5000};
pp{13} = {'shape1',     'WAVE1: Ramp(1), Step(2) or Half-Sine(3)', 3,1,3};
pp{14} = {'freq1',      'WAVE1: Frequency of pulses (Hz*10)',      10,0,1000};
pp{15} = {'dcyc1',      'WAVE1: Pulses Duty Cycle (%*10)',         200, 0, 1000};
pp{16} = {'tstart2',    'WAVE2: Start time (ms)',                  1000,0,60000};
pp{17} = {'tend2',      'WAVE2: End time (ms)',                    3000,0,60000};
pp{18} = {'amp2',       'WAVE2: Amplitude (mV)',                   3000,0,5000};
pp{19} = {'shape2',     'WAVE2: Ramp(1), Step(2) or Half-Sine(3)', 1,1,3};
pp{20} = {'freq2',      'WAVE2: Frequency of pulses (Hz*10)',      0,0,1000};
pp{21} = {'dcyc2',      'WAVE2: Pulses Duty Cycle (%*10)',         200, 0, 1000};
pp{22} = {'trigtype',   'Manual(1), HwDigital(2), Immediate(3)',   1, 1, 3};

x = XFile('stimOptiWaveFlickChecks',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% get the parameters relevant for the visual stimulus and the wave

% first for the visual stimulus
% pp{1}  = {'dur',         'Overall duration (s*10)',             50,1,600};
% pp{2}  = {'tf',          'Flicker temporal frequency (Hz*10)',  20,1,160};
% pp{3}  = {'cont',        'Contrast (%)',                        100,0,100};
% pp{4}  = {'checkSize',   'Single square size (deg*10)',         145,5,900};
% pp{5}  = {'width',       'Stimulus width (deg*10)',             580,5,1800};
% pp{6}  = {'ctr',         'Stimulus centre (deg*10)',            0,-900,900};
% pp{7}  = {'sqwv',        'Sine (0) or Square (1)',              1, 0, 1};
% pp{8}  = {'tstart',      'Stim start time (s*10)',              10,0,600};
% pp{9}  = {'tend',        'Stim end time (s*10)',                30,0,600};

ParsVis = Pars(1:9);

% next for the Wav - parameters have to be like such
% pp{1}  = {'dur',         'Stimulus duration (s*10)',                70,1,600};
% pp{2}  = {'tstart1',     'Start time (ms)',                         1000,0,60000};
% pp{3}  = {'tend1',       'End time (ms)',                           6000,0,60000};
% pp{4}  = {'amp1',        'Amplitude (mV)',                          5000,0,5000};
% pp{5}  = {'shape1',      'Ramp(1), Step(2) or Half-Sine(3)',        3,1,3};
% pp{6}  = {'freq1',       'Frequency of pulses (Hz*10)',             10,0,1000};
% pp{7}  = {'dcyc1',       'Pulses Duty Cycle (%*10)',                200, 0, 1000};
% pp{8}  = {'tstart2',     'Start time (ms)',                         1000,0,60000};
% pp{9}  = {'tend2',       'End time (ms)',                           6000,0,60000};
% pp{10}  = {'amp2',       'Amplitude (mV)',                          3000,0,5000};
% pp{11}  = {'shape2',     'Ramp(1), Step(2) or Half-Sine(3)',        1,1,3};
% pp{12}  = {'freq2',      'Frequency of pulses (Hz*10)',             0,0,1000};
% pp{13}  = {'dcyc2',      'Pulses Duty Cycle (%*10)',                200, 0, 1000};
% pp{14}  = {'trigtype',   'Manual(1), HwDigital(2), Immediate(3)',   1, 1, 3};
ParsWav = [Pars(1); Pars(10:22)];

myScreenStimVis = ScreenStim.Make( myScreenInfo,'oglFlickeringChecksTimed', ParsVis);
myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimOptiWaveOutput', ParsWav);
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimOptiWaveFlickChecks'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
