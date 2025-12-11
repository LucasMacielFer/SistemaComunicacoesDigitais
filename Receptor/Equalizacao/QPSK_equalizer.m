function [clean_symbols_rotated] = QPSK_equalizer(rx_signal, N_levels, fwd_taps, ref_tap, forgetting_f, loop_bw, damping)
    % SINGLE_CARRIER_EQUALIZE: Versão Final Usando EQUALIZADOR LINEAR (LE).
    % Nota: O parâmetro 'fb_taps' é mantido na assinatura, mas ignorado.
    
    % --- 0. CONFIGURAÇÕES INICIAIS ---
    PCW_LEN_SYMBOLS = 8; 
    Fs = 1e6; 
    Ts = 1/Fs;
    
    if N_levels == 1
        M = 2;
    else
        M = N_levels^2;
    end
    
    % Constelações e Sequências
    ref_bits = de2bi(0:M-1, 'left-msb');
    ref_bits = ref_bits.';
    ref_bits = ref_bits(:).';
    ref_const = create_qam_symbols(ref_bits, N_levels);
    [header_bits, ~] = header(N_levels);
    training_seq = create_qam_symbols(header_bits, N_levels);
    
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
    
    % --- 2. PLL E EQUALIZAÇÃO ---
    
    carrier_sync = comm.CarrierSynchronizer(...
        'Modulation', 'QAM', 'ModulationPhaseOffset', 'Auto', 'SamplesPerSymbol', 1, ...
        'DampingFactor', damping, 'NormalizedLoopBandwidth', loop_bw); 
    
    if N_levels == 1
        carrier_sync.Modulation = 'BPSK';
    elseif N_levels == 2
        carrier_sync.Modulation = 'QPSK';
    end
    [rx_derotated, ~] = carrier_sync(rx_cfo_corrected);

    % SUBSTITUIÇÃO CRÍTICA: DFE -> LINEAR EQUALIZER (LE)
    le = comm.LinearEqualizer(...
        'Algorithm', 'RLS', ...
        'NumTaps', fwd_taps, ... % Agora 'NumTaps' é o número total de taps (FFE)
        'ForgettingFactor', forgetting_f, ...
        'ReferenceTap', ref_tap, ...
        'Constellation', ref_const, ...
        'TrainingFlagInputPort', true);  
    
    % Vetores de Controlo LE
    desired_signal = [training_seq; zeros(L_sig - N_train, 1)];
    training_flag = [true(N_train, 1); false(L_sig - N_train, 1)];
    
    [clean_symbols_raw, ~] = le(rx_derotated, desired_signal, training_flag);
    clean_symbols_raw = clean_symbols_raw(:); 
    
    % --- 3. RESOLUÇÃO DE AMBIGUIDADE FINAL (PAR + REFLEXÃO) ---
    
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
        
        % O LE não usa taps de feedback, mas a lógica de swap de eixos é mantida para o MSE
        if abs(rot_factor) < 1.0001 && abs(rot_factor) > 0.9999 && imag(rot_factor) ~= 0 
             hypothetical_pcw = imag(hypothetical_pcw) + 1j * real(hypothetical_pcw);
        end
        
        mse = mean(abs(hypothetical_pcw - tx_pcw_symbols).^2);
        
        if mse < min_mse
            min_mse = mse;
            best_rotation_factor = rot_factor;
        end
    end
    
    % C. Aplicação da Rotação Vencedora e Swap de Eixos (90/270 graus)
    
    if abs(best_rotation_factor) < 1.0001 && abs(best_rotation_factor) > 0.9999 && imag(best_rotation_factor) ~= 0 
        temp_rotated = clean_symbols_raw * best_rotation_factor;
        clean_symbols_temp = imag(temp_rotated) + 1j * real(temp_rotated);
    else
        clean_symbols_temp = clean_symbols_raw * best_rotation_factor;
    end
    
    % D. Teste Final de 180 Graus (Inversão)
    rx_pcw_symbols_corrected = clean_symbols_temp(pcw_start_idx : pcw_end_idx);
    mse_0 = mean(abs(rx_pcw_symbols_corrected - tx_pcw_symbols).^2);
    mse_180 = mean(abs((rx_pcw_symbols_corrected * -1) - tx_pcw_symbols).^2);
    
    if mse_180 < mse_0
        best_rotation_factor_final = -1;
    else
        best_rotation_factor_final = 1;
    end
    
    clean_symbols_temp = clean_symbols_temp * best_rotation_factor_final;

    % E. Correção de Reflexão Final (Para o seu demodulador customizado)
    
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
    
    clean_symbols_rotated = final_imag + 1j * final_real;
    
    % --- 4. RETORNO ---
    clean_symbols_rotated = clean_symbols_rotated.';
end