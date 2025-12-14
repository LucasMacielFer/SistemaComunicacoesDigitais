function [data] = ASCII_encoder(msg_string)
% Uso geral: Converter texto em valores numéricos da tabela
% ASCII Expandida, e posteriormente convertê-los em bits
arguments
    msg_string (1,:) char
end
    msg_dec = uint8(msg_string);
    msg_bin = dec2bin(msg_dec, 8);
    bin_seq = [];
    for i = 1:size(msg_bin,1)
        bin_seq = [bin_seq, msg_bin(i, :)];
    end
    data = bin_seq-'0';
end