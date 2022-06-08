%% Setup related properties

L = 0.1; % 10 cm
v = 0.05; % 50 mm/sec
Fs = 5000; % Hz

%% Profile characteristics

q0 = 2 * pi / L; % It is always fixed, cannot move!
nPoints = floor((L ./ v) * Fs);
deltaX = L ./ nPoints;
qS = pi ./ deltaX; % It is also fixed

fMinLimit = 50;
fMaxLimit = 200;


HGridNumber = 2;
qLGridNumber = 2;

H = linspace(0, 1, HGridNumber);
qL = logspace(log10(2 * pi * fMinLimit / v), log10(2 * pi * fMaxLimit / v), qLGridNumber);

topography = -pi + (pi + pi) * rand(nPoints, 1);
rms = 1e0; % RMS roughness is 1 volt
%% Profile generation

for k = 1:length(H) % Loop for Hurst exponent

    for m = 1:length(qL) % Loop for qL

        [z{k, m}{1}{2}, pixelWidth(k, m), psd_(k, m)] = artificial_surf_1d_with_topography(1e0, H(k), L, nPoints, topography, qL(m));
        z{k, m}{1}{1} = linspace(0, L, nPoints);

        ixs1 = psd_(k, m).q > q0;% & psd_(k, m).q < qLimit ;
        psdDataset{k, m}{1}{1} = (psd_(k, m).q(ixs1));
        psdDataset{k, m}{1}{2} = (psd_(k, m).C(ixs1));

        psdDatasetLog{m, 1}{k}{1} = log10(psd_(k, m).q(ixs1));
        psdDatasetLog{m, 1}{k}{2} = log10(psd_(k, m).C(ixs1));

        [f, w] = fft_data(z{k, m}{1}{2}, Fs);
        ixs2 = f > 0; %f < fLimit;
        fftDataset{k, m}{1}{1} = (f(ixs2));
        fftDataset{k, m}{1}{2} = (w(ixs2));
        fftDatasetLog{m, 1}{k}{1} = log10(f(ixs2));
        fftDatasetLog{m, 1}{k}{2} = log10(w(ixs2));

        subtitle{k, m} = ['H = ' num2str(H(k), '%.2f') ' ' 'qL = ' num2str(qL(m), '%.2f')];
        subtitle_{m, 1} = ['qL = ' num2str(qL(m), '%.2f')];
        legend_{k, 1} = ['H = ' num2str(H(k), '%.2f')];
    end

end

%% Save signals

save('signals.mat', 'z', 'topography', 'psd_', 'pixelWidth');


%% Plot the profiles
folderName = 'figures2';
mkdir(folderName);

xlabel = 'Distance [m]';
ylabel = 'Amplitude [V]';
title = 'Profile for Different Hurst Exponent and qL Values';
legend = {};
figurePosition = [0 0 5000 6000];

p = {Plotter(z, 'figure_position', figurePosition, 'xlabel', xlabel, 'ylabel', ylabel, 'subtitle', subtitle, 'title', title, 'legend', legend, 'save_filename', ['./' folderName '/profile'], 'xlim', 'auto', 'xlim_type', 'all', 'ylim', 'auto', 'ylim_type', 'all', 'visibility', false), ...
        Plotter(psdDataset, 'figure_position', figurePosition, 'xlabel', 'q', 'ylabel', 'C', 'subtitle', subtitle, 'title', {}, 'legend', {}, 'save_filename', ['./' folderName '/psd'], 'xlim', 'auto', 'xlim_type', 'all', 'ylim', 'auto', 'ylim_type', 'all', 'visibility', false, 'plot_handle', @stem), ...
        Plotter(fftDataset, 'figure_position', figurePosition, 'xlabel', 'f', 'ylabel', 'w', 'subtitle', subtitle, 'title', {}, 'legend', {}, 'save_filename', ['./' folderName '/fft'], 'xlim', 'auto', 'xlim_type', 'all', 'ylim', 'auto', 'ylim_type', 'all', 'visibility', false, 'plot_handle', @stem), ...
        Plotter(psdDatasetLog, 'figure_position', [0 0 2000 4000], 'xlabel', 'log q', 'ylabel', 'log C', 'subtitle', subtitle_, 'title', {}, 'legend', legend_, 'save_filename', ['./' folderName '/psdLog'], 'xlim', 'auto', 'xlim_type', 'all', 'ylim', 'auto', 'ylim_type', 'all', 'visibility', false), ...
        Plotter(fftDatasetLog, 'figure_position', [0 0 2000 4000], 'xlabel', 'log f', 'ylabel', 'log w', 'subtitle', subtitle_, 'title', {}, 'legend', legend_, 'save_filename', ['./' folderName '/fftLog'], 'xlim', 'auto', 'xlim_type', 'all', 'ylim', 'auto', 'ylim_type', 'all', 'visibility', false)};

for k = 1:length(p)

    p{k}.plot();
    p{k}.save();

end
