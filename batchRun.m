function [abflist] = batchRun(apath)
% batch run abf2Counts
cd(apath);
apath = pwd;
abfpath = [apath '/*.abf'];
abflist = rdir(abfpath);

for p = 1:length(abflist)
	[responseTimes, stimulusTimes, actionTimes, waves, timeunit, meta] = abf2Counts(abflist.name(p));
	[pathstr, name, ext] = fileparts(abflist.name(p));
	save([pathstr, name, '.mat'], responseTimes, stimulusTimes, actionTimes, waves, timeunit, meta);
	xlswrite([pathstr, name, '.xls'], responseTimes, stimulusTimes, actionTimes);
end
