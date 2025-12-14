function symbols_hat = slicer_demapper_BPSK(symbols_rx)
% Uso geral: Slicer e demapper para BPSK. Basicamente transforma símbolos
% positivos em 1's e negativos em 0's. Sem muita complicação por aqui.

    symbols_hat = zeros(1,length(symbols_rx));
    for i=1:length(symbols_rx)
        if real(symbols_rx(i)) >= 0
            symbols_hat(i) = 1;
        else
            symbols_hat(i) = 0;
        end
    end
end