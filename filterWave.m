function filtered = filterWave(wave, n)

len = length(wave);
nlen = floor(len/n)*n;
nwave = mean(reshape(wave(1:nlen),n,floor(len/n)));
filtered = nwave(:);