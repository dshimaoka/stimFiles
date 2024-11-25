function SS = stimFlashedBar(myScreenInfo,Pars)
% stimFlashedBar makes flashed bars
%
% SS = stimFlashedBar(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimFlashedBar(myScreenInfo) uses the default parameters
%
% 2011-03 MC

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur', 'Stimulus duration (s *10)',               50,1,600};
pp{2} = {'ori',     'Orientation (deg)',                    45, 0, 360};
pp{3} = {'len',     'Bar length (deg*10)',                  300, 1, 900};
pp{4} = {'wid',     'Bar width (deg*10)',                    50, 1, 900};
pp{5} = {'pos',     'Position relative to focus (deg*10)'   200, -900, 900};
pp{6} = {'xfocus',  'Focus position, x (deg*10)',           -300,-900, 900};
pp{7} = {'yfocus',  'Focus position, y (deg*10)',           0, -300, 300};
pp{8}  = {'ton1',  '1st onset time(ms)',                    300,1,6000};
pp{9}  = {'toff1', '1st offset time(ms)',                   1300,1,6000};
pp{10}  = {'ton2',  '2nd onset time(ms)',                   1400,1,6000};
pp{11}  = {'toff2', '2nd offset time(ms)',                  2400,1,6000};
pp{12}  = {'lum1',    '1st luminance (%)',                    100,-100,100};
pp{13}  = {'lum2',    '2nd luminance (%)',                   -100,-100,100};

x = XFile('stimFlashedBar',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%

dur     = Pars(1)/10;                           % seconds 
ori 	= Pars(2);                              % deg
len     = myScreenInfo.Deg2Pix( Pars(3)/10 );   % pixels
wid     = myScreenInfo.Deg2Pix( Pars(4)/10 );   % pixels
r       = myScreenInfo.Deg2Pix( Pars(5)/10 );   % pixels
[x0,y0] = myScreenInfo.Deg2PixCoord( Pars(6)/10, Pars(7)/10 ); % pixels
tt_on   = Pars([8 10])/1000;                    % seconds
tt_off  = Pars([9 11])/1000;                    % seconds
lums    = Pars([12 13])/100;                    % in [-1,1]


%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = repmat(ori,[1 SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2; % as usual, 0.5 is full contrast (don't ask why)

SS.nImages = 3;
ImageTextures = cell(SS.nImages,1);
ImageTextures{1} = 0; % blank
ImageTextures{2} = lums(1); 
ImageTextures{3} = lums(2);

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

ii_on  = round(tt_on *myScreenInfo.FrameRate);
ii_off = round(tt_off*myScreenInfo.FrameRate);

ii_on  = max(ii_on ,0);
ii_off = max(ii_off,0);

ii_on  = min(ii_on ,SS.nFrames);
ii_off = min(ii_off,SS.nFrames);

SS.ImageSequence = ones(1,SS.nFrames); % the default is to show the blank
SS.ImageSequence(ii_on(1):ii_off(1)) = 2;
SS.ImageSequence(ii_on(2):ii_off(2)) = 3;

% from here on things are likely to be wrong...

x1 = round(x0 + r*cos(pi*ori/180));
y1 = round(y0 + r*sin(pi*ori/180));

SS.SourceRects = repmat([1; 1; wid; len],[1 1 SS.nFrames]);
SS.DestRects   = repmat([ x1-wid; y1-len; x1+wid; y1+len ],[1 1 SS.nFrames]);

return

%% To test the code

SS.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
