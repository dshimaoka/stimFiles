function Stim = vismeisteradapt(pars,myscreen)% vismeisteradapt stimuli of Smirnakis et al. 1997%%% Parameters are:% x% y% diam% intdur% nint% lmean1% lmean2% c1% c2% sf1% sf2% seed% jnpos% nfr% The parametersp.x      = ceil(ltdeg2pix(pars(1)/10,myscreen));p.y      = ceil(ltdeg2pix(pars(2)/10,myscreen));p.diam   = ceil(ltdeg2pix(pars(3)/10,myscreen));p.intdur = pars(4)/10;   p.nint   = pars(5);p.lmean1 = round(pars(6)/100*255);p.lmean2 = round(pars(7)/100*255);p.c1     = pars(8)/100;p.c2     = pars(9)/100;p.sf1    = pars(10)/100;p.sf2    = pars(11)/100;p.seed   = pars(12);p.jnpos  = pars(13);p.nfr    = pars(14);% The radius of the gratingp.rad = round(p.diam/2);% Make a grid of x and ynx = 2*p.rad;ny = 2*p.rad;xax = 1-nx/2:nx/2;yax = 1-ny/2:ny/2;[xx,yy] = meshgrid(xax,yax);% The points in the centerdd = sqrt(xx.^2+yy.^2);	% distance matrix% The point (ny/2,nx/2) corresponds to dd = 0, the center of the stimulusctrind = find( dd < p.rad );ctrpts = dd < p.rad;% Make the frames of the first epochif p.sf1 == 0;   Stim.frames{1}{1} = (ones(size(xx))*3).*ctrpts;   nef1 = 1;else   % Prepare stuff to make a checkerboard	DegPerCycle = 1/p.sf1;   % Make sure that there is an even number of pixels per cycle	PixPerCycle = max(2,ceil(ltdeg2pix(DegPerCycle,myscreen)/2)*2);      % A small phase shift, needed to make the ckeckerboard has the same   % number of white and black pixels   dph = pi/PixPerCycle/10;      % Make the indexes for the jittering   jnpos = min(p.jnpos,PixPerCycle/2);   jindex = round((0:jnpos-1)*PixPerCycle/jnpos);      % Make all the jittered frames   iframe = 0;   for ix = jindex      for iy = jindex         % Keep track of the frame         iframe = iframe+1;                  % The vertical and horizontal stripes         xcheck = sign(cos(2*pi/PixPerCycle*(xax + ix) - dph));         ycheck = sign(cos(2*pi/PixPerCycle*(yax + iy) - dph));                  % Make the checkerboard         [xxcheck,yycheck] = meshgrid(xcheck,ycheck);         checkboard = (xxcheck.*yycheck > 0) + 3;                  Stim.frames{1}{iframe} = checkboard.*ctrpts;      end   end   nef1 = iframe;end% Make the frames of the second epochif p.sf2 == 0;   Stim.frames{1}{nef1+1} = (ones(size(xx))*3).*ctrpts;   nef2 = 1;else   % Prepare stuff to make a checkerboard	DegPerCycle = 1/p.sf2;   % Make sure that there is an even number of pixels per cycle	PixPerCycle = max(2,ceil(ltdeg2pix(DegPerCycle,myscreen)/2)*2);      % A small phase shift, needed to make the ckeckerboard has the same   % number of white and black pixels   dph = pi/PixPerCycle/10;      % Make the indexes for the jittering   jnpos = min(p.jnpos,PixPerCycle/2);   jindex = round((0:jnpos-1)*PixPerCycle/jnpos);      % Make all the jittered frames   iframe = nef1;   for ix = jindex      for iy = jindex         % Keep track of the frame         iframe = iframe+1;                  % The vertical and horizontal stripes         xcheck = sign(cos(2*pi/PixPerCycle*(xax + ix) - dph));         ycheck = sign(cos(2*pi/PixPerCycle*(yax + iy) - dph));                  % Make the checkerboard         [xxcheck,yycheck] = meshgrid(xcheck,ycheck);         checkboard = (xxcheck.*yycheck > 0) + 3;                  Stim.frames{1}{iframe} = checkboard.*ctrpts;      end   end   nef2 = iframe - nef1;end% Make themStim = ltMakeOffScreenWindows(myscreen,Stim,1);% The number of frames in one epoch (half an interval)eframes = ceil(p.intdur*myscreen.FrameRate/p.nfr/2);% The total number of frames in the stimulusnframes = 2*eframes*p.nint*p.nfr;% Set the frame seed, and select the Matlab 4 rand num generatorrand('seed',p.seed);% The first entries of the lutnreslutentries = 3; reslutentries = [128 128 128; 255 255 255; 0 0 0];mylut = zeros(5,3);mylut(1:3,:) = reslutentries;% Make the luts for the first epochfor ilum = 0:255   Stim.luts{ilum + 1} = mylut;   Stim.luts{ilum + 1}(4,:) = ilum;   Stim.luts{ilum + 1}(5,:) = 2*p.lmean1 - ilum;endnel1 = 256;% Make the luts for the second epochfor ilum = 0:255   Stim.luts{ilum + nel1 + 1} = mylut;   Stim.luts{ilum + nel1 + 1}(4,:) = ilum;   Stim.luts{ilum + nel1 + 1}(5,:) = 2*p.lmean2 - ilum;endnel2 = 256;% Make the sequences for the entire stimuluslutseq = [];frameseq = [];% How to interleave framesframeindex = floor(0:1/p.nfr:eframes-1/p.nfr)+1;for iint = 1:p.nint   % THE LUTs   % The luminance for the first epoch (no interleaving)   goodlum = [];   while length(goodlum) < eframes      % Luminance values at each frame      lum = randn(1,eframes)*p.lmean1*p.c1 + p.lmean1;      if p.lmean1 < 128         goodindex = find(lum >= 0 & lum <= p.lmean1*2);      else         goodindex = find(lum >= p.lmean1*2-255 & lum <= 255);      end               % The corresponding lut      goodlum = [goodlum round(lum(goodindex))+1];   end   lutseq1 = goodlum(1:eframes);      % The luminance for the second epoch (no interleaving)   goodlum = [];   while length(goodlum) < eframes      % Luminance values at each frame      lum = randn(1,eframes)*p.lmean2*p.c2 + p.lmean2;      if p.lmean2 < 128         goodindex = find(lum >= 0 & lum <= p.lmean2*2);      else         goodindex = find(lum >= p.lmean2*2-255 & lum <= 255);      end      % The corresponding lut      goodlum = [goodlum round(lum(goodindex))+1];   end   lutseq2 = goodlum(1:eframes);      % The lut sequence for the entire interval   lutseq = [lutseq lutseq1(frameindex) lutseq2(frameindex)];      % THE FRAMES   % The sequence of frames for the first epoch (no interleaving)   frameseq1 = floor(rand(1,eframes)*nef1) + 1;    frameseq1(frameseq1 == nef1+1) = nef1;      % The sequence of frames for the second epoch (no interleaving)   frameseq2 = floor(rand(1,eframes)*nef2) + 1 + nef1;   frameseq2(frameseq2 == nef1+nef2+1) = nef1 + nef2;      % The sequence of frames for the entire interval   frameseqint = [frameseq1(frameindex) frameseq2(frameindex)];      % The framesequence for the entire interval   frameseq = [frameseq frameseqint];endStim.sequence.frames = frameseq;Stim.sequence.luts = lutseq;% The number of times you want to see the stimulusStim.nperiods = 1;% Coordinates of center of stimulus with respect to the top left of the screenxs = p.x + myscreen.Xmax/2;ys = p.y + myscreen.Ymax/2;% Coordinates of top left of stimulus with respect to the top left of the screenx = xs - round(nx/2);y = ys - round(ny/2);% The position vectorStim.position(1,:) = [ x, y, x+nx, y+ny ];return% Code to test the function% The screenmyscreen = defaultscreen;% The screenmyscreen = ltScreenInitialize(1);		myscreen.Dist = 57;ltLoadCalibration(myscreen,3);% The parametersx      = 0;y      = 0;diam   = 100;intdur = 100;   nint   = 2;lmean1 = 50;lmean2 = 80;c1     = 10;c2     = 10;sf1    = 0;sf2    = 0;seed   = 1;jnpos  = 10;nfr    = 1;pars = [x y diam intdur nint lmean1 lmean2 c1 c2 sf1 sf2 seed jnpos nfr];Stim = vismeisteradapt(pars,myscreen);vsPlayStimulus(myscreen,Stim,'norush');ltClearStimulus(Stim,'nowarnings');figure; subplot(2,1,1); plot(Stim.sequence.frames);subplot(2,1,2); plot(Stim.sequence.luts);