function [path] = image_decoder(data)
% Uso geral: Extrai Altura e Largura (H, W) do header de 32 bits na primeira linha,
% remove o padding e reconstrói a matriz de imagem RGB na ordem correta.
arguments (Input)
    data (:,:) double  % Matriz de bits (H linhas x (Largura_Pixel + 32) colunas)
end
   
    BITS_POR_DIMENSAO = 16;
    TAMANHO_HEADER_BITS = 32; 
    
    % Extração e descodificação do tamanho
    header_bits = data(1, 1:TAMANHO_HEADER_BITS);
    altura_bin = header_bits(1, 1:BITS_POR_DIMENSAO);
    largura_bin = header_bits(1, BITS_POR_DIMENSAO + 1 : TAMANHO_HEADER_BITS);
    
    % Binário -> Decimal
    H = bin2dec(char(altura_bin + '0'));
    W = bin2dec(char(largura_bin + '0'));
    
    if W == 0 || H == 0
        error('Dimensões da imagem inválidas.');
    end
    
    % Remove os 32 bits do header/padding de TODAS as linhas
    data_bits_pixels = data(:, TAMANHO_HEADER_BITS + 1 : end);
    
    % B. Achata a matriz de bits (H x N_bits_per_line) em um único vetor linha.
    % Transpõe e Achata para forçar a ordem Linha-por-Linha (Row-Major)
    data_bits_flat = data_bits_pixels.'; 
    data_bits_flat = data_bits_flat(:).'; 
    
    num_bytes = H * W * 3; 
    
    % Reorganiza o vetor de bits em uma matriz onde cada linha é um byte (8 bits)
    bits_char = char(data_bits_flat + '0'); 
    
    byte_matrix = reshape(bits_char, 8, num_bytes).'; 
    
    % Binário -> Decimal
    pixel_values_dec = bin2dec(byte_matrix);
    
    % O vetor está na ordem: R1, G1, B1, R2, G2, B2, ...
    R_values = pixel_values_dec(1:3:end); 
    G_values = pixel_values_dec(2:3:end); 
    B_values = pixel_values_dec(3:3:end); 
    
    R_temp = reshape(R_values, W, H); 
    G_temp = reshape(G_values, W, H); 
    B_temp = reshape(B_values, W, H); 
    
    % Transpor para a ordem correta H x W
    R_channel = R_temp.'; 
    G_channel = G_temp.'; 
    B_channel = B_temp.'; 
    
    % Concatenação para a matriz final (H x W x 3)
    img_reconstruida = cat(3, uint8(R_channel), uint8(G_channel), uint8(B_channel));
    
    % Correção final de rotação
    img_recovered = rot90(img_reconstruida, -1);
    img_recovered = flip(img_recovered, 2);
    my_path = which('image_decoder');
    [dir, ~, ~] = fileparts(my_path);
    path = fullfile(dir, 'tmpImg.jpg');
    imwrite(img_recovered, path);
end