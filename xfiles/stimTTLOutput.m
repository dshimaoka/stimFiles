function SS = stimTTLOutput(myScreenInfo,Pars)
% stimTTLOutput makes TTL(mimicked by ao, 2channels) OR wave(sound, 1channel) stimuli (nothing visual)
% use with Play_ds and vs_ds (legacy mode only)
% TTL and sound cannot be output at the same time
% SS = stimTTLOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimTTLOutput(myScreenInfo) uses the default parameters
%
% 2013-07 DS made from stimWaveOutput

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
pp{2}  = {'TTL1',   'Switch of TTL1 (0 1)',                  0,0,1};
pp{3}  = {'TTL2',   'Switch of TTL2 (0 1)',                  0,0,1};
pp{4}  = {'WaveAmp',   'Amplitude of sinusoid (mV*1000)',    100, 0, 5000};

%TTL ch1
pp{5}  = {'TTL1Start', 'Time of TTL1 onset (ms)',        2000,0,6000};
pp{6}  = {'TTL1Stop', 'Time of TTL1 offset (ms)',        4000,0,6000};
pp{7}  = {'TTL1Freq',  'Frequency (Hz*10)',             4400,0,20000};
pp{8}  = {'TTL1DurOn',     'Duration of on period (ms)',   20,0,1000};
%TTL ch2
pp{9}  = {'TTL2Start', 'Time of TTL2 onset (ms)',        2000,0,6000};
pp{10}  = {'TTL2Stop', 'Time of TTL2 offset (ms)',        4000,0,6000};
pp{11}  = {'TTL2Freq',  'Frequency (Hz*10)',             4400,0,20000};
pp{12}  = {'TTL2DurOn',     'Duration of on period (ms)',   20,0,1000};

%Wave
pp{13}  = {'WaveStart', 'Time of wave onset (ms)',        2000,0,6000};
pp{14}  = {'WaveStop', 'Time of wave offset (ms)',        4000,0,6000};
pp{15}  = {'WaveFreq',  'Frequency (Hz*10)',             4400,0,20000};
pp{16}  = {'WaveDurOn',     'Duration of on period (ms)',   20,0,1000};
pp{17}  = {'ToneFreq',     'Tone frequency (Hz*10)',   200,0,10000};

x = XFile('stimTTLOutput',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur     = Pars(1)/10;   % s
TTL1 = Pars(2);
TTL2 = Pars(3);
WaveAmp = Pars(4)/1000;

TTL1Start   = Pars(5);    % ms
TTL1Stop    = Pars(6);    % ms
TTL1Freq = Pars(7)/10;    % Hz
TTL1DurOn   = Pars(8);    % ms 
TTL2Start   = Pars(9);    % ms
TTL2Stop    = Pars(10);    % ms
TTL2Freq = Pars(11)/10;    % Hz
TTL2DurOn   = Pars(12);    % ms 
WaveStart   = Pars(13);    % ms
WaveStop    = Pars(14);    % ms
WaveFreq = Pars(15)/10;    % Hz
WaveDurOn   = Pars(16);    % ms
ToneFreq = Pars(17)/10;    % Hz    

if (TTL1+TTL2) * WaveAmp ~= 0
    Warning('ABORTED: TTL and Wave stimuli cannot be applied at the same time!');
end

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimWaveOutput';
SS.Parameters = Pars;

% fs = 40000; 
fs = 125e3; %13.10,20
nt = ceil(dur*fs);
tt = (1:nt)./fs;

ntTTL1start = ceil(TTL1Start/1000*fs);
ntTTL1stop = ceil(TTL1Stop/1000*fs);
ttTTL1 = (1:ntTTL1stop-ntTTL1start-1)./fs;

ntTTL2start = ceil(TTL2Start/1000*fs);
ntTTL2stop = ceil(TTL2Stop/1000*fs);
ttTTL2 = (1:ntTTL2stop-ntTTL2start-1)./fs;

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

%% TTL stim
if WaveAmp > 0
    SS.WaveStim.Waves = zeros(nt,1);
    SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
        WaveAmp*0.5*(1+square(2*pi*WaveFreq*ttWave, WaveDurOn/1000*WaveFreq*100)').*sin(2*pi*ToneFreq*ttWave)';
%     SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
%         WaveAmp*0.5*(1+square(2*pi*WaveFreq*ttWave, WaveDurOn/1000*WaveFreq*100)').*0.5*(1+sin(2*pi*ToneFreq*ttWave)');
elseif TTL1 || TTL2
    SS.WaveStim.Waves = zeros(nt,3);
    SS.WaveStim.Waves(ntTTL1start:ntTTL1stop-2,2) = ...
        TTL1*2.5*( 1 + square(2*pi*TTL1Freq*ttTTL1, TTL1DurOn/1000*TTL1Freq*100)');
    SS.WaveStim.Waves(ntTTL2start:ntTTL2stop-2,3) = ...
    TTL2*2.5*( 1 + square(2*pi*TTL2Freq*ttTTL2, TTL2DurOn/1000*TTL2Freq*100)');
end
SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

SS = stimWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play_ds( SS, myScreenInfo);


