function [abflist] = batchRun(apath)
% batch run abf2Counts
apath = fileparts(apath);
abfpath = [apath '/*.abf'];
abflist = rdir(abfpath);

for p = 1:length(abflist)
	fprintf('\n [Processing]: %s\n\n', abflist(p).name)
	[responseTimes, stimulusTimes, actionTimes, waves, timeunit, meta] = abf2Counts(abflist(p).name);
	[pathstr, name, ext] = fileparts(abflist(p).name);
	save([pathstr, name, '.mat'], responseTimes, stimulusTimes, actionTimes, waves, timeunit, meta);
	xlswrite([pathstr, name, '.xls'], responseTimes, stimulusTimes, actionTimes);
end
