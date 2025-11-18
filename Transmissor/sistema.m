addpath 'C:\Users\lucas\OneDrive\Documents\MATLAB\CD\TRABALHO\Transmissor\FonteDeDados'

fonteDeDadosApp = FonteDeDados();
waitfor(fonteDeDadosApp, 'doneFlag', true);
[TXdata, TXtype] = fonteDeDadosApp.getData();
delete(fonteDeDadosApp);