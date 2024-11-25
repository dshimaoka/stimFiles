function SS = stimOptiWaveGratingWithMask_MP(myScreenInfo,Pars)
% stimOptiWaveGratingWithMask_MP makes a waveoutput pulse and a visual stimulus pulse
% This is a merge of stimGratingWithMask.m and stimOptiWaveOutput_NS.m

% SS = stimOptiWaveGratingWithMask_MP(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimOptiWaveGratingWithMask_MP(myScreenInfo) uses the default parameters
%
% 2013-10 MP created by modifying stimOptiWaveFlickChecks_NS.m

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',      'Total duration (s *10)',           13,1,600};
pp{2}  = {'tf',       'Temporal frequency (Hz *10)',      20,0,4000};
pp{3}  = {'sf',       'Spatial frequency (cpd *1000)',    80,0,1000};
pp{4}  = {'tph',      'Temporal phase (deg)',             0,0,360};
pp{5}  = {'sph',      'Spatial phase (deg)',              0,0,360};
pp{6}  = {'ori',      'Orientation (deg)',                0,0,360};
pp{7}  = {'diam',     'Diameter (deg*10)',                1400,0,2800};
pp{8}  = {'xc',       'Center, x (deg*10)',               0,-1400,1400};
pp{9}  = {'yc',       'Center, y (deg*10)',               0,-450,450};
pp{10} = {'flck',     'Flickering (1) or drifting (0)',   0,0,1};
pp{11} = {'sqwv',     'Square wave (1) or sinusoid (0)',  0,0,1};
pp{12} = {'shape',    'Rectangle (1) or circle (0)',      1,0,1};
pp{13} = {'tstart',   'Start time (ms)',                  300,0,60000};
pp{14} = {'tend',     'End   time (ms)',                  1300,0,60000};
pp{15} = {'ctst',     'Contrast (%)',                     20,0,100};
pp{16} = {'lum',	  'Mean luminance (%)',               20,0,100};
nparvis = numel(pp);

pp{nparvis+1}  = {'tstart1',    'Laser: Start time (ms)',                  50,  0,60000};
pp{nparvis+2}  = {'tend1',      'Laser: End time (ms)',                    800, 0,60000};
pp{nparvis+3}  = {'amp1',       'Laser: Amplitude (mV)',                   0,   0,5000};
pp{nparvis+4}  = {'tstart2',    'Puff: Start time (ms)',                   0,   0,60000};
pp{nparvis+5}  = {'tend2',      'Puff: End time (ms)',                     100, 0,60000};
pp{nparvis+6}  = {'amp2',       'Puff: Amplitude (mV)',                    0,   0,5000};
pp{nparvis+7}  = {'trigtype',   'Manual(1), HwDigital(2), Immediate(3)',   1,   1,3};

x = XFile('stimOptiWaveGratingWithMask_MP',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% get the parameters relevant for the visual stimulus and the wave

% ParsVis = [Pars(1:nparvis-2); 100; 100; 100; 50; 50; 50; Pars(nparvis-1:nparvis)];
ParsVis = [Pars(1:nparvis-2); repmat(Pars(nparvis-1), 3, 1); repmat(Pars(nparvis), 3, 1)];
ParsWav = [Pars(1); Pars(nparvis + (1:7))];

myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimOptiWaveOutput_MP', ParsWav);
myScreenStimVis = ScreenStim.Make( myScreenInfo,'stimGratingWithMask_MP',   ParsVis);
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;
% keyboard;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimOptiWaveFlickChecks'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
