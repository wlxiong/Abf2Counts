function [probes, responses, mismatch, invalidate, smoothwaves, avgwaves] = abf2Counts(waves, timeunit)
% convert abf waves to counts
% calculate the moving-average values of each 10 points
avgspan = floor(1000/timeunit);
[actionWave, avgActionWave]     = smoothWave(waves(:,1), avgspan);
[probeWave, avgProbeWave]       = smoothWave(waves(:,2), avgspan);
[stimulusWave, avgStimulusWave] = smoothWave(waves(:,3), avgspan);
smoothwaves = [stimulusWave,probeWave,actionWave];
avgwaves = [avgStimulusWave,avgProbeWave,avgActionWave];
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
