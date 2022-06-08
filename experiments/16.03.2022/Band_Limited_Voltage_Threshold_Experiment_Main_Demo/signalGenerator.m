%sp1 = pearsrnd(0, 1, 1, 3, 100000, 1);
%sm1 = pearsrnd(0, 1, -1, 3, 100000, 1);
%save('signals.mat', 'sp1', 'sm1')

%% Band limited white noise generation

% Filter parameters
Fp = 0.1;
Fst = 100;
Ap = 0.5;
Ast = 40;
Fs = 5000;
N = 5e4;

% Signal design
d = fdesign.lowpass('Fp,Fst,Ap,Ast',Fp, Fst, Ap, Ast, Fs);
% d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',100,500,600,800,1e3,1e4);
d.Fs = Fs;
B = design(d);

% Create white Gaussian noise the length of your signal
sample = randn(N, 1);
% Create the band-limited Gaussian noise
% Since it is filtered and does not cover the whole
% frequency range, it is not correct to name as white noise. Now,
% it is just Gaussian noise, not white.
sampleFiltered = filter(B,sample);
sampleFilteredScaled = sampleFiltered * sqrt(var(sample) / var(sampleFiltered));

%% Turn into non-Gaussian process

sk = 1;
ku = 4;
sp1 = MBHTM(sampleFilteredScaled, sk, ku);

sk = -1;
ku = 4;
sm1 = MBHTM(sampleFilteredScaled, sk, ku);

save('signals.mat', 'sp1', 'sm1')
