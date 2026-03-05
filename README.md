# SistemaComunicacoesDigitais

Este repositório contém o desenvolvimento de um simulador completo de sistemas de comunicações digitais
ponto-a-ponto, implementado integralmente em MATLAB, apresentado como projeto final da disciplina de 
Comunicações Digitais no âmbito da Mobilidade Estudantil Internacional no Instituto Politécnico de Leiria.
O projeto foca-se na modelação, simulação e análise de desempenho de cadeias de transmissão, avaliando o 
impacto de codificações de canal e esquemas de modulação em ambientes ruidosos.

## 🛠️ Tecnologias e Metodologia

- Ambiente de Simulação: Implementação e validação integral em MATLAB.

- Processamento de Sinal: Análise no domínio da frequência utilizando FFT para conversão de sinais e IFFT para modulação OFDM.

- Codificação de Canal: Implementação de um codificador convolucional (taxa 1/2) e um decodificador de Viterbi para correção de erros.

- Modulações: Suporte para esquemas BPSK, QPSK e M-QAM (16/64/256), operando em portadora única ou múltiplas subportadoras.


## ✨ Funcionalidades Principais

- Modelação de Canal Realista: Simulação de interferências críticas como AWGN, Ruído de Fase, Desvio Doppler e Desvanecimento Multipercurso.

- Recuperação de Sinal: Implementação de algoritmos de sincronização de portadora e equalização para mitigar distorções de canal.

- Análise de Desempenho: Geração automática de diagramas de constelação e curvas de BER (Bit Error Rate) e EVM (Error Vector Magnitude).

- Interface Interativa: Aplicação gráfica (UI) para configuração dinâmica de parâmetros de transmissão e visualização de resultados em tempo real.
