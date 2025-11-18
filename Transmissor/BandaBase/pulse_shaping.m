function [tx_signal, h_rrc, delay_samples] = pulse_shaping(symbols, N)
% Função utilizada para aplicar um filtro RRC para modelar o pulso NRZ
% codificado.    
arguments (Input)
    symbols (:,:) double                % Coeficientes após mapeamento
    N {mustBeMember(N, [1, 4, 8, 16])}  % Coeficiente NRZ
end
    % --- 1. PARÂMETROS FIXOS DO SISTEMA ---
    SPB = 15;        % Amostras por Bit (Fixo)
    ALPHA = 0.25;    % Fator de Roll-off (Padrão)
    SPAN = 10;       % Duração do filtro em símbolos (Padrão)
    
    switch N
            case 1,  k = 1; % BPSK
            case 4,  k = 4; % 16-QAM
            case 8,  k = 6; % 64-QAM (log2(64)=6)
            case 16, k = 8; % 256-QAM (log2(256)=8)
            otherwise, error('Nível de modulação não suportado.');
    end

    SPS = SPB * k;

    h_rrc = rcosdesign(ALPHA, SPAN, SPS, 'sqrt');

    sinal_filtrado = upfirdn(symbols, h_rrc, SPS, 1);
    delay_samples = (SPAN * SPS) / 2;

    L_input_syms = size(symbols, 2); % Número de símbolos no input
    L_target_samples = L_input_syms * SPS;     % Comprimento total desejado

    % Trunca o início (Delay) e mantém APENAS os L_target_samples seguintes
    tx_signal = sinal_filtrado(:, delay_samples + 1 : delay_samples + L_target_samples);
end