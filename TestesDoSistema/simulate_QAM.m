function [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(bindata_tx, N_levels, convActive, phase, doppler, multipath, snr)
% Uso geral: Executar todo o pipeline de simulação para transmissão com
% modulação QAM em single carrier. Há uma função semelhante dentro da
% aplicação final, que utiliza os parâmetros da classe. O funcionamento é
% exatamente o mesmo.
    
    k = 2*log2(N_levels); 

    dataSize = size(bindata_tx);
    spb = 200;
    fc = 100e3;

    [sync_bits_data, ~] = sync_bits(N_levels);
    mini_header_size_bits = length(sync_bits_data);
    
    BITS_POR_BLOCO = 192;
    headerSize = 72*k; 
    
    dados_por_linha_orig = dataSize(2); 
    
    if convActive
        convG1 = '10101';
        convG2 = '10111';
        
        K_mem = length(convG1);
        num_bits_dados_tx = 2 * (dados_por_linha_orig + K_mem - 1);
    else
        num_bits_dados_tx = dados_por_linha_orig;
    end
    
    num_blocos = ceil(num_bits_dados_tx / BITS_POR_BLOCO);
    overhead_sync_bits = num_blocos * mini_header_size_bits;
    num_bits_total_com_sync = num_bits_dados_tx + overhead_sync_bits;
    num_symbols_final = ceil(num_bits_total_com_sync / k);

    bindata_rx = zeros(dataSize(1), dados_por_linha_orig); 
    bindata_eq = zeros(dataSize(1), dados_por_linha_orig);
    
    symbols_tx = zeros(dataSize(1), num_symbols_final);
    symbols_rx = zeros(dataSize(1), num_symbols_final);
    symbols_eq = zeros(dataSize(1), num_symbols_final);

    waveformI = zeros(1, num_symbols_final * spb);
    waveformQ = zeros(1, num_symbols_final * spb);
    waveform = zeros(1, num_symbols_final * spb);
    coeffsI = zeros(1, num_symbols_final);
    coeffsQ = zeros(1, num_symbols_final);

    binData_com_sync_tmp = zeros(1, headerSize + num_bits_total_com_sync);

    for i=1:dataSize(1)
        
        % TX
        if convActive
            bits_tx_codificados = conv_encoder(bindata_tx(i, :), convG1, convG2);
        else
            bits_tx_codificados = bindata_tx(i, :);
        end
                        
        [binHeader, ~] = header(N_levels);
        binData_com_sync_tmp(1, 1:headerSize) = binHeader;

        idx_leitura_dados = 1; 
        idx_escrita_final = headerSize + 1;
        
        for b = 1:num_blocos
            binData_com_sync_tmp(1, idx_escrita_final : idx_escrita_final + mini_header_size_bits - 1) = sync_bits_data;
            idx_escrita_final = idx_escrita_final + mini_header_size_bits;
            
            tamanho_dados = min(BITS_POR_BLOCO, num_bits_dados_tx - (idx_leitura_dados - 1));

            if tamanho_dados > 0
                bloco_dados = bits_tx_codificados(idx_leitura_dados : idx_leitura_dados + tamanho_dados - 1);
                binData_com_sync_tmp(1, idx_escrita_final : idx_escrita_final + tamanho_dados - 1) = bloco_dados;
                
                idx_leitura_dados = idx_leitura_dados + tamanho_dados;
                idx_escrita_final = idx_escrita_final + tamanho_dados;
            end
        end
        
        [time, coeffsI, coeffsQ, waveformI, waveformQ] = NRZ_polar_QAM(binData_com_sync_tmp, N_levels);
        waveform = modulate_single_carrier(waveformI, waveformQ, time, phase, doppler, fc);
        
        % Canal
        waveform = canal(waveform, time, multipath, snr, N_levels, convActive);
        
        % RX - Demodulação e Normalização
        symbols_raw = demodulate_single_carrier(waveform, time, N_levels);
        symbols_raw = normalize(symbols_raw);
        
        if N_levels == 2
            fwd_taps = 11;
            ref_tap = 9;
            forgetting_f = 0.99;
            loop_bw = 0.05;
            damping = 0.7;
            symbols_eq_output = QPSK_equalizer(symbols_raw, N_levels, fwd_taps, ref_tap, forgetting_f, loop_bw, damping);
        else
            symbols_eq_output = QAM_equalizer(symbols_raw, N_levels);
        end
        symbols_eq_output = normalize(symbols_eq_output);
        
        
        idx_simbolo_inicio_dados = ceil(headerSize / k) + 1;
        
        symbols_tx(i,:) = coeffsI(idx_simbolo_inicio_dados:end) + 1i*coeffsQ(idx_simbolo_inicio_dados:end);  
        symbols_rx(i,:) = symbols_raw(idx_simbolo_inicio_dados:end);
        symbols_eq(i,:) = symbols_eq_output(idx_simbolo_inicio_dados:end);
        
        bits_rx_com_sync = demapper(slicer(symbols_rx(i,:), N_levels), N_levels);
        bits_rx_limpos = clean_sync_bits(bits_rx_com_sync, BITS_POR_BLOCO, mini_header_size_bits, num_bits_dados_tx);
        
        bits_eq_com_sync = demapper(slicer(symbols_eq(i,:), N_levels), N_levels);
        bits_eq_limpos = clean_sync_bits(bits_eq_com_sync, BITS_POR_BLOCO, mini_header_size_bits, num_bits_dados_tx);
        
        if convActive
            bindata_rx(i,:) = viterbi(bits_rx_limpos, convG1, convG2, dataSize(2));
            bindata_eq(i,:) = viterbi(bits_eq_limpos, convG1, convG2, dataSize(2));
        else
            bindata_rx(i,:) = bits_rx_limpos;
            bindata_eq(i,:) = bits_eq_limpos;
        end
    end
end