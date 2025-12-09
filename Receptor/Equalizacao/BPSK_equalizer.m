function [clean_symbols_rotated] = BPSK_equalizer(rx_signal, fwd_taps, ref_tap, forgetting_f, loop_bw)
    % FINAL_ROBUST_RECEIVER_LE: A arquitetura mais estável para canais com Multipercurso.
    % Usando o LE (Linear Equalizer) em vez do instável DFE ou FDE-ZF.
    
    % --- 0. CONFIGURAÇÕES INICIAIS ---
    PCW_LEN_SYMBOLS = 8; 
    Fs = 2e6; 
    Ts = 1/Fs;
    
    M = 2;

    % Constelações e Sequências
    ref_const = qammod(0:M-1, M, 'UnitAveragePower', true);
    [header_bits, ~] = header(1);
    training_seq = qammod(double(header_bits(:)), M, 'InputType', 'bit', 'UnitAveragePower', true);
    
    rx_aligned = rx_signal(:); 
    L_sig = length(rx_aligned);
    N_train = length(training_seq);
    
    % --- 1. ESTIMATIVA E CORREÇÃO GROSSEIRA DE CFO ---
    time_vector_total = (0:L_sig - 1).' * Ts;
    rx_train = rx_aligned(1:N_train);
    phase_error_vec = rx_train ./ training_seq;
    phase_diff = phase_error_vec(2:end) .* conj(phase_error_vec(1:end-1));
    delta_phase_per_symbol = mean(angle(phase_diff));
    
    cfo_estimate_rad_s = delta_phase_per_symbol / Ts;
    SAFETY_FACTOR = 0.99; 
    cfo_estimate_rad_s = cfo_estimate_rad_s * SAFETY_FACTOR;
    
    cfo_correction_factor = exp(-1j * cfo_estimate_rad_s * time_vector_total);
    rx_cfo_corrected = rx_aligned .* cfo_correction_factor;
    
    % --- 2. PLL E EQUALIZAÇÃO LINEAR (LE-RLS) ---
    
    carrier_sync = comm.CarrierSynchronizer(...
        'Modulation', 'QAM', 'ModulationPhaseOffset', 'Auto', 'SamplesPerSymbol', 1, ...
        'DampingFactor', 0.7, 'NormalizedLoopBandwidth', loop_bw); 
    
    carrier_sync.Modulation = 'BPSK';
    [rx_derotated, ~] = carrier_sync(rx_cfo_corrected);

    le = comm.LinearEqualizer(...
        'Algorithm', 'RLS', ...
        'NumTaps', fwd_taps, ... 
        'ForgettingFactor', forgetting_f, 'ReferenceTap', ref_tap, ...
        'Constellation', ref_const, 'TrainingFlagInputPort', true);  
    
    desired_signal = [training_seq; zeros(L_sig - N_train, 1)];
    training_flag = [true(N_train, 1); false(L_sig - N_train, 1)];
    
    [clean_symbols_raw, ~] = le(rx_derotated, desired_signal, training_flag);
    clean_symbols_raw = clean_symbols_raw(:); 
    
    % ----------------------------------------------------
    % --- 3. RESOLUÇÃO DE AMBIGUIDADE FINAL (PAR + REFLEXÃO) ---
    % ----------------------------------------------------
    
    % A. Isolar o PCW
    hadamard_len_symbols = N_train - PCW_LEN_SYMBOLS; 
    pcw_start_idx = hadamard_len_symbols + 1;
    pcw_end_idx = hadamard_len_symbols + PCW_LEN_SYMBOLS;
    
    rx_pcw_symbols = clean_symbols_raw(pcw_start_idx : pcw_end_idx);
    tx_pcw_symbols = training_seq(end - PCW_LEN_SYMBOLS + 1 : end);
    
    % B. Testar 4 Quadrantes (0, 90, 180, 270 graus)
    rotation_factors = [1, 1j, -1, -1j]; 
    min_mse = inf;
    best_rotation_factor = 1; 
    
    for k = 1:4
        rot_factor = rotation_factors(k);
        hypothetical_pcw = rx_pcw_symbols * rot_factor;
        
        % Não precisamos de swap complexo; a multiplicação simples é suficiente
        mse = mean(abs(hypothetical_pcw - tx_pcw_symbols).^2);
        
        if mse < min_mse
            min_mse = mse;
            best_rotation_factor = rot_factor;
        end
    end
    
    % C. Aplicação da Rotação Vencedora (Final)
    clean_symbols_temp = clean_symbols_raw * best_rotation_factor;
    
    % D. Correção de Reflexão Final (Para o seu demodulador customizado)
    
    rx_pcw_symbols_final = clean_symbols_temp(pcw_start_idx : pcw_end_idx);
    tx_pcw_symbols_check = tx_pcw_symbols; 
    
    mean_real_rx = mean(real(rx_pcw_symbols_final));
    mean_real_tx = mean(real(tx_pcw_symbols_check));
    correction_factor_I = sign(mean_real_rx) ~= sign(mean_real_tx);
    
    mean_imag_rx = mean(imag(rx_pcw_symbols_final));
    mean_imag_tx = mean(imag(tx_pcw_symbols_check));
    correction_factor_Q = sign(mean_imag_rx) ~= sign(mean_imag_tx);
    
    final_real = real(clean_symbols_temp) .* (-1).^correction_factor_I;
    final_imag = imag(clean_symbols_temp) .* (-1).^correction_factor_Q;
    
    clean_symbols_rotated = final_real + 1j * final_imag;
    
    % --- 4. RETORNO ---
    clean_symbols_rotated = conj(clean_symbols_rotated).';
end