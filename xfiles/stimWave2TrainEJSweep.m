function SS = stimWave2TrainEJSweep(myScreenInfo,Pars)
% stim2WaveTrain makes 2lines of Wave stimuli (nothing visual)
%
% To use this script as TTL output, set RiseTime and ToneFreq as 0, and
% WaveAmp as 5000
%

%% 

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration (s*10)',          100,1,600};
%1st output
pp{2}  = {'WaveAmp1',   'Amplitude of sinusoid (mV*1000)',    100, 0, 5000};
pp{3}  = {'WaveStart1', 'Time of stim onset (ms)',        2000,0,6000};
pp{4}  = {'WaveStop1', 'Time of stim offset (ms)',        4000,0,6000};
pp{5}  = {'WaveFreq1',  'Frequency (Hz*10)',             4400,0,20000};
pp{6}  = {'WaveDurOn1',     'Duration of on period for wave (ms)',   20,0,10000};   %EJ changed this on 10/06/15 in the hopes of making it possible to have a longer duration than 1 sec
pp{7}  = {'ToneFreq1',     'Tone frequency (Hz*10)',   200,0,10000};
pp{8}  = {'SweepUpDown',    'Sweep (0 for up, 1 for down)', 0,0,1};
pp{9} = {'RiseTime1',   'Rise and fall time (ms)',  5  ,0,500};
%2nd output
pp{10}  = {'WaveAmp2',   'Amplitude of sinusoid (mV*1000)',    100, 0, 5000};
pp{11}  = {'WaveStart2', 'Time of stim onset (ms)',        2000,0,6000};
pp{12}  = {'WaveStop2', 'Time of stim offset (ms)',        4000,0,6000};
pp{13}  = {'WaveFreq2',  'Frequency (Hz*10)',             4400,0,20000};
pp{14}  = {'WaveDurOn2',     'Duration of on period for wave (ms)',   20,0,1000};
pp{15}  = {'ToneFreq2',     'Tone frequency (Hz*10)',   200,0,10000};
pp{16} = {'RiseTime2',   'Rise and fall time (ms)',  5  ,0,500};
x = XFile('stimWave2TrainEJSweep',pp);
%x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur             = Pars(1)/10;   % s
WaveAmp(1)      = Pars(2)/1000;
WaveStart(1)    = Pars(3);      % ms
WaveStop(1)     = Pars(4);      % ms
WaveFreq(1)     = Pars(5)/10;   % Hz
% WaveDurOn(1)    = WaveStop(1) - WaveStart(1);       % considering I want the tonesweep to be continuous, there is no need for the WaveDurOn parameter to be separate
WaveDurOn(1)    = Pars(6);      % ms
ToneFreq(1)     = Pars(7)/10;   % Hz If 0, just envelope wave
SweepDir        = Pars(8);      % 0: tone starts at ToneFreq/2 and goes up to ToneFreq, 1: tone starts at ToneFreq and goes down to ToneFreq/2
RiseTime(1)     = Pars(9)/1000; %s If 0, no truncation

WaveAmp(2)      = Pars(10)/1000;
WaveStart(2)    = Pars(11);     % ms
WaveStop(2)     = Pars(12);     % ms
WaveFreq(2)     = Pars(13)/10;  % Hz
WaveDurOn(2)    = Pars(14);     % ms
ToneFreq(2)     = Pars(15)/10;    % Hz If 0, just envelope wave
RiseTime(2)     = Pars(16)/1000;  % s If 0, no truncation
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

%fs = 125e3; %13.10,20
fs = myScreenInfo.WaveInfo.SampleRate; %DS 2015-3-25
nt = ceil(dur*fs);
tt = (1:nt)./fs;


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

SS.WaveStim.Waves = zeros(nt,2);

for ch = 1:2
    ntWavestart = ceil(WaveStart(ch)/1000*fs);
    ntWavestop = ceil(WaveStop(ch)/1000*fs);
    ttWave = (1:ntWavestop-ntWavestart-1)./fs;
    
    dWave = 0 : 1/WaveFreq(ch) : ttWave(end);
    dWave = dWave + WaveDurOn(ch)/2/1000;
    
    train_rectangle = pulstran(ttWave,dWave,'rectpuls',WaveDurOn(ch)/1000);
    
    
    if RiseTime(ch) > 0 %2014/12/9
        train_triangle =2*WaveDurOn(ch)/RiseTime(ch)/1000 *pulstran(ttWave,dWave,'tripuls',WaveDurOn(ch)/1000);
        train_output = min(train_triangle,train_rectangle);%trimmed rectangle
    elseif RiseTime(ch) == 0
        train_output = train_rectangle;
    end
    
    if ToneFreq(ch) > 0 %2014/12/9
        %         tp = linspace(0,log2(ToneFreq(ch)),length(ttWave));
        %         tp = 2.^tp;
        tp = linspace(-1,0,length(ttWave));
        if SweepDir == 0;
            SS.WaveStim.Waves(ntWavestart:ntWavestop-2, ch) = ...
                WaveAmp(ch)*train_output'.*sin(2*pi*(ToneFreq(ch)*2.^tp).*ttWave)';
        elseif SweepDir == 1;
            tp=flip(tp);
            SS.WaveStim.Waves(ntWavestart:ntWavestop-2, ch) = ...
                WaveAmp(ch)*train_output'.*sin(2*pi*(ToneFreq(ch)*2.^tp).*ttWave)';
        end
                
        %WaveAmp(ch)*train_output'.*sin(2*pi*ToneFreq(ch)*ttWave)';
    elseif ToneFreq(ch) == 0
        SS.WaveStim.Waves(ntWavestart:ntWavestop-2, ch) = ...
            WaveAmp(ch)*train_output';
    end
end

SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0; 

return

%% To test the code

SS = stimWaveOutput(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play_ds( SS, myScreenInfo);


