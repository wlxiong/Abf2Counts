function [timelist, abflist] = batchRun(apath)
% batch run abf2Counts
apath = fileparts(apath);
abfpath = [apath '/*.abf'];
abflist = rdir(abfpath);
timelist = cell(length(abflist),1);
for p = 1:length(abflist)
    fprintf('\n *** %d/%d *** \n', p, length(abflist))
	% import data
	fprintf('\n [Importing]: %s\n\n', abflist(p).name)
	[waves,timeunit,meta] = abfload2(abflist(p).name);
	% process data
	fprintf('\n [Processing]: %s\n\n', abflist(p).name)
	[responseTimes, stimulusTimes, actionTimes, fWaves] = abf2Counts(waves,meta);
	timelist{p} = responseTimes;
	% export results
	[pathstr, name, ext] = fileparts(abflist(p).name);
	matfilename = fullfile(pathstr, [name, '.mat']);
	csvfilename = fullfile(pathstr, [name, '.csv']);
	save(matfilename, 'responseTimes', 'stimulusTimes', 'actionTimes', 'fWaves');
	csvwrite(csvfilename, [responseTimes, stimulusTimes, actionTimes]);
	% display summary
	fprintf(' no. of response: %d\n', length(responseTimes));
	fprintf(' mean response time: %.2f ms\n', mean(responseTimes));
	fprintf(' std. response time: %.2f ms\n',  std(responseTimes));
end
