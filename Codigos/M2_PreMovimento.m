function [Gesto,Modo] = M2_PreMovimento(MatrizInicial,T,Vmin,Hmin,Z)
    % Calcula a velocidade a uma "Taxa" de f quadros comparando se a 
    % velocidade é maior que "Vmin" e se a altura "Hmin" já foi atingida. 
    % Quando ambas as condições forem atendidas, Gesto = MatrizInicial(:,:)
    % e Modo == 2.
    
    % Definição das variaveis usadas na função:
    Gesto = []; %Informações do gesto
    V = []; % Velocidades em y dos RB
    H = []; % Alturas em y dos RB
    Teste1 = []; % Testa as velocidades
    Teste2 = []; %Testas as alturas
    MI = MatrizInicial(:,2:10); % Contém apenas os dados de x, y e z 

    % Calcula as velocidades em y dos RB de MatrizInicial de T em T valores
    % e guarda as alturas em y.
    for LMI = 0:T:size(MI,1)
        for CMI = 1:size(Z,2)
            if LMI > 0
                V(LMI/T,CMI) = (MI(LMI,Z(CMI)) - MI(LMI-(T-1),Z(CMI)))/T;
                H(LMI/T,CMI) = MI(LMI,Z(CMI));
            end
        end
    end

    % Verifica se o gesto começou
    for C = 1:size(Z,2)
        Teste1(:,C) = abs(V(:,C)) > Vmin;
        Teste2(:,C) = abs(H(:,C)) > Hmin;
    end

    %Se qualquer um for verdadeiro, então o gesto começou, caso contraio, 
    % não está gravando
    if (sum(Teste1(:,2) == 1) == 2 && sum(Teste2(:,2) == 1) == 2) 
        fprintf('-Começou o gesto com o braço esquerdo.\n');
        Gesto = MatrizInicial(:,:);
        Modo = 2;
    elseif (sum(Teste1(:,3) == 1) == 2 && sum(Teste2(:,3) == 1) == 2)
        fprintf('-Começou o gesto com o braço Direito.\n');
        Gesto = MatrizInicial(:,:);
        Modo = 2;
    else
        %fprintf('-O gesto ainda não foi iniciado.\n');
        Modo = 1;
    end
end