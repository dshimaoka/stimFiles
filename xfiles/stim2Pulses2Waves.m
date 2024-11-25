function SS = stim2Pulses2Waves(myScreenInfo,Pars)
% stim2Pulses2Wave  make 1 or 2 pulses (can be of different wavelengths) + blank
%
% SS = stim2Pulses2Waves(myScreenInfo,Pars) returns object SS of type ScreenStim
% SS = stim2Pulses2Waves(myScreenInfo) uses the default parameters
%
% 2015-05-13 IC	1 or 2 wave pulses (can be of green or blue).
% For single blue pulse,  set pulseType = 1 and intT=0
% For single green pulse, set pulseType = 2 and intT=0

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition

pp = cell(1,1);
pp{1} = {'dur',       'Stimulus duration       (s*10)',        20,1,6000};
pp{2} = {'Vamp',      'Pulse amplitude         (mV)',          3300,0,5000};
pp{3} = {'durT',      'Pulse duration          (ms*10)',       5,1,5000};
pp{4} = {'intT',      'Pulse-to-pulse interval (ms)',          5,0,1000};
pp{5} = {'trigType',  'Manual(1), HwDigital(2), Immediate(3)', 2,1,3};
pp{6} = {'pulseType', 'BB(1), GG(2), BG(3), GB(4); B: A0, G: A1', 1,1,4};

x = XFile('stim2Pulses2Waves',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end
dur     	= Pars(1)/10;    % s, duration
Vamp    	= Pars(2)/1000;  % V, pulse amplitude 
durT		= Pars(3)/10000; % s, duration of pulse
intT		= Pars(4)/1000;  % s, pulse-to-pulse interval
trigType	= Pars(5);	 % trigger type
pulseType       = Pars(6);       % pulseType, blue/blue, blue/green, etc 

%% Make the wave output (to analogue output)
SS = ScreenStim; % initialization
SS.Type = 'stim2Pulses2Waves';
SS.Parameters = Pars;
rng(Pars(4)); % seeds the random number generator 
ss = []; % generate 1st pulse with jitter 300ms + rand(1)*200ms
ss = 0.3+rand(1)*0.2; if intT~=0, ss(end+1) = ss(end)+durT+intT; end

fs = 30000; % # of frames in 1s
nt = ceil(dur*fs); % total # of frames in dur
tt = (1:nt)./fs; % corresponding time in s for each frame
ii = round(ss*fs); ni=length(ii); % frame # that corresponds to iith event
% use ceil(ss*fs) can result in n+1 frame instead of n frame!
if find(ii>=nt), error('pulses > dur!'); end

onframe = (durT)*fs-2;
pulse=zeros(nt,2);
if pulseType     == 1, for i=1:ni, pulse(ii(i):ii(i)+onframe,1) = Vamp; end,
elseif pulseType == 2, for i=1:ni, pulse(ii(i):ii(i)+onframe,2) = Vamp; end,
elseif pulseType == 3 
  pulse(ii(1):ii(1)+onframe,1) = Vamp; 
  pulse(ii(2):ii(2)+onframe,2) = Vamp;
else  
  pulse(ii(1):ii(1)+onframe,2) = Vamp;
  pulse(ii(2):ii(2)+onframe,1) = Vamp;
end

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

SS = stim2Pulses2Waves(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
