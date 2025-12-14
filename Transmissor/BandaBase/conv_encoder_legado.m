function [output] = conv_encoder_legado(binseq, g1, g2)
% Uso geral: Codificar os bits com código convolucional para adicionar
% robustez ao sistema. Esta versão foi feita por mim. Deixei-a aqui como
% código legado, pois agora utilizo a função nativa do MATLAB para maior
% robustez
    arguments
        binseq (1,:) {mustBeNumeric, mustBeMember(binseq, [0, 1])}
        g1 (1,:) char = '11011'
        g2 (1,:) char = '10101'
    end

    if ~isequal(size(g2, 2), size(g1, 2))
        error('Os geradores g1 e g2 devem ter o mesmo comprimento.');
    end
    
    g1 = g1 - '0';
    g2 = g2 - '0';
    
    [num_seqs, seq_len] = size(binseq);
    memo_size = size(g1, 2) - 1;
    
    % Pré-alocação de Memória
    output_len = (seq_len + memo_size) * 2;
    output = zeros(num_seqs, output_len);
    
    % Seletores lógicos
    g1_taps = logical(g1(2:end));
    g2_taps = logical(g2(2:end));

    % Memo state refere-se ao estado de cada flip-flop
    memo_state = zeros(1, memo_size);
    idx = 1;
    for i = 1:seq_len
        current_bit = binseq(1, i); 
        
        operand1 = memo_state(g1_taps);
        operand2 = memo_state(g2_taps);

        % Multiplicação direta (g1(1) é 0 ou 1, current_bit é 0 ou 1)
        b1in = g1(1) * current_bit;
        b2in = g2(1) * current_bit;

        b1 = mod(sum(operand1) + b1in, 2);
        b2 = mod(sum(operand2) + b2in, 2);

        % Preenche a matriz
        output(1, idx:idx+1) = [b1, b2]; 
        idx = idx + 2;
        
        % Atualiza estado (o seu memo_size-1 é g1,2-2)
        memo_state = [current_bit, memo_state(1:memo_size-1)];
    end
    
    % Loop de Flushing (Terminação - zerar os FFs)
    for i = 1:memo_size
        operand1 = memo_state(g1_taps);
        operand2 = memo_state(g2_taps);
        
        b1 = mod(sum(operand1), 2);
        b2 = mod(sum(operand2), 2);
        
        output(1, idx:idx+1) = [b1, b2]; % Preenche o resto da linha
        idx = idx + 2;
        
        memo_state = [0, memo_state(1:memo_size-1)]; 
    end
end