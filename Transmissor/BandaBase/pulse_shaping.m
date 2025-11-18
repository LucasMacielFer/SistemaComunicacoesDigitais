function [tx_signal, filter_coeffs, filter_delay] = pulse_shaping(symbols, sps, rolloff, span)
% Função utilizada para aplicar um filtro RRC para modelar o pulso NRZ
% codificado.    
arguments
    symbols (:,:) double % Aceita complexo (QAM) ou real (BPSK)
    sps (1,1) {mustBeInteger, mustBePositive} = 4
    rolloff (1,1) {mustBeNumeric, mustBeGreaterThanOrEqual(rolloff, 0), mustBeLessThanOrEqual(rolloff, 1)} = 0.25
    span (1,1) {mustBeInteger, mustBePositive, mustBeNumeric} = 10
end
    filter_coeffs = rcosdesign(rolloff, span, sps, 'sqrt');
    
    % 2. Aplicar Upsampling e Filtragem (Pulse Shaping)
    % A função 'upfirdn' (Upsample, FIR, Downsample) é a forma mais
    % eficiente do MATLAB. Ela insere zeros (trem de impulsos) e
    % aplica a convolução numa só passada.
    % Nota: O terceiro argumento '1' é o fator de downsample (não queremos, então é 1).
    tx_signal = upfirdn(symbols, filter_coeffs, sps, 1);
    filter_delay = (length(filter_coeffs) - 1) / 2;
end