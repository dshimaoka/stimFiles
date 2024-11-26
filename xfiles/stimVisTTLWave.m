function SS = stimVisTTLWave(myScreenInfo,Pars)
% stimTTLOutput makes wave(at AO0) and TTL (at AO1) + stimuli (nothing visual)
% TTL and wave can be sent at the same time
% SS = stimVisTTLWave(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimVisTTLWave(myScreenInfo) uses the default parameters
%
% 2024-11 DS made from stimVISTTL

%% 

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration (s*10)',          100,1,600};
pp{2}  = {'TTL',   'Switch of TTL (0 1)',                  0,0,1};
pp{3}  = {'WaveAmp',   'Amplitude of sinusoid (mV*1000)',    100, 0, 5000};

%TTL AO1
pp{4}  = {'TTLStart', 'Time of TTL onset (ms)',        2000,0,6000};
pp{5}  = {'TTLStop', 'Time of TTL offset (ms)',        4000,0,6000};
pp{6}  = {'TTLFreq',  'Frequency (Hz*10)',             4400,0,20000};
pp{7}  = {'TTLDurOn',     'Duration of on period (ms)',   20,0,1000};

%Wave AO0
pp{8}  = {'WaveStart', 'Time of wave onset (ms)',        2000,0,6000};
pp{9}  = {'WaveStop', 'Time of wave offset (ms)',        4000,0,6000};
pp{10}  = {'WaveFreq',  'Frequency (Hz*10)',             4400,0,20000};
pp{11}  = {'WaveDurOn',     'Duration of on period (ms)',   20,0,1000};
pp{12}  = {'ToneFreq',     'Tone frequency (Hz*10)',   200,0,10000};

%Visual
pp{13}  = {'tf',   'Temporal frequency (Hz*10)',   10,   1,   200};
pp{14}  = {'sf',   'Spatial frequency (cpd*100)',  5,    0,   1000};
pp{15}  = {'c',    'Contrast (%)'                  50,  -100, 100};
pp{16}  = {'ori',  'Orientation (deg)',            45,   0,   360};
pp{17}  = {'dim1',  'Diameter (deg*10)'             100,  1,   500};
pp{18}  = {'dim2',  'Diameter (deg*10)'             250,  1,   500};
pp{19}  = {'x',    'Focus position, x (deg*10)',   0,   -900, 900};
pp{20}  = {'y',    'Focus position, y (deg*10)',   0,   -300, 300};
pp{21} = {'ton',   'onset time(ms)',               2000,  1,   6000};
pp{22} = {'toff',  'offset time(ms)',              3000, 1,   6000};
pp{23} = {'shape', 'shape (0 = circle; 1 = rect)', 0,    0,   1};


x = XFile('stimVisTTLWave',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%

Pars1 = [Pars(1:12)];
Pars2 = [Pars(1); Pars(13:23)];

myScreenStim1 = ScreenStim.Make( myScreenInfo,'stimTTLWaveOutput',Pars1 );
myScreenStim2 = ScreenStim.Make( myScreenInfo,'stimFlashedGrat',Pars2 );

SS = Merge( myScreenInfo, myScreenStim1, myScreenStim2);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

SS = stimVisTTL(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play_test( SS, myScreenInfo);


