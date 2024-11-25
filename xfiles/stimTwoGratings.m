function SS = stimTwoGratings(myScreenInfo, Pars)% Two gratings, drifting or flickering, in disks or annuli or rectangles%% SS = stimSparseNoise(myScreenInfo,Pars) returns an object SS of type ScreenStim%% SS = stimSparseNoise(myScreenInfo) uses the default parameters%% 2014-11-10 SS (based on oglTwoGratings)%% Basicsif nargin < 1    error('Must at least specify myScreenInfo');endif nargin < 2    Pars = [];end%% The parameters and their definitionpp = cell(1,1);pp{1}  = {'dur',      'Stimulus duration (s *10)',        20,1,600};pp{2}  = {'tf1',      'Temporal frequency (Hz *10)',      20,1,4000};pp{3}  = {'sf1',      'Spatial frequency (cpd *100)',     8,1,1000};pp{4}  = {'tph1',     'Temporal phase (deg)',             0,0,360};pp{5}  = {'sph1',     'Spatial phase (deg)',              0,0,360};pp{6}  = {'ori1',     'Orientation (deg)',                0,0,360};pp{7}  = {'dA1',      'Inner diameter (deg*10)',          0,0,1200};pp{8}  = {'dB1',      'Outer diameter (deg*10)',          200,0,1200};pp{9}  = {'xc1',      'Center, x (deg*10)',               -100,-1400,1400};pp{10} = {'yc1',      'Center, y (deg*10)',               0,-450,450};pp{11} = {'flck1',    'Flickering (1) or drifting (0)',   0,0,1};pp{12} = {'sqwv1',    'Square wave (1) or sinusoid (0)',  0,0,1};pp{13} = {'duty1',    'Duty cycle (*100)',                100,0,100};pp{14} = {'shape1',   'Rectangle (1) or circle (0)',      0,0,1};pp{15} = {'cr1',      'Contrast of red gun (%)',          100,0,100};pp{16} = {'cg1',	  'Contrast of green gun (%)',        100,0,100};pp{17} = {'cb1',	  'Contrast of blue gun (%)',         100,0,100};pp{18} = {'tf2',      'Temporal frequency (Hz *10)',      20,1,4000};pp{19} = {'sf2',      'Spatial frequency (cpd *100)',     8,1,1000};pp{20} = {'tph2',     'Temporal phase (deg)',             0,0,360};pp{21} = {'sph2',     'Spatial phase (deg)',              0,0,360};pp{22} = {'ori2',     'Orientation (deg)',                0,0,360};pp{23} = {'dA2',      'Inner diameter or width (deg*10)', 0,0,1200};pp{24} = {'dB2',      'Outer diameter or height (deg*10)',200,0,1200};pp{25} = {'xc2',      'Center, x (deg*10)',               100,-1400,1400};pp{26} = {'yc2',      'Center, y (deg*10)',               0,-450,450};pp{27} = {'flck2',    'Flickering (1) or drifting (0)',   0,0,1};pp{28} = {'sqwv2',    'Square wave (1) or sinusoid (0)',  0,0,1};pp{29} = {'duty2',    'Duty cycle (*100)',                100,0,100};pp{30} = {'shape2',   'Rectangle (1) or circle (0)',      0,0,1};pp{31} = {'cr2',      'Contrast of red gun (%)',          100,0,100};pp{32} = {'cg2',	  'Contrast of green gun (%)',        100,0,100};pp{33} = {'cb2',	  'Contrast of blue gun (%)',         100,0,100};pp{34} = {'lr',	      'Mean luminance of red gun (%)',    50,0,100};pp{35} = {'lg',       'Mean luminance of green gun (%)',  50,0,100};pp{36} = {'lb',       'Mean luminance of blue gun (%)',   50,0,100};x = XFile('stimTwoGratings', pp);% x.Write; % call this ONCE: it writes the .x file%% Parse the parametersif isempty(Pars)    Pars = x.ParDefaults;enddur         = Pars(1)/10;                       % stfreq	 	= [Pars(2), Pars(18)] /10;          % Hzsfreq  		= [Pars(3), Pars(19)] /100;         % cpdtempphase  	= [Pars(4), Pars(20)] * (pi/180);   % radiansspatphase  	= [Pars(5), Pars(21)] * (pi/180);   % radiansorientation = [Pars(6), Pars(22)];              % degdiamIn      = myScreenInfo.Deg2Pix( [Pars(7), Pars(23)] /10 );       % degdiamOut     = myScreenInfo.Deg2Pix( [Pars(8), Pars(24)] /10 );       % deg[CtrCol(1), CtrRow(1)] = myScreenInfo.Deg2PixCoord(Pars(9)/10, Pars(10)/10);  % deg[CtrCol(2), CtrRow(2)] = myScreenInfo.Deg2PixCoord(Pars(25)/10, Pars(26)/10); % degflck        = [Pars(11), Pars(27)];             % 0 or 1sqwv        = [Pars(12), Pars(28)];             % 0 or 1duty        = [Pars(13), Pars(29)];             % between 0 and 1shape       = [Pars(14), Pars(30)];             % 0 or 1frequency   = zeros(1, 2);numFrames   = zeros(1, 2);cc 	= [Pars(15:17), Pars(31:33)] /100;          % between 0 and 1mm 	= Pars(34:36)/100;                          % between 0 and 1%% Make the stimulusSS = ScreenStim; % initializationSS.Type = x.Name;SS.Parameters = Pars;SS.nTextures = 2;SS.nFrames = ceil(myScreenInfo.FrameRate*dur );SS.Orientations = repmat(orientation', [1,SS.nFrames]);SS.Amplitudes = ones(2,SS.nFrames)/2; destRects = zeros(4, 2);sourceRects = zeros(4, 2);for igrat = 1:2    switch shape(igrat)        case 0            % it is an annulus            nx = diamOut(igrat);            ny = diamOut(igrat);        case 1            % it is a rectangle            nx = diamIn(igrat);            ny = diamOut(igrat);    end    destRects(:,igrat) = round([CtrCol(igrat)-nx/2 CtrRow(igrat)-ny/2 ...        CtrCol(igrat)+nx/2 CtrRow(igrat)+ny/2]');    sourceRects(:,igrat) = [0 0 nx ny];endSS.DestRects = repmat(destRects, [1 1 SS.nFrames]);SS.SourceRects = repmat(sourceRects, [1 1 SS.nFrames]);SS.MinusOneToOne = false;%% Define Frames and FrameSequence for each component gratingFrames          = cell(2,1);FrameSequence   = cell(2,1);ticfor igrat = 1:2        t = 0.001; % threshold    if duty(igrat)<1        beta = log(t)/log(cos( duty(igrat)*pi/2 ));    else        beta = 1;    end        % Spatial frequency in cycles/pixel    PixPerCycle = myScreenInfo.Deg2Pix(1/sfreq(igrat));    frequency(igrat) = 1/PixPerCycle; % sf in cycles/pix        nx = diff(destRects([1 3], igrat));    ny = diff(destRects([2 4], igrat));        % Make a grid of x and y    [xx,yy] = meshgrid(1-nx/2:nx/2,1-ny/2:ny/2);        % Image of the spatial phase of the stimulus (in radians)    AngFreqs = -2*pi* frequency(igrat) * xx + spatphase(igrat);        switch shape(igrat)        case 0            % an annulus            dd = sqrt(xx.^2+yy.^2);            WindowImage = double(dd >= diamIn(igrat)/2 & dd <= diamOut(igrat)/2);        case 1            % a rectangle            WindowImage = double(ones(size(xx)));    end        % The temporal phase of the response        nFramesInPeriod = round(myScreenInfo.FrameRate / tfreq(igrat));    TemporalPhase = 2*pi*(0:(nFramesInPeriod-1))/nFramesInPeriod + tempphase(igrat);    numFrames(igrat) = nFramesInPeriod;        ActualFrequency = myScreenInfo.FrameRate/nFramesInPeriod;    if abs(ActualFrequency/tfreq(igrat)-1)>0.1        fprintf(1,'Frequency %d is %2.2f rather than %2.0f Hz\n', ...            igrat, ActualFrequency, tfreq(igrat));    end        % Make movies    fprintf(1,' Frames for grating %d...', igrat);    if flck(igrat)        % flickering        ContrastTrace = sin(TemporalPhase);        ContrastImage = sin(AngFreqs);        ContrastImage = sign(ContrastImage).*abs(ContrastImage).^beta;        if sqwv(igrat)            ContrastImage = (ContrastImage>0.01)-(ContrastImage<-0.01);        end        Frames{igrat} = cell(nFramesInPeriod,1);        for iframe = 1:nFramesInPeriod            Frames{igrat}{iframe} = zeros(ny, nx, 3);            for igun = 1:3                Frames{igrat}{iframe}(:,:,igun) = uint8(255 * mm(igun) * ...                    (1 + cc(igrat,igun)*ContrastImage  .* WindowImage));            end        end    else        % drifting        for iframe = 1:nFramesInPeriod            ContrastImage = sin( AngFreqs + TemporalPhase(iframe));            ContrastImage = sign(ContrastImage).*abs(ContrastImage).^beta;            if sqwv(igrat)                ContrastImage = (ContrastImage>eps)-(ContrastImage<-eps);            end            Frames{igrat}{iframe} = zeros(ny, nx, 3);            for igun = 1:3                Frames{igrat}{iframe}(:,:,igun) = uint8(255 * mm(igun) * ...                    (1 + cc(igun,igrat)*ContrastImage  .* WindowImage));            end        end    end        % the frame sequence    FrameSequence{igrat} = mod(1:SS.nFrames,nFramesInPeriod);    FrameSequence{igrat}(FrameSequence{igrat} == 0) = nFramesInPeriod;   toc endSS.nImages = length(Frames{1}) + length(Frames{2});ImageTextures = [Frames{1}(:); Frames{2}(:)];SS.BackgroundColor = round(255 * mm);SS.BackgroundPersists = true;SS.ImageSequence = [FrameSequence{1}; FrameSequence{2} + length(Frames{1})];%% put the images in video RAMSS = SS.LoadImageTextures( myScreenInfo, ImageTextures );return%% to test the functionRigInfo = RigInfoGet; %#ok<UNRCH>myScreenInfo = ScreenInfo(RigInfo);myScreenInfo = myScreenInfo.CalibrationLoad;SS = stimTwoGratings(myScreenInfo);show(SS, myScreenInfo);Screen('CloseAll');% Play(SS, myScreenInfo)