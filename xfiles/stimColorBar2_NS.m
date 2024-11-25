function SS = stimColorBar2_NS(myScreenInfo,Pars)
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
pp{1}  = {'dur',	'Stimulus duration (s *10)',        50,1,600};
pp{2}  = {'swT',	'Switch Time  (s *10)',        15,1,600};
pp{3}  = {'tf',     'Temporal frequency (Hz *10)',      40,1,400};
pp{4}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{5}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{6}  = {'ori',    'Orientation (deg)',                0,0,360};
pp{7} = {'len',     'Bar length (deg*10)',                  300, 1, 3600};
pp{8} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{9} = {'xfocus',  'Focus position, x (deg*10)',           -300,-1500, 1500};
pp{10} = {'yfocus',  'Focus position, y (deg*10)',           0, -600, 600};
pp{11}  = {'cr',    'Contrast of red gun (%)',          100,0,100};
pp{12}  = {'cg',	'Contrast of green gun (%)',        100,0,100};
pp{13}  = {'cb',	'Contrast of blue gun (%)',         100,0,100};
pp{14}  = {'lr',	'Mean luminance of red gun (%)',    50,0,100};
pp{15}  = {'lg',    'Mean luminance of green gun (%)',  50,0,100};
pp{16}  = {'lb',    'Mean luminance of blue gun (%)',   50,0,100};

x = XFile('stimColorBar2_NS',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur         = Pars(1)/10; % s, duration
dur_bar     = Pars(2)/10;  % s, duration of the flickering bar
tfreq	 	= Pars(3)/10;              % Hz
sfreq  		= Pars(4)/100;             % cpd
spatphase  	= Pars(5) * (pi/180);      % radians
orientation 	= Pars(6);                 % deg
len     = myScreenInfo.Deg2Pix( Pars(7)/10 );   % pixels
cyN     = Pars(8);
[x0,y0] = myScreenInfo.Deg2PixCoord( Pars(9)/10, Pars(10)/10 );
cc 	= Pars(11:13)/100;         % between 0 and 1
mm 	= Pars(14:16)/100;     % between 0 and 1

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
nFrames_stim = ceil(myScreenInfo.FrameRate*dur_bar);
SS.Orientations = repmat(orientation,[1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

wid = myScreenInfo.Deg2Pix(cyN/sfreq);
SS.SourceRects = repmat([1; 1; wid; len],[1 1 SS.nFrames]);
SS.DestRects   = repmat(round([ x0-wid/2; y0-len/2; x0+1+wid/2; y0+1+len/2 ]),[1 1 SS.nFrames]);
SS.MinusOneToOne = 0;

CyclesPerPix = cyN/wid; % sf in cycles/pix

% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* CyclesPerPix * (1-wid/2:wid/2) + spatphase;

SS.nImages = 3;
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

if (SS.nImages-1)*tfreq>myScreenInfo.FrameRate,
    SS.ImageSequence = 1+mod(1:nFrames_stim,SS.nImages-1);
else
    nFramesPerCycle = (SS.nImages-1)*round(myScreenInfo.FrameRate/((SS.nImages-1)*tfreq));
    nCycles = floor(nFrames_stim/nFramesPerCycle);
    for i=1:(SS.nImages-1),
        ind_seq = (1:nFramesPerCycle/(SS.nImages-1));
        singlecycle_sequence(ind_seq+(i-1)*nFramesPerCycle/(SS.nImages-1)) = i*ones(1,nFramesPerCycle/(SS.nImages-1));
    end
    if nCycles>0
        SS.ImageSequence = repmat(singlecycle_sequence,[1 nCycles]);
        SS.ImageSequence(nCycles*nFramesPerCycle+1:nFrames_stim)=SS.ImageSequence(1:nFrames_stim-(nCycles*nFramesPerCycle));
    else
        SS.ImageSequence = singlecycle_sequence(1:nFrames_stim);
    end
end

SS.ImageSequence(nFrames_stim+1:SS.nFrames)= SS.nImages;

%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
return

%% To test the code

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimColorBar2'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures



