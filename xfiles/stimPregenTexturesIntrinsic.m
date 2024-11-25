function SS = stimPregenTexturesIntrinsic(myScreenInfo,Pars)
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
pp{1}  = {'dur',    'Stimulus duration (s *10)',              200,1,18000};
pp{2}  = {'x1',     'Left border, from center (deg*10)',     -1400,-1400,1400};
pp{3}  = {'x2',     'Right border, from center (deg*10)',     1400,-1400,1400};
pp{4}  = {'y1',     'Bottom border, from center (deg*10)',   -1000,-1000,1000};
pp{5}  = {'y2',     'Top border, from center (deg*10)',       1000,-1000,1000};
pp{6}  = {'nfON',    'number of frames stimulus stays on (deg*10)', 60,1,200};
pp{7}  = {'nfOFF',   'number of frames stimulus stays off (deg*10)', 60,1,200};
pp{8}  = {'c',      'Contrast (%)',                           100,0,100};
pp{9} = {'seed',   'Seed of random number generator',        1,1,100};

x = XFile('stimPregenTexturesIntrinsic',pp);
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


nfON = Pars(6);
nfOFF = Pars(7);

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
load('\\zserver\Data\pregenerated_textures\Marius\image_dat21_uint8.mat')
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

%
SS.ImageSequence = zeros(1,ceil(SS.nFrames/(nfOFF + nfON)));
nClasses = 2*21;

for iFrame = 1:ceil(SS.nFrames/(nfOFF + nfON))    
    iImage = rem(ceil(iFrame/nFr1)-1, nClasses-1) + 1;
    SS.ImageSequence(iFrame) = iImage; % SS.ImagePointers(iImage);
end
% permute images to be shown
SS.ImageSequence = SS.ImageSequence(randperm(numel(SS.ImageSequence)));
imgsq = repmat(SS.ImageSequence, nfON/5,1);

for i = 1:nClasses
    iFind = find((rem(imgsq-1, nClasses)+1)==i);
    iClass = find((rem([1:(SS.nImages-1)] - 1, nClasses)+1)==i);
   imgsq(iFind)  = iClass(ceil(rand(1,length(iFind)) * length(iClass)));
end

imgsq = reshape(repmat(imgsq(:)', 5,1), nfON, []);


% %     blockGray = SS.nImages * ones(2*nfOFF, size(imgsq,2));
%     blockGray = repmat(SS.ImageSequence, 10*nfOFF,1);
%     blockGray(randperm(numel(blockGray), 9*numel(blockGray)/10)) = NaN;

blockGray2 = SS.nImages * ones(10*nfOFF, size(imgsq,2));
erand = ceil(exprnd(nfOFF, 1, size(imgsq,2)));
for i = 1:size(imgsq,2)
  blockGray2(erand(i):end,i) = NaN;  
end

imgsq = cat(1, imgsq, blockGray2); % last image is grey
imgsq = imgsq(~isnan(imgsq));
SS.ImageSequence = imgsq(:);
SS.ImageSequence((end+1):SS.nFrames) = SS.nImages;

SS.ImageSequence = SS.ImageSequence(1:SS.nFrames)';

[nr, nc] = size(ImageTextures{1});
asp_ratio_dest = abs(Col2-Col1)/abs(Row2-Row1);
asp_ratio_source = abs(nc)/abs(nr);
if asp_ratio_source>asp_ratio_dest
    nc = floor(nc * asp_ratio_dest/asp_ratio_source);
else
    nr = floor(nr * asp_ratio_source/asp_ratio_dest);
end


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

