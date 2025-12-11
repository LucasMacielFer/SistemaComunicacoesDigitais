function [eq_grid, ch_estimation] = OFDM_equalizer(neq_grid, params)
%OFDM_EQUALIZE Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    neq_grid
    params
end

    [n_rows_grid, num_cols] = size(neq_grid); % Isso vai dar 64
    
    idx_pilots = params.idx_pilots; % Índices lógicos (baseados em 64)
    val_pilots = params.val_pilots;
    
    % Matriz de equalização com o tamanho correto (64 x Blocos)
    H_est_full = ones(n_rows_grid, num_cols);
    
    if ~isempty(idx_pilots)
        % 1. Extrair pilotos recebidos
        rx_pilots = neq_grid(idx_pilots, :);
        
        % 2. Estimar Canal (H = Rx / Tx)
        H_pilots = rx_pilots ./ val_pilots;
        
        % 3. Interpolar
        % O eixo de interpolação deve ter o tamanho dos dados (64), não da FFT física (512)
        all_carriers = (1:n_rows_grid).'; 
        
        for i = 1:num_cols
            H_est_full(:, i) = interp1(idx_pilots, H_pilots(:, i), all_carriers, 'linear', 'extrap');
        end
    end
    
    % APLICA A CORREÇÃO
    eq_grid = neq_grid ./ H_est_full;
    ch_estimation = H_est_full(:, 1);
end