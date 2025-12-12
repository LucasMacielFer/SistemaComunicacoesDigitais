function [decoded_bit_seq] = viterbi_legado(encoded_bit_seq, g1, g2)
    arguments (Input)
        encoded_bit_seq (1,:) {mustBeNumeric, mustBeMember(encoded_bit_seq, [0, 1])}
        g1 (1,:) char
        g2 (1,:) char
    end
    
    % --- 1. PREPARAÇÃO E VALIDAÇÃO ---
    if ~isequal(size(g2, 2), size(g1, 2))
        decoded_bit_seq = -1;
        return;
    end
    
    % Converters G1 e G2 para numérico (necessário para a lógica)
    g1_num = g1 - '0'; 
    g2_num = g2 - '0';
    
    n = size(g2,2); % Quantidade de flipflops + 1 (Constraint length)
    numStates = 2^(n-1);
    
    % --- 2. CRIAÇÃO DA TABELA DE ESTADOS (STATE TABLE) ---
    stateTable = zeros(numStates, 4); 
    
    for i = 0:(numStates - 1)
        % Obter estado binário atual (representa os flipflops D1, D2, ...)
        bin_vec = de2bi(i, n-1, 'left-msb'); 

        % Transição para entrada 0 (Input bit = 0)
        input_if0 = [0, bin_vec]; 
        output1 = mod(sum(input_if0(logical(g1_num))), 2);
        output2 = mod(sum(input_if0(logical(g2_num))), 2);
        output_if0_dec = output1 * 2 + output2; % Saída para 0 (Decimal)
        
        % Próximo estado (Shifts in 0)
        nextState0_dec = bi2de([0, bin_vec(1:n-2)], 'left-msb');

        % Transição para entrada 1 (Input bit = 1)
        input_if1 = [1, bin_vec]; 
        output1 = mod(sum(input_if1(logical(g1_num))), 2);
        output2 = mod(sum(input_if1(logical(g2_num))), 2);
        output_if1_dec = output1 * 2 + output2; % Saída para 1 (Decimal)
        
        % Próximo estado (Shifts in 1)
        nextState1_dec = bi2de([1, bin_vec(1:n-2)], 'left-msb');
        
        % Define a transição e a saída (NextState0, NextState1, Output0, Output1)
        stateTable(i + 1, :) = [nextState0_dec, nextState1_dec, output_if0_dec, output_if1_dec]; 
    end

    % --- 3. PRÉ-PROCESSAMENTO DOS SÍMBOLOS RECEBIDOS ---
    % Conversão do vetor de bits de entrada em símbolos decimais (0, 1, 2, 3)
    numSymbols = (length(encoded_bit_seq) / 2);
    encoded_bits_char = char(encoded_bit_seq + '0'); % Conversão necessária para bin2dec funcionar no loop
    receivedSymbols = zeros(1, numSymbols);
    for i = 1:numSymbols
        % Agrupa 2 bits e converte para decimal (0 a 3)
        receivedSymbols(i) = bin2dec(encoded_bits_char(2*i-1 : 2*i));
    end
    
    % --- 4. FASE 1: FORWARD PASS (Cálculo das Métricas) ---
    pathMetrics = inf(numStates, numSymbols + 1); 
    pathMemory = zeros(numStates, numSymbols);  
    pathMetrics(1, 1) = 0; % O caminho começa no estado 0 com métrica 0
    
    for k = 1:numSymbols 
        received_symbol_k = receivedSymbols(k);
        
        % Gerar vetor binário do símbolo recebido para cálculo da Distância de Hamming
        received_bin = dec2bin(received_symbol_k, 2) - '0'; % VETOR NUMÉRICO [0 1]
        
        for currentState = 0:(numStates - 1) 
            if pathMetrics(currentState + 1, k) == inf
                continue; 
            end
            
            % Transição para entrada 0
            nextState0 = stateTable(currentState + 1, 1);
            expectedOutput0 = stateTable(currentState + 1, 3);
            expected_bin0 = dec2bin(expectedOutput0, 2) - '0'; % VETOR NUMÉRICO [0 1]
            branchMetric0 = sum(abs(received_bin - expected_bin0)); % Distância de Hamming
            newPathMetric0 = pathMetrics(currentState + 1, k) + branchMetric0;
            
            if newPathMetric0 < pathMetrics(nextState0 + 1, k + 1)
                pathMetrics(nextState0 + 1, k + 1) = newPathMetric0;
                pathMemory(nextState0 + 1, k) = currentState;
            end
            
            % Transição para entrada 1
            nextState1 = stateTable(currentState + 1, 2);
            expectedOutput1 = stateTable(currentState + 1, 4);
            expected_bin1 = dec2bin(expectedOutput1, 2) - '0'; % VETOR NUMÉRICO [0 1]
            branchMetric1 = sum(abs(received_bin - expected_bin1));
            newPathMetric1 = pathMetrics(currentState + 1, k) + branchMetric1;
            
            if newPathMetric1 < pathMetrics(nextState1 + 1, k + 1)
                pathMetrics(nextState1 + 1, k + 1) = newPathMetric1;
                pathMemory(nextState1 + 1, k) = currentState;
            end
        end
    end

    % --- 5. FASE 2: TRACEBACK (Retorna Array Numérico) ---
    decoded_bit_seq = zeros(1, numSymbols); % Inicializa como array NUMÉRICO (0s e 1s)
    num_flush_bits = size(g1, 2) - 1; 
    
    % Encontra o estado final com a menor métrica de caminho
    lastState = 0; 
    
    for k = numSymbols:-1:1
        prevState = pathMemory(lastState + 1, k);
        
        % Verifica qual transição (entrada 0 ou 1) levou do prevState para o lastState
        if stateTable(prevState + 1, 1) == lastState % Se o próximo estado (com input 0) é o lastState
            decoded_bit_seq(k) = 0; % O bit decodificado é 0
        else
            decoded_bit_seq(k) = 1; % Deve ser o bit 1
        end
        
        lastState = prevState;
    end
    
    % Truncagem: Remove os bits de flush (terminação) do final
    decoded_bit_seq = decoded_bit_seq(1 : numSymbols - num_flush_bits);
end