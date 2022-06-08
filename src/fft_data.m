function [frequency, amplitude_normalized_one_sided] = fft_data(signal, sampling_frequency)
%fft_data It takes FFT of the experimental data
%   Detailed explanation goes here

signal_length = length(signal);


% Amplitude of the FFT
amplitude = fft(signal);

amplitude_normalized = abs(amplitude / signal_length);
amplitude_normalized_one_sided = amplitude_normalized(1 : (signal_length/2) + 1);
amplitude_normalized_one_sided(2 : end - 1) = 2 * amplitude_normalized_one_sided(2 : end - 1);

frequency = sampling_frequency * (0 : (signal_length / 2)) / signal_length;

end

