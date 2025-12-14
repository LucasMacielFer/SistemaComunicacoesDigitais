function [msg_string] = ASCII_decoder(data)
% Uso geral: Recebe um vetor linha de bits e descodifica para caracteres 
% ASCII estendidos (8-bits).
arguments
    data (1,:) double  % Vetor linha de bits (zeros e uns)
end
    
    num_total_bits = length(data);
    bits_por_caractere = 8;

    if mod(num_total_bits, bits_por_caractere) ~= 0
        error('O vetor de bits não tem um número total de bits múltiplo de 8. Verifique o padding.');
    end
    
    char_array = char(data + '0'); 
    num_caracteres = num_total_bits / bits_por_caractere;
    
    % Cria a matriz (N_caracteres linhas x 8 colunas)
    bin_matrix_col_major = reshape(char_array, bits_por_caractere, num_caracteres);
    msg_bin = bin_matrix_col_major.'; % Transpõe para (num_caracteres x 8)

    % Binário -> Decimal
    msg_dec = bin2dec(msg_bin);
    
    % Converte o vetor de valores decimais ASCII para uma string de caracteres.
    msg_string = char(msg_dec.');
end