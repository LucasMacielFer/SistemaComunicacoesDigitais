function [symbols] = demodulate(wave, t, N_levels, filtered, Fc)
arguments(Input)
    wave 
    t
    N_levels {mustBeMember(N_levels, [2, 4, 8, 16])}
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
            case 2, k = 2;
            case 4,  k = 4; % 16-QAM
            case 8,  k = 6; % 64-QAM (log2(64)=6)
            case 16, k = 8; % 256-QAM (log2(256)=8)
            otherwise, error('Nível de modulação não suportado.');
    end

    SPB = 200; % Samples per symbol
    SPS = SPB*k;
    SPAN = 10;
    ALPHA = 0.25;

    if filtered
        h_rrc = rcosdesign(ALPHA, SPAN, SPS, 'sqrt');
        h_rrc = h_rrc / sqrt(sum(h_rrc.^2));
        I_base = upfirdn(wave_I, h_rrc, 1, 1);
        Q_base = upfirdn(wave_Q, h_rrc, 1, 1);

        delay_samples = (SPS*SPAN)/2;
        num_symbols = floor((length(I_base) - delay_samples) / SPS);
        idx0 = delay_samples;
        idx = idx0 : SPS : idx0 + (num_symbols-1)*SPS;

        I_final = I_base(idx);
        Q_final = Q_base(idx);
    else
        fs = 2e6; 
        f_cut = 20e3; 
  
        [b, a] = butter(5, f_cut/(fs/2));
        I_lpf = filtfilt(b, a, wave_I);
        Q_lpf = filtfilt(b, a, wave_Q);
        
        start_idx = 1;
        idx_amostragem = SPS : SPS : length(I_lpf);

        num_symbols = length(idx_amostragem);
        I_final = zeros(1, num_symbols);
        Q_final = zeros(1, num_symbols);

        for i=1:length(idx_amostragem)
            I_final(1,i) = trapz(I_lpf(start_idx:idx_amostragem(i)))/SPS;
            Q_final(1,i) = trapz(Q_lpf(start_idx:idx_amostragem(i)))/SPS;
            start_idx = idx_amostragem(i)+1;
        end
    end

    % Está pronta a constelação...
    symbols = I_final + 1i * Q_final;
end