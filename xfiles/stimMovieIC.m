function SS = stimMovieIC(myScreenInfo,Pars)
% stimMovieIC makes stimuli of type stimMovieIC.x
%
% SS = stimMovieIC(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimMovieIC(myScreenInfo) uses the default parameters
%
% 2011-07 MO, Still under development

%% Basics

if nargin < 2, Pars = []; end
if nargin < 1, error('Must at least specify myScreenInfo'); end

%% The parameters and their definition
pp = cell(1,1);
pp{1} =  {'dur',  'Stimulus duration (s *10)',50,1,600};
% if the movie clip is longer than that, only a part of it will be shown
% if the movie clip is shorter, it will be shown over & over, until the desired duration is reached
pp{2}  = {'movieFile',  'Movie filename',  8009, 1, 9999};
pp{3}  = {'x1',   'Left border, from center (deg*10)', -400,-1300,500};
pp{4}  = {'x2',   'Right border, from center (deg*10)',  400,-500,1300};

x = XFile('stimMovieIC',pp);

%% Parse the parameters

if isempty(Pars), Pars = x.ParDefaults; end

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
%SS.MinusOneToOne = false;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.Orientations = zeros(1,SS.nFrames);
SS.Amplitudes = ones(1,SS.nFrames); %/2; % why do we need to divide by 2??
SS.BilinearFiltering = 0; % do not interpolate!
SS.nImages = min(length(Stim.frames{1}), framesToUse);

nc = Col2-Col1;
nr = myScreenInfo.Ymax;

Csquash = 1;

for i = 1:SS.nImages
  frame = 2*double(Stim.frames{1}{i})/255 - 1; % between -1 and 1...
% for j = 1:10
%   frame = frame-mean(frame(:));
%   frame(frame < -1) = -1;
%   frame(frame > 1) = 1;
% end;
% if mean(frame(:)) > 0.01 || mean(frame(:)) < -0.01
%   disp('failed to normalize');
% end;
  Stim.frames{1}{i} = frame * Csquash; % contrast squashing
end;

%for i = 1:SS.nImages
%  Stim.frames{1}{i} = double(Stim.frames{1}{i});
%end;

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

Pars = [300, 5500, -300, 700];
SS = stimMovieIC(myScreenInfo, Pars);
%SS.Show(myScreenInfo)
Play(SS, myScreenInfo);

