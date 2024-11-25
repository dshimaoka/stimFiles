function SS = stimFlashBarPlusNoiseTS2(myScreenInfo,Pars)
% stimFlashBarPlusNoise makes flashed bars superimposed onto rand noise
%
% SS = stimFlashBarPlusNoise(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimFlashBarPlusNoise(myScreenInfo) uses the default parameters
%
% 2011-08 MC

%% Basics

% global tsnum 
if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur', 'Stimulus duration (s *10)',               50,1,600};
pp{2} = {'ori',     'Orientation (deg)',                    45, 0, 360};
pp{3} = {'len',     'Bar length (deg*10)',                  300, 1, 900};
pp{4} = {'wid',     'Bar width (deg*10)',                    50, 1, 900};
pp{5} = {'pos',     'Position relative to center of screen (deg*10)'   200, -900, 900};
pp{6}  = {'ton1',  '1st onset time(ms)',                    300,1,6000};
pp{7}  = {'toff1', '1st offset time(ms)',                   2300,1,6000};
pp{8}  = {'ton2',  '2nd onset time(ms)',                   2400,1,6000};
pp{9}  = {'toff2', '2nd offset time(ms)',                  4400,1,6000};
pp{10}  = {'lum1',    '1st luminance (%)',                    50,-100,100};
pp{11}  = {'lum2',    '2nd luminance (%)',                   -50,-100,100};
pp{12}  = {'x1',    'NOISE: Left border, from center (deg*10)', -400,-1000,500};
pp{13}  = {'x2',   'NOISE: Right border, from center (deg*10)',  400,-500,1000};
pp{14}  = {'nfr',  'NOISE: Number of frames per stimulus',     20,1,70};
pp{15}  = {'sqsz',  'NOISE: Size of squares (deg*10)',         40,1,100};
pp{16}  = {'ncs',  'NOISE: Number of contrasts (choose 2 for b&w)', 3,2,16};
pp{17}  = {'c',    'NOISE: Contrast (%)',                           50,0,100};
pp{18} = {'seed', 'NOISE: Seed of random number generator',        1,1,100};
x = XFile('stimFlashBarPlusNoise',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%

% if abs(Pars(10))+Pars(17)>100 || abs(Pars(11))+Pars(17)>100
%     beep;
%     fprintf('\n\n\n\n CAREFUL!!! Your stimuli add up to contrast >100 \n\n');
% end

% parameters of the bar
xfocus = 0;
yfocus = 0;
Pars1 = [ Pars(1:5); xfocus; yfocus; Pars(6:11) ]; 

% parameters of the noise
y1 = -500;
y2 = 500;
Pars2 = [ Pars(1); Pars(12:13); y1; y2; Pars(14:end) ];

myScreenStim1 = ScreenStim.Make(myScreenInfo,'stimFlashedBar',Pars1 );
myScreenStim2 = ScreenStim.Make(myScreenInfo,'stimRandNoiseTS2' ,Pars2);

SS = Merge( myScreenInfo, myScreenStim1, myScreenStim2);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

RigInfo = RigInfoGet;
myScreenInfo = ScreenInfo(RigInfo);
myScreenInfo = myScreenInfo.CalibrationLoad;

x = XFile.Load('stimFlashBarPlusNoise');
Pars = x.ParDefaults;
Pars(1) = 20;
Pars(10) = 100;
Pars(17) = 100;
Pars(12) = 600;
Pars(13) = 800;

SS = ScreenStim.Make(myScreenInfo,'stimFlashBarPlusNoiseTS2',Pars);
SS.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
