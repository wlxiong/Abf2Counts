function [probes, responses, mismatch] = ...
    calcReponseTime(stimulusPulses,probePulses, actionPulses)
% calculate the response time
numProbe  = length(probePulses.head);
mismatch  = zeros(numProbe, 1);
probes    = struct('time', mismatch, 'head', mismatch, 'tail', mismatch);
responses = struct('time', mismatch, 'head', mismatch, 'tail', mismatch);
if isempty(stimulusPulses.head) || isempty(actionPulses.head)
    return
end
% check every probe
for probeInd = 1:numProbe
    % calculate probe times
    probes.time(probeInd) = probePulses.tail(probeInd) - probePulses.head(probeInd);
    probes.head(probeInd) = probePulses.head(probeInd);
    probes.tail(probeInd) = probePulses.tail(probeInd);
    
    % search stimuluses
	stimuInd  = lowerBound(stimulusPulses.head, probePulses.head(probeInd));
    % do not match any stimulus pulse
    if stimuInd > length((stimulusPulses.head)) || ...
       stimulusPulses.head(stimuInd) > probePulses.tail(probeInd)
		mismatch(probeInd) = 1;
		continue
    end
    % calculate the probe time
    probes.time(probeInd) = stimulusPulses.head(stimuInd) - probePulses.head(probeInd);
	probes.head(probeInd) = probePulses.head(probeInd);
    probes.tail(probeInd) = stimulusPulses.head(stimuInd);
    
    % search actions
	actionInd = lowerBound(actionPulses.head, stimulusPulses.head(stimuInd));
	% do not match any action pulse
	if actionInd > length(actionPulses.head) ||...
       stimulusPulses.head(stimuInd) + 2000 < actionPulses.head(actionInd) || ...
       stimuInd < length(stimulusPulses.head) && ...
       stimulusPulses.head(stimuInd+1) < actionPulses.head(actionInd)
        responses.head(probeInd) = stimulusPulses.head(stimuInd);
		mismatch(probeInd) = 2;
		continue
	end
	% calculate the response time
    responses.time(probeInd) = actionPulses.head(actionInd) - stimulusPulses.head(stimuInd);
	responses.tail(probeInd) = actionPulses.head(actionInd);
    responses.head(probeInd) = stimulusPulses.head(stimuInd);
end
