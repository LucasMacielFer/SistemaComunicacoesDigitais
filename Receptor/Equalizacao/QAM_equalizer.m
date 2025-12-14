function [clean_symbols_rotated] = QAM_equalizer(rx_signal, N_levels)
% Uso geral: Equalizar uma constelação QAM (ou QPSK), de modo a remover a
% rotação causada pelo canal multipercurso e a deriva de frequência causada
% pelo desvio doppler.
    
    k = 2 * log2(N_levels); 
    BITS_POR_BLOCO = 192; 
    
    Fs = 2e6; 
    Ts = 1/Fs;
    CFO_NOISE_THRESHOLD_RAD_S = 1; 
    
    % 1. Header Principal: 72 símbolos
    N_HEADER_PRINCIPAL_SYMBOLS = 72;
    N_PCW_PRINCIPAL_SYMBOLS = 8;
    
    % Geração dos bits/símbolos do Header Principal
    [header_bits_principal, ~] = header(N_levels); 
    training_seq_principal = create_qam_symbols(header_bits_principal, N_levels);
    
    % 2. Mini-Header (Sync Bits):
    [sync_bits_data, ~] = sync_bits(N_levels); 
    
    N_TOTAL_SYNC_SYMBOLS = 20; 
    
    training_seq_sync = create_qam_symbols(sync_bits_data, N_levels);
    training_seq_sync = training_seq_sync(:); 
    
    if length(training_seq_sync) ~= N_TOTAL_SYNC_SYMBOLS
        error('A sequência de gabarito SYNC BITS não tem o tamanho de 20 símbolos, verifique create_qam_symbols().');
    end

    L_sig = length(rx_signal);
    rx_aligned = rx_signal(:);
    
    % Passo 1: Estimativa de CFO GLOBAL

    % Como funciona:
    % Pegamos os valores da constelação RECEBIDOS e os TEÓRICOS (isto é, a 
    % nossa sequência de treino conhecida, que é a mesma no início de todas
    % as linhas de bits). Dividimos um pelo outro ponto-a-ponto, e, como 
    % são números complexos, podemos pensar em uma divisão fasorial. 
    % O resultado é a divisão das amplitudes e a subtração (diferença) das
    % fases. 
    % 
    % Para correção, aproximamos um polinômio que siga a distorção de fase
    % no tempo.

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
        p(1) = 0; % Zera a estimativa de CFO se estiver abaixo do limiar de ruído.
    end
    
    % Passo 2: Aplicação da Correção Dinâmica (CFO) Global

    % Como funciona:
    % O modelo de CFO ajustado (polyval) é transformado em um fator de correção 
    % exponencial. Este fator é aplicado a todo o vetor de símbolos recebidos 
    % (rx_aligned) para remover a deriva de frequência.

    time_vector_total = (0:L_sig - 1).' * Ts;
    cfo_model = polyval(p, time_vector_total);
    clean_symbols_temp = rx_aligned .* exp(-1i * cfo_model);
    
    % Passo 3: Correção Estática (Phase/Amplitude) do Header Principal

    % Como funciona:
    % Após a correção dinâmica de CFO, o remanescente é um erro de fase constante. 
    % Este erro estático é estimado usando a Palavra de Controle (PCW) do Header 
    % Principal. O fator de correção resultante é aplicado apenas ao Header Principal.    
    
    clean_symbols_rotated = zeros(size(clean_symbols_temp));
    
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

    % Passo 4: Loop de Correção Estática Contínua (Sync Bits)
    % Itera sobre o restante do sinal em blocos que contêm um "Mini-Header" 
    % (Sync Bits) e dados. Para cada bloco, usa-se os Sync Bits conhecidos para 
    % estimar o erro de fase estático remanescente e aplica essa correção ao 
    % bloco inteiro (Sync + Dados). Isso lida com variações lentas de fase/caminho.
    while idx_leitura_intercalado <= L_intercalado
        
        % Determina o tamanho total do bloco (Sync + Dados)
        bloco_total_len = N_TOTAL_SYNC_SYMBOLS + symbols_por_bloco;
        
        % Determina se há símbolos suficientes para um bloco completo (Sync + Dados)
        bloco_total_restante = min(bloco_total_len, L_intercalado - (idx_leitura_intercalado - 1));
        
        if bloco_total_restante <= 0
            break; % Sai se não houver mais nada para processar
        end
        
        if (idx_leitura_intercalado + N_TOTAL_SYNC_SYMBOLS - 1) > L_intercalado
             break; % Sai se não houver símbolos suficientes para processar
        end
        
        % Extração Correta do segmento de 20 símbolos
        rx_sync_segment = rx_symbols_after_cfo(idx_leitura_intercalado : idx_leitura_intercalado + N_TOTAL_SYNC_SYMBOLS - 1);
        
        % Estimativa de Erro Estático (PCW) - [20x1] ./ [20x1]
        final_error_ratio = rx_sync_segment ./ training_seq_sync; 
        static_phase_error = angle(mean(final_error_ratio));
        static_correction_factor = exp(-1i * static_phase_error);
        
        % Aplica a correção ao Bloco INTEIRO (Sync Bits + Dados)
        
        % O bloco a corrigir é o segmento atual (Sync) mais o segmento de dados que se segue
        bloco_total_a_corrigir = rx_symbols_after_cfo(idx_leitura_intercalado : idx_leitura_intercalado + bloco_total_restante - 1);
        corrected_block = bloco_total_a_corrigir .* static_correction_factor;
            
        % Armazenar o Bloco Corrigido 
        idx_escrita_final = idx_start_intercalado + idx_leitura_intercalado - 1;
        clean_symbols_rotated(idx_escrita_final : idx_escrita_final + bloco_total_restante - 1) = corrected_block;
        
        idx_leitura_intercalado = idx_leitura_intercalado + bloco_total_restante;
    end
    
    % Passo 5: Normalização Final de Amplitude

    % Como funciona:
    % O módulo do fator de erro do último segmento (mean(abs(final_error_ratio))) 
    % é usado para realizar a normalização final da amplitude de todos os símbolos, 
    % garantindo que a constelação esteja na escala de amplitude correta (sem 
    % a distorção introduzida pelo canal).
    
    static_module_error = mean(abs(final_error_ratio));
    clean_symbols_rotated = static_module_error * clean_symbols_rotated;
    clean_symbols_rotated = clean_symbols_rotated.';
end