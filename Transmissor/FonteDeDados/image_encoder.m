function [imgSize, data] = image_encoder(filename)
% Função utilizada para abrir um arquivo de imagem de caminho "filename",
% obter os valores de seus pixels nos canais R, G e B e convertê-los para
% valores binários. A função retorna o tamanho da imagem, em binário, e uma
% matriz 8*h x 8*3*w. Cada linha da matriz contém os valores binários
% correspondentes aos canais R, G e B de seus pixels como elementos
% adjacentes. Exemplo: linha 1: 
% 0bRRRRRRRR 0bGGGGGGGG 0bBBBBBBBB 0bRRRRRRRR 0bGGGGGGGG 0bBBBBBBBB...
% refere-se aos 2 primeiros pixels da imagem.
arguments (Input)
    filename (1,:) char
end
    img = imread(filename);
    sz = size(img);
    imgSize = [sz(1) sz(2)];
    imgSize = dec2bin(imgSize,16)-'0';
    % L: Largura, A: Altura
    % 0bLLLLLLLLLLLLLLLL 0bAAAAAAAAAAAAAAAA
    imgSize = [imgSize(2,:), imgSize(1,:)];

    R = dec2bin(img(:,:,1),8);  % canal vermelho
    G = dec2bin(img(:,:,2),8);  % canal verde
    B = dec2bin(img(:,:,3),8);  % canal azul

    for j = 1:sz(1)
        for i = 1:sz(2)
            data(j,(i-1)*3+1) = R((j-1)*sz(2)+i,1);
            data(j,(i-1)*3+2) = G((j-1)*sz(2)+i,1);
            data(j,(i-1)*3+3) = B((j-1)*sz(2)+i,1);
        end
    end
    data = data-'0';
end