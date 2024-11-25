function Stim =  visdriftsin(pars,myscreen);% Stim =  visdriftsin(pars,myscreen);%% code for visdriftsin.x%% Stim = visdriftsin([dur tf sf c ori x y diam], myscreen)%% to see something reasonable, try with pars = [20 20 20 50 30 0 0 30]%% 2000-01 TCB and MC % 2000-04 MC cleaned up a lot. Now it returns Stim, and does not play it.% 2001-03 Added code at the end of the function for example of use% ------ parse the pars (excuse the pun)xpars.dur 	= pars(1)/10;  % = dur; % Stim. duration.xpars.tf	= pars(2)/10;  % = sf; % Temporal frequency.xpars.sf 	= pars(3)/10;  % = sf; % Spatial frequency.xpars.c 	= pars(4)/100; % = c; % Stim. constrast. xpars.ori 	= pars(5) * (pi/180); % = ori; % Stim. orientation .xpars.x		= ceil(ltdeg2pix(pars(6)/10,myscreen)); % Centre x (deg/10).xpars.y		= ceil(ltdeg2pix(pars(7)/10,myscreen)); % Centre y (deg/10).xpars.diam	= ceil(ltdeg2pix(pars(8)/10,myscreen)); % diameter (deg/10).% ------ convert them into relevant fields in SinParsSinPars.x 				 = xpars.diam; SinPars.y 				 = xpars.diam;SinPars.Contrast		 = xpars.c;SinPars.Orientation 	 = xpars.ori;	% radiansSinPars.SpatialFrequency = xpars.sf;	% Cycles/degreeSinPars.tFreq			 = xpars.tf;	% Hz % SinPars.outerRad 		 = round(xpars.diam/2); % pixels!% ------ other SinPars fields to be setSinPars.phase			 = 0;	% 0 is cosine phase, must be RADIANSSinPars.sqwv			 = 0;	% 0=sine, 1=squareSinPars.innerRad 		 = 0;	% pixels!% ------ other xpars to be keptctr.x = xpars.x;ctr.y = xpars.y;nframes = round(myscreen.FrameRate * xpars.dur);% ------ that's it, no more use for xparsclear xpars%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Stim.frames{1}{1} = ltMakeGratingFrame(SinPars,myscreen,'reserve3');Stim = ltMakeOffScreenWindows(myscreen,Stim,1);[Cluts, nCluts] = ltMakeGratingCluts(SinPars,myscreen,'reserve3');Stim.luts = cell(nCluts,1); % allocationfor ii = 1:nCluts	Stim.luts{ii} = squeeze(Cluts(ii,:,:)); % why???endStim.sequence.frames 	= ones(1,nframes); % this will stay like thatStim.sequence.luts 		= ones(1,nframes); % this will change, it is just an allocationfor ii = 0:nframes - 1	Stim.sequence.luts(ii+1) = mod(ii,nCluts) + 1;end%------- define position rectx1 = (round(myscreen.Xmax/2) - SinPars.x/2);y1 = (round(myscreen.Ymax/2) - SinPars.y/2);x2 = (round(myscreen.Xmax/2) + SinPars.x/2);y2 = (round(myscreen.Ymax/2) + SinPars.y/2);	Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],ctr.x,ctr.y);Stim.nperiods = 1;return%----------------------------------------------------------------------------% TO TEST IT:myscreen = ltScreenInitialize(1);		myscreen.Dist = 57;ltLoadCalibration(myscreen,3);dur = 100;tf = 1;sf = 2;c = 100;ori = 45;x = 0;y = 0;Stim1 = visdriftsin([dur tf sf c ori x y   8],myscreen);Stim2 = visdriftsin([dur tf sf c ori x y 130],myscreen);Stim3 = visdriftsin([dur tf sf c ori x y  50],myscreen); % should have one cycleStim4 = visdriftsin([dur tf sf c ori x y  75],myscreen); % should have two cyclesfigure(5); imagesc(Stim1.frames{1}{1},[0 255]); colormap grayfigure(6); imagesc(Stim2.frames{1}{1},[0 255]); colormap grayfigure(7); imagesc(Stim3.frames{1}{1},[0 255]); colormap grayfigure(8); imagesc(Stim4.frames{1}{1},[0 255]); colormap grayvsPlayStimulus(myscreen,Stim1,'norush');	vsPlayStimulus(myscreen,Stim1);	vsPlayStimulus(myscreen,Stim3);	vsPlayStimulus(myscreen,Stim4);	%ltClearStimulus(Stim1,'nowarnings'); ltClearStimulus(Stim2,'nowarnings'); ltClearStimulus(Stim3,'nowarnings'); ltClearStimulus(Stim4,'nowarnings'); SCREEN('CloseAll');	