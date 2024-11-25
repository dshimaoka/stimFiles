function Stim =  visgratgrat(pars,myscreen);% Stim =  visgratgrat(pars,myscreen);%% code for gratgrat.x % (grating of gratings)%% 2002-02 MC%% parameters are :[ dur tf x y diam c e_sf e_ph e_ori c_sf100 c_ph c_ori ]%% SEE THE END OF THE FILE FOR CODE USED TO TEST THE FUNCTIONif isempty(pars)	pars = [20 30 0 0 100 50 10 45 90 50 0 180 ]endduration 	= pars(1)/10; % duration.tf 			= pars(2)/10; %  Temporal frequency.Envelope.x		= ceil(ltdeg2pix(pars(3)/10,myscreen)); % Centre x (deg*10).Envelope.y		= ceil(ltdeg2pix(pars(4)/10,myscreen)); % Centre y (deg*10).Envelope.npix 	= ceil(ltdeg2pix(pars(5)/10,myscreen)); % deg*10Envelope.Contrast	= pars( 6)/100; %  contrast. Envelope.SpatFreq 	= 1./ltdeg2pix(100/pars(7),myscreen); % sf in cycles/pixEnvelope.Phase		= pars(8)/180*pi;Envelope.Orientation = pars(9) * (pi/180); % orientation Carrier.SpatFreq 	= 1./ltdeg2pix(100/pars(10),myscreen); % sf in cycles/pixCarrier.Phase		= pars(11)/180*pi;Carrier.Orientation = pars(12) * (pi/180); % orientation % ------ nframes = round(myscreen.FrameRate /tf); % frames/sec * sec/cycle = frames/cyclenperiods = floor(duration*tf);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Stim = [];% ---- make a grid of x and y[xx,yy]=meshgrid(1-Envelope.npix/2:Envelope.npix/2,1-Envelope.npix/2:Envelope.npix/2); Carrier.angfreq = 2*pi* Carrier.SpatFreq*(-cos( Carrier.Orientation).*xx-sin( Carrier.Orientation).*yy );Envelope.angfreq = 2*pi*Envelope.SpatFreq*(-cos(Envelope.Orientation).*xx-sin(Envelope.Orientation).*yy );window = ( (xx.^2+yy.^2)<(Envelope.npix/2)^2 );Envelope.values = Envelope.Contrast*window.*(0.5+0.5*cos(Envelope.Phase+Envelope.angfreq));% figure; imagesc(Envelope.values); colormap gray; colorbar% make the movie movie = cell(nframes,1);for iframe=1:nframes	movieimage = Envelope.values.*sin( 2*pi*iframe/nframes + Carrier.Phase + Carrier.angfreq );	% figure; imagesc(movieimage); colormap gray; colorbar	% at this point movieimage goes bet -1 and 1	movie{iframe} = uint8(round((movieimage+1)*126 + 3)); 	% and at this point movieimage goes bet 3 and 255endStim.frames{1} = movie;Stim = ltMakeOffScreenWindows(myscreen,Stim,1);% define the look-up tables linClut = [ [128 128 128]; [255 255 255]; [  1   1   1]; round(linspace(1,255,253))'*[1 1 1] ];Stim.luts{1} = linClut;% coordinates of center of stimulus with respect to the top left of the screenx = Envelope.x + myscreen.Xmax/2;y = Envelope.y + myscreen.Ymax/2;% coordinates of top left of stimulus with respect to the top left of the screenx = x - round(Envelope.npix/2);y = y - round(Envelope.npix/2);Stim.position(1,:) = [x,y,x+Envelope.npix,y+Envelope.npix];% define the sequences for the frames and the lutsStim.sequence.frames = [1:nframes];Stim.sequence.luts = ones(1,nframes);% define the number of times you want to see the movie		Stim.nperiods = nperiods;return%----------------------------------------------------------------------------% TO TEST IT:myscreen = ltScreenInitialize(1);		myscreen.Dist = 65;ltLoadCalibration(myscreen,3);dur = 20;tf 	= 40;x	= 0;y	= 0;diam= 100;c 	= 100;e_sf100 = 25;e_ph = 45;e_ori = 90;c_sf100 = 100;c_ph = 0;c_ori = 45 ;ltClearStimulus(Stim,'nowarnings'); Stim = visgratgrat([ dur tf x y diam c e_sf100 e_ph e_ori c_sf100 c_ph c_ori ],myscreen);vsPlayStimulus(myscreen,Stim,'norush');	SCREEN('CloseAll');	