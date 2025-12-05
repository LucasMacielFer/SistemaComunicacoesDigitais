addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\FonteDeDados'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\BandaBase'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\Modulacao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\Demodulacao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\BandaBase'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\Reconstrucao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Receptor\Equalizacao'
addpath 'C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Canal'



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
        RXBinData = RXBinData(1:cols);
        erroTotal = erroTotal + sum(abs(RXBinData-TXBinData(i,:)));
        symbols = [symbols symbols_temp];
    end
end

Es = (2/3) * (N_levels^2 - 1);      
norm_factor = sqrt(1 / double(Es));
integers = -(double(N_levels-1)) : 2 : (double(N_levels-1));

if N_levels == 1
    levels = [-1 1];
    levels_I = levels;
    levels_Q = [0 0];
else
    levels = integers*norm_factor;
    [levels_I, levels_Q] = meshgrid(levels, levels);
end

scatter(real(symbols), imag(symbols), 'filled');
grid on;
title('Diagrama de Constelação Recebido');    
xlabel('In-Phase (I)');
ylabel('Quadrature (Q)');
axis equal;
hold on;
scatter(levels_I, levels_Q, 'r', 'x', 'LineWidth',1);