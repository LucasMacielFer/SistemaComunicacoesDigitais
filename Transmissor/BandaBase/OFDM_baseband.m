function [tx_signal, t, ofdm_params] = OFDM_baseband(symbols, N_carriers, N_pilots_target, Fs)
arguments(Input)
    symbols
    N_carriers {mustBeMember(N_carriers, [64, 128, 256])}
    N_pilots_target double = 4
    Fs double = 2e6       % --- ADICIONADO: Frequência de amostragem padrão
end   
    symbols_col = symbols(:);
    
    % --- MODIFICADO: Definição do tamanho da FFT de simulação ---
    N_fft_sim = N_carriers * 8; 
    % -----------------------------------------------------------

    bandwidth_limit = floor(N_carriers * 0.35); 
    if N_pilots_target > 0
        idx_pilotos_rel = unique(round(linspace(-bandwidth_limit, bandwidth_limit, N_pilots_target)));
        idx_pilotos_rel(idx_pilotos_rel == 0) = []; 
    else
        idx_pilotos_rel = [];
    end
    N_pilots = length(idx_pilotos_rel);
    N_guard = floor(N_carriers * 0.25); 
    if mod(N_guard, 2) ~= 0, N_guard = N_guard + 1; end
    
    N_active_total = N_carriers - N_guard - 1;
    N_data = N_active_total - N_pilots;
    
    num_symbols = length(symbols_col);
    num_blocks = ceil(num_symbols / N_data);
    pad_len = (num_blocks * N_data) - num_symbols;
    qam_padded = [symbols_col; zeros(pad_len, 1)]; 
    data_matrix = reshape(qam_padded, N_data, num_blocks);
    
    fft_grid = zeros(N_carriers, num_blocks);
    active_indices = [ (N_guard/2)+1 : (N_carriers/2), (N_carriers/2)+2 : N_carriers-(N_guard/2) ];
    idx_pilotos_abs = (N_carriers/2 + 1) + idx_pilotos_rel;
    idx_data_abs = setdiff(active_indices, idx_pilotos_abs);
    
    fft_grid(idx_data_abs, :) = data_matrix;
    valor_piloto = 1 + 0i; 
    fft_grid(idx_pilotos_abs, :) = valor_piloto;
    
    % --- MODIFICADO: Lógica de Zero Padding (Centrar dados na FFT gigante) ---
    % 1. Cria o grid maior vazio
    grid_oversampled = zeros(N_fft_sim, num_blocks);
    
    % 2. Calcula índices centrais
    idx_start = (N_fft_sim/2) - (N_carriers/2) + 1;
    idx_end   = (N_fft_sim/2) + (N_carriers/2);
    
    % 3. Insere o sinal pequeno no centro (com fftshift para alinhar DC)
    grid_oversampled(idx_start:idx_end, :) = fft_grid;
    
    % 4. Prepara para IFFT (Shift final)
    ifft_input = ifftshift(grid_oversampled, 1);
    
    % 5. IFFT com tamanho N_fft_sim
    time_blocks = ifft(ifft_input, N_fft_sim, 1) * sqrt(N_fft_sim);
    % -----------------------------------------------------------------------

    % --- MODIFICADO: CP escala com o oversampling ---
    cp_len = (N_carriers / 4) * 8;
    % ------------------------------------------------
    
    cp_part = time_blocks(end-cp_len+1 : end, :);
    ofdm_blocks_with_cp = [cp_part; time_blocks];
    
    % --- MODIFICADO: Saída Coluna e Vetor Tempo ---
    tx_signal = ofdm_blocks_with_cp(:).'; 
    
    num_samples = length(tx_signal);
    t = (0 : num_samples - 1) / Fs;
    % ----------------------------------------------

    ofdm_params.idx_data = idx_data_abs;
    ofdm_params.idx_pilots = idx_pilotos_abs;
    ofdm_params.val_pilots = valor_piloto;
    ofdm_params.N_fft = N_fft_sim; % --- MODIFICADO: O receptor precisa saber o tamanho real
    ofdm_params.CP = cp_len;       % --- MODIFICADO: O receptor precisa do CP real
end