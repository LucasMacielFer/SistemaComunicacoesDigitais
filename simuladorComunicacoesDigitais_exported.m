classdef simuladorComunicacoesDigitais_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        ConfiguraesdasimulaoTab         matlab.ui.container.Tab
        GridLayout                      matlab.ui.container.GridLayout
        FD_error                        matlab.ui.container.Panel
        GridLayout12                    matlab.ui.container.GridLayout
        ERROLabel                       matlab.ui.control.Label
        SimuladordecomunicaesdigitaisLabel  matlab.ui.control.Label
        SimularButton                   matlab.ui.control.Button
        ImperfeiesnocanalPanel          matlab.ui.container.Panel
        GridLayout3                     matlab.ui.container.GridLayout
        RudodeFaseEditField             matlab.ui.control.NumericEditField
        RudodeFaseEditFieldLabel        matlab.ui.control.Label
        DesvioDopplerEditField          matlab.ui.control.NumericEditField
        DesvioDopplerEditFieldLabel     matlab.ui.control.Label
        CanalMultipercursoDropDown      matlab.ui.control.DropDown
        CanalmultipercursoLabel         matlab.ui.control.Label
        SNRSlider                       matlab.ui.control.Slider
        SNRSliderLabel                  matlab.ui.control.Label
        ModulaoPanel                    matlab.ui.container.Panel
        GridLayout2                     matlab.ui.container.GridLayout
        PilotsEditField                 matlab.ui.control.NumericEditField
        PilotsEditFieldLabel            matlab.ui.control.Label
        NmerodesubportadorasButtonGroup  matlab.ui.container.ButtonGroup
        Button_3                        matlab.ui.control.RadioButton
        Button_2                        matlab.ui.control.RadioButton
        Button                          matlab.ui.control.RadioButton
        OFDMSwitch                      matlab.ui.control.Switch
        OFDMSwitchLabel                 matlab.ui.control.Label
        CodificaoconvolucionalSwitch    matlab.ui.control.Switch
        CodificaoconvolucionalSwitchLabel  matlab.ui.control.Label
        ModulaoDropDown                 matlab.ui.control.DropDown
        ModulaoDropDownLabel            matlab.ui.control.Label
        FontededadosPanel               matlab.ui.container.Panel
        FD_grid                         matlab.ui.container.GridLayout
        FD_texto                        matlab.ui.container.Panel
        TextArea_3                      matlab.ui.control.TextArea
        InsiraseutextoASCIIExtendida8bitsLabel  matlab.ui.control.Label
        FD_audio                        matlab.ui.container.Panel
        AgravarLabel                    matlab.ui.control.Label
        CarregarudiodeumficheiroButton  matlab.ui.control.Button
        OuvirButton                     matlab.ui.control.Button
        GravarButton                    matlab.ui.control.Button
        OULabel                         matlab.ui.control.Label
        TempodegravaosegundosSpinner    matlab.ui.control.Spinner
        TempodegravaosegundosSpinnerLabel  matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
        FD_imagem                       matlab.ui.container.Panel
        Image                           matlab.ui.control.Image
        CarregarimagemapartirdeumficheiroButton  matlab.ui.control.Button
        FD_bitsAleatorios               matlab.ui.container.Panel
        NmerodelinhasSpinner            matlab.ui.control.Spinner
        NmerodelinhasSpinnerLabel       matlab.ui.control.Label
        NmerodebitsporlinhaSpinner      matlab.ui.control.Spinner
        NmerodebitsporlinhaSpinnerLabel  matlab.ui.control.Label
        FontededadosDropDown            matlab.ui.control.DropDown
        FontededadosDropDownLabel       matlab.ui.control.Label
        BandabaseTXTab                  matlab.ui.container.Tab
        GridLayout4                     matlab.ui.container.GridLayout
        UIAxes2_3                       matlab.ui.control.UIAxes
        UIAxes2                         matlab.ui.control.UIAxes
        CanalTab                        matlab.ui.container.Tab
        GridLayout5                     matlab.ui.container.GridLayout
        UIAxes5                         matlab.ui.control.UIAxes
        UIAxes6_2                       matlab.ui.control.UIAxes
        UIAxes6                         matlab.ui.control.UIAxes
        UIAxes5_2                       matlab.ui.control.UIAxes
        ConstelaesRXTab                 matlab.ui.container.Tab
        GridLayout6                     matlab.ui.container.GridLayout
        UIAxes7_2                       matlab.ui.control.UIAxes
        UIAxes7                         matlab.ui.control.UIAxes
        ResultadosTab                   matlab.ui.container.Tab
        GridLayout7                     matlab.ui.container.GridLayout
        RecuperaodedadosImagemPanel     matlab.ui.container.Panel
        GridLayout11                    matlab.ui.container.GridLayout
        error_img_rx                    matlab.ui.container.Panel
        GridLayout12_2                  matlab.ui.container.GridLayout
        ERROLabel_2                     matlab.ui.control.Label
        ImagemRecebidaLabel             matlab.ui.control.Label
        ImagemEnviadaLabel              matlab.ui.control.Label
        image_rx_results                matlab.ui.control.Image
        image_tx_results                matlab.ui.control.Image
        RecuperaodedadosudioPanel       matlab.ui.container.Panel
        GridLayout10                    matlab.ui.container.GridLayout
        error_audio_rx                  matlab.ui.container.Panel
        GridLayout12_3                  matlab.ui.container.GridLayout
        ERROLabel_3                     matlab.ui.control.Label
        udioRecebidoLabel               matlab.ui.control.Label
        udioEnviadoLabel                matlab.ui.control.Label
        OuvirButton_3                   matlab.ui.control.Button
        OuvirButton_2                   matlab.ui.control.Button
        UIAxes9                         matlab.ui.control.UIAxes
        UIAxes9_2                       matlab.ui.control.UIAxes
        RecuperaodedadosTextoPanel      matlab.ui.container.Panel
        GridLayout9                     matlab.ui.container.GridLayout
        TextoRecebidoLabel              matlab.ui.control.Label
        TextoEnviadoLabel               matlab.ui.control.Label
        TextArea_2                      matlab.ui.control.TextArea
        TextArea                        matlab.ui.control.TextArea
        Panel                           matlab.ui.container.Panel
        GridLayout8                     matlab.ui.container.GridLayout
        EVM_rx_label                    matlab.ui.control.Label
        BER_rx_label                    matlab.ui.control.Label
        BER_eq_label                    matlab.ui.control.Label
        CorrigidoLabel_2                matlab.ui.control.Label
        CorrigidoLabel                  matlab.ui.control.Label
        RecebidoLabel_2                 matlab.ui.control.Label
        RecebidoLabel                   matlab.ui.control.Label
        EVM_eq_label                    matlab.ui.control.Label
        EVMLabel                        matlab.ui.control.Label
        BERLabel                        matlab.ui.control.Label
        UIAxes8                         matlab.ui.control.UIAxes
    end
    
    % Properties do simulador
    properties (Access = private)
        tipoDeDados     % Tipo de dados
        modulacao       % Tipo de modulacao
        N_levels        % Níveis do sinal NRZ
        convActive      % Codificacao convolucional ativa
        convG1='11011'  % Polinomio G1 codificador convolucional
        convG2='10101'  % Polinomio G2 codificador convolucional
        ofdmActive      % OFDM ativo
        subcarriers=64  % Numero de subportadoras
        pilots=0        % Numero de pilotos
        snr             % SNR
        multipath       % Perfil do canal multipercurso
        doppler         % Desvio doppler
        phase           % Ruido de fase
        fc=100e3        % Frequencia da portadora
        fs=2e6          % Frequencia da simulacao
        spb=200         % Samples per bit
    end

    % Área de dados
    properties (Access = private)
        uri_tx               % Guarda o caminho da imagem ou audio TX
        uri_rx               % guarda o caminho da imagem ou audio RX
        generate = false     % True/False - Todos os parametros estao corretos?
        audioDuration        % Duracao do audio
        audioSampleRate      % Fs do audio
        bindata_tx           
        bindata_rx
        bindata_eq
        metadata = []
        symbols_tx
        symbols_rx
        symbols_eq
        constellation_guides
        constellation_rx
        constellation_eq
    end

    % Metricas
    properties (Access = private)
        ber
        evm
        ber_eq
        evm_eq
    end

    methods (Access = private)
        % Inicializa todos os parâmetros da simulação
        function [] = initializeParameters(app)
            app.tipoDeDados = app.FontededadosDropDown.Value;
            app.modulacao = app.ModulaoDropDown.Value;
            switch app.modulacao
                case "BPSK"
                    app.N_levels = 1;
                case "QPSK"
                    app.N_levels = 2;
                case "16-QAM"
                    app.N_levels = 4;
                case "64-QAM"
                    app.N_levels = 8;
                case "256-QAM"
                    app.N_levels = 16;
            end

            if app.CodificaoconvolucionalSwitch.Value == "On"
                app.convActive = true;
            else
                app.convActive = false;
            end

            if app.OFDMSwitch.Value == "On"
                app.ofdmActive = true;
                app.fc = 400e3;
                app.fs = 2e6;
            else
                app.ofdmActive = false;
                app.fc = 100e3;
                app.fs = 2e6;
            end

            app.snr = app.SNRSlider.Value;
            app.multipath = app.CanalMultipercursoDropDown.ValueIndex - 1;
            app.doppler = app.DesvioDopplerEditField.Value;
            app.phase = app.RudodeFaseEditField.Value;
            app.pilots = app.PilotsEditField.Value;
        end

        % Gera os dados binários
        function [] = generateBinData(app)
            switch app.tipoDeDados
                case 'Bits aleatórios'
                    nLinhas = app.NmerodelinhasSpinner.Value;
                    nBits = app.NmerodebitsporlinhaSpinner.Value;
                    app.bindata_tx = random_bitseq_generator(nLinhas, nBits);
                    app.metadata = [nLinhas, nBits];
                    if(~isempty(app.bindata_tx))
                        app.generate = true;
                    else
                        app.generate = false;
                        disp("Erro ao gerar bits aleatorios...");
                    end

                case 'Áudio'
                    try
                        app.bindata_tx = audio_encoder(app.uri_tx, app.audioDuration, app.audioSampleRate);
                        sz = size(app.bindata_tx);
                        app.metadata = [sz(1), sz(2)];
                        app.generate = true;
                        if(~isempty(app.bindata_tx))
                            app.generate = true;
                        else
                            app.generate = false;
                        end
                    catch
                        app.generate = false;
                        disp("Erro ao converter audio...");
                    end

                case 'Imagem'
                    try
                        app.bindata_tx = image_encoder(app.uri_tx);
                        sz = size(app.bindata_tx);
                        app.metadata = [sz(1), sz(2)];
                        app.generate = true;
                        if(~isempty(app.bindata_tx))
                            app.generate = true;
                        else
                            app.generate = false;
                        end
                    catch
                        app.generate = false;
                        disp("Erro ao converter imagem...");
                    end

                case 'Texto'
                    try
                        app.bindata_tx = ASCII_encoder(app.TextArea_3.Value);
                        sz = size(app.bindata_tx);
                        app.metadata = [sz(1), sz(2)];
                        app.TextArea.Value = app.TextArea_3.Value;
                        if(~isempty(app.bindata_tx))
                            app.generate = true;
                        else
                            app.generate = false;
                        end
                    catch
                       app.generate = false;
                       disp("Erro ao converter texto...");
                    end
            end
        end

        % Cria o gráfico do sinal de áudio
        function [] = plotAudioSignal(app)
            [rawAudio, ~] = audioread(app.uri_tx);
            plot(app.UIAxes, rawAudio);
            plot(app.UIAxes9, rawAudio);
        end

        function [] = plotSampleData(app)
            % Primeira linha de bits apenas
            sampleBinData = app.bindata_tx(1,:);
            if app.convActive
                sampleBinData = conv_encoder(sampleBinData, app.convG1, app.convG2);
            end

            if app.metadata(1,2) > 200
                sampleBinData = sampleBinData(1:200);
            end
            
            if ~app.ofdmActive
                if app.N_levels == 1
                    [t, ~, iWave] = NRZ_polar_BPSK(sampleBinData);

                    plot(app.UIAxes2, t, iWave);
                    cla(app.UIAxes2_3);

                    modWavePerfect = modulate_cos(iWave, t);
                    modWave = modulate_single_carrier(iWave, [], t, app.phase, app.doppler, app.fc);
                    modWave = canal(modWave, t, app.multipath, app.snr, app.N_levels, app.convActive);

                    f = linspace(-app.fs/2, app.fs/2, length(t));
                    plot(app.UIAxes5, t, modWavePerfect);
                    plot(app.UIAxes6, f, abs(fftshift(fft(modWavePerfect))));
                    plot(app.UIAxes5_2, t, modWave);
                    plot(app.UIAxes6_2, f, abs(fftshift(fft(modWave))));
                else
                    [t, ~, ~, iWave, qWave] = NRZ_polar_QAM(sampleBinData, app.N_levels);
                    plot(app.UIAxes2, t, iWave);
                    plot(app.UIAxes2_3, t, qWave);

                    modWavePerfect = modulate_cos(iWave, t) + modulate_sin(qWave, t);
                    modWave = modulate_single_carrier(iWave, qWave, t, app.phase, app.doppler, app.fc);
                    modWave = canal(modWave, t, app.multipath, app.snr, app.N_levels, app.convActive);

                    f = linspace(-app.fs/2, app.fs/2, length(t));
                    plot(app.UIAxes5, t, modWavePerfect);
                    plot(app.UIAxes6, f, abs(fftshift(fft(modWavePerfect))));
                    plot(app.UIAxes5_2, t, modWave);
                    plot(app.UIAxes6_2, f, abs(fftshift(fft(modWave))));
                end
            else
                if app.N_levels == 1
                    [~, iSyms, ~] = NRZ_polar_BPSK(sampleBinData);
                    sym_qam = iSyms;
                    [ofdm_baseband, t, params] = OFDM_baseband(sym_qam, app.subcarriers, app.pilots);

                    plot(app.UIAxes2, t, real(ofdm_baseband));
                    plot(app.UIAxes2_3, t, imag(ofdm_baseband));

                    modWavePerfect = modulate_cos(real(ofdm_baseband), t, app.fc) + modulate_sin(imag(ofdm_baseband), t, app.fc);
                    modWave = canal(modWavePerfect, t, app.multipath, app.snr, app.N_levels, app.convActive, params);

                    f = linspace(-app.fs/2, app.fs/2, length(t));
                    plot(app.UIAxes5, t, modWavePerfect);
                    plot(app.UIAxes6, f, abs(fftshift(fft(modWavePerfect))));
                    plot(app.UIAxes5_2, t, modWave);
                    plot(app.UIAxes6_2, f, abs(fftshift(fft(modWave))));
                else
                    [~, iSyms, qSyms, ~, ~] = NRZ_polar_QAM(sampleBinData, app.N_levels);
                    sym_qam = iSyms + 1i*qSyms;
                    [ofdm_baseband, t, params] = OFDM_baseband(sym_qam, app.subcarriers, app.pilots);

                    plot(app.UIAxes2, t, real(ofdm_baseband));
                    plot(app.UIAxes2_3, t, imag(ofdm_baseband));

                    modWavePerfect = modulate_cos(real(ofdm_baseband), t, app.fc) + modulate_sin(imag(ofdm_baseband), t, app.fc);
                    modWave = canal(modWavePerfect, t, app.multipath, app.snr, app.N_levels, app.convActive, params);

                    f = linspace(-app.fs/2, app.fs/2, length(t));
                    plot(app.UIAxes5, t, modWavePerfect);
                    plot(app.UIAxes6, f, abs(fftshift(fft(modWavePerfect))));
                    plot(app.UIAxes5_2, t, modWave);
                    plot(app.UIAxes6_2, f, abs(fftshift(fft(modWave))));
                end
            end
        end

        % Simulacao BPSK - Single carrier
        function [] = simulateBPSKSingleCarrier(app)
            app.bindata_rx = zeros(app.metadata(1,1), app.metadata(1,2));
            app.bindata_eq = zeros(app.metadata(1,1), app.metadata(1,2));
            
            if app.convActive
                K_mem = length(app.convG1);
                num_bits = 2 * (app.metadata(1,2) + K_mem - 1);

                binData = zeros(1, 64+8+num_bits);
                binData(1,73:end) = conv_encoder(app.bindata_tx(1, :));

            else
                num_bits = app.metadata(1,2);
                binData = zeros(1, 64+8+num_bits);
                binData(1,73:end) = app.bindata_tx(1, :);
            end

            symbols_tmp = zeros(1, (num_bits+64+8));
            symbols_tmp_eq = zeros(1, (num_bits+64+8));
            bits_tmp = zeros(1, (num_bits+64+8));
            bits_tmp_eq = zeros(1, (num_bits+64+8));
            waveformI = zeros(1, (num_bits+64+8)*app.spb);
            waveform = zeros(1, (num_bits+64+8)*app.spb);
            coeffsI = zeros(1, 64+8+num_bits);

            app.symbols_tx = zeros(app.metadata(1,1), num_bits);
            app.symbols_rx = zeros(app.metadata(1,1), num_bits);
            app.symbols_eq = zeros(app.metadata(1,1), num_bits);

            [binHeader, ~] = header(app.N_levels);
            binData(1,1:72) = binHeader;
            
            [time, ~, ~] = NRZ_polar_BPSK(binData);

            for i=1:app.metadata(1,1)
                % TX
                if app.convActive
                    binData(1,73:end) = conv_encoder(app.bindata_tx(i, :), app.convG1, app.convG2);
                else
                    binData(1,73:end) = app.bindata_tx(i, :);
                end

                [~, coeffsI, waveformI] = NRZ_polar_BPSK(binData);
                waveform = modulate_single_carrier(waveformI, [], time, app.phase, app.doppler, app.fc);

                % Canal
                waveform = canal(waveform, time, app.multipath, app.snr, app.N_levels, app.convActive);
    
                % RX
                symbols_tmp = demodulate_single_carrier(waveform, time, app.N_levels);
                symbols_tmp_eq = BPSK_equalizer(symbols_tmp, 72);
                symbols_tmp = symbols_tmp(73:end);
                symbols_tmp_eq = symbols_tmp_eq(73:end);
                bits_tmp = slicer_demapper_BPSK(symbols_tmp);
                bits_tmp = bits_tmp(1:num_bits);
                bits_tmp_eq = slicer_demapper_BPSK(symbols_tmp_eq);
                bits_tmp_eq = bits_tmp_eq(1:num_bits);

                % Inserir na matriz de dados novamente
                app.symbols_tx(i,:) = coeffsI(73:end);
                app.symbols_rx(i,:) = symbols_tmp;
                app.symbols_eq(i,:) = symbols_tmp_eq;

                if app.convActive
                    app.bindata_rx(i,:) = viterbi(bits_tmp, app.convG1, app.convG2, app.metadata(1,2));
                    app.bindata_eq(i,:) = viterbi(bits_tmp_eq, app.convG1, app.convG2, app.metadata(1,2));
                else
                    app.bindata_rx(i,:) = bits_tmp;
                    app.bindata_eq(i,:) = bits_tmp_eq;
                end
            end
        end

        % Simulacao QAM - Single carrier
        function [] = simulateQAMSingleCarrier(app)
            k = 2*log2(app.N_levels); 
            
            [sync_bits_data, ~] = sync_bits(app.N_levels);
            mini_header_size_bits = length(sync_bits_data);
            
            BITS_POR_BLOCO = 192;

            headerSize = 72*k; 
            
            dados_por_linha_orig = app.metadata(1,2); 
            
            if app.convActive
                K_mem = length(app.convG1);
                num_bits_dados_tx = 2 * (dados_por_linha_orig + K_mem - 1);
            else
                num_bits_dados_tx = dados_por_linha_orig;
            end
            
            num_blocos = ceil(num_bits_dados_tx / BITS_POR_BLOCO);
            overhead_sync_bits = num_blocos * mini_header_size_bits;
            num_bits_total_com_sync = num_bits_dados_tx + overhead_sync_bits;
            num_symbols_final = ceil(num_bits_total_com_sync / k);

            app.bindata_rx = zeros(app.metadata(1,1), dados_por_linha_orig); 
            app.bindata_eq = zeros(app.metadata(1,1), dados_por_linha_orig);
            
            app.symbols_tx = zeros(app.metadata(1,1), num_symbols_final);
            app.symbols_rx = zeros(app.metadata(1,1), num_symbols_final);
            app.symbols_eq = zeros(app.metadata(1,1), num_symbols_final);

            waveformI = zeros(1, num_symbols_final * app.spb);
            waveformQ = zeros(1, num_symbols_final * app.spb);
            waveform = zeros(1, num_symbols_final * app.spb);
            coeffsI = zeros(1, num_symbols_final);
            coeffsQ = zeros(1, num_symbols_final);

            binData_com_sync_tmp = zeros(1, headerSize + num_bits_total_com_sync);

            for i=1:app.metadata(1,1)
                
                % TX
                if app.convActive
                    bits_tx_codificados = conv_encoder(app.bindata_tx(i, :), app.convG1, app.convG2);
                else
                    bits_tx_codificados = app.bindata_tx(i, :);
                end
                                
                [binHeader, ~] = header(app.N_levels);
                binData_com_sync_tmp(1, 1:headerSize) = binHeader;

                idx_leitura_dados = 1; 
                idx_escrita_final = headerSize + 1;
                
                for b = 1:num_blocos
                    binData_com_sync_tmp(1, idx_escrita_final : idx_escrita_final + mini_header_size_bits - 1) = sync_bits_data;
                    idx_escrita_final = idx_escrita_final + mini_header_size_bits;
                    
                    tamanho_dados = min(BITS_POR_BLOCO, num_bits_dados_tx - (idx_leitura_dados - 1));

                    if tamanho_dados > 0
                        bloco_dados = bits_tx_codificados(idx_leitura_dados : idx_leitura_dados + tamanho_dados - 1);
                        binData_com_sync_tmp(1, idx_escrita_final : idx_escrita_final + tamanho_dados - 1) = bloco_dados;
                        
                        idx_leitura_dados = idx_leitura_dados + tamanho_dados;
                        idx_escrita_final = idx_escrita_final + tamanho_dados;
                    end
                end
                
                [time, coeffsI, coeffsQ, waveformI, waveformQ] = NRZ_polar_QAM(binData_com_sync_tmp, app.N_levels);
                waveform = modulate_single_carrier(waveformI, waveformQ, time, app.phase, app.doppler, app.fc);
                
                % Canal
                waveform = canal(waveform, time, app.multipath, app.snr, app.N_levels, app.convActive);
                
                % RX - Demodulação e Normalização
                symbols_raw = demodulate_single_carrier(waveform, time, app.N_levels);
                symbols_raw = normalize(symbols_raw);
                
                if app.N_levels == 2
                    fwd_taps = 11;
                    ref_tap = 9;
                    forgetting_f = 0.99;
                    loop_bw = 0.05;
                    damping = 0.7;
                    symbols_eq_output = QPSK_equalizer(symbols_raw, app.N_levels, fwd_taps, ref_tap, forgetting_f, loop_bw, damping);
                else
                    symbols_eq_output = QAM_equalizer(symbols_raw, app.N_levels);
                end
                symbols_eq_output = normalize(symbols_eq_output);
                
                
                idx_simbolo_inicio_dados = ceil(headerSize / k) + 1;
                
                app.symbols_tx(i,:) = coeffsI(idx_simbolo_inicio_dados:end) + 1i*coeffsQ(idx_simbolo_inicio_dados:end);  
                app.symbols_rx(i,:) = symbols_raw(idx_simbolo_inicio_dados:end);
                app.symbols_eq(i,:) = symbols_eq_output(idx_simbolo_inicio_dados:end);
                
                bits_rx_com_sync = demapper(slicer(app.symbols_rx(i,:), app.N_levels), app.N_levels);
                bits_rx_limpos = clean_sync_bits(bits_rx_com_sync, BITS_POR_BLOCO, mini_header_size_bits, num_bits_dados_tx);
                
                bits_eq_com_sync = demapper(slicer(app.symbols_eq(i,:), app.N_levels), app.N_levels);
                bits_eq_limpos = clean_sync_bits(bits_eq_com_sync, BITS_POR_BLOCO, mini_header_size_bits, num_bits_dados_tx);
                
                if app.convActive
                    app.bindata_rx(i,:) = viterbi(bits_rx_limpos, app.convG1, app.convG2, app.metadata(1,2));
                    app.bindata_eq(i,:) = viterbi(bits_eq_limpos, app.convG1, app.convG2, app.metadata(1,2));
                else
                    app.bindata_rx(i,:) = bits_rx_limpos;
                    app.bindata_eq(i,:) = bits_eq_limpos;
                end
            end
        end

        function [] = simulateOFDM(app)
            k = 2*log2(app.N_levels);
            if app.N_levels == 1, k = 1; end

            app.bindata_rx = zeros(app.metadata(1,1), app.metadata(1,2));
            app.bindata_eq = zeros(app.metadata(1,1), app.metadata(1,2));

            if app.convActive
                K_mem = length(app.convG1);
                num_bits = 2 * (app.metadata(1,2) + K_mem - 1);
            else
                num_bits = app.metadata(1,2);
            end

            % pré-alocação dos vetores
            app.symbols_tx = zeros(app.metadata(1,1), ceil(num_bits/k));
            app.symbols_rx = zeros(app.metadata(1,1), ceil(num_bits/k));
            app.symbols_eq = zeros(app.metadata(1,1), ceil(num_bits/k));
    
            if app.N_levels == 1
                coeffsI = zeros(num_bits);
                symbols = zeros(num_bits);
            else
                coeffsI = zeros(ceil(num_bits/k));
                coeffsQ = zeros(ceil(num_bits/k));
                symbols = zeros(ceil(num_bits/k));
            end

            for i=1:app.metadata(1,1)
                
                if app.convActive
                    binData = conv_encoder(app.bindata_tx(i, :), app.convG1, app.convG2);
                else
                    binData = app.bindata_tx(i, :);
                end
                
                if app.N_levels == 1
                    [~, coeffsI, ~] = NRZ_polar_BPSK(binData);
                    symbols = coeffsI;
                else
                    [~, coeffsI, coeffsQ, ~, ~, ~] = NRZ_polar_QAM(binData, app.N_levels);
                    symbols = coeffsI + 1i*coeffsQ;
                end

                [ofdmBaseband, time, params] = OFDM_baseband(symbols, app.subcarriers, app.pilots);

                [ofdmPassband, time] = modulate_single_carrier(real(ofdmBaseband), imag(ofdmBaseband), time, app.phase, app.doppler, app.fc);
                ofdmPassband = canal(ofdmPassband, time, app.multipath, app.snr, app.N_levels, app.convActive, params);

                rxBaseband = demodulate_OFDM(ofdmPassband, time, app.fc);
                rxDirtyGrid = OFDM_prepare_grid(rxBaseband, params);

                rxSymbols = OFDM_slicer(rxDirtyGrid, params);
                if length(rxSymbols) > length(symbols)
                    rxSymbolsFinal = rxSymbols(1:length(symbols));
                else
                    rxSymbolsFinal = rxSymbols;
                end
                rxSymbolsFinal = normalize(rxSymbolsFinal);

                % Estou a reutilizar o mesmo buffer de antes
                if app.N_levels == 1
                    binData = slicer_demapper_BPSK(rxSymbolsFinal.');
                else
                    binData = demapper(rxSymbolsFinal.', app.N_levels);
                end

                if app.convActive
                    binData = viterbi(binData, app.convG1, app.convG2, app.metadata(1,2));
                end

                app.symbols_rx(i,:) = rxSymbolsFinal;
                app.bindata_rx(i,:) = binData(1:app.metadata(1,2));

                [rxCleanGrid, ~] = OFDM_equalizer(rxDirtyGrid, params);
                rxSymbols = OFDM_slicer(rxCleanGrid, params);

                if length(rxSymbols) > length(symbols)
                    rxSymbolsFinal = rxSymbols(1:length(symbols));
                else
                    rxSymbolsFinal = rxSymbols;
                end
                rxSymbolsFinal = normalize(rxSymbolsFinal);

                % Estou a reutilizar o mesmo buffer de antes
                if app.N_levels == 1
                    binData = slicer_demapper_BPSK(rxSymbolsFinal.');
                else
                    binData = demapper(rxSymbolsFinal.', app.N_levels);
                end

                
                if app.convActive
                    binData = viterbi(binData, app.convG1, app.convG2, app.metadata(1,2));
                end

                app.bindata_eq(i,:) = binData(1:app.metadata(1,2));
                app.symbols_tx(i,:) = symbols;
                app.symbols_eq(i,:) = rxSymbolsFinal;
            end
        end

        function [] = decodeBinData(app)
            if app.ber < app.ber_eq
                bindata = app.bindata_rx;
            else
                bindata = app.bindata_eq;
            end

            switch app.tipoDeDados
                case 'Áudio'
                    try
                        [app.uri_rx, audiodata] = audio_decoder(bindata, app.audioDuration, app.audioSampleRate);
                        plot(app.UIAxes9_2, audiodata);
                        app.OuvirButton_3.Enable = 'on';
                        app.error_audio_rx.Visible = 'off';
                        app.error_audio_rx.Enable = 'off';
                    catch
                        app.OuvirButton_3.Enable = 'off';
                        app.error_audio_rx.Visible = 'on';
                        app.error_audio_rx.Enable = 'on';
                    end
                case 'Imagem'
                    try
                        app.uri_rx = image_decoder(bindata);
                        app.image_rx_results.ImageSource = app.uri_rx;
                        app.error_img_rx.Visible = 'off';
                        app.error_img_rx.Enable = 'off';
                    catch
                        app.error_img_rx.Visible = 'on';
                        app.error_img_rx.Enable = 'on';
                    end
                case 'Texto'
                    textoRecebido = ASCII_decoder(bindata);
                    app.TextArea_2.Value = textoRecebido;
            end
        end

        function [] = plotConstellations(app)
            cla(app.UIAxes7);
            cla(app.UIAxes7_2);
            Es = (2/3) * (app.N_levels^2 - 1);      
            norm_factor = sqrt(1 / double(Es));
            integers = -(double(app.N_levels-1)) : 2 : (double(app.N_levels-1));
            if app.N_levels == 1
                levels = [-1 1];
                levels_I = levels;
                levels_Q = [0 0];
            else
                levels = integers*norm_factor;
                [levels_I, levels_Q] = meshgrid(levels, levels);
            end

            sz = size(app.symbols_rx);
            buffer_re = zeros(1, sz(2));
            buffer_im = zeros(1, sz(2));

            tamSymbols = size(app.symbols_tx);

            % Máximo de 1000 pontos senão meu PC explode
            nLinhas = ceil(1000/tamSymbols(2));
            if tamSymbols(2) < 1000
                nCols = tamSymbols(2); 
            else 
                nCols = 1000; 
            end

            % Constelação RX
            hold(app.UIAxes7, 'on');
            axis(app.UIAxes7, 'equal');
            for i=1:nLinhas
                buffer_re = real(app.symbols_rx(1:nCols));
                buffer_im = imag(app.symbols_rx(1:nCols));
                drawnow limitrate;
                scatter(app.UIAxes7, buffer_re, buffer_im, 'filled');
            end
            scatter(app.UIAxes7, levels_I, levels_Q, 'r', 'x', 'LineWidth',1);
            hold(app.UIAxes7, 'off');

            % Constelação EQ
            hold(app.UIAxes7_2, 'on');
            axis(app.UIAxes7_2, 'equal');
            for i=1:app.metadata(1,1)
                buffer_re = real(app.symbols_eq(1:nCols));
                buffer_im = imag(app.symbols_eq(1:nCols));
                scatter(app.UIAxes7_2, buffer_re, buffer_im, 'filled');
            end
            scatter(app.UIAxes7_2, levels_I, levels_Q, 'r', 'x', 'LineWidth',1);
            hold(app.UIAxes7_2, 'off');
        end

        function [] = plotBER(app)
            EbNo_dB = -10:1:10;
            k = 2*log2(app.N_levels);
            M = app.N_levels^2;
            if app.N_levels == 1
                modulation_type = 'psk'; % BPSK
                M = 2;
            elseif app.N_levels == 2
                modulation_type = 'psk'; % QPSK
            elseif app.N_levels >= 4 && mod(k, 2) == 0
                modulation_type = 'qam'; % M-QAM (com M=16, 64, 256...)
            else
                error('Modulação não suportada para cálculo teórico de BER.');
            end

            ber_teorico = berawgn(EbNo_dB, modulation_type, M, 'nondiff');
            cla(app.UIAxes8);
            hold(app.UIAxes8, "on");
            set(app.UIAxes8, 'YScale', 'log');
            semilogy(app.UIAxes8, EbNo_dB, ber_teorico, 'r-', 'LineWidth', 2);
            plot(app.UIAxes8, app.snr, app.ber, 'yx', 'MarkerSize', 8, 'LineWidth', 1.5);
            plot(app.UIAxes8, app.snr, app.ber_eq, 'gx', 'MarkerSize', 8, 'LineWidth', 1.5);
            hold(app.UIAxes8, "off");
        end

        function [] = calculateMetrics(app)
            tx_bits = app.bindata_tx(:);
            rx_bits = app.bindata_rx(:);
            rx_eq_bits = app.bindata_eq(:);
            
            tx_symbols = app.symbols_tx(:);
            rx_symbols = app.symbols_rx(:);
            rx_eq_symbols = app.symbols_eq(:);
            
            N_bits_total = length(tx_bits);
            N_symbols_total = length(tx_symbols);
        
            
            % BER RX (Antes da Equalização)
            errors_rx = sum(tx_bits ~= rx_bits);
            app.ber = errors_rx / N_bits_total;
            
            % BER RX Equalizado (Após a Equalização)
            errors_rx_eq = sum(tx_bits ~= rx_eq_bits);
            app.ber_eq = errors_rx_eq / N_bits_total;
        
            P_ref = sum(abs(tx_symbols).^2) / N_symbols_total;
            
            % EVM RX (Antes da Equalização)
            error_vector_rx = rx_symbols - tx_symbols;
            P_error_rx = sum(abs(error_vector_rx).^2) / N_symbols_total;
            
            % EVM = sqrt(P_error / P_ref) * 100%
            app.evm = sqrt(P_error_rx / P_ref);
            
            % EVM RX Equalizado (Após a Equalização)
            error_vector_rx_eq = rx_eq_symbols - tx_symbols;
            P_error_rx_eq = sum(abs(error_vector_rx_eq).^2) / N_symbols_total;
            
            app.evm_eq = sqrt(P_error_rx_eq / P_ref);

            app.BER_rx_label.Text = num2str(app.ber);
            app.BER_eq_label.Text = num2str(app.ber_eq);
            app.EVM_rx_label.Text = num2str(app.evm);
            app.EVM_eq_label.Text = num2str(app.evm_eq);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: FontededadosDropDown
        function FontededadosDropDownValueChanged(app, event)
            value = app.FontededadosDropDown.Value;
            
            switch value
                case 'Bits aleatórios'
                    app.FD_bitsAleatorios.Visible = "on";
                    app.FD_bitsAleatorios.Enable = "on";
                    app.FD_audio.Visible = "off";
                    app.FD_audio.Enable = "off";
                    app.FD_imagem.Visible = "off";
                    app.FD_imagem.Enable = "off";
                    app.FD_texto.Visible = "off";
                    app.FD_texto.Enable = "off";

                    app.RecuperaodedadosImagemPanel.Visible = "off";
                    app.RecuperaodedadosImagemPanel.Enable = "off";
                    app.RecuperaodedadosudioPanel.Visible = "off";
                    app.RecuperaodedadosudioPanel.Enable = "off";
                    app.RecuperaodedadosTextoPanel.Visible = "off";
                    app.RecuperaodedadosTextoPanel.Enable = "off";
                case 'Áudio'
                    app.FD_bitsAleatorios.Visible = "off";
                    app.FD_bitsAleatorios.Enable = "off";
                    app.FD_audio.Visible = "on";
                    app.FD_audio.Enable = "on";
                    app.FD_imagem.Visible = "off";
                    app.FD_imagem.Enable = "off";
                    app.FD_texto.Visible = "off";
                    app.FD_texto.Enable = "off";

                    app.RecuperaodedadosImagemPanel.Visible = "off";
                    app.RecuperaodedadosImagemPanel.Enable = "off";
                    app.RecuperaodedadosudioPanel.Visible = "on";
                    app.RecuperaodedadosudioPanel.Enable = "on";
                    app.RecuperaodedadosTextoPanel.Visible = "off";
                    app.RecuperaodedadosTextoPanel.Enable = "off";
                case 'Imagem'
                    app.FD_bitsAleatorios.Visible = "off";
                    app.FD_bitsAleatorios.Enable = "off";
                    app.FD_audio.Visible = "off";
                    app.FD_audio.Enable = "off";
                    app.FD_imagem.Visible = "on";
                    app.FD_imagem.Enable = "on";
                    app.FD_texto.Visible = "off";
                    app.FD_texto.Enable = "off";

                    app.RecuperaodedadosImagemPanel.Visible = "on";
                    app.RecuperaodedadosImagemPanel.Enable = "on";
                    app.RecuperaodedadosudioPanel.Visible = "off";
                    app.RecuperaodedadosudioPanel.Enable = "off";
                    app.RecuperaodedadosTextoPanel.Visible = "off";
                    app.RecuperaodedadosTextoPanel.Enable = "off";
                case 'Texto'
                    app.FD_bitsAleatorios.Visible = "off";
                    app.FD_bitsAleatorios.Enable = "off";
                    app.FD_audio.Visible = "off";
                    app.FD_audio.Enable = "off";
                    app.FD_imagem.Visible = "off";
                    app.FD_imagem.Enable = "off";
                    app.FD_texto.Visible = "on";
                    app.FD_texto.Enable = "on";

                    app.RecuperaodedadosImagemPanel.Visible = "off";
                    app.RecuperaodedadosImagemPanel.Enable = "off";
                    app.RecuperaodedadosudioPanel.Visible = "off";
                    app.RecuperaodedadosudioPanel.Enable = "off";
                    app.RecuperaodedadosTextoPanel.Visible = "on";
                    app.RecuperaodedadosTextoPanel.Enable = "on";
            end
        end

        % Button pushed function: SimularButton
        function SimularButtonPushed(app, event)
            app.initializeParameters();
            app.generateBinData();
            if app.generate
                app.plotSampleData();
                if app.ofdmActive
                    app.simulateOFDM();
                else
                    if app.N_levels == 1
                        app.simulateBPSKSingleCarrier();
                    else
                        app.simulateQAMSingleCarrier();
                    end
                end
                app.calculateMetrics();
                app.plotBER();
                app.decodeBinData();
                app.plotConstellations();
            else
                app.FD_error.Visible = "on";
                app.FD_error.Enable = "on";
            end
        end

        % Button pushed function: CarregarimagemapartirdeumficheiroButton
        function CarregarimagemapartirdeumficheiroButtonPushed(app, event)
            filter_spec = {'*.jpg;*.png;*.bmp', 'Ficheiros de Imagem (*.jpg, *.png, *.bmp)'};
            dialog_title = 'Selecione um Ficheiro de Imagem';
            [filename, pathname, ~] = uigetfile(filter_spec, dialog_title);
            if isequal(filename, 0) || isequal(pathname, 0)
                app.uri_tx = "";
            else
                app.uri_tx = fullfile(pathname, filename);
                try
                    app.Image.ImageSource = app.uri_tx;
                    app.image_tx_results.ImageSource = app.uri_tx;
                    app.FD_error.Visible = "off";
                    app.FD_error.Enable = "off";
                catch
                    app.FD_error.Visible = "on";
                    app.FD_error.Enable = "on";
                end
            end
        end

        % Button pushed function: CarregarudiodeumficheiroButton
        function CarregarudiodeumficheiroButtonPushed(app, event)
            filter_spec = {'*.wav;*.mp3;*.flac', 'Ficheiros de Áudio (*.wav, *.mp3, *.flac)'};
            dialog_title = 'Selecione um Ficheiro de Audio';
            [filename, pathname, ~] = uigetfile(filter_spec, dialog_title);
            if isequal(filename, 0) || isequal(pathname, 0)
                app.uri_tx = "";
            else
                app.uri_tx = fullfile(pathname, filename);
                audioMetaData = audioinfo(app.uri_tx);

                % Pega os 5 primeiros segundos do audio...
                if(audioMetaData.Duration > 5)
                    app.audioDuration = 5;
                else
                    app.audioDuration = floor(audioMetaData.Duration);
                    if(app.audioDuration <= 0)
                        app.FD_error.Visible = "on";
                        app.FD_error.Enable = "on";
                    end 
                end

                app.audioSampleRate = audioMetaData.SampleRate;
                try
                    app.OuvirButton_3.Enable = "off";
                    app.plotAudioSignal();
                    app.FD_error.Visible = "off";
                    app.FD_error.Enable = "off";
                catch
                    app.FD_error.Visible = "on";
                    app.FD_error.Enable = "on";
                end
            end
        end

        % Button pushed function: OuvirButton
        function OuvirButtonPushed(app, event)
            try
                audio_listen(app.uri_tx);
                app.FD_error.Visible = "off";
                app.FD_error.Enable = "off";
            catch
                app.FD_error.Visible = "on";
                app.FD_error.Enable = "on";
            end
        end

        % Button pushed function: GravarButton
        function GravarButtonPushed(app, event)
            try
                app.audioDuration = app.TempodegravaosegundosSpinner.Value;
                app.audioSampleRate = 44100;
                app.AgravarLabel.Visible = "on";
                app.AgravarLabel.Enable = "on";
                [~, app.uri_tx] = audio_recorder(app.audioDuration);
                app.AgravarLabel.Visible = "off";
                app.AgravarLabel.Enable = "off";
                app.plotAudioSignal();
                app.FD_error.Visible = "off";
                app.FD_error.Enable = "off";
            catch
                app.AgravarLabel.Visible = "off";
                app.AgravarLabel.Enable = "off";
                app.FD_error.Visible = "on";
                app.FD_error.Enable = "on";
            end
        end

        % Button pushed function: OuvirButton_2
        function OuvirButton_2Pushed(app, event)
            try
                audio_listen(app.uri_tx);
                app.error_audio_rx.Visible = "off";
                app.error_audio_rx.Enable = "off";
            catch
                app.error_audio_rx.Visible = "on";
                app.error_audio_rx.Enable = "on";
            end
        end

        % Button pushed function: OuvirButton_3
        function OuvirButton_3Pushed(app, event)
            try
                audio_listen(app.uri_rx);
                app.error_audio_rx.Visible = "off";
                app.error_audio_rx.Enable = "off";
            catch
                app.error_audio_rx.Visible = "on";
                app.error_audio_rx.Enable = "on";
            end
        end

        % Selection changed function: NmerodesubportadorasButtonGroup
        function NmerodesubportadorasButtonGroupSelectionChanged(app, event)
            selectedButton = app.NmerodesubportadorasButtonGroup.SelectedObject;
            
            switch selectedButton.Text
                case "64"
                    app.subcarriers = 64;
                case "128"
                    app.subcarriers = 128;
                case "256"
                    app.subcarriers = 256;
            end
        end

        % Value changed function: OFDMSwitch
        function OFDMSwitchValueChanged(app, event)
            value = app.OFDMSwitch.Value;
            
            if value == "On"
                app.NmerodesubportadorasButtonGroup.Enable = "on";
                app.PilotsEditField.Enable = "on";
            else
                app.NmerodesubportadorasButtonGroup.Enable = "off";
                app.PilotsEditField.Enable = "off";
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1210 774];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 1210 774];

            % Create ConfiguraesdasimulaoTab
            app.ConfiguraesdasimulaoTab = uitab(app.TabGroup);
            app.ConfiguraesdasimulaoTab.Title = 'Configurações da simulação';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.ConfiguraesdasimulaoTab);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create FontededadosPanel
            app.FontededadosPanel = uipanel(app.GridLayout);
            app.FontededadosPanel.TitlePosition = 'centertop';
            app.FontededadosPanel.Title = 'Fonte de dados';
            app.FontededadosPanel.Layout.Row = [2 13];
            app.FontededadosPanel.Layout.Column = [1 2];

            % Create FD_grid
            app.FD_grid = uigridlayout(app.FontededadosPanel);
            app.FD_grid.ColumnWidth = {'1.15x', 98.92, '1.69x', '1x'};
            app.FD_grid.RowHeight = {'1x', 21.98, '32.07x', '1x'};

            % Create FontededadosDropDownLabel
            app.FontededadosDropDownLabel = uilabel(app.FD_grid);
            app.FontededadosDropDownLabel.HorizontalAlignment = 'right';
            app.FontededadosDropDownLabel.Layout.Row = 2;
            app.FontededadosDropDownLabel.Layout.Column = 2;
            app.FontededadosDropDownLabel.Text = 'Fonte de dados';

            % Create FontededadosDropDown
            app.FontededadosDropDown = uidropdown(app.FD_grid);
            app.FontededadosDropDown.Items = {'Bits aleatórios', 'Áudio', 'Imagem', 'Texto'};
            app.FontededadosDropDown.ValueChangedFcn = createCallbackFcn(app, @FontededadosDropDownValueChanged, true);
            app.FontededadosDropDown.Layout.Row = 2;
            app.FontededadosDropDown.Layout.Column = 3;
            app.FontededadosDropDown.Value = 'Bits aleatórios';

            % Create FD_bitsAleatorios
            app.FD_bitsAleatorios = uipanel(app.FD_grid);
            app.FD_bitsAleatorios.BackgroundColor = [0.2 0.2 0.2];
            app.FD_bitsAleatorios.Layout.Row = 3;
            app.FD_bitsAleatorios.Layout.Column = [1 4];

            % Create NmerodebitsporlinhaSpinnerLabel
            app.NmerodebitsporlinhaSpinnerLabel = uilabel(app.FD_bitsAleatorios);
            app.NmerodebitsporlinhaSpinnerLabel.HorizontalAlignment = 'right';
            app.NmerodebitsporlinhaSpinnerLabel.Position = [58 400 136 22];
            app.NmerodebitsporlinhaSpinnerLabel.Text = 'Número de bits por linha';

            % Create NmerodebitsporlinhaSpinner
            app.NmerodebitsporlinhaSpinner = uispinner(app.FD_bitsAleatorios);
            app.NmerodebitsporlinhaSpinner.Step = 10;
            app.NmerodebitsporlinhaSpinner.Limits = [100 1000];
            app.NmerodebitsporlinhaSpinner.Position = [209 400 100 22];
            app.NmerodebitsporlinhaSpinner.Value = 100;

            % Create NmerodelinhasSpinnerLabel
            app.NmerodelinhasSpinnerLabel = uilabel(app.FD_bitsAleatorios);
            app.NmerodelinhasSpinnerLabel.HorizontalAlignment = 'right';
            app.NmerodelinhasSpinnerLabel.Position = [75 363 99 22];
            app.NmerodelinhasSpinnerLabel.Text = 'Número de linhas';

            % Create NmerodelinhasSpinner
            app.NmerodelinhasSpinner = uispinner(app.FD_bitsAleatorios);
            app.NmerodelinhasSpinner.Limits = [1 10000];
            app.NmerodelinhasSpinner.Position = [189 363 100 22];
            app.NmerodelinhasSpinner.Value = 1;

            % Create FD_imagem
            app.FD_imagem = uipanel(app.FD_grid);
            app.FD_imagem.Enable = 'off';
            app.FD_imagem.Visible = 'off';
            app.FD_imagem.BackgroundColor = [0.2 0.2 0.2];
            app.FD_imagem.Layout.Row = 3;
            app.FD_imagem.Layout.Column = [1 4];

            % Create CarregarimagemapartirdeumficheiroButton
            app.CarregarimagemapartirdeumficheiroButton = uibutton(app.FD_imagem, 'push');
            app.CarregarimagemapartirdeumficheiroButton.ButtonPushedFcn = createCallbackFcn(app, @CarregarimagemapartirdeumficheiroButtonPushed, true);
            app.CarregarimagemapartirdeumficheiroButton.Position = [70 356 230 23];
            app.CarregarimagemapartirdeumficheiroButton.Text = 'Carregar imagem a partir de um ficheiro';

            % Create Image
            app.Image = uiimage(app.FD_imagem);
            app.Image.Position = [17 64 336 217];

            % Create FD_audio
            app.FD_audio = uipanel(app.FD_grid);
            app.FD_audio.Enable = 'off';
            app.FD_audio.Visible = 'off';
            app.FD_audio.BackgroundColor = [0.2 0.2 0.2];
            app.FD_audio.Layout.Row = 3;
            app.FD_audio.Layout.Column = [1 4];

            % Create UIAxes
            app.UIAxes = uiaxes(app.FD_audio);
            title(app.UIAxes, 'Sinal de áudio')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [23 83 323 178];

            % Create TempodegravaosegundosSpinnerLabel
            app.TempodegravaosegundosSpinnerLabel = uilabel(app.FD_audio);
            app.TempodegravaosegundosSpinnerLabel.HorizontalAlignment = 'right';
            app.TempodegravaosegundosSpinnerLabel.Position = [40 348 174 22];
            app.TempodegravaosegundosSpinnerLabel.Text = 'Tempo de gravação (segundos)';

            % Create TempodegravaosegundosSpinner
            app.TempodegravaosegundosSpinner = uispinner(app.FD_audio);
            app.TempodegravaosegundosSpinner.Step = 0.5;
            app.TempodegravaosegundosSpinner.Limits = [1 5];
            app.TempodegravaosegundosSpinner.Position = [229 348 100 22];
            app.TempodegravaosegundosSpinner.Value = 1;

            % Create OULabel
            app.OULabel = uilabel(app.FD_audio);
            app.OULabel.HorizontalAlignment = 'center';
            app.OULabel.Position = [163 384 25 22];
            app.OULabel.Text = 'OU';

            % Create GravarButton
            app.GravarButton = uibutton(app.FD_audio, 'push');
            app.GravarButton.ButtonPushedFcn = createCallbackFcn(app, @GravarButtonPushed, true);
            app.GravarButton.Position = [135 298 100 23];
            app.GravarButton.Text = 'Gravar';

            % Create OuvirButton
            app.OuvirButton = uibutton(app.FD_audio, 'push');
            app.OuvirButton.ButtonPushedFcn = createCallbackFcn(app, @OuvirButtonPushed, true);
            app.OuvirButton.Position = [135 29 100 23];
            app.OuvirButton.Text = 'Ouvir';

            % Create CarregarudiodeumficheiroButton
            app.CarregarudiodeumficheiroButton = uibutton(app.FD_audio, 'push');
            app.CarregarudiodeumficheiroButton.ButtonPushedFcn = createCallbackFcn(app, @CarregarudiodeumficheiroButtonPushed, true);
            app.CarregarudiodeumficheiroButton.Position = [79 415 208 23];
            app.CarregarudiodeumficheiroButton.Text = 'Carregar áudio de um ficheiro';

            % Create AgravarLabel
            app.AgravarLabel = uilabel(app.FD_audio);
            app.AgravarLabel.FontWeight = 'bold';
            app.AgravarLabel.FontColor = [1 0 0];
            app.AgravarLabel.Enable = 'off';
            app.AgravarLabel.Visible = 'off';
            app.AgravarLabel.Position = [265 298 63 22];
            app.AgravarLabel.Text = 'A gravar...';

            % Create FD_texto
            app.FD_texto = uipanel(app.FD_grid);
            app.FD_texto.Enable = 'off';
            app.FD_texto.Visible = 'off';
            app.FD_texto.BackgroundColor = [0.2 0.2 0.2];
            app.FD_texto.Layout.Row = 3;
            app.FD_texto.Layout.Column = [1 4];

            % Create InsiraseutextoASCIIExtendida8bitsLabel
            app.InsiraseutextoASCIIExtendida8bitsLabel = uilabel(app.FD_texto);
            app.InsiraseutextoASCIIExtendida8bitsLabel.HorizontalAlignment = 'center';
            app.InsiraseutextoASCIIExtendida8bitsLabel.Position = [118 432 140 30];
            app.InsiraseutextoASCIIExtendida8bitsLabel.Text = {'Insira seu texto'; '(ASCII Extendida - 8 bits)'};

            % Create TextArea_3
            app.TextArea_3 = uitextarea(app.FD_texto);
            app.TextArea_3.Position = [49 302 278 108];

            % Create ModulaoPanel
            app.ModulaoPanel = uipanel(app.GridLayout);
            app.ModulaoPanel.TitlePosition = 'centertop';
            app.ModulaoPanel.Title = 'Modulação';
            app.ModulaoPanel.Layout.Row = [2 13];
            app.ModulaoPanel.Layout.Column = [3 4];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.ModulaoPanel);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout2.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create ModulaoDropDownLabel
            app.ModulaoDropDownLabel = uilabel(app.GridLayout2);
            app.ModulaoDropDownLabel.HorizontalAlignment = 'center';
            app.ModulaoDropDownLabel.Layout.Row = 4;
            app.ModulaoDropDownLabel.Layout.Column = 1;
            app.ModulaoDropDownLabel.Text = 'Modulação';

            % Create ModulaoDropDown
            app.ModulaoDropDown = uidropdown(app.GridLayout2);
            app.ModulaoDropDown.Items = {'BPSK', 'QPSK', '16-QAM', '64-QAM', '256-QAM'};
            app.ModulaoDropDown.Layout.Row = 4;
            app.ModulaoDropDown.Layout.Column = [2 4];
            app.ModulaoDropDown.Value = 'BPSK';

            % Create CodificaoconvolucionalSwitchLabel
            app.CodificaoconvolucionalSwitchLabel = uilabel(app.GridLayout2);
            app.CodificaoconvolucionalSwitchLabel.HorizontalAlignment = 'center';
            app.CodificaoconvolucionalSwitchLabel.Layout.Row = 7;
            app.CodificaoconvolucionalSwitchLabel.Layout.Column = [2 3];
            app.CodificaoconvolucionalSwitchLabel.Text = 'Codificação convolucional';

            % Create CodificaoconvolucionalSwitch
            app.CodificaoconvolucionalSwitch = uiswitch(app.GridLayout2, 'slider');
            app.CodificaoconvolucionalSwitch.Layout.Row = 6;
            app.CodificaoconvolucionalSwitch.Layout.Column = [2 3];

            % Create OFDMSwitchLabel
            app.OFDMSwitchLabel = uilabel(app.GridLayout2);
            app.OFDMSwitchLabel.HorizontalAlignment = 'center';
            app.OFDMSwitchLabel.Layout.Row = 10;
            app.OFDMSwitchLabel.Layout.Column = [2 3];
            app.OFDMSwitchLabel.Text = 'OFDM';

            % Create OFDMSwitch
            app.OFDMSwitch = uiswitch(app.GridLayout2, 'slider');
            app.OFDMSwitch.ValueChangedFcn = createCallbackFcn(app, @OFDMSwitchValueChanged, true);
            app.OFDMSwitch.Layout.Row = 9;
            app.OFDMSwitch.Layout.Column = [2 3];

            % Create NmerodesubportadorasButtonGroup
            app.NmerodesubportadorasButtonGroup = uibuttongroup(app.GridLayout2);
            app.NmerodesubportadorasButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @NmerodesubportadorasButtonGroupSelectionChanged, true);
            app.NmerodesubportadorasButtonGroup.Enable = 'off';
            app.NmerodesubportadorasButtonGroup.TitlePosition = 'centertop';
            app.NmerodesubportadorasButtonGroup.Title = 'Número de subportadoras';
            app.NmerodesubportadorasButtonGroup.Layout.Row = [11 13];
            app.NmerodesubportadorasButtonGroup.Layout.Column = [2 3];

            % Create Button
            app.Button = uiradiobutton(app.NmerodesubportadorasButtonGroup);
            app.Button.Text = '64';
            app.Button.Position = [11 62 58 22];
            app.Button.Value = true;

            % Create Button_2
            app.Button_2 = uiradiobutton(app.NmerodesubportadorasButtonGroup);
            app.Button_2.Text = '128';
            app.Button_2.Position = [11 40 65 22];

            % Create Button_3
            app.Button_3 = uiradiobutton(app.NmerodesubportadorasButtonGroup);
            app.Button_3.Text = '256';
            app.Button_3.Position = [11 18 65 22];

            % Create PilotsEditFieldLabel
            app.PilotsEditFieldLabel = uilabel(app.GridLayout2);
            app.PilotsEditFieldLabel.HorizontalAlignment = 'center';
            app.PilotsEditFieldLabel.Enable = 'off';
            app.PilotsEditFieldLabel.Layout.Row = 14;
            app.PilotsEditFieldLabel.Layout.Column = 2;
            app.PilotsEditFieldLabel.Text = 'Pilots';

            % Create PilotsEditField
            app.PilotsEditField = uieditfield(app.GridLayout2, 'numeric');
            app.PilotsEditField.Limits = [0 178];
            app.PilotsEditField.Enable = 'off';
            app.PilotsEditField.Layout.Row = 14;
            app.PilotsEditField.Layout.Column = 3;
            app.PilotsEditField.Value = 8;

            % Create ImperfeiesnocanalPanel
            app.ImperfeiesnocanalPanel = uipanel(app.GridLayout);
            app.ImperfeiesnocanalPanel.TitlePosition = 'centertop';
            app.ImperfeiesnocanalPanel.Title = 'Imperfeições no canal';
            app.ImperfeiesnocanalPanel.Layout.Row = [2 13];
            app.ImperfeiesnocanalPanel.Layout.Column = [5 6];

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.ImperfeiesnocanalPanel);
            app.GridLayout3.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create SNRSliderLabel
            app.SNRSliderLabel = uilabel(app.GridLayout3);
            app.SNRSliderLabel.HorizontalAlignment = 'center';
            app.SNRSliderLabel.Layout.Row = [3 4];
            app.SNRSliderLabel.Layout.Column = 1;
            app.SNRSliderLabel.Text = 'SNR';

            % Create SNRSlider
            app.SNRSlider = uislider(app.GridLayout3);
            app.SNRSlider.Limits = [-20 100];
            app.SNRSlider.Step = 1;
            app.SNRSlider.Layout.Row = [3 4];
            app.SNRSlider.Layout.Column = [2 4];

            % Create CanalmultipercursoLabel
            app.CanalmultipercursoLabel = uilabel(app.GridLayout3);
            app.CanalmultipercursoLabel.HorizontalAlignment = 'center';
            app.CanalmultipercursoLabel.Layout.Row = 5;
            app.CanalmultipercursoLabel.Layout.Column = 1;
            app.CanalmultipercursoLabel.Text = {'Canal '; 'Multipercurso'};

            % Create CanalMultipercursoDropDown
            app.CanalMultipercursoDropDown = uidropdown(app.GridLayout3);
            app.CanalMultipercursoDropDown.Items = {'Perfil 0 - Sem multipercurso', 'Perfil 1 - Indoor', 'Perfil 2 - Indoor / Open space caótico', 'Perfil 3 - Typical urban', 'Perfil 4 - Urban dense'};
            app.CanalMultipercursoDropDown.Layout.Row = 5;
            app.CanalMultipercursoDropDown.Layout.Column = [2 4];
            app.CanalMultipercursoDropDown.Value = 'Perfil 0 - Sem multipercurso';

            % Create DesvioDopplerEditFieldLabel
            app.DesvioDopplerEditFieldLabel = uilabel(app.GridLayout3);
            app.DesvioDopplerEditFieldLabel.HorizontalAlignment = 'right';
            app.DesvioDopplerEditFieldLabel.Layout.Row = 7;
            app.DesvioDopplerEditFieldLabel.Layout.Column = 2;
            app.DesvioDopplerEditFieldLabel.Text = 'Desvio Doppler';

            % Create DesvioDopplerEditField
            app.DesvioDopplerEditField = uieditfield(app.GridLayout3, 'numeric');
            app.DesvioDopplerEditField.Layout.Row = 7;
            app.DesvioDopplerEditField.Layout.Column = 3;

            % Create RudodeFaseEditFieldLabel
            app.RudodeFaseEditFieldLabel = uilabel(app.GridLayout3);
            app.RudodeFaseEditFieldLabel.HorizontalAlignment = 'right';
            app.RudodeFaseEditFieldLabel.Layout.Row = 8;
            app.RudodeFaseEditFieldLabel.Layout.Column = 2;
            app.RudodeFaseEditFieldLabel.Text = 'Ruído de Fase';

            % Create RudodeFaseEditField
            app.RudodeFaseEditField = uieditfield(app.GridLayout3, 'numeric');
            app.RudodeFaseEditField.Layout.Row = 8;
            app.RudodeFaseEditField.Layout.Column = 3;

            % Create SimularButton
            app.SimularButton = uibutton(app.GridLayout, 'push');
            app.SimularButton.ButtonPushedFcn = createCallbackFcn(app, @SimularButtonPushed, true);
            app.SimularButton.Layout.Row = 14;
            app.SimularButton.Layout.Column = [3 4];
            app.SimularButton.Text = 'Simular';

            % Create SimuladordecomunicaesdigitaisLabel
            app.SimuladordecomunicaesdigitaisLabel = uilabel(app.GridLayout);
            app.SimuladordecomunicaesdigitaisLabel.HorizontalAlignment = 'center';
            app.SimuladordecomunicaesdigitaisLabel.FontSize = 18;
            app.SimuladordecomunicaesdigitaisLabel.FontWeight = 'bold';
            app.SimuladordecomunicaesdigitaisLabel.Layout.Row = 1;
            app.SimuladordecomunicaesdigitaisLabel.Layout.Column = [3 4];
            app.SimuladordecomunicaesdigitaisLabel.Text = 'Simulador de comunicações digitais';

            % Create FD_error
            app.FD_error = uipanel(app.GridLayout);
            app.FD_error.Enable = 'off';
            app.FD_error.Visible = 'off';
            app.FD_error.Layout.Row = 1;
            app.FD_error.Layout.Column = [1 2];

            % Create GridLayout12
            app.GridLayout12 = uigridlayout(app.FD_error);
            app.GridLayout12.ColumnWidth = {'1x'};
            app.GridLayout12.RowHeight = {'1x'};
            app.GridLayout12.BackgroundColor = [1 0 0];

            % Create ERROLabel
            app.ERROLabel = uilabel(app.GridLayout12);
            app.ERROLabel.HorizontalAlignment = 'center';
            app.ERROLabel.FontSize = 18;
            app.ERROLabel.FontWeight = 'bold';
            app.ERROLabel.FontColor = [0.149 0.149 0.149];
            app.ERROLabel.Layout.Row = 1;
            app.ERROLabel.Layout.Column = 1;
            app.ERROLabel.Text = 'ERRO';

            % Create BandabaseTXTab
            app.BandabaseTXTab = uitab(app.TabGroup);
            app.BandabaseTXTab.Title = 'Banda base - TX';

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.BandabaseTXTab);
            app.GridLayout4.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout4.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.GridLayout4);
            title(app.UIAxes2, 'Banda base sem imperfeições - I')
            xlabel(app.UIAxes2, 'tempo')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Layout.Row = [1 6];
            app.UIAxes2.Layout.Column = [2 5];

            % Create UIAxes2_3
            app.UIAxes2_3 = uiaxes(app.GridLayout4);
            title(app.UIAxes2_3, 'Banda base sem imperfeições - Q')
            xlabel(app.UIAxes2_3, 'tempo')
            zlabel(app.UIAxes2_3, 'Z')
            app.UIAxes2_3.Layout.Row = [7 12];
            app.UIAxes2_3.Layout.Column = [2 5];

            % Create CanalTab
            app.CanalTab = uitab(app.TabGroup);
            app.CanalTab.Title = 'Canal';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.CanalTab);
            app.GridLayout5.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout5.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes5_2
            app.UIAxes5_2 = uiaxes(app.GridLayout5);
            title(app.UIAxes5_2, 'Sinal com imperfeições modulado em passa-banda')
            xlabel(app.UIAxes5_2, 'tempo')
            zlabel(app.UIAxes5_2, 'Z')
            app.UIAxes5_2.Layout.Row = [7 11];
            app.UIAxes5_2.Layout.Column = [1 4];

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.GridLayout5);
            title(app.UIAxes6, 'Espectro de frequências - FFT')
            xlabel(app.UIAxes6, 'frequência')
            zlabel(app.UIAxes6, 'Z')
            app.UIAxes6.Layout.Row = [2 6];
            app.UIAxes6.Layout.Column = [5 6];

            % Create UIAxes6_2
            app.UIAxes6_2 = uiaxes(app.GridLayout5);
            title(app.UIAxes6_2, 'Espectro de frequências - FFT')
            xlabel(app.UIAxes6_2, 'frequência')
            zlabel(app.UIAxes6_2, 'Z')
            app.UIAxes6_2.Layout.Row = [7 11];
            app.UIAxes6_2.Layout.Column = [5 6];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.GridLayout5);
            title(app.UIAxes5, 'Sinal sem imperfeições modulado em passa-banda')
            xlabel(app.UIAxes5, 'tempo')
            zlabel(app.UIAxes5, 'Z')
            app.UIAxes5.Layout.Row = [2 6];
            app.UIAxes5.Layout.Column = [1 4];

            % Create ConstelaesRXTab
            app.ConstelaesRXTab = uitab(app.TabGroup);
            app.ConstelaesRXTab.Title = 'Constelações - RX';

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.ConstelaesRXTab);
            app.GridLayout6.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout6.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes7
            app.UIAxes7 = uiaxes(app.GridLayout6);
            title(app.UIAxes7, 'Constelação recebida')
            xlabel(app.UIAxes7, 'In-Phase')
            ylabel(app.UIAxes7, 'Quadrature')
            zlabel(app.UIAxes7, 'Z')
            app.UIAxes7.XGrid = 'on';
            app.UIAxes7.YGrid = 'on';
            app.UIAxes7.Layout.Row = [2 8];
            app.UIAxes7.Layout.Column = [2 4];

            % Create UIAxes7_2
            app.UIAxes7_2 = uiaxes(app.GridLayout6);
            title(app.UIAxes7_2, 'Constelação corrigida')
            xlabel(app.UIAxes7_2, 'In-Phase')
            ylabel(app.UIAxes7_2, 'Quadrature')
            zlabel(app.UIAxes7_2, 'Z')
            app.UIAxes7_2.XGrid = 'on';
            app.UIAxes7_2.YGrid = 'on';
            app.UIAxes7_2.Layout.Row = [2 8];
            app.UIAxes7_2.Layout.Column = [6 8];

            % Create ResultadosTab
            app.ResultadosTab = uitab(app.TabGroup);
            app.ResultadosTab.Title = 'Resultados';

            % Create GridLayout7
            app.GridLayout7 = uigridlayout(app.ResultadosTab);
            app.GridLayout7.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout7.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create Panel
            app.Panel = uipanel(app.GridLayout7);
            app.Panel.Layout.Row = [1 12];
            app.Panel.Layout.Column = [1 3];

            % Create GridLayout8
            app.GridLayout8 = uigridlayout(app.Panel);
            app.GridLayout8.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout8.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes8
            app.UIAxes8 = uiaxes(app.GridLayout8);
            title(app.UIAxes8, 'Curva de BER')
            xlabel(app.UIAxes8, 'SNR')
            ylabel(app.UIAxes8, 'BER')
            zlabel(app.UIAxes8, 'Z')
            app.UIAxes8.Layout.Row = [8 12];
            app.UIAxes8.Layout.Column = [1 8];

            % Create BERLabel
            app.BERLabel = uilabel(app.GridLayout8);
            app.BERLabel.HorizontalAlignment = 'center';
            app.BERLabel.FontSize = 18;
            app.BERLabel.FontWeight = 'bold';
            app.BERLabel.Layout.Row = 2;
            app.BERLabel.Layout.Column = [4 5];
            app.BERLabel.Text = 'BER';

            % Create EVMLabel
            app.EVMLabel = uilabel(app.GridLayout8);
            app.EVMLabel.HorizontalAlignment = 'center';
            app.EVMLabel.FontSize = 18;
            app.EVMLabel.FontWeight = 'bold';
            app.EVMLabel.Layout.Row = 5;
            app.EVMLabel.Layout.Column = [4 5];
            app.EVMLabel.Text = 'EVM';

            % Create EVM_eq_label
            app.EVM_eq_label = uilabel(app.GridLayout8);
            app.EVM_eq_label.HorizontalAlignment = 'center';
            app.EVM_eq_label.FontSize = 14;
            app.EVM_eq_label.Layout.Row = 6;
            app.EVM_eq_label.Layout.Column = 7;
            app.EVM_eq_label.Text = 'A calcular';

            % Create RecebidoLabel
            app.RecebidoLabel = uilabel(app.GridLayout8);
            app.RecebidoLabel.HorizontalAlignment = 'center';
            app.RecebidoLabel.FontSize = 14;
            app.RecebidoLabel.FontWeight = 'bold';
            app.RecebidoLabel.Layout.Row = 3;
            app.RecebidoLabel.Layout.Column = [2 3];
            app.RecebidoLabel.Text = 'Recebido';

            % Create RecebidoLabel_2
            app.RecebidoLabel_2 = uilabel(app.GridLayout8);
            app.RecebidoLabel_2.HorizontalAlignment = 'center';
            app.RecebidoLabel_2.FontSize = 14;
            app.RecebidoLabel_2.FontWeight = 'bold';
            app.RecebidoLabel_2.Layout.Row = 6;
            app.RecebidoLabel_2.Layout.Column = [2 3];
            app.RecebidoLabel_2.Text = 'Recebido';

            % Create CorrigidoLabel
            app.CorrigidoLabel = uilabel(app.GridLayout8);
            app.CorrigidoLabel.HorizontalAlignment = 'center';
            app.CorrigidoLabel.FontSize = 14;
            app.CorrigidoLabel.FontWeight = 'bold';
            app.CorrigidoLabel.Layout.Row = 3;
            app.CorrigidoLabel.Layout.Column = [5 6];
            app.CorrigidoLabel.Text = 'Corrigido';

            % Create CorrigidoLabel_2
            app.CorrigidoLabel_2 = uilabel(app.GridLayout8);
            app.CorrigidoLabel_2.HorizontalAlignment = 'center';
            app.CorrigidoLabel_2.FontSize = 14;
            app.CorrigidoLabel_2.FontWeight = 'bold';
            app.CorrigidoLabel_2.Layout.Row = 6;
            app.CorrigidoLabel_2.Layout.Column = [5 6];
            app.CorrigidoLabel_2.Text = 'Corrigido';

            % Create BER_eq_label
            app.BER_eq_label = uilabel(app.GridLayout8);
            app.BER_eq_label.HorizontalAlignment = 'center';
            app.BER_eq_label.FontSize = 14;
            app.BER_eq_label.Layout.Row = 3;
            app.BER_eq_label.Layout.Column = 7;
            app.BER_eq_label.Text = 'A calcular';

            % Create BER_rx_label
            app.BER_rx_label = uilabel(app.GridLayout8);
            app.BER_rx_label.HorizontalAlignment = 'center';
            app.BER_rx_label.FontSize = 14;
            app.BER_rx_label.Layout.Row = 3;
            app.BER_rx_label.Layout.Column = 4;
            app.BER_rx_label.Text = 'A calcular';

            % Create EVM_rx_label
            app.EVM_rx_label = uilabel(app.GridLayout8);
            app.EVM_rx_label.HorizontalAlignment = 'center';
            app.EVM_rx_label.FontSize = 14;
            app.EVM_rx_label.Layout.Row = 6;
            app.EVM_rx_label.Layout.Column = 4;
            app.EVM_rx_label.Text = 'A calcular';

            % Create RecuperaodedadosTextoPanel
            app.RecuperaodedadosTextoPanel = uipanel(app.GridLayout7);
            app.RecuperaodedadosTextoPanel.Enable = 'off';
            app.RecuperaodedadosTextoPanel.TitlePosition = 'centertop';
            app.RecuperaodedadosTextoPanel.Title = 'Recuperação de dados - Texto';
            app.RecuperaodedadosTextoPanel.Visible = 'off';
            app.RecuperaodedadosTextoPanel.Layout.Row = [1 12];
            app.RecuperaodedadosTextoPanel.Layout.Column = [4 6];
            app.RecuperaodedadosTextoPanel.FontWeight = 'bold';

            % Create GridLayout9
            app.GridLayout9 = uigridlayout(app.RecuperaodedadosTextoPanel);
            app.GridLayout9.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout9.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create TextArea
            app.TextArea = uitextarea(app.GridLayout9);
            app.TextArea.Editable = 'off';
            app.TextArea.Layout.Row = [3 4];
            app.TextArea.Layout.Column = [2 5];

            % Create TextArea_2
            app.TextArea_2 = uitextarea(app.GridLayout9);
            app.TextArea_2.Editable = 'off';
            app.TextArea_2.Layout.Row = [7 8];
            app.TextArea_2.Layout.Column = [2 5];

            % Create TextoEnviadoLabel
            app.TextoEnviadoLabel = uilabel(app.GridLayout9);
            app.TextoEnviadoLabel.HorizontalAlignment = 'center';
            app.TextoEnviadoLabel.FontSize = 18;
            app.TextoEnviadoLabel.FontWeight = 'bold';
            app.TextoEnviadoLabel.Layout.Row = 2;
            app.TextoEnviadoLabel.Layout.Column = [3 4];
            app.TextoEnviadoLabel.Text = 'Texto Enviado';

            % Create TextoRecebidoLabel
            app.TextoRecebidoLabel = uilabel(app.GridLayout9);
            app.TextoRecebidoLabel.HorizontalAlignment = 'center';
            app.TextoRecebidoLabel.FontSize = 18;
            app.TextoRecebidoLabel.FontWeight = 'bold';
            app.TextoRecebidoLabel.Layout.Row = 6;
            app.TextoRecebidoLabel.Layout.Column = [3 4];
            app.TextoRecebidoLabel.Text = 'Texto Recebido';

            % Create RecuperaodedadosudioPanel
            app.RecuperaodedadosudioPanel = uipanel(app.GridLayout7);
            app.RecuperaodedadosudioPanel.Enable = 'off';
            app.RecuperaodedadosudioPanel.TitlePosition = 'centertop';
            app.RecuperaodedadosudioPanel.Title = 'Recuperação de dados - Áudio';
            app.RecuperaodedadosudioPanel.Visible = 'off';
            app.RecuperaodedadosudioPanel.Layout.Row = [1 12];
            app.RecuperaodedadosudioPanel.Layout.Column = [4 6];
            app.RecuperaodedadosudioPanel.FontWeight = 'bold';

            % Create GridLayout10
            app.GridLayout10 = uigridlayout(app.RecuperaodedadosudioPanel);
            app.GridLayout10.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout10.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create UIAxes9_2
            app.UIAxes9_2 = uiaxes(app.GridLayout10);
            zlabel(app.UIAxes9_2, 'Z')
            app.UIAxes9_2.Layout.Row = [9 11];
            app.UIAxes9_2.Layout.Column = [1 3];

            % Create UIAxes9
            app.UIAxes9 = uiaxes(app.GridLayout10);
            zlabel(app.UIAxes9, 'Z')
            app.UIAxes9.Layout.Row = [3 5];
            app.UIAxes9.Layout.Column = [1 3];

            % Create OuvirButton_2
            app.OuvirButton_2 = uibutton(app.GridLayout10, 'push');
            app.OuvirButton_2.ButtonPushedFcn = createCallbackFcn(app, @OuvirButton_2Pushed, true);
            app.OuvirButton_2.Layout.Row = 6;
            app.OuvirButton_2.Layout.Column = 2;
            app.OuvirButton_2.Text = 'Ouvir';

            % Create OuvirButton_3
            app.OuvirButton_3 = uibutton(app.GridLayout10, 'push');
            app.OuvirButton_3.ButtonPushedFcn = createCallbackFcn(app, @OuvirButton_3Pushed, true);
            app.OuvirButton_3.Layout.Row = 12;
            app.OuvirButton_3.Layout.Column = 2;
            app.OuvirButton_3.Text = 'Ouvir';

            % Create udioEnviadoLabel
            app.udioEnviadoLabel = uilabel(app.GridLayout10);
            app.udioEnviadoLabel.HorizontalAlignment = 'center';
            app.udioEnviadoLabel.FontSize = 18;
            app.udioEnviadoLabel.FontWeight = 'bold';
            app.udioEnviadoLabel.Layout.Row = 2;
            app.udioEnviadoLabel.Layout.Column = 2;
            app.udioEnviadoLabel.Text = 'Áudio Enviado';

            % Create udioRecebidoLabel
            app.udioRecebidoLabel = uilabel(app.GridLayout10);
            app.udioRecebidoLabel.HorizontalAlignment = 'center';
            app.udioRecebidoLabel.FontSize = 18;
            app.udioRecebidoLabel.FontWeight = 'bold';
            app.udioRecebidoLabel.Layout.Row = 8;
            app.udioRecebidoLabel.Layout.Column = 2;
            app.udioRecebidoLabel.Text = 'Áudio Recebido';

            % Create error_audio_rx
            app.error_audio_rx = uipanel(app.GridLayout10);
            app.error_audio_rx.Enable = 'off';
            app.error_audio_rx.Visible = 'off';
            app.error_audio_rx.Layout.Row = 1;
            app.error_audio_rx.Layout.Column = [1 3];

            % Create GridLayout12_3
            app.GridLayout12_3 = uigridlayout(app.error_audio_rx);
            app.GridLayout12_3.ColumnWidth = {'1x'};
            app.GridLayout12_3.RowHeight = {'1x'};
            app.GridLayout12_3.BackgroundColor = [1 0 0];

            % Create ERROLabel_3
            app.ERROLabel_3 = uilabel(app.GridLayout12_3);
            app.ERROLabel_3.HorizontalAlignment = 'center';
            app.ERROLabel_3.FontSize = 18;
            app.ERROLabel_3.FontWeight = 'bold';
            app.ERROLabel_3.FontColor = [0.149 0.149 0.149];
            app.ERROLabel_3.Layout.Row = 1;
            app.ERROLabel_3.Layout.Column = 1;
            app.ERROLabel_3.Text = 'ERRO';

            % Create RecuperaodedadosImagemPanel
            app.RecuperaodedadosImagemPanel = uipanel(app.GridLayout7);
            app.RecuperaodedadosImagemPanel.TitlePosition = 'centertop';
            app.RecuperaodedadosImagemPanel.Title = 'Recuperação de dados - Imagem';
            app.RecuperaodedadosImagemPanel.Visible = 'off';
            app.RecuperaodedadosImagemPanel.Layout.Row = [1 12];
            app.RecuperaodedadosImagemPanel.Layout.Column = [4 6];
            app.RecuperaodedadosImagemPanel.FontWeight = 'bold';

            % Create GridLayout11
            app.GridLayout11 = uigridlayout(app.RecuperaodedadosImagemPanel);
            app.GridLayout11.ColumnWidth = {'1x', '1x', '1x', '1x', '1x'};
            app.GridLayout11.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create image_tx_results
            app.image_tx_results = uiimage(app.GridLayout11);
            app.image_tx_results.Layout.Row = [3 6];
            app.image_tx_results.Layout.Column = [2 4];

            % Create image_rx_results
            app.image_rx_results = uiimage(app.GridLayout11);
            app.image_rx_results.Layout.Row = [9 12];
            app.image_rx_results.Layout.Column = [2 4];

            % Create ImagemEnviadaLabel
            app.ImagemEnviadaLabel = uilabel(app.GridLayout11);
            app.ImagemEnviadaLabel.HorizontalAlignment = 'center';
            app.ImagemEnviadaLabel.FontSize = 18;
            app.ImagemEnviadaLabel.FontWeight = 'bold';
            app.ImagemEnviadaLabel.Layout.Row = 2;
            app.ImagemEnviadaLabel.Layout.Column = [2 4];
            app.ImagemEnviadaLabel.Text = 'Imagem Enviada';

            % Create ImagemRecebidaLabel
            app.ImagemRecebidaLabel = uilabel(app.GridLayout11);
            app.ImagemRecebidaLabel.HorizontalAlignment = 'center';
            app.ImagemRecebidaLabel.FontSize = 18;
            app.ImagemRecebidaLabel.FontWeight = 'bold';
            app.ImagemRecebidaLabel.Layout.Row = 8;
            app.ImagemRecebidaLabel.Layout.Column = [2 4];
            app.ImagemRecebidaLabel.Text = 'Imagem Recebida';

            % Create error_img_rx
            app.error_img_rx = uipanel(app.GridLayout11);
            app.error_img_rx.Enable = 'off';
            app.error_img_rx.Visible = 'off';
            app.error_img_rx.Layout.Row = 1;
            app.error_img_rx.Layout.Column = [1 5];

            % Create GridLayout12_2
            app.GridLayout12_2 = uigridlayout(app.error_img_rx);
            app.GridLayout12_2.ColumnWidth = {'1x'};
            app.GridLayout12_2.RowHeight = {'1x'};
            app.GridLayout12_2.BackgroundColor = [1 0 0];

            % Create ERROLabel_2
            app.ERROLabel_2 = uilabel(app.GridLayout12_2);
            app.ERROLabel_2.HorizontalAlignment = 'center';
            app.ERROLabel_2.FontSize = 18;
            app.ERROLabel_2.FontWeight = 'bold';
            app.ERROLabel_2.FontColor = [0.149 0.149 0.149];
            app.ERROLabel_2.Layout.Row = 1;
            app.ERROLabel_2.Layout.Column = 1;
            app.ERROLabel_2.Text = 'ERRO';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = simuladorComunicacoesDigitais_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end