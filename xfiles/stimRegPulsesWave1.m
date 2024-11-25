function SS = stimRegPulsesWave1(myScreenInfo,Pars)
% stimRegPulsesWave1	makes a train of 5 wave stimuli at regular interval +
%			gray screen
%
% SS = stimRegPulsesWave1(myScreenInfo,Pars) returns object SS of type ScreenStim
% SS = stimRegPulsesWave1(myScreenInfo) uses the default parameters
%
% 2014-10 IC train of 5 pulses at regular time 
% 2015-11 IC train of X pulses at regular time for X sec

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition

pp = cell(1,1);
pp{1} = {'dur',         'Stimulus duration      (s*10)',        50,1,6000};
pp{2} = {'Vamp',        'Pulse amplitude        (mV)',          2000,0,5000};
pp{3} = {'f',           'Frequency of pulses	(Hz*10)',       200,0,20000};
pp{4} = {'durT',        'Pulse duration         (ms*10)',       5,1,1000};
pp{5} = {'seed',        'Seed of random number generator',      1,1,100};
pp{6} = {'trigType',    'Manual(1), HwDigital(2), Immediate(3)',2,1,3};

x = XFile('stimRegPulsesWave1',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end
dur     	= Pars(1)/10;   % s, duration
Vamp    	= Pars(2)/1000; % V, pulse amplitude 
f       	= Pars(3)/10;   % Hz, pulse frequency 
durT		= Pars(4)/10000; % s, duration of pulse
seed            = Pars(5);      % seed for randon number generator
trigType	= Pars(6);	% trigger type

%% Make the wave output (to analogue output)
SS = ScreenStim; % initialization
SS.Type = 'stimRegPulsesWave1';
SS.Parameters = Pars;
% rng(seed); % seeds the random number generator 

% generate 5-pulse train
ss = [];
beg = 0.1; % pulse beg 100ms in and stops 100ms before end
ss = [beg:1/f:dur-beg];
if find(ss>=dur), error('pulses > dur!'); end

fs = 30000; % # of frames in 1s
nt = ceil(dur*fs); % total # of frames in dur
tt = (1:nt)./fs; % corresponding time in s for each frame
ii = round(ss*fs); % frame # that corresponds to iith event
% use ceil(ss*fs) can result in n+1 frame instead of n frame!
ii(ii<1)  = 1; ii(ii>nt) = nt;

onframe = (durT)*fs-2;
pulse=zeros(nt,1);
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

SS = stimRegPulsesWave1(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
