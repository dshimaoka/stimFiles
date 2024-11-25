function SS = stimOptiWaveOutput_MP(myScreenInfo,Pars)
% stimWaveOutput makes wave stimuli (nothing visual)
%
% SS = stimWaveOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimWaveOutput(myScreenInfo) uses the default parameters
%
% 2011-02 MC
% 2013-10 MK (significantly) modified stimWaveOutput for specific needs (optogenetic stimulation) and to allow 2 channels
% 2015-02 NS made it a full sine wave
% 2020-10 DS something is wrong with this function AO switches off later
% than specified

%%

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',        'Stimulus duration (s*10)',           70,1,600};
pp{2}  = {'tstart1',     'Start time (ms)',                   1000,0,60000};
pp{3}  = {'tend1',       'End time (ms)',                     6000,0,60000};
pp{4}  = {'amp1',        'Amplitude (mV)',                    0,0,5000};
pp{5}  = {'tstart2',     'Start time (ms)',                   1000,0,60000};
pp{6}  = {'tend2',       'End time (ms)',                     6000,0,60000};
pp{7}  = {'amp2',        'Amplitude (mV)',                   0,0,50000};
pp{8}  = {'trigtype',    'Manual(1), HwDigital(2), Immediate(3)', 1, 1, 3};

x = XFile('stimOptiWaveOutput_MP',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur      = Pars(1)/10;   % s
tStart1  = Pars(2)/1000; % s
tEnd1    = Pars(3)/1000; % s
amp1     = Pars(4)/1000; % V

tStart2  = Pars(5)/1000; % s
tEnd2    = Pars(6)/1000; % s
amp2     = Pars(7)/1000; % V

triggerType=Pars(8);


%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimOptiWaveOutput_MP';
SS.Parameters = Pars;

fs = myScreenInfo.WaveInfo.SampleRate;%40e3; 28/9/20
nt = ceil(dur*fs);

%% building the waveform for the first channel
nSamplesPerStim1=round((tEnd1-tStart1)*fs);
nSamplesPerPulse1=nSamplesPerStim1;

pulseWaveform1=amp1*ones(nSamplesPerPulse1, 1); % step

pulseStartTimes1=tStart1; % make a single pulse

Waveform1=zeros(nt, 1);
Waveform1(max(round(pulseStartTimes1*fs), 1))=1;
Waveform1=conv(Waveform1, pulseWaveform1, 'full');
Waveform1=Waveform1(1:nt);
Waveform1(round(tEnd1*fs):end)=0;
Waveform1(nt)=0; % make sure there is zero output at the end

%% building the waveform for the second channel
nSamplesPerStim2=round((tEnd2-tStart2)*fs);
nSamplesPerPulse2=nSamplesPerStim2;

pulseWaveform2=amp2*ones(nSamplesPerPulse2, 1); % step
pulseStartTimes2=tStart2; % make a single pulse

Waveform2=zeros(nt, 1);
Waveform2(max(round(pulseStartTimes2*fs), 1))=1;
Waveform2=conv(Waveform2, pulseWaveform2, 'full');
Waveform2=Waveform2(1:nt);
Waveform2(round(tEnd2*fs):end)=0;
Waveform2(nt)=0; % make sure there is zero output at the end

%% putting things together
SS.WaveStim.Waves = [Waveform1(:), Waveform2(:)];
% figure; plot(tt,SS.WaveStim.Waves)
SS.WaveStim.SampleRate = fs;
switch triggerType
    case 1
        SS.WaveStim.TriggerType = 'Manual';        
    case 2
        SS.WaveStim.TriggerType = 'HwDigital';
    case 3
        SS.WaveStim.TriggerType = 'Immediate';
end

% a blank visual stimulus
SS.nTextures = 1;
SS.nFrames = round(myScreenInfo.FrameRate*dur );
if ~mod(SS.nFrames, 2)
    % we want an odd number of frames if the SyncSquare is Flickering.
    SS.nFrames=SS.nFrames+1;
end
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = zeros(1,SS.nFrames);
SS.nImages = 1;

try
    SS.ImagePointers = Screen('MakeTexture', myScreenInfo.windowPtr, 0, [], 0, 1);
end
SS.ImageSequence = ones(1,SS.nFrames);
SS.SourceRects = repmat([1; 1; 1; 1],[1 1 SS.nFrames]);
SS.DestRects   = repmat([1; 1; 1; 1],[1 1 SS.nFrames]);

%debug only
% fprintf('stimOptiWaveOutput : nFrames = %d\n', SS.nFrames);
return

%% To test the code

SS = stimOptiWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);


