function [ber_I, ber_Q, final_bits] = check_bit_ambiguity(rx_symbols, tx_bits, M_order)
    % Testa qual bit stream (I ou Q) está invertido (180 graus).
    
    bits_per_sym = log2(M_order);
    
    % 1. Demodulação e Alinhamento
    rx_bits_raw = qamdemod(rx_symbols, M_order, 'OutputType', 'bit', 'UnitAveragePower', true);
    
    L = min(length(rx_bits_raw), length(tx_bits));
    rx_bits_raw = rx_bits_raw(1:L);
    tx_bits = tx_bits(1:L);
    
    % 2. Separação dos Streams I e Q (Assume-se que b1 é I e b2 é Q)
    % Coluna 1 (I), Coluna 2 (Q)
    rx_mat = reshape(rx_bits_raw, bits_per_sym, []).';
    tx_mat = reshape(tx_bits, bits_per_sym, []).';
    
    % 3. CÁLCULO DO ERRO PARA O EIXO I (Primeiro Bit)
    ber_I_normal = mean(xor(rx_mat(:, 1), tx_mat(:, 1)));
    ber_I_invert = mean(xor(xor(rx_mat(:, 1), 1), tx_mat(:, 1))); % Inverte RX e compara
    
    if ber_I_invert < ber_I_normal
        rx_mat(:, 1) = xor(rx_mat(:, 1), 1); % Aplica correção no I
    end
    ber_I = min(ber_I_normal, ber_I_invert);

    % 4. CÁLCULO DO ERRO PARA O EIXO Q (Segundo Bit)
    ber_Q_normal = mean(xor(rx_mat(:, 2), tx_mat(:, 2)));
    ber_Q_invert = mean(xor(xor(rx_mat(:, 2), 1), tx_mat(:, 2)));
    
    if ber_Q_invert < ber_Q_normal
        rx_mat(:, 2) = xor(rx_mat(:, 2), 1); % Aplica correção no Q
    end
    ber_Q = min(ber_Q_normal, ber_Q_invert);
    
    % 5. Saída: Bit stream corrigido
    final_bits = rx_mat.';
    final_bits = final_bits(:);
end