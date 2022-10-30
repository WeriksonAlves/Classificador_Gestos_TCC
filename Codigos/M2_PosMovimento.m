function [Resposta,Gesto_Executado,Modo,GestoPCA,Minimo_Coluna] = M2_PosMovimento(MatrizFinal,BasePCA)
    % A função recebe "MatrizFinal" e faz a centralização dos dados pela 
    % média das coordenadas. Em seguida, faz a analise das componentes 
    % principais. Depois a função compara "GestoPCA" com o banco de dados, 
    % classificando o gesto, ao encontrar  menor a distancia entre o gesto
    % executado e a base de dados. Ao final, retorna "Modo == 4" e 
    % "Resposta", sendo esta uma string.

    % Definição das variaveis usadas na função:
    DadosCentralizados = []; % Matriz com os dados centralizados
    Classe = ["A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N"];

    % Faz a centralização pela média das coordenadas
    for CMF = 1:6 %Percorre as colunas de MatrizFinal
        if CMF <= 3
            DadosCentralizados(:,CMF) = MatrizFinal(:,CMF+3) - MatrizFinal(:,CMF);
        else
            DadosCentralizados(:,CMF) = MatrizFinal(:,CMF+3) - MatrizFinal(:,CMF-3);
        end
    end

    % Faz a PCA do movimento: [coeff,score,latent,tsquared,explained,mu]
    [GestoPCA,~,~,~,~,~] = pca(DadosCentralizados,'Algorithm','svd','NumComponents',3);

    % Calcula o mínimo valor das linhas a partir das comparações entre o
    % gesto executado e o gesto que esta na base de dados, em seguida
    % procura o menor valor de Minimo_Linha e determina o gesto executado.
    Minimo_Linha = inf*ones(14,1);
    Minimo_Coluna = inf;
    for LBPCA = 1:size(BasePCA,1) % Percorre todas as Linhas de BasePCA
        for CBPCA = 1:size(BasePCA,2) % Percorre todas as Colunas de BasePCA
            if BasePCA{LBPCA,CBPCA} ~= ' '                
                Distancia = [norm(BasePCA{LBPCA,CBPCA}(:,1)-GestoPCA(:,1))+norm(BasePCA{LBPCA,CBPCA}(:,2)-GestoPCA(:,2))+norm(BasePCA{LBPCA,CBPCA}(:,3)-GestoPCA(:,3))];
                if Distancia < Minimo_Linha(LBPCA)
                    Minimo_Linha(LBPCA) = Distancia;
                    if Minimo_Linha(LBPCA) < Minimo_Coluna
                        Minimo_Coluna = Minimo_Linha(LBPCA);
                        Gesto_Executado = LBPCA;
                    end
                end
            end
        end
    end

    % Se Minimo_Linha for meor que o limiar, o gesto é classificado, e caso
    % contrario é inconclusivo.
    if Minimo_Coluna < 1.5
        Resposta = Classe(Gesto_Executado);
        fprintf('-O gesto foi classificado como: %s.\n', Resposta);
        Modo = 4;
    else
        Resposta = "Z";
        fprintf('-O gesto foi classificado como: Z.\n')
        Modo = 4;
    end
end
