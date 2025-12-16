path = which('sistema.m');
[dir, ~, ~] = fileparts(path);

addpath ([dir '\Transmissor'])
addpath ([dir '\Transmissor\FonteDeDados'])
addpath ([dir '\Transmissor\BandaBase'])
addpath ([dir '\Transmissor\Modulacao'])
addpath ([dir '\Receptor'])
addpath ([dir '\Receptor\Demodulacao'])
addpath ([dir '\Receptor\BandaBase'])
addpath ([dir '\Receptor\Reconstrucao'])
addpath ([dir '\Receptor\Equalizacao'])
addpath ([dir '\Canal'])

% 10.000 bits de teste
testData = random_bitseq_generator(10,1000);

% BPSK
subplot(3,2,1);
title("Curva de BER - BPSK");
hold on;
EbNo_dB = -10:1:15;
ber_teorico = berawgn(EbNo_dB, 'psk', 2, 'nondiff');

set(gca, 'YScale', 'log');
h_line_teo = semilogy(EbNo_dB, ber_teorico, 'r-', 'LineWidth', 2);
h_line = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [0 0 1]);
h_line_conv = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [1 0 1]);

x_data = [];
y_data = [];
y_data_conv = [];

legend([h_line_teo, h_line, h_line_conv], {'Curva teórica', 'Curva obtida', 'Curva obtida (conv)'}, 'Location', 'best');

for snr = -10:1:15
    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_BPSK(testData, false, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 1, 256, 32, false, 0, 0, 0, snr);
    [ber, ber_eq, evm, evm_eq] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_BPSK(testData, true, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 1, 256, 32, true, 0, 0, 0, snr);
    [ber_c, ber_eq_c, evm_c, evm_eq_c] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    disp("BPSK - SNR = " + snr)
    disp("  BER = " + ber);
    disp("  BER equalizado = " + ber_eq);
    disp("  EVM = " + evm);
    disp("  EVM equalizado = " + evm_eq);
    disp("  BER (conv) = " + ber_c);
    disp("  BER equalizado (conv) = " + ber_eq_c);
    disp("  EVM (conv) = " + evm_c);
    disp("  EVM equalizado (conv) = " + evm_eq_c);

    x_data = [x_data, snr];
    y_data = [y_data, ber];
    y_data_conv = [y_data_conv ber_c];
    
    set(h_line, 'XData', x_data, 'YData', y_data);
    set(h_line_conv, 'XData', x_data, 'YData', y_data_conv);
    drawnow limitrate;
end

% QPSK
subplot(3,2,2);
title("Curva de BER - QPSK");
hold on;

EbNo_dB = -10:1:15;
ber_teorico = berawgn(EbNo_dB, 'psk', 4, 'nondiff');

set(gca, 'YScale', 'log');
h_line_teo = semilogy(EbNo_dB, ber_teorico, 'r-', 'LineWidth', 2);
h_line = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [0 0 1]);
h_line_conv = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [1 0 1]);

x_data = [];
y_data = [];
y_data_conv = [];

legend([h_line_teo, h_line, h_line_conv], {'Curva teórica', 'Curva obtida', 'Curva obtida (conv)'}, 'Location', 'best');

for snr = -10:1:15
    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 2, false, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 2, 256, 32, false, 0, 0, 0, snr);
    [ber, ber_eq, evm, evm_eq] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 2, true, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 2, 256, 32, true, 0, 0, 0, snr);
    [ber_c, ber_eq_c, evm_c, evm_eq_c] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    disp("QPSK - SNR = " + snr)
    disp("  BER = " + ber);
    disp("  BER equalizado = " + ber_eq);
    disp("  EVM = " + evm);
    disp("  EVM equalizado = " + evm_eq);
    disp("  BER (conv) = " + ber_c);
    disp("  BER equalizado (conv) = " + ber_eq_c);
    disp("  EVM (conv) = " + evm_c);
    disp("  EVM equalizado (conv) = " + evm_eq_c);

    x_data = [x_data, snr];
    y_data = [y_data, ber];
    y_data_conv = [y_data_conv ber_c];
    
    set(h_line, 'XData', x_data, 'YData', y_data);
    set(h_line_conv, 'XData', x_data, 'YData', y_data_conv);
    drawnow limitrate;
end

% 16-QAM
subplot(3,2,3);
title("Curva de BER - 16-QAM");
hold on;

EbNo_dB = -10:1:15;
ber_teorico = berawgn(EbNo_dB, 'qam', 16, 'nondiff');

set(gca, 'YScale', 'log');
h_line_teo = semilogy(EbNo_dB, ber_teorico, 'r-', 'LineWidth', 2);
h_line = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [0 0 1]);
h_line_conv = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [1 0 1]);

x_data = [];
y_data = [];
y_data_conv = [];

legend([h_line_teo, h_line, h_line_conv], {'Curva teórica', 'Curva obtida', 'Curva obtida (conv)'}, 'Location', 'best');

for snr = -10:1:15
    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 4, false, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 4, 256, 32, false, 0, 0, 0, snr);
    [ber, ber_eq, evm, evm_eq] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 4, true, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 4, 256, 32, true, 0, 0, 0, snr);
    [ber_c, ber_eq_c, evm_c, evm_eq_c] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    disp("16-QAM - SNR = " + snr)
    disp("  BER = " + ber);
    disp("  BER equalizado = " + ber_eq);
    disp("  EVM = " + evm);
    disp("  EVM equalizado = " + evm_eq);
    disp("  BER (conv) = " + ber_c);
    disp("  BER equalizado (conv) = " + ber_eq_c);
    disp("  EVM (conv) = " + evm_c);
    disp("  EVM equalizado (conv) = " + evm_eq_c);

    x_data = [x_data, snr];
    y_data = [y_data, ber];
    y_data_conv = [y_data_conv ber_c];
    
    set(h_line, 'XData', x_data, 'YData', y_data);
    set(h_line_conv, 'XData', x_data, 'YData', y_data_conv);
    drawnow limitrate;
end

% 64-QAM
subplot(3,2,4);
title("Curva de BER - 64-QAM");
hold on;

EbNo_dB = -10:1:15;
ber_teorico = berawgn(EbNo_dB, 'qam', 64, 'nondiff');

set(gca, 'YScale', 'log');
h_line_teo = semilogy(EbNo_dB, ber_teorico, 'r-', 'LineWidth', 2);
h_line = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [0 0 1]);
h_line_conv = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [1 0 1]);

x_data = [];
y_data = [];
y_data_conv = [];

legend([h_line_teo, h_line, h_line_conv], {'Curva teórica', 'Curva obtida', 'Curva obtida (conv)'}, 'Location', 'best');

for snr = -10:1:15
    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 8, false, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 8, 256, 32, false, 0, 0, 0, snr);
    [ber, ber_eq, evm, evm_eq] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 8, true, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 8, 256, 32, true, 0, 0, 0, snr);
    [ber_c, ber_eq_c, evm_c, evm_eq_c] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    disp("16-QAM - SNR = " + snr)
    disp("  BER = " + ber);
    disp("  BER equalizado = " + ber_eq);
    disp("  EVM = " + evm);
    disp("  EVM equalizado = " + evm_eq);
    disp("  BER (conv) = " + ber_c);
    disp("  BER equalizado (conv) = " + ber_eq_c);
    disp("  EVM (conv) = " + evm_c);
    disp("  EVM equalizado (conv) = " + evm_eq_c);

    x_data = [x_data, snr];
    y_data = [y_data, ber];
    y_data_conv = [y_data_conv ber_c];
    
    set(h_line, 'XData', x_data, 'YData', y_data);
    set(h_line_conv, 'XData', x_data, 'YData', y_data_conv);
    drawnow limitrate;
end


% 256-QAM
subplot(3,2,5);
title("Curva de BER - 256-QAM");
hold on;

EbNo_dB = -10:1:15;
ber_teorico = berawgn(EbNo_dB, 'qam', 256, 'nondiff');

set(gca, 'YScale', 'log');
h_line_teo = semilogy(EbNo_dB, ber_teorico, 'r-', 'LineWidth', 2);
h_line = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [0 0 1]);
h_line_conv = semilogy(NaN, NaN, 'o-', 'LineWidth', 1, 'Color', [1 0 1]);

x_data = [];
y_data = [];
y_data_conv = [];

legend([h_line_teo, h_line, h_line_conv], {'Curva teórica', 'Curva obtida', 'Curva obtida (conv)'}, 'Location', 'best');

for snr = -10:1:15
    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 16, false, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 16, 256, 32, false, 0, 0, 0, snr);
    [ber, ber_eq, evm, evm_eq] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    [symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_QAM(testData, 16, true, 0, 0, 0, snr);
    %[symbols_tx, symbols_rx, symbols_eq, bindata_rx, bindata_eq] = simulate_OFDM(testData, 16, 256, 32, true, 0, 0, 0, snr);
    [ber_c, ber_eq_c, evm_c, evm_eq_c] = calculate_metrics(testData, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq);

    disp("16-QAM - SNR = " + snr)
    disp("  BER = " + ber);
    disp("  BER equalizado = " + ber_eq);
    disp("  EVM = " + evm);
    disp("  EVM equalizado = " + evm_eq);
    disp("  BER (conv) = " + ber_c);
    disp("  BER equalizado (conv) = " + ber_eq_c);
    disp("  EVM (conv) = " + evm_c);
    disp("  EVM equalizado (conv) = " + evm_eq_c);

    x_data = [x_data, snr];
    y_data = [y_data, ber];
    y_data_conv = [y_data_conv ber_c];
    
    set(h_line, 'XData', x_data, 'YData', y_data);
    set(h_line_conv, 'XData', x_data, 'YData', y_data_conv);
    drawnow limitrate;
end
