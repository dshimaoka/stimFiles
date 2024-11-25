function SS = stimPregenTexturesGaps4(myScreenInfo,Pars)
% stimPregenTextures makes stimuli of type stimPregenTextures.x
%
% SS = stimPregenTextures(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimPregenTextures(myScreenInfo) uses the default parameters
%
% 2011-02 MC
% 2012-01 MK - corrected the bug of underrepresented min/max values line #77
% 2014-05 SS - wrote stimSparseNoise on basis of stimRandNoiseFixed
% 2014-11 MP - wrote stimPregenTextures on basis of stimSparseNoise

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',    'Stimulus duration (s *10)',              100,1,18000};
pp{2}  = {'x1',     'Left border, from center (deg*10)',     -1400,-1400,1400};
pp{3}  = {'x2',     'Right border, from center (deg*10)',     1400,-1400,1400};
pp{4}  = {'y1',     'Bottom border, from center (deg*10)',   -1000,-1000,1000};
pp{5}  = {'y2',     'Top border, from center (deg*10)',       1000,-1000,1000};
pp{6}  = {'nFr1',   'number of slow repeats', 10,1,2000};
pp{7}  = {'nFr2',   'number of fast repeats', 1,1,2000};
pp{8}  = {'c',      'Contrast (%)',                           100,0,100};
pp{9} = {'seed',   'Seed of random number generator',        1,1,100};
pp{10}  = {'stimF',    'Stimulus frequency in frames',  10,0,100};
pp{11}  = {'stimD',    'Stimulus duration in frames',   3,0,100};
pp{12}  = {'stimOFF',    'OFF frames after stimulus',   2,0,100};
pp{13}  = {'slowFR',    'frequency of slow repeats',   4,0,1000};

x = XFile('stimPregenTexturesGaps4',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

[Col1,Row1] = myScreenInfo.Deg2PixCoord( Pars(2)/10, Pars(4)/10 );
[Col2,Row2] = myScreenInfo.Deg2PixCoord( Pars(3)/10, Pars(5)/10 );
Col2 = max(Col2,Col1+1);
Row2 = max(Row2,Row1+1);

c   = Pars(8)/100;
seed = Pars(9);

dur = Pars(1)/10;

nFr1 =Pars(6);
nFr2 = Pars(7);

%% Make the stimulus

rand('seed',seed); %#ok<RAND>

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
% SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.nFrames = ceil(60*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = zeros(1,SS.nFrames)*c/2; % why do we need to divide by 2??

% check if this is useful
SS.BilinearFiltering = 0; % do not interpolate!

% put LOAD here
load('\\zserver\Data\pregenerated_textures\Marius\image_grat.mat')
fprintf('Images loaded from zserver\n')

SS.nImages = size(dat.samp_img, 3);
ImageTextures = cell(SS.nImages, 1);
for i = 1:SS.nImages
    ImageTextures{i} = double(dat.samp_img(:,:,i))/128 - 1;
end

ImageTextures{SS.nImages+1} = ImageTextures{SS.nImages};
ImageTextures{SS.nImages+1}(:) = 0;
SS.nImages = SS.nImages + 1;

% save stimulus sequence here??

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
fprintf('textures loaded \n')

stimF = Pars(10); % stimulus frequency
stimD = Pars(11); %stimulus duration
stimOFF = Pars(12); %stimulus duration
ton = cumsum(stimD + stimOFF + geornd(1/(1+stimF), 1, ceil(2 * 60/stimF * dur)));
ton = ton(ton<(SS.nFrames-stimD));
SS.Amplitudes(ton) = 1;

SS.ImageSequence = zeros(1,length(ton));
slowFR = Pars(13);
for iFrame = 1:length(SS.ImageSequence)
    if slowFR>0
        if rem(iFrame,slowFR)==1
            iImage = rem(ceil(iFrame/nFr1)-1, SS.nImages-1) + 1;
        else
            iImage = rem(ceil(iFrame/nFr2)-1, SS.nImages-1) + 1;
        end
    else
        iImage = rem(ceil(iFrame/nFr2)-1, SS.nImages-1) + 1;
    end
    SS.ImageSequence(iFrame) = iImage; % SS.ImagePointers(iImage);
end

% permute images to be shown
imgsq = SS.ImageSequence(randperm(numel(SS.ImageSequence)));

istim = repmat(ton, stimD, 1) + repmat((0:1:(stimD-1))', 1, size(ton,2));
imgsq = repmat(imgsq, stimD, 1);
SS.ImageSequence = (SS.nImages) * ones(1, SS.nFrames);

SS.ImageSequence(istim) = imgsq; 

SS.ImageSequence = SS.ImageSequence(1:SS.nFrames);

nr = size(ImageTextures{1},1);
nc = size(ImageTextures{1},2);

SS.SourceRects = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);
return

%% To test the code
% Screen('Preference', 'SkipSyncTests', 1);

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimSparseNoise(myScreenInfo);
SS.Show(myScreenInfo)
Play(SS, myScreenInfo)

