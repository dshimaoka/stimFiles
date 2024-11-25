function SS = stimPregenTextures(myScreenInfo,Pars)
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
pp{6}  = {'nfr',    'Number of frames per image',             10,1,200};
pp{7}  = {'sqsz',   'Size of squares (deg*10)',               30,1,1000};
pp{8}  = {'c',      'Contrast (%)',                           100,0,100};
pp{9} = {'seed',   'Seed of random number generator',        1,1,100};

x = XFile('stimPregenTextures',pp);
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

nFr1 = 1;
nFr2 = 1;

nfr = Pars(6);
nfON = 10;
nfOFF = 20;

%% Make the stimulus

rand('seed',seed); %#ok<RAND>

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
% SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.nFrames = ceil(60*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames)*c/2; % why do we need to divide by 2??

% check if this is useful
SS.BilinearFiltering = 0; % do not interpolate!

% put LOAD here
load('\\zserver\Data\pregenerated_textures\Marius\image_dat.mat')
fprintf('Images loaded from zserver\n')

% SS.nImages = 600;
% ImageTextures = cell(SS.nImages,1);
% for iImage = 1:SS.nImages
%     im = floor(2 * rand(100, 100, 1)) / (2 - 1) * 2 - 1;
%     ImageTextures{iImage} = im;
% end

% SS.nImages = size(dat.samp_img,3);
% ImageTextures = cell(SS.nImages,1);
% for iImage = 1:SS.nImages
%     ImageTextures{iImage} = dat.samp_img(:,:,iImage);
% end

SS.nImages = length(dat.ImageTextures);
ImageTextures = cellfun(@(x) double(x)/128 - 1, dat.ImageTextures, 'UniformOutput', 0);

ImageTextures{SS.nImages+1} = ImageTextures{SS.nImages};
ImageTextures{SS.nImages+1}(:) = 0;
SS.nImages = SS.nImages + 1;

% save stimulus sequence here??

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
fprintf('textures loaded \n')

% nFr = 10; 
% SS.ImageSequence = zeros(1,SS.nFrames);
% 
% for iFrame = 1:SS.nFrames
%     iImage = ceil(iFrame/nFr);
%     SS.ImageSequence(iFrame) = iImage; % SS.ImagePointers(iImage);
% end


%
if 1
    SS.ImageSequence = zeros(1,ceil(SS.nFrames/(nfOFF + nfON)));
    
    for iFrame = 1:ceil(SS.nFrames/(nfOFF + nfON))
        if rem(iFrame,2)==1
            iImage = rem(ceil(iFrame/nFr1)-1, SS.nImages-1) + 1;
        else
            iImage = rem(ceil(iFrame/nFr2)-1, SS.nImages-1) + 1;
        end
        SS.ImageSequence(iFrame) = iImage; % SS.ImagePointers(iImage);
    end
    
    % permute images to be shown
    SS.ImageSequence = SS.ImageSequence(randperm(numel(SS.ImageSequence)));
        
    imgsq = repmat(SS.ImageSequence, nfON,1);
    
%     blockGray = SS.nImages * ones(2*nfOFF, size(imgsq,2));
    blockGray = repmat(SS.ImageSequence, 10*nfOFF,1);
    blockGray(randperm(numel(blockGray), 9*numel(blockGray)/10)) = NaN;
    
    imgsq = cat(1, imgsq, blockGray); % last image is grey
    
%	onsets = 1 + [0 cumsum(sum(~isnan(imgsq), 1))]; onsets(end) = [];
%	SS.onsets = onsets;

	imgsq = imgsq(~isnan(imgsq));
%     imgsq = repmat(SS.ImageSequence, nfON,1);
%     imgsq(end+(1:nfOFF),:) = SS.nImages; % last image is grey
    
   disp(imgsq')
    
     SS.ImageSequence = imgsq(:);
     
%     iblanks = find(SS.ImageSequence==SS.nimages);
%     iib = randperm(numel(iblanks));
%     SS.ImageSequences(iblanks(iib(1:end/2)))= [];
    
    SS.ImageSequence = SS.ImageSequence(1:SS.nFrames)';
    
    [nr, nc] = size(ImageTextures{1});
    asp_ratio_dest = abs(Col2-Col1)/abs(Row2-Row1);
    asp_ratio_source = abs(nc)/abs(nr);
    if asp_ratio_source>asp_ratio_dest
       nc = floor(nc * asp_ratio_dest/asp_ratio_source);
    else
       nr = floor(nr * asp_ratio_source/asp_ratio_dest);
    end    
end

% [nr, nc] = size(ImageTextures{1});

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

