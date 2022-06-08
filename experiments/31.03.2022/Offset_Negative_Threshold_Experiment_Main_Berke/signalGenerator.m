tStart = 0;
tEnd = 10;
Fs = 5000;
t = tStart:1/Fs:tEnd;
f = 15;

sp1 = 1 + (1 * sin(2 * pi * f * t)');
sm1 = -1 + (1 * sin(2 * pi * f * t)');
save('signals.mat', 'sp1', 'sm1');