function SS = stimWaveOutputIC1013(myScreenInfo,Pars)
% stimWaveOutput makes wave stimuli (nothing visual)
%
% SS = stimWaveOutput(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimWaveOutput(myScreenInfo) uses the default parameters
%
% 2011-02 MC
% 2013-10 IC introduced 'trigtype' so a waveout can be triggered by photodiode
%            cf. 'stimOptiWaveOutPut.m' 

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
pp{12}  = {'trigtype',  'Manual(1), HwDigital(2), Immediate(3)', 1, 1, 3}; %IC


x = XFile('stimWaveOutputIC1013',pp);
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

triggerType=Pars(12); % IC

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimWaveOutputIC1013';
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

switch triggerType % IC
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

SS = stimWaveOutputIC1013(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
