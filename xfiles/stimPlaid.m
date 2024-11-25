function SS = stimPlaid(myScreenInfo,Pars)
% stimPlaid makes a drifting plaid of 2 gratings at an angle
%
% SS = stimPlaid(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimPlaid(myScreenInfo) uses the default parameters
%
% 2016-05 LFR, based on stimColorGrating

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',    5,1,600};
pp{2}  = {'tf',     'Temporal frequency (Hz *10)',      40,1,400};
pp{3}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{4}  = {'tph',    'Temporal phase (deg)',             0,0,360};
pp{5}  = {'sph',    'Spatial phase (deg)',              0,0,360};
pp{6}  = {'ori',    'Orientation (deg)',                225,0,360};
pp{7}  = {'angle',    'Plaid angle (deg)',                120,0,360};
pp{8}  = {'diam',   'Diameter (deg*10)',                100,0,1200};
pp{9}  = {'xc',     'Center, x (deg*10)',               0,-900,900};
pp{10}  = {'yc',     'Center, y (deg*10)',               0,-900,900};
pp{11}  = {'co',    'Contrast of plaid (%)',          0,0,100};
% pp{12}  = {'cg',	'Contrast of green gun (%)',    0,0,100};
% pp{13}  = {'cb',	'Contrast of blue gun (%)',     100,0,100};
pp{12}  = {'lu',	'Mean luminance of background (%)',  50,0,100};
% pp{15}  = {'lg',    'Mean luminance of green gun (%)',  50,0,100};
% pp{16}  = {'lb',    'Mean luminance of blue gun (%)',   50,0,100};
x = XFile('stimPlaid',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end


dur         = Pars(1)/10; % s, duration
tfreq	 	= Pars(2)/10;              % Hz
sfreq  		= Pars(3)/100;             % cpd
tempphase  	= Pars(4) * (pi/180);      % radians
spatphase  	= Pars(5) * (pi/180);      % radians
orientation 	= Pars(6);                 % deg
angle        = Pars(7);                %deg 
diam = myScreenInfo.Deg2Pix( Pars(8)/10 );
[CtrCol,CtrRow] = myScreenInfo.Deg2PixCoord( Pars(9)/10, Pars(10)/10 );

cc 	= Pars(11)/100;         % between 0 and 1
mm 	= Pars(12)/100;     % between 0 and 1        

%% Make the stimulus

SS = ScreenStim; % initialization

SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur );
SS.Orientations = repmat(orientation,[1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2; 

myRectangle = round([CtrCol-diam/2 CtrRow-diam/2 CtrCol+diam/2 CtrRow+diam/2]');
SS.DestRects   = repmat(myRectangle,[1 1 SS.nFrames]);
SS.SourceRects = repmat([1; 1; diam; diam],[1 1 SS.nFrames]);
SS.MinusOneToOne = 0; 

CyclesPerPix = 1/myScreenInfo.Deg2Pix(1/sfreq); % sf in cycles/pix

% Make a grid of x and y
nx = diam;
ny = diam; % if you were willing to do without the window this could be one!
[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);
    
% Image of the spatial phase of the stimulus (in radians)
AngFreqs = -2*pi* CyclesPerPix * xx + spatphase;
    
WindowImage = double( sqrt(xx.^2+yy.^2)<=diam/2 );
 
SS.nImages = round(myScreenInfo.FrameRate / tfreq);

% The temporal phase of the response
TemporalPhase = 2*pi*(0:(SS.nImages-1))/SS.nImages + tempphase;
    
ActualFrequency = myScreenInfo.FrameRate/SS.nImages;
if abs(ActualFrequency/tfreq-1)>0.1
    fprintf(1,'Frequency %d is %2.2f rather than %2.0f Hz\n', ...
        igrat, ActualFrequency, tfreq);
end
    
ImageTextures = cell(SS.nImages,1);
for iImage = 1:SS.nImages
    ContrastImage = sin( AngFreqs + TemporalPhase(iImage));
    ImageTextures{iImage} = zeros(nx,ny);
%     PlaidImage = ContrastImage.*WindowImage;
    PlaidImage = ...
            (imrotate(ContrastImage, -angle/2 , 'crop') +...
            imrotate(ContrastImage, +angle/2 , 'crop'))/2;
    ImageTextures{iImage} = ...
            uint8(255*mm*(1+cc*PlaidImage.*WindowImage));
        
    %     ImageTextures{iImage} = zeros(nx,ny,3);
%     for igun = 1:3
%         ImageTextures{iImage}(:,:,igun) = ...
%             uint8(255*mm(igun)*(1+cc(igun)*ContrastImage.*WindowImage));
%     end
end

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

SS.ImageSequence = 1+mod(1:SS.nFrames,SS.nImages);

%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );

return

%% to test the function

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimPlaid'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures




