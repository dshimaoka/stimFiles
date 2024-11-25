function SS = stimKalatskyWavesFlicker(myScreenInfo,Pars)
% stimKalatskyWavesFlicker makes color flickering bars moving periodically in the x/y
% direction together with two squared waves signal from NI
%
% SS = stimKalatskyWavesFlicker(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimKalatskyWavesFlicker(myScreenInfo) uses the default parameters
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
pp{18}  = {'Wave1Amp',   'Wave 1 amplitude (mV)',       5000, 0, 5000};
pp{19}  = {'Wave1Dur',  'Wave 1 pulse duration (ms)',               10,0,1000};
pp{20}  = {'Wave1FlickFreq',  'Wave 1 temporal frequency (Hz*10)',               250,0,20000};
pp{21}  = {'Wave2Amp',   'Wave 2 amplitude (mV)',       5000, 0, 5000};
pp{22}  = {'Wave2Dur',  'Wave 2 pulse duration (ms)',               10,0,1000};
pp{23}  = {'Wave2FlickFreq',  'Wave 2 temporal frequency (Hz*10)',               250,0,20000};
pp{24}  = {'WavesShift',  'Temporal Shift between Wave 1 and 2 (ms)',               20,0,1000};

x = XFile('stimKalatskyWavesFlicker',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%
Pars1 = Pars( 1:17 );
Pars2 = [ Pars(1); Pars(18:24)];

myScreenStim1 = ScreenStim.Make( myScreenInfo,'stimKalatsky',Pars1 );
myScreenStim2 = ScreenStim.Make( myScreenInfo,'stimWavesFlicker',Pars2 );

SS = Merge( myScreenInfo, myScreenStim1, myScreenStim2);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimKalatskyWavesFlicker'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
