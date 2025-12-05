function rx_wave = multipath_model(tx_wave, t, gains_dB, delays_s)

    if length(gains_dB) ~= length(delays_s)
        error('Os vetores de ganhos e atrasos devem ter o mesmo tamanho.');
    end

    if isempty(gains_dB)
        rx_wave = tx_wave;
        return; % Exit the function if gains_dB is empty
    end

    tx_wave = tx_wave(:);
    dt = t(2) - t(1);
    Fs = 1 / dt;

    gains_lin = 10.^(gains_dB / 20);

    rx_wave = zeros(size(tx_wave));

    for i = 1:length(gains_dB)
        gain = gains_lin(i);
        delay = delays_s(i);
        
        % Converter atraso de segundos para número de amostras
        delay_samples = round(delay * Fs);
        
        % Criar a cópia atrasada do sinal
        if delay_samples == 0
            % Caminho sem atraso (Sinal original escalado)
            path_signal = tx_wave;
        elseif delay_samples < length(tx_wave)
            % Caminho atrasado:
            % 1. Adiciona zeros no início (o atraso)
            % 2. Trunca o final para manter o mesmo tamanho do vetor original
            %    (Simula que o eco "caiu fora" da janela de observação)
            
            signal_delayed = [zeros(delay_samples, 1); tx_wave(1:end-delay_samples)];
            path_signal = signal_delayed;
        else
            % Se o atraso for maior que o sinal todo, esse eco nem aparece
            path_signal = zeros(size(tx_wave));
        end
        
        % Soma ao sinal total (Superposição)
        rx_wave = rx_wave + (gain * path_signal);
    end
    rx_wave = rx_wave.';
end