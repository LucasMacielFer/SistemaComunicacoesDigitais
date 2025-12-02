function symbols_hat = slicer(symbols_rx, N_levels)
% symbols_rx: vetor de símbolos complexos recebidos
% N_levels: número de níveis por eixo (sqrt da constelação)
% Símbolos normalizados entre -1 e 1
% Retorna symbols_hat: símbolos "decididos" na constelação

    % Criar níveis uniformes entre -1 e 1
    levels = linspace(-1, 1, N_levels);
    
    % Separar I e Q
    I_rx = real(symbols_rx);
    Q_rx = imag(symbols_rx);
    
    % Inicializar vetores decididos
    I_hat = zeros(size(I_rx));
    Q_hat = zeros(size(Q_rx));
    
    % Slicing: escolher o nível mais próximo
    for i = 1:length(I_rx)
        [~, idx_I] = min(abs(I_rx(i) - levels));
        [~, idx_Q] = min(abs(Q_rx(i) - levels));
        I_hat(i) = levels(idx_I);
        Q_hat(i) = levels(idx_Q);
    end
    
    % Símbolos reconstruídos
    symbols_hat = I_hat + 1i*Q_hat;
end