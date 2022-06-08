tStart = 0;
tEnd = 10;
Fs = 5000;
t = tStart:1/Fs:tEnd;
f = 30;

sp1 = (1.6/sqrt(3)) + (1.6/sqrt(3)) * sin(2 * pi * f * t)';
sm1 = -(1.6/sqrt(3)) + (1.6/sqrt(3)) * sin(2 * pi * f * t)';
save('signals.mat', 'sp1', 'sm1');