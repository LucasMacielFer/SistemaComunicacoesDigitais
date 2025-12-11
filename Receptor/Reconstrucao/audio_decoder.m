function [path, rawAudioReceived] = audio_decoder(bits, audioDuration, Fs)
    arguments
        bits (:,:) {mustBeNumeric}
        audioDuration (1,1) uint16
        Fs (1,1) uint16
    end

    BITS_POR_AMOSTRA = 16;

    nFrames = 50 * double(audioDuration);    
    
    serializedBits = bits.';
    serializedBits = serializedBits(:).';

    bitMatrix = reshape(serializedBits, 16, []);
    bitMatrix = bitMatrix.';

    charMatrix = char(bitMatrix+'0');
    decimalData = bin2dec(charMatrix).';
    decimalData = typecast(uint16(decimalData), 'int16');
    rawAudioReceived = double(decimalData)/2^15;
    rawAudioReceived = rawAudioReceived(:);
    rawAudioReceived(rawAudioReceived > 1) = 1;
    rawAudioReceived(rawAudioReceived < -1) = -1;

    my_path = which('audio_decoder');
    [dir, ~, ~] = fileparts(my_path);
    path = fullfile(dir, 'tmpAudio.wav');

    audiowrite(path, rawAudioReceived, Fs);
end
