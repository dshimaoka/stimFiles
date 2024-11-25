function Stim = vXYCMseqGratSplit(pars,myscreen)global patchmsq;% ------ parse the parsxpars.dur 	 = pars(1)/10;  % = dur; % Stim. duration.xpars.sf 	 = pars(2)/100;  % = sf100; % Spatial frequency.xpars.ori 	 = pars(3)* pi/180; % = ori; % Stim. orientation .xpars.sph    = pars(4)* pi/180; % phasexpars.x		 = ceil(ltdeg2pix(pars(5)/10,myscreen)); % Center x (deg/10).xpars.y		 = ceil(ltdeg2pix(pars(6)/10,myscreen)); % Center y (deg/10).xpars.sqsz	 = ceil(ltdeg2pix(pars(7)/10,myscreen)); % the size (deg/10) of a single squarexpars.nsqx   = pars(8); %the number of squares along the x dimensionxpars.nsqy   = pars(9); %the number of squares along the y dimensionxpars.nfrms  = pars(10); %the number of frames for which the stimulus is constantxpars.seed   = pars(11); %which m-sequence to usexpars.cent   = pars(12); %just show the center or all of the squares.xpars.c		 = pars(13); %contrast of the patchesxpars.nsplit = pars(14); %the number of splits that there will be (must be an even number)xpars.isplit = pars(15); %which of the splits you want to show (must be <= nsplits)xpars.order  = pars(16); %The order of the m-sequence (as in 2.^order-1)%-------------BEGIN ERROR CHECKINGif (mod(xpars.nsplit,2) ~= 0)    warning(sprintf('The parameter nsplit must be even'));    Stim.frames{1}{1}(:,:) = ones(xpars.nsqy.*xpars.sqsz,xpars.nsqx.*xpars.sqsz);    Stim.luts{1} = 128.*ones(256,3);    Stim.sequence.frames = 1;    Stim.sequence.luts 	 = 1;	%------- define position rect	xsize = size(Stim.frames{1}{1},2);	ysize = size(Stim.frames{1}{1},1);	x1 = (round(myscreen.Xmax/2) - round(xpars.nsqx.*xpars.sqsz/2));	y1 = (round(myscreen.Ymax/2) - round(xpars.nsqy.*xpars.sqsz/2));	x2 = x1+xsize;	y2 = y1+ysize;	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],xpars.x,xpars.y);    Stim = ltMakeOffScreenWindows(myscreen,Stim,1);    Stim.nperiods = 1;	returnendif (xpars.isplit > xpars.nsplit)    warning(sprintf('The parameter isplit exceeds nsplit, which is bad'));    Stim.frames{1}{1}(:,:) = ones(xpars.nsqy.*xpars.sqsz,xpars.nsqx.*xpars.sqsz);    Stim.luts{1} = 128.*ones(256,3);    Stim.sequence.frames = 1;    Stim.sequence.luts 	 = 1;	%------- define position rect	xsize = size(Stim.frames{1}{1},2);	ysize = size(Stim.frames{1}{1},1);	x1 = (round(myscreen.Xmax/2) - round(xpars.nsqx.*xpars.sqsz/2));	y1 = (round(myscreen.Ymax/2) - round(xpars.nsqy.*xpars.sqsz/2));	x2 = x1+xsize;	y2 = y1+ysize;	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],xpars.x,xpars.y);    Stim = ltMakeOffScreenWindows(myscreen,Stim,1);    Stim.nperiods = 1;	returnendnframestoshow = ceil((2.^xpars.order-1)./(xpars.nsplit./2)).*xpars.nfrms;  %this takes into account the number of splits.nframestoshowit = round(myscreen.FrameRate * xpars.dur);if (nframestoshow > nframestoshowit)    warning(sprintf('Your duration is too short for the appropriate m-sequence. You need a duration of about %.2f seconds',nframestoshow./myscreen.FrameRate));    Stim.frames{1}{1}(:,:) = ones(xpars.nsqy.*xpars.sqsz,xpars.nsqx.*xpars.sqsz);    Stim.luts{1} = 128.*ones(256,3);    Stim.sequence.frames = 1;    Stim.sequence.luts 	 = 1;	%------- define position rect	xsize = size(Stim.frames{1}{1},2);	ysize = size(Stim.frames{1}{1},1);	x1 = (round(myscreen.Xmax/2) - round(xpars.nsqx.*xpars.sqsz/2));	y1 = (round(myscreen.Ymax/2) - round(xpars.nsqy.*xpars.sqsz/2));	x2 = x1+xsize;	y2 = y1+ysize;	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],xpars.x,xpars.y);    Stim = ltMakeOffScreenWindows(myscreen,Stim,1);    Stim.nperiods = 1;	returnendif (xpars.nsqx.*xpars.nsqy > 125)    warning('There are too many squares for the LUT.  The product of nsqx and nsqy must be <= 125');    Stim.frames{1}{1}(:,:) = ones(xpars.nsqy.*xpars.sqsz,xpars.nsqx.*xpars.sqsz);    Stim.luts{1} = 128.*ones(256,3);    Stim.sequence.frames = 1;    Stim.sequence.luts 	 = 1;	%------- define position rect	xsize = size(Stim.frames{1}{1},2);	ysize = size(Stim.frames{1}{1},1);	x1 = (round(myscreen.Xmax/2) - round(xpars.nsqx.*xpars.sqsz/2));	y1 = (round(myscreen.Ymax/2) - round(xpars.nsqy.*xpars.sqsz/2));	x2 = x1+xsize;	y2 = y1+ysize;	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],xpars.x,xpars.y);    Stim = ltMakeOffScreenWindows(myscreen,Stim,1);    Stim.nperiods = 1;	returnendif (rem(xpars.nsqx,2)==0 |rem(xpars.nsqy,2)==0)    warning('You have an even number of squares on the x and/or y dimension.  They must be odd.');    Stim.frames{1}{1}(:,:) = ones(xpars.nsqy.*xpars.sqsz,xpars.nsqx.*xpars.sqsz);    Stim.luts{1} = 128.*ones(256,3);    Stim.sequence.frames = 1;    Stim.sequence.luts 	 = 1;	%------- define position rect	xsize = size(Stim.frames{1}{1},2);	ysize = size(Stim.frames{1}{1},1);	x1 = (round(myscreen.Xmax/2) - round(xpars.nsqx.*xpars.sqsz/2));	y1 = (round(myscreen.Ymax/2) - round(xpars.nsqy.*xpars.sqsz/2));	x2 = x1+xsize;	y2 = y1+ysize;	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],xpars.x,xpars.y);    Stim = ltMakeOffScreenWindows(myscreen,Stim,1);    Stim.nperiods = 1;	returnendif (nframestoshowit > 1.5.*nframestoshow)    warning(sprintf('The duration is more than 50 percent longer than is necessary. A duration of about %.2f seconds is close.',nframestoshow./myscreen.FrameRate));    Stim.frames{1}{1}(:,:) = ones(xpars.nsqy.*xpars.sqsz,xpars.nsqx.*xpars.sqsz);    Stim.luts{1} = 128.*ones(256,3);    Stim.sequence.frames = 1;    Stim.sequence.luts 	 = 1;	%------- define position rect	xsize = size(Stim.frames{1}{1},2);	ysize = size(Stim.frames{1}{1},1);	x1 = (round(myscreen.Xmax/2) - round(xpars.nsqx.*xpars.sqsz/2));	y1 = (round(myscreen.Ymax/2) - round(xpars.nsqy.*xpars.sqsz/2));	x2 = x1+xsize;	y2 = y1+ysize;	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],xpars.x,xpars.y);    Stim = ltMakeOffScreenWindows(myscreen,Stim,1);    Stim.nperiods = 1;	returnend%-------------BEGIN ERROR CHECKING% ------ convert them into relevant fields in SinParsSinPars.width 			 = xpars.sqsz.*xpars.nsqx; SinPars.height			 = xpars.sqsz.*xpars.nsqy;SinPars.Contrast		 = 1;SinPars.Orientation 	 = xpars.ori;	% radiansSinPars.SpatialFrequency = xpars.sf;	% Cycles/degreeSinPars.phase			 = xpars.sph;	% 0 is cosine phase, must be RADIANS% ------ other pars to be keptctr.x = xpars.x;ctr.y = xpars.y;nx = SinPars.width;ny = SinPars.height;centonly = xpars.cent;%--Make the Square Field--------------------------------------------------- square = zeros(SinPars.height,SinPars.width);Wave = zeros(SinPars.height,SinPars.width);xstep = xpars.sqsz;ystep = xpars.sqsz;icount = 2;%reserve the first 3for ipatchx = 1:xpars.nsqx    for ipatchy = 1:xpars.nsqy        icount = icount + 1;        startx = (ipatchx-1).*xstep+1; endx = min(startx-1+xstep,SinPars.width);            starty = (ipatchy-1).*ystep+1; endy = min(starty-1+ystep,SinPars.height);        square(starty:endy,startx:endx) = icount;    endend%--Make the Square Wave-----------------------------------------------------DegPerCycle = 1/SinPars.SpatialFrequency;PixPerCycle = ltdeg2pix(DegPerCycle,myscreen);cyclesperpix = 1/PixPerCycle; % sf in cycles/pix[xx,yy]=meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);Wave = sign(cos(2*pi*cyclesperpix*(cos(SinPars.Orientation).*xx+sin(SinPars.Orientation).*yy ) +SinPars.phase));Wave = (Wave + 1)./2;Stim.frames{1}{1} = (2.*square-3)+Wave;%Stim= ltMakeOffScreenWindows(myscreen,Stim,1);%--Make the LUTs------------------------------------------------------------nblankframes = nframestoshowit-nframestoshow;  %the number of initial blank framesnuniqueframes = ceil((2^xpars.order-1)./(xpars.nsplit./2));ms = mseq(2,xpars.order,0,xpars.seed);stepsize = 2^xpars.order./xpars.nsplit;startindex = stepsize.*(xpars.isplit-1);Cluts = 128.*ones(nuniqueframes+1,256,3);nCluts = nuniqueframes+1;Cluts(1,:,:) = 128.*ones(256,3);Cluts(1,2,:) = 255.*ones(1,3);Cluts(1,3,:) = zeros(1,3);interval = round(2.^xpars.order./(xpars.nsqx.*xpars.nsqy));upperlum = 128 + round(127.*xpars.c./100);lowerlum = 128 - round(128.*xpars.c./100);for il = 2:nCluts    Cluts(il,1,:) = [128 128 128];    Cluts(il,2,:) = [255 255 255];    Cluts(il,3,:) = [0 0 0];    for jl = 1:xpars.nsqx.*xpars.nsqy        kl = 2.*(jl-1) + 1;        indx = (il-1)+interval.*jl+startindex;		showit = (centonly == 0 | jl == round(xpars.nsqx.*xpars.nsqy./2));%        if indx>length(ms),indx = rem(indx,length(ms))+1;end %wrap around% NOTE: TQD changed this line to: (the indx-1 is there because when% everything wraps around, without the -1, the sequence skips an element)        if indx>length(ms),indx = rem(indx-1,length(ms))+1;end %wrap around        if (ms(indx) == 0 & showit)            Cluts(il,kl+3,:) = [lowerlum lowerlum lowerlum];            Cluts(il,kl+4,:) = [upperlum upperlum upperlum];          elseif (ms(indx) == 1 & showit)            Cluts(il,kl+3,:) = [upperlum upperlum upperlum];            Cluts(il,kl+4,:) = [lowerlum lowerlum lowerlum];		else 			Cluts(il,kl+3,:) = [128 128 128];            Cluts(il,kl+4,:) = [128 128 128];        end        patchmsq(il,jl) = ms(indx);    endendStim.luts = cell(nCluts,1); % allocationfor ii = 1:nCluts	Stim.luts{ii} = squeeze(Cluts(ii,:,:)); % why???end%Stim.luts = Cluts;Stim.sequence.frames = ones(1,nframestoshowit);Stim.sequence.luts 	 = [ones(1,nblankframes),lincopy(nuniqueframes,nframestoshow)+1]; %puts blank frames at beginning%Stim.sequence.luts   = [lincopy(nuniqueframes,nframestoshow)+1,ones(1,nblankframes)]; %puts blank frames at the end;% ------ that's it, no more use for xparsclear xpars%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Stim = ltMakeOffScreenWindows(myscreen,Stim,1);%------- define position rectxsize = size(Stim.frames{1}{1},2);ysize = size(Stim.frames{1}{1},1);x1 = (round(myscreen.Xmax/2) - round(SinPars.width/2));y1 = (round(myscreen.Ymax/2) - round(SinPars.height/2));x2 = x1+xsize;y2 = y1+ysize;Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],ctr.x,ctr.y);if (x1+ctr.x<0 | x2+ctr.x>myscreen.Xmax | y1+ctr.y<0 | y2+ctr.y>myscreen.Ymax)    warning('Stimulus is offscreen');end    Stim.nperiods = 1;return%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function out = lincopy(A,B)%makes an array with length(B) of 1:A with an approximately equal number of%elements 1:A, thus out = lincopy(5,10) = [1 1 2 2 3 3 4 4 5 5]if B<A    error('The second argument must be greater than or equal to the first, dude')endnsteps = round(B./A);out = ones(1,B);for il = 1:A    start = (il-1).*nsteps+1;    enddd = start+nsteps-1;    out(start:enddd) = il;endout = out(1:B);return%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------------------------------------To test itglobal DIRSDIRS.data = 'Z:\trodes'myscreen = ScreenLogLoad('catz059',5,8); % a plausible screen structuredur = 62;sf100 = 40;ori = 90;sph = 0;x = 0;y = 0;sqsz = 75;nsquaresx = 3;nsquaresy = 5;nfrms = 3;seed = 1;centeronly = 0;c = 100;nsplit = 4;isplit = 3;myscreen.PixelSize = 0.0609;        %centimetersmyscreen.Dist = 40;                 %centimetersmyscreen.FrameRate = 124.85;pars = [dur sf100 ori sph x y sqsz nsquaresx nsquaresy nfrms seed centeronly c nsplit isplit];Stim = vXYCMseqGratSplit(pars,myscreen);vv = vsGetStimulusFrame(Stim,myscreen,30);imshow(vv);