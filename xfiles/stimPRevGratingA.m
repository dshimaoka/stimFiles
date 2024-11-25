function SS = stimPRevGratingA(myScreenInfo,audioPtr,Pars)
% stimPRevGrating makes reverse grating stimuli that have a predefined 
% interval of blank at first 

%---- Basics

if nargin < 2
  error('Must at least specify myScreenInfo & audioPtr');
end

if nargin < 3
  Pars = [];
end

%---- The parameters and their definition

pp = cell(1,1);
pp{1}  = {'durPrefix', 'Prefix   duration (s *10)',         10,0,600};
pp{2}  = {'durGrating', 'Grating duration (s *10)',         30,0,600};
pp{3}  = {'ori',   'Orientation  (deg)', 0, 0, 360};
pp{4}  = {'xc',     'Center, x (deg*10)',               0,-900,900};
pp{5}  = {'yc',     'Center, y (deg*10)',               0,-900,900};
pp{6}  = {'size',     'Horizontal/Vertical size, (deg*10)',     1200,1,1760};
pp{7}  = {'c',   'Contrast (%)',                           100,0,100};
pp{8}  = {'tf',   'Temporal frequency (Hz * 10)',         5,1,200};
pp{9}  = {'sc',   'Spatial cycles',        16,1,40};
pp{10}  = {'tph',   'Temporal phase  (deg)', 0, 0, 360};
pp{11}  = {'sph',   'Spatial phase  (deg)', 0, 0, 360};
pp{12} = {'toneFreq', 'Frequency of pure tone to play (Hz)', 2000, 0, 48000};

x = XFile('stimPRevGratingA',pp);
% x.Write; % call this ONCE: it writes the .x file

% With tph of 0, the grating begins with 0 contrast and gradually grows in contrast
% With tph of 90, the grating begins with maximum contrast and gradually decreases in contrast

%---- Parse the parameters

if isempty(Pars)
  Pars = x.ParDefaults;
end

durPref = Pars(1)/10; % seconds
durGrating = Pars(2)/10; % seconds
ori = Pars(3); % deg

[Col1,Row1] = Deg2PixCoord(Pars(4)/10-Pars(6)/10/2, Pars(5)/10-Pars(6)/10/2);
[Col2,Row2] = Deg2PixCoord(Pars(4)/10+Pars(6)/10/2, Pars(5)/10+Pars(6)/10/2);
Col2 = max(Col2,Col1+1);
Row2 = max(Row2,Row1+1);

c   = Pars(7)/100;
tf = Pars(8)/10; % Hz
sc = Pars(9); % Spatial cycles
tph = Pars(10) * (pi/180); % radians
sph = Pars(11) * (pi/180);% radians



%---- Make the stimulus
% consider using sin(x).^3.*sign(sin(x)) instead of sin(x) to get a smooth lift off

% SS = ScreenStim; % initialization
SS = ScreenSoundStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*(durPref+durGrating));
SS.Orientations = repmat(ori,[1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

nx = 256; % the source rectangles are of fixed 128x256 size...
ny = 128;
myRectangle = round([Col1 Row1 Col2 Row2]');
SS.DestRects   = repmat(myRectangle,[1 1 SS.nFrames]);
SS.SourceRects = repmat([1; 1; nx; ny],[1 1 SS.nFrames]);
SS.MinusOneToOne = 0;

% Make a grid 
[xx,~] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);

% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* sc * xx/(nx-1) + sph;

SS.nImages = round(myScreenInfo.FrameRate / tf) + 1; %+1 for the prefix part (no ramp for time being)

% The temporal phase of the response
TemporalPhase = 2*pi*(0:(SS.nImages-1))/SS.nImages + tph;

ActualFrequency = myScreenInfo.FrameRate/SS.nImages;
if abs(ActualFrequency/tf-1)>0.1
  fprintf(1,'Frequency %d is %2.2f rather than %2.0f Hz\n', ...
    igrat, ActualFrequency, tfreq);
end

ImageTextures = cell(SS.nImages,1);
ImageTextures{SS.nImages} = SS.BackgroundColor;
for iImage = 1:SS.nImages-1
  %   %--- drifting grating
  %   ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
  %   ImageTextures{iImage} = ...
  %     uint8(255*(1+c*ContrastImage));
  %--- reversing grating
  ContrastImage = sin(AngFreqs) * sin(TemporalPhase(iImage));
  ImageTextures{iImage} = ...
    uint8(SS.BackgroundColor(1)*(1+c*ContrastImage));
end

prefFrames = ceil(myScreenInfo.FrameRate*durPref);
SS.ImageSequence(1:prefFrames) = SS.nImages;
SS.ImageSequence(1+prefFrames:SS.nFrames) = 1+mod(1:SS.nFrames-prefFrames,SS.nImages-1);

% put the images in video RAM
SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

% Prepare the auditory stim. 
if Pars(12) == 0  
  SS = SS.LoadAudioBuffer(audioPtr, []);  
else
  t = (0:95999)/96000;
  SS = SS.LoadAudioBuffer(audioPtr, sin(t*2*pi*Pars(12)));
end;
return;


%---- Testing
RigInfo = RigInfoGet;
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;
InitializePsychSound;
audioPtr = PsychPortAudio('Open', [], [], 0, 96000, 1);


Pars(1) = 10; %pp{1}  = {'durPrefix', 'Prefix   duration (s *10)',         10,0,600};
Pars(2) = 30; %pp{2}  = {'durGrating', 'Grating duration (s *10)',         30,0,600};
Pars(3) = 0; %pp{3}  = {'ori',   'Orientation  (deg)', 0, 0, 360};
Pars(4) = 0; %pp{4}  = {'xc',     'Center, x (deg*10)',               0,-900,900};
Pars(5) = 0; %pp{5}  = {'yc',     'Center, y (deg*10)',               0,-900,900};
Pars(6) = 1200; %pp{6}  = {'size',     'Horizontal/Vertical size, (deg*10)',     1200,1,1760};
Pars(7) = 100; %pp{7}  = {'c',   'Contrast (%)',                           100,0,100};
Pars(8) = 5; %pp{8}  = {'tf',   'Temporal frequency (Hz * 10)',         5,1,200};
Pars(9) = 16; %pp{9}  = {'sc',   'Spatial cycles',        16,1,40};
Pars(10) = 0; %pp{10}  = {'tph',   'Temporal phase  (deg)', 0, 0, 360};
Pars(11) = 0; %pp{11}  = {'sph',   'Spatial phase  (deg)', 0, 0, 360};
Pars(12) = 2000; %pp{12} = {'toneFreq', 'Frequency of pure tone to play (Hz)', 2000, 0, 48000};

%myScreenStim = stimPRevGratingA(myScreenInfo,audioPtr);
SS1 = stimPRevGratingA(myScreenInfo,audioPtr, Pars);
Pars(12) = 0; Pars(8) = 10; Pars(9) = 8;
SS2 = stimPRevGratingA(myScreenInfo,audioPtr, Pars);
SS1.Show(myScreenInfo, audioPtr);
SS2.Show(myScreenInfo, audioPtr);
%my_Play(SS1, myScreenInfo, [], audioPtr);

  % ScreenInfo.Deg2PixCoord does not return negative values (although it
  % should), so we convert degrees to pixels on our own...
  function [xPix, yPix] = Deg2PixCoord(xDeg,yDeg)
    xPixCtr = myScreenInfo.Xmax/2;
    yPixCtr = myScreenInfo.Ymax/2;
    
    xPix = 2 * myScreenInfo.Dist/ myScreenInfo.PixelSize * tan( pi/180 * xDeg/2 );
    yPix = 2 * myScreenInfo.Dist/ myScreenInfo.PixelSize * tan( pi/180 * yDeg/2 );
    
    xPix = round(xPixCtr + xPix);
    yPix = round(yPixCtr + yPix);
  end

end


