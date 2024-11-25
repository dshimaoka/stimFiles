function SS = stimMovieNoiseDrift(myScreenInfo,Pars)
% stimMovie makes stimuli of type stimMovie.x / stimRandNoise.x / oglFlickDrift.x
%
% SS = stimMovie(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimMovie(myScreenInfo) uses the default parameters
%
% 2011-06 MO, still in developemnt

% Basics

if nargin < 2
  error('Must specify myScreenInfo & Pars');
end

% Common parameter and their definition
pp = cell(1,1);
pp{1}  = {'dur',  'Stimulus duration (s *10)',         50,1,600};
pp{2}  = {'movieORnoiseORdrift', 'selects which type of stimulus to present', 1, 0, 2};
pp{3}  = {'C',  'movie contrast squashing factor (in %) / contrast', 100,1,100};
pp{4}  = {'x1',   'Left border, from center (deg*10)', -400,-1000,500};
pp{5}  = {'x2',   'Right border, from center (deg*10)',  400,-500,1000};

% Movie specific parameters
pp{6}  = {'movieFile',  'Movie filename',  8009, 1, 9999};
pp{7}  = {'flipBW', 'flip black and white',              0,0,1};

% 7-->1

% parameters for stimRandNoise
pp{8}  = {'y1',  'Bottom border, from center (deg*10)', -200,-1000,500};
pp{9}  = {'y2',     'Top border, from center (deg*10)',  200,-500,1000};
pp{10}  = {'nfr',  'Number of frames per stimulus',     10,1,70};
pp{11}  = {'sqsz',  'Size of squares (deg*10)',         30,1,100};
pp{12}  = {'ncs',  'Number of contrasts (choose 2 for b&w)', 3,2,16};
pp{13} = {'seed', 'Seed of random number generator',        1,1,100};

% parameters for oglFlickDrift.x
pp{14} = {'tfreq' , 'temporal freq (cyc/s * 10)' , 50, 1, 100};
pp{15} = {'sfreq ', 'spatial freq (cyc/deg* 100)', 15, 5, 50};	
pp{16} = {'ori', 'orientation', 225, 0, 359};

% x = XFile('stimMovieNoiseDrift',pp);
% x.Write; % call this ONCE: it writes the .x file

% Pars has to be a column

if Pars(2) == 0 % movie
  SS = stimMovie(myScreenInfo, [...
    Pars(1) ... duration
    Pars(6) ... movie filename
    Pars(3) ... contrast squash
    Pars(4:5)' ... left & right borders
    Pars(7) ... flip BW
    ]');    
elseif Pars(2) == 1 % random noise
  SS = stimRandNoise(myScreenInfo, [...
  Pars(1) ... duration
  Pars(4:5)' ... left & right borders
  Pars(8:9)' ... top & bottom borders
  Pars(10:12)' ... nfr sqsz ncs
  Pars(3) ... contrast
  Pars(13) ... random seed
  ]');
else
  SS = ScreenStim.Make(myScreenInfo,'oglFlickDrift',[...
    Pars(1) .... duration
    Pars(14:15)' ...tfreq & sfreq
    Pars(3) ... contrast (%)
    Pars(16) ... orientation
    Pars(1) Pars(1) ... duration
    0 ... blank screen in the end duration
    ]');
end;
SS.Type = 'stimMovieNoiseDrift';
SS.Parameters = Pars;
return

%% To test the code

RigInfo = RigInfoGet;
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

Pars = [ ...
  50 ... (1) 5 sec duration 
  0 ... (2) movie
  50 ... (3) contrast
  -400 400 ... (4 & 5) left & right borders
  4200 ... (6)which movie
  0 ... (7) not to flip black & white  
  -200 200 ... (8 & 9) bottom & top borders (for noise)
  10 30 3 1 ... (10 11 12 13) nfr sqsz ncs seed (for noise)
  50 15 ... (14 15) tfreq & sfreq for grating
  225 ... (16) orientation for grating
  ]';
  
SSm = stimMovieNoiseDrift(myScreenInfo, Pars);  % movie...
Pars(2) = 1;
SSn = stimMovieNoiseDrift(myScreenInfo, Pars); % random noise 
Pars(2) = 2;
SSg = stimMovieNoiseDrift(myScreenInfo, Pars); % gratings
Pars(16) = 180; % different direction of drift
SSg2 = stimMovieNoiseDrift(myScreenInfo, Pars); % gratings

Play(SSn, myScreenInfo);
Play(SSg, myScreenInfo);
Play(SSm, myScreenInfo);
Play(SSg2, myScreenInfo);
