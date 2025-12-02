function [t, I_coeffs, I_waveform] = NRZ_polar_BPSK(data)
% Função utilizada para gerar ondas quadradas para posterior multiplicação
% com a portadora única
arguments (Input)
    data    (1,:) double
end
    spb = 200;
    sz = size(data);

    FS_SIM = 2000000;
    Len_total = spb*sz(2);
    
    I_waveform = zeros(sz(1), Len_total);

    T_total = (spb*sz(2)) / FS_SIM;
    t = linspace(0, T_total, Len_total);
    
    for j=1:sz(2)
        if data(1, j) == 1
            I_waveform(1, (j-1)*spb + 1:j*spb) = ones(1, spb);
        else
            I_waveform(1, (j-1)*spb + 1:j*spb) = -1* ones(1, spb);
        end
    end

    I_coeffs = data * 2 - 1;
end