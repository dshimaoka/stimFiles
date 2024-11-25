function SS = stimSPOTSadapt(myScreenInfo,Pars)
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
pp{1}   = {'dur',    'Stimuluse duration (s *10)',              10,1,6000};
pp{2}   = {'x1',     'Left border, from center (deg*10)',       -1350,-1500,1500};
pp{3}   = {'x2',     'Right border, from center (deg*10)',      1350,-1500,1500};
pp{4}   = {'y1',     'Bottom border, from center (deg*10)',     -450,-1500,1500};
pp{5}   = {'y2',     'Top border, from center (deg*10)',        450,-1500,1500};
pp{6}   = {'nfr',    'Number of frames per image',              6,1,70};
pp{7}   = {'sqsz',   'Size of squares (deg*10)',                75,1,100};
pp{8}  =  {'seed',   'Seed of random number generator',         1,1,100};
pp{9}  =  {'spotr',  'Adaptor row',                             1,1,100};
pp{10}  = {'spotc',  'Adaptor column',                          1,1,100};
pp{11}  = {'spotC',  'Adaptor contrast',                        0,0,100};
pp{12}  = {'spotP',  'Adaptor probability',                     35,0,100};

x = XFile('stimSPOTSadapt', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters
if isempty(Pars)
    Pars = x.ParDefaults;
end

spotr = Pars(9);
spotc = Pars(10);
spotC = Pars(11)/100;
spotP = Pars(12)/100;

dur     = Pars(1)/10; % seconds 
[Col1,Row1] = myScreenInfo.Deg2PixCoord( Pars(2)/10, Pars(4)/10 );
[Col2,Row2] = myScreenInfo.Deg2PixCoord( Pars(3)/10, Pars(5)/10 );
Col2 = max(Col2,Col1+1);
Row2 = max(Row2,Row1+1);

nFr = Pars(6);
SquareSize = myScreenInfo.Deg2Pix( Pars(7)/10 );
seed = Pars(8);

%% Make the stimulus

rand('seed',seed); %#ok<RAND>

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames)/2; % why do we need to divide by 2??

SS.BilinearFiltering = 0; % do not interpolate! 

nc = ceil((Col2-Col1)/SquareSize);
nr = ceil((Row2-Row1)/SquareSize);
images = zeros(nr, nc, nr*nc+2);
for i = 1:nr
    for j = 1:nc
        images(i,j,i + (j-1)*nr) = 1;
    end
end
images(spotr,spotc,nr*nc+1) = spotC;

sig = 1.25;
dt = -4*sig:1:4*sig;
gaus = exp( - dt.^2/(2*sig^2));
gaus = gaus'/sum(gaus);

% for i = 1:size(images,3)
%     images(:,:,i) = images(:,:,i) - my_conv(my_conv(images(:,:,i), sig)', sig)';        
% end
% images = 2*(images + gaus(4*sig+1)*gaus(4*sig))-1;
images = 2*images-1;

SS.nImages = size(images, 3);
% create textures
ImageTextures = cell(SS.nImages,1);
for iImage = 1:SS.nImages   
    ImageTextures{iImage} = images(:,:,iImage);
end

Nstims  = ceil(SS.nFrames/nFr);
seq     = ceil(rand(1,Nstims)*nr*nc);

noseq = numel(seq);
iBias = randperm(noseq, ceil(noseq * spotP));
seq(iBias) = nr*nc+1;

iBias = randperm(noseq, ceil(noseq * .1));
seq(iBias) = nr*nc+2;
seq = repmat(seq, nFr, 1);
seq = seq(1:SS.nFrames);

% save stimulus sequence here??
SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
SS.ImageSequence = seq(:)';
% SS.Amplitudes = zeros(1,SS.nFrames); % why do we need to divide by 2??
% SS.Amplitudes(1:nFr:end) = 1;

SS.SourceRects = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);

SS.BackgroundColor =  0; %gaus(4*sig+1)*gaus(4*sig) * 256;
SS.BackgroundPersists = true;

end

%% To test the code

% RigInfo = RigInfoGet; %#ok<UNRCH>
% myScreenInfo = ScreenInfo(RigInfo);
% myScreenInfo = myScreenInfo.CalibrationLoad;
% 
% SS = stimSparseNoiseUncorr(myScreenInfo); 
% show(SS, myScreenInfo)
% Screen('CloseAll');
% % Play(SS, myScreenInfo) 

function Smooth = my_conv(S1, sig)

NN = size(S1,1);
NT = size(S1,2);

dt = -4*sig:1:4*sig;
gaus = exp( - dt.^2/(2*sig^2));
gaus = gaus'/sum(gaus);

% Norms = conv(ones(NT,1), gaus, 'same');
%Smooth = zeros(NN, NT);
%for n = 1:NN
%    Smooth(n,:) = (conv(S1(n,:)', gaus, 'same')./Norms)';
%end

Smooth = filter(gaus, 1, [S1' ones(NT,1); zeros(4*sig, NN+1)]);
Smooth = Smooth(1+4*sig:end, :);
Smooth = Smooth(:,1:NN) ./ (Smooth(:, NN+1) * ones(1,NN));

Smooth = Smooth';
end