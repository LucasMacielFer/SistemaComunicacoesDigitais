function [output] = conv_encoder(binseq, g1, g2)
% Uso geral: Codificar os bits com código convolucional para adicionar
% robustez ao sistema. Aqui utilizo a função nativa do MATALAB "convenc"

    k = length(g1);

    if k ~= length(g2) || k > 6
        error("G1 e G2 devem ter tamanhos iguais e inferiores a 7");
    end

    % Conversão dos polinômios String binária -> Octal
    dec_g1 = bin2dec(g1);
    dec_g2 = bin2dec(g2);
    oct_g1 = dec2base(dec_g1, 8);
    oct_g2 = dec2base(dec_g2, 8);

    % Adicionam-se manualmente os bits de terminação (zerar os FFs)
    tailSize = (length(g1)-1);
    tail = zeros(1, tailSize);

    oct_g1 = oct_g1 - '0';
    oct_g2 = oct_g2 - '0';

    g1_octal = oct_g1(1)*10 + oct_g1(2);
    g2_octal = oct_g2(1)*10 + oct_g2(2);
    
    % Trellis
    binseqWithTail = [binseq tail];
    trellis = poly2trellis(k, [g1_octal g2_octal]);

    % Codificação
    output = convenc(binseqWithTail, trellis);
end