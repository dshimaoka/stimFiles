function [luminance,ileave,whichframe,whichclut] = virtualPlayStimulus(iframe,myscreen,stim,oldleave,oldframe,oldclut)
% virtualPlayStimulus plays one frame of a stimulus to a model
% 
% [luminance,ileave,whichframe,whichclut] = virtualPlayStimulus(iframe,myscreen,stim,oldleave,oldframe,oldclut)
% luminance is a cell array, each entry corresponds to a patch in the frame
%
% This function does essentially the same as ltPlayStimulus, without actually
% showing the stimulus on a screen. In essence, the function first checks when 
% the lookup table changes according to stim.sequence.frames, than combines the
% lookup table with a frame according to stim.sequence.frames.
%
% Unlike ltPlayStimulus, to interleave 2 stimuli they are not given as separate
% inputs, but as different cells in stim (as they are generated for example by
% vis2luts2grats).
%
% The luminance values in the output vary between 0 and 1. I assumed that
% the original luminance values vary between 0 and 255.
%
% part of VisBox

% 2003-06-18 VM from virtualplaystimulus
% 

if nargin < 6
   oldleave = [];
end

% Decide whether there are two stimuli that have to be interleaved, and
% check that all inputs have reasonable sizes.
thisstim = [];
if length(stim) == 1 % not interleaved
   
   if (size(stim{1}.sequence.luts,2) ~= size(stim{1}.sequence.frames,2))
      error('stim.sequence.luts and stim.sequence.frames must have the same length in ltVirtualPlayStimulus!');
   end
   if isempty(stim{1}.luts)
      error('You must specify at least one lut in stim.lut!');
   end
   if isempty(stim{1}.frames)
      error('You must specify at least one frame in stim.frames!');
   end
   
   nframes = length(stim{1}.sequence.frames) * stim{1}.nperiods;
   if (iframe < 1 | iframe > nframes)
      error(['You can choose iframe between 1 and ' num2str(nframes)]);
   end
   
   % There is only one stim
   thisstim = stim{1};
   ileave = 1;
   
elseif length(stim) == 2 % interleaved
   
   if (size(stim{1}.sequence.luts,2) ~= size(stim{1}.sequence.frames,2))
      error('stim{1}.sequence.luts and stim{1}.sequence.frames must have the same length in ltVirtualPlayStimulus!');
   end
   if (size(stim{2}.sequence.luts,2) ~= size(stim{2}.sequence.frames,2))
      error('stim{2}.sequence.luts and stim{2}.sequence.frames must have the same length in ltVirtualPlayStimulus!');
   end
   if (size(stim{1}.sequence.luts,2) ~= size(stim{2}.sequence.frames,2))
      error('Interleaved Movies must have the same length in ltVirtualPlayStimulus!');
   end
   
   nframes = length(stim{1}.sequence.frames) * stim{1}.nperiods * 2;
   if (iframe < 1 | iframe > nframes)
      error(['You can choose iframe between 1 and ' num2str(nframes)]);
   end
   
   % There are two stimuli, find out which one has to be shown during this frame
   ileave = mod(iframe - 1,2) + 1;
   thisstim = stim{ileave};
   iframe = round(iframe/2);
   
else
   error('The stimulus format is wrong');
end

% Find the right frame. Consider that stim.sequence.frames is NaN 
% if the frame is the same as the preceding one
whichframe = NaN;
lastframe = iframe + 1;
while isnan(whichframe)
   lastframe = lastframe - 1;
   whichframe = thisstim.sequence.frames(lastframe);
end

% Find the rigth lookup table. Condider that stim.sequence.luts is NaN 
% if the lut is the same as the preceding one
whichclut = NaN;
lastClut = iframe + 1;
while isnan(whichclut)
   lastClut = lastClut - 1;
   whichclut = thisstim.sequence.luts(lastClut);
end

% If frame and lut are the same as before, than do nothing
if ~isempty(oldleave) & all([oldleave oldframe oldclut] == [ileave whichframe whichclut])
   luminance = NaN;
else

   % Get the right lookup table
   goodClut = thisstim.luts{whichclut};
   
   % Compute the actual luminance on the screen
   npatches = length(thisstim.frames);
   for ipatch = 1:npatches
      
      % Get the right frame
      goodFrame = thisstim.frames{ipatch}{whichframe};
      
      % Combine the lookup table and the frame to obtain luminances that vary between 
      % 0 and 255, and rescale them so that they vary between 0 and 1.
      % Assumes that all columns in the lookup table are the same (which mean that 
      % there is no color in the stimuli).
      thisluminance = goodClut(double(goodFrame(:))+1,1) / 255;
      [ny,nx] = size(goodFrame);
      luminance{ipatch} = reshape(thisluminance,ny,nx);
      
   end
end
   
   
return

%----------------------------------------------------------------------------

% Code to test the function
myscreen.Xmax = 400;
myscreen.Ymax = 400;
myscreen.FrameRate = 125;
myscreen.PixelSize = 0.25;
myscreen.Dist = 60;

% Make a movie
stim = vismovie([1001,0,0],myscreen);

iframe = 1;
[luminance,ileave,whichframe,whichclut] = virtualPlayStimulus(iframe,myscreen,stim);

% figure;
tic
iframe = 1;
[luminance,ileave,whichframe,whichclut] = virtualPlayStimulus(iframe,myscreen,stim);
for iframe = 2:length(stim.sequence.frames)
   %[luminance,ileave,whichframe,whichclut] = virtualPlayStimulus(iframe,myscreen,stim);
   [luminance,ileave,whichframe,whichclut] = virtualPlayStimulus(iframe,myscreen,stim,ileave,whichframe,whichclut);
%    if iscell(luminance)
%       imagesc(luminance{1});
%    end
%    iframe
%    pause
end
toc

figure;
subplot(2,1,1); imagesc(stim.frames{1}{whichframe}); set(gca,'plotboxaspectratio',[1 1 1]);
subplot(2,1,2); imagesc(luminance{1}); set(gca,'plotboxaspectratio',[1 1 1]);

% Make a plaid
stim = vis2luts2grats([ 20 40 10 0 50 90 0 0 0 40 30 10 0 50 45 20 -20 20 60],myscreen);
iframe = 3;
[luminance,ileave] = virtualPlayStimulus(iframe,myscreen,stim);
figure; imagesc(patches{1}.luminance); set(gca,'plotboxaspectratio',[1 1 1]);

