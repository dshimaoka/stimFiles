function Stim = vmovieGrating(pars,myscreen)% vmovie3sequentialGrating code for vmovie3sequentialGrating.x% % Stim =  vmovie3sequentialGrating(pars,myscreen)%% [  dur swT1 swT2 ...%    dima dimb x y flick sqwv shape ...%    tf1 sf1 tph1 sph1 c1 ori1 ...%    tf2 sf2 tph2 sph2 c2 ori2 ...]%    tf3 sf3 tph3 sph3 c3 ori3 ]%% sqwv = 1 for square waves, 0 for sin waves% shape determines whether the window is an annulus (shape = 0) or a rectangle (shape = 1)% dima and dimb are inner and outer diameter (for annuli) or dimensions x and y (for rectangles)%% 2010-10 MC + TS extended vmovie2sequentialGrating to 3 gratings...% 2013-07 DS added flick=2 option (spatio-temporally square wave)% 2014-08 DS found bug in temporal phase when tf = 1 and 35, but not when% tf=40%% Read the parameters% Durationdur         = pars(1)/10; %= dur; % trial durationswitchTime1 = pars(2)/10; % time stimulus switches ONswitchTime2 = pars(3)/10; % time stimulus switches OFFdima		= ceil (ltdeg2pix(pars(4)/10,myscreen)); % inner diameter (deg/10).dimb		= floor(ltdeg2pix(pars(5)/10,myscreen)); % outer diameter (deg/10).xc	 		= ltdeg2pix(pars(6)/10,myscreen); % Centre x (deg/10).yc		 	= ltdeg2pix(pars(7)/10,myscreen); % Centre y (deg/10).flicker 	= pars(8);sqwv 		= pars(9);shape  		= pars(10); % 0 = circle; 1 = rect    sinpars = struct([]);ipar = 10;for igrat = 1%:3	sinpars(igrat).tfreq	 	= pars(ipar+1)/10; 	 	sinpars(igrat).sfreq  		= pars(ipar+2)/100; 			sinpars(igrat).tempphase  	= pars(ipar+3) * (pi/180); 			sinpars(igrat).spatphase  	= pars(ipar+4) * (pi/180); 			sinpars(igrat).contrast 	= pars(ipar+5)/100; 	sinpars(igrat).orientation 	= pars(ipar+6) * (pi/180); 	ipar = ipar + 6;end%% Prepare some variablesnframes    = round(myscreen.FrameRate * dur);frmSwitch1 = round(myscreen.FrameRate * switchTime1);frmSwitch2 = round(myscreen.FrameRate * switchTime2);% make sure the switch frames are reasonablefrmSwitch1 = max(frmSwitch1,1);frmSwitch2 = max(frmSwitch2,1);frmSwitch1 = min(frmSwitch1,nframes);frmSwitch2 = min(frmSwitch2,nframes);frmSwitch2 = max(frmSwitch2, frmSwitch1);%% Build the gratingsStim = cell(3,1);for igrat = 1%:3		% Spatial frequency in cycles/pixel	PixPerCycle = ltdeg2pix(1/sinpars(igrat).sfreq,myscreen);	sinpars(igrat).frequency = 1/PixPerCycle; % sf in cycles/pix		switch shape	case 0 		% it is an annulus		maxrad = max(1, dimb/2);		nx = ceil(2*maxrad);		ny = ceil(2*maxrad);		case 1		% it is a rectangle		nx = max(1,dima);		ny = max(1,dimb);	end		% Make a grid of x and y	[xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);		% The spatial phase of the stimulus	% the minus sign below is for consistency with the orientation of other stimuli	angfreq = -2*pi* sinpars(igrat).frequency * (...		cos(sinpars(igrat).orientation).*xx + ...		sin(sinpars(igrat).orientation).*yy ) + sinpars(igrat).spatphase;	% in radians		switch shape	case 0 		% an annular window		dd = sqrt(xx.^2+yy.^2);		win = double(dd >= dima/2 & dd <= dimb/2);	case 1		% no window is needed to make a rectangle		win = 1;	end		% The temporal phase of the response		period = round(myscreen.FrameRate / sinpars(igrat).tfreq);	tphase = 2*pi* (0:(period-1)) /period + sinpars(igrat).tempphase;	fprintf(1,'\nFrequency %d is %2.2f (requested: %2.1f Hz)\n', ...		igrat, myscreen.FrameRate/period , sinpars(igrat).tfreq );		    grat = cell(period,1);    	% Make movies	fprintf(1,' Frames for grating %d...', igrat);	if flicker >= 1        %temporally sin wave		contrast = sinpars(igrat).contrast * sin(tphase);                if flicker == 2 %temporally square wave            contrast = sinpars(igrat).contrast * square(tphase);        end                spatialstim = sin(angfreq);        spatialstim = sign(spatialstim).*abs(spatialstim);		if sqwv			spatialstim = (spatialstim>0.01)-(spatialstim<-0.01);		end		for iframe = 1:period			grat{iframe} = contrast(iframe) .* spatialstim .* win;		end				else		for iframe = 1:period			spatialstim = sin( angfreq + tphase(iframe));			spatialstim = sign(spatialstim).*abs(spatialstim);			if sqwv				spatialstim = (spatialstim>0.01)-(spatialstim<-0.01);			end				grat{iframe} = sinpars(igrat).contrast * spatialstim  .* win;		end	end	for iframe = 1:period		Stim{igrat}.frames{1}{iframe} = uint8( grat{iframe}*126 + 129 );         % for Stimulus toolbox the 129 should be 130	end		% Make the lookup table	Stim{igrat}.luts{1} = repmat([128 255 0 1:253]',1,3);		% Make sequence	Stim{igrat}.sequence.frames = 1+mod(1:nframes,period);    Stim{igrat}.sequence.luts = ones(1,nframes);			fprintf(1,'done\n');		% The position vector	x = round(xc + myscreen.Xmax/2 - nx/2);	y = round(yc + myscreen.Ymax/2 - ny/2);	Stim{igrat}.position(1,:) = [x y x+nx y+ny];	Stim{igrat}.nperiods = 1;	end%% Concatenate the three stimuliSingleStim = StimSwitch(Stim{1}   ,Stim{2},frmSwitch1);SingleStim = StimSwitch(SingleStim,Stim{3},frmSwitch2);Stim = SingleStim;%% all donereturn%% TO TEST IT:myscreen = ltScreenInitialize(2); %#ok<UNRCH>myscreen.Dist = 20;ltLoadCalibration(myscreen);dur = 35;swT1 = 10;swT2 = 25;dima = 500;dimb = 800;x = -100;y = 0;flick = 1;sqwv = 1;shape = 1;tf = [ 10 10 10 ];sf = [ 30 3 30 ];tph = [ 0 0 0 ];sph = [ 0 0 0 ];c = [0 0 0];ori = [90 0 45];pars = [  dur swT1 swT2 dima dimb x y flick sqwv shape...    tf(1) sf(1) tph(1) sph(1) c(1) ori(1) ...    tf(2) sf(2) tph(2) sph(2) c(2) ori(2) ...    tf(3) sf(3) tph(3) sph(3) c(3) ori(3) ];Stim = oglStimMake('vmovie3sequentialGrating',pars, myscreen);oglStimPlay(myscreen,Stim);ltClearLoadedTextures;ltClearStimulus(Stim,'nowarnings');Screen('CloseAll');