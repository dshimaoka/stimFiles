function SS = stimTTLChirp(myScreenInfo,Pars)
% stimTTLOutput rectanglar wave (AO0) of a DMD pattern (ptnIdx)
% SS = stimTTLSwitch(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% 2025-04 created from stimTTLWaveOutput

%%

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',       'Stimulus duration (s*10)',          100,1,12000};
%Sinusoidal Wave AO0
pp{2}  = {'WaveAmp',   'Amplitude of wave (mV*1000)',    100, 0, 5000};
pp{3}  = {'WaveFreqInit',  'Start Frequency (Hz*1000)',             1,0,200000};
pp{4}  = {'WaveFreqLast',  'Start Frequency (Hz*1000)',             1,0,200000};
pp{5}  = {'chirpType',  '0:linear, 1:exponential',             1,0,1};

x = XFile('stimTTLChirp',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur     = Pars(1)/10;   % s
WaveAmp = Pars(2)/1000; % V
WaveFreqInit = Pars(3)/1000;    % Hz
WaveFreqLast = Pars(4)/1000;    % Hz
chirpType = Pars(5); %0:linear, 1:exponential

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimTTLChirp';
SS.Parameters = Pars;

fs = myScreenInfo.WaveInfo.SampleRate;%6600*2;%5000;
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


%% wave
Vth = 0;
switch chirpType
    case 0
        %option 1: linear
        c = (WaveFreqInit - WaveFreqLast)/dur;
        Waves(:,1) = ...
            (WaveAmp-Vth)*abs(sin(2*pi*(c/2*tt.^2+WaveFreqLast*tt))') + Vth;
        Waves(:,2) = ...
            5*abs(square(4*pi*(c/2*tt.^2+WaveFreqLast*tt))'+1);
        
    case 1
        %option 2: exponential
        k = WaveFreqInit/WaveFreqLast;
        Waves(:,1) = ...
            (WaveAmp-Vth)*abs(sin(2*pi*WaveFreqLast*(dur*(k.^(tt/dur)-1)/log(k)))') + Vth;
        Waves(:,2) = ...
            5*abs(square(4*pi*WaveFreqLast*(dur*(k.^(tt/dur)-1)/log(k)))'+1);
end

%after Wave, reset to the 1st ptn
% nFlips =  ceil((ntWavestop-ntWavestart)/fs*2);
nFlips = sum(diff(Waves(:,2))>0);
if mod(nFlips,2) == 1
    SS.WaveStim.Waves(end,2) = 5;
end

SS.WaveStim.SampleRate = fs;

SS.MinusOneToOne = 0;

return

%% To test the code

SS = stimTTLWaveChirp(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
show( SS, myScreenInfo);



%% to visualize result
% window_length = round(4 * fs);   % 50 ms window (adjust as needed)
% overlap = round(0.9 * window_length);
% nfft = max(256, 2^nextpow2(window_length));
% 
% % --- Compute spectrogram ---
% [S, F, T] = spectrogram(Waves(:,1), window_length, overlap, nfft, fs);
% 
% % --- Convert to power (dB) ---
% S_dB = 20*log10(abs(S) + eps);
% 
% % --- Plot ---
% figure;
% ax(1)=subplot(211);
% plot(tt, Waves)
% 
% ax(2)=subplot(212);
% imagesc(T, F, S_dB);
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('Spectrogram of Chirp Signal');
% mcolorbar;
% colormap jet;
% ylim(sort([WaveFreqLast WaveFreqInitial]));  % adjust depending on expected range
% linkaxes(ax,'x');

