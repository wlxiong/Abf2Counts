figure
nbin = floor(sqrt(size(wave,1)));
[n, xout] = hist(wave, nbin);
[c i] = max(n);
threshold = (xout(i) + xout(i+1))/2.0;
axis([0.15 .2 0 160000])

figure
hist(wave(2:160000,2), 1000);
axis([0 .3 0 160000])

figure
hist(wave(3:160000,3), 1000);
axis([0 .1 0 160000])