function data = image_encoder(filename)
% Função corrigida: Usa consistência de tipos (caracteres) para evitar o erro -48.
arguments (Input)
    filename (1,:) char
end
    img = imread(filename);
    sz = size(img);
    H = sz(1); 
    W = sz(2); 
    
    % --- 1. ENCODING DO TAMANHO (HEADER) ---
    H_bin = dec2bin(H, 16); % Caracteres
    W_bin = dec2bin(W, 16); % Caracteres
    header_bits_char = [H_bin, W_bin]; % Caracteres (32 bits)
    
    % --- 2. PREPARAÇÃO DOS DADOS DE PIXEL (Linearização) ---
    R = dec2bin(img(:,:,1), 8);  % Matriz de Caracteres (H*W linhas x 8 colunas)
    G = dec2bin(img(:,:,2), 8);  
    B = dec2bin(img(:,:,3), 8);  
    
    LARGURA_PIXEL_LINHA = W * 3 * 8; 
    
    % Inicializamos a matriz de bits dos pixels como CARACTERES '0'
    data_bits_pixels_unp = repmat('0', H, LARGURA_PIXEL_LINHA); % <-- CORREÇÃO
    
    % --- 3. REORGANIZAÇÃO DOS PIXELS ---
    for j = 1:H % Linhas
        for i = 1:W % Colunas/Pixels
            idx_achatado = (j-1)*W + i; 
            idx_saida = (i-1)*3*8 + 1; 
            
            % Atribuímos os caracteres binários diretamente (já são do tipo char)
            data_bits_pixels_unp(j, idx_saida : idx_saida + 7) = R(idx_achatado, :);
            data_bits_pixels_unp(j, idx_saida + 8 : idx_saida + 15) = G(idx_achatado, :);
            data_bits_pixels_unp(j, idx_saida + 16 : idx_saida + 23) = B(idx_achatado, :);
        end
    end
    
    % --- 4. EMBUTIR O HEADER E O PADDING ---
    TAMANHO_PAD = 32;
    LARGURA_TOTAL = LARGURA_PIXEL_LINHA + TAMANHO_PAD;
    
    % Inicializamos a matriz de saída final como CARACTERES '0'
    data = repmat('0', H, LARGURA_TOTAL); % <-- CORREÇÃO FINAL
    
    % A. Primeira Linha (HEADER + PIXELS)
    data(1, 1:TAMANHO_PAD) = header_bits_char; 
    data(1, TAMANHO_PAD + 1 : end) = data_bits_pixels_unp(1, :); 
    
    % B. Linhas Subsequentes (PADDING + PIXELS)
    for j = 2:H
        % O padding é zero (bits '0'). Já garantido pelo repmat('0').
        % data(j, 1:TAMANHO_PAD) = zeros(1, TAMANHO_PAD); <--- AGORA É '0's
        data(j, TAMANHO_PAD + 1 : end) = data_bits_pixels_unp(j, :); 
    end

    % --- 5. SAÍDA FINAL ---
    
    % Converte a matriz de caracteres binários ('0' e '1') para números (0 e 1)
    data = data - '0'; % <--- AGORA ESTA OPERAÇÃO É VÁLIDA PARA TODA A MATRIZ
end