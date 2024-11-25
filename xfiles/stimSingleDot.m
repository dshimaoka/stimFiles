function SS = stimSingleDot(myScreenInfo,Pars)
% stimSingleDot makes stimuli of type stimSingleDot.x
% Shows a single square on the screen. Square size, intenisity and
% background intensity arer definable.
% 
% Initially motivated for mapping reflections from the eye onto eye-camera.
%
% SS = stimSingleDot(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimSingleDot(myScreenInfo) uses the default parameters
%
% 2014-05 MK

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',   'Stimulus duration (s *10)',         50,1,600};
pp{2}  = {'xpos',  'x position (deg*10)',               0,-1500,1500};
pp{3}  = {'ypos',  'y position (deg*10)',               0,-1000,1000};
pp{4}  = {'sqsz',  'Size of the square (deg*10)',       50,1,1000};
pp{5}  = {'bklum', 'Background intensity (%)',          0,0,100};
pp{6}  = {'sqlum', 'Square intensity (%)',              100,0,100};

x = XFile('stimSingleDot',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10; % seconds 

SquareSize = myScreenInfo.Deg2Pix( Pars(4)/10 );

[xCoord, yCoord] = myScreenInfo.Deg2PixCoord( Pars(2)/10, Pars(3)/10 );
Col1 = round(xCoord - SquareSize/2);
Row1 = round(yCoord - SquareSize/2);
Col2 = round(xCoord + SquareSize/2);
Row2 = round(yCoord + SquareSize/2);

c   = Pars(6)/100;
bkgLevel  = round(Pars(5)/100*255);

%% Make the stimulus

% rand('seed',seed); %#ok<RAND>

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames)*c; % why do we need to divide by 2??
SS.BackgroundColor = bkgLevel*[1 1 1];   % Background color, between 0 and 255 (3 x 1)
SS.BackgroundPersists = true;

SS.BilinearFiltering = 0; % do not interpolate! 

SS.nImages = 1;

ImageTextures = cell(SS.nImages,1);
for iImage = 1:SS.nImages
    ImageTextures{iImage} = c*ones(2);
end

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

SS.ImageSequence = zeros(1,SS.nFrames);

for iFrame = 1:SS.nFrames
    iImage = 1;
    SS.ImageSequence(iFrame) = iImage; % SS.ImagePointers(iImage);
end

SS.SourceRects = repmat([1; 1; 2; 2],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);

return

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimSingleDot(myScreenInfo); 
SS.ImageTextures{1} = 1;
SS.Show(myScreenInfo)
Play(SS, myScreenInfo);

