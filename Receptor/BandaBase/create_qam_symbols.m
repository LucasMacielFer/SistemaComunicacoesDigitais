function symbols = create_qam_symbols(data_bits, N_levels)
    % RECRIA A LÓGICA DO SEU NRZ_polar_QAM PARA SÍMBOLOS PUROS
    
    M = N_levels^2;
    k = log2(M);
    N_half = log2(N_levels);
    V_levels = -(N_levels-1) : 2 : (N_levels-1);
    
    % Assegura o padding (embora os bits do header já devam estar alinhados)
    num_bits_orig = length(data_bits);
    resto = mod(num_bits_orig, k);
    if resto > 0
        data_bits = [data_bits, zeros(1, k - resto)];
    end
    
    bits_mat = reshape(data_bits, k, []).'; 
    
    I_bits = bits_mat(:, 1:N_half);        
    Q_bits = bits_mat(:, N_half+1:k);      
    
    I_dec = bi2de(I_bits, 'left-msb');
    Q_dec = bi2de(Q_bits, 'left-msb');
    
    % Conversão Binário para Gray
    I_gray = bitxor(I_dec, bitshift(I_dec, -1));
    Q_gray = bitxor(Q_dec, bitshift(Q_dec, -1));
    
    % Mapeamento de Tensão (Lookup na tabela V_levels)
    V_I = V_levels(I_gray + 1); 
    V_Q = V_levels(Q_gray + 1);
    
    symbols_raw = V_I + 1j * V_Q;
    
    % Normalização de Energia
    Es = (2/3) * (M - 1);        
    norm_factor = sqrt(1 / double(Es));
    
    symbols = symbols_raw * norm_factor;
    symbols = symbols(:); % Garante vetor coluna
end