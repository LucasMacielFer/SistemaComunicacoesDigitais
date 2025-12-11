function [msg_string] = ASCII_decoder(data)
% ASCII_DECODER: Recebe um vetor linha de bits e descodifica para caracteres ASCII estendidos (8-bits).
%
% Exemplo: [0 1 0 0 1 0 0 0 0 1 1 0 0 1 0 1] -> 'He'
%
arguments
    data (1,:) double  % Vetor linha de bits (zeros e uns)
end
    
    % --- 1. VERIFICAÇÃO DE DADOS ---
    num_total_bits = length(data);
    bits_por_caractere = 8;

    % O número total de bits deve ser um múltiplo de 8
    if mod(num_total_bits, bits_por_caractere) ~= 0
        error('O vetor de bits não tem um número total de bits múltiplo de 8. Verifique o padding.');
    end
    
    % --- 2. REAGRUPAMENTO DE BITS ---

    % A sua função encoder gera uma linha de bits [C1(b1-b8), C2(b1-b8), ...]
    % Transformamos o vetor linha em uma matriz: 8 colunas x N_caracteres linhas.
    % O reshape lê coluna por coluna (por defeito), por isso precisamos de transpor o vetor,
    % usar 'reshape' para criar a matriz por coluna e transpor novamente.
    
    % Converte os números (0 ou 1) de volta para caracteres '0' ou '1'
    char_array = char(data + '0'); 
    
    num_caracteres = num_total_bits / bits_por_caractere;
    
    % Cria a matriz (N_caracteres linhas x 8 colunas)
    % A leitura é feita por linha, o que preserva a ordem C1, C2, ...
    bin_matrix_col_major = reshape(char_array, bits_por_caractere, num_caracteres);
    msg_bin = bin_matrix_col_major.'; % Transpõe para (num_caracteres x 8)

    
    % --- 3. CONVERSÃO BINÁRIO -> DECIMAL ---

    % Converte cada linha (8 bits) da matriz para o seu valor decimal ASCII.
    % 'bin2dec' espera um vetor coluna de chars, mas 'bin2dec' também funciona com matrizes
    % de caracteres se cada linha for um número binário.
    
    % A função 'bin2dec' no MATLAB é robusta para este formato.
    msg_dec = bin2dec(msg_bin);
    
    
    % --- 4. CONVERSÃO DECIMAL -> CARACTERE ---

    % Converte o vetor de valores decimais ASCII para uma string de caracteres.
    % Usamos 'char()' para converter os valores inteiros (uint8) para caracteres.
    msg_string = char(msg_dec.');
end