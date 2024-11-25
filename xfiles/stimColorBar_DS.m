function SS = stimColorBar_DS(myScreenInfo,Pars)
% sbColorGrating makes a color grating
%
% SS = stimColorBar(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimColorBar(myScreenInfo) uses the default parameters
%
% 2011-03 AP

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',        90,1,600};
pp{2}  = {'stT',	'Stimulus start Time  (s *10)',        30,1,600};
pp{3}  = {'enT',	'Stimulus end Time  (s *10)',        80,1,600};
pp{4}  = {'tf',     'Temporal frequency (Hz *10)',      20,1,400};
pp{5}  = {'sf',     'Spatial frequency (cpd *100)',     4,1,200};
pp{6}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{7}  = {'ori',    'Orientation (deg)',                0,0,360};
pp{8} = {'len',     'Bar length (deg*10)',                  300, 1, 2000};
pp{9} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{10} = {'xfocus',  'Focus position, x (deg*10)',           -300,-1500, 1500};
pp{11} = {'yfocus',  'Focus position, y (deg*10)',           0, -600, 600};
pp{12}  = {'cbg',	'Contrast of green & blue gun (%)',        100,0,100};
pp{13}  = {'lbg',	'Mean luminance of green & blue gun (%)',         100,0,100};

x = XFile('stimColorBar2',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur         = Pars(1)/10; % s, total duration of a trial
dur_pre     = Pars(2)/10; %s, duration of the prestimulus period
dur_bar     = Pars(3)/10 - dur_pre;  % s, duration of the flickering bar
tfreq	 	= Pars(4)/10;              % Hz
sfreq  		= Pars(5)/100;             % cpd
spatphase  	= Pars(6) * (pi/180);      % radians
orientation 	= Pars(7);                 % deg
len     = myScreenInfo.Deg2Pix( Pars(8)/10 );   % pixels
cyN     = Pars(9);
[x0,y0] = myScreenInfo.Deg2PixCoord( Pars(10)/10, Pars(11)/10 );
cc 	= [0 Pars(12)/100 Pars(12)/100];         % between 0 and 1
mm 	= [0 Pars(13)/100 Pars(13)/100];     % between 0 and 1

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
nFrames_stim = ceil(myScreenInfo.FrameRate*dur_bar);
% nFrames_pre = SS.nFrames - nFrames_stim;
nFrames_pre = floor(myScreenInfo.FrameRate*dur_pre);
SS.Orientations = repmat(orientation,[1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

wid = myScreenInfo.Deg2Pix(cyN/sfreq);
SS.SourceRects = repmat([1; 1; wid; len],[1 1 SS.nFrames]);
SS.DestRects   = repmat(round([ x0-wid/2; y0-len/2; x0+1+wid/2; y0+1+len/2 ]),[1 1 SS.nFrames]);
SS.MinusOneToOne = 0;

CyclesPerPix = cyN/wid; % sf in cycles/pix

% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* CyclesPerPix * (1-wid/2:wid/2) + spatphase;

SS.nImages = 3; %?
ContrastImage = ones(len,wid);
indeces_darkcontrast = (sin( AngFreqs)<0);
ContrastImage(:,indeces_darkcontrast) = -1;
ImageTextures = cell(SS.nImages,1);
Factor = [1 -1 0];
for iImage = 1:SS.nImages
    ImageTextures{iImage} = zeros(len,wid,3);
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = ...
            uint8(255*mm(igun)*(1+cc(igun)*Factor(iImage)*ContrastImage));
    end
end

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

if (SS.nImages-1)*tfreq > myScreenInfo.FrameRate,
    ImageSequenceCache = 1+mod(1:nFrames_stim,SS.nImages-1);
else
    nFramesPerCycle = (SS.nImages-1)*round(myScreenInfo.FrameRate/((SS.nImages-1)*tfreq));
    nCycles = floor(nFrames_stim/nFramesPerCycle);
    for i=1:(SS.nImages-1),
        ind_seq = (1:nFramesPerCycle/(SS.nImages-1));
        singlecycle_sequence(ind_seq+(i-1)*nFramesPerCycle/(SS.nImages-1)) = i*ones(1,nFramesPerCycle/(SS.nImages-1));
    end
    if nCycles>0
        ImageSequenceCache = repmat(singlecycle_sequence,[1 nCycles]);
        ImageSequenceCache(nCycles*nFramesPerCycle+1:nFrames_stim)=ImageSequenceCache(1:nFrames_stim-(nCycles*nFramesPerCycle));
    else
        ImageSequenceCache = singlecycle_sequence(1:nFrames_stim);
    end
end

SS.ImageSequence(1:nFrames_pre) = SS.nImages;
SS.ImageSequence(nFrames_pre+1:nFrames_pre+nFrames_stim) = ImageSequenceCache;
SS.ImageSequence(nFrames_pre+nFrames_stim: SS.nFrames) = SS.nImages;
%last frame of the bar is intentionally removed to prevent sudden change of
%bar

%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
return

%% To test the code

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimColorBar_DS'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures



