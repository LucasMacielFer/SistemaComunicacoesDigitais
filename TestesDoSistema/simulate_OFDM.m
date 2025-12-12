function [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(bindata_tx, N_levels, subcarriers, pilots, convActive, phase, doppler, multipath, snr)
   
    dataSize = size(bindata_tx);
    fc = 400e3;

    subcarriers = 64;
    pilots = 8;

    k = 2*log2(N_levels);
    if N_levels == 1, k = 1; end

    bindata_rx = zeros(dataSize(1), dataSize(2));
    bindata_eq = zeros(dataSize(1), dataSize(2));

    if convActive
        convG1 = '10101';
        convG2 = '10111';
        K_mem = length(convG1);
        num_bits = 2 * (dataSize(2) + K_mem - 1);
    else
        num_bits = dataSize(2);
    end

    % pré-alocação dos vetores
    symbols_tx = zeros(dataSize(1), ceil(num_bits/k));
    symbols_rx = zeros(dataSize(1), ceil(num_bits/k));
    symbols_eq = zeros(dataSize(1), ceil(num_bits/k));

    if N_levels == 1
        coeffsI = zeros(num_bits);
        symbols = zeros(num_bits);
    else
        coeffsI = zeros(ceil(num_bits/k));
        coeffsQ = zeros(ceil(num_bits/k));
        symbols = zeros(ceil(num_bits/k));
    end

    for i=1:dataSize(1)
        
        if convActive
            binData = conv_encoder(bindata_tx(i, :), convG1, convG2);
        else
            binData = bindata_tx(i, :);
        end
        
        if N_levels == 1
            [~, coeffsI, ~] = NRZ_polar_BPSK(binData);
            symbols = coeffsI;
        else
            [~, coeffsI, coeffsQ, ~, ~, ~] = NRZ_polar_QAM(binData, N_levels);
            symbols = coeffsI + 1i*coeffsQ;
        end

        [ofdmBaseband, time, params] = OFDM_baseband(symbols, subcarriers, pilots);

        [ofdmPassband, time] = modulate_single_carrier(real(ofdmBaseband), imag(ofdmBaseband), time, phase, doppler, fc);
        ofdmPassband = canal(ofdmPassband, time, multipath, snr, N_levels, convActive);

        rxBaseband = demodulate_OFDM(ofdmPassband, time, fc);
        rxDirtyGrid = OFDM_prepare_grid(rxBaseband, params);

        rxSymbols = OFDM_slicer(rxDirtyGrid, params);
        if length(rxSymbols) > length(symbols)
            rxSymbolsFinal = rxSymbols(1:length(symbols));
        else
            rxSymbolsFinal = rxSymbols;
        end
        rxSymbolsFinal = normalize(rxSymbolsFinal);

        % Estou a reutilizar o mesmo buffer de antes
        binData = demapper(rxSymbolsFinal.', N_levels);
        
        if convActive
            binData = viterbi(binData, convG1, convG2, dataSize(2));
        end

        symbols_rx(i,:) = rxSymbolsFinal;
        bindata_rx(i,:) = binData(1:dataSize(2));

        [rxCleanGrid, ~] = OFDM_equalizer(rxDirtyGrid, params);
        rxSymbols = OFDM_slicer(rxCleanGrid, params);

        if length(rxSymbols) > length(symbols)
            rxSymbolsFinal = rxSymbols(1:length(symbols));
        else
            rxSymbolsFinal = rxSymbols;
        end
        rxSymbolsFinal = normalize(rxSymbolsFinal);

        % Estou a reutilizar o mesmo buffer de antes
        binData = demapper(rxSymbolsFinal.', N_levels);
        
        if convActive
            binData = viterbi(binData, convG1, convG2, dataSize(2));
        end

        bindata_eq(i,:) = binData(1:dataSize(2));
        symbols_tx(i,:) = symbols;
        symbols_eq(i,:) = rxSymbolsFinal;
    end
end