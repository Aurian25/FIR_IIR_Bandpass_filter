% Let the user choose an audio file using a file picker dialog
[filename, filepath] = uigetfile('*.wav', 'studio.wav');

% Construct the full file path
fullFilePath = fullfile(filepath, filename);

% Read the selected audio file
[y, Fs] = audioread(fullFilePath);

% IIR Bandpass Filter Design
iirBPFilt = designfilt('bandpassiir', 'FilterOrder', 100, ...
                       'HalfPowerFrequency1', 20, 'HalfPowerFrequency2', 1650, ...
                       'SampleRate', Fs);  % Use the same Fs as the input audio

dataIn = y;
iirDataOut = filter(iirBPFilt, dataIn);

% FIR Bandpass Filter Design
firBPFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
                       'CutoffFrequency1',20, 'CutoffFrequency2',1450, ...
                       'SampleRate', Fs);  % Use the same Fs as the input audio

firDataOut = filter(firBPFilt, dataIn);

% Playing audio
sound(y, Fs)        % Input audio
pause(3)
sound(iirDataOut, Fs)  % IIR bandpass filtered audio
pause(3)
sound(firDataOut, Fs)  % FIR bandpass filtered audio

% Time Domain Plots
t = (0:length(y) - 1) / Fs;  % Time vector for the original audio

subplot(3,2,1)
plot(t, y)
xlabel('Time (s)')
ylabel('Magnitude')
title('Original Audio')
grid on

t_filtered = (0:length(iirDataOut) - 1) / Fs;  % Time vector for the filtered audio

subplot(3,2,5)
plot(t_filtered, iirDataOut)
xlabel('Time (s)')
ylabel('Magnitude')
title('IIR Filtered Audio')
grid on

subplot(3,2,3)
plot(t_filtered, firDataOut)
xlabel('Time (s)')
ylabel('Magnitude')
title('FIR Filtered Audio')
grid on

% FFT and Frequency Visualization
fs = Fs;  % Use the sampling frequency of the input audio
nfft = 2048;
f = linspace(0, fs, nfft);
Y = abs(fft(y, nfft));

subplot(3,2,2)
plot(f(1:nfft/2), Y(1:nfft/2))
xlabel('Frequency')
ylabel('Magnitude')
title('Original Audio')
grid on

Y = abs(fft(iirDataOut, nfft));

subplot(3,2,6)
plot(f(1:nfft/2), Y(1:nfft/2))
xlabel('Frequency')
ylabel('Magnitude')
title('IIR FILTER')
grid on

Y = abs(fft(firDataOut, nfft));

subplot(3,2,4)
plot(f(1:nfft/2), Y(1:nfft/2))
xlabel('Frequency')
ylabel('Magnitude')
title('FIR FILTER')
grid on