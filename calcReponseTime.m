function [responseTimes, actionTimes, stimulusTimes] = ...
    calcReponseTime(stimulusWave,probeWave, actionWave)
% calcReponseTime(waveFile, stimulusType)

% extract pusles from each wave
stimulusPulses = detPulseInterval(stimulusWave);
probePulses = detPulseInterval(probeWave);
actionPulses = detPulseInterval(actionWave);
% calculate the response time
numStimulus = length(stimulusPulses.head);
responseTimes = zeros(numStimulus, 1);
stimulusTimes = zeros(numStimulus, 1);
actionTimes = zeros(numStimulus, 1);
matchedProbePulses = zeros(numStimulus, 1);
matchedActionPulses = zeros(numStimulus, 1);
for i = 1:length(stimulusPulses.head)
    probeHeadInd = 0 - 1 - lowerBound(probePulses.head, stimulusPulses.head(i));
    probeTailInd = 0 - lowerBound(probePulses.tail, stimulusPulses.head(i));
    actionHeadInd = 0 - 1 - lowerBound(actionPulses.head, stimulusPulses.tail(i));
    actionTailInd = 0 - lowerBound(actionPulses.tail, stimulusPulses.tail(i));
%     actionHeadInd = 0 - lowerBound(actionPulses.head, stimulusPulses.head(i));
%     actionTailInd = 0 - lowerBound(actionPulses.tail, stimulusPulses.tail(i));
    if probeHeadInd == probeTailInd && ...
            stimulusPulses.head(i) >= probePulses.head(probeHeadInd) && ...
            stimulusPulses.head(i) <= probePulses.tail(probeTailInd)
        matchedProbePulses(i) = probeHeadInd;
    end
    if actionHeadInd == actionTailInd && ...
            stimulusPulses.tail(i) >= actionPulses.head(actionHeadInd) && ...
            stimulusPulses.tail(i) <= actionPulses.tail(actionTailInd)
        matchedActionPulses(i) = actionHeadInd;
    end
%     if actionHeadInd == actionTailInd && ...
%             actionPulses.head(actionHeadInd) >= stimulusPulses.head(i) && ...
%             actionPulses.head(actionHeadInd) <= stimulusPulses.tail(i)
%         matchedActionPulses(i) = actionHeadInd;
%     end
    if matchedActionPulses(i) ~= 0 && matchedProbePulses(i) ~= 0
        actionTimes(i) = actionPulses.head( matchedActionPulses(i) );
        stimulusTimes(i) = stimulusPulses.head( i );
        responseTimes(i) = actionTimes(i) - stimulusTimes(i);
    end
end
