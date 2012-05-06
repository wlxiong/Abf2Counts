function [pulses, threshold] = findPulseInterval(wave)
% [pulses, threshold] = detPulseInterval(wave)
% add zeros in the first and last rows of wave
wave = [0; wave(:);0];
% find the bin with the maximum frequency
nbin = floor(sqrt(length(wave)));
[bins xout] = hist(wave, nbin);
[mvalue mindex] = max(bins(1:int32(nbin/2)));
% calculate the threshold of low volt value
threshold = abs(xout(mindex+floor(sqrt(nbin/2))));
%% detect the pulses for each wave
wave( abs(wave) >  threshold  ) = max(wave);
wave( abs(wave) <= threshold  ) = 0.0;
vjump = max(wave) - threshold;
head = find( diff(wave) >  vjump );
tail = find( diff(wave) < -vjump ) + 1;
% asset if the number of pulse heads is equal to that of tail
if length(head) ~= length(tail)
    error('Pulses cannot be detected.');
end
% return a struct with heads and tails
pulses = struct('head', head, 'tail', tail);
%% plot the pusle: for debug use
% figure;plot(wave);hold on
% plot(head, wave(head), '^' )
% plot(tail, wave(tail), 'v')
