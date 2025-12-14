function bits = demapper(symbols_hat, N_levels)
% Uso geral: Decodificar os símbolos QAM recebidos para bits.
arguments(Input)
    symbols_hat 
    N_levels {mustBeMember(N_levels, [2, 4, 8, 16])}
end   
    switch N_levels
        case 1,  k = 1; % BPSK
        case 2,  k = 1; % QPSK
        case 4,  k = 2; % 16-QAM
        case 8,  k = 3; % 64-QAM
        case 16, k = 4; % 256-QAM
    end

    num_symbols = length(symbols_hat);
    bits = zeros(1, num_symbols * 2 * k);

    % Normalização por energia média do símbolo
    integers = -(double(N_levels-1)) : 2 : (double(N_levels-1));
    M = N_levels^2;
    Es = (2/3) * (M - 1); 
    norm_factor = sqrt(1 / double(Es));
    levels = integers * norm_factor;

    idx_fill = 1;

    for i = 1:length(symbols_hat)
        % Separar I e Q
        I_val = real(symbols_hat(i));
        Q_val = imag(symbols_hat(i));

        % Encontrar índice do nível mais próximo (0..N_levels-1)
        [~, idx_I] = min(abs(I_val - levels));
        [~, idx_Q] = min(abs(Q_val - levels));

        idx_I = idx_I - 1; % converter para 0-based
        idx_Q = idx_Q - 1;

        % --- DESFAZER GRAY CODE ---
        I_bin = zeros(1, k);
        I_bin(1) = bitget(idx_I, k);
        for b = 2:k
            I_bin(b) = bitget(idx_I, k-b+1) ~= I_bin(b-1); % XOR para desfazer Gray
        end

        Q_bin = zeros(1, k);
        Q_bin(1) = bitget(idx_Q, k);
        for b = 2:k
            Q_bin(b) = bitget(idx_Q, k-b+1) ~= Q_bin(b-1);
        end

        bits(idx_fill : idx_fill + k - 1) = I_bin;
        bits(idx_fill + k : idx_fill + 2*k - 1) = Q_bin;
        idx_fill = idx_fill + 2*k;
    end
end