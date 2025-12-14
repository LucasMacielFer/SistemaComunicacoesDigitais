function audio_listen(filename)
% Uso geral: Escutar um ficheiro de áudio
arguments (Input)
    filename (1,:) char;
end
    [audioData, Fs] = audioread(filename); 
    sound(audioData, Fs);
end