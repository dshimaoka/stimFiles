function SS = stimTTLSwitch(myScreenInfo,Pars)
% stimTTLOutput rectanglar wave (AO0) of a DMD pattern (ptnIdx) 
% SS = stimTTLSwitch(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% 2025-04 created from stimTTLWaveOutput

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
pp{2} = {'nPtn', 'Total number of patterns',1,1,100000};
pp{3} = {'ptnIdx', 'Pattern ID',1,1,100000};
%Rectanglar Wave AO0
pp{4}  = {'WaveAmp',   'Amplitude of wave (mV*1000)',    100, 0, 5000};
pp{5}  = {'WaveStart', 'Time of wave onset (ms)',        2000,100,6000}; %MUST IMPOSE SOME TIME TO ALLOW PTN SWITCHING
pp{6}  = {'WaveStop', 'Time of wave offset (ms)',        4000,0,6000};
pp{7}  = {'WaveFreq',  'Frequency (Hz*10)',             4400,0,20000};
pp{8}  = {'WaveDurOn',     'Duration of on period (ms)',   20,0,1000};

x = XFile('stimTTLSwitch',pp);
% x.Write; % call this ONCE: it writes the .x file

margin = 1; %number of blank frames before/after TTL switching ... could be just 0?

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur     = Pars(1)/10;   % s
nPtn = Pars(2); %number of total patterns registered in polyScan. MUST BE constant across mpep stim number
PtnIdx = Pars(3); %pattern order to present. MUST BE larger than 0
assert(nPtn >= PtnIdx, 'Pattern ID must be equal or smaller than total number of patterns');
WaveAmp = Pars(4)/1000; %V
WaveStart   = Pars(5);    % ms
WaveStop    = Pars(6);    % ms
WaveFreq = Pars(7)/10;    % Hz
WaveDurOn   = Pars(8);    % ms

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimTTLSwitch';
SS.Parameters = Pars;

% fs = 40000; 
fs = 1000;%5000
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

SS.WaveStim.Waves = zeros(nt,2); %zeros(nt,1)

%% wave
SS.WaveStim.Waves(ntWavestart:ntWavestop-2,1) = ...
    WaveAmp*square(2*pi*WaveFreq*ttWave, WaveDurOn/1000*WaveFreq*100)';

%% TTL

%before Wave, fast forward to the x-th ptn
nTTL_before = PtnIdx;% - 1;
if nTTL_before >= 1
    assert(ntWavestart-margin-2*nTTL_before+1>0, 'Not enough time for Ptn switching. Increase WaveStart');
    SS.WaveStim.Waves(ntWavestart-margin-2*nTTL_before+1:2:ntWavestart-margin,2) = 5;
end

%after Wave, reset to the 1st ptn
nTTL_after  = nPtn - PtnIdxp;% + 1;
if nTTL_after >= 1
    assert(ntWavestop+margin+2*nTTL_after-1<nt, 'Not enough time for Ptn switching. Increase dur or decrease WaveStop');
        SS.WaveStim.Waves(ntWavestop+margin:2:ntWavestop+margin+2*nTTL_after-1,2) = 5;
end


SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

SS = stimTTLWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
show( SS, myScreenInfo);


