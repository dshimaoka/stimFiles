function SS = stimImgloadWave(myScreenInfo,Pars)
% stimImgloadWave makes a waveoutput pulse and a visual stimulus pulse
% This is a merge of stimOptiWaveOutput_MP.m and stimLoadImg3.m
% Can be used to load any image (set) saved on local disk

% SS = stimImgloadWave(myScreenInfo,Pars) returns an object SS of type ScreenStim
% SS = stimImgloadWave(myScreenInfo) uses the default parameters
%
% 2016-04 MP created 

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',    'Stimulus duration (s *10)',              2,1,18000};
pp{2}  = {'x1',     'Left border, from center (deg*10)',     -1400,-1400,1400};
pp{3}  = {'x2',     'Right border, from center (deg*10)',     1400,-1400,1400};
pp{4}  = {'y1',     'Bottom border, from center (deg*10)',   -1000,-1000,1000};
pp{5}  = {'y2',     'Top border, from center (deg*10)',       1000,-1000,1000};
pp{6}  = {'c',      'Contrast (%)',                           100,0,100};
pp{7}  = {'seed',   'Seed of random number generator',        1,1,1000};
pp{8}  = {'repn',   'which image in the sequence (0 is random)',1,0,10000};
pp{9}  = {'ip',     'which image database',                   1,1,1000};
pp{10}  = {'nimg',  'total number of images',                 1400,1,10000};
pp{11}  = {'pbl',   'percentage blanks',                      5,1,100};
nparvis = numel(pp);

pp{nparvis+1}  = {'tstart1',    'Wave1: Start time (ms)',                  50,  0,60000};
pp{nparvis+2}  = {'tend1',      'Wave1: End time (ms)',                    800, 0,60000};
pp{nparvis+3}  = {'amp1',       'Wave1: Amplitude (mV)',                   0,   0,5000};
pp{nparvis+4}  = {'tstart2',    'Wave2: Start time (ms)',                  0,   0,60000};
pp{nparvis+5}  = {'tend2',      'Wave2: End time (ms)',                    100, 0,60000};
pp{nparvis+6}  = {'amp2',       'Wave2: Amplitude (mV)',                   0,   0,5000};
pp{nparvis+7}  = {'trigtype',   'Manual(1), HwDigital(2), Immediate(3)',   1,   1,3};

x = XFile('stimImgloadWave',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters
if isempty(Pars)
    Pars = x.ParDefaults;
end
%% get the parameters relevant for the visual stimulus and the wave

ParsVis = Pars(1:nparvis);
ParsWav = [Pars(1); Pars(nparvis + (1:7))];

myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimOptiWaveOutput_MP', ParsWav);
myScreenStimVis = ScreenStim.Make( myScreenInfo,'stimLoadImg3',   ParsVis);
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;
% keyboard;
try
    SS              = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
end

SS.Type         = x.Name;
SS.Parameters   = Pars;

return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimOptiWaveFlickChecks'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
