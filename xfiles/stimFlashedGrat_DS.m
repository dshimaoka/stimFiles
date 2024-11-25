function SS = stimFlashedGrat_DS(myScreenInfo,Pars)
% stimFlashedGrat makes flashed grating - that is it displays a grating
% with specified parameters only during a specified pulse time
%
% SS = stimFlashedGrat(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimFlashedGrat(myScreenInfo) uses the default parameters
%
% 2011-03 MC created stimFlashedBar
% 2012-02 ND modified to create stimFlashedGrat - NOT FINISHED

%% 2015-03-31 shape==0 is not working properly

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',   'Stimulus duration (s *10)',    3,   1,   6000};
pp{2}  = {'tf1',   'Temporal frequency (Hz*10)',   10,   1,   200};
pp{3}  = {'sf1',   'Spatial frequency (cpd*100)',  5,    0,   1000};
pp{4}  = {'c1',    'Contrast (%)'                  50,  -100, 100};
pp{5}  = {'ori1',  'Orientation (deg)',            45,   0,   360};
pp{6}  = {'dim1',  'Diameter (deg*10)'             100,  1,   50000};
pp{7}  = {'dim2',  'Diameter (deg*10)'             250,  1,   50000};
pp{8}  = {'x1',    'Focus position, x (deg*10)',   0,   -900, 900};
pp{9}  = {'y1',    'Focus position, y (deg*10)',   0,   -300, 300};
pp{10} = {'ton',   'onset time(ms)',               100,  1,   6000};
pp{11} = {'toff',  'offset time(ms)',              200, 1,   6000};
pp{12} = {'shape', 'shape (0 = circle; 1 = rect)', 0,    0,   2};

x = XFile('stimFlashedGrat_NS',pp);
% x = XFile('stimFlashedGrat_NS.x');
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%

dur     = Pars(1)/10;                           % seconds 
tf1      = Pars(2)/10;                           % Hz
sf1      = Pars(3)/100;                          % cpd
cont    = Pars(4);                              % contrast in percent
ori1 	= Pars(5);                              % deg
dima1    = myScreenInfo.Deg2Pix( Pars(6)/10 );   % pixels
dimb1    = myScreenInfo.Deg2Pix( Pars(7)/10 );   % pixels
[x0,y0] = myScreenInfo.Deg2PixCoord( Pars(8)/10, Pars(9)/10 ); % pixels
tt_on   = Pars(10)/1000;                        % seconds
tt_off  = Pars(11)/1000;                        % seconds
shape   = Pars(12);                            % 0 if circle; 1 if rectangle

cc 	= cont/100; % between 0 and 1 %%2015/3/31 what is this for?
mm 	= 0.5;        % between 0 and 1 %2015/3/31 what is this for?

downSampleFactor = 8;


%% Make the stimulus
SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = repmat(ori1,[1,SS.nFrames]);
SS.Amplitudes = repmat(0.5,[1,SS.nFrames]); % as usual, 0.5 is full contrast (don't ask why)

% generate the grating stimulus
% Make a grid of x and y
% if shape == 0 || shape==2 % a circle (or annulus)
    nx = dimb1;
    ny = dimb1;
    myRectangle = round([x0-dimb1/2 y0-dimb1/2 x0+dimb1/2 y0+dimb1/2]');
    SS.DestRects   = repmat(myRectangle,[1 1 SS.nFrames]);
    
    nx = round(nx/downSampleFactor);
    ny = round(ny/downSampleFactor);
    
    SS.SourceRects = repmat([1; 1; nx; ny],[1 1 SS.nFrames]);
% else % a rectangle
%     nx = dima1;
%     ny = dimb1;
%     x1 = round(x0 + x0*cos(pi*ori1/180));
%     y1 = round(y0 + x0*sin(pi*ori1/180));
%     
%     SS.SourceRects = repmat([1; 1; nx; ny],[1 1 SS.nFrames]);
%     SS.DestRects   = repmat([ x1-nx; y1-ny; x1+nx; y1+ny ],[1 1 SS.nFrames]);
% end


[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);

SS.MinusOneToOne = 0; 

CyclesPerPix = downSampleFactor*1/myScreenInfo.Deg2Pix(1/sf1); % sf in cycles/pix

% Image of the spatial phase of the stimulus (in radians)
spatphase = pi*(90)/180;
AngFreqs = -2*pi* CyclesPerPix * yy + spatphase;
  
if shape == 0 % circle
    
    dd = sqrt(xx.^2+yy.^2);
    WindowImage = double(dd >= dima1/2 & dd <= dimb1/2);
    
    nImages = round(myScreenInfo.FrameRate / tf1);
    SS.nImages = nImages * 2;
    
    % The temporal phase of the response
    tempphase = 0;
    TemporalPhase = 2*pi*(0:(SS.nImages-1))/nImages + tempphase;
    
    ActualFrequency = myScreenInfo.FrameRate/nImages;
    if abs(ActualFrequency/tf1-1)>0.1
        fprintf(1,'Frequency %d is %2.2f rather than %2.0f Hz\n', ...
            igrat, ActualFrequency, tf1);
    end
    ImageTextures = cell(SS.nImages,1);
    imScale = uint8(255*mm);
    imScaleCC = uint8(255*mm*cc);
    t = tic;
    for iImage = 1:nImages
%         tic
        %ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
        % Rather than the above line, we can use the fact that AngFreqs is
        % just one column repeated; >2x faster
        ContrastImage = repmat(sin(AngFreqs(:,1)+TemporalPhase(iImage)), 1, size(AngFreqs,2));
        
        %ImageTextures{iImage} = zeros(nx,ny,3,'uint8');
%         toc
        ImageTextures{iImage} = uint8(255*mm*(1+cc*ContrastImage.*WindowImage));        
        %ImageTextures{iImage} = imScale+imScaleCC*uint8(ContrastImage.*WindowImage);
%         toc
    end
    toc(t)
    for iImage = nImages+1:2*nImages % make a second set of the images that are blanks
        %ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
        ImageTextures{iImage} = zeros(nx,ny,3,'uint8')+255*mm;
        %ImageTextures{iImage} = uint8(255*mm*(1+0*ContrastImage.*WindowImage));
    end
    
    SS.BackgroundColor = floor(255*mm)*[1 1 1]';
    SS.BackgroundPersists = true;
    
    ii_on  = round(tt_on *myScreenInfo.FrameRate);
    ii_off = round(tt_off*myScreenInfo.FrameRate);
    
    ii_on  = max(ii_on ,0);
    ii_off = max(ii_off,0);
    
    ii_on  = min(ii_on ,SS.nFrames);
    ii_off = min(ii_off,SS.nFrames);
    
    SS.ImageSequence = 1+mod(1:SS.nFrames,nImages);
    % make visible the gratings during the pulse
    SS.ImageSequence(1:ii_on) = SS.ImageSequence(1:ii_on) + nImages;
    SS.ImageSequence(ii_off:end) = SS.ImageSequence(ii_off:end) + nImages;
    
elseif shape==1 % a rectangle: same computation as circle but no window applied
        
    nImages = round(myScreenInfo.FrameRate / tf1);
    SS.nImages = nImages * 2;
    
    % The temporal phase of the response
    tempphase = 0;
    TemporalPhase = 2*pi*(0:(SS.nImages-1))/nImages + tempphase;
    
    ActualFrequency = myScreenInfo.FrameRate/nImages;
    if abs(ActualFrequency/tf1-1)>0.1
        fprintf(1,'Frequency %d is %2.2f rather than %2.0f Hz\n', ...
            igrat, ActualFrequency, tf1);
    end
    ImageTextures = cell(SS.nImages,1);


    for iImage = 1:nImages

        %ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
        % Rather than the above line, we can use the fact that AngFreqs is
        % just one column repeated; >2x faster
        ContrastImage = repmat(sin(AngFreqs(:,1)+TemporalPhase(iImage)), 1, size(AngFreqs,2));
        
        %ImageTextures{iImage} = zeros(nx,ny,3,'uint8');
        ImageTextures{iImage} = uint8(255*mm*(1+cc*ContrastImage));        

    end
    for iImage = nImages+1:2*nImages % make a second set of the images that are blanks
        %ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
        ImageTextures{iImage} = zeros(nx,ny,3,'uint8')+255*mm;
        %ImageTextures{iImage} = uint8(255*mm*(1+0*ContrastImage.*WindowImage));
    end
    
    SS.BackgroundColor = floor(255*mm)*[1 1 1]';
    SS.BackgroundPersists = true;
    
    ii_on  = round(tt_on *myScreenInfo.FrameRate);
    ii_off = round(tt_off*myScreenInfo.FrameRate);
    
    ii_on  = max(ii_on ,0);
    ii_off = max(ii_off,0);
    
    ii_on  = min(ii_on ,SS.nFrames);
    ii_off = min(ii_off,SS.nFrames);
    
    SS.ImageSequence = 1+mod(1:SS.nFrames,nImages);
    % make visible the gratings during the pulse
    SS.ImageSequence(1:ii_on) = SS.ImageSequence(1:ii_on) + nImages;
    SS.ImageSequence(ii_off:end) = SS.ImageSequence(ii_off:end) + nImages;
    
elseif shape==2 % a circular gaussian aperture
    % dima/dim1 defines standard deviation of gaussian; dimb/dim2 defines
    % the extent over which it is calculated
    % Added by NS, 2014-09
    %sigx = 100*dima1; sigy = 100*dima1;
    sigx = dima1; sigy = dima1;
    WindowImage = exp(-(xx.^2/(2*sigx) + yy.^2/(2*sigy)));        %wrong
    
    nImages = round(myScreenInfo.FrameRate / tf1);
    SS.nImages = nImages * 2;
    
    % The temporal phase of the response
    tempphase = 0;
    TemporalPhase = 2*pi*(0:(SS.nImages-1))/nImages + tempphase;
    
    ActualFrequency = myScreenInfo.FrameRate/nImages;
    if abs(ActualFrequency/tf1-1)>0.1
        fprintf(1,'Frequency %d is %2.2f rather than %2.0f Hz\n', ...
            igrat, ActualFrequency, tf1);
    end
    
    ImageTextures = cell(SS.nImages,1);
    for iImage = 1:nImages
        ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
        ImageTextures{iImage} = zeros(nx,ny,3);
        ImageTextures{iImage} = uint8(255*mm*(1+cc*ContrastImage.*WindowImage));
    end
    for iImage = nImages+1:2*nImages % make a second set of the images that are blanks
        ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
        ImageTextures{iImage} = zeros(nx,ny,3);
        ImageTextures{iImage} = uint8(255*mm*(1+0*ContrastImage.*WindowImage));
    end
    
    SS.BackgroundColor = floor(255*mm)*[1 1 1]';
    SS.BackgroundPersists = true;
    
    ii_on  = round(tt_on *myScreenInfo.FrameRate);
    ii_off = round(tt_off*myScreenInfo.FrameRate);
    
    ii_on  = max(ii_on ,0);
    ii_off = max(ii_off,0);
    
    ii_on  = min(ii_on ,SS.nFrames);
    ii_off = min(ii_off,SS.nFrames);
    
    SS.ImageSequence = 1+mod(1:SS.nFrames,nImages);
    % make visible the gratings during the pulse
    SS.ImageSequence(1:ii_on) = SS.ImageSequence(1:ii_on) + nImages;
    SS.ImageSequence(ii_off:end) = SS.ImageSequence(ii_off:end) + nImages;
    
end
SS.BackgroundColor = floor(255*mm)*[1 1 1]';
SS.BackgroundPersists = true;
SS.WaveStim = [];

%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
disp('version 1.001')
return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimFlashedGrat'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
%% To test the code (a` la tlvs)

% MC wrote these lines 2014-09-20 from home and could not test them:
SetDefaultDirs;
[screenInfo,waveOutSess] = PrepTLVS;
stim = ScreenStim.Make(screenInfo, 'stimFlashedGrat');
stim.Show(screenInfo, [], waveOutSess, []);