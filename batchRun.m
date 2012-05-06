function [timelist, chckfile, abflist] = batchRun(apath, replace)
% batch run abf2Counts
apath = fileparts(apath);
abfpath = fullfile(apath, '**/', '*.abf');
abflist = rdir(abfpath);
timelist = cell(length(abflist),1);
chckfile = zeros(length(abflist),1);
diary(fullfile(apath, 'abf2counts.log'))
diary on
for p = 1:length(abflist)
    fprintf('\n *** %d/%d *** \n', p, length(abflist))
    % create the output filenames
	[pathstr, name, ext] = fileparts(abflist(p).name);
	matfilename = fullfile(pathstr, [name, '.mat']);
	csvfilename = fullfile(pathstr, [name, '.csv']);
    % check if the results already exist
    if replace || ~exist(matfilename, 'file') || ~exist(csvfilename, 'file')
        % import data
        fprintf('\n [Importing]: %s\n\n', abflist(p).name)
        [waves,timeunit,meta] = abfload2(abflist(p).name);
        % process data
        fprintf('\n [Processing]: %s\n\n', abflist(p).name)
        [responseTimes, stimulusTimes, actionTimes, fWaves, manyzero] = abf2Counts(waves,meta);
        timelist{p} = responseTimes;
        chckfile(p) = manyzero;
        % export results
        save(matfilename, 'responseTimes', 'stimulusTimes', 'actionTimes', ...
                          'fWaves', 'waves', 'timeunit', 'meta');
        csvwrite(csvfilename, [responseTimes, stimulusTimes, actionTimes]);
    else
        % if the results exist, load them
        fprintf('\n [Found]: %s\n', matfilename)
        fprintf('\n Results already exist, skip computation.\n\n')
        load(matfilename, 'responseTimes')
    end
	% display summary
	fprintf(' no. of response: %d\n', length(responseTimes));
	fprintf(' mean response time: %.2f ms\n', mean(responseTimes));
	fprintf(' std. response time: %.2f ms\n',  std(responseTimes));
end
% the abf files needs manual check
chcklist = abflist(logical(chckfile));
if ~isempty(chcklist)
    fprintf('\n\n\n Please check the following records manually: \n\n')
    cellfun(@disp, chcklist);
end
diary off
