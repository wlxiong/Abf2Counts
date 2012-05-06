function [responseTimes, actionTimes, stimulusTimes] = ...
    calcReponseTime(stimulusPulses,probePulses, actionPulses)
% calcReponseTime(waveFile, stimulusType)

% calculate the response time
numStimulus = length(stimulusPulses.head);
responseTimes = zeros(numStimulus, 1);
stimulusTimes = zeros(numStimulus, 1);
actionTimes   = zeros(numStimulus, 1);
% test each stimulus
for stimuInd = 1:numStimulus
    probeInd  = lowerBound(probePulses.tail, stimulusPulses.head(stimuInd));
    actionInd = lowerBound(actionPulses.head, stimulusPulses.head(stimuInd));
    if probeInd > length((probePulses.head)) || actionInd > length(actionPulses.head) || ...
	   stimulusPulses.head(stimuInd) < probePulses.head( probeInd ) || ...
       stimuInd < numStimulus && stimulusPulses.head(stimuInd+1) < actionPulses.head( actionInd )
        continue
    end
    actionTimes(stimuInd) = actionPulses.head( actionInd );
    stimulusTimes(stimuInd) = stimulusPulses.head(stimuInd);
    responseTimes(stimuInd) = actionTimes(stimuInd) - stimulusTimes(stimuInd);
end
