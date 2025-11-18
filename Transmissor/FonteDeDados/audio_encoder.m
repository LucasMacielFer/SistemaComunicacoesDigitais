function data = audio_encoder(filename, time)
% Função responsável por gerar a sequência de bits referente a um sinal de
% áudio. O sinal será recuperado de um arquivo de áudio no caminho 
% "filename".

% O sinal de áudio discretizado é segmentado em blocos de 20 ms. O retorno
% da função é uma matriz em que cada linha é um bloco de 20 ms, com
% amplitudes convertidas para binário.
arguments (Input)
    filename (1,:) char
    time (1,1) double
end
    % nSamplesPerRow: 44100 Hz * 0,02 s = 882 amostras
    % nFrames: time/0,02 = time*50 = numero de blocos de 20 ms
    nSamplesPerRow = 882;
    nFrames = 50*time;

    [audioData, ~] = audioread(filename); 
    audioData = reshape(audioData, nSamplesPerRow, nFrames).';
    data = reshape((dec2bin(audioData, 16) - '0').',16*nSamplesPerRow, []).';
end