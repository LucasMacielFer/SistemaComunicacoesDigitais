function [t, I_coeffs, Q_coeffs, I_waveform, Q_waveform, padding_bits] = NRZ_polar_QAM(data, N)
    % Função utilizada para gerar ondas quadradas para posterior multiplicação
    % com as portadoras I e Q
    arguments (Input)
        data    (:,:) double
        N       {mustBeMember(N, [4, 8, 16])}   % Coeficiente NRZ
    end
    
    % --- 1. CONFIGURAÇÃO DE TEMPO E ORDEM ---
    SPB = 15;                       % Amostras por Bit (Fixo para o sistema)
    RB_TOTAL = 1411200;             % Taxa de Bits Total (1.4112 Mbps)
    FS_SIM = RB_TOTAL * SPB;        % Frequência de Simulação (~21.168 MHz)
    
    M = N^2;                        % Ordem da Modulação (16, 64, ou 256)
    k = log2(M);                    % Bits por Símbolo (4, 6, ou 8) <-- Variável correta para reshape
    N_half = log2(N);               % Bits por eixo (2, 3, ou 4) <-- Para o slicing I/Q
    V_levels = -(N-1) : 2 : (N-1);  % Níveis de tensão (Ex: [-3 -1 1 3])

    [num_linhas, num_bits_orig] = size(data);
    
    % --- 2. PADDING (CORREÇÃO DE LÓGICA: Deve usar 'k' e não 'N') ---
    resto = mod(num_bits_orig, k);
    padding_bits = 0;
    
    if resto > 0
        padding_bits = k - resto;
        padding = zeros(num_linhas, padding_bits);
        data = [data, padding];
    end
    
    num_bits = size(data, 2);
    num_simbolos = num_bits / k;
    simbolos_I_Q = zeros(num_linhas, num_simbolos); % Vetor que guarda os símbolos complexos
    
    % --- 3. MAPEAMENTO DE NÍVEIS ---
    for i = 1:num_linhas
        % Agrupamento (Organiza em blocos de 'k' bits por linha)
        bits_row = data(i, :);
        % O reshape agora usa K (bits/símbolo) e garante o tamanho correto da linha 
        bits_mat = reshape(bits_row, k, []).'; 
        
        I_bits = bits_mat(:, 1:N_half);        % Slicing de 2, 3 ou 4 bits
        Q_bits = bits_mat(:, N_half+1:k);      % Os restantes k-k_half bits
        
        % Conversão Binário -> Decimal (Obtém o Índice Binário)
        I_dec = bi2de(I_bits, 'left-msb');
        Q_dec = bi2de(Q_bits, 'left-msb');
        
        % Conversão Binário para Gray (Minimiza erros)
        I_gray = bitxor(I_dec, bitshift(I_dec, -1));
        Q_gray = bitxor(Q_dec, bitshift(Q_dec, -1));
        
        % Mapeamento de Tensão (Lookup na tabela V_levels)
        V_I = V_levels(I_gray + 1); 
        V_Q = V_levels(Q_gray + 1);
        
        % 4E. Combinação (Símbolos Complexos)
        simbolos_I_Q(i, :) = V_I.' + 1j * V_Q.';
    end
    
    % --- 4. GERAÇÃO DA ONDA QUADRADA ---
    SPS = SPB * k; % Amostras por Símbolo = 15 * k
    
    I_coeffs = real(simbolos_I_Q);
    Q_coeffs = imag(simbolos_I_Q);

    I_waveform = repelem(real(simbolos_I_Q), 1, SPS);
    Q_waveform = repelem(imag(simbolos_I_Q), 1, SPS);
    
    len_total = size(I_waveform, 2);
    T_total = (len_total - 1) / FS_SIM;
    t = linspace(0, T_total, len_total);
end