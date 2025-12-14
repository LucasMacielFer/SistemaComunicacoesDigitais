function [symbols] = demodulate_single_carrier(wave, t, N_levels, Fc)
% Uso geral: Demodular uma sinal transmitido em single carrier
arguments(Input)
    wave 
    t
    N_levels {mustBeMember(N_levels, [1, 2, 4, 8, 16])}
    Fc = 100e3
end

    % Mistura IQ - Downconversion
    wave_I = wave .* cos(2*pi*Fc*t)*2;
    if N_levels > 1
        wave_Q = wave .* -sin(2*pi*Fc*t)*2;
    else
        wave_Q = zeros(1, length(wave_I));
    end

    switch N_levels
            case 1,  k = 1; % BPSK
            case 2,  k = 2; % QPSK
            case 4,  k = 4; % 16-QAM
            case 8,  k = 6; % 64-QAM (log2(64)=6)
            case 16, k = 8; % 256-QAM (log2(256)=8)
            otherwise, error('Nível de modulação não suportado.');
    end

    SPB = 200; % Samples per bit
    SPS = SPB*k;
    
    % Quebra o sinal em blocos (cada bloco, um símbolo)
    start_idx = 1;
    idx_amostragem = SPS : SPS : length(wave_I);

    num_symbols = length(idx_amostragem);
    I_final = zeros(1, num_symbols);
    Q_final = zeros(1, num_symbols);

    % Filtro casado - integra o sinal NRZ
    for i=1:length(idx_amostragem)
        I_final(1,i) = trapz(wave_I(start_idx:idx_amostragem(i)))/SPS;
        Q_final(1,i) = trapz(wave_Q(start_idx:idx_amostragem(i)))/SPS;
        start_idx = idx_amostragem(i)+1;
    end

    symbols = I_final + 1i * Q_final;
end