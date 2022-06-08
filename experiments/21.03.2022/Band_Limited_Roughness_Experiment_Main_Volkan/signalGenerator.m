%sp1 = pearsrnd(0, 1, 1, 3, 100000, 1);
%sm1 = pearsrnd(0, 1, -1, 3, 100000, 1);
%save('signals.mat', 'sp1', 'sm1')

condition = true;
sk1 = 1;
ku1 = 4;
sk2 = -1;
ku2 = 4;

cnt = 1;
while condition

    
    
    [sp1, sm1] = generateSignal(sk1, ku1, sk2, ku2);
    
    condition = ~(skewness(sp1) < sk1 * 1.05 &&...
        skewness(sp1) > sk1 * 0.95 &&...
        kurtosis(sp1) < ku1 * 1.05 &&...
        kurtosis(sp1) > ku1 * 0.95 &&...
        skewness(sm1) < sk2 * 0.95 &&...
        skewness(sm1) > sk2 * 1.05 &&...
        kurtosis(sm1) < ku2 * 1.05 &&...
        kurtosis(sm1) > ku2 * 0.95);
    
        cnt = cnt + 1
    
    
end

save('signals.mat', 'sp1', 'sm1')

skewness(sp1)
skewness(sm1)
kurtosis(sp1)
kurtosis(sm1)

function [sp1, sm1] = generateSignal(sk1, ku1, sk2, ku2)
%% Band limited white noise generation

% Filter parameters
Fp = 15;
Fst = 20;
Ap = 0.1;
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


sp1 = MBHTM(sampleFilteredScaled, sk1, ku1);

sm1 = MBHTM(sampleFilteredScaled, sk2, ku2);

end

