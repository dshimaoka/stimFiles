function SS = stimDriftingClouds(myScreenInfo, Pars)
% One grating, drifting or flickering, in disks or annuli or rectangles
%
% SS = stimGratingWithMask(myScreenInfo, Pars)
%
% SS = stimGratingWithMask(myScreenInfo) uses the default parameters
%
% 2015-09 MP based on stimGratingWithMask.m. Added onset and offset times.

%% Basics
if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',      'Stimulus duration (s *10)',        90,1,600};
pp{2}  = {'ss',       'Spatial scale (half-width gauss) (sq*10)', 40,0,4000};
pp{3}  = {'ts',       'Temporal scale (half-width gauss) (fr*10)', 40,0,4000};
pp{4}  = {'diam',     'Diameter (deg*10)',                200,0,2700};
pp{5}  = {'xc',       'Center, x (deg*10)',               -100,-1400,1400};
pp{6}  = {'yc',       'Center, y (deg*10)',               0,-450,450};
pp{7} = {'tstart',   'Drifting start (s*10)',            30,1,600};
pp{8} = {'tstop',    'Drifting stop (s*10)',             60,1,600};
pp{9} = {'cr',       'Contrast of red gun (%)',          100,0,100};
pp{10} = {'cg',	      'Contrast of green gun (%)',        100,0,100};
pp{11} = {'cb',	      'Contrast of blue gun (%)',         100,0,100};
pp{12} = {'lr',	      'Mean luminance of red gun (%)',    50,0,100};
pp{13} = {'lg',       'Mean luminance of green gun (%)',  50,0,100};
pp{14} = {'lb',       'Mean luminance of blue gun (%)',   50,0,100};
pp{15}  = {'seed',    'Seed of random number generator',        1,1,100};
pp{16}  = {'dir', 'Direction of motion',        0,0,360};
pp{17}  = {'sp',     'Speed of motion (FOVs/s * 10)',        40,0,1000};


x = XFile('stimDriftingClouds', pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur         = Pars(1)/10;           % s
ss   	 	= Pars(2) /10;          % Hz
ts  		= Pars(3) /10;         % cpd
diamOut     = myScreenInfo.Deg2Pix( Pars(4) /10 );       % deg
[CtrCol(1), CtrRow(1)] = myScreenInfo.Deg2PixCoord(Pars(5)/10, Pars(6)/10);  % deg

tonset        = Pars(7)/10;             % in seconds
toffset       = Pars(8)/10;             % in seconds
ori           = Pars(16);             % in seconds
sp            = Pars(17)/10;             % in seconds

mm 	= [.5 .5 .5];

%% Make the stimulus
seed            = Pars(15);

rand('seed',seed); %#ok<RAND>

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = round( myScreenInfo.FrameRate*dur );

nFrames1 = round( myScreenInfo.FrameRate*tonset );
nFrames2 = round( myScreenInfo.FrameRate*toffset );

SS.Orientations = zeros([1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames); % global alpha value

% determine size of grating and mask (not size of presented part of
% gratings through mask)
nxGrating = diamOut;

%% Define Frames and FrameSequence for each component grating
    
nFOVs = 10*ceil(sp * toffset);
rands = randn(128*(1+nFOVs), 128*(1+nFOVs), 1);
rands = my_conv2(rands, ss, [1 2]);
rands = rands / std(rands(:));
rands = rands*128 * Pars(9)/100 + 128;
rands = uint8(rands);

SS.nImages      = 1;

% create textures
ImageTextures{1} = rands;



destRects = zeros(4, 1);
destRects(:,1) = round([CtrCol-nxGrating/2 CtrRow-nxGrating/2 ...
    CtrCol+nxGrating/2 CtrRow+nxGrating/2]');
SS.DestRects = repmat(destRects, [1 1 SS.nFrames]);
SS.SourceRects  = repmat([1; 1; 128; 128],[1 1 SS.nFrames]);

y0 = size(rands,1)/2;
x0 = size(rands,2)/2;

nn = linspace(nFOVs * 128, 0, nFrames2);
cx = x0 -cos(ori) * nn;
cy = y0 + sin(ori) * nn;

cx(nFrames2+1:SS.nFrames) = 0;
cy(nFrames2+1:SS.nFrames) = 0;

for i = 1:SS.nFrames
    SS.SourceRects(:,1,i) = round([cx(i)-64 cy(i)-64 cx(i)+64 cy(i)+64]'); 
end

SS.MinusOneToOne = false;
SS.UseAlpha = true;

SS.BackgroundColor                  = round(255 * mm);
SS.BackgroundPersists               = true;

SS.ImageSequence                    = ones(1,SS.nFrames); 

%% put the images in video RAM
SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

end

function S1 = my_conv2(S1, sig, varargin)
% takes an extra argument which specifies which dimension to filter on
% extra argument can be a vector with all dimensions that need to be
% smoothed, in which case sig can also be a vector of different smoothing
% constants

idims = 2;
if ~isempty(varargin)
    idims = varargin{1};
end
if numel(idims)>1 && numel(sig)>1
    sigall = sig;
else
    sigall = repmat(sig, numel(idims), 1);
end

for i = 1:length(idims)
    sig = sigall(i);
    
    idim = idims(i);
    Nd = ndims(S1);
    
    S1 = permute(S1, [idim 1:idim-1 idim+1:Nd]);
    
    dsnew = size(S1);
    
    S1 = reshape(S1, size(S1,1), []);
    dsnew2 = size(S1);
    
    % NN = size(S1,1);
    % NT = size(S1,2);
    
    dt = -4*sig:1:4*sig;
    gaus = exp( - dt.^2/(2*sig^2));
    gaus = gaus'/sum(gaus);
    
    % Norms = conv(ones(NT,1), gaus, 'same');
    % Smooth = zeros(NN, NT);
    % for n = 1:NN
    %    Smooth(n,:) = (conv(S1(n,:)', gaus, 'same')./Norms)';
    % end
    
    cNorm = filter(gaus, 1, cat(1, ones(dsnew2(1), 1), zeros(4*sig,1)));
    cNorm = cNorm(1+4*sig:end, :);
    S1 = filter(gaus, 1, cat(1, S1, zeros([4*sig, dsnew2(2)])));
    S1(1:4*sig, :) = [];
    S1 = reshape(S1, dsnew);
    
    S1 = bsxfun(@rdivide, S1, cNorm);
    
    S1 = permute(S1, [2:idim 1 idim+1:Nd]);
end
end
%% to test the function
% 
% RigInfo = RigInfoGet; %#ok<UNRCH>
% myScreenInfo = ScreenInfo(RigInfo);
% myScreenInfo = myScreenInfo.CalibrationLoad;
% 
% SS = stimGratingWithMask(myScreenInfo);
% show(SS, myScreenInfo);
% Screen('CloseAll');
% % Play(SS, myScreenInfo)