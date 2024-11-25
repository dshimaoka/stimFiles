function SS = stimNatObj(myScreenInfo,Pars)

% Created by SF based on stimImgLoad5.m

% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1} =  {'dur',    'Stimulus duration (s*10)',                   5,1,100};
pp{2} =  {'c',      'Contrast (%)',                               100,0,100};
pp{3} =  {'xc',     'Center, x (deg*10)',                         0,-1400,1400};
pp{4} =  {'yc',     'Center, y (deg*10)',                         0,-450,450};
pp{5} =  {'gSTD',   'STD of Gaussian window (deg)',               10,0,100};
pp{6} =  {'theta',  'Rotation (deg)',                             0,0,360}; % Amount object will be rotated in pos and neg direction
pp{7} =  {'seed',   'Seed of random number generator',            1,1,1000};
pp{8} =  {'nimg',   'Number of unique images to show',            10,1,2800}; 
pp{9} =  {'repn',   'Which image in the sequence (0 is random)',  0,0,10000};
pp{10} = {'pbl',    'Percentage blanks',                          5,0,100};

x = XFile('stimNatObj',pp);
% x.Write; % call this ONCE: it writes the .x file

% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

[Col1,Row1] = myScreenInfo.Deg2PixCoord( -140, -45 );
[Col2,Row2] = myScreenInfo.Deg2PixCoord( 140, 45 );

[xCor, yCor] = myScreenInfo.Deg2PixCoord(Pars(3)/10, Pars(4)/10);

gSTD = myScreenInfo.Deg2Pix(Pars(5));

Col2 = max(Col2,Col1+1);
Row2 = max(Row2,Row1+1);

dur     = Pars(1)/10;
c       = Pars(2)/100;
theta   = Pars(6);
seed    = Pars(7);
nimg    = Pars(8); 
repn    = Pars(9);
pblanks = Pars(10)/100;
%% Make the stimulus
root = sprintf('C:\\StimulusDATA\\natObj\\');

rng('default');
rng(seed);

if repn>0
    ntotstim    = nimg + ceil(pblanks*nimg);
    iperm       = randperm(ntotstim*3); % Multiply by 3 to show normal, rotated x, rotated -x. Multiply by more for additional translations, etc.
%     isample     = iperm(rem(repn-1, ntotstim) + 1);
    isample = iperm(repn);
else
    isample     = ceil(rand * (nimg + ceil(pblanks *nimg)));
end

if isample > nimg*3
    dat.img = zeros(10); % Blank
elseif isample <= nimg
    dat         = load(fullfile(root, sprintf('img%d.mat', isample))); % Loads image to be windowed and positioned   
elseif isample <= nimg*2 
    dat         = load(fullfile(root, sprintf('img%d.mat', isample-nimg))); 
elseif isample <= nimg*3 
    dat         = load(fullfile(root, sprintf('img%d.mat', isample-nimg*2)));
end

nr = size(dat.img,1);
nc = size(dat.img,2);

if isample <= nimg*3
       
    dr = myScreenInfo.ScreenRect(4);
    dc = myScreenInfo.ScreenRect(3);
    
    rR = nr/dr;
    cR = nc/dc;
    
    gSR = gSTD*rR;
    gSC = gSTD*cR;
    
    [X, Y] = meshgrid(1:nc, 1:nr);
    
    gaussWin = mvnpdf([X(:) Y(:)], [nc/2 nr/2], [gSC^2 gSR^2]);
    
    gaussWin = reshape(gaussWin, length(1:nr), length(1:nc));
    
    gaussWin = gaussWin/max(max(gaussWin));
    
%     Apply Gaussian window
    
    winImg = dat.img.*gaussWin;
    
%     Normalize to get full contrast

    winImg = winImg/max(abs(winImg(:)));
    
%     Rotate
    
    if isample > nimg*2 % Rotate x

        winImg = imrotate(winImg, theta,'bilinear','crop');
    
    elseif isample > nimg % Rotate -x
        
        winImg = imrotate(winImg, -theta,'bilinear','crop');
        
    end
    
%     Translate to xCor and yCor
    
    winImg = imtranslate(winImg,[-(nc/2 - xCor*cR),-(nr/2 - yCor*rR)],'OutputView','same');
    
   
else
    winImg = dat.img; % Blank
end


ImageTextures{1} = double(winImg);

SS = ScreenStim; % initialization
%SS.BackgroundColor      = double(round(255 * 0.5));
%SS.BackgroundPersists   = true;

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
% SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.nFrames = round(myScreenInfo.FrameRate*dur);

SS.Orientations = zeros(1,SS.nFrames); 
SS.Amplitudes = ones(1,SS.nFrames)*c; 

% check if this is useful
SS.BilinearFiltering = 0; % do not interpolate!
SS.MinusOneToOne = true;

SS.nImages = 1;
SS.ImageSequence = ones(1, SS.nFrames); 
% SS.ImagePointers(iImage);

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

nr = size(ImageTextures{1},1);
nc = size(ImageTextures{1},2);

SS.SourceRects = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; Row1; Col2; Row2],[1 1 SS.nFrames]);


fprintf('Texture loaded \n')


return

%% To test the code
% Screen('Preference', 'SkipSyncTests', 1);

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimNatObj(myScreenInfo);
% SS.Show(myScreenInfo)
Play(SS, myScreenInfo)

