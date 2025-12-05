Fs = 2e6;
Fc = 100e3;
N_levels = 4;

% Parametros ruido
SNR = 100;
Perfil_MP = 0;
Ruido_fase = 0;
Desv_doppler = 0;

% Parametros equalizador - BPSK
% fwd_taps = 1;
% ref_tap = 1;
% forgetting_f = 0.9999;
% loop_bw = 0.05;
% damping = 1.0;

% Parametros equalizador - QPSK
% fwd_taps = 11;
% ref_tap = 9;
% forgetting_f = 0.99;
% loop_bw = 0.05;
% damping = 0.7;

% Parametros equalizador - QAM
% fwd_taps = 21;
% ref_tap = 19;
% forgetting_f = 0.999999;
% loop_bw = 0.005;
% damping = 1.0;

% Transmissor
nbits = 10000;
data = randi([0 1], 1, nbits);
[h, ~] = header(N_levels);
bits_tx = [h data];
hsz = length(h)
if N_levels == 1
    [t, I_coeffs, I_wave] = NRZ_polar_BPSK(bits_tx);
    if Desv_doppler == 0 && Ruido_fase == 0
        wave = modulate_cos(I_wave, t);
    else
        wave = modulate_dirty(I_wave, [], t, Ruido_fase, Desv_doppler);
    end

    syms_original = I_coeffs;
else
    [t, I_coeffs, Q_coeffs, I_wave, Q_wave, ~] = NRZ_polar_QAM(bits_tx, N_levels);
    wave_I = modulate_cos(I_wave, t);
    wave_Q = modulate_sin(Q_wave, t);

    if Desv_doppler == 0 && Ruido_fase == 0
        wave = wave_I + wave_Q;
    else
        wave = modulate_dirty(I_wave, Q_wave, t, Ruido_fase, Desv_doppler);
    end

    syms_original = I_coeffs + 1i*Q_coeffs;
end

% Canal
wave = canal(wave, t, Perfil_MP, SNR);

% Receptor
symbols = demodulate_single_carrier(wave, t, N_levels);
symbols = normalize(symbols);

header_size = (64+8)*N_levels + 1;

if N_levels == 1
    symbols_norm = BPSK_equalizer(symbols, fwd_taps, ref_tap, forgetting_f, loop_bw);
    symbols_lin = symbols_norm;

    bits_rx = slicer_demapper_BPSK(symbols);
    bits_eq = slicer_demapper_BPSK(symbols_norm);
    bits_eq2 = slicer_demapper_BPSK(symbols_lin);

else
    symbols_norm = single_carrier_equalize(symbols, N_levels, fwd_taps, fb_taps, ref_tap, forgetting_f, loop_bw);
    symbols_norm = normalize(symbols_norm);
    
    symbols_lin = single_carrier_eq_no_dfe(symbols, N_levels, fwd_taps, ref_tap, forgetting_f, loop_bw, damping);
    symbols_lin = normalize(symbols_lin);

    sliced_rx = slicer(symbols, N_levels);
    sliced_eq = slicer(symbols_norm, N_levels);
    sliced_eq2 = slicer(symbols_lin, N_levels);
    bits_rx = demapper(sliced_rx, N_levels);
    bits_eq = demapper(sliced_eq, N_levels);
    bits_eq2 = demapper(sliced_eq2, N_levels);
end

bits_rx = logical(bits_rx(header_size:end));
bits_eq = logical(bits_eq(header_size:end));
bits_eq2 = logical(bits_eq2(header_size:end));
data = logical(data);

err_rx = xor(bits_rx, data);
err_eq = xor(bits_eq, data);
err_eq2 = xor(bits_eq2, data);

ber_rx = sum(err_rx)/nbits;
ber_eq = sum(err_eq)/nbits;
ber_eq2 = sum(err_eq2)/nbits;

disp(ber_rx);
disp(ber_eq);
disp(ber_eq2);

% [ber_I, ber_Q, ~] = check_bit_ambiguity(symbols_norm, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);
% 
% rotated = conj(symbols_norm);
% [ber_I, ber_Q, ~] = check_bit_ambiguity(rotated, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);
% 
% rotated = - real(symbols_norm) + imag(symbols_norm)*1i;
% [ber_I, ber_Q, ~] = check_bit_ambiguity(rotated, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);
% 
% rotated = - real(symbols_norm) - imag(symbols_norm)*1i;
% [ber_I, ber_Q, ~] = check_bit_ambiguity(rotated, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);
% 
% rotated = imag(symbols_norm) + real(symbols_norm)*1i;
% [ber_I, ber_Q, ~] = check_bit_ambiguity(rotated, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);
% 
% rotated = -imag(symbols_norm) + real(symbols_norm)*1i;
% [ber_I, ber_Q, ~] = check_bit_ambiguity(rotated, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);
% 
% rotated = imag(symbols_norm) - real(symbols_norm)*1i;
% [ber_I, ber_Q, ~] = check_bit_ambiguity(rotated, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);
% 
% rotated = - imag(symbols_norm) - real(symbols_norm)*1i;
% [ber_I, ber_Q, ~] = check_bit_ambiguity(rotated, data, N_levels^2);
% disp(ber_I);
% disp(ber_Q);

% Constelação
Es = (2/3) * (N_levels^2 - 1);      
norm_factor = sqrt(1 / double(Es));
integers = -(double(N_levels-1)) : 2 : (double(N_levels-1));
if N_levels == 1
    levels = [-1 1];
    levels_I = levels;
    levels_Q = [0 0];
else
    levels = integers*norm_factor;
    [levels_I, levels_Q] = meshgrid(levels, levels);
end

subplot(1,3,1)
scatter(real(symbols), imag(symbols), 'filled');
hold on;
grid on;
title('Diagrama de Constelação Recebido');    
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
axis equal;
scatter(levels_I, levels_Q, 'r', 'x', 'LineWidth',1);

subplot(1,3,2)
scatter(real(symbols_norm(257:end)), imag(symbols_norm(257:end)), 'filled');
hold on;
grid on;
title('Diagrama de Constelação Equalizado');    
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
axis equal;
scatter(levels_I, levels_Q, 'r', 'x', 'LineWidth',1);

subplot(1,3,3)
scatter(real(symbols_lin(257:end)), imag(symbols_lin(257:end)), 'filled');
hold on;
grid on;
title('Diagrama de Constelação Equalizado 2');    
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
axis equal;
scatter(levels_I, levels_Q, 'r', 'x', 'LineWidth',1);