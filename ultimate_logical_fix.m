function [best_ber, final_bits_corrected] = ultimate_logical_fix(rx_symbols, tx_bits, N_levels)
    % TESTA TODAS AS 8 AMBIGUIDADES LÓGICAS E DE ORDEM DE EIXO
    
    M_order = N_levels^2;
    bits_per_sym = log2(M_order);
    
    % --- 1. Demodulação e Separação ---
    rx_bits_raw = qamdemod(rx_symbols, M_order, 'OutputType', 'bit', 'UnitAveragePower', true);
    L = min(length(rx_bits_raw), length(tx_bits));
    
    rx_bits_raw = rx_bits_raw(1:L);
    tx_bits = tx_bits(1:L);
    
    % Divide em colunas (bit-stream I, bit-stream Q, etc.)
    rx_mat = reshape(rx_bits_raw, bits_per_sym, []).'; 
    tx_mat = reshape(tx_bits, bits_per_sym, []).';
    
    min_ber_total = 1.0;
    final_best_bits = [];
    
    % --- 2. LOOP DE CORREÇÃO (4 Testes de Eixo x 2 Inversões) ---
    
    % Existem 4 eixos para os 4 bits de QPSK: b1, b2, b3, b4.
    % Vamos testar se o stream que o demodulador está a ler é I ou Q,
    % e se está invertido.
    
    % O I/Q swap para QPSK é o mais crítico (coluna 1 vs coluna 2)
    
    % Itera sobre 4 estados de fase (0, 90, 180, 270) que causam swap/inversão
    % E testa todas as 4 possíveis inversões lógicas de sinal (+-I, +-Q)
    
    for i_swap = [0, 1] % Swap Sim/Não
        for flip_I = [0, 1] % Inverter Eixo I?
            for flip_Q = [0, 1] % Inverter Eixo Q?
                
                rx_test = rx_mat;
                
                % 2A. APLICAR SWAP LÓGICO (Simula a troca de 90/270 graus)
                if i_swap == 1
                    % Troca as colunas de bits I e Q (Ex: Coluna 1 vs 2)
                    rx_test(:, [1, 2]) = rx_mat(:, [2, 1]);
                end
                
                % 2B. APLICAR INVERSÃO DE SINAL (XOR Flip)
                if flip_I == 1
                    rx_test(:, 1) = xor(rx_test(:, 1), 1);
                end
                if flip_Q == 1
                    rx_test(:, 2) = xor(rx_test(:, 2), 1);
                end
                
                % 2C. CALCULAR BER
                num_errors = sum(sum(xor(rx_test, tx_mat)));
                current_ber = num_errors / L;
                
                % 2D. ATUALIZAR MELHOR RESULTADO
                if current_ber < min_ber_total
                    min_ber_total = current_ber;
                    final_best_bits = rx_test;
                end
            end
        end
    end
    
    % --- 3. SAÍDA ---
    
    final_bits_corrected = final_best_bits.';
    final_bits_corrected = final_bits_corrected(:);
    best_ber = min_ber_total;
end