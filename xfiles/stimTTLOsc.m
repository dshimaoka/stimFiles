function SS = stimTTLOsc(myScreenInfo,Pars)
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
pp{1}  = {'dur',       'Stimulus duration (s*10)',          100,1,1200};
%Sinusoidal Wave AO0
pp{2}  = {'WaveAmp',   'Amplitude of wave (mV*1000)',    100, 0, 5000};
pp{3}  = {'WaveStart', 'Time of wave onset (ms)',        2000,100,12000}; %MUST IMPOSE SOME TIME TO ALLOW PTN SWITCHING
pp{4}  = {'WaveStop', 'Time of wave offset (ms)',        4000,0,12000};
pp{5}  = {'WaveFreq',  'Frequency (Hz*10)',             4400,0,20000};

x = XFile('stimTTLSwitch',pp);
% x.Write; % call this ONCE: it writes the .x file

margin = 1; %number of blank frames before/after TTL switching ... could be just 0?

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur     = Pars(1)/10;   % s
WaveAmp = Pars(2)/1000; %V
WaveStart   = Pars(3);    % ms
WaveStop    = Pars(4);    % ms
WaveFreq = Pars(5)/10;    % Hz

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimTTLOsc';
SS.Parameters = Pars;

fs = myScreenInfo.WaveInfo.SampleRate;%6600*2;%5000;
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
        WaveAmp*abs(sin(2*pi*WaveFreq*ttWave)');
    % SS.WaveStim.Waves(ntWavestart:ntWavestop-2,1) = ...
    %     WaveAmp*square(2*pi*WaveFreq*ttWave, WaveDurOn/1000*WaveFreq*100)';
    
    
    
    %% TTL
    
    % %before Wave, fast forward to the x-th ptn
    % nTTL_before = PtnIdx;% - 1;
    % if nTTL_before >= 1
    %     assert(ntWavestart-margin-2*nTTL_before+1>0, 'Not enough time for Ptn switching. Increase WaveStart');
    %     SS.WaveStim.Waves(ntWavestart-margin-2*nTTL_before+1:2:ntWavestart-margin,2) = 5;
    % end
    % 
    % %after Wave, reset to the 1st ptn
    % nTTL_after  = nPtn - PtnIdx;% + 1;
    % if nTTL_after >= 1
    %     assert(ntWavestop+margin+2*nTTL_after-1<nt, 'Not enough time for Ptn switching. Increase dur or decrease WaveStop');
    %     SS.WaveStim.Waves(ntWavestop+margin:2:ntWavestop+margin+2*nTTL_after-1,2) = 5;
    % end

    % regular freq during trial
    SS.WaveStim.Waves(ntWavestart-1, 2) = 5; %need initial trigger to start with 1st ptn
    SS.WaveStim.Waves(ntWavestart:ntWavestop-2,2) = ...
        5*(abs(square(4*pi*WaveFreq*ttWave, 1/2/fs*WaveFreq*100)+1)');

    %after Wave, reset to the 1st ptn
    %nFlips = sum(   SS.WaveStim.Waves(ntWavestart:ntWavestop-2,2));
    nFlips =  ceil((ntWavestop-ntWavestart)/fs*2);
    if mod(nFlips,2) == 1
        SS.WaveStim.Waves(ntWavestop,2) = 5;
    end

SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

SS = stimTTLWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
show( SS, myScreenInfo);


