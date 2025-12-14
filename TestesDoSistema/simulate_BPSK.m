function [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_BPSK(bindata_tx, convActive, phase, doppler, multipath, snr)
% Uso geral: Executar todo o pipeline de simulação para transmissão com
% modulação BPSK em single carrier. Há uma função semelhante dentro da
% aplicação final, que utiliza os parâmetros da classe. O funcionamento é
% exatamente o mesmo.

    dataSize = size(bindata_tx);
    spb = 200;
    fc = 100e3;

    bindata_rx = zeros(dataSize(1), dataSize(2));
    bindata_eq = zeros(dataSize(1), dataSize(2));
    
    if convActive
        convG1 = '11011';
        convG2 = '10101';

        K_mem = length(convG1);
        num_bits = 2 * (dataSize(2) + K_mem - 1);

        binData = zeros(1, 64+8+num_bits);
        binData(1,73:end) = conv_encoder(bindata_tx(1, :), convG1, convG2);

    else
        num_bits = dataSize(2);
        binData = zeros(1, 64+8+num_bits);
        binData(1,73:end) = bindata_tx(1, :);
    end

    symbols_tmp = zeros(1, (num_bits+64+8));
    symbols_tmp_eq = zeros(1, (num_bits+64+8));
    bits_tmp = zeros(1, (num_bits+64+8));
    bits_tmp_eq = zeros(1, (num_bits+64+8));
    waveformI = zeros(1, (num_bits+64+8)*spb);
    waveform = zeros(1, (num_bits+64+8)*spb);
    coeffsI = zeros(1, 64+8+num_bits);

    symbols_tx = zeros(dataSize(1), num_bits);
    symbols_rx = zeros(dataSize(1), num_bits);
    symbols_eq = zeros(dataSize(1), num_bits);

    [binHeader, ~] = header(1);
    binData(1,1:72) = binHeader;
    
    [time, ~, ~] = NRZ_polar_BPSK(binData);

    for i=1:dataSize(1)
        % TX
        if convActive
            binData(1,73:end) = conv_encoder(bindata_tx(i, :), convG1, convG2);
        else
            binData(1,73:end) = bindata_tx(i, :);
        end

        [~, coeffsI, waveformI] = NRZ_polar_BPSK(binData);
        waveform = modulate_single_carrier(waveformI, [], time, phase, doppler, fc);

        % Canal
        waveform = canal(waveform, time, multipath, snr, 1, convActive);

        % RX
        symbols_tmp = demodulate_single_carrier(waveform, time, 1);
        symbols_tmp_eq = BPSK_equalizer(symbols_tmp, 72);
        symbols_tmp = symbols_tmp(73:end);
        symbols_tmp_eq = symbols_tmp_eq(73:end);
        bits_tmp = slicer_demapper_BPSK(symbols_tmp);
        bits_tmp = bits_tmp(1:num_bits);
        bits_tmp_eq = slicer_demapper_BPSK(symbols_tmp_eq);
        bits_tmp_eq = bits_tmp_eq(1:num_bits);

        % Inserir na matriz de dados novamente
        symbols_tx(i,:) = coeffsI(73:end);
        symbols_rx(i,:) = symbols_tmp;
        symbols_eq(i,:) = symbols_tmp_eq;

        if convActive
            bindata_rx(i,:) = viterbi(bits_tmp, convG1, convG2, dataSize(2));
            bindata_eq(i,:) = viterbi(bits_tmp_eq, convG1, convG2, dataSize(2));
        else
            bindata_rx(i,:) = bits_tmp;
            bindata_eq(i,:) = bits_tmp_eq;
        end
    end
end