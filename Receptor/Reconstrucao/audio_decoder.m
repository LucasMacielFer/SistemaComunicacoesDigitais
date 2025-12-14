function [path, rawAudioReceived] = audio_decoder(bits, audioDuration, Fs)
% Uso geral: Reconstrói um áudio a partir de uma matriz binária
    arguments
        bits (:,:) {mustBeNumeric}
        audioDuration (1,1) uint16
        Fs (1,1) uint16
    end

    BITS_POR_AMOSTRA = 16;

    % Frames de 20 ms
    nFrames = 50 * double(audioDuration);    
    
    % Serialização dos bits
    serializedBits = bits.';
    serializedBits = serializedBits(:).';

    % Matriz m x 16, isto é, coluna em que cada linha é um número de 16 bits
    bitMatrix = reshape(serializedBits, 16, []);
    bitMatrix = bitMatrix.';

    charMatrix = char(bitMatrix+'0');
    decimalData = bin2dec(charMatrix).';
    decimalData = typecast(uint16(decimalData), 'int16');

    % Normalização [-1 1]
    rawAudioReceived = double(decimalData)/2^15;
    rawAudioReceived = rawAudioReceived(:);
    rawAudioReceived(rawAudioReceived > 1) = 1;
    rawAudioReceived(rawAudioReceived < -1) = -1;

    % Salvamento do ficheiro
    my_path = which('audio_decoder');
    [dir, ~, ~] = fileparts(my_path);
    path = fullfile(dir, 'tmpAudio.wav');

    audiowrite(path, rawAudioReceived, Fs);
end
