function rx_wave = canal(tx_wave, t, perfil, EbN0_dB, N_levels, conv, ofdm_params)
% Função que aplica as imperfeições do canal: Multipath e AWGN
arguments (Input)
    tx_wave
    t
    perfil {mustBeMember(perfil, [0, 1, 2, 3, 4])}  % Perfil multipercurso
    EbN0_dB                                         % Eb/N0 (dB) AWGN
    N_levels
    conv 
    ofdm_params = []
end

    % Perfis multipercurso - Canais GENÉRICOS, INSPIRADOS QUALITATIVAMENTE
    % nas normativas IEEE 802.11ay-2021 e 3GPP TDL

    % É "INSPIRADO" pois utilizo menos taps para poupar esforço
    % computacional. Isto altera o RMS delay spread, autocorrelação e
    % seletividade em frequência originais dos modelos.

    % PARTE 1 - Modelo multipercurso
    switch(perfil)
        % --- 0. Sem Multipercurso (AWGN/LoS Puro) ---
        case 0
            gains = [];
            delays = [];
        
        % --- 1. Inspirado em IEEE 802.11ay Model A (Indoor) ---
        % Baixa dispersão de tempo, distâncias curtas.
        case 1
            gains = [0, -6, -8, -10, -12];
            delays = [0, 5e-9, 10e-9, 20e-9, 30e-9]; 
        
        % --- 2. Inspirado em IEEE 802.11ay Model B (Indoor - Open Space Caótico) ---
        % Dispersão de tempo moderada devido a múltiplas superfícies de reflexão.
        case 2
            gains = [0, -2, -5, -8, -12, -18];
            delays = [0, 15e-9, 40e-9, 80e-9, 150e-9, 250e-9]; 
            
        % --- 3. Inspirado em 3GPP TDL-A (Typical Urban - Baixa Dispersão de Tempo) ---
        case 3
            gains = [0, -1.0, -2.0, -3.0, -8.0];
            delays = [0, 50e-9, 120e-9, 200e-9, 300e-9]; 

        % --- 4. Inspirado em 3GPP TDL-D (Urban Dense - High Delay Spread) ---
        case 4
            % Baseado no modelo TDL-D do 3GPP.
            gains = [0, -1.5, -4.5, -7.5, -12, -15, -20]; 
            delays = [0, 100e-9, 300e-9, 800e-9, 1.5e-6, 3e-6, 5e-6];
    end

    rx_wave = multipath_model(tx_wave, t, gains, delays);

    % Parte 2 - AWGN
    % Adiciona fator de codificação para o cálculo do SNR
    if conv, Rc = 2; else Rc = 1; end

    % Single carrier: SNR = EbN0_dB - OSR_dB
    % OSR é um fator adicionado em virtude da oversampling
    % (sobreamostragem - temos 200 samples por bit).
    if isempty(ofdm_params)
        spb = 200;
        OSR = spb;
        OSR_dB = 10 * log10(OSR) - 10 * log10(Rc);
        SNR_awgn_dB = EbN0_dB-OSR_dB;

    % OFDM - Calcula o SNR com base nas bandas utilizadas para dados
    else
        k = 2*log2(N_levels);
        if N_levels == 1
            k = 1;
        end

        N_data = numel(ofdm_params.idx_data);
        eta_sub    = N_data / ofdm_params.N_fft;
        eta_pilots = N_data / (N_data + length(ofdm_params.idx_pilots));
        eta_CP     = ofdm_params.N_fft / (ofdm_params.N_fft + ofdm_params.CP);
        
        SNR_awgn_dB = EbN0_dB ...
                    + 10*log10(k) ...
                    + 10*log10(eta_sub) ...
                    + 10*log10(eta_pilots) ...
                    + 10*log10(eta_CP)...
                    + 10*log10(Rc);
    end

    % Aplica AWGN
    rx_wave = awgn(rx_wave, SNR_awgn_dB, 'measured');
end