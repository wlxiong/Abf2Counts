function [abflist, chklist] = batchRun(apath, replace)
% batch run of conversion from abf to response time
% usage: 
% [abflist, chklist] = batchRun(filename_string, replace);
% if replace = 1, overwrite the previous computed xls files
% if replace = 0, preserve the previous computed xls files
% examples: 
% [abflist, chklist] = batchRun('E:\lzl_light_sound_association\101204\', 1);
% [abflist, chklist] = batchRun('E:\lzl_light_sound_association\101204\', 0);
% [abflist, chklist] = batchRun('E:\lzl_light_sound_association\', 1);
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
chkfile = zeros(length(abflist),1);
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
        % calculate the moving-average values
        avgspan = floor(1000.0/timeunit);
        [actionWave, avgActionWave]     = smoothWave(waves(:,actionChInd), avgspan);
        [probeWave, avgProbeWave]       = smoothWave(waves(:,probeChInd), avgspan);
        [stimulusWave, avgStimulusWave] = smoothWave(waves(:,stimulusChInd), avgspan);
        % extract pusles from each wave
        [actionPulses, lowa]   = findPulseInterval(actionWave);
        [probePulses, lowp]    = findPulseInterval(probeWave);
        [stimulusPulses, lows] = findPulseInterval(stimulusWave);
        % calculate response times
        [probes, responses, mismatch] = calcReponseTime(stimulusPulses,probePulses,actionPulses);
        % export results
        avgwaves = [avgStimulusWave,avgProbeWave,avgActionWave];
        save(matfilename, 'probes', 'responses', 'mismatch', ...
                          'actionChInd', 'probeChInd', 'stimulusChInd', ...
                          'avgwaves', 'timeunit', 'meta');
    else
        % if the results exist, load them
        fprintf('\n [Found]: %s\n', matfilename)
        fprintf('\n Results already exist, skip computation.\n\n')
        load(matfilename, 'probes', 'responses', 'mismatch')
    end
    % check if the response rate is lower than 0.5
    chkfile(p) = sum(mismatch==0) <= 0.5*length(mismatch);
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
chklist = abflist(logical(chkfile));
if ~isempty(chklist)
    fprintf('\n Please check the following files manually: \n\n')
    fprintf(' %s\n', chklist.name);
end
diary off
