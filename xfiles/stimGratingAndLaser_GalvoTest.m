function SS = stimGratingAndLaser_GalvoTest(myScreenInfo,Pars)
% stimGratingAndLaserCommands makes a waveoutput pulse and a visual stimulus pulse
% This is a merge of stimGratingWithMask and stimOptiWaveOutputSineWithTail.m

% SS = stimGratingAndLaserCommands(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimGratingAndLaserCommands(myScreenInfo) uses the default parameters
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
pp{1}  = {'dur',      'Stimulus duration (s *10)',        20,1,12000};

pp{2}  = {'tf',       'Temporal frequency (Hz *10)',      20,0,4000};
pp{3}  = {'sf',       'Spatial frequency (cpd *1000)',    80,0,1000};
pp{4}  = {'tph',      'Temporal phase (deg)',             0,0,360};
pp{5}  = {'sph',      'Spatial phase (deg)',              0,0,360};
pp{6}  = {'ori',      'Orientation (deg)',                0,0,360};
pp{7}  = {'dA',       'Inner diameter (deg*10)',          0,0,1200};
pp{8}  = {'dB',       'Outer diameter (deg*10)',          200,0,2700};
pp{9}  = {'xc',       'Center, x (deg*10)',               -100,-1400,1400};
pp{10} = {'yc',       'Center, y (deg*10)',               0,-450,450};
pp{11} = {'flck',     'Flickering (1) or drifting (0)',   0,0,1};
pp{12} = {'sqwv',     'Square wave (1) or sinusoid (0)',  0,0,1};
pp{13} = {'duty',     'Duty cycle (*100)',                100,0,100};
pp{14} = {'shape',    'Rectangle (1) or circle (0)',      0,0,1};
pp{15} = {'cr',       'Contrast of red gun (%)',          100,0,100};
pp{16} = {'cg',	      'Contrast of green gun (%)',        100,0,100};
pp{17} = {'cb',	      'Contrast of blue gun (%)',         100,0,100};
pp{18} = {'lr',	      'Mean luminance of red gun (%)',    50,0,100};
pp{19} = {'lg',       'Mean luminance of green gun (%)',  50,0,100};
pp{20} = {'lb',       'Mean luminance of blue gun (%)',   50,0,100};
pp{21} = {'ton',      'Onset of stimulus (ms)',           0,0,10000};
pp{22} = {'toff',     'Offset of stimulus (ms)',          2000,0,100000};

pp{23} = {'tstart1',    'WAVE1: Start time (ms)',                  500,0,60000};
pp{24} = {'tend1',      'WAVE1: End time (ms)',                    1500,0,60000};
pp{25} = {'amp1',       'WAVE1: Amplitude (mV)',                   0,0,5000};
pp{26} = {'freq1',      'WAVE1: Frequency of pulses (Hz*10)',      10,0,1000};
pp{27} = {'tailDuration',    'WAVE1: Tail Duration (ms, 0 for none)',   200, 0 10000}; 
pp{28} = {'trigtype',   'Manual(1), HwDigital(2), Immediate(3)',   1, 1, 3};
pp{29} = {'shape',      'Sine (1), GalvoSimulation (2)',   1, 1, 2};

x = XFile('stimGratingAndLaser_GalvoTest',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% get the parameters relevant for the visual stimulus and the wave

ParsVis = Pars(1:22);

ParsWav = [Pars(1); Pars(23:29)];

myScreenStimVis = ScreenStim.Make( myScreenInfo,'stimGratingWithDelay', ParsVis);
myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimOptiWaveOutput_GalvoTest', ParsWav);
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);

SS.Type = x.Name;
SS.Parameters = Pars;
mm 	= Pars(18:20)/100;
SS.BackgroundColor = round(255 * mm);
SS.BackgroundPersists = true;

return

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimGratingAndLaser_GalvoTest(myScreenInfo);
show(SS, myScreenInfo);
Screen('CloseAll');
% myScreenStim = ScreenStim.Make(myScreenInfo,'stimOptiGratSine_NS'); %#ok<UNRCH>
% myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

 
