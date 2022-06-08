N = 4;
n = N/2;
trials = [ones(n, 1); -1*ones(n,1)];
rp = randperm(N);
trials = trials(rp);
trials = [trials -trials];
save('trials.mat', 'trials')