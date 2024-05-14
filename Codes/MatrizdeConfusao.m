function [MC] = M2_MatrizdeConfusao(Comparacao)
    VetorConhecido = string();
    VetorResposta = string();
    for linha = 1:size(Comparacao,1)
        for coluna = 1:size(Comparacao,2)
            if linha <= size(Comparacao,1)/2
                VetorConhecido(coluna+14*(linha-1)) = Comparacao(linha,coluna);
            elseif linha > size(Comparacao,1)/2
                VetorResposta(coluna+14*(linha-1)-14*size(Comparacao,1)/2) = Comparacao(linha,coluna);
            end
        end
    end
    MC = confusionchart(VetorConhecido,VetorResposta);
end