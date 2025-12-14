function [clean_symbols] = BPSK_equalizer(rx_signal, N_header)
% Uso geral: Equalização básica de ganho de uma constelação BPSK
    arguments (Input)
        rx_signal (1,:) double  
        N_header (1,1) double
    end
    
    rx_signal = rx_signal(:).'; 
    rx_train = rx_signal(1:N_header);
    
    % Calcula a compensação de amplitude
    rx_amplitude_mean = mean(abs(rx_train)); 
    ideal_amplitude = 1;
    agc_gain_factor = ideal_amplitude / rx_amplitude_mean;
    
    % Aplica a Correção de Amplitude ao Sinal Total
    symbols_agc_corrected = rx_signal * agc_gain_factor;
    
    % O BPSK reside no eixo Real. O ruído na componente Imaginária
    % deve ser explicitamente descartado.
    clean_symbols = real(symbols_agc_corrected);
end