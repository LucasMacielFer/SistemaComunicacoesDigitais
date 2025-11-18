function [rx_symbols] = matched_filter(rx_signal, sps, rolloff, span)
% Função para aplicar o "filtro casado" ao sinal demodulado para obter os
% símbolos
    arguments
        rx_signal (:,:) double
        sps (1,1) {mustBeInteger, mustBePositive}
        rolloff (1,1) {mustBeNumeric} = 0.25
        span (1,1) {mustBeInteger} = 10
    end

    filter_coeffs = rcosdesign(rolloff, span, sps, 'sqrt');
    rx_filtered = filter(filter_coeffs, 1, rx_signal);
    total_delay = span * sps;
    rx_symbols = rx_filtered(total_delay + 1 : sps : end, :);
end