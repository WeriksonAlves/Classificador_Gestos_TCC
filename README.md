# Título: **Classificador de Gesto utilizando Distância Euclidiana**

**Trabalho de monografia do curso de Engenharia Elétrica, pela UFV**

Aplicações baseadas em reconhecimento de ações estão cada vez mais comuns no dia a dia. Isto porque possibilita ao usuário acionar equipamentos sem a necessidade de tocá-los e, além disso, pode ser realizado remotamente. Neste contexto, o objetivo deste trabalho é a criação de uma ferramenta de classificação de ações, pré-definidas, para o usuário em tempo real. 
    
Esta ferramenta adquire os dados das ações dos usuários e os categoriza em um conjunto de 14 classes. Os marcadores registrados pelo Sistema de Rastreamento OptiTrack foram representados por duas pulseiras e um crachá, a fim de tornar o processo de classificação mais fácil e dinâmico.

Estas informações são analisadas por um programa desenvolvido no software MatLab, no qual indica, ao final, a ação classificada. Primeiramente, para a análise destas informações, foi necessário realizar um pré-processamento dos dados de entrada, composto de uma centralização espacial dos dados rastreados dos marcadores.

Em seguida, para reduzir a dimensão dos dados, foi aplicada a técnica de Análise das Componentes Principais (PCA) sendo extraídas às três principais componentes do movimento mais relevantes. Por fim, estas informações foram utilizadas como entradas do classificador. 

Por sua simplicidade, utilizou-se o classificador por KNN, com k igual a 1, a qual se assemelha à Distância Euclidiana, o qual consiste na comparação da série de informações do conjunto de dados reduzidos da ação a ser classificada com as ações armazenadas na base de dados. Ao percorrer a base de dados, aquela em que se obter a menor diferença irá representar a classe da ação a ser classificada. A validação se deu de forma offline através do treinamento da ferramenta. Os resultados da matriz de confusão consolidaram a proposta. Ao final, conclui-se que o classificador obteve taxas de acerto superiores a 90\% para 11 das 14 classes, e superior a 74% para as demais classes. 

O principal benefício deste trabalho é formalizar um classificador simplista, de baixo custo computacional, que requer uma base de dados mínima e satisfatória para generalização das ações.

Palavras-chave: Reconhecimento de Ações; Robótica Interativa; PCA; OptiTrack; KNN; Distância Euclidiana.

## Informações de contato

Para obter mais informações, dúvidas ou sugestões de melhorias, entre em contato.
