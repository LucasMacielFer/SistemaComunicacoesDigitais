function received_symbols = OFDM_demodulate(equalized_grid, ofdm_params)
% OFDM_demodulate: Extrai dados de uma grade já processada.
% Não faz FFT nem equalização. Apenas extrai.

arguments(Input)
    equalized_grid  % Matriz [N_fft x Blocos]
    ofdm_params     % Struct do modulador
end

    % 1. Onde estão os dados?
    idx_data = ofdm_params.idx_data;
    
    % 2. Extração
    data_grid = equalized_grid(idx_data, :);
    
    % 3. Serialização
    received_symbols = data_grid(:);
end