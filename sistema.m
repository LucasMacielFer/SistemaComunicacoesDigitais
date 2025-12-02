addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\FonteDeDados'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\BandaBase'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\Modulacao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\Demodulacao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\BandaBase'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\Reconstrucao'

TXBinData = [];
symbols = [];
[TXBinData, TXType, conv, pulse, N_levels, g1, g2] = TX_GUI();
[lins, cols] = size(TXBinData);

% Pipeline envio - canal - recepção
erroTotal = 0;
if(~isempty(TXBinData))
    for i=1:lins
        [t, TXWave] = TX(TXBinData(i,:), N_levels, pulse, conv, g1, g2);
        disp("Linha " + i + " enviada...");
        [RXBinData, symbols_temp] = RX(t, TXWave, N_levels, pulse, conv, g1, g2);
        RXBinData = RXBinData(1:length(TXBinData));
        erroTotal = erroTotal + sum(abs(RXBinData-TXBinData(i,:)));
        symbols = [symbols symbols_temp];
    end
end

switch N_levels
    case 1
        levels = [-1 1];
        levels_I = levels;
        levels_Q = [0 0];
    case 4
        levels = [-1 -1/3 1/3 1];
        [levels_I, levels_Q] = meshgrid(levels, levels);
    case 8
        levels = [-1 -5/7 -3/7 -1/7 1/7 3/7 5/7 1];
        [levels_I, levels_Q] = meshgrid(levels, levels);
    case 16
        levels = [-1 -13/15 -11/15 -9/15 -7/15 -5/15 -3/15 -1/15 1/15 3/15 5/15 7/15 9/15 11/15 13/15 1];
        [levels_I, levels_Q] = meshgrid(levels, levels);
    otherwise, levels = [];
end

scatter(real(symbols), imag(symbols), 'filled');
grid on;
title('Diagrama de Constelação Recebido');    
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
axis equal;
hold on;
scatter(levels_I, levels_Q, 'r', 'x', 'LineWidth',2);