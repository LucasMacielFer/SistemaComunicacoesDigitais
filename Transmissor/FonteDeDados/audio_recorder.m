function [rawData, uri] = audio_recorder(time)
% Uso geral: Grava um áudio com "time" segundos e guarda-o num ficheiro,
% cuja localização é retornada.
arguments (Input)
    time double;
end
    Fs = 44100;
    nBits = 16;
    nChannels = 1;

    basePath = fileparts(mfilename('fullpath'));
    filename = fullfile(basePath, 'srcs', 'temp.wav');
    uri = filename;
    
    recObj = audiorecorder(Fs, nBits, nChannels);
    recordblocking(recObj, time);
    audioData = getaudiodata(recObj,'int16');
    size(audioData)
    rawData = audioData;
    audiowrite(filename, rawData, Fs);
end