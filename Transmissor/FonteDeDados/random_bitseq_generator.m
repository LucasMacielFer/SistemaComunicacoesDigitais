function [data] = random_bitseq_generator(nLinhas, nBits)
% Função utilizada para gerar uma sequência aleatória com comprimento nBits
arguments (Input)
    nLinhas (1,1) uint32
    nBits (1,1) uint32
end
    data = [];
    for i=1:nLinhas
        data = [data; randi([0 1], 1, nBits)];
    end
end