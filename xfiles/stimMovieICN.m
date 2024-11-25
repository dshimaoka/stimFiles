function SS = stimMovieICN(myScreenInfo,Pars)
% stimMovieICN makes stimuli of type stimMovieICN.x
%
% SS = stimMovieICN(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimMovieICN(myScreenInfo) uses the default parameters
%
% 2011-07 MO, Still under development

%% Basics

if nargin < 1
  error('Must at least specify myScreenInfo');
end

if nargin < 2
  Pars = [];
end

%% The parameters and their definition
pp = cell(1,1);
pp{1} =  {'dur',  'Stimulus duration (s *10)',50,1,600};
% if the movie clip is longer than that, only a part of it will be shown
% if the movie clip is shorter, it will be shown over & over, until the desired duration is reached
pp{2}  = {'movieFile',  'Movie filename',  8009, 1, 9999};
pp{3}  = {'x1',   'Left border, from center (deg*10)', -400,-1300,500};
pp{4}  = {'x2',   'Right border, from center (deg*10)',  400,-500,1300};

x = XFile('stimMovieICN',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
  Pars = x.ParDefaults;
end

if ~exist(['\\zubjects\Data\movies\', num2str(Pars(2)), '.mat'], 'file')
  disp('could not find the movie...');
  return
end;
load(['\\zubjects\Data\movies\', num2str(Pars(2))]); % defines Stim.frames{1}, and maybe imagerate as well

if exist('imagerate', 'var')
  disp('disregarding the provided imagerate in favor of 25Hz');
end;
dur = Pars(1)/10; % in seconds
framesToUse = ceil(Pars(1)*2.5);
Col1 = myScreenInfo.Deg2PixCoord( Pars(3)/10, 0 );
Col2 = myScreenInfo.Deg2PixCoord( Pars(4)/10, 0 );
Col2 = max(Col2,Col1+1);

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames); %/2; % why do we need to divide by 2??
SS.BilinearFiltering = 0; % do not interpolate!
SS.nImages = min(length(Stim.frames{1}), framesToUse);

nc = Col2-Col1;
nr = myScreenInfo.Ymax;

for i = 1:SS.nImages
  frame = double(Stim.frames{1}{i});
  frame = (frame - mean(frame(:))) / std(frame(:));
  Stim.frames{1}{i} = frame;
end;
Stim.frames{1} = {Stim.frames{1}{1:SS.nImages}};
SS = SS.LoadImageTextures(myScreenInfo, Stim.frames{1});
SS.ImageSequence = zeros(1,SS.nFrames);

for iFrame = 1:SS.nFrames  
  iImage = ceil(iFrame/myScreenInfo.FrameRate * 25); %, SS.nImages);
  iImage = mod(iImage, SS.nImages);
  if iImage == 0
    iImage = SS.nImages;
  end;
  SS.ImageSequence(iFrame) = iImage;
end;

%SS.SourceRects = repmat([1; 1; nc; nr],[1 1 SS.nFrames]);
SS.SourceRects = repmat([1; 1; size(Stim.frames{1}{1}, 2); size(Stim.frames{1}{1}, 1)],[1 1 SS.nFrames]);
SS.DestRects   = repmat([Col1; 1; Col2; myScreenInfo.Ymax],[1 1 SS.nFrames]);

return

%% To test the code

RigInfo = RigInfoGet;
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

Pars = [600, 5250, 50, -400, 400, 0];
SS = stimMovieICN(myScreenInfo, Pars);
%SS.Show(myScreenInfo)
Play(SS, myScreenInfo);

