function [tx_rf, t] = modulate_single_carrier(wave_I, wave_Q, t, phase_std, doppler_freq, Fc)
% Uso Geral: Modula um sinal digital em banda-base (I/Q) para radiofrequência (RF), 
% adicionando desvio de fase (jitter) e desvio Doppler.
arguments (Input)
    wave_I          % Componente I (In-phase) do sinal banda-base.
    wave_Q          % Componente Q (Quadrature) do sinal banda-base.
    t               % Vetor de tempo.
    phase_std       % Desvio padrão para o ruído de fase (jitter).
    doppler_freq    % Desvio de frequência Doppler em Hertz.
    Fc = 100e3      % Frequência portadora (padrão 100 kHz).
end
    wave_I = wave_I(:); % Garante que I seja vetor coluna.
    wave_Q = wave_Q(:); % Garante que Q seja vetor coluna.
    t = t(:); % Garante que o tempo seja vetor coluna.
    
    % Verificação de consistência
    if length(wave_I) ~= length(t)
        error('O vetor de tempo "t" e o sinal "wave_I" devem ter o mesmo tamanho.');
    end

    BPSK = false;
    if isempty(wave_Q) % Verifica se a modulação é BPSK (sem componente Q)
        BPSK = true;
    end
    
    phase_jitter = cumsum(randn(size(t))) * phase_std; % Gera ruído de fase aleatório acumulado.
    phase_doppler = 2 * pi * doppler_freq * t; % Cálculo da fase gerada pelo desvio Doppler.
    total_phase = (2 * pi * Fc * t) + phase_jitter + phase_doppler; % Fase instantânea total.
    
    if BPSK
        tx_rf = wave_I .* cos(total_phase); % Modulação BPSK (apenas componente I).
    else
        % Modulação QAM/QPSK: I*cos(fase) - Q*sin(fase).
        tx_rf = wave_I .* cos(total_phase) - wave_Q .* sin(total_phase);
    end
    
    tx_rf = tx_rf.'; % Garante que a saída seja um vetor linha.
end