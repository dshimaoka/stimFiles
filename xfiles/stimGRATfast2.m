function SS = stimGRATfast2(myScreenInfo,Pars)
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

pp{1}   = {'dur',       'Stimulus duration (s *10)',        20,1,18000};
pp{2}   = {'sf',        'Spatial frequency (cpd *100)',     5,1,200};
pp{3}   = {'nORI',      'number of orientations',           12,1,100};
pp{4}   = {'nPH',       'number of spatial phases',         12,1,100};
pp{5}   = {'diam',      'Diameter (deg*10)',                400,0,1200};
pp{6}   = {'xc',        'Center, x (deg*10)',               0,-900,900};
pp{7}   = {'yc',        'Center, y (deg*10)',               0,-900,900};
pp{8}   = {'stimF',     'Blank ISI in frames',              0,0,100};
pp{9}   = {'stimD',     'Stimulus duration in frames',      3,0,100};
pp{10}  = {'stimOFF',   'OFF frames after stimulus',        0,0,100};
pp{11}  = {'oriB',      'Adaptor orientation (deg)',        0,0,180};
pp{12}  = {'oriC',      'Adaptor relative contrast',        100,0,100};
pp{13}  = {'oriP',      'Adaptor probability',              35,0,100};
pp{14}  = {'cr',        'Contrast of red gun (%)',          0,0,100};
pp{15}  = {'cg',        'Contrast of green gun (%)',        100,0,100};
pp{16}  = {'cb',        'Contrast of blue gun (%)',         100,0,100};
pp{17}  = {'lr',        'Mean luminance of red gun (%)',    0,0,100};
pp{18}  = {'lg',        'Mean luminance of green gun (%)',  50,0,100};
pp{19}  = {'lb',        'Mean luminance of blue gun (%)',   50,0,100};

x = XFile('stimGRATfast2', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars)
    Pars = x.ParDefaults;
end

rand('seed', 1);

dur         = Pars(1)/10; % s, duration
sfreq  		= Pars(2)/100;             % cpd
nORI        = Pars(3);               
nPH         = Pars(4);               
diam        = myScreenInfo.Deg2Pix( Pars(5)/10 );
[CtrCol,CtrRow] = myScreenInfo.Deg2PixCoord( Pars(6)/10, Pars(7)/10 );

stimF = Pars(8); % stimulus frequency
stimD = Pars(9); %stimulus duration
stimOFF = Pars(10); %stimulus duration
oriB = Pars(11);
oriC = Pars(12)/100;
oriP = Pars(13)/100;

cc 	= Pars(14:16)/100;    % between 0 and 1
mm 	= Pars(17:19)/100;     % between 0 and 1        

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
    
WindowImage = double( sqrt(xx.^2+yy.^2)<=diam/2 );
 
SS.nImages = 2*nPH+1;
ImageTextures = cell(SS.nImages,1);
spatphase = linspace(0, 2*pi, nPH+1);
for iImage = 1:nPH
    % Image of the spatial phase of the stimulus (in radians)
    AngFreqs = -2*pi* CyclesPerPix * xx + spatphase(iImage);
    ContrastImage = 2*ceil(sin( AngFreqs ))-1;    
    ImageTextures{iImage} = zeros(nx,ny,3);
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = ...
            255*mm(igun)*(1+cc(igun)*ContrastImage.*WindowImage);        
        ImageTextures{iImage+nPH}(:,:,igun) = ...
            255*mm(igun)*(1+oriC*cc(igun)*ContrastImage.*WindowImage);
    end    
end
ImageTextures{SS.nImages} = 128*ones(size(ImageTextures{SS.nImages-1}));

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

SS.ImageSequence = ceil(rand(1,SS.nFrames)*SS.nImages);

ton = cumsum(stimD + stimOFF + geornd(1/(1+stimF), 1, ceil(2 * 60/(stimF+stimOFF+stimD) * dur)));

istim = repmat(ton, stimD, 1) + repmat((0:1:(stimD-1))', 1, size(ton,2));
istim = istim(istim<=SS.nFrames);

oris = mod(linspace(0, 180, nORI+1), 180);
oris = oris(1:end-1);

oriseq = oris(ceil(rand(1,size(ton,2)) * numel(oris)));
noseq = numel(oriseq);
iBias = randperm(noseq, ceil(noseq * oriP));
oriseq(iBias) = oriB; % add copies of the biased orientation
oriseq = repmat(oriseq, stimD,1);
oriseq = oriseq(istim<=SS.nFrames);

textid = ceil(rand(1, size(ton,2)) * nPH);
textid(iBias) = textid(iBias) + nPH;
textid = repmat(textid, stimD,1);
textid = textid(istim<=SS.nFrames);

SS.Orientations = zeros(1, SS.nFrames);
SS.Orientations(istim) = oriseq;

SS.ImageSequence = SS.nImages * ones(1, SS.nFrames);
SS.ImageSequence(istim) = textid;

SS.Amplitudes = zeros(1,SS.nFrames)/2; 
SS.Amplitudes(ton(ton<SS.nFrames)) = 1;

myRectangle = round([CtrCol-diam/2 CtrRow-diam/2 CtrCol+diam/2 CtrRow+diam/2]');
SS.DestRects   = repmat(myRectangle,[1 1 SS.nFrames]);
SS.SourceRects = repmat([1; 1; diam; diam],[1 1 SS.nFrames]);
SS.MinusOneToOne = 0; 


%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );


return

%% to test the function

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimColorGrating'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures