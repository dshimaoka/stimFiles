function SS = stimKalatsky_DS(myScreenInfo,Pars)
% stimKalatsky makes color flickering bars moving periodically in the x/y direction
% unlike stimKalatsky,
% - stimulus appears gradually from the edge of the screen 
% - blank can be inserted after each sweep (bdur)
%
% 13/10/20 DS made from stimKalatsky

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',        50,1,6000};
pp{2}  = {'bdur',	'blank duration after each sweep (ms)',        50,1,20000}; %13/10/20
pp{3}  = {'tf',     'Temporal frequency (Hz *100)',      1,1,400};
pp{4}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{5}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{6}  = {'dir',    'Direction of movement',                1,-1,1};
pp{7} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{8}  = {'flickfreq',    'Temporal frequency of flicker (Hz *10)',   40,0,400};
pp{9}  = {'cr',    'Contrast of red gun (%)',          100,0,100};
pp{10}  = {'cg',	'Contrast of green gun (%)',        0,0,100};
pp{11}  = {'cb',	'Contrast of blue gun (%)',         0,0,100};
pp{12}  = {'lr',	'Mean luminance of red gun (%)',    50,0,100};
pp{13}  = {'lg',    'Mean luminance of green gun (%)',  0,0,100};
pp{14}  = {'lb',    'Mean luminance of blue gun (%)',   0,0,100};
pp{15}  = {'ori',   'Orientation (xpos = 1;ypos = 2)',   1,1,2};

x = XFile('stimKalatsky_DS',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur         = Pars(1)/10; % s, durations
bdur         = Pars(2)/1000; % s, durations
tfreq	 	= Pars(3)/100;              % Hz
sfreq  		= Pars(4)/100;             % cpd
spatphase  	= Pars(5) * (pi/180);      % radians
direction 	= Pars(6);                 % deg
cyN     = Pars(7);
tfreq_flicker = Pars(8)/10; %Hz
cc 	= Pars(9:11)/100;         % between 0 and 1
mm 	= Pars(12:14)/100;     % between 0 and 1
if Pars(15)==1,
    xpos = 1; ypos = 0;
elseif Pars(15)==2
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
    L = Lx+wid;
elseif ypos
    len = Lx;
    L = Ly+wid;
end
SS.MinusOneToOne = 0;

CyclesPerPix = cyN/wid; % sf in cycles/pix

% Translate requested speed of the grating (in cycles per second)
% into a shift value in "pixels per frame".

T = 1/tfreq;
nFramesPerSweep = round(myScreenInfo.FrameRate * T);
nStimFramesPerSweep = round(myScreenInfo.FrameRate * (T-bdur));

%shiftperframe = direction*L*tfreq/myScreenInfo.FrameRate;
shiftperframe = direction*L/(nStimFramesPerSweep-1); %[deg]

% p0 = direction*L*temporalphase/360;

%first sweep
for iframe = 1 : nStimFramesPerSweep
    if xpos
        if direction == 1
            offset = (iframe-1)*shiftperframe - wid;
        elseif direction == -1
            offset = Lx + (iframe-1)*shiftperframe;
        end
        SS.SourceRects(:,1,iframe) = [1; 1;  wid; len];
        SS.DestRects(:,1,iframe)  = [offset; 0; offset+wid; len];
    elseif ypos
        if direction == 1
            offset = (iframe-1)*shiftperframe - wid;
        elseif direction == -1
            offset = Ly + (iframe-1)*shiftperframe;
        end
        SS.SourceRects(:,1,iframe) = [1; 1;  len; wid];
        SS.DestRects(:,1,iframe)  = [0; offset; len; wid+offset];
    end
end

%first blank
for iframe = nStimFramesPerSweep:nFramesPerSweep
    SS.SourceRects(:,1,iframe) = [ 1; 1; 1; 1];
    SS.DestRects(:,1,iframe) = [0;0;0;0];
end

%copy the first sweep+blank
for iframe = nFramesPerSweep+1:SS.nFrames
    %offset(iframe) = offset(mod(iframe-1, nFramesPerSweep)+1);
    thisFrame = mod(iframe-1, nFramesPerSweep)+1;
    SS.SourceRects(:,1,iframe) = SS.SourceRects(:,1,thisFrame);%[1; 1; Lx; Ly];%[1; 1;  wid; len];
    SS.DestRects(:,1,iframe)  = SS.DestRects(:,1,thisFrame);%[0; 0; Lx; Ly];%[offset; 0; offset+wid; len];
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
            uint8(255*mm(igun)*(1+cc(igun)*Factor(iImage)*ContrastImage));
    end
end

SS.BackgroundColor = round(255*mm);
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