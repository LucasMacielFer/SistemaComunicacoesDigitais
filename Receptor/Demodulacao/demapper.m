function bits = demapper(symbols_hat, N_levels)
% symbols_hat: vetor de símbolos complexos normalizados [-1,1]
% N_levels: níveis por eixo (sqrt da constelação)
% Retorna bits como vetor linha
%
% Exemplo: 64-QAM -> N_levels=8, k=3 bits por eixo

    switch N_levels
        case 1,  k = 1; % BPSK
        case 4,  k = 2; % 16-QAM
        case 8,  k = 3; % 64-QAM
        case 16, k = 4; % 256-QAM
        otherwise, error('Nível de modulação não suportado.');
    end

    bits = [];

    % Criar níveis uniformes [-1, 1] por eixo
    levels = linspace(-1, 1, N_levels);

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

        % Concatenar bits I e Q
        bits = [bits, I_bin, Q_bin];
    end
end