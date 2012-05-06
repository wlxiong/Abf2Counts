function [responseTimes, stimulusTimes, actionTimes, fWaves, manyzero] = abf2Counts(waves, meta)
% convert abf waves to counts
% get the absolute values of the waves
waves = abs(waves);
% calculate the average values of each 10 points
n = 10;
actionChInd   = find(cellfun(@length, strfind(meta.recChNames, '9')));
probeChInd    = find(cellfun(@length, strfind(meta.recChNames, '10')));
stimulusChInd = find(cellfun(@length, strfind(meta.recChNames, '15')));
actionWave   = filterWave(waves(:,actionChInd), n);
probeWave    = filterWave(waves(:,probeChInd), n);
stimulusWave = filterWave(waves(:,stimulusChInd), n);
fWaves = [stimulusWave,probeWave,actionWave];
% extract pusles from each wave
actionPulses   = findPulseInterval(actionWave);
probePulses    = findPulseInterval(probeWave);
stimulusPulses = findPulseInterval(stimulusWave);
% calculate response times
[responseTimes, actionTimes, stimulusTimes] = ...
    calcReponseTime(stimulusPulses,probePulses,actionPulses);
% get the nonzero results
manyzero = 0;
nonzero = responseTimes~=0;
responseTimes = responseTimes(nonzero);
actionTimes = actionTimes(nonzero);
stimulusTimes = stimulusTimes(nonzero);
if sum(nonzero) <= 0.8*length(stimulusPulses)
    warning(' Please check the data manually, because the following issue: ')
    warning(' No. responses %d / No. stimuluses %d < 0.8', sum(nonzero), length(stimulusPulses))
    manyzero = 1;
end