function [t, I_coeffs, I_waveform] = NRZ_polar_BPSK(data)
% Uso geral: Gerar símbolos e o sinal NRZ em banda base para BPSK.
arguments (Input)
    data    (1,:) double
end
    spb = 200;          % Amostras por Bit (Fixo para o sistema)
    FS_SIM = 2000000;   % Frequencia de simulação

    sz = size(data);
    Len_total = spb*sz(2);
    
    % Pré-alocação onda retangular
    I_waveform = zeros(sz(1), Len_total);

    % Vetor tempo
    T_total = (spb*sz(2)) / FS_SIM;
    t = linspace(0, T_total, Len_total);
    
    % Geração da onda retangular
    for j=1:sz(2)
        if data(1, j) == 1
            I_waveform(1, (j-1)*spb + 1:j*spb) = ones(1, spb);
        else
            I_waveform(1, (j-1)*spb + 1:j*spb) = -1* ones(1, spb);
        end
    end

    % Geração dos símbolos (apenas componente I - real)
    I_coeffs = data * 2 - 1;
end