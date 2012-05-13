function [pulses, threshold] = findPulseInterval(wave)
% [pulses, threshold] = detPulseInterval(wave)
% add zeros in the first and last rows of wave
wave = [0; wave(:);0];
% find the bin with the maximum frequency
nbin = max([floor(max(wave)/0.1), 2]);
[bins xout] = hist(wave, nbin);
% calculate the threshold of low volt value
threshold = max(xout)*.5+min(xout)*.5;
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
gt200 = tail - head > 200;
% return a struct with heads and tails
pulses = struct('head', head(gt200), 'tail', tail(gt200));
%% plot the pusle: for debug use
% figure;plot(wave);hold on
% plot(head, wave(head), '^' )
% plot(tail, wave(tail), 'v')
