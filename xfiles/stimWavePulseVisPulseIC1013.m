function SS = stimWavePulseVisPulseIC1013(myScreenInfo,Pars)
% stimWavePulseVisPulse makes a waveoutut pulse and a visual stimulus pulse
%
% SS = stimWavePulseVisPulse(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimWavePulseVisPulse(myScreenInfo) uses the default parameters
%
% 2011-03 MC wrote stimFlashedBarWaveOutput.m
% 2012-02 ND modified to create stimWavePulseVisPulse.m

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',         'Stimulus duration (s *10)',        50,    1,    600};
pp{2}  = {'tonvis',      'Onset time for visual stim (ms)',  1000,  1,    6000};
pp{3}  = {'toffvis',     'Offset time for visual stim (ms)', 1500,  1,    6000};
pp{4}  = {'tonwav',      'Onset time for wave (ms)',         500,   0,    6000};
pp{5}  = {'toffwav',     'Offset time for wave (ms)',        900,   0,    6000};
pp{6}  = {'c1',          'Contrast visual stimulus',         50,    0,    100};
pp{7}  = {'ori1',        'Orientation (deg)',                45,    0,    360};
pp{8}  = {'sf1',         'Spatial frequency (deg*100)',      5,     0,    1000};
pp{9}  = {'tf1',         'Temporal frequency (Hz*10)',       10,    1,    200};
pp{10}  = {'dima1',      'Size1 visual stimulus (deg*10)',   0,   1,    500};
pp{11}  = {'dimb1',      'Size2 visual stimulus (deg*10)',   250,   1,    500};
pp{12}  = {'x1',         'Center, x (deg*10)',               0,    -900,  900};
pp{13}  = {'y1',         'Center, y (deg*10)',               0,    -300,  300};
pp{14} = {'WavSineAmp',  'WAVE: Amplitude of sinusoid (mV)', 1,   0,    5000};
pp{15} = {'WavSineFreq', 'WAVE: Frequency (Hz*10)',          4400,  0,    20000};
pp{16} = {'WavMean',     'WAVE: Value at 1st event (mV)',    1000,  0,    5000};
pp{17} = {'shape',       'shape (0 = circle; 1 = rect)',     0,     0,    1};

x = XFile('stimWavePulseVisPulseIC1013',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% get the parameters relevant for the visual stimulus and the wave

% first for the visual stimulus
% ppvis{1}  = {'dur',   'Stimulus duration (s *10)',    50,   1,   600};
% ppvis{2}  = {'tf1',   'Temporal frequency (Hz*10)',   40,   1,   200};
% ppvis{3}  = {'sf1',   'Spatial frequency (cpd*100)',  5,    0,   1000};
% ppvis{4}  = {'c1',    'Contrast (%)'                  50,   0,   100};
% ppvis{5}  = {'ori1',  'Orientation (deg)',            45,   0,   360};
% ppvis{6}  = {'dim1',  'Diameter (deg*10)'             250,  1,   500};
% ppvis{7}  = {'dim2',  'Diameter (deg*10)'             250,  1,   500};
% ppvis{8}  = {'x1',    'Focus position, x (deg*10)',   0,   -900, 900};
% ppvis{9}  = {'y1',    'Focus position, y (deg*10)',   0,   -300, 300};
% ppvis{10} = {'ton',   'onset time(ms)',               300,  1,   6000};
% ppvis{11} = {'toff',  'offset time(ms)',              1300, 1,   6000};
% ppvis{12} = {'shape', 'shape (0 = circle; 1 = rect)', 1,    0,   1};
ParsVis = Pars([1 9 8 6 7 10 11 12 13 2 3 17]);

% next for the Wav - parameters have to be like such
% ppwav{1}  = {'dur',       'Stimulus duration (s*10)',        50,1,600};
% ppwav{2}  = {'SineAmp',   'Amplitude of sinusoid (mV)',       100, 0, 5000};
% ppwav{3}  = {'SineFreq',  'Frequency (Hz*10)',               4400,0,20000};
% ppwav{4}  = {'t1',        'Time of 1st event (ms)',        2000,0,6000};
% ppwav{5}  = {'v1',        'Value at 1st event (mV)',      -1000,-5000,5000};
% ppwav{6}  = {'t2',        'Time of 2nd event (ms)',        3000,0,6000};
% ppwav{7}  = {'v2',        'Value at 2nd event (mV)',      -2000,-5000,5000};
% ppwav{8}  = {'t3',        'Time of 3rd event (ms)',        3000,0,6000};
% ppwav{9}  = {'v3',        'Value at 3rd event (mV)',       1000,-5000,5000};
% ppwav{10}  = {'t4',        'Time of 4th event (ms)',        4000,0,6000};
% ppwav{11}  = {'v4',        'Value at 4th event (mV)',       2000,-5000,5000};
ParsWav = [Pars([1 14 15]); Pars([4 16 5 16 5]); 0; Pars(1)*100-5; 0; 2];

myScreenStimVis = ScreenStim.Make( myScreenInfo,'stimFlashedGrat',ParsVis );
myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimWaveOutputIC1013',ParsWav );
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimWavePulseVisPulseIC1013'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
