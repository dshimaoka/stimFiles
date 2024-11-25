function SS = stimWaveTrainEJ(myScreenInfo,Pars)
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
pp{1}  = {'dur',       'Stimulus duration (s*10)',          100,1,600};     % duration of whole stimulus
pp{2}  = {'WaveAmp',   'Amplitude of sinusoid (mV*1000)',    100, 0, 5000}; % amplitude, ie how loud sound is

pp{3}  = {'WaveStart', 'Time of wave onset (ms)',        2000,0,6000};      % within the stimulus, at what time does sound start
pp{4}  = {'WaveStop', 'Time of wave offset (ms)',        4000,0,6000};      % within the stimulus, at what time does sound stop
pp{5}  = {'WaveFreq',  'Frequency (Hz*10)',             4400,0,20000};      % how often pip is played
pp{6}  = {'WaveDurOn',     'Duration of on period (ms)',   20,0,1000};      % duration of pip
pp{7}  = {'ToneFreq',     'Tone frequency (Hz*10)',   200,0,10000};         % pitch of tone
pp{8} = {'RiseTime',   'Rise and fall time (ms)',  5  ,0,500};
x = XFile('stimWaveTrainEJ',pp);
%  x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10;   % s                                                 % duration of whole stimulus
WaveAmp = Pars(2)/1000;                                                     % amplitude, ie how loud sound is

WaveStart   = Pars(3);    % ms                                              % within the stimulus, at what time does sound start
WaveStop    = Pars(4);    % ms                                              % within the stimulus, at what time does sound stop
WaveFreq = Pars(5)/10;    % Hz                                              % how often pip is played
WaveDurOn   = Pars(6);    % ms                                              % duration of pip
ToneFreq = Pars(7)/10;    % Hz If 0, just envelope wave                     % pitch of tone
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
nt = ceil(dur*fs);                                  % calculates how many time points, ie frames, there will be during the whole duration of the stimulus given the sampling rate
tt = (1:nt)./fs;

ntWavestart = ceil(WaveStart/1000*fs);              % calculates the time point, ie nth frame, at which the pip(s) starts
ntWavestop = ceil(WaveStop/1000*fs);                % calculates the last time point, ie last frame, in which there will be a value that is a point within the tone wave sent as a signal to the DAQ
ttWave = (1:ntWavestop-ntWavestart-1)./fs;          % creates a vector to fill all frames between the onset and end of tones, ie must be equal in length

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

SS.WaveStim.Waves = zeros(nt,1);                    % creates vector, ie wave form, that fills the entire length of stimulus (given by dur) and that has nt frames in it, ie how many are needed to match sampling rate
% SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
%     WaveAmp*0.5*(1+square(2*pi*WaveFreq*ttWave, WaveDurOn/1000*WaveFreq*100)').*sin(2*pi*ToneFreq*ttWave)';

dWave = 0 : 1/WaveFreq : ttWave(end);           
dWave = dWave + WaveDurOn/2/1000;

train_rectangle = pulstran(ttWave,dWave,'rectpuls',WaveDurOn/1000);
% creates envelope of a single pip - ie how many points will be contained,
% but this doesn't contain the frequency bit yet, it's just the structure
% onto which the sample points of the wave are going to be mapped to give
% desired frequency

if RiseTime > 0 %2014/12/9
    % this crops the envelope created above to rise in amplitude over the
    % risetime specified
    train_triangle =2*WaveDurOn/RiseTime/1000 *pulstran(ttWave,dWave,'tripuls',WaveDurOn/1000);
    train_output = min(train_triangle,train_rectangle); %trimmed rectangle
elseif RiseTime == 0
    train_output = train_rectangle;
end

tp = linspace(0,log2(ToneFreq),length(ttWave));
tp = 2.^tp;

if ToneFreq > 0 %2014/12/9
    SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
    WaveAmp*train_output'.*sin(2*pi*(ToneFreq + tp).*ttWave)';
    % WaveAmp*train_output'.*sin(2*pi*ToneFreq*ttWave)';
    % this maps the frequency onto the envelope, and does this so it starts
    % at ntWavestart, which corresponds to the frame given by desired onset
    % time of tone, and ends at ntWavestop
elseif ToneFreq == 0 
    SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
    WaveAmp*train_output';
end

% % for rising tone
% % sp = fs*WaveDurOn;            % number of sampling points - fs per second, multiplied by duration of pip
% % tp = 0 : 1/fs : WaveDurOn;      % length(tp) should equal sp+1
% % tp =(1:ntWavestop-ntWavestart-1);
% tp = linspace(0,log2(ToneFreq),length(ttWave));
% tp = 2.^tp;
% 
% %      SS.WaveStim.Waves(ntWavestart:ntWavestop-2) = ...
%      testWave = WaveAmp*train_output'.*sin(2*pi*(ToneFreq + tp).*ttWave)';
%      % what I need is to add another vector to ToneFreq that
%      % logarithmically rises from zero to ToneFreq so the last value is
%      % double the value of ToneFreq itself so that it'll be a doubling in
%      % frequency, which will make for a one octave sweep

SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

SS = stimWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play_ds( SS, myScreenInfo);


