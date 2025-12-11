function [clean_symbols_rotated] = QAM_equalizer(rx_signal, N_levels)
    % SIMPLE_PHASE_CORRECTOR_PCW: Integra CFO (Regressão Linear) com Limiar de Ruído
    % e aplica uma Correção de Fase Estática (PCW) final.
    
    % --- 0. CONFIGURAÇÃO DE VARIÁVEIS E CONSTANTES ---
    Fs = 2e6; % HARDCODED: 2 MHz
    Ts = 1/Fs;
    CFO_NOISE_THRESHOLD_RAD_S = 1; % Limiar de 1 rad/s (aprox. 0.16 Hz)
    N_PCW = 8; % Oito últimos símbolos do cabeçalho são a PCW
    
    % Geração do Gabarito (Assumida a função create_qam_symbols customizada)
    % NOTA: Certifique-se de que 'header_bits' inclui os bits da PCW.

    [header_bits, ~] = header(N_levels); 
    
    if N_levels == 1
        M = 2;
        k = 1;
        training_seq = (header_bits*2)-1;
    else
        M = N_levels^2;
        k = log2(M);
        training_seq = create_qam_symbols(header_bits, N_levels);
    end
    
    training_seq = training_seq(:);

    rx_aligned = rx_signal(:); 
    N_train = length(training_seq); % Comprimento total do treino (inclui PCW)
    L_sig = length(rx_aligned);
    
    % --- 1. PREPARAÇÃO DOS VETORES DE TREINO (Excluindo PCW para o CFO) ---
    
    % A. Segmentos de Treino
    N_cfo_train = N_train - N_PCW; % Símbolos usados apenas para estimar a inclinação (CFO)
    rx_cfo_train = rx_aligned(1:N_cfo_train);
    training_seq_cfo = training_seq(1:N_cfo_train);
    
    % B. Segmentos da PCW
    rx_pcw = rx_aligned(N_cfo_train + 1 : N_train);
    training_seq_pcw = training_seq(N_cfo_train + 1 : N_train);

    % --- 2. ESTIMATIVA ROBUSTA DE CFO (Least Squares Linear) ---
    
    % A. Calcular a Fase ACUMULADA do Erro (Unwrap)
    error_ratio_cfo = rx_cfo_train ./ training_seq_cfo;
    phase_error_unwrapped_cfo = unwrap(angle(error_ratio_cfo));
    
    % B. Definir vetores de tempo (somente para o segmento CFO)
    time_vector_cfo = (0:N_cfo_train - 1).' * Ts;
    time_vector_total = (0:L_sig - 1).' * Ts;
    
    % C. REGRESSÃO LINEAR (Grau 1): p(1)=CFO (slope), p(2)=fase inicial (PAR).
    % NOTA: p(2) aqui estima o erro de fase inicial, mas o PCW irá refinar.
    p = polyfit(time_vector_cfo, phase_error_unwrapped_cfo, 1);
    
    % D. AVALIAÇÃO DO LIMIAR DE RUÍDO
    cfo_estimate_rad_s = p(1); 
    
    if abs(cfo_estimate_rad_s) < CFO_NOISE_THRESHOLD_RAD_S
        % Se o CFO for ruído, anulamos a inclinação (CFO).
        p(1) = 0; 
    end
    
    % --- 3. CORREÇÃO DINÂMICA (CFO) ---
    
    % A. Cria o modelo de fase de rotação (CFO corrigido + PAR inicial)
    cfo_model = polyval(p, time_vector_total);
    
    % B. Aplicação da correção ao sinal total
    clean_symbols_temp = rx_aligned .* exp(-1i * cfo_model);
    
    % --- 4. CORREÇÃO ESTÁTICA FINAL (PLL: PCW - Phase Correction Word) ---
    
    % A. Extrai o segmento PCW APÓS a correção de CFO
    pcw_corrected_rx = clean_symbols_temp(N_cfo_train + 1 : N_train);
    
    % B. Calcula o erro de fase MÉDIO/ESTÁTICO remanescente na PCW
    % O erro de fase final é o ângulo médio da proporção entre o sinal corrigido
    % e o gabarito.
    final_error_ratio = pcw_corrected_rx ./ training_seq_pcw;
    static_phase_error = angle(mean(final_error_ratio));
    static_module_error = mean(abs(final_error_ratio));
    
    % C. Fator de Correção Estática (Rotaciona na direção OPPOSTA ao erro médio)
    static_correction_factor = exp(-1i * static_phase_error);
    
    % D. Aplica a correção estática ao SINAL TOTAL
    clean_symbols_rotated = clean_symbols_temp .* static_correction_factor;
    
    % --- 5. RETORNO FINAL ---
    
    clean_symbols_rotated = static_module_error*clean_symbols_rotated.';
end