function rx_bb = demodulate_OFDM(rx_signal, t, Fc)
% Uso geral: Demodulação de um sinal transmitido em OFDM para banda-base
% complexa.
arguments (Input)
    rx_signal       
    t               
    Fc = 400e3     
end

    rx_signal = rx_signal(:);
    t = t(:);

    dt = t(2) - t(1);
    Fs = 1 / dt;

    % Mistura IQ (Downconversion)
    rx_I_mix = rx_signal .* cos(2 * pi * Fc * t);
    rx_Q_mix = rx_signal .* -sin(2 * pi * Fc * t);

    % Filtragem Passa-Baixas (Low Pass Filter)
    % Precisamos remover a imagem espectral que aparece em 2*Fc.
    
    f_cut = Fc; % Frequência de corte
    
    % Normaliza para Nyquist (Fs/2)
    Wn = f_cut / (Fs/2);
    
    % Proteção: O corte não pode ser maior que Nyquist
    if Wn >= 1
        Wn = 0.99; 
    end
    
    % Filtro Butterworth de 5ª ordem
    [b, a] = butter(5, Wn);
    
    % Aplicamos filtfilt para não ter atraso de fase (Zero-Phase Filtering)
    % Multiplicamos por 2 para recuperar a amplitude perdida na mistura (0.5)
    rx_I = filtfilt(b, a, rx_I_mix) * 2;
    rx_Q = filtfilt(b, a, rx_Q_mix) * 2;

    % 5. Reconstrução do Sinal Complexo (Banda Base)
    rx_bb = rx_I + 1i * rx_Q;
end