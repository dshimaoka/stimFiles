function SS = stimATCGrat(myScreenInfo,Pars)
% stimATCGrat is a combination of stimATC and drifting grating 
%
% SS = stimATCGrat(myScreenInfo,Pars) returns an object of type ScreenStim
% SS = stimATCGrat(myScreenInfo) uses the default parameters
%
% 2014-04 MO

%---- Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)', 50, 1, 600};
pp{2}  = {'tf',	'Temporal frequency (Hz *10)', 40, 1, 400};
pp{3}  = {'sf',	'Spatial frequency (cpd *100)', 10, 1, 200};
pp{4}  = {'tph',	'Temporal phase (deg)', 0, 0, 360};
pp{5}  = {'sph',	'Spatial phase (deg)', 0, 0, 360};
pp{6}  = {'c',		'Contrast (%)', 50, 0, 100};
pp{7}  = {'ori',	'Orientation (deg)', 45, 0, 360};
pp{8}  = {'dima',	'Inner Diam or Size X (deg*10)', 30, 0, 1199};
pp{9}  = {'dimb',	'Outer Diam or Size Y (deg*10)', 100, 1, 1200};
pp{10} = {'x',     'Center, x (deg*10)', 0, -1000, 1000};
pp{11} = {'y',     'Center, y (deg*10)', 0, -500, 500};
pp{12} = {'flick', 'Drift (0) or Flicker (1)', 0, 0, 1};
pp{13} = {'sqwv',	'Sine (0) or Square (1)', 0, 0, 1};
pp{14} = {'duty',	'Duty cycle (%)', 100, 1, 100}; 
pp{15} = {'shape',	'Annulus (0) or Rectangle (1)', 0, 0, 1};
pp{16}  = {'SineAmp',   'Amplitude of tone (mV)',         100, 0, 5000};
pp{17}  = {'SineFreq',  'Frequency of tone (Hz)',        9500, 0,30000};
pp{18}  = {'tTone', 'Time of onset of auditory event (ms)',1000, 0,60000};
pp{19}  = {'durTone',   'Duration of auditory event (ms)',350, 0,1000};
pp{20}  = {'durInt',      'Duration of interval (ms)',      250, 0,600};
pp{21}  = {'durPuff',      'Duration of puff (ms)',          100, 0,500};

x = XFile('stimATCGrat',pp);
% x.Write; % call this ONCE: it writes the .x file

%---- Parse the parameters
if isempty(Pars)
    Pars = x.ParDefaults;
end

%---- get the parameters relevant for the visual stimulus and the wave

%first for the visual stimulus (see oglOneGrating_IC1013.x)
ParsVis = Pars([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]);

% next for stimATC
ParsWav = [Pars(1); Pars(16:21); 2];

myScreenStimVis = ScreenStim.Make( myScreenInfo, 'oglOneGrating_IC1013', ParsVis );
myScreenStimWav = ScreenStim.Make( myScreenInfo, 'stimATC', ParsWav );
myScreenStimWav.MinusOneToOne = myScreenStimVis.MinusOneToOne;

SS = Merge( myScreenInfo, myScreenStimVis, myScreenStimWav);
SS.Type = x.Name;
SS.Parameters = Pars;

return

%% To test the code
RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;
pars = [5 20 5 0 0 100 90 1199 1200 150 0 0 0 100 1 0 0 100 50 249 100]';
SS = stimATCGrat(myScreenInfo, pars); 
Play(SS, myScreenInfo);

