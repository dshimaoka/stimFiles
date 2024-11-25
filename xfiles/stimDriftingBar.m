function SS = stimDriftingBar(myScreenInfo,Pars)
% stimDriftingBar makes a color bar moving across the screen at specific
% orientation
%
% SS = stimDriftingBar(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimDriftingBar(myScreenInfo) uses the default parameters
%
% 2015-04 SS

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',    'Stimulus duration (s *10)',            50,1,6000};
pp{2}  = {'x',      'Bar center at half duration (deg*10)', 0,-1800,1800};
pp{3}  = {'y',      'Bar center at half duration (deg*10)', 0,-1800,1800};
pp{4}  = {'width',  'Bar width (deg*10)',                   30,0,3600};
pp{5}  = {'length', 'Bar length (deg*10)',                  200,0,1600};
pp{6}  = {'dir',    'Direction of movement (deg)',          45,0,360};
pp{7}  = {'speed',  'Movement speed (deg*10/s)',            150,0,10000};
pp{8}  = {'r',      'Amplitude of red gun (%)',             100,0,100};
pp{9}  = {'g',      'Amplitude of green gun (%)',           0,0,100};
pp{10} = {'b',      'Amplitude of blue gun (%)',            0,0,100};
pp{11} = {'lr',     'Mean luminance of red gun (%)',        50,0,100};
pp{12} = {'lg',     'Mean luminance of green gun (%)',      50,0,100};
pp{13} = {'lb',     'Mean luminance of blue gun (%)',       50,0,100};

x = XFile('stimDriftingBar', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur     = Pars(1)/10; % seconds
[x_mid, y_mid] = myScreenInfo.Deg2PixCoord( Pars(2)/10, Pars(3)/10 );
width = myScreenInfo.Deg2Pix( Pars(4)/10 );
len = myScreenInfo.Deg2Pix( Pars(5)/10 );
orientation = Pars(6);
shiftPerFrame = myScreenInfo.Deg2Pix( Pars(7)/10 ) / myScreenInfo.FrameRate;
cc 	= Pars(8:10)/100;      % between 0 and 1
mm 	= Pars(11:13)/100;     % between 0 and 1


%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.nImages = 1;
SS.Orientations = ones(1,SS.nFrames) * orientation;
SS.Amplitudes = ones(1,SS.nFrames)/2;
SS.BilinearFiltering = 0; % do not interpolate!
SS.MinusOneToOne = 0;

% make source image: bar on background, height equals length of bar, width
% equals width of bar plus number of shift pixels in each direction;
% presented will be the part of the image representing bar at correct shift
% position
totalShift = ceil(shiftPerFrame * (SS.nFrames - 1));
imWidth = width + 2 * totalShift;
ImageTextures{1} = zeros(len, imWidth, 3);
for igun = 1:3
    ImageTextures{1}(:,:,igun) = uint8(255*mm(igun));
    ImageTextures{1}(:, totalShift+(1:width), igun) = uint8(255*cc(igun));
end

SS.DestRects = repmat(CenterRectOnPointd([0 0 width+totalShift len], ...
    x_mid, y_mid), [1 1 SS.nFrames]);
% SS.SourceRects = permute([zeros(1, SS.nFrames); zeros(1, SS.nFrames); ...
%     ones(1, SS.nFrames) * (width+totalShift); ones(1, SS.nFrames) * len], ...
%     [1 3 2]);
SS.SourceRects = permute([totalShift : -shiftPerFrame : 0; zeros(1, SS.nFrames); ...
    [width+2*totalShift : -shiftPerFrame : width+totalShift]; ones(1, SS.nFrames) * len], ...
    [1 3 2]);
SS.ImageSequence = ones(1, SS.nFrames);

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

return

%% To test the code

RigInfo = RigInfoGet; %#ok<UNRCH>
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

SS = stimDriftingBar(myScreenInfo); 
show(SS, myScreenInfo);
Screen('CloseAll');
% Play(SS, myScreenInfo) 

