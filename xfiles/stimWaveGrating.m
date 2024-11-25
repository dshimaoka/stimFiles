function SS = stimWaveGrating(myScreenInfo,Pars)
% stimWaveGratingb makes a visual stimulus pulse
% and a waveout pulse that can be triggered by photodiode
%
% SS=stimWaveGrating(myScreenInfo,Pars) returns an object SS of type ScreenStim
%

%% Basics

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition
pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)', 50, 1, 600};
pp{2}  = {'tf1',	'Patch: Temporal frequency (Hz *10)', 40, 1, 400};
pp{3}  = {'sf1',	'Patch: Spatial frequency (cpd *100)', 10, 1, 200};
pp{4}  = {'tph1',	'Patch: Temporal phase (deg)', 0, 0, 360};
pp{5}  = {'sph1',	'Patch: Spatial phase (deg)', 0, 0, 360};
pp{6}  = {'c1',		'Patch: Contrast (%)', 50, 0, 100};
pp{7}  = {'ori1',	'Patch: Orientation (deg)', 45, 0, 360};
pp{8}  = {'dima1',	'Patch: Inner Diam or Size X (deg*10)', 30, 0, 1199};
pp{9}  = {'dimb1',	'Patch: Outer Diam or Size Y (deg*10)', 100, 1, 1200};
pp{10} = {'x1',         'Patch: Center, x (deg*10)', 0, -1000, 1000};
pp{11} = {'y1',         'Patch: Center, y (deg*10)', 0, -500, 500};
pp{12} = {'flick1', 	'Patch: Drift (0) or Flicker (1)', 0, 0, 1};
pp{13} = {'sqwv1',	'Patch: Sine (0) or Square (1)', 0, 0, 1};
pp{14} = {'duty1',	'Patch: Duty cycle (%)', 100, 1, 100}; 
pp{15} = {'shape1',	'Patch: Annulus (0) or Rectangle (1)', 0, 0, 1};
pp{16} = {'Vamp',        'Pulse amplitude        (mV)',         3300,0,5000};
pp{17} = {'LaserOn',     'Laser on time          (ms*10)',      0,0,5000};
pp{18} = {'LaserOff',    'Laser off time         (ms*10)',      1000,0,50000};
pp{19} = {'trigType',    'Manual(1), HwDigital(2), Immediate(3)',2,1,3};

x = XFile('stimWaveGrating',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end

%% get the parameters relevant for the visual stimulus and the wave
% IC first for the visual stimulus (see oglOneGrating_IC1013.x)
ParsVis = Pars([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]);

% next for the Wave
ParsWav = Pars([1 16 17 18 19]);

myScreenStimVis=ScreenStim.Make( myScreenInfo,'oglOneGrating_IC1013',ParsVis );
myScreenStimWav = ScreenStim.Make( myScreenInfo,'stimWaveBlank',ParsWav );
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;

return

%% To test the code
myScreenStim = ScreenStim.Make(myScreenInfo,'stimWaveGrating'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>
