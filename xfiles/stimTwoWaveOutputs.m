function SS = stimTwoWaveOutputs(myScreenInfo,Pars)
% stimTwoWaveOutputs makes wave stimuli (nothing visual)
%
% SS = stimTwoWaveOutputs(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimTwoWaveOutputs(myScreenInfo) uses the default parameters
%
% 2014-08 MC from StimWaveOutput

%% 

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration (s*10)',             50,1,600};
pp{2}  = {'SineAmp1',   'Amplitude of sinusoid chan 1 (mV)',   4000, 0, 5000};
pp{3}  = {'SineAmp2',   'Amplitude of sinusoid chan 2 (mV)',   4000, 0, 5000};
pp{4}  = {'SineFreq',  'Frequency of sinusoid (Hz*10)',        40,0,20000};
pp{5}  = {'tOn',        'Time stimulus goes on (s*10)',        10,0,600};
pp{6}  = {'tOff',       'Time stimulus goes off (s*10)',       20,0,600};

x = XFile('stimTwoWaveOutputs',pp);
% x.Write; %  call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10;   % s
Vamps   = Pars(2:3)/1000; % V
f       = Pars(4)/10;   % Hz
tOnOff  = Pars(5:6)/10;

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimTwoWaveOutputs';
SS.Parameters = Pars;

fs = 40000; 
nt = ceil(dur*fs);
tt = (1:nt)./fs;

iOn =   ceil(tOnOff(1)*fs);
iOff = floor(tOnOff(2)*fs);

sinewaves = Vamps*sin(2*pi*f*tt);
sinewaves(:,1:iOn   ) = 0;
sinewaves(:,iOff:end) = 0;

SS.WaveStim.Waves = sinewaves';
% figure; plot(tt,SS.WaveStim.Waves)
SS.WaveStim.SampleRate = fs;

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

return

%% To test the code

SetDefaultDirs;
rigInfo = RigInfoGet; % Get this rig's settings
screenInfo = ScreenInfo(rigInfo);
screenInfo = screenInfo.CalibrationLoad;
daqInfo = rigInfo.WaveInfo; % Prepare the DAQ for outputs
waveOutSess = daq.createSession(daqInfo.DAQAdaptor);

SS = stimTwoWaveOutputs(screenInfo);
show(SS, screenInfo, [], waveOutSess, []);


