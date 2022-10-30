% Limpa o workspace, command window e fecha as janelas
clear; clc; close all;

Simulacao1 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_1.mat");
Simulacao2 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_2.mat");
Simulacao3 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_3.mat");
Simulacao4 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_4.mat");
Simulacao5 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_5.mat");
Simulacao6 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_6.mat");
Simulacao7 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_7.mat");
Simulacao8 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_8.mat");
Simulacao9 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_9.mat");
Simulacao10 = load("C:\Users\robot\OneDrive\Área de Trabalho\Werikson\Tempo_Real_Metodo_2\M2_Simulacao_10.mat");


Comp = [Simulacao1.Comparacao(1:5,:);
        Simulacao2.Comparacao(1:5,:); 
        Simulacao3.Comparacao(1:5,:);
        Simulacao4.Comparacao(1:5,:);
        Simulacao5.Comparacao(1:5,:);
        Simulacao6.Comparacao(1:5,:);
        Simulacao7.Comparacao(1:5,:);
        Simulacao8.Comparacao(1:5,:);
        Simulacao9.Comparacao(1:5,:);
        Simulacao10.Comparacao(1:5,:);

        Simulacao1.Comparacao(6:10,:); 
        Simulacao2.Comparacao(6:10,:);
        Simulacao3.Comparacao(6:10,:); 
        Simulacao4.Comparacao(6:10,:);
        Simulacao5.Comparacao(6:10,:);
        Simulacao6.Comparacao(6:10,:);
        Simulacao7.Comparacao(6:10,:); 
        Simulacao8.Comparacao(6:10,:);
        Simulacao9.Comparacao(6:10,:);
        Simulacao10.Comparacao(6:10,:);
        ]
save("Tempo_Real_Metodo_2\M2_Validacao_Total_10","Comp")
MC = M2_MatrizdeConfusao(Comp)
saveas(gcf,"Tempo_Real_Metodo_2\M2_Validacao_Total_10.png")

