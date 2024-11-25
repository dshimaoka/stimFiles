function SS = stimFlashedBarWaveOutput(myScreenInfo,Pars)
% stimFlashedBarWaveOutput makes flashed bars superimposed onto rand noise
%
% SS = stimFlashedBarWaveOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimFlashedBarWaveOutput(myScreenInfo) uses the default parameters
%
% 2011-03 MC

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur', 'Stimulus duration (s *10)',               50,1,600};
pp{2} = {'ori',     'Orientation (deg)',                    45, 0, 360};
pp{3} = {'len',     'Bar length (deg*10)',                  300, 1, 900};
pp{4} = {'wid',     'Bar width (deg*10)',                    50, 1, 900};
pp{5} = {'pos',     'Position relative to focus (deg*10)'   200, -900, 900};
pp{6} = {'xfocus',  'Focus position, x (deg*10)',           -300,-900, 900};
pp{7} = {'yfocus',  'Focus position, y (deg*10)',           0, -300, 300};
pp{8}  = {'ton1',  '1st onset time(ms)',                    500,1,6000};
pp{9}  = {'toff1', '1st offset time(ms)',                   1000,1,6000};
pp{10}  = {'ton2',  '2nd onset time(ms)',                   1000,1,60000};
pp{11}  = {'toff2', '2nd offset time(ms)',                  1500,1,60000};
pp{12}  = {'lum1',    '1st luminance (%)',                    50,-100,100};
pp{13}  = {'lum2',    '2nd luminance (%)',                   -50,-100,100};
pp{14}  = {'SineAmp',   'WAVE: Amplitude of sinusoid (mV)',       100, 0, 5000};
pp{15}  = {'SineFreq',  'WAVE: Frequency (Hz*10)',               4400,0,20000};
pp{16}  = {'t1',        'WAVE: Time of 1st event (ms)',        1000,0,6000};
pp{17}  = {'v1',        'WAVE: Value at 1st event (mV)',       1000,-5000,5000};
pp{18}  = {'t2',        'WAVE: Time of 2nd event (ms)',        2000,0,60000};
pp{19}  = {'v2',        'WAVE: Value at 2nd event (mV)',          0,-5000,5000};

x = XFile('stimFlashedBarWaveOutput',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%

Pars1 = Pars( 1:13 );

t3 = Pars(1);
t4 = Pars(1);
v3 = Pars(19);
v4 = Pars(19);

Pars2 = [ Pars(1); Pars(14:19); t3; v3; t4; v4 ];

myScreenStim1 = ScreenStim.Make( myScreenInfo,'stimFlashedBar',Pars1 );
myScreenStim2 = ScreenStim.Make( myScreenInfo,'stimWaveOutput',Pars2 );

SS = Merge( myScreenInfo, myScreenStim1, myScreenStim2);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimFlashedBarWaveOutput'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
