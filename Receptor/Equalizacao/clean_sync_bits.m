function bits_limpos = clean_sync_bits(bits_com_headers, BITS_POR_BLOCO, mini_header_size_bits, num_bits_tx_total)
% Uso geral: Remover os sync_bits do meio das tramas de bits transmitidas
    num_blocos = ceil(num_bits_tx_total / BITS_POR_BLOCO);
    bits_limpos = zeros(1, num_bits_tx_total); 
    idx_leitura = 1;
    idx_escrita_limpa = 1;

    for b = 1:num_blocos
        idx_leitura = idx_leitura + mini_header_size_bits; 
        
        tamanho_bloco = min(BITS_POR_BLOCO, num_bits_tx_total - (idx_escrita_limpa - 1));
        
        if tamanho_bloco > 0
            bloco_dados = bits_com_headers(idx_leitura : idx_leitura + tamanho_bloco - 1);
            bits_limpos(idx_escrita_limpa : idx_escrita_limpa + tamanho_bloco - 1) = bloco_dados;
        end
        
        idx_leitura = idx_leitura + tamanho_bloco;
        idx_escrita_limpa = idx_escrita_limpa + tamanho_bloco;
    end
end