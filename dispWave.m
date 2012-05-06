function dispWave(waves, stimulusTimes, actionTimes)
% data visualization
figure; hold on
plot(waves)
legend('15','10','9')
plot(stimulusTimes, ones(length(stimulusTimes),1),'*k')
plot(actionTimes, ones(length(actionTimes),1),'ok')
