
d = daq("ni");

%% Add Channels
% Add channels and set channel properties, if any.

addinput(d,"Dev1","ai0","Voltage");
addinput(d,"Dev1","ai1","Voltage");
addinput(d,"Dev1","ai2","Voltage");
addinput(d,"Dev1","ai3","Voltage");
addinput(d,"Dev1","ai4","Voltage");
addinput(d,"Dev1","ai5","Voltage");

%% Read Data to bias sensor
% Read the data in timetable format.
d.Rate = 1000;
data = read(d,seconds(1), 'OutputFormat', 'Matrix');

GainMatrix=[-0.008988558	0.01636383	-0.016207209	1.709100556	-0.010353274	-1.714581856
            0.064670016	-2.188230603	-0.010510775	0.972092909	-0.015269682	1.041792839
            1.805711459	0.007669575	1.526170728	-0.045459199	1.933470965	-0.025708347
            0.306797685	-13.27323888	8.678856758	5.656698914	-11.02508507	6.469202187
            -11.5890942	-0.100412191	5.1181421	-10.5413148	6.505246556	10.32580521
            0.136561278	-7.586013116	0.21378772	-7.246447361	-0.092033948	-7.061610822];
 
data_mean = mean(data, 1);

%% Add output channels 

addoutput(d,"Dev2","ao1","Voltage");
%%
outputSignal = idinput([1000, 1], 'prbs', [0 1/20], [-3 3]);

numCycles = 2;
outputSignal = repmat(outputSignal,numCycles,1);


%% Main process

disp("NOW");
[data_, startTime] = readwrite(d, outputSignal, 'OutputFormat', 'Matrix');


%% Preprocess

data_force = (GainMatrix * (data_ - data_mean)')';


%% Plotting

figure;
yyaxis left
plot(data_force(:, 3));
yyaxis right
plot(outputSignal);
