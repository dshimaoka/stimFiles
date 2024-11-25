function SS = stimCorrectedKalatsky3(myScreenInfo,Pars)
% stimKalatsky makes color flickering bars moving periodically in the x/y direction
%
% SS = stimKalatsky(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimKalatsky(myScreenInfo) uses the default parameters
%
% 2012-06 AP

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',        50,1,600};
pp{2}  = {'bdur',	'blank duration of each sweep (ms)',        50,1,600};
pp{3}  = {'start',	'Stimulus start (deg)',      -0,0,180};
pp{4}  = {'end',	'Stimulus end (deg)',        -0,0,180};
pp{5}  = {'tf',     'Temporal frequency (Hz *100)',     40,1,400};
pp{6}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{7}  = {'dir',    'Direction of movement',                1,-1,1};
pp{8} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{9}  = {'flickfreq',    'Temporal frequency of flicker (Hz *10)',   40,0,400};
pp{10}  = {'maxL',    'Maximum luminance (%)',          100,0,100};
pp{11}  = {'meanL',	'Mean luminance (%)',    50,0,100};
pp{12}  = {'ori',   'Orientation (xpos = 1;ypos = 2)',   1,1,2};
pp{13} = {'lumFactor',   'Luminance Correction factor (0(nothing)-10(full correction))',  0,0,1};
pp{14} = {'phi0',   'Origin of azimuth for isoradius/polar stim (deg))',  -0,-180,180};
pp{15} = {'theta0',   'Origin of altitude for isoradius/polar stim (deg))',  -0,-90,90};

x = XFile('stimCorrectedKalatsky3',pp);
% x.Write; % call this ONCE: it writes the .x file

%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

dur         = Pars(1)/10; % s, durations
bdur         = Pars(2)/1000; % s, durations
start_point = Pars(3); %deg, where the cycle start
end_point   = Pars(4); %deg ,where the cycle end
tfreq	 	= Pars(5)/100;              % Hz
sfreq  		= Pars(6)/100;             % cpd
direction 	= Pars(7);                 % deg
cyN     = Pars(8);
tfreq_flicker = Pars(9)/10; %Hz
cc 	= Pars(10)/100;         % between 0 and 1
mm 	= Pars(11)/100;     % between 0 and 1
if Pars(12)==1,
    xpos = 1; ypos = 0; eccentricity = 0; polar = 0;
elseif Pars(12)==2
    xpos = 0; ypos = 1; eccentricity = 0; polar = 0;
elseif Pars(12)==3
    xpos = 0; ypos = 0; eccentricity = 1; polar = 0;
elseif Pars(12)==4
    xpos = 0; ypos = 0; eccentricity = 0; polar = 1;
end
lumCorrectFactor = Pars(13)/10;
if lumCorrectFactor > 0
    correctLuminance = 1;
else
    correctLuminance = 0;
end
phi0 = Pars(14) * pi/180; %[rad]
theta0 = Pars(15) * pi/180; %[rad]

%% Make the stimulus

SS = ScreenStim; % initialization
SS.Type = x.Name;
SS.Parameters = Pars;
SS.nTextures = 1;
SS.nFrames = ceil(myScreenInfo.FrameRate*dur);
SS.Orientations = zeros([1,SS.nFrames]);
SS.Amplitudes = ones(1,SS.nFrames)/2;

%wid = myScreenInfo.Deg2Pix(cyN/sfreq);
Lx = myScreenInfo.Xmax;
Ly = myScreenInfo.Ymax;
L = abs(end_point-start_point);%[deg]
SS.MinusOneToOne = 0;

%CyclesPerPix = cyN/wid; % sf in cycles/pix

% Translate requested speed of the grating (in cycles per second)
% into a shift value in "pixels per frame".

T = 1/tfreq;
nFramesPerSweep = round(myScreenInfo.FrameRate * T);
nStimFramesPerSweep = round(myScreenInfo.FrameRate * (T-bdur));
%NOTE: as a result of rounding, actual temporal frequency may differ from tfreq

%shiftperframe = direction*L*tfreq/myScreenInfo.FrameRate; %[pix]
shiftperframe = direction*L/(nStimFramesPerSweep-1); %[deg]

%p0 = direction*L*temporalphase/360;


offset_angle = []; 
for iframe = 1 : nFramesPerSweep
    offset_angle(iframe) =  pi/180*(start_point + (iframe-1)*shiftperframe);%[rad]
    %image actually starts at start_point and ends at end_point.
    
    SS.SourceRects(:,1,iframe) = [1; 1; Lx; Ly];%[1; 1;  wid; len];
    SS.DestRects(:,1,iframe)  = [0; 0; Lx; Ly];%[offset; 0; offset+wid; len];
end

%copy the first sweep
for iframe = nFramesPerSweep+1:SS.nFrames
    offset_angle(iframe) = offset_angle(mod(iframe-1, nFramesPerSweep)+1);
    SS.SourceRects(:,1,iframe) = [1; 1; Lx; Ly];%[1; 1;  wid; len];
    SS.DestRects(:,1,iframe)  = [0; 0; Lx; Ly];%[offset; 0; offset+wid; len];
end

%position on screen in pixels
pixx = 1:myScreenInfo.Xmax; %pixels
pixy = 1:myScreenInfo.Ymax;

%position on screen in cm
posx = myScreenInfo.PixelSize*(pixx - mean(pixx));%cm
posy = myScreenInfo.PixelSize*(myScreenInfo.Ymax - pixy) - 11.5;%cm ...should be able to modify center position from outside
[POSX, POSY] = meshgrid(posx, posy);

%spherical coordinate in radian
[PHI, THETA] = box2sphere(myScreenInfo.Dist, POSX, POSY);

if eccentricity || polar
    dPHI = PHI-phi0;
    dPHI(dPHI > pi/2) = pi - dPHI(dPHI > pi/2);
    dPHI(dPHI < -pi/2) = -pi - dPHI(dPHI < -pi/2);
    
    ETA = atan2(tan(dPHI), tan(THETA) - tan(theta0)/cos(theta0));
    RHO = atan2(cos(theta0)*tan(abs(dPHI)), abs(sin(ETA)));
    lateral_pix = (abs(PHI-phi0) > pi/2);
    RHO(lateral_pix) = pi - RHO(lateral_pix);
    
    %adjust min and max of ETA (to specify angle range) ... not enough?
    max_etaangle = max(offset_angle(1:nStimFramesPerSweep)) + cyN/sfreq/180*pi/2;
    min_etaangle = min(offset_angle(1:nStimFramesPerSweep)) - cyN/sfreq/180*pi/2;
    %limit_etaangle = angle(exp(1i*max_etaangle) + exp(1i*min_etaangle));
    
    ETA = mod(ETA,2*pi);
    ETA(ETA>max_etaangle) = ETA(ETA>max_etaangle) - 2*pi;
    ETA(ETA<min_etaangle) = ETA(ETA<min_etaangle) + 2*pi;
    ETA(ETA>min_etaangle+2*pi) = ETA(ETA>min_etaangle+2*pi) - 2*pi;
    ETA(ETA<max_etaangle-2*pi) = ETA(ETA<max_etaangle-2*pi) + 2*pi;
     
    %for debugging
    % subplot(211)
    % imagesc(posx,posy,ETA);axis equal tight xy;
    % hold on
    % rectangle('position',[posx(1280), posy(end), myScreenInfo.PixelSize*myScreenInfo.Xmax/3,myScreenInfo.PixelSize*myScreenInfo.Ymax],'edgecolor','w')
    % mcolorbar;
    % subplot(212)
    % imagesc(posx,posy,RHO);axis equal tight xy;
    % hold on
    % rectangle('position',[posx(1280), posy(end), myScreenInfo.PixelSize*myScreenInfo.Xmax/3,myScreenInfo.PixelSize*myScreenInfo.Ymax],'edgecolor','w')
    % mcolorbar;
end

if correctLuminance
    %effective luminance of screen.
    load('\\zserver\Lab\Share\Shimaoka\vertData.mat','degs','monDataNorm');%iiyamaE1980 NS 12/1/15
    degs_v = degs;
    monDataNorm_v = monDataNorm;
    
    load('\\zserver\Lab\Share\Shimaoka\horizData.mat','degs','monDataNorm');%iiyamaE1980 NS 12/1/15
    degs_h = degs;
    monDataNorm_h = monDataNorm;
    
    cycle = pi/2;%rad
    PHI_effective = pi/4*(2*(PHI/cycle-floor(PHI/cycle+0.5)));
    
    eLum = interp1(degs_h,monDataNorm_h, PHI_effective*180/pi,'pchip','extrap') .* ...
        interp1(degs_v,monDataNorm_v, THETA*180/pi,'pchip','extrap');
    
    invELum = 1./(eLum).^lumCorrectFactor;
    normInvELum = invELum./max(invELum(:));
end


SS.nImages = nFramesPerSweep;%2;

value_cache = zeros(size(PHI,1)*size(PHI,2), nFramesPerSweep);
for iframe = 1:nFramesPerSweep
    angleLimit = [offset_angle(iframe)-cyN/sfreq/180*pi/2 offset_angle(iframe)+cyN/180*pi/sfreq/2]; %[rad]
    
    %% single white stripe
    if ypos
        ind1 = find(THETA > angleLimit(1));
        ind2 = find(THETA < angleLimit(2));
    elseif xpos
        ind1 = find(PHI > angleLimit(1));
        ind2 = find(PHI < angleLimit(2));
    elseif eccentricity
        ind1 = find(RHO > angleLimit(1));
        ind2 = find(RHO < angleLimit(2));
    elseif polar
        ind1 = find( ETA > angleLimit(1));
        ind2 = find( ETA < angleLimit(2));     
    end
    ind = intersect_sorted(ind1,ind2);%fast. applicable only to sorted idx
    %ind = intersect(ind1,ind2);%slow
    value_cache(ind, iframe) = 1;
    
    %% checker board ... disabled
%     if ypos
%         cache_v = 2*(ceil(1+0.99*sin(2*pi*sfreq*180/pi*(PHI - 0)))-1.5);%vertical grating
%         cache_h = 2*(ceil(1+0.99*sin(2*pi*sfreq*180/pi*(THETA - offset_angle(iframe))))-1.5);%horizontal grating
%     elseif xpos
%         cache_v = 2*(ceil(1+0.99*sin(2*pi*sfreq*180/pi*(PHI - offset_angle(iframe))))-1.5);%vertical grating
%         cache_h = 2*(ceil(1+0.99*sin(2*pi*sfreq*180/pi*(THETA)))-1.5);%horizontal grating
%     else
        cache_v = 1;
        cache_h = 1;
%     end
  
    value_cache(:,iframe) = value_cache(:,iframe).*cache_v(:).*cache_h(:);

    bgIdx = (value_cache(:,iframe) == 0);
    value_cache(:,iframe) = 255*cc*value_cache(:,iframe);
    value_cache(bgIdx,iframe) = 255*mm;
    
    if iframe > nStimFramesPerSweep
        value_cache(:,iframe) = 255*mm;
    end

    if correctLuminance
        %correct gray lavel
        value_cache(:,iframe) = value_cache(:,iframe) .* normInvELum(:);
        
        %correct black and white
        %value_cache(:,iframe) = value_cache(:,iframe).*normInvELum(:);
        
        %correct only white
        %         whitePixIdx = find(value_cache(:,iframe) > 0);
        %         value_cache(whitePixIdx,iframe) = value_cache(whitePixIdx,iframe).*normInvELum(whitePixIdx);
    end
end
value = reshape(value_cache, size(PHI,1), size(PHI,2), nFramesPerSweep); %[-1 1]

value = uint8(value);  

ImageTextures = cell(nFramesPerSweep,1);
%Factor = [1 -1];
for iImage = 1:SS.nImages
    if xpos
        ImageTextures{iImage} = zeros(Ly,Lx,3);
    elseif ypos
        ImageTextures{iImage} = zeros(Ly,Lx,3);
    end
    for igun = 1:3
        ImageTextures{iImage}(:,:,igun) = ...
            value(:,:,iImage);
        %uint8(255*mm*(1+cc*value));
    end
end

SS.BackgroundColor = round(255*mm);
SS.BackgroundPersists = true;

if (SS.nImages)*tfreq_flicker>myScreenInfo.FrameRate,
        SS.ImageSequence = mod(0:SS.nFrames-1,SS.nImages)+1;
else
    if tfreq_flicker>0, %not yet. for intrinsic imaging
        nFramesPerFlickerCycle = (SS.nImages)*round(myScreenInfo.FrameRate/((SS.nImages)*tfreq_flicker));
        nCycles = floor(SS.nFrames/nFramesPerFlickerCycle);
    else % "fast kalatsky"
         nFramesPerFlickerCycle = SS.nImages;
         nCycles = 0;
    end
    for i=1:(SS.nImages)
        ind_seq = (1:nFramesPerFlickerCycle/(SS.nImages));
        singlecycle_sequence(ind_seq+(i-1)*nFramesPerFlickerCycle/(SS.nImages)) = i*ones(1,nFramesPerFlickerCycle/(SS.nImages));
    end
    if nCycles>0
        SS.ImageSequence = repmat(singlecycle_sequence,[1 nCycles]);
        SS.ImageSequence(nCycles*nFramesPerFlickerCycle+1:SS.nFrames)=SS.ImageSequence(1:SS.nFrames-(nCycles*nFramesPerFlickerCycle));
    else
        %         SS.ImageSequence = singlecycle_sequence(1:SS.nFrames);
        %        SS.ImageSequence = ones(1,SS.nFrames);
        SS.ImageSequence = mod(0:SS.nFrames-1,SS.nImages)+1;
    end
end


%% put the images in video RAM

SS = SS.LoadImageTextures( myScreenInfo, ImageTextures );
return

%% To test the code

myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimKalatsky_xpos'); %#ok<UNRCH>
myScreenStim2.Show(myScreenInfo)
myScreenStim2.ShowTextures


end

function [PHI, THETA] = box2sphere(x,Y,Z)
% convert cartesian coordinates in box configuration, to spherical
% coordinates.
%
% assumption:
% three screens, left and right is placed perpendicular to the central
% screen
% distance between animal and central screen is identical to distance between
% animal and side screens
%
% input:
% x (scalar): distance from screen
% Y (matrix): horizontal position on screen
% Z (matrix): vertical position on screen
% Y and Zshould be same size
% (Y,Z) = (0, 0) is defined as line perpendicular to the central
% screen that intersected with the center of the mouse's eye
%
% output:
% PHI (matrix): azimuth from mouse
% THETA (matrix): altitude from mouse
% PHI and THETA will be same size as Y and Z
% (PHI, THETA) = (0, 0) is defined as line perpendicular to the central
% screen that intersected with the center of the mouse's eye


[innerSub] = (abs(Y) < x);
[outerSub_pos] = (Y >= x);
[outerSub_neg] = (Y <= -x);


% if abs(Y) <= x
PHI(innerSub) = atan(Y(innerSub)./x);
THETA(innerSub) = pi/2 - acos(Z(innerSub)./sqrt(x.^2 + Y(innerSub).^2 + Z(innerSub).^2));
% elseif Y > x
PHI(outerSub_pos) = pi/2 - atan((2*x - Y(outerSub_pos))./x);
THETA(outerSub_pos) = pi/2 - acos(Z(outerSub_pos)./sqrt(x.^2 + (2*x - Y(outerSub_pos)).^2 + Z(outerSub_pos).^2));
% elseif Y < -x
PHI(outerSub_neg) = -pi/2 + atan((2*x + Y(outerSub_neg))./x);
THETA(outerSub_neg) = pi/2 - acos(Z(outerSub_neg)./sqrt(x.^2 + (2*x + Y(outerSub_neg)).^2 + Z(outerSub_neg).^2));
% end

%% convert index to sub
idx = 1:size(Y,1)*size(Y,2);
[sub_i, sub_j] = ind2sub(size(Y), idx);
PHI_cache = zeros(size(Y,1), size(Y,2));
THETA_cache = zeros(size(Y,1), size(Y,2));
for jjj = 1:length(idx);
    PHI_cache(sub_i(jjj), sub_j(jjj)) = PHI(idx(jjj));
    THETA_cache(sub_i(jjj), sub_j(jjj)) = THETA(idx(jjj));
end

PHI = PHI_cache;
THETA = THETA_cache;

% % another implementation ... faster but may not always work?
% PHI = reshape(PHI, size(Y,1), size(Y,2));
% THETA = reshape(THETA, size(Y,1), size(Y,2));
end

function c = intersect_sorted(a,b)
% from http://stackoverflow.com/questions/8159449/a-faster-way-to-achieve-what-intersect-is-giving-me

  ia = 1;
  na = length(a);
  ib = 1;
  nb = length(b);
  ic = 0;
  cn = min(na,nb);
  c = zeros(1,cn);

  while (ia <= na && ib <= nb)
    if (a(ia) > b(ib))
      ib = ib + 1;
    elseif a(ia) < b(ib)
      ia = ia + 1;
    else % a(ia) == b(ib)
      ic = ic + 1;
      c(ic) = a(ia);
      ib = ib + 1;
      ia = ia + 1;
    end
  end
  c = c(1:ic);
end
