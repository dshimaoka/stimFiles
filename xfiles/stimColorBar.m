function SS = stimColorBar(myScreenInfo,Pars)
% stimColorBar makes a color bar
%
% SS = stimColorBar(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimColorBar(myScreenInfo) uses the default parameters
%
% 2011-02 AP

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',        600,1,600};
pp{2}  = {'tf',     'Temporal frequency (Hz *10)',      1,1,400};
pp{3}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{4}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{5}  = {'ori',    'Orientation (deg)',                90,0,360};
pp{6} = {'len',     'Bar length (deg*10)',                  300, 1, 900};
pp{7} = {'wid',     'Bar width (deg*10)',                    50, 1, 900};
pp{8} = {'xfocus',  'Focus position, x (deg*10)',           0,-900, 900};
pp{9} = {'yfocus',  'Focus position, y (deg*10)',           0, -300, 300};
pp{10}  = {'cr',    'Contrast of red gun (%)',          100,0,100};
pp{11}  = {'cg',	'Contrast of green gun (%)',        100,0,100};
pp{12}  = {'cb',	'Contrast of blue gun (%)',         100,0,100};
pp{13}  = {'lr',	'Mean luminance of red gun (%)',    50,0,100};
pp{14}  = {'lg',    'Mean luminance of green gun (%)',  50,0,100};
pp{15}  = {'lb',    'Mean luminance of blue gun (%)',   50,0,100};

x = XFile('stimColorBar',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur         = Pars(1)/10; % s, duration
tfreq	 	= Pars(2)/10;              % Hz
sfreq  		= Pars(3)/100;             % cpd
spatphase  	= Pars(4) * (pi/180);      % radians
orientation 	= Pars(5);                 % deg
len     = myScreenInfo.Deg2Pix( Pars(6)/10 );   % pixels
wid     = myScreenInfo.Deg2Pix( Pars(7)/10 );
[x0,y0] = myScreenInfo.Deg2PixCoord( Pars(8)/10, Pars(9)/10 );
cc 	= Pars(10:12)/100;         % between 0 and 1
mm 	= Pars(13:15)/100;     % between 0 and 1

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = repmat(orientation,[1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

SS.SourceRects = repmat([1; 1; wid; len],[1 1 SS.nFrames]);
SS.DestRects   = repmat(round([ x0-wid/2; y0-len/2; x0+wid/2; y0+len/2 ]),[1 1 SS.nFrames]);
SS.MinusOneToOne = 0;

CyclesPerPix = 1/myScreenInfo.Deg2Pix(1/sfreq); % sf in cycles/pix

% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* CyclesPerPix * (1-wid/2:wid/2) + spatphase;

SS.nImages = 3;
ContrastImage = ones(len,wid);
indeces_darkcontrast = (sin( AngFreqs)<0);
ContrastImage(:,indeces_darkcontrast) = -1;
ImageTextures = cell(SS.nImages,1);
Factor = [0 1 -1];
for iImage = 1:SS.nImages
    ImageTextures{iImage} = zeros(len,wid,3);
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = uint8(255*mm(igun)*(1+cc(igun)*Factor(iImage)*ContrastImage));
    end
end

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

if SS.nImages*tfreq>myScreenInfo.FrameRate,
    SS.ImageSequence = 1+mod(1:SS.nFrames,SS.nImages);
else
    nFramesPerCycle = SS.nImages*round(myScreenInfo.FrameRate/(SS.nImages*tfreq));
    nCycles = floor(SS.nFrames/nFramesPerCycle);
    singlecycle_sequence = [ones(1,nFramesPerCycle/3) ones(1,nFramesPerCycle/3)*2 ones(1,nFramesPerCycle/3)*3];
    if nCycles>0
        SS.ImageSequence = repmat(singlecycle_sequence,[1 nCycles]);
        SS.ImageSequence(nCycles*nFramesPerCycle+1:SS.nFrames)=SS.ImageSequence(1:SS.nFrames-(nCycles*nFramesPerCycle));
    else
        SS.ImageSequence = singlecycle_sequence(1:SS.nFrames);
    end
end

%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
return

%% To test the code

% run this once
RigInfo = RigInfoGet;
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

%  make the stimulus

dur  = 20; % Stimulus duration (s *10)
tf = 20;
sf = 10;
sph = 0;
ori = 0;
len = 200;
wid = 50;
xfocus = 0;
yfocus = 0; % Focus position, y (deg*10)

pars = [ dur tf sf sph ori len wid xfocus yfocus 50 50 50 50 50 50 ];

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimColorBar',pars); 

show(myScreenStim2, myScreenInfo);
Screen('CloseAll');

% play it
% Play(myScreenStim2,myScreenInfo);




