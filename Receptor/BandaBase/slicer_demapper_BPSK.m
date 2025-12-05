function symbols_hat = slicer_demapper_BPSK(symbols_rx)
% Slicer para BPSK. Considera apenas a parte real.
    symbols_hat = zeros(1,length(symbols_rx));
    for i=1:length(symbols_rx)
        if real(symbols_rx(i)) >= 0
            symbols_hat(i) = 1; % Assign 1 for positive real parts
        else
            symbols_hat(i) = 0; % Assign -1 for negative real parts
        end
    end
end