function [decoded_bit_seq] = viterbi(encoded_bit_seq, g1, g2, len_orig)
% Uso geral: Decodificar os bits com código convolucional utilizando o
% alogirtmo de Viterbi. Aqui utilizo a função nativa do MATALAB "vitdec"
    k = length(g1);
    if k ~= length(g2)
        error("G1 e G2 devem ter tamanhos iguais!");
    end

    % Conversão dos polinômios String binária -> Octal
    dec_g1 = bin2dec(g1);
    dec_g2 = bin2dec(g2);
    oct_g1 = dec2base(dec_g1, 8);
    oct_g2 = dec2base(dec_g2, 8);
    
    oct_g1 = oct_g1 - '0';
    oct_g2 = oct_g2 - '0';

    g1_octal = oct_g1(1)*10 + oct_g1(2);
    g2_octal = oct_g2(1)*10 + oct_g2(2);
    
    trellis = poly2trellis(k, [g1_octal g2_octal]);
    decoded_bit_seq = vitdec(encoded_bit_seq, trellis, len_orig, 'term', 'hard');

    % Removem-se manualmente os bits de terminação
    tailSize = (length(g1)-1);
    decoded_bit_seq = decoded_bit_seq(1:end-tailSize);
end