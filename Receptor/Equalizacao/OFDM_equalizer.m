function [eq_grid, ch_estimation] = OFDM_equalizer(neq_grid, params)
% Uso geral: Equalizar uma constelação OFDM, de modo a remover a rotação 
% causada pelo canal multipercurso e a deriva de frequência causada
% pelo desvio doppler. Diferente do caso das transmissões single-carrier,
% aqui é feita uma estimação do canal!
    
arguments (Input)
    neq_grid
    params
end

    [n_rows_grid, num_cols] = size(neq_grid);
    
    idx_pilots = params.idx_pilots;
    val_pilots = params.val_pilots;
    
    H_est_full = ones(n_rows_grid, num_cols);
    
    if ~isempty(idx_pilots)
        % 1. Extrair pilotos recebidos
        rx_pilots = neq_grid(idx_pilots, :);
        
        % 2. Estimar Canal (H = Rx / Tx)
        H_pilots = rx_pilots ./ val_pilots;
        
        % 3. Interpolar
        all_carriers = (1:n_rows_grid).'; 
        
        for i = 1:num_cols
            H_est_full(:, i) = interp1(idx_pilots, H_pilots(:, i), all_carriers, 'linear', 'extrap');
        end
    end
    
    % APLICA A CORREÇÃO
    eq_grid = neq_grid ./ H_est_full;
    ch_estimation = H_est_full(:, 1);
end