function [TXData, TXType, conv, pulse, N_levels, g1, g2] = TX_GUI()
% Função que cria a interface de usuário e retorna ao script principal as 
% definições do utilizador, bem como os dados inseridos codificados.
arguments(Output)
    TXData      % Matriz binária dos dados 
    TXType      % Tipo de dados
    conv        % Codificação convolucional (booleano)
    pulse       % Filtro RRC (booleano)
    N_levels    % Níveis NRZ polar
    g1          % polinômio 1 codificação convolucional
    g2          % polinômio 2 codificação convolucional
end
    fonteDeDadosApp = FonteDeDados();
    waitfor(fonteDeDadosApp, 'doneFlag', true);
    [TXData, TXType] = fonteDeDadosApp.getData();
    delete(fonteDeDadosApp);

    TXSize = size(TXData);
    if TXSize(2) < 16
        TXSample = TXData(1,1:TXSize(2));
    else
        TXSample = TXData(1,1:16);
    end

    bandaBaseApp = banda_base();
    bandaBaseApp.setDemoData(TXSample);
    waitfor(bandaBaseApp, 'done_flag', true);
    [t, Iwave, Qwave] = bandaBaseApp.toModulation();
    [conv, pulse, N_levels, g1, g2] = bandaBaseApp.getParams();
    delete(bandaBaseApp);

    Imod = modulate_cos(Iwave, t);
    if ~isempty(Qwave)
        Qmod = modulate_sin(Qwave, t);
        mod = Imod + Qmod;
    end

    % Criando o vetor para eixo x dos gráficos das ffts
    L = size(Imod);
    L = L(2);
    f_ax = (0:L-1)*(2e6/L); % f = (Fsimulação*indice_vetor)/Npontos
    
    f = figure;
    ax1 = subplot(3,2,1);
    plot(ax1, t, Imod);
    title('In-phase Modulated Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    ax2 = subplot(3,2,2);
    plot(ax2, f_ax, abs(fft(Imod)));
    title('In-phase modulated Signal FFT');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    if ~isempty(Qwave)
        ax3 = subplot(3,2,3);
        plot(ax3, t, Qmod);
        title('Quadrature Modulated Signal');
        xlabel('Time (s)');
        ylabel('Amplitude');
        ax4 = subplot(3,2,4);
        plot(ax4, f_ax, abs(fft(Imod)));
        title('Quadrature modulated Signal FFT');
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        ax5 = subplot(3,2,5);
        plot(ax5, t, mod);
        xlabel('Time (s)');
        ylabel('Amplitude');
        title('Transmitted Modulated Signal');
        ax6 = subplot(3,2,6);
        plot(ax6, f_ax, abs(fft(Imod)));
        title('Transmitted modulated Signal FFT');
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
    end
    uiwait(f);
end