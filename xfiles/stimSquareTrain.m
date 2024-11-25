function SS = stimSquareTrain(myScreenInfo,Pars)
% stimSquareTrain makes wave stimuli (nothing visual)
%
% SS = c(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimSquareTrain(myScreenInfo) uses the default parameters
%
% 2011-05 TS

%% 

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

% TS change from here:
pp = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration (s*10)',        50,1,600};
pp{2}  = {'SineAmp',   'Amplitude of sinusoid (mV)',       100, 0, 5000};
pp{3}  = {'SineFreq',  'Frequency (Hz*10)',               4400,0,20000};
pp{4}  = {'t1',        'Time of 1st event (ms)',        2000,0,6000};
pp{5}  = {'v1',        'Value at 1st event (mV)',      -1000,-5000,5000};
pp{6}  = {'t2',        'Time of 2nd event (ms)',        3000,0,6000};
pp{7}  = {'v2',        'Value at 2nd event (mV)',      -2000,-5000,5000};
pp{8}  = {'t3',        'Time of 3rd event (ms)',        3000,0,6000};
pp{9}  = {'v3',        'Value at 3rd event (mV)',       1000,-5000,5000};
pp{10}  = {'t4',        'Time of 4th event (ms)',        4000,0,6000};
pp{11}  = {'v4',        'Value at 4th event (mV)',       2000,-5000,5000};

x = XFile('stimSquareTrain',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10;   % s
Vamp    = Pars(2)/1000; % V
f       = Pars(3)/10;   % Hz

ss = Pars(4:2:10)/1000; % s
vv = Pars(5:2:11)/1000; % V

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimWaveOutput';
SS.Parameters = Pars;

fs = 40000; 
nt = ceil(dur*fs);
tt = (1:nt)./fs;

ii = ceil(ss*fs);
ii(ii<1)  = 1;
ii(ii>nt) = nt;

sinewave = Vamp*sin(2*pi*f*tt)'; 
steps = zeros(nt,1);
steps( ii(1):ii(2) ) = vv(1)+ linspace(0,1,ii(2)-ii(1)+1)*(vv(2)-vv(1));
steps( ii(3):ii(4) ) = vv(3)+ linspace(0,1,ii(4)-ii(3)+1)*(vv(4)-vv(3));
SS.WaveStim.Waves = sinewave+steps;
% figure; plot(tt,SS.WaveStim.Waves)
SS.WaveStim.SampleRate = fs;

% TS change to here

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

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimSquareTrain(myScreenInfo); 
SS.Show(myScreenInfo) % shows the wave, without playing it
Play( SS, myScreenInfo);

% once the code does what you want, uncomment the line
% x.Write; 
% and run ONCE: it writes the .x file

% then, run PfileInitialize, which will create a pfile called
% stimSquareTrainDemo.p, then find it (good luck), and open it in zpep...

