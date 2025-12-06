function [clean_symbols_rotated] = simple_phase_corrector(rx_signal, N_levels)
    % SIMPLE_GEOMETRIC_PHASE_CORRECTOR: Corrige a fase apenas por média geométrica.
    % Não utiliza CFO, Regressão, Unwrap, PLL, nem Equalizador.
    
    % --- 0. CONFIGURAÇÃO DE VARIÁVEIS ---
    if N_levels == 1
        M = 2;
    else
        M = N_levels^2;
    end
    
    % Geração do Gabarito
    [header_bits, ~] = header(N_levels); % Assumida a função header()
    training_seq = create_qam_symbols(header_bits, N_levels);
    
    rx_aligned = rx_signal(:); 
    N_train = length(training_seq);
    
    % --- 1. ISOLAMENTO DO SINAL DE TREINO ---
    
    % Alinha os vetores pelo tamanho do Gabarito
    rx_train = rx_aligned(1:N_train); 
    
    % --- 2. CÁLCULO DO ERRO MÉDIO (A CHAVE GEOMÉTRICA) ---
    
    % A. Calcular o Erro Complexo (Ratio) para cada símbolo de treino.
    % Se o sinal Rx estiver perfeito e alinhado, rx_train ./ training_seq = 1.
    % Se estiver rodado, o resultado é um vetor de e^(j*phi_erro)
    error_ratio_vector = rx_train ./ training_seq;
    
    % B. Calcular a Média Vetorial do Erro (O Ponto central de todos os erros).
    % Este cálculo é robusto contra a maioria dos ruídos de fase estática.
    % A média é feita no domínio complexo antes de extrair o ângulo.
    mean_error_complex = mean(error_ratio_vector);
    
    % C. Encontrar o ângulo do erro médio (em radianos).
    mean_error_phase = angle(mean_error_complex);
    
    % D. Fator de Correção (Rotaciona na direção OPPOSTA ao erro médio)
    correction_factor = exp(-1i * mean_error_phase);
    
    % --- 3. APLICAÇÃO DA CORREÇÃO E RETORNO ---
    
    % Aplica a rotação de fase estática (e ambígua) a TODO o sinal.
    clean_symbols_temp = rx_aligned * correction_factor;
    
    % Aplica conjugação final para resolver o conflito de sinal I-jQ
    clean_symbols_rotated = clean_symbols_temp.';
end