function SS = stimSweepGrating(myScreenInfo,Pars)
% STIMSWEEPGRATING makes sweeps of gratings with changing tf 
%
% SS = stimSweepGrating(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimSweepGrating(myScreenInfo) uses the default parameters
%
% from stimFlashedGrat & stim2FlashedBars
% NOTE: 'shape' is not implemented yet, always a circle
%
% 2013-03 AB

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',   'Stimulus duration (s *10)',    80,   1,   600};
pp{2}  = {'tf1',   'Temporal frequency (Hz*10)',   10,   1,   200};
pp{3}  = {'tf2',   'Temporal frequency (Hz*10)',   100,   1,   200};
pp{4}  = {'sf1',   'Spatial frequency (cpd*100)',  5,    0,   1000};
pp{5}  = {'c1',    'Contrast (%)'                  50,  -100, 100};
pp{6}  = {'ori1',  'Orientation (deg)',            45,   0,   360};
pp{7}  = {'dim1',  'Diameter (deg*10)'             1,  1,   500};
pp{8}  = {'dim2',  'Diameter (deg*10)'             800,  1,   1000};
pp{9}  = {'x1',    'Focus position, x (deg*10)',   0,   -900, 900};
pp{10} = {'y1',    'Focus position, y (deg*10)',   0,   -300, 300};
pp{11} = {'ton',   'onset time(ms)',               1000,  1,   6000};
pp{12} = {'toff',  'offset time(ms)',              4000, 1,   6000};
pp{13} = {'shape', 'shape (0 = circle; 1 = rect)', 0,    0,   1};

x = XFile('stimSweepGrating',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%% more pars

dur     = Pars(1)/10;                           % seconds 
tf1     = Pars(2)/10;                           % Hz
tf2     = Pars(3)/10;                           % Hz
sf1     = Pars(4)/100;                          % cpd
cont    = Pars(5);                              % contrast in percent
ori1 	= Pars(6);                              % deg
dima1   = myScreenInfo.Deg2Pix( Pars(7)/10 );   % pixels
dimb1   = myScreenInfo.Deg2Pix( Pars(8)/10 );   % pixels
[x0,y0] = myScreenInfo.Deg2PixCoord( Pars(9)/10, Pars(10)/10 ); % pixels
tt_on   = Pars(11)/1000;                        % seconds
tt_off  = Pars(12)/1000;                        % seconds
shape   = Pars(13);                             % 0 if circle; 1 if rectangle

cc 	    = cont/100;   % between 0 and 1
mm 	    = 0.5;        % between 0 and 1


%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type         = x.Name;
SS.Parameters   = Pars;
SS.nTextures    = 1;
SS.nFrames      = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = repmat(ori1,[1 SS.nFrames]);
SS.Amplitudes   = repmat(0.5,[1,SS.nFrames]); % as usual, 0.5 is full contrast (don't ask why)

% generate the grating stimulus
% Make a grid of x and y
if shape == 0 % a circle (or annulus)
    nx = dimb1;
    ny = dimb1;
    myRectangle    = round([x0-dimb1/2 y0-dimb1/2 x0+dimb1/2 y0+dimb1/2]');
    SS.DestRects   = repmat(myRectangle,[1 1 SS.nFrames]);
    SS.SourceRects = repmat([1; 1; dimb1; dimb1],[1 1 SS.nFrames]);
else          % a rectangle
    nx = dima1;
    ny = dimb1;
    x1 = round(x0 + x0*cos(pi*ori1/180));
    y1 = round(y0 + x0*sin(pi*ori1/180));
    
    SS.SourceRects = repmat([1; 1; nx; ny],[1 1 SS.nFrames]);
    SS.DestRects   = repmat([ x1-nx; y1-ny; x1+nx; y1+ny ],[1 1 SS.nFrames]);
end
[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);

SS.MinusOneToOne = 0; 
CyclesPerPix = 1/myScreenInfo.Deg2Pix(1/sf1); % sf in cycles/pix

% Image of the spatial phase of the stimulus (in radians)
spatphase = pi*(90)/180;
AngFreqs = -2*pi* CyclesPerPix * yy + spatphase;
    
if shape == 0 % circle
    dd          = sqrt(xx.^2+yy.^2);
    WindowImage = double(dd >= dima1/2 & dd <= dimb1/2);
    nImagesTot  = SS.nFrames; % Loaded in memory and determined by dur   
    nImagesCycl1 = round(myScreenInfo.FrameRate / tf1); 
    nImagesCycl2 = round(myScreenInfo.FrameRate / tf2); 
    
    SS.nImages  = nImagesTot+1; % 1 extra for blank (no need to match SS.nFrames)
    
    % The temporal phase of the response
    tempphase = 0;
    TemporalPhs = 2*pi*(0:((nImagesCycl1*2)-1))/nImagesCycl1 + tempphase;
    dPhase1     = median(diff(TemporalPhs)); 
    TemporalPhs = 2*pi*(0:((nImagesCycl2*2)-1))/nImagesCycl2 + tempphase;
    dPhase2     = median(diff(TemporalPhs)); 
    
    % linear change in Tf
    dphases = linspace(dPhase1,dPhase2,nImagesTot-1);
    TemporalPhase = []; TemporalPhase(1) = 0; 
    for ifrm = 2:nImagesTot
        TemporalPhase(ifrm) = TemporalPhase(ifrm-1) + dphases(ifrm-1);
    end
    
    ImageTextures = cell(SS.nImages,1); 
    for iImage = 1:nImagesTot % nImages
        ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
        ImageTextures{iImage} = zeros(nx,ny,3);
        ImageTextures{iImage} = uint8(255*mm*(1+cc*ContrastImage.*WindowImage));
    end
    % 1 extra for the blank
    ImageTextures{nImagesTot+1} = uint8(255*mm*(1+0*ContrastImage.*WindowImage));
    
    SS.BackgroundColor = floor(255*mm)*[1 1 1]';
    SS.BackgroundPersists = true;
    
    ii_on  = round(tt_on *myScreenInfo.FrameRate);
    ii_off = round(tt_off*myScreenInfo.FrameRate);
    
    ii_on  = max(ii_on ,0);
    ii_off = max(ii_off,0);
    
    ii_on  = min(ii_on ,SS.nFrames);
    ii_off = min(ii_off,SS.nFrames);
    
    SS.ImageSequence = 1:SS.nFrames; 
    % make visible the gratings during the pulse, blank the rest
    SS.ImageSequence(1:ii_on)    = ones(1,ii_on)*(nImagesTot+1); 
    SS.ImageSequence(ii_off:end) = ones(1,length(SS.ImageSequence(ii_off:end)))*(nImagesTot+1); 

else  % a rectangle, NOT IMPLEMENTED YET
   
    error('stimSweepGrating.m,  Shape=1 not yet implemented, please set shape=0');
    % Check stimFlashGrat.m to implement it
end
 
SS.BackgroundColor = floor(255*mm)*[1 1 1]';
SS.BackgroundPersists = true;
SS.WaveStim = [];

%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

return

%% To test the code

global DIRS
% From RigInfo = RigInfoGet; on zap
load('\\zserver\Lab\Tmp\benucci\RigInfo.mat'); 
RigInfo.VsDisplayScreen = 1;
RigInfo.MonitorNumber = 2;
SetDefaultDirs;
addpath('\\zserver\Data\xfiles\');
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo.Dist = 24;

% for stimSweepGrating
pp = cell(1,1);
pp{1}  = {'dur',   'Stimulus duration (s *10)',    80,   1,   600};
pp{2}  = {'tf1',   'Temporal frequency (Hz*10)',   100,   1,   200};
pp{3}  = {'tf2',   'Temporal frequency (Hz*10)',   10,   1,   200};
pp{4}  = {'sf1',   'Spatial frequency (cpd*100)',  5,    0,   1000};
pp{5}  = {'c1',    'Contrast (%)'                  50,  -100, 100};
pp{6}  = {'ori1',  'Orientation (deg)',            45,   0,   360};
pp{7}  = {'dim1',  'Diameter (deg*10)'             0,  1,   500};
pp{8}  = {'dim2',  'Diameter (deg*10)'             800,  1,   1000};
pp{9}  = {'x1',    'Focus position, x (deg*10)',   0,   -900, 900};
pp{10} = {'y1',    'Focus position, y (deg*10)',   0,   -300, 300};
pp{11} = {'ton',   'onset time(ms)',               1000,  1,   6000};
pp{12} = {'toff',  'offset time(ms)',              8000, 1,   6000};
pp{13} = {'shape', 'shape (0 = circle; 1 = rect)', 0,    0,   1};

x = XFile('stimSweepGrating',pp);
% x.Write; % call this ONCE: it writes the .x file

% Parse the parameters
Pars = x.ParDefaults;

myScreenStim = ScreenStim.Make( myScreenInfo,'stimSweepGrating',Pars );

SS = myScreenStim;
SS.Type = x.Name;
SS.Parameters = Pars;
SS.Show(myScreenInfo);

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
