addpath 'C:\Users\lucas\OneDrive\Documents\MATLAB\CD\TRABALHO\Transmissor\FonteDeDados'
addpath 'C:\Users\lucas\OneDrive\Documents\MATLAB\CD\TRABALHO\Transmissor\BandaBase'
addpath 'C:\Users\lucas\OneDrive\Documents\MATLAB\CD\TRABALHO\Transmissor\Modulacao'

fonteDeDadosApp = FonteDeDados();
waitfor(fonteDeDadosApp, 'doneFlag', true);
[TXData, TXType] = fonteDeDadosApp.getData();
delete(fonteDeDadosApp);

TXSize = size(TXData);
if TXSize(2) < 16
    TXSample = TXData(1,1:TXSize(2));
else
    TXSample = TXData(1,1:16);
end

bandaBaseApp = banda_base();
bandaBaseApp.setDemoData(TXSample);
waitfor(bandaBaseApp, 'done_flag', true);
[t, Iwave, Qwave] = bandaBaseApp.toModulation();
[conv, pulse, N_levels, g1, g2] = bandaBaseApp.getParams();
delete(bandaBaseApp);

Imod = modulate_cos(Iwave, t);
if ~isempty(Qwave)
    Qmod = modulate_sin(Qwave, t);
    mod = Imod + Qmod;
end

for i=1:TXSize(1)
    if conv
        data = conv_encoder(TXData(i,:), g1, g2);
    else
        data = TXData(i,:);
    end
    
    switch N_levels
        case 1
            [tempo, coeffs_I, wave_I] = NRZ_polar_BPSK(data);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 1);
            end
            wave = modulate_cos(wave_I, tempo);
            k = 1;
        case 4
            [tempo, coeffs_I, coeffs_Q, wave_I, wave_Q] = NRZ_polar_QAM(data, 4);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 4);
                [wave_Q, ~, ~] = pulse_shaping_filter(coeffs_Q, 4);
            end
            wave = modulate_cos(wave_I, tempo) + modulate_sin(wave_Q, tempo);
            k = 4;
        case 8
            [tempo, coeffs_I, coeffs_Q, wave_I, wave_Q] = NRZ_polar_QAM(data, 8);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 8);
                [wave_Q, ~, ~] = pulse_shaping_filter(coeffs_Q, 8);
            end
            wave = modulate_cos(wave_I, tempo) + modulate_sin(wave_Q, tempo);
            k = 6;
        case 16
            [tempo, coeffs_I, coeffs_Q, wave_I, wave_Q] = NRZ_polar_QAM(data, 16);
            if pulse
                [wave_I, ~, ~] = pulse_shaping_filter(coeffs_I, 16);
                [wave_Q, ~, ~] = pulse_shaping_filter(coeffs_Q, 16);
            end
            wave = modulate_cos(wave_I, tempo) + modulate_sin(wave_Q, tempo);
            k = 8;
    end
    disp("Linha " + i + " transmitida!");
end

% Criando o vetor para eixo x dos gráficos das ffts
L = size(Imod);
L = L(2);
f = (0:L-1)*(2e6/L); % f = (Fsimulação*indice_vetor)/Npontos

subplot(3,2,1);
plot(t, Imod);
title('In-phase Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,2,2);
plot(f, abs(fft(Imod)));
title('In-phase modulated Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
if ~isempty(Qwave)
    subplot(3,2,3);
    plot(t, Qmod);
    title('Quadrature Modulated Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    subplot(3,2,4);
    plot(f, abs(fft(Imod)));
    title('Quadrature modulated Signal FFT');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    subplot(3,2,5);
    plot(t, mod);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Transmitted Modulated Signal');
    subplot(3,2,6);
    plot(f, abs(fft(Imod)));
    title('Transmitted modulated Signal FFT');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
end

% Lowpass para extrar o sinal filtrado em rrc
% Mudar a frequencia da portadora