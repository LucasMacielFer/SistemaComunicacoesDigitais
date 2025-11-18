function audio_listen(filename)
% Função para ouvir um arquivo de áudio
arguments (Input)
    filename (1,:) char;
end
    [audioData, Fs] = audioread(filename); 
    sound(audioData, Fs);
end