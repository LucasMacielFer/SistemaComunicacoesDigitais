function [clean_symbols_rotated] = QAM_equalizer(rx_signal, N_levels)
    % QAM_EQUALIZER: Aplica correção de CFO (Global) e PCW (Bloco a Bloco)
    % ao sinal recebido. O vetor de saída mantém o mesmo tamanho do vetor de entrada
    
    % --- 0. CONFIGURAÇÃO DE VARIÁVEIS E CONSTANTES ---
    
    k = 2 * log2(N_levels); 
    BITS_POR_BLOCO = 192; 
    
    Fs = 2e6; % HARDCODED: 2 MHz
    Ts = 1/Fs;
    CFO_NOISE_THRESHOLD_RAD_S = 1; 
    
    % 1. Header Principal: 72 símbolos
    N_HEADER_PRINCIPAL_SYMBOLS = 72;
    N_PCW_PRINCIPAL_SYMBOLS = 8;
    
    % Geração dos bits/símbolos do Header Principal
    [header_bits_principal, ~] = header(N_levels); 
    training_seq_principal = create_qam_symbols(header_bits_principal, N_levels);
    
    % 2. Mini-Header (Sync Bits):
    [sync_bits_data, N_PCW_SYMBOLS] = sync_bits(N_levels); 
    
    % CORREÇÃO AQUI: O tamanho total da sequência de sincronização é 20 símbolos (16+4).
    % N_PCW_SYMBOLS é apenas a parte PCW (4). Precisamos do tamanho total.
    N_TOTAL_SYNC_SYMBOLS = 20; 
    
    training_seq_sync = create_qam_symbols(sync_bits_data, N_levels);
    training_seq_sync = training_seq_sync(:); % Garante que seja vetor coluna (20x1)
    
    if length(training_seq_sync) ~= N_TOTAL_SYNC_SYMBOLS
        error('A sequência de gabarito SYNC BITS não tem o tamanho de 20 símbolos, verifique create_qam_symbols().');
    end

    L_sig = length(rx_signal);
    rx_aligned = rx_signal(:);
    
    % --- 1. ESTIMATIVA GLOBAL DE CFO (Header Principal) ---
    
    rx_principal = rx_aligned(1:N_HEADER_PRINCIPAL_SYMBOLS);
    
    N_cfo_train = N_HEADER_PRINCIPAL_SYMBOLS - N_PCW_PRINCIPAL_SYMBOLS; 
    rx_cfo_train = rx_principal(1:N_cfo_train);
    training_seq_cfo = training_seq_principal(1:N_cfo_train);
    
    error_ratio_cfo = rx_cfo_train ./ training_seq_cfo;
    phase_error_unwrapped_cfo = unwrap(angle(error_ratio_cfo));
    time_vector_cfo = (0:N_cfo_train - 1).' * Ts;
    
    p = polyfit(time_vector_cfo, phase_error_unwrapped_cfo, 1);
    cfo_estimate_rad_s = p(1); 
    
    if abs(cfo_estimate_rad_s) < CFO_NOISE_THRESHOLD_RAD_S
        p(1) = 0; 
    end
    
    % --- 2. CORREÇÃO DINÂMICA (CFO) GLOBAL ---
    
    time_vector_total = (0:L_sig - 1).' * Ts;
    cfo_model = polyval(p, time_vector_total);
    clean_symbols_temp = rx_aligned .* exp(-1i * cfo_model);
    
    % --- 3. CORREÇÃO ESTÁTICA POR BLOCO (PCW/Sync Bits) ---
    
    clean_symbols_rotated = zeros(size(clean_symbols_temp));
    
    % Índice de início dos dados após o header principal
    idx_start_intercalado = N_HEADER_PRINCIPAL_SYMBOLS + 1;
    rx_symbols_after_cfo = clean_symbols_temp(idx_start_intercalado : end);
    L_intercalado = length(rx_symbols_after_cfo);
    
    idx_leitura_intercalado = 1;
    symbols_por_bloco = BITS_POR_BLOCO / k;
    
    % Correção Estática para o Header Principal
    rx_pcw_principal = clean_symbols_temp(N_HEADER_PRINCIPAL_SYMBOLS - N_PCW_PRINCIPAL_SYMBOLS + 1 : N_HEADER_PRINCIPAL_SYMBOLS);
    training_seq_pcw_principal = training_seq_principal(N_HEADER_PRINCIPAL_SYMBOLS - N_PCW_PRINCIPAL_SYMBOLS + 1 : N_HEADER_PRINCIPAL_SYMBOLS);
    
    final_error_ratio_principal = rx_pcw_principal(:) ./ training_seq_pcw_principal(:);
    static_phase_error_principal = angle(mean(final_error_ratio_principal));
    static_correction_factor_principal = exp(-1i * static_phase_error_principal);
    
    clean_symbols_rotated(1:N_HEADER_PRINCIPAL_SYMBOLS) = clean_symbols_temp(1:N_HEADER_PRINCIPAL_SYMBOLS) .* static_correction_factor_principal;

    % Loop de 1 em 1 bloco (sync bit + dados) para PCW Contínua
    while idx_leitura_intercalado <= L_intercalado
        
        % A. Determina o tamanho total do bloco (Sync + Dados)
        bloco_total_len = N_TOTAL_SYNC_SYMBOLS + symbols_por_bloco;
        
        % B. Determina se há símbolos suficientes para um bloco completo (Sync + Dados)
        bloco_total_restante = min(bloco_total_len, L_intercalado - (idx_leitura_intercalado - 1));
        
        if bloco_total_restante <= 0
            break; % Sai se não houver mais nada para processar
        end
        
        % C. Extrai o segmento do Sync Bit (N_TOTAL_SYNC_SYMBOLS = 20)
        % Verifica se o segmento de SYNC está completo
        if (idx_leitura_intercalado + N_TOTAL_SYNC_SYMBOLS - 1) > L_intercalado
             % Se não houver 20 símbolos completos para o SYNC, usamos o que resta, 
             % mas a estimativa PCW será menos fiável. Vamos simplificar e sair.
             break;
        end
        
        % Extração Correta do segmento de 20 símbolos
        rx_sync_segment = rx_symbols_after_cfo(idx_leitura_intercalado : idx_leitura_intercalado + N_TOTAL_SYNC_SYMBOLS - 1);
        
        % D. Estimativa de Erro Estático (PCW) - Agora [20x1] ./ [20x1]
        final_error_ratio = rx_sync_segment ./ training_seq_sync; 
        static_phase_error = angle(mean(final_error_ratio));
        static_correction_factor = exp(-1i * static_phase_error);
        
        % E. Aplica a correção ao Bloco INTEIRO (Sync Bits + Dados)
        
        % O bloco a corrigir é o segmento atual (Sync) mais o segmento de dados que se segue
        bloco_total_a_corrigir = rx_symbols_after_cfo(idx_leitura_intercalado : idx_leitura_intercalado + bloco_total_restante - 1);
        corrected_block = bloco_total_a_corrigir .* static_correction_factor;
            
        % F. Armazenar o Bloco Corrigido 
        idx_escrita_final = idx_start_intercalado + idx_leitura_intercalado - 1;
        clean_symbols_rotated(idx_escrita_final : idx_escrita_final + bloco_total_restante - 1) = corrected_block;
        
        idx_leitura_intercalado = idx_leitura_intercalado + bloco_total_restante;
    end
    
    % --- 5. NORMALIZAÇÃO FINAL ---
    % Nota: Usamos a média do módulo do último bloco corrigido (final_error_ratio)
    % Apenas a correção de fase estática usa o módulo.
    static_module_error = mean(abs(final_error_ratio));
    clean_symbols_rotated = static_module_error * clean_symbols_rotated;
    clean_symbols_rotated = clean_symbols_rotated.';
end