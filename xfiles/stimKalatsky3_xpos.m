function SS = stimKalatsky3_xpos(myScreenInfo,Pars)
% stimKalatsky_xpos makes color bars moving in the x direction
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
pp{3}  = {'width',     'Bar width (deg)',     1,0,90};
pp{4}  = {'tph',    'Temporal phase (deg)',              0,0,360};
pp{5}  = {'dir',    'Direction of movement',                1,-1,1};
pp{6}  = {'cr',    'Stimulus luminance of red gun (%)',          100,0,100};
pp{7}  = {'cg',	'Stimulus luminance of green gun (%)',        100,0,100};
pp{8}  = {'cb',	'Stimulus luminance of blue gun (%)',         100,0,100};
pp{9}  = {'lr',	'Background luminance of red gun (%)',    50,0,100};
pp{10}  = {'lg',    'Background luminance of green gun (%)',  50,0,100};
pp{11}  = {'lb',    'Background luminance of blue gun (%)',   50,0,100};

x = XFile('stimKalatsky3_xpos',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur         = Pars(1)/10; % s, duration
tfreq	 	= Pars(2)/100;              % Hz
width  		= Pars(3);             % deg 1-4 = 0.01-0.02 cycles per degree
temporalphase  	= Pars(4);      % degree
direction 	= Pars(5);                 % deg
cc 	= Pars(6:8)/100;         % between 0 and 1
mm 	= Pars(9:11)/100;     % between 0 and 1


%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.Orientations = zeros([1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

wid = myScreenInfo.Deg2Pix(width);
Lx = floor(myScreenInfo.Xmax/2);
Ly = myScreenInfo.Ymax;
len = Ly;
SS.MinusOneToOne = 0;

% Translate requested speed of the grating (in cycles per second)
% into a shift value in "pixels per frame". 

shiftperframe = direction*Lx*tfreq/myScreenInfo.FrameRate;

x0 = direction*Lx*temporalphase/360;

for iframe = 1 : SS.nFrames
    xoffset = ceil(mod(x0+iframe*shiftperframe,Lx));
    SS.SourceRects(:,1,iframe) = [1; 1;  wid; len];
    SS.DestRects(:,1,iframe)  = [xoffset; 0; xoffset+wid; len];
end

SS.nImages = 1;
ContrastImage = ones(len,wid);
ImageTextures = cell(SS.nImages,1);
for iImage = 1:SS.nImages
    ImageTextures{iImage} = zeros(len,wid,3);
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = ...
            uint8(255*cc(igun)*ContrastImage);
    end
end

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;
SS.ImageSequence = ones(1,SS.nFrames);


%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
return

%% To test the code

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimKalatsky_xpos'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures