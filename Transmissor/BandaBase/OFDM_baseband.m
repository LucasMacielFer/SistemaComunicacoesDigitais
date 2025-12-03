function [tx_signal, ofdm_params] = OFDM_baseband(symbols, N_carriers, N_pilots_target)
arguments(Input)
    symbols
    N_carriers {mustBeMember(N_carriers, [64, 128, 256])}
    N_pilots_target double = 4
end   

    symbols_col = symbols(:);

    % Nem todas as bandas serão para dados. Algumas bandas serão de guarda
    % e outras serão usadas para transmissão de "símbolos piloto"
    bandwidth_limit = floor(N_carriers * 0.35); 
    % Distribui os pilotos uniformemente de -BW a +BW
    if N_pilots_target > 0
        idx_pilotos_rel = unique(round(linspace(-bandwidth_limit, bandwidth_limit, N_pilots_target)));
        idx_pilotos_rel(idx_pilotos_rel == 0) = []; % Remove DC se cair lá
    else
        idx_pilotos_rel = [];
    end

    N_pilots = length(idx_pilotos_rel);

    N_guard = floor(N_carriers * 0.25); % 25% de banda de guarda
    if mod(N_guard, 2) ~= 0, N_guard = N_guard + 1; end
    
    % Ativas = total - a banda 0 (DC)
    N_active_total = N_carriers - N_guard - 1;
    N_data = N_active_total - N_pilots;

    % Padding e reshape para forma matricial
    num_symbols = length(symbols_col);
    num_blocks = ceil(num_symbols / N_data);
    pad_len = (num_blocks * N_data) - num_symbols;
    qam_padded = [symbols_col; zeros(pad_len, 1)]; % Padding com zeros nos dados

    data_matrix = reshape(qam_padded, N_data, num_blocks);

    fft_grid = zeros(N_carriers, num_blocks);

    active_indices = [ (N_guard/2)+1 : (N_carriers/2), (N_carriers/2)+2 : N_carriers-(N_guard/2) ];
    idx_pilotos_abs = (N_carriers/2 + 1) + idx_pilotos_rel;
    idx_data_abs = setdiff(active_indices, idx_pilotos_abs);

    fft_grid(idx_data_abs, :) = data_matrix;

    % Símbolos piloto terão valor fixo 1 + 0j
    valor_piloto = 1 + 0i; 
    fft_grid(idx_pilotos_abs, :) = valor_piloto;

    ifft_input = ifftshift(fft_grid, 1);
    time_blocks = ifft(ifft_input, N_carriers, 1) * sqrt(N_carriers);

    cp_len = N_carriers / 4;
    cp_part = time_blocks(end-cp_len+1 : end, :);
    ofdm_blocks_with_cp = [cp_part; time_blocks];

    tx_signal = ofdm_blocks_with_cp(:);

    ofdm_params.idx_data = idx_data_abs;
    ofdm_params.idx_pilots = idx_pilotos_abs;
    ofdm_params.val_pilots = valor_piloto;
    ofdm_params.N_fft = N_carriers;
    ofdm_params.CP = cp_len;
end