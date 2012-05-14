function [abflist, chcklist] = batchRun(apath, replace)
% batch run of conversion from abf to response time
% usage: 
% [abflist, chcklist] = batchRun(filename_string, replace);
% if replace = 1, overwrite the previous computed xls files
% if replace = 0, preserve the previous computed xls files
% examples: 
% [abflist, chcklist] = batchRun('E:\lzl_light_sound_association\101204\', 1);
% [abflist, chcklist] = batchRun('E:\lzl_light_sound_association\101204\', 0);
% [abflist, chcklist] = batchRun('E:\lzl_light_sound_association\', 1);
% 
[pathstr, name, ext] = fileparts(apath);
diary(fullfile(pathstr, 'abf2counts.log'))
diary on
if strcmp(ext, '.abf')
    abflist = struct('name', apath);
else
    abfpath = fullfile(pathstr, '**/', '*.abf');
    abflist = rdir(abfpath);
end
chckfile = zeros(length(abflist),1);
% create the big table
tabfilename = fullfile(pathstr, 'abf2counts.csv');
% write the table headings
ftab = fopen(tabfilename, 'w');
fprintf(ftab, 'file,waiting,moving,type\n');
fclose(ftab);
% append to the big table
ftab = fopen(tabfilename, 'a');
for p = 1:length(abflist)
    fprintf('\n *** %d/%d *** \n', p, length(abflist))
    % create the output filenames
	[pathstr, name, ext] = fileparts(abflist(p).name);
	matfilename = fullfile(pathstr, [name, '.mat']);
	csvfilename = fullfile(pathstr, [name, '.csv']);
    % check if the results already exist
    if replace || ~exist(matfilename, 'file')
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
        [probes, responses, mismatch, invalidate, abswaves] = abf2Counts(sortedwaves);
        chckfile(p) = invalidate;
        % export results
        save(matfilename, 'probes', 'responses', 'mismatch', 'invalidate', ...
                          'actionChInd', 'probeChInd', 'stimulusChInd', ...
                          'abswaves', 'timeunit', 'meta');
    else
        % if the results exist, load them
        fprintf('\n [Found]: %s\n', matfilename)
        fprintf('\n Results already exist, skip computation.\n\n')
        load(matfilename, 'probes', 'responses', 'mismatch')
    end
    % print results
    csvwrite(csvfilename, [probes.time, responses.time, mismatch]);
    fprintf(ftab, '%s,,,\n', name);
    fprintf(ftab, ',%d,%d,%d\n', [probes.time'; responses.time'; mismatch']);
	% display summary
	fprintf(' no. of waiting: %d\n', length(probes.time));
	fprintf(' mean waiting time: %.2f ms\n', mean(probes.time));
	fprintf(' std. waiting time: %.2f ms\n',  std(probes.time));
	fprintf(' no. of response: %d\n', length(responses.time(mismatch==0)));
	fprintf(' mean response time: %.2f ms\n', mean(responses.time(mismatch==0)));
	fprintf(' std. response time: %.2f ms\n',  std(responses.time(mismatch==0)));
end
fclose(ftab);
fprintf('\n *** The computation is finished. ***\n\n');
% the abf files needs manual check
chcklist = abflist(logical(chckfile));
if ~isempty(chcklist)
    fprintf('\n Please check the following files manually: \n\n')
    fprintf(' %s\n', chcklist.name);
end
diary off
