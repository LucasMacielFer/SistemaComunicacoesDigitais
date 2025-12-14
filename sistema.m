path = which('sistema.m');
[dir, ~, ~] = fileparts(path);

addpath ([dir '\Transmissor'])
addpath ([dir '\Transmissor\FonteDeDados'])
addpath ([dir '\Transmissor\BandaBase'])
addpath ([dir '\Transmissor\Modulacao'])
addpath ([dir '\Receptor'])
addpath ([dir '\Receptor\Demodulacao'])
addpath ([dir '\Receptor\BandaBase'])
addpath ([dir '\Receptor\Reconstrucao'])
addpath ([dir '\Receptor\Equalizacao'])
addpath ([dir '\Canal'])

simuladorComunicacoesDigitais();