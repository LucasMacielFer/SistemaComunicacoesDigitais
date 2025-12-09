function [tx_rf, t] = modulate_single_carrier(wave_I, wave_Q, t, phase_std, doppler_freq, Fc)
% Modulação do sinal em banda-base com desvio de fase e ruido doppler
arguments (Input)
    wave_I
    wave_Q
    t
    phase_std       % Intensidade do desvio de fase (de 0 a 1)
    doppler_freq    % Desvio doppler em Hertz
    Fc = 100e3
end
    wave_I = wave_I(:);
    wave_Q = wave_Q(:);
    t = t(:);
    
    % Verificação de consistência
    if length(wave_I) ~= length(t)
        error('O vetor de tempo "t" e o sinal "wave_I" devem ter o mesmo tamanho.');
    end

    BPSK = false;
    if isempty(wave_Q) % BPSK
        BPSK = true;
    end
    
    phase_jitter = cumsum(randn(size(t))) * phase_std;
    phase_doppler = 2 * pi * doppler_freq * t;
    total_phase = (2 * pi * Fc * t) + phase_jitter + phase_doppler;

    if BPSK
        tx_rf = wave_I .* cos(total_phase);
    else
        tx_rf = wave_I .* cos(total_phase) - wave_Q .* sin(total_phase);
    end
    tx_rf = tx_rf.';
end