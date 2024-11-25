function SS = stimSparseNoiseUncorr_DS(myScreenInfo,Pars)
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
pp{1}  = {'dur',    'Stimulus duration (s *10)',              50,1,6000};
pp{2}  = {'x1',     'Left border, from center (deg*10)',     -400,-1000,500};
pp{3}  = {'x2',     'Right border, from center (deg*10)',     400,-500,1000};
pp{4}  = {'y1',     'Bottom border, from center (deg*10)',   -200,-1000,500};
pp{5}  = {'y2',     'Top border, from center (deg*10)',       200,-500,1000};
pp{6}  = {'nfr',    'Number of frames per image',             10,1,70};
pp{7}  = {'sqsz',   'Size of squares (deg*10)',               30,1,900};
pp{8}  = {'ncs',    'Number of contrasts (choose 2 for b&w)', 2,2,16};
pp{9}  = {'c',      'Contrast (%)',                           100,0,100};
pp{10} = {'sprsns',  'Mean gray squares (%*10)',                 950,0,1000};
pp{11} = {'seed',   'Seed of random number generator',        1,1,100};

x = XFile('stimSparseNoiseUncorr', pp);
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
ncs = Pars(8);
c   = Pars(9)/100;
sprsns = Pars(10)/1000;
seed = Pars(11);

%% Make the stimulus

rand('seed',seed); %#ok<RAND>

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
ngs = round(nc * nr * sprsns);

SS.nImages = ceil(SS.nFrames/nFr);

ImageTextures = cell(SS.nImages,1);
for iImage = 1:SS.nImages
    im = floor(ncs * rand(nr, nc, 1)) / (ncs - 1) * 2 - 1;
    im(rand(nr, nc)<sprsns) = 0; % every square will become gray with prob=sprsns
    ImageTextures{iImage} = im;
end

% save stimulus sequence here??


SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

SS.ImageSequence = zeros(1,SS.nFrames);

for iFrame = 1:SS.nFrames
    iImage = ceil(iFrame/nFr);
    SS.ImageSequence(iFrame) = iImage; % SS.ImagePointers(iImage);
end

SS.SourceRects = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);

return

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimSparseNoiseUncorr(myScreenInfo); 
show(SS, myScreenInfo)
Screen('CloseAll');
% Play(SS, myScreenInfo) 

