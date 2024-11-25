function SS = stimGratingStopped(myScreenInfo, Pars)% One grating, drifting or flickering, in disks or annuli or rectangles%% SS = stimGratingWithMask(myScreenInfo, Pars)%% SS = stimGratingWithMask(myScreenInfo) uses the default parameters%% 2015-09 MP based on stimGratingWithMask.m. Added onset and offset times.%% Basicsif nargin < 1    error('Must at least specify myScreenInfo');endif nargin < 2    Pars = [];end%% The parameters and their definitionpp = cell(1,1);pp{1}  = {'dur',      'Stimulus duration (s *10)',        50,1,600};pp{2}  = {'tf',       'Temporal frequency (Hz *10)',      20,0,4000};pp{3}  = {'sf',       'Spatial frequency (cpd *1000)',    80,0,1000};pp{4}  = {'tph',      'Temporal phase (deg)',             0,0,360};pp{5}  = {'sph',      'Spatial phase (deg)',              0,0,360};pp{6}  = {'ori',      'Orientation (deg)',                0,0,360};pp{7}  = {'diam',     'Diameter (deg*10)',          200,0,2700};pp{8}  = {'xc',       'Center, x (deg*10)',               -100,-1400,1400};pp{9} = {'yc',       'Center, y (deg*10)',               0,-450,450};pp{10} = {'flck',     'Flickering (1) or drifting (0)',   0,0,1};pp{11} = {'sqwv',     'Square wave (1) or sinusoid (0)',  0,0,1};pp{12} = {'shape',    'Rectangle (1) or circle (0)',      1,0,1};pp{13} = {'tstart',   'Start time (ms)',                  300,0,60000};pp{14} = {'tend',     'End   time (ms)',                  1300,0,60000};pp{15} = {'cr',       'Contrast of red gun (%)',          100,0,100};pp{16} = {'cg',	      'Contrast of green gun (%)',        100,0,100};pp{17} = {'cb',	      'Contrast of blue gun (%)',         100,0,100};pp{18} = {'lr',	      'Mean luminance of red gun (%)',    50,0,100};pp{19} = {'lg',       'Mean luminance of green gun (%)',  50,0,100};pp{20} = {'lb',       'Mean luminance of blue gun (%)',   50,0,100};pp{21} = {'dridur',   'drift duration (s*10)',               30,1,600};x = XFile('stimGratingStopped', pp);% x.Write; % call this ONCE: it writes the .x file%% Parse the parametersif isempty(Pars)    Pars = x.ParDefaults;enddur         = Pars(1)/10;           % stfreq	 	= Pars(2) /10;          % Hzsfreq  		= Pars(3) /1000;         % cpdtempphase  	= Pars(4) * (pi/180);   % radiansspatphase  	= Pars(5) * (pi/180);   % radiansorientation = Pars(6);              % deg% diamIn      = myScreenInfo.Deg2Pix( Pars(7) /10 );       % degdiamOut     = myScreenInfo.Deg2Pix( Pars(7) /10 );       % deg[CtrCol(1), CtrRow(1)] = myScreenInfo.Deg2PixCoord(Pars(8)/10, Pars(9)/10);  % degflck        = Pars(10);             % 0 or 1sqwv        = Pars(11);             % 0 or 1shape       = Pars(12);             % 0 or 1tonset        = Pars(13)/1000;             % in secondstoffset       = Pars(14)/1000;             % in secondscc 	= Pars(15:17) /100;          % between 0 and 1mm 	= Pars(18:20)/100;           % between 0 and 1dridur = Pars(21)/10;%% Make the stimulusSS = ScreenStim; % initializationSS.Type = x.Name;SS.Parameters = Pars;SS.nTextures = 1;SS.nFrames = round( myScreenInfo.FrameRate*dur );nFramesDrift = round( myScreenInfo.FrameRate*dridur );if ~mod(SS.nFrames, 2)    % we want an odd number of frames if the SyncSquare is Flickering.    SS.nFrames=SS.nFrames+1;endSS.Orientations = repmat(orientation, [1,SS.nFrames]);SS.Amplitudes = ones(1,SS.nFrames); % global alpha value% determine size of grating and mask (not size of presented part of% gratings through mask)switch shape    case 0        % it is an annulus        nxGrating = diamOut;        nxMask = sqrt(2) * diamOut;    case 1        % it is a rectangle        nxGrating = sqrt(2) * diamOut; % has to be big enough so that                                             % it covers hole in mask when rotated        nxMask = 2 *diamOut;end%% Define Frames and FrameSequence for each component grating    % Spatial frequency in cycles/pixelif sfreq == 0    frequency = 0;else    PixPerCycle = myScreenInfo.Deg2Pix(1/sfreq);    frequency = 1/PixPerCycle; % sf in cycles/pixend% Make a row of xxx = 1-round(nxGrating/2):round(nxGrating/2);% Image of the spatial phase of the stimulus (in radians)AngFreqs = -2*pi* frequency * xx + spatphase;% The temporal phase of the responseif tfreq == 0    nFramesInPeriod = 1;else    nFramesInPeriod = round(myScreenInfo.FrameRate / tfreq);endTemporalPhase = 2*pi*(0:(nFramesInPeriod-1))/nFramesInPeriod + tempphase;ActualFrequency = myScreenInfo.FrameRate/nFramesInPeriod;if tfreq > 0 && abs(ActualFrequency/tfreq-1)>0.1    fprintf(1,'Frequency %d is %2.2f rather than %2.0f Hz\n', ...        igrat, ActualFrequency, tfreq);end% Make moviesif flck    % flickering    ContrastImage = sin(AngFreqs);    if sqwv        ContrastImage = (ContrastImage>0.01)-(ContrastImage<-0.01);    end    Frames = cell(2,1);    Frames{1} = zeros([size(ContrastImage), 3]);    for igun = 1:3        Frames{1}(:,:,igun) = uint8(255 * mm(igun) * ...            (1 + cc(igun)*ContrastImage));    end    Frames{2} = 255 - Frames{1};else    % drifting    Frames = cell(nFramesInPeriod,1);    for iframe = 1:nFramesInPeriod        ContrastImage = sin( AngFreqs + TemporalPhase(iframe));        if sqwv            ContrastImage = (ContrastImage>=0)-(ContrastImage<0);        end        Frames{iframe} = zeros([size(ContrastImage), 3]);        for igun = 1:3            Frames{iframe}(:,:,igun) = uint8(255 * mm(igun) * ...                (1 + cc(igun)*ContrastImage));        end    endend% Make mask% xx = 1-round(nxMask/2):round(nxMask/2);% MaskImage = zeros(length(xx), length(xx), 4);% % periphery of mask has same colour as background% for j = 1:3%     MaskImage(:,:,j) = round(255 * mm(j));% end% MaskImage(:,:,4) = 255; % makes mask opaque% switch shape%     case 0%         % an annulus: make circle/annulus in mask transparent%         dd = sqrt(bsxfun(@plus, xx.^2, (xx.^2)'));%         mask = MaskImage(:,:,4);%         mask(dd >= diamIn/2 & dd <= diamOut/2) = 0;%         MaskImage(:,:,4) = mask;%     case 1%         % a rectangle: make rectangle in mask transparent%         MaskImage(length(xx)/2 + (1-round(diamIn/2):round(diamIn/2)), ...%             length(xx)/2 + (1-round(diamOut/2):round(diamOut/2)), 4) = 0;% enddestRects = zeros(4, 1);sourceRects = zeros(4, 1);destRects(:,1) = round([CtrCol-nxGrating/2 CtrRow-nxGrating/2 ...    CtrCol+nxGrating/2 CtrRow+nxGrating/2]');% destRects(:,2) = round([CtrCol-nxMask/2 CtrRow-nxMask/2 ...%     CtrCol+nxMask/2 CtrRow+nxMask/2]');sourceRects(:,1) = [0 0 length(ContrastImage) 1];% sourceRects(:,2) = [0 0 size(MaskImage,2) size(MaskImage,1)];SS.DestRects = repmat(destRects, [1 1 SS.nFrames]);SS.SourceRects = repmat(sourceRects, [1 1 SS.nFrames]);SS.MinusOneToOne = false;SS.UseAlpha = true;% the frame sequenceFrameSequence = mod(1:SS.nFrames,nFramesInPeriod);FrameSequence(FrameSequence == 0) = nFramesInPeriod;if flck    FrameSequence = TemporalPhase(FrameSequence);    ind = FrameSequence < pi;    FrameSequence(ind) = 1;    FrameSequence(~ind) = 2;endSS.nImages = length(Frames) + 1; % +1 for masktf1                                 = ceil(myScreenInfo.FrameRate*tonset);tf2                                 = ceil(myScreenInfo.FrameRate*toffset);FrameSequence                       = cat(2, ones(1,tf1-1) * SS.nImages, FrameSequence);FrameSequence                       = FrameSequence(1:SS.nFrames);FrameSequence((tf2+1):SS.nFrames)   = SS.nImages;BackgroundImage               = round(255 * mm);ImageTextures           = [Frames; {BackgroundImage}];SS.BackgroundColor      = round(255 * mm);SS.BackgroundPersists   = true;% SS.BackgroundColor      = mm;% SS.BackgroundPersists   = true;FrameSequence((nFramesDrift+1):end) = FrameSequence(nFramesDrift);% SS.ImageSequence = [FrameSequence; ones(1,SS.nFrames) * SS.nImages];SS.ImageSequence        = FrameSequence; % keyboard;% SS.ImagePointers = Screen('MakeTexture', myScreenInfo.windowPtr, 0, [], 0, 1);% SS.BilinearFiltering = -2; % do not interpolate! %% put the images in video RAMSS = SS.LoadImageTextures( myScreenInfo, ImageTextures );return%% to test the functionRigInfo = RigInfoGet; %#ok<UNRCH>myScreenInfo = ScreenInfo(RigInfo);myScreenInfo = myScreenInfo.CalibrationLoad;SS = stimGratingWithMask(myScreenInfo);show(SS, myScreenInfo);Screen('CloseAll');% Play(SS, myScreenInfo)