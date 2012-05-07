function [timelist, chcklist, abflist] = batchRun(apath, replace)
% batch run of conversion from abf to response time
% usage: 
% [timelist, chckfile, abflist] = batchRun(filename_string, replace);
% if replace = 1, overwrite the previous computed xls files
% if replace = 0, preserve the previous computed xls files
% examples: 
% [timelist, chckfile, abflist] = batchRun('E:\lzl_light_sound_association\101204\', 1);
% [timelist, chckfile, abflist] = batchRun('E:\lzl_light_sound_association\101204\', 0);
% [timelist, chckfile, abflist] = batchRun('E:\lzl_light_sound_association\', 1);
% 
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
        % extract channel 9, 10 and 15
        [waves0,timeunit0,meta0] = abfload2(abflist(p).name, 'info');
        actionChInd   = find(cellfun(@length, strfind(meta0.recChNames, '9')));
        probeChInd    = find(cellfun(@length, strfind(meta0.recChNames, '10')));
        stimulusChInd = find(cellfun(@length, strfind(meta0.recChNames, '15')));
        % if any channel cannot found, go to next file
        if isempty(actionChInd) || isempty(probeChInd) || isempty(stimulusChInd)
            warning(' Not enough input channels.')
            continue
        end
        % import data
        fprintf('\n [Importing]: %s\n\n', abflist(p).name)
        [waves,timeunit,meta] = abfload2(abflist(p).name);
        % process data
        fprintf('\n [Processing]: %s\n\n', abflist(p).name)
        sortedwaves = [waves(:,actionChInd), waves(:,probeChInd), waves(:,stimulusChInd)];
        [responseTimes, stimulusTimes, actionTimes, abswaves, manyzero] = abf2Counts(sortedwaves);
        timelist{p} = responseTimes;
        chckfile(p) = manyzero;
        % export results
        save(matfilename, 'responseTimes', 'stimulusTimes', 'actionTimes', ...
                          'actionChInd', 'probeChInd', 'stimulusChInd', ...
                          'abswaves', 'waves', 'timeunit', 'meta');
        csvwrite(csvfilename, [responseTimes, stimulusTimes, actionTimes]);
    else
        % if the results exist, load them
        fprintf('\n [Found]: %s\n', csvfilename)
        fprintf('\n [Found]: %s\n', matfilename)
        fprintf('\n Results already exist, skip computation.\n\n')
        load(matfilename, 'responseTimes')
    end
	% display summary
	fprintf(' no. of response: %d\n', length(responseTimes));
	fprintf(' mean response time: %.2f ms\n', mean(responseTimes));
	fprintf(' std. response time: %.2f ms\n',  std(responseTimes));
end
fprintf('\n *** The computation is finished. ***\n\n');
% the abf files needs manual check
chcklist = abflist(logical(chckfile));
if ~isempty(chcklist)
    fprintf('\n Please check the following files manually: \n\n')
    fprintf(' %s\n', chcklist.name);
end
diary off
