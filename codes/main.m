% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoTiro/tree/main

%=========================================================================%

% Esta es la funcion principal del programa. En este fichero se pediran los
% parametros al usuario, para, posteriormente llamar al metodo de tiro
% implementado y obtener los resultados pertinentes.

%=========================================================================%

function main
    % Obtener parametros del usuario
    N = input('Número de pasos N: ');
    disp(' ');
    disp('MÉTODOS NUMÉRICOS:');
    disp('1. Método de Euler explícito');
    disp('2. Regla trapezoidal explícita');
    disp('3. Método de Euler implícito');
    disp('4. Regla trapezoidal (implícita)');
    disp('5. Graficar todos (revidar convergencia previamente)');
    disp(' ');

    nmet = input('Seleccione opción (1, 2, 3, 4 o 5): ');

    disp(' ');
    disp('¿Desea generar gráficos?');
    disp('1. Sí');
    disp('2. No');
    graf_opc = input('Seleccione opción (1 o 2): ');
    graf = (graf_opc == 1);
    disp(' ');
    
    % Parametros del problema
    params = struct(); % Permite crear listas estructuradas
    params.s0 = 0.1;
    params.t0 = 1;
    params.tf = 2;
    params.alpha = 1/2;
    params.beta = 2/3;
    params.nmax = 20;
    params.tol = 1e-6;
    params.z0 = [0; 1];
    
    params.N = N;
    params.tau = (params.tf - params.t0)/N;
    params.t = linspace(params.t0, params.tf, N+1);
    
    % Llamada al metodo de tiro
    MetodoDeTiro(nmet, params, graf);

    % Para varios N podemos comentar los input anteriores y la llamada al
    % metodo de tiro y emplear el bucle siguiente.

    %for k=2:6
    %    N=2^k;
    %    params.N = N;
    %    params.tau = (params.tf - params.t0)/N;
    %    params.t = linspace(params.t0, params.tf, N+1);
    %    nmet=5;
    %    graf=false;
    %    MetodoDeTiro(nmet, params, graf);
    %end
end