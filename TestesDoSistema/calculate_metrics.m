function [ber, ber_eq, evm, evm_eq] = calculate_metrics(bindata_tx, bindata_rx, bindata_eq, symbols_tx, symbols_rx, symbols_eq)
            tx_bits = bindata_tx(:);
            rx_bits = bindata_rx(:);
            rx_eq_bits = bindata_eq(:);
            
            tx_symbols = symbols_tx(:);
            rx_symbols = symbols_rx(:);
            rx_eq_symbols = symbols_eq(:);
            
            N_bits_total = length(tx_bits);
            N_symbols_total = length(tx_symbols);
        
            
            % BER RX (Antes da Equalização)
            errors_rx = sum(tx_bits ~= rx_bits);
            ber = errors_rx / N_bits_total;
            
            % BER RX Equalizado (Após a Equalização)
            errors_rx_eq = sum(tx_bits ~= rx_eq_bits);
            ber_eq = errors_rx_eq / N_bits_total;
        
            P_ref = sum(abs(tx_symbols).^2) / N_symbols_total;
            
            % EVM RX (Antes da Equalização)
            error_vector_rx = rx_symbols - tx_symbols;
            P_error_rx = sum(abs(error_vector_rx).^2) / N_symbols_total;
            
            % EVM = sqrt(P_error / P_ref) * 100%
            evm = sqrt(P_error_rx / P_ref);
            
            % EVM RX Equalizado (Após a Equalização)
            error_vector_rx_eq = rx_eq_symbols - tx_symbols;
            P_error_rx_eq = sum(abs(error_vector_rx_eq).^2) / N_symbols_total;
            
            evm_eq = sqrt(P_error_rx_eq / P_ref);
        end