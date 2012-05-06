function [responseTimes, actionTimes, stimulusTimes] = ...
    calcReponseTime(stimulusWave,probeWave, actionWave)
% calcReponseTime(waveFile, stimulusType)

% extract pusles from each wave
stimulusPulses = detPulseInterval(stimulusWave);
probePulses    = detPulseInterval(probeWave);
actionPulses   = detPulseInterval(actionWave);
% calculate the response time
numStimulus = length(stimulusPulses.head);
responseTimes = zeros(numStimulus, 1);
stimulusTimes = zeros(numStimulus, 1);
actionTimes   = zeros(numStimulus, 1);
% test each stimulus
for stimuInd = 1:numStimulus
    probeInd  = lowerBound(probePulses.tail, stimulusPulses.head(stimuInd));
    actionInd = lowerBound(actionPulses.head, stimulusPulses.head(stimuInd));
    if stimulusPulses.head(stimuInd) < probePulses.head( probeInd ) || ...
       stimuInd < numStimulus && stimulusPulses.head(stimuInd+1) < actionPulses.head( actionInd )
        continue
    end
    actionTimes(stimuInd) = actionPulses.head( actionInd );
    stimulusTimes(stimuInd) = stimulusPulses.head(stimuInd);
    responseTimes(stimuInd) = actionTimes(stimuInd) - stimulusTimes(stimuInd);
end
