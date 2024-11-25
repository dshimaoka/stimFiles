function SS = stimOptiWaveOutput_DS(myScreenInfo,Pars)
% stimWaveOutput makes wave stimuli (nothing visual)
%
% SS = stimWaveOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimWaveOutput(myScreenInfo) uses the default parameters
%
% 2011-02 MC
% 2013-10 MK (significantly) modified stimWaveOutput for specific needs (optogenetic stimulation) and to allow 2 channels

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
pp{4}  = {'amp1',        'Amplitude (mV)',                    5000,0,5000};
pp{5}  = {'shape1',      'Ramp(1), Step(2) or Half-Sine(3)',  3,1,3};
pp{6}  = {'freq1',       'Frequency of pulses (Hz*10)',       10,0,1000};
pp{7}  = {'dcyc1',       'Pulses Duty Cycle (%*10)',          200, 0, 1000};
pp{8}  = {'tstart2',     'Start time (ms)',                   1000,0,60000};
pp{9}  = {'tend2',       'End time (ms)',                     6000,0,60000};
pp{10}  = {'amp2',        'Amplitude (mV)',                   3000,0,5000};
pp{11}  = {'shape2',      'Ramp(1), Step(2) or Half-Sine(3)', 1,1,3};
pp{12}  = {'freq2',       'Frequency of pulses (Hz*10)',      0,0,1000};
pp{13}  = {'dcyc2',       'Pulses Duty Cycle (%*10)',         200, 0, 1000};
pp{14}  = {'trigtype',    'Manual(1), HwDigital(2), Immediate(3)', 1, 1, 3};



x = XFile('stimOptiWaveOutput_DS',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur      = Pars(1)/10;   % s
tStart1  = Pars(2)/1000; % s
tEnd1    = Pars(3)/1000; % s
amp1     = Pars(4)/1000; % V
shape1   = Pars(5); % indicator of a pulse shape to use
freq1    = Pars(6)/10; %Hz frequency of pulses (0 for a single pulse)
dcyc1    = Pars(7)/1000; %fraction in [0, 1] - duty cycle of the pulses

tStart2  = Pars(8)/1000; % s
tEnd2    = Pars(9)/1000; % s
amp2     = Pars(10)/1000; % V
shape2   = Pars(11); % indicator of a pulse shape to use
freq2    = Pars(12)/10; %Hz frequency of pulses (0 for a single pulse)
dcyc2    = Pars(13)/1000; %fraction in [0, 1] - duty cycle of the pulses

triggerType=Pars(14);


%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimOptiWaveOutput';
SS.Parameters = Pars;

fs = myScreenInfo.WaveInfo.SampleRate;%40e3; 25/9/20
nt = ceil(dur*fs);
tt = (1:nt)./fs;

%% building the waveform for the first channel
nSamplesPerStim1=round((tEnd1-tStart1)*fs);
if freq1>0
    nSamplesPerPulse1=ceil(1/freq1*dcyc1*fs);
elseif freq1==0
    nSamplesPerPulse1=nSamplesPerStim1;
end
ttPulse1=(1:nSamplesPerPulse1)/nSamplesPerPulse1*pi;

switch shape1
    case 1
        pulseWaveform1=amp1*ttPulse1/pi; % ramp from 0 to amp1
    case 2
        pulseWaveform1=amp1*ones(nSamplesPerPulse1, 1); % step
    case 3
        pulseWaveform1=amp1*sin(ttPulse1);% Half-sine
    otherwise
        warning('unrecognized pulse shape, generating zero intensity waveform');
        pulseWaveform1=zeros(nSamplesPerPulse1, 1);
end

if freq1>0
    pulseStartTimes1=tStart1:1/freq1:tEnd1;
elseif freq1==0
    pulseStartTimes1=tStart1; % make a single pulse
end

Waveform1=zeros(nt, 1);
Waveform1(max(round(pulseStartTimes1*fs), 1))=1;
Waveform1=conv(Waveform1, pulseWaveform1, 'full');
Waveform1=Waveform1(1:nt);
Waveform1(round(tEnd1*fs):end)=0;
Waveform1(nt)=0; % make sure there is zero output at the end

%% building the waveform for the second channel
nSamplesPerStim2=round((tEnd2-tStart2)*fs);
if freq2>0
    nSamplesPerPulse2=ceil(1/freq2*dcyc2*fs);
elseif freq2==0
    nSamplesPerPulse2=nSamplesPerStim2;
end
ttPulse2=(1:nSamplesPerPulse2)/nSamplesPerPulse2*pi;

switch shape2
    case 1
        pulseWaveform2=amp2*ttPulse2/pi; % ramp from 0 to amp2
    case 2
        pulseWaveform2=amp2*ones(nSamplesPerPulse2, 1); % step
    case 3
        pulseWaveform2=amp2*sin(ttPulse2);% Half-sine
    otherwise
        warning('unrecognized pulse shape, generating zero intensity waveform');
        pulseWaveform2=zeros(nSamplesPerPulse2, 1);
end

if freq2>0
    pulseStartTimes2=tStart2:1/freq2:tEnd2;
elseif freq2==0
    pulseStartTimes2=tStart2; % make a single pulse
end

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
SS.ImagePointers = Screen('MakeTexture', myScreenInfo.windowPtr, 0, [], 0, 1);
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


