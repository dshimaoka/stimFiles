function SS = stimKalatsky_xpos(myScreenInfo,Pars)
% stimKalatsky_xpos makes color flickering bars moving in the x direction
%
% SS = stimKalatsky_xpos(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimKalatsky_xpos(myScreenInfo) uses the default parameters
%
% 2011-05 AP

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',        50,1,600};
pp{2}  = {'tf',     'Temporal frequency (Hz *100)',      1,1,400};
pp{3}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{4}  = {'tph',    'Temporal phase (deg)',              0,0,360};
pp{5}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{6}  = {'dir',    'Direction of movement',                1,-1,1};
pp{7} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{8}  = {'flickfreq',    'Temporal frequency of flicker (Hz *10)',   40,1,400};
pp{9}  = {'cr',    'Contrast of red gun (%)',          100,0,100};
pp{10}  = {'cg',	'Contrast of green gun (%)',        0,0,100};
pp{11}  = {'cb',	'Contrast of blue gun (%)',         0,0,100};
pp{12}  = {'lr',	'Mean luminance of red gun (%)',    50,0,100};
pp{13}  = {'lg',    'Mean luminance of green gun (%)',  0,0,100};
pp{14}  = {'lb',    'Mean luminance of blue gun (%)',   0,0,100};

x = XFile('stimKalatsky_xpos',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur         = Pars(1)/10; % s, duration
tfreq	 	= Pars(2)/100;              % Hz
sfreq  		= Pars(3)/100;             % cpd
temporalphase  	= Pars(4);      % degree
spatphase  	= Pars(5) * (pi/180);      % radians
tfreq_flicker = Pars(8)/10; %Hz
direction 	= Pars(6);                 % deg
cyN     = Pars(7);
cc 	= Pars(9:11)/100;         % between 0 and 1
mm 	= Pars(12:14)/100;     % between 0 and 1

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.Orientations = zeros([1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

wid = myScreenInfo.Deg2Pix(cyN/sfreq);
Lx = myScreenInfo.Xmax/2; 
Ly = myScreenInfo.Ymax;
len = Ly;
SS.MinusOneToOne = 0;

CyclesPerPix = cyN/wid; % sf in cycles/pix

% Translate requested speed of the grating (in cycles per second)
% into a shift value in "pixels per frame". 

shiftperframe = direction*Lx*tfreq/myScreenInfo.FrameRate;

x0 = direction*Lx*temporalphase/360;

for iframe = 1 : SS.nFrames
    xoffset = ceil(mod(x0+iframe*shiftperframe,Lx));
    SS.SourceRects(:,1,iframe) = [1; 1;  wid; len];
    SS.DestRects(:,1,iframe)  = [xoffset; 0; xoffset+wid; len];
end

AngFreqs = -2*pi* CyclesPerPix * (1-wid/2:wid/2) + spatphase;

SS.nImages = 2;
ContrastImage = ones(len,wid);
indeces_darkcontrast = (sin( AngFreqs)<0);
ContrastImage(:,indeces_darkcontrast) = -1;
ImageTextures = cell(SS.nImages,1);
Factor = [1 -1];
for iImage = 1:SS.nImages
    ImageTextures{iImage} = zeros(len,wid,3);
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = ...
            uint8(255*mm(igun)*(1+cc(igun)*Factor(iImage)*ContrastImage));
    end
end

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

if (SS.nImages)*tfreq_flicker>myScreenInfo.FrameRate,
    SS.ImageSequence = 1+mod(1:SS.nFrames,SS.nImages);
else
    nFramesPerCycle = (SS.nImages)*round(myScreenInfo.FrameRate/((SS.nImages)*tfreq_flicker));
    nCycles = floor(SS.nFrames/nFramesPerCycle);
    for i=1:(SS.nImages),
        ind_seq = (1:nFramesPerCycle/(SS.nImages));
        singlecycle_sequence(ind_seq+(i-1)*nFramesPerCycle/(SS.nImages)) = i*ones(1,nFramesPerCycle/(SS.nImages));
    end
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

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimKalatsky_xpos'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures