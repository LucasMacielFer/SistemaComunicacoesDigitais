clc; clear; close all;

%% 1. PARÂMETROS DO SISTEMA
N_carriers = 64;     % Tamanho da FFT
N_levels = 16;       % 16-QAM
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
sym_qam = qammod(bits_tx(:), N_levels, 'InputType', 'bit', 'UnitAveragePower', true);

% C. MODULAÇÃO OFDM (SUA FUNÇÃO)
[tx_signal, params] = OFDM_baseband(sym_qam, N_carriers, N_pilots);

%% 3. CANAL (RAYLEIGH + AWGN)
fprintf('2. Canal...\n');

channel = comm.RayleighChannel(...
    'SampleRate', Fs, ...
    'PathDelays', [0 100e-9], ...    % Delay curto para facilitar interpolação
    'AveragePathGains', [0 -10], ... % Eco de -10dB
    'MaximumDopplerShift', 0);       % Estático

rx_signal_faded = channel(tx_signal);
rx_signal_raw = awgn(rx_signal_faded, 30, 'measured'); % SNR=30dB (Bom sinal)

% Sincronização Ideal (Compensar atraso do filtro do canal)
delay = channel.info.ChannelFilterDelay;
rx_signal = rx_signal_raw(delay+1 : end);

%% 4. RECEPTOR (RX) - MODULARIZADO
fprintf('3. Demodulando...\n');

% A. FRONTEND (Tempo -> Frequência)
% Esta função faz apenas: S/P -> Remove CP -> FFT
rx_grid_suja = OFDM_prepare_grid(rx_signal, params);

% B. EQUALIZAÇÃO (A CORREÇÃO ANTES DA EXTRAÇÃO)
% Aqui o sinal entra sujo e sai limpo ("bonitinho")

N_fft = params.N_fft;
idx_pilots = params.idx_pilots;
val_pilots = params.val_pilots;
[~, num_cols] = size(rx_grid_suja);

% Matriz de equalização (inicia como 1 = bypass)
H_est_full = ones(N_fft, num_cols);

if ~isempty(idx_pilots)
    % 1. Extrair pilotos recebidos
    rx_pilots = rx_grid_suja(idx_pilots, :);
    
    % 2. Estimar Canal (H = Rx / Tx)
    H_pilots = rx_pilots ./ val_pilots;
    
    % 3. Interpolar
    all_carriers = (1:N_fft).';
    for i = 1:num_cols
        H_est_full(:, i) = interp1(idx_pilots, H_pilots(:, i), all_carriers, 'linear', 'extrap');
    end
else
    fprintf('Aviso: Sem pilotos. Sinal não será equalizado.\n');
end

% APLICA A CORREÇÃO
rx_grid_bonitinha = rx_grid_suja ./ H_est_full;

% C. EXTRAÇÃO DE DADOS (SUA FUNÇÃO PURA)
% A função recebe a grade já limpa e só tira os dados
rx_syms_serial = OFDM_demodulate(rx_grid_bonitinha, params);

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
plot(rx_syms_final(1:2000), 'b.'); title(['Grade Bonitinha (Equalizada) BER: ' num2str(ber)]); axis square;
subplot(1,3,3); 
plot(20*log10(abs(H_est_full(:,1))), 'LineWidth', 2); title('Resposta do Canal'); ylabel('dB');