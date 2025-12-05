function rx_grid_final = OFDM_prepare_grid(rx_time_signal, ofdm_params)
% Transforma o sinal do tempo numa grade de frequência
% E remove o oversampling (corta apenas o centro útil)

    N_fft_sim = ofdm_params.N_fft; % Tamanho Grande (ex: 512)
    CP = ofdm_params.CP;
    
    % --- 1. S/P e Remoção de CP (Usando tamanho GRANDE) ---
    len_block = N_fft_sim + CP;
    num_blocks = floor(length(rx_time_signal) / len_block);
    
    rx_mat = reshape(rx_time_signal(1:num_blocks*len_block), len_block, num_blocks);
    rx_no_cp = rx_mat(CP+1:end, :);
    
    % --- 2. FFT e Shift ---
    % Normaliza pela raiz do tamanho da FFT usada
    rx_fft = fft(rx_no_cp, N_fft_sim, 1) / sqrt(N_fft_sim);
    rx_grid_large = fftshift(rx_fft, 1); % DC está no meio de 512
    
    % --- 3. DOWNSAMPLING EM FREQUÊNCIA (O RECORTE) ---
    % Precisamos descobrir qual o tamanho original (N_carriers)
    % Podemos deduzir sabendo que o Oversampling foi de 8x, ou melhor:
    % Vamos olhar para os índices de dados para saber onde termina o sinal útil.
    
    % Recupera o N_carriers original (64)
    % A forma mais segura é passar isso no params, mas vamos calcular:
    % Se N_fft_sim = 512 e usamos oversampling de 8, N_orig = 64.
    oversampling_factor = 8; % O padrão que definimos
    N_original = N_fft_sim / oversampling_factor;
    
    % Calcula onde cortar
    center_large = N_fft_sim / 2;
    offset = N_original / 2;
    
    idx_start = center_large - offset + 1;
    idx_end   = center_large + offset;
    
    % Recorta apenas o miolo (ex: do 225 ao 288)
    rx_grid_final = rx_grid_large(idx_start : idx_end, :);
    
    % AGORA rx_grid_final tem tamanho 64xBlocos e bate com seus idx_data!
end