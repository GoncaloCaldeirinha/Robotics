%MDL_COBRA600 Create model of Adept Cobra 600 manipulator
%
% MDL_COBRA600 is a script that creates the workspace variable c600 which
% describes the kinematic characteristics of the 4-axis Adept Cobra 600
% SCARA manipulator using standard DH conventions. 
%
% Also define the workspace vectors:
%   qz         zero joint angle configuration
%
% Notes::
% - SI units are used.
%
% See also SerialRevolute, mdl_puma560akb, mdl_stanford.

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

% MODEL: Adept, Cobra600, 4DOF, standard_DH

% hardstop limits included
%Criar os links
links = [
    Revolute('d', 0.387, 'a', 0.325, 'qlim', [-50 50]*pi/180);
    Revolute('a', 0.275, 'alpha', pi, 'qlim', [-88 88]*pi/180);
    Prismatic('qlim', [0 0.210]);
    Revolute()
];

%Criar o robô
c600 = SerialLink(links, 'name', 'Cobra600', 'manufacturer', 'Adept', 'plotopt', {'workspace', [0 0.8 -0.6 0.6 0 0.4]} );

%Criar as poses
%o primeiro parâmetro é de rotação para a primeira junta
%o segundo parâmetro é de rotação para a segunda junta
%o terceiro parâmetro é de translação para a ultima junta (que seria a pega)
%o ultimo parâmetro é de rotação para a ultima junta
qz = [0 0 0 0];
qr = [pi/2 -pi/2 0 0];
qs = [0 -pi/2 0 0];
qn = [0 0 0.2 0];

%mostrar qz
c600.plot(qz)

%Criar animações
qzr = jtraj(qz,qr,50);
qzs = jtraj(qz,qs,50);
qzn = jtraj(qz,qn,50);
qrn = jtraj(qr,qn,50);

%Mostrar animação do qz para o qr
c600.plot(qzr)

%Criar GUI para mexer no robô a partir da pose qz
c600.teach(qz);


%mostrar os parâmetros DH
c600

%ir buscar a transformação homogênea que representa a pose
T = c600.fkine(qs)


%a função ikine
c600.ikine(T, 'mask', [1 1 1 1 0 0])

%a função tic e toc serve para saber o intervalo de tempo que dura para que
%o matlab faça um determinado calculo.
tic; c600.ikine(T, 'mask', [1 1 1 1 0 0]); toc

