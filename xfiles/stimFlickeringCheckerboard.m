function SS = stimFlickeringCheckerboard(myScreenInfo,Pars)
% stimSparseNoise makes stimuli of type stimSparseNoise.x
%
% SS = stimSparseNoise(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimSparseNoise(myScreenInfo) uses the default parameters
%
% 2011-02 MC
% 2012-01 MK - corrected the bug of underrepresented min/max values line #77
% 2014-05 SS - wrote stimSparseNoise on basis of stimRandNoiseFixed

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',    'Stimulus duration (s *10)',              50,1,12000};
pp{2}  = {'x1',     'Left border, from center (deg*10)',     -400,-1500,1500};
pp{3}  = {'x2',     'Right border, from center (deg*10)',     400,-1500,1500};
pp{4}  = {'y1',     'Bottom border, from center (deg*10)',   -200,-1000,1000};
pp{5}  = {'y2',     'Top border, from center (deg*10)',       200,-1000,1000};
pp{6}  = {'nfr',    'Number of frames per video refresh',     10,1,6000};
pp{7}  = {'sqsz',   'Size of squares (deg*10)',               30,1,2800};
pp{8}  = {'c',      'Contrast (%)',                           100,0,100};

x = XFile('stimFlickeringCheckerboard', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10; % seconds 
[Col1,Row1] = myScreenInfo.Deg2PixCoord( Pars(2)/10, Pars(4)/10 );
[Col2,Row2] = myScreenInfo.Deg2PixCoord( Pars(3)/10, Pars(5)/10 );
Col2 = max(Col2,Col1+1);
Row2 = max(Row2,Row1+1);

nFr = Pars(6);
SquareSize = myScreenInfo.Deg2Pix( Pars(7)/10 );
c   = Pars(8)/100;

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames)*c/2; % why do we need to divide by 2??

SS.BilinearFiltering = 0; % do not interpolate! 

nc = ceil((Col2-Col1)/SquareSize);
nr = ceil((Row2-Row1)/SquareSize);

SS.nImages = 2;

ImageTextures = cell(SS.nImages,1);
line = mod(1:nc,2);
im = zeros(nr,nc);
im(1:2:nr,:) = repmat(line,ceil(nr/2),1);
im(2:2:nr,:) = repmat(abs(line-1),floor(nr/2),1);
ImageTextures{1} = im;
ImageTextures{2} = abs(im-1);

% put images into video RAM
SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

seq = repmat([ones(1,nFr), ones(1,nFr)*2],1,ceil(SS.nFrames/(2*nFr)));
seq(SS.nFrames+1:end) = [];
SS.ImageSequence = seq;

SS.SourceRects = repmat([0; 0; nc; nr],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);

return

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimFlickeringCheckerboard(myScreenInfo); 
show(SS, myScreenInfo)
Screen('CloseAll');
% Play(SS, myScreenInfo) 

