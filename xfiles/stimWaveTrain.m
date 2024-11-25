function SS = stimWaveTrain(myScreenInfo,Pars)
% stimTTLOutput makes TTL(mimicked by ao, 2channels) OR wave(sound, 1channel) stimuli (nothing visual)
% use with Play_ds and vs_ds (legacy mode only)
% TTL and sound cannot be output at the same time
% SS = stimTTLOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimTTLOutput(myScreenInfo) uses the default parameters
%
% To use this script as TTL output, set RiseTime and ToneFreq as 0, and
% WaveAmp as 5000
%

% 2013-10 DS made from stimTTLOutput
% 2014-12-09 DS allowed RiseTime and ToneFreq to be 0, so this script can
% be used as TTL pulse

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
pp{2}  = {'WaveAmp',   'Amplitude of sinusoid (mV*1000)',    100, 0, 5000};

pp{3}  = {'WaveStart', 'Time of wave onset (ms)',        2000,0,6000};
pp{4}  = {'WaveStop', 'Time of wave offset (ms)',        4000,0,6000};
pp{5}  = {'WaveFreq',  'Frequency (Hz*10)',             4400,0,20000};
pp{6}  = {'WaveDurOn',     'Duration of on period (ms)',   20,0,1000};
pp{7}  = {'ToneFreq',     'Tone frequency (Hz*10)',   200,0,10000};
pp{8} = {'RiseTime',   'Rise and fall time (ms)',  5  ,0,500};
x = XFile('stimWaveTrain',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10;   % s
WaveAmp = Pars(2)/1000;

WaveStart   = Pars(3);    % ms
WaveStop    = Pars(4);    % ms
WaveFreq = Pars(5)/10;    % Hz
WaveDurOn   = Pars(6);    % ms
ToneFreq = Pars(7)/10;    % Hz If 0, just envelope wave
RiseTime = Pars(8)/1000; %s If 0, no truncation

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimWaveOutput';
SS.Parameters = Pars;

% dur = 6;
% WaveAmp = 5;
% WaveStart=1000;
% WaveStop = 5000;
% WaveFreq = 5;
% WaveDurOn = 50;
% ToneFreq = 5000;
% RiseTime = 0.005;

fs = 125e3; %13.10,20
nt = ceil(dur*fs);
tt = (1:nt)./fs;

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
% SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
%     WaveAmp*0.5*(1+square(2*pi*WaveFreq*ttWave, WaveDurOn/1000*WaveFreq*100)').*sin(2*pi*ToneFreq*ttWave)';

dWave = 0 : 1/WaveFreq : ttWave(end);           
dWave = dWave + WaveDurOn/2/1000;

train_rectangle = pulstran(ttWave,dWave,'rectpuls',WaveDurOn/1000);
if RiseTime > 0 %2014/12/9
    train_triangle =2*WaveDurOn/RiseTime/1000 *pulstran(ttWave,dWave,'tripuls',WaveDurOn/1000);
    train_output = min(train_triangle,train_rectangle);%trimmed rectangle
elseif RiseTime == 0
    train_output = train_rectangle;
end

if ToneFreq > 0 %2014/12/9
    SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
    WaveAmp*train_output'.*sin(2*pi*ToneFreq*ttWave)';
elseif ToneFreq == 0 
    SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
    WaveAmp*train_output';
end
SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

SS = stimWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play_ds( SS, myScreenInfo);


