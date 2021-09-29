%MDL_PHANTOMX Create model of PhantomX pincher manipulator
%
% MDL_PHANTOMX is a script that creates the workspace variable px which
% describes the kinematic characteristics of a PhantomX Pincher Robot, a 4
% joint hobby class  manipulator by Trossen Robotics.
%
% Also define the workspace vectors:
%   qz         zero joint angle configuration
%
% Notes::
% - Uses standard DH conventions.
% - Tool centrepoint is middle of the fingertips.
% - All translational units in mm.
%
% Reference::
%
% - http://www.trossenrobotics.com/productdocs/assemblyguides/phantomx-basic-robot-arm.html

% MODEL: Trossen Robotics, PhantomX Pincher, 4DOF, standard_DH


% Copyright (C) 1993-2017, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com
%Criar os links
links = [
    Revolute('d', 40, 'alpha', -pi/2)
    Revolute('a', -105, 'alpha', pi, 'offset', pi/2)
    Revolute('a', -105)
    Revolute('a', -105)
];

%Criar o robô
px = SerialLink(links, 'name', 'PhantomX', 'manufacturer', 'Trossen Robotics', 'plotopt', {'tilesize', 50});

%Criar as poses
%o primeiro parâmetro é de rotação sobre a primeira junta
%o segundo parâmetro é de rotação sobre a segunda junta
%o terceiro parâmetro é de rotacao sobre a terceira junta
%o quarto parâmetro é de rotacao sobre a quarta junta
qz = [0 0 0 0];
qr = [pi pi/2 -pi/2 0];
qs = [0 0 -pi/2 0];
qn = [pi pi/2 0 pi/4];

%Rodar o ultimo link para ficar de acordo com o robô.
px.tool = trotz(-pi/2) * trotx(pi/2);

%mostrar qz
px.plot(qz)

%Criar animações
qzr = jtraj(qz,qr,50);
qzs = jtraj(qz,qs,50);
qzn = jtraj(qz,qn,50);
qsr = jtraj(qs,qr,50);

%Mostrar animação do qz para o qr
px.plot(qzr)

%Criar GUI para mexer no robô a partir da pose qz
px.teach(qz);

%mostrar os parâmetros DH
px

%ir buscar a transformação homogênea que representa a pose
T = px.fkine(qs)


%fazer o ikine e calcular o tempo da sua funcao
%a função ikine dá-nos os valores que equivalem à posição das juntas do
%robô, podendo ou não ser iguais aos valores definidos quando o robô é
%criado.
px.ikine(T, 'mask', [1 1 1 1 0 0])

%a função tic e toc serve para saber o intervalo de tempo que dura para que
%o matlab faça um determinado calculo.
tic; px.ikine(T, 'mask', [1 1 1 1 0 0]); toc