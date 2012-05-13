function dispWave(matfilename)
% data visualization
% load the data
load(matfilename)
% plot the waves
figure; hold on
plot(abswaves)
legend('IN 15', 'IN 10', 'IN 9')
plot(responses.head, ones(length(responses.head),1)*.8,'*k')
plot(responses.tail, ones(length(responses.tail),1)*.8,'ok')
plot(probes.head, ones(length(probes.head),1)*.6,'vk')
plot(probes.tail, ones(length(probes.tail),1)*.6,'^k')
