function [responseTimes, stimulusTimes, actionTimes, meanTime, timeunit, meta] = runAbf2Counts(abfFilename)

% import data
[waves,timeunit,meta] = abfload2(abfFilename);
% filter the waves
waves = abs(waves);
% convert from .1ms to 1ms
n = 10;
actionWave = filterWave(waves(:,1), n);
probeWave = filterWave(waves(:,2), n);
stimulusWave = filterWave(waves(:,3), n);
fWaves = [stimulusWave,probeWave,actionWave];
% calculate response times
[responseTimes, actionTimes, stimulusTimes] = ...
    calcReponseTime(stimulusWave, probeWave,actionWave);
% get the nonzero results
nonzero = responseTimes~=0;
responseTimes = responseTimes(nonzero);
actionTimes = actionTimes(nonzero);
stimulusTimes = stimulusTimes(nonzero);
meanTime = mean(responseTimes(responseTimes~=0));
% visualize the results
figure
hold on
plot(fWaves)
legend('15','10','9')
plot(stimulusTimes, ones(length(stimulusTimes),1),'*k')
plot(actionTimes, ones(length(actionTimes),1),'ok')
