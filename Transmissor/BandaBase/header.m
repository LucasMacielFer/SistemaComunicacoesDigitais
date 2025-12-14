function [header_bits, pcw_len_symbols] = header(N_levels)
% Uso geral: Gerar os bits "pilotos" (cabeçalho) adicionados à frente de 
% cada trama de bits. Estes bits são utilizados para equalização.
    
    if N_levels == 1
        M = 2;
    else
        M = N_levels^2;
    end
    bits_per_sym = log2(M); 
    
    % Sequência de treino: Hadamard 64
    Seq_Len_Hadamard = 64;
    H = hadamard(Seq_Len_Hadamard);
    
    % Usamos a linha 32 para treino (boa variação espectral)
    seq_bipolar = H(32, :)'; 
    seq_logical = (seq_bipolar > 0); 
    
    % Expansão e Linearização do Hadamard para Bits
    bits_matrix_hadamard = repmat(seq_logical, 1, bits_per_sym);
    hadamard_bits = bits_matrix_hadamard(:).';
    
    % O PCW deve ser curto, de alta energia e fácil de identificar.
    pcw_len_symbols = 8; 
    
    % PCW: Phase Correction Word. Parte do cabeçalho utilizada para
    % descobrir o desvio de fase. Sempre [1 1 1 1 1 1 1 1]
    pcw_base_bit = true(1, pcw_len_symbols);
    
    % Repete cada bit para preencher o símbolo inteiro
    pcw_bits_matrix = repmat(pcw_base_bit, bits_per_sym, 1);
    pcw_bits = pcw_bits_matrix(:).';
    
    header_bits = [hadamard_bits, pcw_bits];
end