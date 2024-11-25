function SS = stimOnePulseWave_test(myScreenInfo,Pars)
% stimOnePulseWave	makes one wave pulse + gray screen (for testing)
%
% SS = stimOnePulseWave(myScreenInfo,Pars) returns object SS of type ScreenStim
% SS = stimOnePulseWave(myScreenInfo) uses the default parameters
%
% 2019-10 DS created from stimOnePulseWave.m by IC

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition

pp = cell(1,1);
pp{1} = {'dur',         'Stimulus duration      (s*10)',        20,1,6000};
pp{2} = {'Vamp',        'Pulse amplitude        (mV)',          3300,0,5000};
pp{3} = {'durT',        'Pulse duration         (ms*10)',       5,1,5000};
pp{4} = {'trigType',    'Manual(1), HwDigital(2), Immediate(3)',2,1,3};
pp{5} = {'initT',        'Start time of pulse    (s*10)',      5,1,5000};

x = XFile('stimOnePulseWave_test',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end
dur     	= Pars(1)/10;   % s, duration
Vamp    	= Pars(2)/1000; % V, pulse amplitude 
durT		= Pars(3)/10000; % s, duration of pulse
trigType	= Pars(4);	% trigger type
initT       = Pars(5)/10;      % s, time

%% Make the wave output (to analogue output)
SS = ScreenStim; % initialization
SS.Type = 'stimOnePulseWave';
SS.Parameters = Pars;
%rng(seed); % seeds the random number generator 
%ss = []; % generate 1st pulse with jitter 300ms + rand(1)*200ms
%ss = .3 + rand(1)*.2; % arbitrary definition
ss = initT;

fs = 5000; % # of frames in 1sx
nt = ceil(dur*fs); % total # of frames in dur
tt = (1:nt)./fs; % corresponding time in s for each frame
ii = round(ss*fs); % frame # that corresponds to iith event
% use ceil(ss*fs) can result in n+1 frame instead of n frame!
ii(ii<1)  = 1; % ii(ii>nt) = nt;
if find(ii>=nt), error('pulses > dur!'); end

onframe = (durT)*fs-2;
pulse=zeros(nt,1);
for i=1:length(ii), pulse(ii(i):ii(i)+onframe,1) = Vamp; end
%figure; plot(tt, pulse)

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

SS = stimOnePulseWave(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
