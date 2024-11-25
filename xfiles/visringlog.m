function Stim = visringlog(pars,myscreen);
% visringlog
%
% Stim =  visringlog(pars,myscreen);
%
% Parameters are :
% [dur c x y diam nori orimin orimax nsf sfmin sfmax sflog nphase rblank seed nfr]
%
% 2000-04 MC
% 2000-06 MC corrected phase bug, added flag
% 2001-08 VM from visringach
% 2001-09-28 VM corrected orientation bug and nsf = 1 bug
% 2002-02 MC copied from visringnsfnori, changed sf from cpd*10 to cpd*100
% 2002-07 VM from visringnsfnori100

disp('Warning: This XFILE has the size bug! use vringlog instead');

% ------ parse the pars (excuse the pun)
p.dur 	= pars(1)/10; % duration.
p.c		= pars(2)/100; % contrast
p.x		= ceil(ltdeg2pix(pars(3)/10,myscreen)); % Centre x (deg/10).
p.y		= ceil(ltdeg2pix(pars(4)/10,myscreen)); % Centre y (deg/10).
p.diam	= ceil(ltdeg2pix(pars(5)/10,myscreen)); % diameter (deg/10).
p.nori	= pars(6); % number of orientations
p.orimin	= pars(7)*pi/180; % the 'smallest' orientation
p.orimax	= pars(8)*pi/180; % the 'largest' orientation
p.nsf		= pars(9); % number of spatial frequencies
p.sfmin	= pars(10)/100; % the smallest spatial frequency
p.sfmax	= pars(11)/100; % the largest spatial frequency
p.sflog	= pars(12); % sfs log-spaced if 1, lin-spaced otherwise
p.nphase	= pars(13); % the number of spatial frequencies
p.rblank	= pars(14)/100; % the proportion of blank frames
p.seed	= pars(15); % the seed of random number generator
p.nfr		= pars(16); % the number of interpolated frames

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The radius of the stimuli
p.outerRad = round(p.diam/2);

% Make a grid of x and y
nx = 2*p.outerRad;
ny = 2*p.outerRad;
[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);
window = ( xx.^2+yy.^2 < p.diam^2/4 ); % circular window

% Compute the orientations of the stimuli
if p.nori < 2
   diffori = p.orimin;
   p.nori = 1;
elseif p.orimin == p.orimax
   dori = pi/p.nori;
else
   oridist = angle(exp(i*(p.orimax-p.orimin)));
   % There is no motion, oris is bet 0 and pi
   if oridist < 0;
      dori = pi/p.nori;
   else
      % This makes sure that the first and last oris are not too similar
      dori = oridist/(p.nori-1);
      if pi-(p.nori-1)*dori < dori
         dori = pi/p.nori;
      end
   end
end
diffori = zeros(1,p.nori);
diffori(1) = p.orimin;
for iori = 2:p.nori
   diffori(iori) = diffori(iori-1) + dori;
end
diffori = mod(diffori,2*pi);

% Compute the spatial frequencies of the stimuli
if p.nsf > 1
   if p.sflog == 1
      diffsf = logspace(log10(p.sfmin),log10(p.sfmax),p.nsf);
   else
      diffsf = linspace(p.sfmin,p.sfmax,p.nsf);
      p.nsf = 1;
   end
else
   diffsf = p.sfmin;
end

% Compute the phases of the stimuli
if p.nphase > 1
   diffph = (0:2*pi:2*pi*(p.nphase - 1))/p.nphase;
else
   diffph = 0;
   p.nphase = 1;
end


% MAKE ALL THE FRAMES
mymovie = cell(p.nori*p.nphase*p.nsf + 1,1);

iframe = 0;
for isf = 1:p.nsf
 thissf = 1./ltdeg2pix(1/diffsf(isf),myscreen); % sf in cycles/pix
   for iori = 1:p.nori
      for iph = 1:p.nphase
         iframe = iframe+1;
         thisori = diffori(iori);
         thisphase = diffph(iph);
         % the minus sign below is for consistency with the orientation of other stimuli
         angfreq = -2*pi*thissf*( cos(thisori).*xx + sin(thisori).*yy );
         movieimage = p.c * sin( thisphase + angfreq );
         mymovie{iframe} = uint8(round(( movieimage.*window + 1 )*126 + 3)); 
         % and at this point movieimage goes bet 3 and 255
      end
   end
end
% the blank frame
iframe = iframe+1;
mymovie{iframe} = uint8(round(( 0*movieimage + 1 )*126 + 3)); 

% That's it for the frames
Stim.frames{1} = mymovie;
Stim = ltMakeOffScreenWindows(myscreen,Stim,1);


% MAKE ALL THE LUTS
linClut = [ [128 128 128]; [255 255 255]; [ 0 0 0]; round(linspace(0,255,253))'*[1 1 1] ];
Stim.luts{1} = linClut;
% The number of frames in the entire stimulus
nframes = ceil(p.dur * myscreen.FrameRate);
Stim.sequence.luts = ones(1,nframes);

% The position of the stimulus
x1 = round(myscreen.Xmax/2 - p.diam/2);
y1 = round(myscreen.Ymax/2 - p.diam/2);
x2 = round(myscreen.Xmax/2 + p.diam/2);
y2 = round(myscreen.Ymax/2 + p.diam/2);	
Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],p.x,p.y);


% DEFINE THE RANDOM SEQUENCE OF THE FRAMES
% Set the seed, and select the Matlab 4 rand num generator
rand('seed',p.seed);

% The number of images that contain a grating
ngrat = p.nori*p.nphase*p.nsf;

% The number of images that should contain a blank
if p.rblank == 0
   nblank = 1;
else
   nblank = ceil(ngrat*p.rblank);
end

% The sequence of frames
frameseq = min(ngrat+1,ceil(rand(1,nframes)*(ngrat+nblank)));

% Interpolate these frames 
frameindex = floor(1:1/p.nfr:nframes);
Stim.sequence.frames = frameseq(frameindex(1:nframes));

% The number of times you want to see the movie		
Stim.nperiods = 1;

return


% Code to test the function

% The screen
%myscreen = vsMakeMyscreen;
myscreen = ltScreenInitialize(1);		
myscreen.Dist = 57;
ltLoadCalibration(myscreen,3);

% The parameters
dur 		= 500; % sec*10
c			= 50; % contrast in %
x			= 45; % Centre x (deg/10).
y			= -39; % Centre y (deg/10).
diam		= 100; % diameter (deg/10).
nori		= 1; % number of orientations
orimin	= 0; % the 'smallest' orientation
orimax	= 0; % the 'largest' orientation
nsf		= 1; % number of spatial frequencies
sfmin		= 20; % the smallest spatial frequency
sfmax		= 160; % the largest spatial frequency
sflog		= 1; % sfs log-spaced if 1, lin-spaced otherwise
nphase	= 1; % the number of spatial frequencies
rblank	= 50; % the proportion of blank frames
seed		= 1; % the seed of random number generator
nfr		= 1; % the number of interpolated frames
pars = [dur c x y diam nori orimin orimax nsf sfmin sfmax sflog nphase rblank seed nfr];

Stim = visringlog([dur c x y diam nori orimin orimax nsf sfmin sfmax sflog nphase rblank seed nfr],myscreen);

vsPlayStimulus(myscreen,Stim,'norush');

ltClearStimulus(Stim,'nowarnings');


% Let's see whether this is what it is supposed to be
% The sequence of images
nimg = length(Stim.frames{1});
figure;
hist(Stim.sequence.frames,1:nimg);

% The sum over all images
sumall = zeros(size(Stim.frames{1}{1}));
for iframe = 1:nimg
   sumall = sumall + double(Stim.frames{1}{iframe});
end
sumall = uint8(sumall/nimg);
figure;
imagesc(sumall);
colormap gray; colorbar;

% Look at individual frames
figure;
iframe = 1;
for iframe = 1:36
   subplot(6,6,iframe);
   imagesc(Stim.frames{1}{iframe});
   colormap gray;
end



