function Stim =  vdriftsin100rect(pars,myscreen)
% Stim =  visdriftsin100(pars,myscreen);
%
% code for visdriftsin100.x
% just like visdriftsin, but sf is in cpd*100 and allows for larger stimuli
%
% Stim = visdriftsin100([dur tf sf100 c ori x y diam], myscreen)
%
% to see something reasonable, try with pars = [20 20 100 50 30 0 0 30]
%
% 2000-01 TCB and MC 
% 2000-04 MC cleaned up a lot. Now it returns Stim, and does not play it.
% 2001-03 Added code at the end of the function for example of use
% 2002-01 MC created from visdriftsin
% 2003-07 VB corrected rounding bug that caused mismatched between frame size and stimulus size

% ------ parse the pars
xpars.dur 	= pars(1)/10;  % = dur; % Stim. duration.
xpars.tf	= pars(2)/10;  % = tf; % Temporal frequency.
xpars.sf 	= pars(3)/100;  % = sf100; % Spatial frequency.
xpars.c 	= pars(4)/100; % = c; % Stim. constrast. 
xpars.ori 	= pars(5)*(pi/180); % = ori; % Stim. orientation .

xpars.x		= ceil(ltdeg2pix(pars(6)/10,myscreen)); % Center x (deg/10).
xpars.y		= ceil(ltdeg2pix(pars(7)/10,myscreen)); % Center y (deg/10).
xpars.width	= ceil(ltdeg2pix(pars(8)/10,myscreen)); % diameter (deg/10).
xpars.height	= ceil(ltdeg2pix(pars(9)/10,myscreen)); % diameter (deg/10).

% ------ convert them into relevant fields in SinPars
SinPars.sizeX 			 = xpars.width; 
SinPars.sizeY			 = xpars.height;
SinPars.Contrast		 = xpars.c;
SinPars.Orientation 	 = xpars.ori;	% radians
SinPars.SpatialFrequency = xpars.sf;	% Cycles/degree
SinPars.tFreq			 = xpars.tf;	% Hz % 
%SinPars.outerRad 		 = round(xpars.diam/2); % pixels!
SinPars.width            = xpars.width;
SinPars.height           = xpars.height;

% ------ other SinPars fields to be set
SinPars.phase			 = 0;	% 0 is cosine phase, must be RADIANS
SinPars.sqwv			 = 0;	% 0=sine, 1=square
SinPars.innerRad 		 = 0;	% pixels!

% ------ other xpars to be kept
ctr.x = xpars.x;
ctr.y = xpars.y;

nframes = round(myscreen.FrameRate * xpars.dur);

% ------ that's it, no more use for xpars
clear xpars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Stim.frames{1}{1} = ltMakeGratingFrame(SinPars,myscreen,'reserve3');

Stim = ltMakeOffScreenWindows(myscreen,Stim,1);

[Cluts, nCluts] = ltMakeGratingCluts(SinPars,myscreen,'reserve3');

Stim.luts = cell(nCluts,1); % allocation
for ii = 1:nCluts
	Stim.luts{ii} = squeeze(Cluts(ii,:,:)); % why???
end

Stim.sequence.frames 	= ones(1,nframes); % this will stay like that
Stim.sequence.luts 		= ones(1,nframes); % this will change, it is just an allocation
for ii = 0:nframes - 1
	Stim.sequence.luts(ii+1) = mod(ii,nCluts) + 1;
end

%------- define position rect
x1 = (round(myscreen.Xmax/2) - round(SinPars.width/2));
y1 = (round(myscreen.Ymax/2) - round(SinPars.height/2));
x2 = (round(myscreen.Xmax/2) + round(SinPars.width/2));
y2 = (round(myscreen.Ymax/2) + round(SinPars.height/2));	
Stim.position(1,:) = OffsetRect([ x1 y1 x2 y2 ],ctr.x,ctr.y);

Stim.nperiods = 1;

return

%----------------------------------------------------------------------------
% TO TEST IT:

myscreen = ltScreenInitialize(1);		
myscreen.Dist = 57;

dur = 5;
tf = 1;
sf100 = 20;
c = 100;
ori = 45;
x = 100;
y = 0;

%Stim = visdriftsin100([dur tf sf100 c ori x y diam], myscreen)
Stim1 = vdriftsin100([dur tf sf100 c ori x y   8],myscreen);
Stim2 = vdriftsin100([dur tf sf100 c ori x y 130],myscreen);
Stim3 = vdriftsin100([dur tf sf100 c ori x y  50],myscreen); % should have one cycle
% in earlier versions following parameters caused 'frame size mismatch window sizes'
Stim4 = vdriftsin100([10 10 sf100 c ori x y  20],myscreen);

Stim1 = vsLoadTextures(myscreen, Stim1);
Stim2 = vsLoadTextures(myscreen, Stim2);
Stim3 = vsLoadTextures(myscreen, Stim3);
Stim4 = vsLoadTextures(myscreen, Stim4);

vsPlayStimulus(myscreen,Stim1,'norush');
vsPlayStimulus(myscreen,Stim2);	
vsPlayStimulus(myscreen,Stim3);	
% bug should come out here if not resolved
vsPlayStimulus(myscreen,Stim4);	

%
ltClearStimulus(Stim1,'nowarnings'); 
ltClearStimulus(Stim2,'nowarnings'); 
ltClearStimulus(Stim3,'nowarnings'); 
ltClearStimulus(Stim4,'nowarnings'); 

	
SCREEN('CloseAll');

