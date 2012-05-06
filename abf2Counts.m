function [responseTimes, stimulusTimes, actionTimes, abswaves, manyzero] = abf2Counts(waves)
% convert abf waves to counts
% get the absolute values of the waves
waves = abs(waves);
% calculate the average values of each 10 points
n = 10;
actionWave   = filterWave(waves(:,1), n);
probeWave    = filterWave(waves(:,2), n);
stimulusWave = filterWave(waves(:,3), n);
abswaves = [stimulusWave,probeWave,actionWave];
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
    warning(' Low detection rate found. Check data manually.\n No. responses %d / No. stimuluses %d < 0.8', ...
        sum(nonzero), length(stimulusPulses))
    manyzero = 1;
end