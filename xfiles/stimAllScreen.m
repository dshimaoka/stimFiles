function SS = stimAllScreen(myScreenInfo,Pars)
% stimAllScreen makes the whole screen go white or black
%
% SS = stimAllScreen(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimAllScreen(myScreenInfo) uses the default parameters
%
% 2014-05 MO

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',  'Stimulus duration (s *10)',         10,1,600};
pp{2}  = {'lum',  'Luminance ',                   0,0,255};


x = XFile('stimAllScreen',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur = Pars(1)/10; % seconds
lum = Pars(2);

[Col1,Row1] = Deg2PixCoord(-120, -60);
[Col2,Row2] = Deg2PixCoord(120, 60);
Col2 = max(Col2,Col1+1);
Row2 = max(Row2,Row1+1);

%% Make the stimulus



SS = ScreenStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.Orientations = zeros([1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

nx = 256; % the source rectangles are of fixed 128x256 size...
ny = 128;
myRectangle = round([Col1 Row1 Col2 Row2]');
SS.DestRects   = repmat(myRectangle,[1 1 SS.nFrames]);
SS.SourceRects = repmat([1; 1; nx; ny],[1 1 SS.nFrames]);
SS.MinusOneToOne = 0;

SS.nImages =  1;


ImageTextures = cell(SS.nImages,1);
ImageTextures{1} = uint8(lum);

prefFrames = ceil(myScreenInfo.FrameRate*dur);
SS.ImageSequence(1:prefFrames) = SS.nImages;
SS.ImageSequence(1+prefFrames:SS.nFrames) = 1+mod(1:SS.nFrames-prefFrames,SS.nImages-1);

% put the images in video RAM
SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
return;

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimAllScreen(myScreenInfo);
SS.Show(myScreenInfo)
Play(SS, myScreenInfo)

% ScreenInfo.Deg2PixCoord does not return negative values (although it
% should), so we convert degrees to pixels on our own...
    function [xPix, yPix] = Deg2PixCoord(xDeg,yDeg)
        xPixCtr = myScreenInfo.Xmax/2;
        yPixCtr = myScreenInfo.Ymax/2;
        
        xPix = 2 * myScreenInfo.Dist/ myScreenInfo.PixelSize * tan( pi/180 * xDeg/2 );
        yPix = 2 * myScreenInfo.Dist/ myScreenInfo.PixelSize * tan( pi/180 * yDeg/2 );
        
        xPix = round(xPixCtr + xPix);
        yPix = round(yPixCtr + yPix);
    end
end
