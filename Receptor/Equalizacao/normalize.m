function norm_symbols = normalize(symbols)
% Uso geral: Normalizar os símbolos recebidos com base na energia média de 
% símbolo (para que ela seja 1)
    rx_power = mean(abs(symbols).^2);
    agc_gain = 1 / sqrt(rx_power);
    norm_symbols = symbols * agc_gain;
end