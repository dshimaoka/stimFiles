function SS = stimKalatsky_brightness(myScreenInfo,Pars)
% stimKalatsky makes color flickering bars moving periodically in the x/y direction
%
% SS = stimKalatsky(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimKalatsky(myScreenInfo) uses the default parameters
%
% 2012-06 AP

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
pp{2}  = {'start',	'Stimulus start (deg)',        0,0,360};
pp{3}  = {'end',	'Stimulus end (deg)',        360,0,360};
pp{4}  = {'tf',     'Temporal frequency (Hz *100)',      1,1,400};
pp{5}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{6}  = {'tph',    'Temporal phase (deg)',              0,0,360};
pp{7}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{8}  = {'dir',    'Direction of movement',                1,-1,1};
pp{9} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{10}  = {'flickfreq',    'Temporal frequency of flicker (Hz *10)',   40,0,400};
pp{11}  = {'cr',    'Contrast of red gun (%)',          100,0,100};
pp{12}  = {'cg',	'Contrast of green gun (%)',        0,0,100};
pp{13}  = {'cb',	'Contrast of blue gun (%)',         0,0,100};
pp{14}  = {'lr',	'Mean luminance of red gun (%)',    50,0,100};
pp{15}  = {'lg',    'Mean luminance of green gun (%)',  0,0,100};
pp{16}  = {'lb',    'Mean luminance of blue gun (%)',   0,0,100};
pp{17}  = {'ori',   'Orientation (xpos = 1;ypos = 2)',   1,1,2};

x = XFile('stimKalatsky',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur         = Pars(1)/10; % s, durations
start_point = Pars(2); %deg, where the cycle start
end_point   = Pars(3); %deg ,where the cycle end
tfreq	 	= Pars(4)/100;              % Hz
sfreq  		= Pars(5)/100;             % cpd
temporalphase  	= Pars(6);      % degree
spatphase  	= Pars(7) * (pi/180);      % radians
direction 	= Pars(8);                 % deg
cyN     = Pars(9);
tfreq_flicker = Pars(10)/10; %Hz
cc 	= Pars(11:13)/100;         % between 0 and 1
mm 	= Pars(14:16)/100;     % between 0 and 1
if Pars(17)==1,
    xpos = 1; ypos = 0;
elseif Pars(17)==2
    xpos = 0; ypos = 1;
end

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.Orientations = zeros([1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

wid = myScreenInfo.Deg2Pix(cyN/sfreq);
Lx = myScreenInfo.Xmax;
Ly = myScreenInfo.Ymax;
if xpos
    len = Ly;
    L = Lx*(end_point-start_point)/360;
elseif ypos
    len = Lx;
    L = Ly*(end_point-start_point)/360;
end
SS.MinusOneToOne = 0;

CyclesPerPix = cyN/wid; % sf in cycles/pix

% Translate requested speed of the grating (in cycles per second)
% into a shift value in "pixels per frame".

shiftperframe = direction*L*tfreq/myScreenInfo.FrameRate;

p0 = direction*L*temporalphase/360;

for iframe = 1 : SS.nFrames
    if xpos
        offset = start_point/360*Lx + ceil(mod(p0+iframe*shiftperframe,L));
        SS.SourceRects(:,1,iframe) = [1; 1;  wid; len];
        SS.DestRects(:,1,iframe)  = [offset; 0; offset+wid; len];
    elseif ypos
        offset = start_point/360*Ly + ceil(mod(p0+iframe*shiftperframe,L));
        SS.SourceRects(:,1,iframe) = [1; 1;  len; wid];
        SS.DestRects(:,1,iframe)  = [0; offset; len; wid+offset];
    end
end

AngFreqs = -2*pi* CyclesPerPix * (1-wid/2:wid/2) + spatphase;

SS.nImages = 2;
indeces_darkcontrast = (sin(AngFreqs)<0);
if xpos
    ContrastImage = ones(len,wid);
    ContrastImage(:,indeces_darkcontrast) = -1;
elseif ypos
    ContrastImage = ones(wid,len);
    ContrastImage(indeces_darkcontrast,:) = -1;
end
ImageTextures = cell(SS.nImages,1);
Factor = [1 -1];
for iImage = 1:SS.nImages
    if xpos
        ImageTextures{iImage} = zeros(len,wid,3);
    elseif ypos
        ImageTextures{iImage} = zeros(wid,len,3);
    end
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = ...
            uint8(255*mm(igun)*(cc(igun)*Factor(iImage)*ContrastImage));
    end
end

SS.BackgroundColor = round(0*mm);
SS.BackgroundPersists = true;

if (SS.nImages)*tfreq_flicker>myScreenInfo.FrameRate,
    SS.ImageSequence = 1+mod(1:SS.nFrames,SS.nImages);
else
    if tfreq_flicker>0, %AP March '15 ask Mika
        nFramesPerCycle = (SS.nImages)*round(myScreenInfo.FrameRate/((SS.nImages)*tfreq_flicker));
        nCycles = floor(SS.nFrames/nFramesPerCycle);
    else %AP March '15 ask Mika
         nFramesPerCycle = SS.nImages;
         nCycles = 0;
    end
    for i=1:(SS.nImages),
        ind_seq = (1:nFramesPerCycle/(SS.nImages));
        singlecycle_sequence(ind_seq+(i-1)*nFramesPerCycle/(SS.nImages)) = i*ones(1,nFramesPerCycle/(SS.nImages));
    end
    if nCycles>0
        SS.ImageSequence = repmat(singlecycle_sequence,[1 nCycles]);
        SS.ImageSequence(nCycles*nFramesPerCycle+1:SS.nFrames)=SS.ImageSequence(1:SS.nFrames-(nCycles*nFramesPerCycle));
    else
%         SS.ImageSequence = singlecycle_sequence(1:SS.nFrames);
        SS.ImageSequence = ones(1,SS.nFrames);
    end
end


%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
return

%% To test the code

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimKalatsky_xpos'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures