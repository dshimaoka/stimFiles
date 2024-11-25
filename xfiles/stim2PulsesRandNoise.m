function SS = stim2PulsesRandNoise(myScreenInfo,Pars)
% stim2PulsesRandNoise:
% make 1 or 2 pulses (can be of different wavelengths) + white noise
%
% SS = stim2PulsesRandNoise(myScreenInfo,Pars) returns object SS of 
% type ScreenStim
% SS = stim2PulsesRandNoise(myScreenInfo) uses the default parameters
%
% 2015-05-13 IC	1 or 2 wave pulses (can be of green or blue).
% For single blue pulse,  set pulseType = 1 and intT=0
% For single green pulse, set pulseType = 2 and intT=0

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition
pp     = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration       (s*10)',        20,1,6000};
pp{2}  = {'Vamp',      'Pulse amplitude         (mV)',          3300,0,5000};
pp{3}  = {'durT',      'Pulse duration          (ms*10)',       5,1,5000};
pp{4}  = {'intT',      'Pulse-to-pulse interval (ms)',          5,0,1000};
pp{5}  = {'trigType',  'Manual(1), HwDigital(2), Immediate(3)', 2,1,3};
pp{6}  = {'pulseType', 'BB(1), GG(2), BG(3), GB(4); B: A0, G: A1', 1,1,4};
pp{7}  = {'Tp',        'Time of pulse          (ms)',          500,1,10000};
pp{8}  = {'x1',    'Left border, from center (deg*10)', -400,-1000,500};
pp{9}  = {'x2',    'Right border, from center (deg*10)',  400,-500,1000};
pp{10} = {'y1',   'Bottom border, from center (deg*10)', -200,-1000,500};
pp{11} = {'y2',   'Top border, from center (deg*10)',  200,-500,1000};
pp{12} = {'nfr',   'Number of frames per stimulus',     10,1,70};
pp{13} = {'sqsz',  'Size of squares (deg*10)',         30,1,100};
pp{14} = {'ncs',   'Number of contrasts (choose 2 for b&w)', 3,2,16};
pp{15} = {'c',     'Contrast (%)',                           100,0,100};
pp{16} = {'seedw', 'Seed of white noise',      1,1,100};

x = XFile('stim2PulsesRandNoise',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end
dur     	= Pars(1)/10;    % s, duration
Vamp    	= Pars(2)/1000;  % V, pulse amplitude 
durT		= Pars(3)/10000; % s, duration of pulse
intT		= Pars(4)/1000;  % s, pulse-to-pulse interval
trigType	= Pars(5);	 % trigger type
pulseType       = Pars(6);       % pulseType, blue/blue, blue/green, etc 
Tp              = Pars(7)/1000;  % s, Time of pulse 
[Col1, Row1]    = myScreenInfo.Deg2PixCoord( Pars(8)/10, Pars(10)/10 );
[Col2, Row2]    = myScreenInfo.Deg2PixCoord( Pars(9)/10, Pars(11)/10 );
Col2 = max(Col2,Col1+1); Row2 = max(Row2,Row1+1);
nFr             = Pars(12);
SquareSize      = myScreenInfo.Deg2Pix( Pars(13)/10 );
ncs             = Pars(14);
c               = Pars(15)/100;
seedw           = Pars(16);      % seed for white noise randome number

%% Make the wave output (to analogue output)
SS = ScreenStim; % initialization
SS.Type = 'stim2PulsesRandNoise';
SS.Parameters = Pars;
rng(Pars(4)); % seeds the random number generator 
ss = []; ss = Tp; if intT~=0, ss(end+1) = ss(end)+durT+intT; end

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

%% Make the random noise stimulus
rng(seedw); % seeds the random number generator (white noise) 
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames)*c/2; % why do we need to divide by 2??
SS.BilinearFiltering = 0; % do not interpolate! 
SS.nImages = ceil(SS.nFrames/nFr);

nc = ceil((Col2-Col1)/SquareSize); nr = ceil((Row2-Row1)/SquareSize);
ImageTextures = cell(SS.nImages,1);
for iImage = 1:SS.nImages
    ImageTextures{iImage} = 2*round(ncs*rand(nr,nc,1)-0.5)/(ncs-1)-1; % MK
end

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
SS.ImageSequence = zeros(1,SS.nFrames);

for iFrame = 1:SS.nFrames
    iImage = ceil(iFrame/nFr);
    SS.ImageSequence(iFrame) = iImage; % SS.ImagePointers(iImage);
end

SS.SourceRects = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);

return

%% To test the code

SS = stim2PulsesRandNoise(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
