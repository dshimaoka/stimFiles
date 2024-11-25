function SS = stimKalatskyWaveOutput(myScreenInfo,Pars)
% stimKalatsky makes color flickering bars moving periodically in the x/y
% direction together with a wave signal from NI
%
% SS = stimKalatskyWaveOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimKalatskyWaveOutput(myScreenInfo) uses the default parameters
%
% 2013-05 AP

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',        50,1,600};
pp{2}  = {'start',	'Stimulus start (deg)',        0,0,360};
pp{3}  = {'end',	'Stimulus end (deg)',        360,0,360};
pp{4}  = {'tf',     'Temporal frequency (Hz *100)',      1,1,400};
pp{5}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{6}  = {'tph',    'Temporal phase (deg)',              0,0,360};
pp{7}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{8}  = {'dir',    'Direction of movement',                1,-1,1};
pp{9} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{10}  = {'flickfreq',    'Temporal frequency of flicker (Hz *10)',   40,1,400};
pp{11}  = {'cr',    'Contrast of red gun (%)',          100,0,100};
pp{12}  = {'cg',	'Contrast of green gun (%)',        0,0,100};
pp{13}  = {'cb',	'Contrast of blue gun (%)',         0,0,100};
pp{14}  = {'lr',	'Mean luminance of red gun (%)',    50,0,100};
pp{15}  = {'lg',    'Mean luminance of green gun (%)',  0,0,100};
pp{16}  = {'lb',    'Mean luminance of blue gun (%)',   0,0,100};
pp{17}  = {'ori',   'Orientation (xpos = 1;ypos = 2)',   1,1,2};
pp{18}  = {'SineAmp',   'WAVE: Amplitude of sinusoid (mV)',       100, 0, 5000};
pp{19}  = {'SineFreq',  'WAVE: Frequency (Hz*10)',               4400,0,20000};
pp{20}  = {'t1',        'WAVE: Time of 1st event (ms)',        1000,0,6000};
pp{21}  = {'v1',        'WAVE: Value at 1st event (mV)',       1000,-5000,5000};
pp{22}  = {'t2',        'WAVE: Time of 2nd event (ms)',        2000,0,60000};
pp{23}  = {'v2',        'WAVE: Value at 2nd event (mV)',          0,-5000,5000};

x = XFile('stimKalatskyWaveOutput',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%

Pars1 = Pars( 1:17 );

t3 = Pars(1);
t4 = Pars(1);
v3 = Pars(23);
v4 = Pars(23);

Pars2 = [ Pars(1); Pars(18:23); t3; v3; t4; v4 ];

myScreenStim1 = ScreenStim.Make( myScreenInfo,'stimKalatsky',Pars1 );
myScreenStim2 = ScreenStim.Make( myScreenInfo,'stimWaveOutput',Pars2 );

SS = Merge( myScreenInfo, myScreenStim1, myScreenStim2);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimKalatskyWaveOutput'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
