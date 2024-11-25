function SS = stimKalatskyCombo(myScreenInfo,Pars)
% stimKalatskyCombo makes color flickering bars moving periodically in both x and y
% direction
%
% SS = stimKalatskyCombo(myScreenInfo,Pars) returns an object SS of type ScreenStim
%
% SS = stimKalatskyCombo(myScreenInfo) uses the default parameters
%
% 2014-01 AP

%% Basics

if nargin < 1
    error('Must at least specify myScreenInfo');
end

if nargin < 2
    Pars = [];
end

%% The parameters and their definition

pp = cell(1,1);
pp{1}  = {'dur',	'Stimulus duration (s *10)',        50,1,600};
pp{2}  = {'start X',	'Stimulus start xpos(deg)',        0,0,360};
pp{3}  = {'end X',	'Stimulus end xpos(deg)',        360,0,360};
pp{4}  = {'start Y',	'Stimulus start ypos(deg)',        0,0,360};
pp{5}  = {'end Y',	'Stimulus end ypos(deg)',        360,0,360};
pp{6}  = {'tf X',     'Temporal frequency xpos(Hz *100)',      1,1,400};
pp{7}  = {'tf Y',     'Temporal frequency ypos(Hz *100)',      1,1,400};
pp{8}  = {'sf',     'Spatial frequency (cpd *100)',     20,1,200};
pp{9}  = {'dir',    'Direction of movement',                1,-1,1};
pp{10} = {'cyN',     'Cycles number (integer)',                    1, 1, 100};
pp{11}  = {'flickfreq',    'Temporal frequency of flicker (Hz *10)',   40,1,400};
pp{12}  = {'cr',    'Contrast of red gun (%)',          100,0,100};
pp{13}  = {'cg',	'Contrast of green gun (%)',        0,0,100};
pp{14}  = {'cb',	'Contrast of blue gun (%)',         0,0,100};
pp{15}  = {'lr',	'Mean luminance of red gun (%)',    50,0,100};
pp{16}  = {'lg',    'Mean luminance of green gun (%)',  0,0,100};
pp{17}  = {'lb',    'Mean luminance of blue gun (%)',   0,0,100};

x = XFile('stimKalatskyCombo',pp);
% x.Write; % call this ONCE: it writes the .x file


%% Parse the parameters

if isempty(Pars)
    Pars = x.ParDefaults;
end

%%
Pars1 = [Pars(1:3)' Pars(6) Pars(8) 0 0 Pars(9:17)' 1];
Pars2 = [Pars(1) Pars(4:5)' Pars(7:8)' 0 0 Pars(9:17)' 2];

myScreenStim1 = ScreenStim.Make( myScreenInfo,'stimKalatsky',Pars1 );
myScreenStim2 = ScreenStim.Make( myScreenInfo,'stimKalatsky',Pars2 );

SS = Merge( myScreenInfo, myScreenStim1, myScreenStim2);
SS.Type = x.Name;
SS.Parameters = Pars;


return

%% To test the code

myScreenStim = ScreenStim.Make(myScreenInfo,'stimKalatskyCombo'); %#ok<UNRCH>
myScreenStim.Show(myScreenInfo) %#ok<UNRCH>

% Screen('DrawTextures', myScreenInfo.windowPtr, SS.ImagePointers(3), [1; 1; wid; len], [ x1-wid, y1-len, x1+wid, y1+len ]);
% Screen('Flip', myScreenInfo.windowPtr);
 
