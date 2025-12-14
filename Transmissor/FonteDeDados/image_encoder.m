function data = image_encoder(filename)
% Uso geral: Carrega uma imagem de "filename" e a converte em uma matriz
% bi-dimensional de bits, com cada pixel no seguinte formato:
% 0bRRRRRRRR 0bGGGGGGGG 0bBBBBBBBB (pixel 1,1)
% Além disso, adiciona o tamanho da imagem como cabeçalho.
arguments (Input)
    filename (1,:) char
end
    img = imread(filename);
    sz = size(img);
    H = sz(1); 
    W = sz(2); 
    
    % Cabeçalho - tamanho da imagem
    H_bin = dec2bin(H, 16);
    W_bin = dec2bin(W, 16);
    header_bits_char = [H_bin, W_bin];
    
    % Linearização dos 3 canais
    R = dec2bin(img(:,:,1), 8);
    G = dec2bin(img(:,:,2), 8);  
    B = dec2bin(img(:,:,3), 8);  
    
    LARGURA_PIXEL_LINHA = W * 3 * 8; 
    
    data_bits_pixels_unp = repmat('0', H, LARGURA_PIXEL_LINHA);
    
    for j = 1:H
        for i = 1:W
            idx_achatado = (j-1)*W + i; 
            idx_saida = (i-1)*3*8 + 1; 
            
            data_bits_pixels_unp(j, idx_saida : idx_saida + 7) = R(idx_achatado, :);
            data_bits_pixels_unp(j, idx_saida + 8 : idx_saida + 15) = G(idx_achatado, :);
            data_bits_pixels_unp(j, idx_saida + 16 : idx_saida + 23) = B(idx_achatado, :);
        end
    end
    
    % Cabeçalho + padding
    TAMANHO_PAD = 32;
    LARGURA_TOTAL = LARGURA_PIXEL_LINHA + TAMANHO_PAD;
    
    % Inicialização a matriz de saída final
    data = repmat('0', H, LARGURA_TOTAL);
    
    % Primeira Linha (HEADER + PIXELS)
    data(1, 1:TAMANHO_PAD) = header_bits_char; 
    data(1, TAMANHO_PAD + 1 : end) = data_bits_pixels_unp(1, :); 
    
    % Linhas Subsequentes (PADDING + PIXELS)
    for j = 2:H
        data(j, TAMANHO_PAD + 1 : end) = data_bits_pixels_unp(j, :); 
    end
    
    % Converte a matriz de caracteres binários ('0' e '1') para números (0 e 1)
    data = data - '0';
end