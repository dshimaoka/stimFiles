function SS = stim2FlashedBars(myScreenInfo,Pars)
% stim2FlashedBars makes flashed bars
%
% SS = stim2FlashedBars(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stim2FlashedBars(myScreenInfo) uses the default parameters
%
% 2012-07 MC modified from stimFlashedBar

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

% RigInfo = RigInfoGet;
% myScreenInfo = ScreenInfo(RigInfo);

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',  'Stimulus duration (s *10)',             50,1,600};
pp{2}  = {'ori',   'Orientation (deg)',                    45, 0, 360};
pp{3}  = {'len',   'Bar length (deg*10)',                  300, 1, 900};
pp{4}  = {'wid',   'Bar width (deg*10)',                    50, 1, 900};
pp{5}  = {'pos1',  'Bar 1 position relative to focus (deg*10)'   200, -900, 900};
pp{6}  = {'pos2',  'Bar 2 position relative to focus (deg*10)'   300, -900, 900};
pp{7}  = {'xfocus','Focus position, x (deg*10)',           -300,-900, 900};
pp{8}  = {'yfocus','Focus position, y (deg*10)',            0, -300, 300};
pp{9}  = {'ton',   'Onset time(ms)',                         300,1,6000};
pp{10} = {'toff',  'Offset time(ms)',                         1300,1,6000};
pp{11} = {'lum1',  'Bar 1 luminance (%)',                     100,-100,100};
pp{12} = {'lum2',  'Bar 2 luminance (%)',                    -100,-100,100};

x = XFile('stim2FlashedBars',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10;                           % seconds 
ori 	= Pars(2);                              % deg
len     = myScreenInfo.Deg2PixCirc( Pars(3)/10 /2);   % pixels
wid     = myScreenInfo.Deg2PixCirc( Pars(4)/10 /2);   % pixels
r1      = myScreenInfo.Deg2PixCirc( Pars(5)/10 );   % pixels
r2      = myScreenInfo.Deg2PixCirc( Pars(6)/10 );   % pixels

[x0,y0] = myScreenInfo.Deg2PixCoord( Pars(7)/10, Pars(8)/10 ); % pixels

t_on    = Pars( 9)/1000;                     % seconds
t_off   = Pars(10)/1000;                    % seconds
lums    = Pars([11 12])/100;                    % in [-1,1]

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = repmat(ori,[1 SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2; % as usual, 0.5 is full contrast (don't ask why)

SS.nTextures = 2;
SS.nImages = 3;

ImageTextures = cell(SS.nImages,1);
ImageTextures{1} = 0; % blank
ImageTextures{2} = lums(1); 
ImageTextures{3} = lums(2);

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

i_on  = round(t_on *myScreenInfo.FrameRate);
i_off = round(t_off*myScreenInfo.FrameRate);

i_on  = max(i_on ,1);
i_off = max(i_off,1);

i_on  = min(i_on ,SS.nFrames);
i_off = min(i_off,SS.nFrames);

SS.ImageSequence = ones(2,SS.nFrames); % the default is to show the blank
SS.ImageSequence(1,i_on:i_off) = 2;
SS.ImageSequence(2,i_on:i_off) = 3;

x1 = round(x0 + r1*cos(pi*ori/180)); y1 = round(y0 + r1*sin(pi*ori/180));
x2 = round(x0 + r2*cos(pi*ori/180)); y2 = round(y0 + r2*sin(pi*ori/180));

% SS.SourceRects = repmat([1; 1; wid; len],[1 2 SS.nFrames]);
SS.SourceRects = repmat([1; 1; 2; 2],[1 2 SS.nFrames]);
SS.DestRects(:,1,:)   = repmat([ x1-wid; y1-len; x1+wid; y1+len ],[1 1 SS.nFrames]);
SS.DestRects(:,2,:)   = repmat([ x2-wid; y2-len; x2+wid; y2+len ],[1 1 SS.nFrames]);

return

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);

p = 900;
Pars = [ 30 0 300 100 -50+p 50+p 0 0 100 2900 100 -100];
SS = stim2FlashedBars(myScreenInfo,Pars)

SS.Show(myScreenInfo) 
 
