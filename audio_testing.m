path = "C:\Users\Lucas-local\Documents\MATLAB\SistemaComunicacoesDigitais\Transmissor\FonteDeDados\srcs\default.wav";
audioMetaData = audioinfo(path);

% Pega os 5 primeiros segundos do audio...
if(audioMetaData.Duration > 5)
    audioDuration = 5;
else
    audioDuration = floor(audioMetaData.Duration);
end

audioSampleRate = audioMetaData.SampleRate;

[rawAudio, ~] = audioread(path);
bits = audio_encoder(path, audioDuration, audioSampleRate);
[~, rawReceived] = audio_decoder(bits, audioDuration, audioSampleRate);

subplot(2,1,1)
plot(rawAudio)
subplot(2,1,2)
plot(rawReceived)
