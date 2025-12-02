function [symbols] = demodulate(wave, t, N_levels, filtered, Fc)
arguments(Input)
    wave 
    t
    N_levels {mustBeMember(N_levels, [1, 4, 8, 16])}
    filtered
    Fc = 100e3
end

    wave_I = wave .* cos(2*pi*Fc*t)*2;
    if N_levels > 1
        wave_Q = wave .* -sin(2*pi*Fc*t)*2;
    else
        wave_Q = zeros(1, length(wave_I));
    end

    switch N_levels
            case 1,  k = 1; % BPSK
            case 4,  k = 4; % 16-QAM
            case 8,  k = 6; % 64-QAM (log2(64)=6)
            case 16, k = 8; % 256-QAM (log2(256)=8)
            otherwise, error('Nível de modulação não suportado.');
    end

    spb = 200; % Samples per symbol
    step_size = spb*k;

    if filtered
        h_rrc = rcosdesign(0.25, 10, spb*k, 'sqrt');
        h_rrc = h_rrc / sum(h_rrc);
        I_base = conv(wave_I, h_rrc);
        Q_base = conv(wave_Q, h_rrc);

        % 10 é o SPAN do filtro. Não é um valor mágico
        delay = (10*k*spb)/2;
        
        idx_amostragem = delay : step_size : length(I_base);
        idx_amostragem = idx_amostragem(idx_amostragem <= length(I_base));
        plot(I_base);
        
        return;
        I_final = I_base(idx_amostragem);
        Q_final = Q_base(idx_amostragem);
    else
        fs = 2e6; 
        f_cut = 20e3; 
  
        [b, a] = butter(5, f_cut/(fs/2));
        I_lpf = filtfilt(b, a, wave_I);
        Q_lpf = filtfilt(b, a, wave_Q);
        
        start_idx = 1;
        idx_amostragem = step_size : step_size : length(I_lpf);

        num_symbols = length(idx_amostragem);
        I_final = zeros(1, num_symbols);
        Q_final = zeros(1, num_symbols);

        for i=1:length(idx_amostragem)
            I_final(1,i) = trapz(I_lpf(start_idx:idx_amostragem(i)))/step_size;
            Q_final(1,i) = trapz(Q_lpf(start_idx:idx_amostragem(i)))/step_size;
            start_idx = idx_amostragem(i)+1;
        end
    end

    %P_rms = sqrt(mean(I_final.^2 + Q_final.^2));
    max_val = max(max(abs(I_final)), max(abs(Q_final)));

    scale_factor = max_val; 
    if scale_factor > 0
        I_final = I_final / scale_factor;
        Q_final = Q_final / scale_factor;
    end

    % Está pronta a constelação...
    symbols = I_final + 1i * Q_final;
end