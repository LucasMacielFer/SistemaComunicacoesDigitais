addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\FonteDeDados'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\BandaBase'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\Modulacao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\Demodulacao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\BandaBase'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\Reconstrucao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Canal'

bits = [0 0 0 1 1 1 0 0 1 1 0 1 0 1 0 1];

[t, symbols, digital_wave] = NRZ_polar_BPSK(bits);
modulated = modulate_dirty(digital_wave, [], t, 0.02, 10, 100e3);
ruined_signal = canal(modulated, t, 4, 10);

fs = 2e6; 
f_cut = 20e3;
Fc = 100e3;
demod = ruined_signal .* cos(2*pi*Fc*t)*2;
[b, a] = butter(5, f_cut/(fs/2));
filtered_wave = filtfilt(b, a, demod);

subplot(4,1,1)
plot(t, digital_wave);
subplot(4,1,2)
plot(t, modulated);
subplot(4,1,3)
plot(t, ruined_signal)
subplot(4,1,4)
plot(filtered_wave)