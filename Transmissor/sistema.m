addpath 'C:\Users\lucas\OneDrive\Documents\MATLAB\CD\TRABALHO\Transmissor\FonteDeDados'
addpath 'C:\Users\lucas\OneDrive\Documents\MATLAB\CD\TRABALHO\Transmissor\BandaBase'
addpath 'C:\Users\lucas\OneDrive\Documents\MATLAB\CD\TRABALHO\Transmissor\Modulacao'

fonteDeDadosApp = FonteDeDados();
waitfor(fonteDeDadosApp, 'doneFlag', true);
[TXData, TXType] = fonteDeDadosApp.getData();
delete(fonteDeDadosApp);

TXSize = size(TXdata);
if TXSize(2) < 16
    TXSample = TXData(1,1:TXSize(2));
else
    TXSample = TXData(1,1:16);
end

bandaBaseApp = banda_base();
bandaBaseApp.setDemoData(TXSample);
waitfor(bandaBaseApp, 'done_flag', true);
[t, Iwave, Qwave] = bandaBaseApp.toModulation();
delete(bandaBaseApp);

Imod = modulate_cos(Iwave, t);
if ~isempty(Qwave)
    Qmod = modulate_sin(Qwave, t);
    mod = Imod + Qmod;
end

subplot(3,1,1);
plot(t, Imod);
title('In-phase Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
if ~isempty(Qwave)
    subplot(3,1,2);
    plot(t, Qmod);
    title('Quadrature Modulated Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    subplot(3,1,3);
    plot(t, mod);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Transmitted Modulated Signal');
end