function SS = stimWaveBlank(myScreenInfo,Pars)
% stimWaveBlank:	DC laser wave to analogue output 
% 				+ blank 

if nargin < 1, error('Must at least specify myScreenInfo'); end
if nargin < 2, Pars = []; end

%% The parameters and their definition
pp = cell(1,1);
pp{1} = {'dur',         'Stimulus duration      (s*10)',       20,1,6000};
pp{2} = {'Vamp',        'Pulse amplitude        (mV)',         3300,0,5000};
pp{3} = {'LaserOn',     'Laser on time	 	(ms*10)',      0,0,5000};
pp{4} = {'LaserOff',    'Laser off time        	(ms)',	       1000,0,5000};
pp{5} = {'trigType',    'Manual(1), HwDigital(2), Immediate(3)',2,1,3};

x = XFile('stimWaveBlank',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars), Pars = x.ParDefaults; end
dur     	= Pars(1)/10;   % s, duration
Vamp    	= Pars(2)/1000; % V, pulse amplitude 
LaserOn       	= Pars(3)/10000;   % Laser on time in s
LaserOff       	= Pars(4)/10000;   % Laser off time in s
trigType	= Pars(5);	% trigger type

%% Make the wave to analogue output
SS = ScreenStim; % initialization
SS.Type = 'stimWaveBlank';
SS.Parameters = Pars;

% Laser on (DC mode)   
fs = 30000; % # of frames in 1s
nt = ceil(dur*fs); % total # of frames in dur
tt = (1:nt)./fs; % corresponding time in s for each frame
if LaserOff ~=0
 istart = ceil(LaserOn*fs); % frame # that corresponds to laser on 
 if istart<1, istart=1; end %if LaserOn = 0, trigger at frame 1
 iend = ceil(LaserOff*fs) % frame # that corresponds to laser on 
 if iend>nt, iend=nt, end %if LaserOff > last frame, trigger at last frame
 pulse = zeros(nt,1);
 pulse(istart:iend) = Vamp;
else
 pulse = [];
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

%% Make a blank visual stimulus 
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
SS = stimWaveBlank(myScreenInfo); %#ok<UNRCH>
SS.Show(myScreenInfo)
Play( SS, myScreenInfo);
