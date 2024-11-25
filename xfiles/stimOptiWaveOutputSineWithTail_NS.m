function SS = stimOptiWaveOutputSineWithTail_NS(myScreenInfo,Pars)
% stimWaveOutput makes wave stimuli (nothing visual)
%
% SS = stimWaveOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimWaveOutput(myScreenInfo) uses the default parameters
%
% 2011-02 MC
% 2013-10 MK (significantly) modified stimWaveOutput for specific needs (optogenetic stimulation) and to allow 2 channels
% 2015-02 NS made it a full sine wave

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
pp{5}  = {'freq1',       'Frequency (Hz*10)',                  10,0,10000};
pp{6} = {'tailDuration',    'Tail Duration (ms, 0 for none)',   200, 0 10000}; 
pp{7}  = {'trigtype',    'Manual(1), HwDigital(2), Immediate(3)', 1, 1, 3};



x = XFile('stimOptiWaveOutputSineWithTail_NS',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur      = Pars(1)/10;   % s
tStart1  = Pars(2)/1000; % s
tEnd1    = Pars(3)/1000; % s
amp1     = Pars(4)/1000; % V
freq1    = Pars(5)/10; %Hz frequency of pulses (0 for a single pulse)
tailDuration    = Pars(6)/1000; %s

triggerType=Pars(7);


%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimOptiWaveOutputSineWithTail_NS';
SS.Parameters = Pars;

fs = myScreenInfo.WaveInfo.SampleRate;%40e3; 28/9/20
nt = ceil(dur*fs);
tt = (1:nt)./fs;

%% building the waveform for the first channel
nSamples=round((tEnd1-tStart1)*fs);
% if freq1>0
%     nSamplesPerPulse1=ceil(1/freq1*dcyc1*fs);
% elseif freq1==0
%     nSamplesPerPulse1=nSamplesPerStim1;
% end
% ttPulse1=(1:nSamplesPerPulse1)/nSamplesPerPulse1*(2*pi);
% 
% switch shape1
%     case 1
%         pulseWaveform1=amp1*ttPulse1/pi; % ramp from 0 to amp1
%     case 2
%         pulseWaveform1=amp1*ones(nSamplesPerPulse1, 1); % step
%     case 3
%         pulseWaveform1=amp1*sin(ttPulse1)+amp1/2;% Half-sine
%     otherwise
%         warning('unrecognized pulse shape, generating zero intensity waveform');
%         pulseWaveform1=zeros(nSamplesPerPulse1, 1);
% end
% 
% if freq1>0
%     pulseStartTimes1=tStart1:1/freq1:tEnd1;
% elseif freq1==0
%     pulseStartTimes1=tStart1; % make a single pulse
% end
% 
% Waveform1=zeros(nt, 1);
% Waveform1(max(round(pulseStartTimes1*fs), 1))=1;
% Waveform1=conv(Waveform1, pulseWaveform1, 'full');
% Waveform1=Waveform1(1:nt);

% using -cos makes the wave start at zero
% adding 1 before multiplying by amplitude makes it all positive
sineWave = amp1/2*(-cos((1:nSamples)/nSamples*2*pi*freq1*(tEnd1-tStart1))+1);

if tailDuration>0
    nTailSamples = round(tailDuration*fs);
    tail = (nTailSamples-(1:nTailSamples))/nTailSamples;
    sineWave(end-nTailSamples+1:end) = sineWave(end-nTailSamples+1:end).*tail;
end

Waveform1 = zeros(nt,1);
Waveform1(round(tStart1*fs):round(tStart1*fs)+nSamples-1) = sineWave;
Waveform1(round(tEnd1*fs):end)=0;
Waveform1(nt)=0; % make sure there is zero output at the end

%% building the waveform for the second channel
% nSamplesPerStim2=round((tEnd2-tStart2)*fs);
% if freq2>0
%     nSamplesPerPulse2=ceil(1/freq2*dcyc2*fs);
% elseif freq2==0
%     nSamplesPerPulse2=nSamplesPerStim2;
% end
% ttPulse2=(1:nSamplesPerPulse2)/nSamplesPerPulse2*pi;
% 
% switch shape2
%     case 1
%         pulseWaveform2=amp2*ttPulse2/pi; % ramp from 0 to amp2
%     case 2
%         pulseWaveform2=amp2*ones(nSamplesPerPulse2, 1); % step
%     case 3
%         pulseWaveform2=amp2*sin(ttPulse2);% Half-sine
%     otherwise
%         warning('unrecognized pulse shape, generating zero intensity waveform');
%         pulseWaveform2=zeros(nSamplesPerPulse2, 1);
% end
% 
% if freq2>0
%     pulseStartTimes2=tStart2:1/freq2:tEnd2;
% elseif freq2==0
%     pulseStartTimes2=tStart2; % make a single pulse
% end
% 
% Waveform2=zeros(nt, 1);
% Waveform2(max(round(pulseStartTimes2*fs), 1))=1;
% Waveform2=conv(Waveform2, pulseWaveform2, 'full');
% Waveform2=Waveform2(1:nt);
% Waveform2(round(tEnd2*fs):end)=0;
% Waveform2(nt)=0; % make sure there is zero output at the end

%% putting things together
SS.WaveStim.Waves = Waveform1(:);
% SS.WaveStim.Waves = [Waveform1(:), Waveform2(:)];
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


