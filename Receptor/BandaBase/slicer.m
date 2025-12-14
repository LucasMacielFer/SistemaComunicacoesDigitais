function symbols_hat = slicer(symbols_rx, N_levels)
% Uso geral: Decidir qual o símbolo da constelação base é mais próximo de 
% cada símbolo recebido. QAM-only
arguments(Input)
    symbols_rx 
    N_levels {mustBeMember(N_levels, [2, 4, 8, 16])}
end       
    % Calcula a Energia Média da constelação inteira
    M = N_levels^2;
    Es = (2/3) * (M - 1); 
    
    % Fator de normalização (O mesmo do TX)
    integers = -(double(N_levels-1)) : 2 : (double(N_levels-1));
    norm_factor = sqrt(1 / double(Es));
    levels = integers*norm_factor;

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