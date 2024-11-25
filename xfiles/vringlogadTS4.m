function [Stim, NoisePars] = vringlogadTS4(pars,myscreen)% vringlogad%% Stim =  vringlogad(pars,myscreen);%% Parameters are :% [dur c x y diam nori orimin orimax nsf sfmin sfmax sflog nphase seed nfr]%% 2000-04 MC% 2000-06 MC corrected phase bug, added flag% 2001-08 VM from visringach% 2001-09-28 VM corrected orientation bug and nsf = 1 bug% 2002-02 MC copied from visringnsfnori, changed sf from cpd*10 to cpd*100% 2002-07 VM from visringnsfnori100% 2003-07 VB corrected rounding bug that caused stimulus size mismatched frame size% 2004-11 MC added adaptation condition% 2004-12 RF corrected bug on line 161 (changed "and" to "any")% 2008-02 LB corrected bug on line 217 which hardcoded 4 spatial phases%               instead of using p.nphase% 2009-11 ND added test of non-zero adapter contrast when computing the aprob see line 165% 2011-08 TS this function only works with vs Stimbox version. Global%                        totalpresentationnum is includedglobal tsnum %TS versionglobal tsstimnum%------ parse the parametersp.dur 		= pars(1)/10; % duration.p.c			= pars(2)/100; % contrastp.x			= ceil(ltdeg2pix(pars(3)/10,myscreen)); % Center x (deg/10).p.y			= ceil(ltdeg2pix(pars(4)/10,myscreen)); % Center y (deg/10).p.diam		= ceil(ltdeg2pix(pars(5)/10,myscreen)); % diameter (deg/10).p.nori		= pars(6); % number of orientationsp.orimin	= pars(7)*pi/180; % the 'smallest' orientationp.orimax	= pars(8)*pi/180; % the 'largest' orientationp.nsf		= pars(9); % number of spatial frequenciesp.sfmin		= pars(10)/100; % the smallest spatial frequencyp.sfmax		= pars(11)/100; % the largest spatial frequencyp.sflog		= pars(12); % sfs log-spaced if 1, lin-spaced otherwisep.nphase	= pars(13); % the number of spatial frequenciesp.seed		= pars(14); % the seed of random number generatorp.nfr		= pars(15); % the number of interpolated framesp.aori		= pars(16)*pi/180; % the orientation of the adaptorp.asf		= pars(17)/100; % the spatial frequency of the adaptorp.ac		= pars(18)/100; % the contrast of the adaptorp.aprob		= pars(19)/100; % the probability of the adaptor%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% p.nfr=p.nfr+mod(ceil(tsnum/tsstimnum),5);% introduce jitter 20120918if isempty(p.nfr)   error('empty nfr') else    disp(['nfr....',num2str(p.nfr)]);end% The radius of the stimulip.outerRad = round(p.diam/2);% Make a grid of x and ynx = 2*p.outerRad;ny = 2*p.outerRad;[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);%%window = ( xx.^2+yy.^2 < p.diam^2/4 ); % circular window%window = ( (xx+nx/2).^2+yy.^2 < p.diam^2/4*4).*( (xx-nx/2).^2+yy.^2 < p.diam^2/4*4 );% temporarily TS 20110813  %window = xx.^2+yy.^2 >-1;window = 1;% Compute the orientations of the stimuliif p.nori < 2	diffori = p.orimin;	p.nori = 1;elseif p.orimin == p.orimax	dori = pi/p.nori;else	oridist = angle(exp(i*(p.orimax-p.orimin)));	% There is no motion, oris is bet 0 and pi	if oridist < 0;		dori = pi/p.nori;	else		% This makes sure that the first and last oris are not too similar		dori = oridist/(p.nori-1);		if pi-(p.nori-1)*dori < dori			dori = pi/p.nori;		end	endenddiffori = zeros(1,p.nori);diffori(1) = p.orimin;for iori = 2:p.nori	diffori(iori) = diffori(iori-1) + dori;enddiffori = mod(diffori,2*pi);% Compute the spatial frequencies of the stimuliif p.nsf > 1	if p.sflog == 1		diffsf = logspace(log10(p.sfmin),log10(p.sfmax),p.nsf);	else		diffsf = linspace(p.sfmin,p.sfmax,p.nsf);		p.nsf = 1;	endelse	diffsf = p.sfmin;end% Compute the phases of the stimuliif p.nphase > 1	diffph = (0:2*pi:2*pi*(p.nphase - 1))/p.nphase;else	diffph = 0;	p.nphase = 1;end% MAKE ALL THE FRAMESmymovie = cell(p.nori*p.nphase*p.nsf,1);iframe = 0;for isf = 1:p.nsf	thissf = 1./ltdeg2pix(1/diffsf(isf),myscreen); % sf in cycles/pix	for iori = 1:p.nori		for iph = 1:p.nphase			iframe = iframe+1;			thisori = diffori(iori);			thisphase = diffph(iph);			% the minus sign below is for consistency with the orientation of other stimuli			angfreq = -2*pi*thissf*( cos(thisori).*xx + sin(thisori).*yy );			movieimage = p.c * sin( thisphase + angfreq );			mymovie{iframe} = uint8(round(( movieimage.*window + 1 )*126 + 3)); 			% and at this point movieimage goes bet 3 and 255		end	endendif p.aprob > 0	% the adaptor frames	for iph = 1:p.nphase		iframe = iframe+1;		thisphase = diffph(iph);		thisori = p.aori;		thissf = 1./ltdeg2pix(1/p.asf,myscreen); % sf in cycles/pix		% the minus sign below is for consistency with the orientation of other stimuli		angfreq = -2*pi*thissf*( cos(thisori).*xx + sin(thisori).*yy );		movieimage = p.ac * sin( thisphase + angfreq );		mymovie{iframe} = uint8(round(( movieimage.*window + 1 )*126 + 3));        %mymovie{iframe} = uint8(round(( movieimage.*window + 1 )*126 + 3));		% and at this point movieimage goes bet 3 and 255	end	end% That's it for the framesStim.frames{1} = mymovie;Stim = ltMakeOffScreenWindows(myscreen,Stim,1);% MAKE ALL THE LUTS%linClut = [ [128 128 128]; [255 255 255]; [ 0 0 0]; round(linspace(0,255,253))'*[1 1 1] ];linClut = [ [128 128 128]; [255 255 255]; [ 0 0 0]; (linspace(1,253,253))'*[1 1 1] ];% 20110813 TSStim.luts{1} = linClut;% The number of frames in the entire stimulusnframes = ceil(p.dur * myscreen.FrameRate);Stim.sequence.luts = ones(1,nframes);% The position of the stimulusx1 = round(myscreen.Xmax/2) - round(p.diam/2);y1 = round(myscreen.Ymax/2) - round(p.diam/2);x2 = round(myscreen.Xmax/2) + round(p.diam/2);y2 = round(myscreen.Ymax/2) + round(p.diam/2);	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],p.x,p.y);% DEFINE THE RANDOM SEQUENCE OF THE FRAMES% Set the seed, and select the Matlab 4 rand num generatorif p.seed    seed=p.seed;else    seed = ceil(tsnum/tsstimnum) ;    disp(['seed = ', num2str(seed)])    disp(['tsnum= ', num2str(tsnum)])endrand('seed',seed)% The number of images that contain a gratingngrat = p.nori*p.nphase*p.nsf;% The sequence of framesframeseq = min(ngrat ,ceil(rand(1,nframes)*ngrat));% frameseq(1:5)=[2 4 3 1 3];FirstFrameArray=[2,4];newSeq=[ones(1,4)*FirstFrameArray(mod(seed,2)+1) ...    ones(1,2)*1 ...    ones(1,4)*3]frameseq(1:length(newSeq))=newSeq;if p.aprob>0		if any(diffori == p.aori) && any(diffsf == p.asf) && (p.ac~=0)		% the adaptor is one of the stimuli		padapt = p.nphase/ngrat;	else		padapt = 0;	end	if p.aprob < padapt 		fprintf(1, 'Warning, cannot do a probability that is < %1.2d\n', padapt);	else		pa = (p.aprob - padapt) / (1 - padapt);		% the idea is that p.aprob = pa + (1-pa)*padapt		% where		% p.aprob is the desired probability of the stimulus		% padapt is the probabilit of the stimulus within the test sequence		% pa is the probability of setting a stimulus to the adapt stimulus.		adaptframes = find(rand(1,nframes)<=pa);		adaptseq = ngrat + ceil(rand(1,nframes)*p.nphase);		if ~isempty(adaptframes)			frameseq(adaptframes) = adaptseq(adaptframes);		end	endend% Interpolate these frames frameindex = floor(1:1/p.nfr:nframes);Stim.sequence.frames = frameseq(frameindex(1:nframes));% The number of times you want to see the movie		Stim.nperiods = 1;%------------------- ADDED 2004-11: The info structure --------------------iframe = 0;for isf = 1:p.nsf    for iori = 1:p.nori        for iph = 1:p.nphase            iframe = iframe+1;            NoisePars.ori(iframe) = diffori(iori)/pi*180;            NoisePars.sf(iframe) = diffsf(isf); % SF in cpd            NoisePars.phase(iframe) = diffph(iph)/pi*180;        end    endendNoisePars.c = p.c*ones(1,p.nsf*p.nori*p.nphase);% then, the adaptorif p.aprob > 0    for iph = 1:p.nphase        iframe = iframe+1;        NoisePars.ori(iframe)   = p.aori/pi*180;        NoisePars.sf(iframe)	= p.asf; % sf in CPD        NoisePars.phase(iframe) = diffph(iph)/pi*180;    end	    NoisePars.c(end+[1:p.nphase]) = p.ac*ones(1,p.nphase);endreturn%-------------------------------------------------------------% Code to test the function% The screen%myscreen = vsMakeMyscreen;myscreen = ltScreenInitialize(1);		myscreen.Dist = 57;ltLoadCalibration(myscreen,3);% The parametersdur 		= 100; % sec*10c			= 50; % contrast in %x			= 45; % Centre x (deg/10).y			= -39; % Centre y (deg/10).diam		= 100; % diameter (deg/10).nori		= 4; % number of orientationsorimin		= 0; % the 'smallest' orientationorimax		= 180; % the 'largest' orientationnsf			= 1; % number of spatial frequenciessfmin		= 50; % the smallest spatial frequencysfmax		= 50; % the largest spatial frequencysflog		= 1; % sfs log-spaced if 1, lin-spaced otherwisenphase		= 4; % the number of spatial frequenciesseed		= 1; % the seed of random number generatornfr			= 1; % the number of interpolated framesaori		= 15;asf			= 50;ac			= 50;aprob 		= 75;pars = [dur c x y diam nori orimin orimax nsf sfmin sfmax sflog nphase seed nfr aori asf ac aprob];Stim = vringlogad(pars,myscreen);vsPlayStimulus(myscreen,Stim,'norush');ltClearStimulus(Stim,'nowarnings');% Let's see whether this is what it is supposed to be% The sequence of imagesnimg = length(Stim.frames{1});figure;[yy, xx] = hist(Stim.sequence.frames,1:nimg);bar(xx, yy/length(Stim.sequence.frames) )% The sum over all imagessumall = zeros(size(Stim.frames{1}{1}));for iframe = 1:nimg	sumall = sumall + double(Stim.frames{1}{iframe});endsumall = uint8(sumall/nimg);figure;imagesc(sumall);colormap gray; colorbar;% Look at individual framesfigure;iframe = 1;for iframe = 1:length(Stim.frames{1})	subplot(6,6,iframe);	imagesc(Stim.frames{1}{iframe});	colormap gray;	axis equal	set(gca,'xtick',[],'ytick',[])end%% To test it using more modern code%% TO TEST IT:myscreen = ltScreenInitialize(2); myscreen.Dist = 24;ltLoadCalibration(myscreen);% The parametersdur 		= 20; % sec*10c			= 100; % contrast in %x			= 300; % Centre x (deg/10).y			= 0; % Centre y (deg/10).diam		= 715; % diameter (deg/10).nori		= 4; % number of orientationsorimin		= 0; % the 'smallest' orientationorimax		= 180; % the 'largest' orientationnsf			= 1; % number of spatial frequenciessfmin		= 3; % the smallest spatial frequencysfmax		= 3; % the largest spatial frequencysflog		= 1; % sfs log-spaced if 1, lin-spaced otherwisenphase		= 2; % the number of spatial frequenciesseed		= 1; % the seed of random number generatornfr			= 27; % the number of interpolated framesaori		= 15;asf			= 50;ac			= 50;aprob 		= 0;pars = [dur c x y diam nori orimin orimax nsf sfmin sfmax sflog nphase seed nfr aori asf ac aprob];Stim = oglStimMake('vringlogad',pars, myscreen);oglStimPlay(myscreen,Stim);ltClearLoadedTextures;ltClearStimulus(Stim,'nowarnings');Screen('CloseAll');