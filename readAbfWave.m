function [stimulusWave,probeWave,actionWave,waves,timeunit,meta] = readAbfWave(filename)
% read the abf file
[waves,timeunit,meta] = abfload2(filename);
% get channel name
channelNames = meta.recChNames;
disp(channelNames)
stimulusChannel = 3;
probeChannel = 2;
actionChannel = 1;
% get wave from each channel
stimulusWave = waves(:,stimulusChannel);
probeWave = waves(:,probeChannel);
actionWave = waves(:,actionChannel);
