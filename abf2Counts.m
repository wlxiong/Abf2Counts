function [probes, responses, mismatch, invalidate, abswaves] = abf2Counts(waves)
% convert abf waves to counts
% get the absolute values of the waves
waves = abs(waves);
% calculate the moving-average values of each 10 points
n = 10;
actionWave   = smoothWave(waves(:,1), n);
probeWave    = smoothWave(waves(:,2), n);
stimulusWave = smoothWave(waves(:,3), n);
abswaves = [stimulusWave,probeWave,actionWave];
% extract pusles from each wave
[actionPulses, lowa]   = findPulseInterval(actionWave);
[probePulses, lowp]    = findPulseInterval(probeWave);
[stimulusPulses, lows] = findPulseInterval(stimulusWave);
% calculate response times
[probes, responses, mismatch] = calcReponseTime(stimulusPulses,probePulses,actionPulses);
% warn the invalidate results
invalidate = 0;
if sum(mismatch==0) <= 0.5*length(probePulses.head)
    warning(' Low detection rate found. Check data manually.\n No. responses %d / No. probes %d < 0.5', ...
        sum(mismatch==0), length(probePulses.head))
    invalidate = 1;
end
