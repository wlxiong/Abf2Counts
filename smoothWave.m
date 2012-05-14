function [smoothwave, avgwave] = smoothWave(wave, n)
% get the absolute values of the waves
abswave = abs(wave);
% average values
len = length(abswave);
nlen = floor(len/n);
meanwave = mean(reshape(abswave(1:nlen*n),n,nlen));
avgwave = meanwave(:);
% smooth the wave
smoothwave = smooth(avgwave,n*4);
