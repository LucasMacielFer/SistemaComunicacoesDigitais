function rx_grid_raw = OFDM_prepare_grid(rx_time_signal, ofdm_params)
% Transforma o sinal do tempo numa grade de frequência suja (com distorção)
    N_fft = ofdm_params.N_fft;
    CP = ofdm_params.CP;
    
    % Serial -> Paralelo
    len_block = N_fft + CP;
    num_blocks = floor(length(rx_time_signal) / len_block);
    rx_mat = reshape(rx_time_signal(1:num_blocks*len_block), len_block, num_blocks);
    
    % Remove CP e faz FFT
    rx_no_cp = rx_mat(CP+1:end, :);
    rx_fft = fft(rx_no_cp, N_fft, 1) / sqrt(N_fft);
    rx_grid_raw = fftshift(rx_fft, 1);
end