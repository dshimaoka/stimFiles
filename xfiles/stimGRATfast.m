function SS = stimGRATfast(myScreenInfo,Pars)
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

pp{1}  = {'dur',	'Stimulus duration (s *10)',        20,1,18000};
pp{2}  = {'tf',     'Temporal frequency (Hz *10)',      40,1,400};
pp{3}  = {'sf',     'Spatial frequency (cpd *100)',     5,1,200};
pp{4}  = {'tph',    'Temporal phase (deg)',             0,0,360};
pp{5}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{6}  = {'nORI',     'number of orientations',  12,1,100};
pp{7}  = {'diam',   'Diameter (deg*10)',                100,0,1200};
pp{8}  = {'xc',     'Center, x (deg*10)',               0,-900,900};
pp{9}  = {'yc',     'Center, y (deg*10)',               0,-900,900};
pp{10}  = {'cr',    'Contrast of red gun (%)',          0,0,100};
pp{11}  = {'cg',	'Contrast of green gun (%)',        100,0,100};
pp{12}  = {'cb',	'Contrast of blue gun (%)',         100,0,100};
pp{13}  = {'lr',	'Mean luminance of red gun (%)',    0,0,100};
pp{14}  = {'lg',    'Mean luminance of green gun (%)',  50,0,100};
pp{15}  = {'lb',    'Mean luminance of blue gun (%)',   50,0,100};
pp{16}  = {'stimF',    'Stimulus frequency in frames',  10,0,100};
pp{17}  = {'stimD',    'Stimulus duration in frames',   3,0,100};
pp{18}  = {'oriB',    'Orientation biased (deg)',        30,0,360};
pp{19}  = {'oriF',    'Bias ratio',                     6,1,100};
pp{20}  = {'stimOFF',    'OFF frames after stimulus',   2,0,100};

x = XFile('stimGRATfast', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars)
    Pars = x.ParDefaults;
end

rand('seed', 1);

dur         = Pars(1)/10; % s, duration
tfreq	 	= Pars(2)/10;              % Hz
sfreq  		= Pars(3)/100;             % cpd
tempphase  	= Pars(4) * (pi/180);      % radians
spatphase  	= Pars(5) * (pi/180);      % radians
nORI        = Pars(6);               
diam        = myScreenInfo.Deg2Pix( Pars(7)/10 );
[CtrCol,CtrRow] = myScreenInfo.Deg2PixCoord( Pars(8)/10, Pars(9)/10 );

cc 	= Pars(10:12)/100;         % between 0 and 1
mm 	= Pars(13:15)/100;     % between 0 and 1        

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(60*dur );

CyclesPerPix = 1/myScreenInfo.Deg2Pix(1/sfreq); % sf in cycles/pix

% Make a grid of x and y
nx = diam;
ny = diam; % if you were willing to do without the window this could be one!
[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);
    
% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* CyclesPerPix * xx + spatphase;
    
WindowImage = double( sqrt(xx.^2+yy.^2)<=diam/2 );
 
SS.nImages = 1;
% The temporal phase of the response
TemporalPhase = zeros(1, SS.nImages) + tempphase;    
ImageTextures = cell(SS.nImages,1);
for iImage = 1:SS.nImages
    ContrastImage = 2*ceil(sin( AngFreqs + TemporalPhase(iImage)))-1;
    ImageTextures{iImage} = zeros(nx,ny,3);
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = ...
            uint8(255*mm(igun)*(1+cc(igun)*ContrastImage.*WindowImage));
    end
end

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

SS.ImageSequence = ones(1,SS.nFrames);


stimF = Pars(16); % stimulus frequency
stimD = Pars(17); %stimulus duration
stimOFF = Pars(20); %stimulus duration

ton = cumsum(stimD + stimOFF + geornd(1/(1+stimF), 1, ceil(2 * 60/stimF * dur)));

istim = repmat(ton, stimD, 1) + repmat((0:1:(stimD-1))', 1, size(ton,2));
istim = istim(istim<=SS.nFrames);
SS.Amplitudes = zeros(1,SS.nFrames)/2; 
SS.Amplitudes(istim) = 1;

oriB = Pars(18);
oriF = Pars(19);

oris = mod(linspace(oriB, oriB+360, nORI+1), 360);
oris = oris(1:end-1);
oris(numel(oris) +(1:(oriF-1))) = oriB; % add copies of the biased orientation

oriseq = oris(ceil(rand(1,size(ton,2)) * numel(oris)));
oriseq = repmat(oriseq, stimD,1);
oriseq = oriseq(istim<=SS.nFrames);
SS.Orientations = zeros(1, SS.nFrames);
SS.Orientations(istim) = oriseq;

myRectangle = round([0 0 0 0]');
SS.DestRects   = repmat(myRectangle,[1 1 SS.nFrames]);
SS.SourceRects = repmat([1; 1; 1; 1],[1 1 SS.nFrames]);

myRectangle = round([CtrCol-diam/2 CtrRow-diam/2 CtrCol+diam/2 CtrRow+diam/2]');
SS.DestRects(:,:,istim)   = repmat(myRectangle,[1 1 numel(istim)]);
SS.SourceRects(:,:,istim) = repmat([1; 1; diam; diam],[1 1 numel(istim)]);
SS.MinusOneToOne = 0; 


%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );


return

%% to test the function

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimColorGrating'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures