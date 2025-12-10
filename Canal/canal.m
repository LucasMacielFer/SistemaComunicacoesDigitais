function rx_wave = canal(tx_wave, t, perfil, snr, N_levels)
% Função que aplica as imperfeições do canal: Multipath e AWGN
arguments (Input)
    tx_wave
    t
    perfil {mustBeMember(perfil, [0, 1, 2, 3, 4])}  % Perfil multipercurso
    snr                                             % SNR AWGN
    N_levels
end

% --- 1. LABORATÓRIO "COM DEFEITO" (Otimista, mas realista) ---
% Reflexão numa bancada metálica e num equipamento próximo.
% --- 2. SALA FECHADA "OPEN SPACE CAÓTICO" (Indoor denso) ---
% Cenário: Escritório cheio de cubículos, pessoas e paredes de vidro.
% --- 3. AUTOESTRADA "MAD MAX" (Alta velocidade / Reflexos distantes) ---
% Cenário: Reflexo no asfalto (chão) muito forte e reflexo em montanha distante.
% --- 4. URBANO "CANYON DE MANHATTAN" (O Chefão Final) ---
% Cenário: Prédios altos por todo lado. Não há linha de visada clara (NLOS).

% PARTE 1 - Modelo multipercurso
    switch(perfil)
        case 0
            gains = [];
            delays = [];
        case 1
            gains = [0, -20, -25];
            delays = [0, 15e-9, 30e-9];
        case 2
            gains = [0, -4, -8, -12, -20];
            delays = [0, 50e-9, 110e-9, 200e-9, 450e-9];
        case 3
            gains = [0, -1.5, -9, -15];
            delays = [0, 200e-9, 1e-6, 2.5e-6]; 
        case 4
            gains = [0, -3, -5, -10, -18]; 
            delays = [0, 300e-9, 800e-9, 1.5e-6, 3.5e-6];
    end

    rx_wave = multipath_model(tx_wave, t, gains, delays);

% Parte 2 - AWGN
    k = 2*log2(N_levels);
    if N_levels == 1
        k = 1;
    end

    spb = 200;
    P_rx_ref = mean(abs(rx_wave).^2);

    OSR = spb*k;
    OSR_dB = 10 * log10(OSR);

    rx_wave = awgn(rx_wave, snr-OSR_dB, P_rx_ref, OSR);
end