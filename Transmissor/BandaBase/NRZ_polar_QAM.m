function [t, I_waveform, Q_waveform] = NRZ_polar_QAM(data, N)
% Função utilizada para gerar ondas quadradas para posterior multiplicação
% com as portadoras I e Q
arguments (Input)
    data    (:,:) double
    N       {mustBeMember(N, [4, 8, 16])}   % Níveis NRZ
end
    
    

end