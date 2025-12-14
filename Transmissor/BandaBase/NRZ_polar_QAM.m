function [t, I_coeffs, Q_coeffs, I_waveform, Q_waveform, padding_bits] = NRZ_polar_QAM(data, N)
% Uso geral: Gerar símbolos e sinais NRZ em banda base para QPSK e M-QAM.
    arguments (Input)
        data    (1,:) double
        N       {mustBeMember(N, [2, 4, 8, 16])}   % Coeficiente NRZ
    end
    
    SPB = 200;                      % Amostras por Bit (Fixo para o sistema)
    FS_SIM = 2e6;                   % Frequencia de simulação
    
    M = N^2;                        % Ordem da Modulação (16, 64, ou 256)
    k = log2(M);                    % Bits por Símbolo (4, 6, ou 8) <-- Variável correta para reshape
    N_half = log2(N);               % Bits por eixo (2, 3, ou 4) <-- Para o slicing I/Q
    V_levels = -(N-1) : 2 : (N-1);  % Níveis de tensão (Ex: [-3 -1 1 3])

    [~, num_bits_orig] = size(data);
    
    % Padding (caso não haja bits suficientes para fechar o último símbolo)
    resto = mod(num_bits_orig, k);
    padding_bits = 0;
    
    if resto > 0
        padding_bits = k - resto;
        padding = zeros(1, padding_bits);
        data = [data, padding];
    end
    
    num_bits = size(data, 2);
    num_simbolos = num_bits / k;
    simbolos_I_Q = zeros(1, num_simbolos); % Vetor que guarda os símbolos complexos
    
    bits_row = data(1, :); 
    
    % Agrupamento (Organiza em blocos de 'k' bits por linha)
    bits_mat = reshape(bits_row, k, []).'; 
        
    I_bits = bits_mat(:, 1:N_half);        % Slicing de 2, 3 ou 4 bits para I
    Q_bits = bits_mat(:, N_half+1:k);      % Os restantes bits para Q
    
    % Conversão Binário -> Decimal
    I_dec = bi2de(I_bits, 'left-msb');
    Q_dec = bi2de(Q_bits, 'left-msb');
    
    % Conversão Binário para Gray
    I_gray = bitxor(I_dec, bitshift(I_dec, -1));
    Q_gray = bitxor(Q_dec, bitshift(Q_dec, -1));
    
    % Mapeamento de Tensão (Lookup na tabela V_levels)
    V_I = V_levels(I_gray + 1); 
    V_Q = V_levels(Q_gray + 1);
    
    % Combinação (Símbolos Complexos)
    simbolos_I_Q = V_I + 1j * V_Q;
    
    % Geração da onda quadrada
    SPS = SPB * k;
    Es = (2/3) * (N^2 - 1);        
    norm_factor = sqrt(1 / double(Es));

    I_norm = real(simbolos_I_Q)*norm_factor;
    Q_norm = imag(simbolos_I_Q)*norm_factor;

    I_coeffs = I_norm;
    Q_coeffs = Q_norm;
    
    I_waveform = repelem(I_norm, 1, SPS);
    Q_waveform = repelem(Q_norm, 1, SPS);
    
    len_total = size(I_waveform, 2);
    T_total = (len_total - 1) / FS_SIM;
    t = linspace(0, T_total, len_total);
end