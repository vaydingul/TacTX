sgn = idinput([1000, 1], 'prbs', [0 1/5], [-3 3]);
u = iddata([], sgn, 1);
plot(u)