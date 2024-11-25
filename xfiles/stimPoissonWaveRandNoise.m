function SS = stimPoissonWaveRandNoise(myScreenInfo,Pars)
% stimPoissonWaveRandNoise:	Poisson train wave stimuli to analogue output 
% 				+ white noise visual stimulus
%
% 2014-10 IC 	combined stimPoissonWave and stimRandNoiseFixed

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition
pp = cell(1,1);
pp{1} = {'dur',         'Stimulus duration      (s*10)',        50,1,6000};
pp{2} = {'Vamp',        'Pulse amplitude        (mV)',          2000,0,5000};
pp{3} = {'f',           'Mean Poisson rate      (Hz*10)',       10,0,20000};
pp{4} = {'durT',        'Pulse duration         (ms*10)',       5,1,1000};
pp{5} = {'seedp',        'Seed of Poisson train',      1,1,100};
pp{6} = {'trigType',    'Manual(1), HwDigital(2), Immediate(3)',2,1,3};
pp{7}	= {'x1',	'Left border, from center (deg*10)', -400,-1000,500};
pp{8}	= {'x2',	'Right border, from center (deg*10)',  400,-500,1000};
pp{9}	= {'y1',	'Bottom border, from center (deg*10)', -200,-1000,500};
pp{10}	= {'y2',	'Top border, from center (deg*10)',  200,-500,1000};
pp{11}	= {'nfr',	'Number of frames per stimulus',     10,1,70};
pp{12}	= {'sqsz',	'Size of squares (deg*10)',         30,1,100};
pp{13}	= {'ncs',	'Number of contrasts (choose 2 for b&w)', 3,2,16};
pp{14}	= {'c',		'Contrast (%)',                           100,0,100};
pp{15} = {'seedw',        'Seed of white noise',      1,1,100};

x = XFile('stimPoissonWaveRandNoise',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end
dur     	= Pars(1)/10;   % s, duration
Vamp    	= Pars(2)/1000; % V, pulse amplitude 
f       	= Pars(3)/10;   % Hz, mean rate of Poisson train
durT		= Pars(4)/10000; % s, duration of pulse
seedp		= Pars(5);	% seed for Poisson train randon number
trigType	= Pars(6);	% trigger type
[Col1, Row1] = myScreenInfo.Deg2PixCoord( Pars(7)/10, Pars(9)/10 );
[Col2, Row2] = myScreenInfo.Deg2PixCoord( Pars(8)/10, Pars(10)/10 );
Col2 = max(Col2,Col1+1); Row2 = max(Row2,Row1+1);
nFr = Pars(11);
SquareSize = myScreenInfo.Deg2Pix( Pars(12)/10 );
ncs = Pars(13);
c   = Pars(14)/100;
seedw		= Pars(15);	% seed for white noise randome number

%% Make the wave to analogue output
SS = ScreenStim; % initialization
SS.Type = 'stimPoissonWaveRandNoise';
SS.Parameters = Pars;
rng(seedp); % seeds the random number generator (Poisson train) 

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
ii(ii<1) = 1; ii(ii>nt) = nt;

%if find(diff(ii)/fs<durT), error('pulses too close together!'); end
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

rng(seedw); % seeds the random number generator (white noise) 
%% Make the random noise stimulus
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
SS = stimPoissonWaveRandNoise(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
