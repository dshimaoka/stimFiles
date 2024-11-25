function SS = stimORsequence(myScreenInfo, Pars)
% Sequence of static gratings in disks
%
% SS = stimORsequence(myScreenInfo, Pars)
%
% SS = stimORsequence(myScreenInfo) uses the default parameters
%
% 2018-11 created from stimGratingWithMask 
%% TODO: disk size too small

%% Basics
if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',      'Stimulus duration (s *10)',        50,1,12000};
pp{2}  = {'tf',       'Temporal frequency (Hz *10)',      20,0,4000};
pp{3}  = {'sf',       'Spatial frequency (cpd *1000)',    80,0,1000};
pp{4}  = {'stimOnRatio',       'Stim On percentile (%)',    0,50,100};
pp{5}  = {'stimMode',       '0: equiprobable, 1: novel/adaptor',    0,0,1};
pp{6}  = {'novelOri',      'Novel orientation (deg)',                0,0,179};
pp{7}  = {'seed',       'seed integer for rand',          0,0,10000};
pp{8}  = {'dB',       'Diameter (deg*10)',          100,0,2700};
pp{9}  = {'xc',       'Center, x (deg*10)',               0,-1400,1400};
pp{10} = {'yc',       'Center, y (deg*10)',               0,-450,450};
pp{11} = {'cr',       'Contrast of red gun (%)',          100,0,100};
pp{12} = {'cg',	      'Contrast of green gun (%)',        100,0,100};
pp{13} = {'cb',	      'Contrast of blue gun (%)',         100,0,100};
pp{14} = {'lr',	      'Mean luminance of red gun (%)',    50,0,100};
pp{15} = {'lg',       'Mean luminance of green gun (%)',  50,0,100};
pp{16} = {'lb',       'Mean luminance of blue gun (%)',   50,0,100};

x = XFile('ORsequence', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end
%% parameters
dur         = Pars(1)/10;           % s
tfreq	 	= Pars(2) /10;          % Hz %MEANING HAS BEEN CHANGED
sfreq  		= Pars(3) /1000;         % cpd
diamOut     = myScreenInfo.Deg2Pix( Pars(8) /10 );       % deg ... this is size of MASK but not grating! Divide by sqrt(2) to obtain grating size 
[CtrCol(1), CtrRow(1)] = myScreenInfo.Deg2PixCoord(Pars(9)/10, Pars(10)/10);  % position of grating in pixels
cc 	= Pars(11:13) /100;          % between 0 and 1 %DELETE
mm 	= Pars(14:16)/100;           % between 0 and 1 %DELETE

stimOnRatio = Pars(4)/100;%0.3; %[0-1] NEW PARAMETER ratio when stimulus in on in one cycle
stimMode = Pars(5); %0: equiprobable, 1: novel/adaptor
novelOR = mod(Pars(6), 180); %[deg] 90; %NEW PARAMETER
seed = Pars(7); 

%% Make the stimulus
SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 2;

nxGrating = diamOut;
nxMask = sqrt(2) * diamOut;


nFramesInPeriod = round(myScreenInfo.FrameRate / tfreq);
nCycles = ceil(myScreenInfo.FrameRate*dur/nFramesInPeriod);
SS.nFrames =  nCycles * nFramesInPeriod;

PixPerCycle = myScreenInfo.Deg2Pix(1/sfreq);
frequency = 1/PixPerCycle; % sf in cycles/pix


% Define Frames and FrameSequence for each component grating
beta = 1;

% Make a row of x for grating
xx = 1-round(nxGrating/2):round(nxGrating/2);

% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* frequency * xx; %[1 (x patchsize in pixel)]

% Make moving grating   
ContrastImage = sin(AngFreqs);
ContrastImage = sign(ContrastImage).*abs(ContrastImage).^beta;

Frames = cell(2,1); %Frames{2}: inverse of Frames{1}
Frames{1} = zeros([size(ContrastImage), 3]); %[(x patchsize in pixel), (num of colors)]
for igun = 1:3
    Frames{1}(:,:,igun) = uint8(255 * mm(igun) * ...
        (1 + cc(igun)*ContrastImage));

    Frames{2} = 255 * mm(igun);
end
% Frames{2} = 255 - Frames{1}


% Make static mask
xx = 1-round(nxMask/2):round(nxMask/2);
MaskImage = zeros(length(xx), length(xx), 4);
for j = 1:3 %rgb color
    MaskImage(:,:,j) = round(255 * mm(j));
end
MaskImage(:,:,4) = 255; % makes mask opaque

dd = sqrt(bsxfun(@plus, xx.^2, (xx.^2)'));
mask = MaskImage(:,:,4);
mask(dd <= diamOut/2) = 0;
MaskImage(:,:,4) = mask;

%coordinate in pixel at the actual screen
destRects = zeros(4, 2);
destRects(:,1) = round([CtrCol-nxGrating/2 CtrRow-nxGrating/2 ...
    CtrCol+nxGrating/2 CtrRow+nxGrating/2]'); %coordinate of grating in pixel
destRects(:,2) = round([CtrCol-nxMask/2 CtrRow-nxMask/2 ...
    CtrCol+nxMask/2 CtrRow+nxMask/2]'); %coordinate of mask in pixel

%coordinate in pixel when making the stimulus
sourceRects = zeros(4, 2);
sourceRects(:,1) = [0 0 length(ContrastImage) 1];
sourceRects(:,2) = [0 0 size(MaskImage,2) size(MaskImage,1)];

SS.nImages = length(Frames) + 1; % +1 for mask
SS.DestRects = repmat(destRects, [1 1 SS.nFrames]);
SS.SourceRects = repmat(sourceRects, [1 1 SS.nFrames]);
SS.MinusOneToOne = false;
SS.UseAlpha = true;

%{1}: grating, {2}: background, {3}: mask. ImageTextures does NOT include temporal information
ImageTextures = [Frames; {MaskImage}]; 


%% frame sequence
TemporalPhase = 2*pi*(0:(nFramesInPeriod-1))/nFramesInPeriod;
%ActualFrequency = myScreenInfo.FrameRate/nFramesInPeriod;

%sequence per stimulation cycle
FrameSequence = mod(1:nFramesInPeriod,nFramesInPeriod);
FrameSequence(FrameSequence == 0) = nFramesInPeriod;
FrameSequence = TemporalPhase(FrameSequence);
% ind = FrameSequence < pi;
ind = FrameSequence < 2*pi*stimOnRatio;
FrameSequence(ind) = 1; %show ImageTextures{1}
FrameSequence(~ind) = 2; %show ImageTextures{2}
FrameSequence = repmat(FrameSequence, [1 nCycles]);


dOR = 15; %[deg]
nORs = 180/dOR; %number of variations of OR in equiprobable condition

rng(seed, 'twister');
ORsequence = mod(dOR*randi(nORs, [1 nCycles]), 180); %[deg] equiprobable
if stimMode == 1 %novel/adaptor condition
    adaptOR = mod(novelOR + 90, 180);
    if isempty(find(ORsequence == novelOR)) || isempty(find(ORsequence == adaptOR))
        error('novelOR/adaptOR NOT FOUND in OR sequence');
    else
        ORsequence(ORsequence ~= novelOR) = adaptOR;
        %shuffle sequence here? 
        %impose minimal dispersion between novel stims?
    end
end

ORsequence = repmat(ORsequence, [nFramesInPeriod, 1]);
ORsequence = ORsequence(:)';

SS.Orientations = [ORsequence; zeros(1, SS.nFrames)];
SS.Amplitudes = ones(2,SS.nFrames); % global alpha value
SS.BackgroundColor = round(255 * mm);
SS.BackgroundPersists = true;
SS.ImageSequence = [FrameSequence; ones(1,SS.nFrames) * SS.nImages]; %??
% SS.BilinearFiltering = -2; % do not interpolate! 


%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

return


%% to test the function

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimGratingWithMask(myScreenInfo);
show(SS, myScreenInfo);
Screen('CloseAll');
