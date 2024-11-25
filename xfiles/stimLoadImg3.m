function SS = stimLoadImg3(myScreenInfo,Pars)

% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',    'Stimulus duration (s *10)',              2,1,18000};
pp{2}  = {'x1',     'Left border, from center (deg*10)',     -1400,-1400,1400};
pp{3}  = {'x2',     'Right border, from center (deg*10)',     1400,-1400,1400};
pp{4}  = {'y1',     'Bottom border, from center (deg*10)',   -1000,-1000,1000};
pp{5}  = {'y2',     'Top border, from center (deg*10)',       1000,-1000,1000};
pp{6}  = {'c',      'Contrast (%)',                           100,0,100};
pp{7}  = {'seed',   'Seed of random number generator',        1,1,1000};
pp{8}  = {'repn',   'which image in the sequence (0 is random)',1,0,10000};
pp{9}  = {'ip',     'which image database',                   1,1,1000};
pp{10}  = {'nimg',  'total number of images',                 1400,1,10000};
pp{11}  = {'pbl',   'percentage blanks',                      5,1,100};

x = XFile('stimLoadImg3',pp);
% x.Write; % call this ONCE: it writes the .x file

% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

[Col1,Row1] = myScreenInfo.Deg2PixCoord( Pars(2)/10, Pars(4)/10 );
[Col2,Row2] = myScreenInfo.Deg2PixCoord( Pars(3)/10, Pars(5)/10 );
Col2 = max(Col2,Col1+1);
Row2 = max(Row2,Row1+1);

dur     = Pars(1)/10;
c       = Pars(6)/100;
seed    = Pars(7);
repn    = Pars(8);
ip      = Pars(9);
nimg    = Pars(10);
pblanks = Pars(11)/100;
%% Make the stimulus
root = sprintf('C:\\StimulusDATA\\selection%d\\', ip);

rng('default');
rng(seed); 

%iperm       = randperm(nimg + ceil(pblanks *nimg));
if repn>0
    isample     = rem(repn-1, nimg + ceil(pblanks *nimg)) + 1;
else
    isample     = ceil(rand * (nimg + ceil(pblanks *nimg)));
end

if isample>nimg
    dat.img = zeros(10);
else
    dat         = load(fullfile(root, sprintf('img%d.mat', isample)));
end
ImageTextures{1} = double(dat.img);
% put LOAD here
fprintf('Images loaded from zserver\n')

SS = ScreenStim; % initialization
%SS.BackgroundColor      = double(round(255 * 0.5));
%SS.BackgroundPersists   = true;

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
% SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.nFrames = round(myScreenInfo.FrameRate*dur );


SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames)*c/2; % why do we need to divide by 2??

% check if this is useful
SS.BilinearFiltering = 0; % do not interpolate!
SS.MinusOneToOne = true;

SS.nImages = 1;
SS.ImageSequence = ones(1, SS.nFrames); % SS.ImagePointers(iImage);

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

nr = size(ImageTextures{1},1);
nc = size(ImageTextures{1},2);

SS.SourceRects = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);


% fprintf('textures loaded \n')


return

%% To test the code
% Screen('Preference', 'SkipSyncTests', 1);

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimSparseNoise(myScreenInfo);
SS.Show(myScreenInfo)
Play(SS, myScreenInfo)

