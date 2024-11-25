function [ stim, NoisePars ] =  visringnsfnori(pars,myscreen,flag);
% visringnsfnori
%
% stim =  visringnsfnori(pars,myscreen);
%
% code for visringnsfnori.x (nori, nsf, 4 phases, a blank, no adaptor)
%
% stim =  visringnsfnori(pars,myscreen,'analysis') can be run without the PsychToolbox, to analyze the data.
% (it does need ltdeg2pix though)
%
% 2000-04 MC
% 2000-06 MC corrected phase bug, added flag
% 2001-08 VM from visringach
% 2001-09-28 VM corrected orientation bug and nsf = 1 bug


if nargin<3
   flag = '';
end

% ------ parse the pars (excuse the pun)
xpars.dur 	= pars(1)/10; % duration.
xpars.x		= ceil(ltdeg2pix(pars(3)/10,myscreen)); % Centre x (deg/10).
xpars.y		= ceil(ltdeg2pix(pars(4)/10,myscreen)); % Centre y (deg/10).
xpars.diam	= ceil(ltdeg2pix(pars(5)/10,myscreen)); % diameter (deg/10).
seed	= pars(6);
nori	= ceil(pars(7));
nsf	= ceil(pars(8));
sfmin = pars(9)/10;
sfmax = pars(10)/10;
nfr	= ceil(pars(11));

SinPars = [];
%SinPars.Frequency 	= 1./ltdeg2pix(10/pars(2),myscreen); % sf in cycles/pix
SinPars.Contrast 	= pars(2)/100; %  contrast. 

% ------ and into the relevant fields of MoviePars
MoviePars.nx = xpars.diam; 
MoviePars.ny = xpars.diam;
MoviePars.nframes = round(myscreen.FrameRate * xpars.dur); % frames/sec * sec 

% ------ other xpars to be kept
diam = xpars.diam; 
ctr.x = xpars.x;
ctr.y = xpars.y;

% ------ that's it, no more use for xpars
clear xpars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear stim
nphase = 4;

diffori = (0:pi:pi*(nori - 1))/nori;
diffphases = (0:2*pi:2*pi*(nphase - 1))/nphase;
if nsf > 1
   diffsf = sfmin:(sfmax-sfmin)/(nsf-1):sfmax;
else
   diffsf = sfmin;
end
%diffsf = unique(round(diffsf*10)/10);

% ---- make a grid of x and y
x = 1-MoviePars.nx/2:MoviePars.nx/2;
y = 1-MoviePars.ny/2:MoviePars.ny/2;
[xx,yy]=meshgrid(x,y);
window = ( xx.^2+yy.^2 < diam^2/4 ); % circular window

% make the movie ------------------------------------------
mymovie = cell(nori*nphase*nsf+1,1);

iframe = 0;
for isf = 1:nsf
   SinPars.Frequency 	= 1./ltdeg2pix(1/diffsf(isf),myscreen); % sf in cycles/pix
   for iori = 1:nori
      for iphase = 1:nphase
         iframe = iframe+1;
         thisori = diffori(iori);
         thisphase = diffphases(iphase);
         % the minus sign below is for consistency with the orientation of other stimuli
         angfreq = 2*pi*SinPars.Frequency*(-cos(thisori).*xx-sin(thisori).*yy );
         movieimage = SinPars.Contrast * sin(thisphase+angfreq);
         mymovie{iframe} = uint8(round((movieimage.*window+1)*126 + 3)); 
         % and at this point movieimage goes bet 3 and 255
      end
   end
end
% the blank frame
iframe = iframe+1;
mymovie{iframe} = uint8(round((0*movieimage.*window+1)*126 + 3)); 

stim.frames{1} = mymovie;

if ~strcmp(flag,'analysis')
   stim = ltMakeOffScreenWindows(myscreen,stim,1);
end

% define the look-up tables for this stimulus
linClut = [ [128 128 128]; [255 255 255]; [  1   1   1]; round(linspace(1,255,253))'*[1 1 1] ];
stim.luts{1} = linClut;
stim.sequence.luts = ones(1,MoviePars.nframes);

% coordinates of center of stimulus with respect to the top left of the screen
x = ctr.x + myscreen.Xmax/2;
y = ctr.y + myscreen.Ymax/2;

% coordinates of top left of stimulus with respect to the top left of the screen
x = x - round(MoviePars.nx/2);
y = y - round(MoviePars.ny/2);

stim.position(1,:) = [x,y,x+MoviePars.nx,y+MoviePars.ny];

% define the RANDOM SEQUENCE FOR THE FRAMES 
rand('seed',seed); % sets the seed, and selects the Matlab 4 rand num generator
ntests = nori*nphase*nsf + 1;
frameseq = ceil(rand(1,MoviePars.nframes)*ntests);

% interpolate these frames 
frameindex = floor(1:1/nfr:MoviePars.nframes);
stim.sequence.frames = frameseq(frameindex(1:MoviePars.nframes));

% define the number of times you want to see the movie		
stim.nperiods = 1;

%------------------- ADDED 2004-11: The info structure --------------------

iframe = 0;
for isf = 1:nsf
    for iori = 1:nori
        for iph = 1:nphase
            iframe = iframe+1;
            NoisePars.ori(iframe) = diffori(iori)/pi*180;
            NoisePars.sf(iframe) = diffsf(isf); % SF in cpd
            NoisePars.phase(iframe) = diffphases(iph)/pi*180;
        end
    end
end
% then, the blank
NoisePars.ori(iframe+1) = NaN;
NoisePars.sf(iframe+1) = NaN;
NoisePars.phase(iframe+1) = NaN;

return

%----------------------------------------------------------

% Some stuff to test the code
pars(1)	= 1200; %dur
pars(2)	= 50; %c
pars(3)	= 0; %x
pars(4)	= 0; %y
pars(5)	= 100; %diam
pars(6)	= 1; %seed
pars(7)	= 4; %nori
pars(8)	= 4; %nsf
pars(9)	= 1; %sfmin
pars(10)	= 16; %sfmax
pars(11)	= 2; %efr

myscreen.FrameRate = 124.8926;
myscreen.PixelSize = 0.0609;
myscreen.Dist = 57;
myscreen.Xmax = 640;
myscreen.Ymax = 480;

flag = 'analysis';

sumall = double(mymovie{1});
for iframe = 2:length(mymovie)
   sumall = sumall + double(mymovie{iframe});
end

nframes = length(stim.frames{1});
howmany = [];
for iframe = 1:nframes
   howmany(iframe) = sum(stim.sequence.frames == iframe);
end




