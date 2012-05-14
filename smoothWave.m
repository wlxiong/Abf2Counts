function [smwave, avgwave] = smoothWave(wave, n)
% average values
len = length(wave);
nlen = floor(len/n)*n;
mwave = mean(reshape(wave(1:nlen),n,floor(len/n)));
avgwave = mwave(:);
% smooth the wave
smwave = smooth(avgwave,n*4);
