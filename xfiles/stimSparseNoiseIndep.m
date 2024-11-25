function SS = stimSparseNoiseIndep(myScreenInfo,Pars)
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

pp      = cell(1,1);
pp{1}   = {'dur',    'Stimulus duration (s *10)',              5,1,6000};
pp{2}   = {'x1',     'Left border, from center (deg*10)',     -1350,-1350,500};
pp{3}   = {'x2',     'Right border, from center (deg*10)',     1350,-500,1350};
pp{4}   = {'y1',     'Bottom border, from center (deg*10)',   -450,-1000,500};
pp{5}   = {'y2',     'Top border, from center (deg*10)',       450,-500,1000};
pp{6}   = {'nfr',    'Number of frames per image',             10,1,70};
pp{7}   = {'sqsz',   'Size of squares (deg*10)',               30,1,100};
pp{8}   = {'ncs',    'Number of contrasts (choose 2 for b&w)', 2,1,16};
pp{9}   = {'c',      'Contrast (%)',                           100,0,100};
pp{10}  = {'sprsns', 'Mean gray squares (%*10)',               950,0,1000};
pp{11}  = {'bckgrnd','Background luminance',                   50,0,100};
pp{12}  = {'seed',   'Seed of random number generator',        1,1,100};

x       = XFile('stimSparseNoiseIndep', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars        = x.ParDefaults;
end

dur             = Pars(1)/10; % seconds 
[Col1,Row1]     = myScreenInfo.Deg2PixCoord( Pars(2)/10, Pars(4)/10 );
[Col2,Row2]     = myScreenInfo.Deg2PixCoord( Pars(3)/10, Pars(5)/10 );
Col2            = max(Col2,Col1+1);
Row2            = max(Row2,Row1+1);

nFr             = Pars(6);
SquareSize      = myScreenInfo.Deg2Pix( Pars(7)/10 );
ncs             = Pars(8);
c               = Pars(9)/100;
sprsns          = Pars(10)/1000;
bckgrnd         = Pars(11)/100;
seed            = Pars(12);

%% Make the stimulus

rand('seed',seed); %#ok<RAND>

SS              = ScreenStim; % initialization
SS.Type         = x.Name;
SS.Parameters   = Pars;
SS.nTextures    = 1;
SS.nFrames      = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes   = ones(1,SS.nFrames)*c/2; % why do we need to divide by 2??
SS.BilinearFiltering = 0; % do not interpolate! 

nc              = ceil((Col2-Col1)/SquareSize);
nr              = ceil((Row2-Row1)/SquareSize);

%% create sequence

pOFF            = sprsns;
stimD           = nFr; 
stimF           = 1/(1-pOFF)*stimD; 
nwarmup         = 1000;
noise           = (2*bckgrnd-1) * ones(nr, nc, nwarmup+SS.nFrames);


stimcs = linspace(-1, 1, ncs);

for i = 1:nr
    for j = 1:nc
        ton = cumsum(stimD + geornd(1/(1+stimF), [1,ceil(2*SS.nFrames/(stimF+stimD))]));
        
        istim = repmat(ton, [stimD, 1]) + repmat((0:1:(stimD-1))', [1 size(ton,2)]);
        
        stimseq = stimcs(ceil(ncs*rand(1,size(ton,2))));
        stimseq = repmat(stimseq, stimD,1);
        
        ivalid = find(istim(:)<=(nwarmup+SS.nFrames));
        
        noise(i,j,istim(ivalid)) = stimseq(ivalid);
    end
end

images          = noise(:,:,nwarmup + (1:SS.nFrames));

SS.nImages      = size(images, 3);

% create textures
ImageTextures   = cell(SS.nImages,1);
for iImage = 1:SS.nImages   
    ImageTextures{iImage} = images(:,:,iImage);
end

% save stimulus sequence here??
SS                  = SS.LoadImageTextures( myScreenInfo, ImageTextures );
SS.ImageSequence    = 1:SS.nFrames;

SS.SourceRects  = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.DestRects    = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);

SS.BackgroundColor      = 0;
SS.BackgroundPersists   = true;

return

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimSparseNoiseUncorr(myScreenInfo); 
show(SS, myScreenInfo)
Screen('CloseAll');
% Play(SS, myScreenInfo) 

