function SS = stimPoissonWave(myScreenInfo,Pars)
% stimPoissonWave makes Poisson train wave/TTL stimuli (visual: 'blank')
%
% SS = stimPoissonWave(myScreenInfo,Pars) returns object SS of type ScreenStim
% SS = stimPoissonWave(myScreenInfo) uses the default parameters
%
% 2011-02 MC (stimWaveOuput)
% 2013-10 IC introduced 'trigType' so a waveout can be triggered by photodiode
%            cf. 'stimOptiWaveOutPut.m' 
% 2014-10 IC pulses generated from Poisson process (single wave output only)

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition

pp = cell(1,1);
pp{1} = {'dur',		'Stimulus duration	(s*10)',	50,1,6000};
pp{2} = {'Vamp',	'Pulse amplitude	(mV)',		3300,0,5000};
pp{3} = {'f',		'Mean Poisson rate	(Hz*10)',	10,0,20000};
pp{4} = {'durT',	'Pulse duration		(ms*10)',	5,1,600};
pp{5} = {'seed',	'Seed of random number generator',	1,1,100};
pp{6} = {'trigType',	'Manual(1), HwDigital(2), Immediate(3)',2,1,3};

x = XFile('stimPoissonWave',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end
dur     	= Pars(1)/10;   % s, duration
Vamp    	= Pars(2)/1000; % V, pulse amplitude 
f       	= Pars(3)/10;   % Hz, mean rate of Poisson train
durT		= Pars(4)/10000; % s, duration of pulse
seed		= Pars(5);	% seed for randon number generator
trigType	= Pars(6);	% trigger type

%% Make the wave output (to analogue output)
SS = ScreenStim; % initialization
SS.Type = 'stimPoissonWave';
SS.Parameters = Pars;
rng(seed, 'twister'); % seeds the random number generator 

% generate poisson spike train (single train only)
ss = []; dt = 1/1000; % dt in s
for t = 1 : dt : dur 
  if f * dt >= rand(1), ss(end + 1) = t; end
end
ss( find(diff(ss)<durT) ) = [];

fs = 30000; % # of frames in 1s
nt = ceil(dur*fs); % total # of frames in dur
tt = (1:nt)./fs; % corresponding time in s for each frame
ii = ceil(ss*fs); % frame # that corresponds to iith event
ii(ii<1)  = 1; ii(ii>nt) = nt;

% if find(diff(ii)/fs<durT), error('pulses too close together!'); end
onframe = (durT)*fs-2;
pulse = zeros(nt,1);
for i=1:length(ii), pulse(ii(i):ii(i)+onframe,1) = Vamp; end
% figure; plot(tt, pulse)

SS.WaveStim.Waves = pulse;
SS.WaveStim.SampleRate = fs;

switch trigType % IC
    case 1
        SS.WaveStim.TriggerType = 'Manual';        
    case 2
        SS.WaveStim.TriggerType = 'HwDigital';
    case 3
        SS.WaveStim.TriggerType = 'Immediate';
end % IC

% overlap with a blank visual stimulus
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

SS = stimPoissonWave(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
