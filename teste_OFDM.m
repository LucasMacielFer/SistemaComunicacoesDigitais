clc; clear; close all;

%% 1. PARÂMETROS DO SISTEMA
N_carriers = 64;     % Tamanho da FFT
N_levels = 4;       % 16-QAM
N_pilots = 8;        % <-- QUANTIDADE DE PILOTOS (Variável)
Fs = 2e6;            % Taxa de amostragem

% Simulação
N_sym_ofdm = 1000;   % Número de símbolos OFDM no tempo
bits_per_sym = log2(N_levels);
est_data_carriers = 48; % Estimativa para buffer
nbits = ceil(est_data_carriers * N_sym_ofdm * bits_per_sym);

%% 2. TRANSMISSOR (TX)
fprintf('1. Modulando...\n');

% A. Gerar Bits
bits_tx = randi([0 1], 1, nbits);

% B. Mapear QAM (Simulando sua função NRZ_polar_QAM apenas na parte dos coeficientes)
% Usamos qammod para garantir compatibilidade direta com o seu demapper
[~, I_coeffs, Q_coeffs, ~, ~, ~] = NRZ_polar_QAM(bits_tx, N_levels);
sym_qam = I_coeffs + 1i*Q_coeffs;

% C. MODULAÇÃO OFDM (SUA FUNÇÃO)
[tx_signal, t, params] = OFDM_baseband(sym_qam, N_carriers, N_pilots);
wave_I = modulate_cos(real(tx_signal), t, 400e3);
wave_Q = modulate_sin(imag(tx_signal), t, 400e3);
wave = wave_I + wave_Q;
wave = canal(wave, t, 4, 20);

%% 4. RECEPTOR (RX) - MODULARIZADO
fprintf('3. Demodulando...\n');

% A. FRONTEND (Tempo -> Frequência)
% Esta função faz apenas: S/P -> Remove CP -> FFT
rx_signal = demodulate_OFDM(wave, t, 400e3);
rx_grid_suja = OFDM_prepare_grid(rx_signal, params);

% B. EQUALIZAÇÃO (A CORREÇÃO ANTES DA EXTRAÇÃO)
% Aqui o sinal entra sujo e sai limpo ("bonitinho")

% 1. Determinar dimensões reais baseadas no que chegou (O Recorte já foi feito)
[rx_grid_bonitinha, ch_estimation] = OFDM_equalize(rx_grid_suja, params);

% C. EXTRAÇÃO DE DADOS (SUA FUNÇÃO PURA)
% A função recebe a grade já limpa e só tira os dados
rx_syms_serial = OFDM_slicer(rx_grid_bonitinha, params);

% D. Ajuste de tamanho (corta padding se houver)
len_original = length(sym_qam);
if length(rx_syms_serial) > len_original
    rx_syms_final = rx_syms_serial(1:len_original);
else
    rx_syms_final = rx_syms_serial;
end

%% 5. DEMAPPER (SUA FUNÇÃO)
bits_rx = demapper(rx_syms_final.', N_levels);

%% 6. RESULTADOS
% BER
n_bits_comp = min(length(bits_tx), length(bits_rx));
[~, ber] = biterr(bits_tx(1:n_bits_comp), bits_rx(1:n_bits_comp));

figure('Position', [100 100 1200 400]);
subplot(1,3,1); 
plot(rx_grid_suja(params.idx_data, 1:200), 'r.'); title('Grade Suja (Pós-FFT)'); axis square;
subplot(1,3,2); 
plot(rx_syms_final(1:2000), 'g.'); title(['Grade Bonitinha (Equalizada) BER: ' num2str(ber)]); axis square;
subplot(1,3,3); 
plot(20*log10(abs(ch_estimation(:,1))), 'LineWidth', 2); title('Resposta do Canal'); ylabel('dB');