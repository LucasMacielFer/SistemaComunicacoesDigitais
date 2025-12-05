function rx_bb = demodulate_OFDM(rx_signal, t, Fc)
% DEMODULATE_OFDM Converte sinal Passa-Banda para Banda Base Complexa.
% O sinal de saída deve ser alimentado ao 'OFDM_prepare_grid'.
arguments (Input)
    rx_signal       % Sinal real (Passa-Banda) vindo do canal
    t               % Vetor de tempo
    Fc = 400e3      % Frequência da portadora (Default: 400kHz)
end

    % 1. Garantir vetores coluna
    rx_signal = rx_signal(:);
    t = t(:);

    % 2. Descobrir a Taxa de Amostragem (Fs)
    % Necessário para projetar o filtro corretamente
    % Fs = 2e6;
    dt = t(2) - t(1);
    Fs = 1 / dt;

    % 3. Mistura IQ (Downconversion)
    % Multiplicamos por cos e -sin para separar I e Q
    rx_I_mix = rx_signal .* cos(2 * pi * Fc * t);
    rx_Q_mix = rx_signal .* -sin(2 * pi * Fc * t);

    % 4. Filtragem Passa-Baixas (Low Pass Filter)
    % Precisamos remover a imagem espectral que aparece em 2*Fc.
    % Vamos cortar em Fc (assumindo que o sinal OFDM é mais estreito que a portadora).
    
    f_cut = Fc; % Frequência de corte
    
    % Normaliza para Nyquist (Fs/2)
    Wn = f_cut / (Fs/2);
    
    % Proteção: O corte não pode ser maior que Nyquist
    if Wn >= 1
        Wn = 0.99; 
    end
    
    % Filtro Butterworth de 5ª ordem (padrão robusto)
    [b, a] = butter(5, Wn);
    
    % Aplicamos filtfilt para não ter atraso de fase (Zero-Phase Filtering)
    % Multiplicamos por 2 para recuperar a amplitude perdida na mistura (0.5)
    rx_I = filtfilt(b, a, rx_I_mix) * 2;
    rx_Q = filtfilt(b, a, rx_Q_mix) * 2;

    % 5. Reconstrução do Sinal Complexo (Banda Base)
    rx_bb = rx_I + 1i * rx_Q;
end