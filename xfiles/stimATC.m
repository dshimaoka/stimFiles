function SS = stimATC(myScreenInfo,Pars)
% stimATC is for auditory trace (or delay) conditioning
%
% SS = stimATC(myScreenInfo,Pars) returns an object SS of type ScreenStim
% SS = stimATC(myScreenInfo) uses the default parameters
%
% 2014-04 MO


if nargin < 1
  error('Must at least specify myScreenInfo');
end

if nargin < 2
  Pars = [];
end

%---- The parameters and their definition

pp = cell(1,1);
pp{1}  = {'durTotal',  'Stimulus duration (s*10)',        30, 1,600};
pp{2}  = {'SineAmp',   'Amplitude of tone (mV)',         100, 0, 5000};
pp{3}  = {'SineFreq',  'Frequency of tone (Hz)',        9500, 0,30000};
pp{4}  = {'tTone', 'Time of onset of auditory event (ms)',1000, 0,60000};
pp{5}  = {'durTone',   'Duration of auditory event (ms)',350, 0,1000};
pp{6}  = {'durInt',      'Duration of interval (ms)',      250, 0,600};
pp{7}  = {'durPuff',      'Duration of puff (ms)',          100, 0,500};
pp{8}  = {'trigtype',  'Manual(1), HwDigital(2), Immediate(3)', 1, 1, 3}; %IC

x = XFile('stimATC',pp);
% x.Write; % call this ONCE: it writes the .x file

%---- Parse the parameters

if isempty(Pars)
  Pars = x.ParDefaults;
end

durTotal = Pars(1)*100;   % ms
Vamp     = Pars(2)/1000; % V
toneFreq = Pars(3);   % Hz

tTone = Pars(4);
durTone = Pars(5);
durInt = Pars(6);
durPuff = Pars(7);
triggerType=Pars(8); 

assert(durTotal >= tTone+durTone+durInt+durPuff); %otherwise the parameters specified are inconsistent

%---- Make the stimulus

SS = ScreenStim; % initialization
SS.Type = 'stimATC';
SS.Parameters = Pars;

fs = 1e5;

tone =  zeros(ceil(durTotal/1e3*fs),1);
valve = zeros(ceil(durTotal/1e3*fs),1);

tone(ceil(tTone/1e3*fs):ceil(tTone/1e3*fs)+ceil(durTone/1e3*fs)-1) = ...
  Vamp*cos(toneFreq*(1:ceil(fs*durTone/1e3))*(2*pi/fs))';
valve(ceil((tTone+durTone+durInt)/1e3*fs):ceil((tTone+durTone+durInt+durPuff)/1e3*fs)-1) = 5;

% % Add another 0.25s of "silence" to both signals:
% valve = [valve; zeros(round(fs*0.25), 1)]; 
% tone = [tone; zeros(round(fs*0.25), 1)];
valve(end)=0; %this closes the valve, very important !!!

SS.WaveStim.Waves = [valve tone];
SS.WaveStim.SampleRate = fs;

switch triggerType 
  case 1
    SS.WaveStim.TriggerType = 'Manual';
  case 2
    SS.WaveStim.TriggerType = 'HwDigital';
  case 3
    SS.WaveStim.TriggerType = 'Immediate';
end 

% a blank visual stimulus
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*durTotal/1e3);
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

SS = stimATC(myScreenInfo);
SS.Show(myScreenInfo);
Play(SS, myScreenInfo);
