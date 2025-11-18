function [t, I_coeffs, I_waveform] = NRZ_polar_BPSK(data)
% Função utilizada para gerar ondas quadradas para posterior multiplicação
% com a portadora única
arguments (Input)
    data    (1,:) double
end

    % Fc estará explicada no relatório, mas basicamente: Se fosse um sistema
    % real, o pior caso seria a transmissão de áudio. Como ele é amostrado em
    % 44,1kHz, a 16 bits, teriamos um débito binário de 705600 bps. Como
    % aplicamos codificação convolucional, isto sobe para cerca de 1,4112
    % MBaud. Assim, a largura de banda no pior caso (BPSK) seria de 1,4112 MHz.
    
    % O número de samples por bit é de 15, para termos mais de 10 pontos por
    % ciclo de portadora, sem skyrocketar o custo de simulação
    
    % Assim, a frequência da simulação será correspondente ao débito
    % binário no pior caso, multiplicado pelo número de amostras por bit
    spb = 15;
    sz = size(data);

    FS_SIM = 1411200 * spb;
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