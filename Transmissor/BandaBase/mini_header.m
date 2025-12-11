function [header_bits, pcw_len_symbols] = mini_header(N_levels)
% Função que gera os símbolos pilotos (Hadamard + PCW)
% 16+4 = 20 símbolos

    % --- 1. CONFIGURAÇÃO BASE ---
    if N_levels == 1
        M = 2;
    else
        M = N_levels^2;
    end
    bits_per_sym = log2(M); 

    % --- 2. GERAÇÃO DO TREINO (Hadamard 64) ---
    Seq_Len_Hadamard = 16; % Em símbolos
    H = hadamard(Seq_Len_Hadamard);
    
    % Usamos a linha 16 para treino (boa variação espectral)
    seq_bipolar = H(16, :)'; 
    seq_logical = (seq_bipolar > 0); 
    
    % Expansão e Linearização do Hadamard para Bits (Corner/Extremes)
    bits_matrix_hadamard = repmat(seq_logical, 1, bits_per_sym);
    hadamard_bits = bits_matrix_hadamard(:).';
    
    % --- 3. GERAÇÃO DA PALAVRA DE VERIFICAÇÃO DE FASE (PCW) ---
    
    % O PCW deve ser curto, de alta energia e fácil de identificar.
    pcw_len_symbols = 4; % Tamanho fixo em 4 símbolos (Ex: 32 bits em 256-QAM)
    
    % Geramos 8 bits, todos '1's (Isso força o símbolo a ir para o canto +++)
    pcw_base_bit = true(1, pcw_len_symbols); % [1 1 1 1]
    
    % Repete cada bit para preencher o símbolo inteiro (robustez)
    pcw_bits_matrix = repmat(pcw_base_bit, bits_per_sym, 1);
    pcw_bits = pcw_bits_matrix(:).';
    
    % --- 4. CONCATENAÇÃO FINAL ---
    header_bits = [hadamard_bits, pcw_bits];
end