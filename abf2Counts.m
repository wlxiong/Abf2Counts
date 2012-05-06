function [responseTimes, stimulusTimes, actionTimes, meanTime, timeunit, meta] = abf2Counts(abfFilename)

% import data
[waves,timeunit,meta] = abfload2(abfFilename);
% get the absolute values of the waves
waves = abs(waves);
% calculate the average values of each 10 points
n = 10;
actionWave   = filterWave(waves(:,1), n);
probeWave    = filterWave(waves(:,2), n);
stimulusWave = filterWave(waves(:,3), n);
fWaves = [stimulusWave,probeWave,actionWave];
% extract pusles from each wave
actionPulses   = findPulseInterval(actionWave);
probePulses    = findPulseInterval(probeWave);
stimulusPulses = findPulseInterval(stimulusWave);
% calculate response times
[responseTimes, actionTimes, stimulusTimes] = ...
    calcReponseTime(stimulusPulses,probePulses,actionPulses);
% get the nonzero results
nonzero = responseTimes~=0;
responseTimes = responseTimes(nonzero);
actionTimes = actionTimes(nonzero);
stimulusTimes = stimulusTimes(nonzero);
meanTime = mean(responseTimes(responseTimes~=0));
% visualize the results
figure; hold on
plot(fWaves)
legend('15','10','9')
plot(stimulusTimes, ones(length(stimulusTimes),1),'*k')
plot(actionTimes, ones(length(actionTimes),1),'ok')
