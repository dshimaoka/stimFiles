function SS = stimLoomingStop(myScreenInfo, Pars)
% One grating, drifting or flickering, in disks or annuli or rectangles
%
% SS = stimGratingWithMask(myScreenInfo, Pars)
%
% SS = stimGratingWithMask(myScreenInfo) uses the default parameters
%
% 2015-09 MP based on stimGratingWithMask.m. Added onset and offset times.

%% Basics
if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',      'Stimulus duration (s *10)',        90,1,600};
pp{2}  = {'diam',     'Diameter (deg*10)',                200,0,2700};
pp{3}  = {'xc',       'Center, x (deg*10)',               -100,-1400,1400};
pp{4}  = {'yc',       'Center, y (deg*10)',               0,-450,450};
pp{5} = {'tstart',   'Drifting start (s*10)',            30,1,600};
pp{6} = {'tstop',    'Drifting stop (s*10)',             60,1,600};

x = XFile('stimLoomingStop', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur         = Pars(1)/10;           % s
diamOut     = myScreenInfo.Deg2Pix( Pars(2) /10 );       % deg
[CtrCol(1), CtrRow(1)] = myScreenInfo.Deg2PixCoord(Pars(3)/10, Pars(4)/10);  % deg

tonset        = Pars(5)/10;             % in seconds
toffset       = Pars(6)/10;             % in seconds

mm 	= [.5 .5 .5];

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = round( myScreenInfo.FrameRate*dur );

nFrames1 = round( myScreenInfo.FrameRate*tonset );
nFrames2 = round( myScreenInfo.FrameRate*toffset );

SS.Orientations = zeros([1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames); % global alpha value

% determine size of grating and mask (not size of presented part of
% gratings through mask)
nxGrating = diamOut;

%% Define Frames and FrameSequence for each component grating
SS.nFrames = 2* ceil(SS.nFrames/2);

ndiam = linspace(0, 256, SS.nFrames/2);
ndiam = [ndiam ndiam(end:-1:1)];


SS.nImages      = SS.nFrames;
xs = repmat(1:256, 256, 1);
xs = xs - mean(xs(:));
ys = xs';
ds = (xs.^2 + ys.^2).^.5;

% create textures
ImageTextures   = cell(SS.nImages,1);
for iImage = 1:SS.nImages       
    mask = single(ds<ndiam(iImage)/2);
    img = - mask * 128+ 128;
    % ndiam???/
    ImageTextures{iImage} = uint8(img);
end


destRects = zeros(4, 1);
destRects(:,1) = round([CtrCol-nxGrating/2 CtrRow-nxGrating/2 ...
    CtrCol+nxGrating/2 CtrRow+nxGrating/2]');
SS.DestRects = repmat(destRects, [1 1 SS.nFrames]);
SS.SourceRects  = repmat([1; 1; 256; 256],[1 1 SS.nFrames]);

SS.MinusOneToOne = false;
SS.UseAlpha = true;

SS.BackgroundColor                  = round(255 * mm);
SS.BackgroundPersists               = true;

FrameSequence = 1:SS.nFrames;
FrameSequence(1:min(nFrames1, SS.nFrames))           = FrameSequence(min(SS.nFrames, max(1,nFrames1)));
FrameSequence((1+nFrames2):SS.nFrames) = FrameSequence(min(SS.nFrames, nFrames2));
SS.ImageSequence                    = FrameSequence; 

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
% Play(SS, myScreenInfo)