function [MatrizFinal,Modo] = M2_Movimento(Gesto,LAF,T,Hmin,Y)
    % Calcula a velocidade a uma "Taxa" de f quadros comparando se a 
    % velocidade é menor que "Vmin" e se a altura "Hmin" não foi superada. 
    % Quando ambas as condições forem atendidas, Matrizfinal = Gesto(:,:)
    % e Modo == 3.
    
    % Definição das variaveis usadas na função:
    MatrizFinal = []; %Informações da matriz final
    V = []; % Velocidades em y dos RB
    H = []; % Alturas em y dos RB
    Teste2 = []; %Testas as alturas
    G = Gesto(LAF,2:10); % Contém apenas os dados de x, y e z 

    % Calcula as velocidades em y dos RB de Gesto de T em T valores e
    % guarda as alturas em y.
    for LG = 0:T:size(G,1)
        for CG = 1:size(Y,2)
            if LG > 0
                V(LG/T,CG) = (G(LG,Y(CG)) - G(LG-(T-1),Y(CG)))/T;
                H(LG/T,CG) = G(LG,Y(CG));
            end
        end
    end

    % Verifica se o gesto terminou
    for C = 1:size(Y,2)
        Teste2(:,C) = abs(H(:,C)) < Hmin;
    end

    %Se qualquer um for verdadeiro, então o gesto terminou, caso contraio, 
    % ainda continua gravando.
    if sum(Teste2(:,2) == 1) == 2 && sum(Teste2(:,3) == 1) == 2  
        fprintf('-O gesto foi concluído.\n');
        MatrizFinal = Gesto(:,:);
        Modo = 3;
    else
        %fprintf('-O gesto ainda não foi concluido.\n');
        Modo = 2;
    end
end