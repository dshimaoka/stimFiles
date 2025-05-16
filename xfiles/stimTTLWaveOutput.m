function SS = stimTTLWaveOutput(myScreenInfo,Pars)
% stimTTLOutput makes TTL(mimicked by AO1) OR wave(AO0) 
% SS = stimTTLWaveOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimTTLWaveOutput(myScreenInfo) uses the default parameters
%
% 2024-11 DS made from stimTTLOutput

%

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

x = XFile('stimTTLOutput',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur     = Pars(1)/10;   % s
TTL = Pars(2);
WaveAmp = Pars(3)/1000;

TTLStart   = Pars(4);    % ms
TTLStop    = Pars(5);    % ms
TTLFreq = Pars(6)/10;    % Hz
TTLDurOn   = Pars(7);    % ms 
WaveStart   = Pars(8);    % ms
WaveStop    = Pars(9);    % ms
WaveFreq = Pars(10)/10;    % Hz
WaveDurOn   = Pars(11);    % ms
ToneFreq = Pars(12)/10;    % Hz    

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimWaveOutput';
SS.Parameters = Pars;

% fs = 40000; 
fs = 5000;
nt = ceil(dur*fs);
tt = (1:nt)./fs;

ntTTLstart = ceil(TTLStart/1000*fs);
ntTTLstop = ceil(TTLStop/1000*fs);
ttTTL = (1:ntTTLstop-ntTTLstart-1)./fs;


ntWavestart = ceil(WaveStart/1000*fs);
ntWavestop = ceil(WaveStop/1000*fs);
ttWave = (1:ntWavestop-ntWavestart-1)./fs;

% a blank visual stimulus
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = zeros(1,SS.nFrames); 
SS.nImages = 1;
SS.ImagePointers = Screen('MakeTexture', myScreenInfo.windowPtr, 0, [], 0, 1);
SS.ImageSequence = ones(1,SS.nFrames);
SS.SourceRects = repmat([1; 1; 1; 1],[1 1 SS.nFrames]);
SS.DestRects   = repmat([1; 1; 1; 1],[1 1 SS.nFrames]);

SS.WaveStim.Waves = zeros(nt,1);

%% wave
SS.WaveStim.Waves(ntWavestart:ntWavestop-2,1) = ...
    WaveAmp*0.5*(1+square(2*pi*WaveFreq*ttWave, WaveDurOn/1000*WaveFreq*100)').*sin(2*pi*ToneFreq*ttWave)';

%% TTL
SS.WaveStim.Waves(ntTTLstart:ntTTLstop-2,2) = ...
    TTL*2.5*( 1 + square(2*pi*TTLFreq*ttTTL, TTLDurOn/1000*TTLFreq*100)');

SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

SS = stimTTLWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
show( SS, myScreenInfo);


