function dispWave(matfilename)
% data visualization
% load the data
load(matfilename)
% plot the waves
figure; hold on
plot(fWaves)
legend('IN 15', 'IN 10', 'IN 9')
plot(stimulusTimes, ones(length(stimulusTimes),1),'*k')
plot(actionTimes, ones(length(actionTimes),1),'ok')
