close all
clear
clc

% Search root directory
PastaAtual = pwd;
PastaRaiz = 'Werikson';
cd(PastaAtual(1:(strfind(PastaAtual,PastaRaiz)+numel(PastaRaiz)-1)))
addpath(genpath(pwd))

figure(1)
axis equal
view(45,45)
axis([-3 3 -3 3 0 3])
grid on

% Styling the 
lighting phong;
material shiny;
colormap winter;
lightangle(-45,30)
%%
A = ArDrone;
A.mCADplot('outdoor',1);
%%
% Create OptiTrack object and initialize
OPT = OptiTrack;
OPT.Initialize;

tc = tic;
tp = tic;
while true
    if toc(tc) > A.pPar.Ts
       tc = tic;
       
       
        %  Get current rigid body information from optitrack
        rb = OPT.RigidBody;
            
        A = getOptData(rb,A);
    end

    if toc(tp) > 5*A.pPar.Ts
        tp = tic;

        A.mCADplot('outdoor',1);
        drawnow
    end
end
