function [clean_symbols] = BPSK_equalizer(rx_signal, N_header)
    % BPSK_EQUALIZE: Versão simplificada. Foca apenas em AGC e Projeção Real.
    
    arguments (Input)
        rx_signal (1,:) double  
        N_header (1,1) double
    end
    
    rx_signal = rx_signal(:).'; 
    rx_train = rx_signal(1:N_header);
    
    % --- 1. COMPENSAÇÃO DE AMPLITUDE (AGC ESTÁTICO) ---
    
    % A. Calcular a Amplitude Média (Módulo) no Header
    rx_amplitude_mean = mean(abs(rx_train)); 
    ideal_amplitude = 1;
    agc_gain_factor = ideal_amplitude / rx_amplitude_mean;
    
    % B. Aplicar a Correção de Amplitude ao Sinal Total
    symbols_agc_corrected = rx_signal * agc_gain_factor;
    
    % --- 2. PROJEÇÃO FINAL E SAÍDA (Onde a Perda de SNR é combatida) ---
    
    % O BPSK reside no eixo Real. O ruído na componente Imaginária
    % deve ser explicitamente descartado.
    
    clean_symbols = real(symbols_agc_corrected);
    
    % Nota: Se o seu BER não se altera, significa que o seu slicer
    % já estava a aplicar implicitamente o 'real(input)' e o 'normalize'.
    % A solução para o déficit de SNR deve ser no Slicer/Demapper,
    % e não nesta função.
end