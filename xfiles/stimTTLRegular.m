function SS = stimTTLRegular(myScreenInfo,Pars)
% stimTTLOutput rectanglar wave (AO0) of a DMD pattern (ptnIdx) 
% SS = stimTTLSwitch(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% 2025-10 created from stimTTLSwitch

%% 

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1} = {'nPtn', '#images per condition',1,1,100000};
pp{2} = {'ptnIdx', 'Pattern ID',1,1,100000}; %must be identical to condition number ... no need to provide as an input
pp{3}  = {'WaveAmp',   'Amplitude of wave (mV*1000)',    100, 0, 5000};
pp{4}  = {'WaveFreq',  'Frequency (Hz)',             4400,0,20000};
pp{5}  = {'WaveDuty',     'percentage of ON period per presentation(%)',   50,0,100}; 
x = XFile('stimTTLRegular',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


nPtn = Pars(1); %number of patterns per condition registered in polyScan. MUST BE constant across mpep stim number
PtnIdx = Pars(2);
WaveAmp = Pars(3)/1000; %V
WaveFreq = Pars(4);    % Hz
WaveDuty   = Pars(5);    % [%]

margin = 1; %number of blank frames before/after TTL switching ... could be just 0?
wavedur = nPtn/WaveFreq; %s
fs = 5000;

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimTTLRegular';
SS.Parameters = Pars;

nConds = size(SS.Parameters,2);
WaveStart   = ceil(2*1000*nConds*nPtn/fs);%Pars(5);    % ms
WaveStop    = WaveStart+wavedur*1000;%Pars(6);    % ms
WaveDurOn_TTL   = 2;%Pars(8);    % ms % to switch DMD images

ntWavestart = ceil(WaveStart/1000*fs);
ntWavestop = ceil(WaveStop/1000*fs);
nt = ntWavestart+ntWavestop;
dur = ceil(nt/fs);
tt = (1:nt)./fs; %[s] consecutive time
ttWave = (1:ntWavestop-ntWavestart-1)./fs; %[s] consecutive time after wave start

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


SS.WaveStim.Waves = zeros(nt,2); 

%% wave
SS.WaveStim.Waves(ntWavestart:ntWavestop-2,1) = ...
    0.5*WaveAmp*(square(2*pi*WaveFreq*ttWave, WaveDuty)+1)';


%% TTL
%before Wave, fast forward to the x-th ptn
nTTL_before = (PtnIdx-1)*nPtn;% - 1;
if nTTL_before >= 1
    SS.WaveStim.Waves(ntWavestart-margin-2*nTTL_before+1:2:ntWavestart-margin,2) = 5;
end

%after Wave, reset to the 1st ptn
nTTL_after  = nConds*nPtn - PtnIdx*nPtn;% + 1;
if nTTL_after >= 1
    SS.WaveStim.Waves(ntWavestop+margin:2:ntWavestop+margin+2*nTTL_after-1,2) = 5;
end

%regular freq during trial
SS.WaveStim.Waves(ntWavestart:ntWavestop-2,2) = ...
    2.5*(square(2*pi*WaveFreq*ttWave, WaveDurOn_TTL/1000*WaveFreq*100)+1)';


SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

% ax(1) = subplot(211);
% plot(tt, SS.WaveStim.Waves(:,1));vline([WaveStart WaveStop]/1000,ax(1));
% 
% ax(2) = subplot(212);
% plot(tt, SS.WaveStim.Waves(:,2));vline([WaveStart WaveStop]/1000,ax(2));
% 
% linkaxes(ax);

SS = stimTTLRegular(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
show( SS, myScreenInfo);


