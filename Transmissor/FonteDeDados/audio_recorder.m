function rawData = audio_recorder(time)
% Função responsável por gravar o áudio para transmissão. A gravação se dá
% num ficheiro de nome "temp.wav"
arguments (Input)
    time double;
end
        Fs = 44100;
        nBits = 16;
        nChannels = 1;
        basePath = fileparts(mfilename('fullpath'));
        filename = fullfile(basePath, 'srcs', 'temp.wav');

        recObj = audiorecorder(Fs, nBits, nChannels);
        recordblocking(recObj, time);
        audioData = getaudiodata(recObj,'int16');
        size(audioData)
        rawData = audioData;
        audiowrite(filename, rawData, Fs);
end