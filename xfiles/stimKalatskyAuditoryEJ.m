function SS = stimKalatskyAuditory(myScreenInfo,Pars)
% stimTTLOutput makes TTL(mimicked by ao, 2channels) OR wave(sound, 1channel) stimuli (nothing visual)
% Kalatsky et al 2005 PNAS
% use with Play_ds and vs_ds (legacy mode only)
% TTL and sound cannot be output at the same time
% SS = stimTTLOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimTTLOutput(myScreenInfo) uses the default parameters
%
% 2013-07 DS made from stimWaveOutput
% 2015-03 DS modified duration is solely determined by dur
%            added calibration          

%% 

% load dB calibration info


if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration (s*10)',          10,1,600};
pp{2}  = {'WaveAmp',   'Amplitude of sinusoid (mV*1000)',    100, 0, 5000};


%Wave
pp{3}  = {'WaveStart', 'Time of wave onset (ms)',        2000,0,60000};
pp{4}  = {'WaveStop', 'Time of wave offset (ms)',        4000,0,60000};
pp{5}  = {'StairFreq', 'Slow staircase freq (Hz*100)',        20,1,100};
pp{6}  = {'EnvFreq',  'Envelop Frequency for tone(Hz*10)',             60,1,200};
pp{7}  = {'ToneOn', 'Duration of single tone (ms)', 50, 1, 1000};
pp{8}  = {'minToneFreq', 'minimum tone freq (Hz)', 1000, 1000, 64000};
pp{9}  = {'maxToneFreq', 'maximum tone freq (Hz)', 32000, 1000, 64000};
pp{10} = {'NumTones', 'Number of tones', 1,1,64};
pp{11} = {'RiseTime',   'Rise and fall time (ms)',  5  ,1,500};
pp{12}  = {'Direction',     'Tone direction. (1:ascending, 0:descending)',   1,0,1};


x = XFile('stimKalatskyAuditory',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur     = Pars(1)/10;   % s
WaveAmp = Pars(2)/1000;

WaveStart   = Pars(3);    % ms when the stim start in a trial
WaveStop    = Pars(4);    % ms when the stim stop in a trial
StairFreq = Pars(5)/100;    % Hz slow 
EnvFreq = Pars(6)/10; %Hz fast
ToneOn   = Pars(7);    % ms duration of a single tone
minToneFreq = Pars(8);    % kHz    
maxToneFreq = Pars(9);    % kHz    
NumTones = Pars(10);
RiseTime = Pars(11)/1000; %s
direction = Pars(12); %direction of tone (1:increase,-1:decrease)

% dur = 4;
% WaveAmp = 5000;
% WaveStart = 1000;
% WaveStop = 3000;
% StairFreq = 0.5;
% ToneOn = 20;
% minToneFreq = 2*1000;
% maxToneFreq = 32*1000;
% NumTones = 4;
% %DurToneTrain = 500;
% EhvFreq = 10;
% direction = 1;

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimWaveOutput';
SS.Parameters = Pars;

%fs = 40000;%200000;%how to set in vs? 
%fs = 125e3;
fs = myScreenInfo.WaveInfo.SampleRate; %DS 2015-3-25
nt = ceil(dur*fs);
tt = (1:nt)./fs;

DurToneTrain = 1/StairFreq * 1000 / NumTones; %ms
totToneOn = WaveStop - WaveStart; %ms. entire duration of stimulus in a trial
ToneFreq = round(logspace(log10(minToneFreq),log10(maxToneFreq),NumTones));
if direction == 0 %descending tone frequency
    ToneFreq = fliplr(ToneFreq);
end

% amp_calib = 1.4e-5*ToneFreq.^2-0.062*ToneFreq+6.1e2;
% amp_calib = amp_calib/max(amp_calib);
%  WaveAmp_calib = amp_calib * WaveAmp;


ntWavestart = ceil(WaveStart/1000*fs);
ntWavestop = ceil(WaveStop/1000*fs);
ttWave = (0:ceil(DurToneTrain/1000*fs-1))./fs; %[s]. in one tone train

ToneStart = zeros(NumTones,1);
ToneStop = zeros(NumTones,1);
for itone = 1:NumTones
    ToneStart(itone) = 1 + ceil(DurToneTrain/1000*fs) * (itone-1);
    ToneStop(itone) = ceil(DurToneTrain/1000*fs) * itone;
end

%% TTL stim
SS.WaveStim.Waves = zeros(nt,1);
% SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
%     WaveAmp*0.5*(1+square(2*pi*EnvFreq*ttWave, ToneOn/1000*EnvFreq*100)').*sin(2*pi*ToneFreq*ttWave)';

dWave = 0 : 1/EnvFreq : ttWave(end);           
dWave = dWave + ToneOn/2/1000;

train_triangle =2*ToneOn/RiseTime/1000 *pulstran(ttWave,dWave,'tripuls',ToneOn/1000);
train_rectangle = pulstran(ttWave,dWave,'rectpuls',ToneOn/1000);
train_trimedrect = min(train_triangle,train_rectangle);

for icycle = 1:ceil(totToneOn / DurToneTrain / NumTones)
    cycleStart = ceil(DurToneTrain * NumTones * (icycle-1) / 1000*fs) + ntWavestart;
    for itone = 1:NumTones        
        SS.WaveStim.Waves(ToneStart(itone)+cycleStart:ToneStop(itone)+cycleStart) = ...
            WaveAmp*train_trimedrect'.*...
            sin(2*pi*ToneFreq(itone)*ttWave - pi/2)';
    end
end
%make sure stim stops at WaveStop
%SS.WaveStim.Waves(ntWavestop:end) = 0;
SS.WaveStim.Waves(ntWavestop:nt) = 0;%2015/3/25
SS.WaveStim.Waves = SS.WaveStim.Waves(1:nt);%2015/3/25

SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 



% a blank visual stimulus ... not sure if this is needed
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = zeros(1,SS.nFrames); 
SS.nImages = 1;
SS.ImagePointers = Screen('MakeTexture', myScreenInfo.windowPtr, 0, [], 0, 1);
SS.ImageSequence = ones(1,SS.nFrames);
SS.SourceRects = repmat([1; 1; 1; 1],[1 1 SS.nFrames]);
SS.DestRects   = repmat([1; 1; 1; 1],[1 1 SS.nFrames]);



return

%% To test the code

SS = stimWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play_ds( SS, myScreenInfo);


