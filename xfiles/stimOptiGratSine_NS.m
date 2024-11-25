function SS = stimOptiChecksSine_NS(myScreenInfo,Pars)
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

pp{1}  = {'dur',   'Stimulus duration (s *10)',    3,   1,   6000};
pp{2}  = {'tf1',   'Temporal frequency (Hz*10)',   10,   1,   200};
pp{3}  = {'sf1',   'Spatial frequency (cpd*100)',  5,    0,   1000};
pp{4}  = {'c1',    'Contrast (%)'                  50,  -100, 100};
pp{5}  = {'ori1',  'Orientation (deg)',            45,   0,   360};
pp{6}  = {'dim1',  'Diameter (deg*10)'             100,  1,   50000};
pp{7}  = {'dim2',  'Diameter (deg*10)'             250,  1,   50000};
pp{8}  = {'x1',    'Focus position, x (deg*10)',   0,   -900, 900};
pp{9}  = {'y1',    'Focus position, y (deg*10)',   0,   -300, 300};
pp{10} = {'ton',   'onset time(ms)',               100,  1,   6000};
pp{11} = {'toff',  'offset time(ms)',              200, 1,   6000};
pp{12} = {'shape', 'shape (0 = circle; 1 = rect)', 0,    0,   2};
pp{13} = {'tstart1',    'WAVE1: Start time (ms)',                  1000,0,60000};
pp{14} = {'tend1',      'WAVE1: End time (ms)',                    3000,0,60000};
pp{15} = {'amp1',       'WAVE1: Amplitude (mV)',                   0,0,5000};
pp{16} = {'freq1',      'WAVE1: Frequency of pulses (Hz*10)',      10,0,1000};
pp{17} = {'tailDuration',    'WAVE1: Tail Duration (ms, 0 for none)',   200, 0 10000}; 
pp{18} = {'trigtype',   'Manual(1), HwDigital(2), Immediate(3)',   1, 1, 3};

x = XFile('stimOptiGratSine_NS',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% get the parameters relevant for the visual stimulus and the wave

% first for the visual stimulus
%pp{1}  = {'dur',   'Stimulus duration (s *10)',    3,   1,   6000};
%pp{2}  = {'tf1',   'Temporal frequency (Hz*10)',   10,   1,   200};
%pp{3}  = {'sf1',   'Spatial frequency (cpd*100)',  5,    0,   1000};
%pp{4}  = {'c1',    'Contrast (%)'                  50,  -100, 100};
%pp{5}  = {'ori1',  'Orientation (deg)',            45,   0,   360};
%pp{6}  = {'dim1',  'Diameter (deg*10)'             100,  1,   50000};
%pp{7}  = {'dim2',  'Diameter (deg*10)'             250,  1,   50000};
%pp{8}  = {'x1',    'Focus position, x (deg*10)',   0,   -900, 900};
%pp{9}  = {'y1',    'Focus position, y (deg*10)',   0,   -300, 300};
%pp{10} = {'ton',   'onset time(ms)',               100,  1,   6000};
%pp{11} = {'toff',  'offset time(ms)',              200, 1,   6000};
%pp{12} = {'shape', 'shape (0 = circle; 1 = rect)', 0,    0,   2};

ParsVis = Pars(1:12);

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
ParsWav = [Pars(1); Pars(13:18)];

myScreenStimVis = ScreenStim.Make( myScreenInfo,'stimFlashedGrat_NS', ParsVis);
myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimOptiWaveOutputSineWithTail_NS', ParsWav);
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimOptiGratSine_NS'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
