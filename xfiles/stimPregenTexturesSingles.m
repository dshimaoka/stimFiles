function SS = stimPregenTexturesSingles(myScreenInfo,Pars)
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
pp{6}  = {'nfON',    'number of frames stimulus stays on ', 10,1,200};
pp{7}  = {'nfOFF',   'number of frames stimulus stays off ', 10,1,200};
pp{8}  = {'c',      'Contrast (%)',                           100,0,100};
pp{9} = {'indT',   'Index of texture',        1,1,600};

x = XFile('stimPregenTexturesSingles',pp);
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
indxtx = Pars(9);

dur = Pars(1)/10;

%% Make the stimulus

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
load(sprintf('//zserver/Data/pregenerated_textures/Marius/single_files/texture%d.mat', indxtx))
% fprintf('Images loaded from zserver\n')

ImageTextures{1}    = double(I)/128 - 1;
SS.ImageTextures{1} = ImageTextures;
SS.nImages          = 1;
SS                  = SS.LoadImageTextures( myScreenInfo, ImageTextures );
SS.ImageSequence    = ones(1,SS.nFrames);

[nr] = size(ImageTextures{1},1);
nr = nr * (Row2-Row1)/900;
nc = nr;

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

