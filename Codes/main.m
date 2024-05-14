












%% Parte 1: 
% Estabelecer a Cominicação e carregar os dados

% Limpa o workspace, command window e fecha as janelas
clear; clc; close all;

% Procura o diretorio com todos os arquivos relacionados ao projeto
PastaAtual = pwd;
PastaRaiz = 'TCC__Classificador_de_Gestos';
cd(PastaAtual(1:(strfind(PastaAtual,PastaRaiz)+numel(PastaRaiz)-1)))
addpath(genpath(pwd))

% Cria o objeto OptiTrack e inicializa a conexão
OPT = OptiTrack;
OPT.Initialize;%('10.0.0.115','Multicast');

%==========================================================================
%% Parte 2: 
% Obter os dados do OptiTrack em tempo real e verificar se os 
% gatilhos foram ativados

% Cria as matrizes de analises do gesto
VetorPosicao = zeros(1,10);
MatrizInicial = zeros(3,10);

% Definição das variaveis usadas nas funções:
T = 12;            % [frames] Periodo de medição.
Vmin = 0.001;      % [m/frame] V mínimo para iniciar a gravação.
Hmin = 0.95;       % [m] H mínimo para iniciar o movimento.
Z = [3 6 9];       % Coluna Z para os corpos rígidos
LAI = 24;          % Linha da matriz inicial
Contador = 1;      % Quantidades de frames do gesto 
FrameAnterior = 1; % Frame anterior ao atual
Modo = 0;          % Modo inicial de operação
Coluna = 1;        % Coluna do vetor de respostas
Linha = 1;         % Linha do vetor de resposta
NTeste = 1;        % Numero de classificações realizados atÃ© o momento

% Itens da rotina de treino
Tarefa = "Validar";
% Tarefa = "Treinar";
%Tarefa = "Construir";
Gabarito = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N'];
VetorResp =['Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y' 'Y'];
Vezes = 5;        % Quantas ciclos serão realizados
TreinaGesto = 14;  % Qual gesto está sendo realizado
n=Vezes*14;       % Numero total de classificações a serem realizados

% Cria o gabarito para validação
for L99 = 1:Vezes
    Seq = randperm(14,14);
    C99 = 1;
    for C98 = Seq 
        GabStirng(L99,C99) = Gabarito(C98);
        GabNum(L99,C99) = C98;
        C99 = C99 + 1;
    end
end
GabNum
GabStirng

V_Minimo_Coluna = [];
% Carrega a base de dados, composta por dados de PCA.
load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_BasePCA.mat");

%% Parte 3
Ok = input('Pode começar?')
pause(3)
while true
    %if toc(Freq) < 1/240
    % Obtem as informações atuais dos corpos rígidos
    RB = OPT.RigidBody;

    %Informações do frame atual
    FrameAtual = RB.FrameIndex;

    %Se o frame atual for diferente do anterior, então obtem as 
    % informações do corpo rígido
    if FrameAtual > FrameAnterior
        %Adiciona o frame atual em StartMove(Line_StartMove,1)
        VetorPosicao(1,1) = Contador;

        %Percorre cada RB e coleta os dados de cada um
        for nRB = 1:numel(RB)           
            %Se  RB(nRB).Name == "H", salve as informações em 
            % VetorPosicao(1,2:4)
            if RB(nRB).Name == "H"
                % Informa se a cabeça está sendo rastreada
                %fprintf('\n- %s, Tracking Status: %d\n',RB(nRB).Name,RB(nRB).isTracked);
            
                if RB(nRB).isTracked == 1
                    VetorPosicao(1,2:4) = [RB(nRB).Position']./1000;
                else
                    VetorPosicao(1,2:4) = MatrizInicial(size(MatrizInicial,1),2:4);
                end

            %Se  RB(nRB).Name == "L", salve as informações em 
            % VetorPosicao(1,5:7)
            elseif RB(nRB).Name == "L"
                % Informa se o braço esquerdo está sendo rastreado
                %fprintf('\n- %s, Tracking Status: %d\n',RB(nRB).Name,RB(nRB).isTracked);

                if RB(nRB).isTracked == 1
                    VetorPosicao(1,5:7) = [RB(nRB).Position']./1000;
                else
                    VetorPosicao(1,5:7) = MatrizInicial(size(MatrizInicial,1),5:7);
                end

            %Se  RB(nRB).Name == "R", salve as informações em 
            % VetorPosicao(1,8:10)
            elseif RB(nRB).Name == "R"
                % Informa se o braço direito está sendo rastreado
                %fprintf('\n- %s, Tracking Status: %d\n',RB(nRB).Name,RB(nRB).isTracked);

                if RB(nRB).isTracked == 1
                    VetorPosicao(1,8:10) = [RB(nRB).Position']./1000;
                else
                    VetorPosicao(1,8:10) = MatrizInicial(size(MatrizInicial,1),8:10);
                end
            end
        end
        
        % Parte 4
        % Notifica a permissão para o inicio de um gestos.
        if Modo == 0
            fprintf('\n-Iniciando simulação: Execute um gesto para ser classificado.\n');
            Modo = 1;

        % Se Modo == 1, Concatena VetorPosicao em Matriz inicial, verifica
        % se Matriz inicial tem (LAI+1) linhas e deleta a primeira, para em
        % seguida testar se o gesto começou.
        elseif Modo == 1            
            %Matriz com as informações rastreadas
            MatrizInicial = [[MatrizInicial]; [VetorPosicao]];

            %Se MatrizInicial tem (LAI+1) linhas, delete a linha 1.
            if size(MatrizInicial,1) == LAI + 1
                MatrizInicial(1,:) = [];
                
                %Verifica se os gatilhos de velocidade e altura foram 
                % acionados
                [Acao,Modo] = M2_PreMovimento(MatrizInicial,T,Vmin,Hmin,Z);
            end

        % Se Modo == 2, Concatena a VetorPosicao em Gesto, e testa se nas 
        % ultimas (LAI+1) linhaso gesto foi encerrado.
        elseif Modo == 2
            %Matriz com as informações rastreadas
            Acao = [[Acao]; [VetorPosicao]];
            
            %Verifica se os gatilhos de velocidade e altura foram 
            % desacionados por meio das Ãºltimas 48 linhas.
            LAF = (size(Acao,1)-LAI+1):size(Acao,1); 
            [MatrizFinal,Modo] = M2_Movimento(Acao,LAF,T,Hmin,Z);

        % Se Modo == 3, faz a centralização, normalização e calcula a PCA
        % do gesto, em seguida compara com a base de dados e o classifica.
        elseif Modo == 3            
            % Centraliza, normaliza, calcula a PCA e classifica o gesto.
            [Resposta,Classe,Modo,GestoPCA,Minimo_Coluna] = M2_PosMovimento(MatrizFinal(:,2:10),BasePCA);
            V_Minimo_Coluna = [V_Minimo_Coluna Minimo_Coluna];
            
        % Parte 6
        % Se Modo == 4, verifica se o gesto foi classificado corretamente.
        elseif Modo == 4
            %Operação de treino do sistem: Se tiver classificado
            %corretamente, o PCA será armazenado na base de dados.
            if Tarefa == "Validar"
                VetorResp(Linha,Coluna) = Resposta;
                if GabStirng(Linha,Coluna)==VetorResp(Linha,Coluna)
                    fprintf('-A classificação do gesto foi correta.\n');
                else
                    fprintf('-A classificação do gesto foi incorreta.\n');
                end

                % Percorre GabString
                Coluna = Coluna + 1;
                NTeste = NTeste +1;
                if Coluna > 14
                    Coluna = 1;
                    Linha = Linha +1
                end
                
                % Parada
                if NTeste > n
                    Comparacao = [GabStirng;VetorResp]
                    save("Tempo_Real_Metodo_2\M2_Validacao_ff_1","Comparacao")
                    MC = M2_MatrizdeConfusao(Comparacao)
                    saveas(gcf,"Tempo_Real_Metodo_2\M2_Validacao_ff_1.png")
                    break
                end  
            
            elseif Tarefa == "Treinar"
                VetorResp(Linha,Coluna) = Resposta;
                if GabStirng(Linha,Coluna)==VetorResp(Linha,Coluna)
                    fprintf('-A classificação do gesto foi correta.\n');
                    % Procura o ultimo elemento daquela linha
                    for Tamanho = 1:size(BasePCA,2)
                        if size(BasePCA{Classe,Tamanho},2)~=0
                            Amostra = Tamanho + 1;
                        end
                    end
                    Amostra
                    % Salva ele no final da linha
                    BasePCA{Classe,Amostra} = GestoPCA;
                    save("Tempo_Real_Metodo_2\M2_BasePCA", "BasePCA")

                else
                    fprintf('-A classificação do gesto foi incorreta.\n');
                end

                % Percorre GabString
                Coluna = Coluna + 1;
                NTeste = NTeste +1;
                if Coluna > 14
                    Coluna = 1;
                    Linha = Linha +1
                end
                
                % Parada
                if NTeste > n
                    BasePCA
                    Comparacao = [GabStirng;VetorResp]
                    save("Tempo_Real_Metodo_2\M2_Simulacao_11","Comparacao")
                    MC = M2_MatrizdeConfusao(Comparacao)
                    saveas(gcf,"Tempo_Real_Metodo_2\M2_Simulacao_11.png")
                    break
                end

            elseif Tarefa == "Construir"
                NovaBasePCA{Linha,Coluna} = GestoPCA;

                Coluna = Coluna + 1
                NTeste = NTeste +1;
                if Coluna > 5
                    fprintf('-Iniciando proxima seção.\n');
                    Coluna = 1
                    Linha = Linha +1
                end
                
                % Parada
                if NTeste > n
                    save("Tempo_Real_Metodo_2\M2_BasePCA1_0", "NovaBasePCA")
                    break
                end  

            end
            t1 = tic;
            while toc(t1) < 1.5
            end
            Modo = 0;
        end

        %Salva o FrameAtual em Frame_Anterior
        FrameAnterior = FrameAtual;
        %Atualiza o frame atual da simulação
        Contador = Contador + 1;
    end
end