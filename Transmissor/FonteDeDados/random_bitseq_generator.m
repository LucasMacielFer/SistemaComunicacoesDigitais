function [data] = random_bitseq_generator(nLinhas, nBits)
% Uso Geral: Gera uma matriz aleatória de bits com dimensão nLinhas x nBits
arguments (Input)
    nLinhas (1,1) uint32
    nBits (1,1) uint32
end
    data = [];
    for i=1:nLinhas
        data = [data; randi([0 1], 1, nBits)];
    end
end