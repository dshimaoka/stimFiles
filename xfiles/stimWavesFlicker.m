function SS = stimWavesFlicker(myScreenInfo,Pars)
% stimWavesFlicker makes two wave stimuli (nothing visual)
%
% SS = stimWavesFlicker(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimWavesFlicker(myScreenInfo) uses the default parameters
%
% 2013-06 AP

%% 

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration (s*10)',        50,1,600};
pp{2}  = {'Wave1Amp',   'Wave 1 amplitude (mV)',       5000, 0, 5000};
pp{3}  = {'Wave1Dur',  'Wave 1 pulse duration (ms)',               10,0,1000};
pp{4}  = {'Wave1FlickFreq',  'Wave 1 temporal frequency (Hz*10)',               250,0,20000};
pp{5}  = {'Wave2Amp',   'Wave 2 amplitude (mV)',       5000, 0, 5000};
pp{6}  = {'Wave2Dur',  'Wave 2 pulse duration (ms)',               10,0,1000};
pp{7}  = {'Wave2FlickFreq',  'Wave 2 temporal frequency (Hz*10)',               250,0,20000};
pp{8}  = {'WavesShift',  'Temporal Shift between Wave 1 and 2 (ms)',               20,0,1000};

x = XFile('stimWavesFlicker',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10;   % s
Vamp    = [Pars(2) Pars(5)]/1000; % V
PulseDur = [Pars(3) Pars(6)]/1000; % s
f     = [Pars(4) Pars(7)]/10;   % Hz
shift = Pars(8)/1000; %s
safety_shift = 0; %s ensure there are no frames acquired in the first and last 50ms of the stimulus

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;

fs = 40000; 
nt = ceil(dur*fs);
wave = zeros(nt,2);

MaxFreq = [1 1]./PulseDur;
if MaxFreq(1)<f(1),
    fprintf('reducing pulse duration of wave %d in order to keep flicker frequency',1)
    PulseDur(1) = 1/f(1);
end
if MaxFreq(2)<f(2),
    fprintf('reducing pulse duration of wave %d in order to keep flicker frequency',2)
    PulseDur(2) = 1/f(2);
end
Pulse_tt = PulseDur*fs; 
Shift_tt = [0 shift*fs];
PulseDist_tt = fs*[1 1]./f;
Safety_Shift_tt = safety_shift*fs;

for i_Wave=1:2,
istart{i_Wave} = (1+Safety_Shift_tt+Shift_tt(i_Wave):PulseDist_tt(i_Wave):nt-Pulse_tt(i_Wave)-Safety_Shift_tt);
end

for i_Wave=1:2,
    for i=1:size(istart{i_Wave},2),
        wave(istart{i_Wave}(i):istart{i_Wave}(i)+Pulse_tt(i_Wave),i_Wave) = Vamp(i_Wave); %when the wave are on
    end
end

SS.WaveStim.Waves = wave;
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

SS = stimWavesFlicker(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);


