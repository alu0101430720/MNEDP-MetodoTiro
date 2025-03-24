% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoTiro/tree/main

%=========================================================================%

% Esta es la implementacion del metodo de tiro

%=========================================================================%

function MetodoDeTiro(nmet, params, graf)
    % Parametro
    N = params.N;
    s = params.s0;
    tau = params.tau;
    t = params.t;
    w0 = params.alpha;
    wf = params.beta;
    nmax = params.nmax;
    tol = params.tol;
    z0 = params.z0;
    s0 = params.s0;
    
    % Definimos las soluciones exactas
    [y_exacta, xi_exacta, s_exacta] = SolucionExacta(t);
    
    % Inicializamos vectores para almacenar datos
    y = zeros(2, N+1);
    z = zeros(2, N+1);
    z(:, 1) = z0;
    
    % Inicializamos matrices/vectores para guardar los tiros,
    % la funcion de tiro (aprox.), su derivada (aprox.) y los s (aprox.)
    tiros = zeros(1, N+1, nmax);
    F = NaN(1, nmax);
    Fp = NaN(1, nmax);
    s_vector = NaN(1, nmax);
    
    if nmet ~= 5
        % Implementacion de un unico metodo
        i = 0;
        tic;
        while i < nmax
            % Actualizacion de variables
            i = i + 1;
            s_vector(i) = s;
            y0 = [w0; s];
            y(:, 1) = y0;
            
            % Llamada al metodo
            [y, z] = runMetodosNumericos(nmet, t, y, z, tau, N);
            
            % Almacenar funcion de tiro, derivada y el tiro.
            F(i) = y(1, N+1) - wf;
            Fp(i) = z(1, N+1);
            tiros(1, :, i) = y(1, :);
            
            % Verificacion de convergencia
            D = F(i)/Fp(i);
            if abs(D) <= tol
                % En caso de convergencia del metodo
                toc;
                sol = y(1, :);
                sol_z = z(1, :);
                errores_y = abs(sol - y_exacta);
                errores_z = abs(sol_z - xi_exacta);
                errores_s = abs(s_vector - s_exacta);
                if graf
                    % Graficar
                    graficar(i, t, s, w0, wf, tol, nmax, y_exacta, s_exacta, errores_y, errores_z, s_vector, F, Fp, tiros);
                end
                
                % Imprimir resultados (comentar para evitar salidas por pantalla)
                printResultados(nmet, errores_y, errores_z, errores_s);

                % Guardar datos en fichero (comentar para evitar escritura)
                guardarFichero(nmet, N, params.s0, max(errores_y), max(errores_z), min(errores_s));
                return;
            else
                s = s - D;
            end
        end
        fprintf('Error de convergencia, elija otro s0.');
    else
        % Comparar todos los metodos
        [y_metodos, z_metodos, F, Fp, s_vector] = compararTodos(w0, wf, z0, t, tau, N, nmax, tol, s0);
        
        % Graficar
        if graf
            graficarTodo(t, tol, y_exacta, xi_exacta, s_exacta, s_vector, F, Fp, y_metodos, z_metodos, N);
        end
        
        % Imprimir los resultados
        for m = 1:4
            errores_y = abs(y_exacta - y_metodos(1, :, m));
            errores_z = abs(xi_exacta - z_metodos(1, :, m));
            errores_s = abs(s_exacta - s_vector(1, :, m));

            % Imprimir por pantalla los datos (comentar para evitar salidas por pantalla)
            printResultados(m, errores_y, errores_z, errores_s);

            %Descomentar para almacenar datos en ficheros
                % Primera opcion, usar la funcion existente.

            %guardarFichero(m, N, params.s0, max(errores_y), max(errores_z), min(errores_s));
    
                % Segunda opcion, modificar la funcion de escritura para que
                % sea automatica.

            guardarFichero_siempre(m, N, params.s0, max(errores_y), max(errores_z), min(errores_s));
        end
    end
end

% Funciones auxiliares
function [y_exacta, xi_exacta, s_exacta] = SolucionExacta(t)
    % Solucion exacta para w
    sol = @(x) x./(1+x);
    y_exacta = sol(t);
    
    % Solucion exacta para xi
    solxi = @(x) (x.^2+2.*x.*log(x)-1)./(x+1).^2;
    xi_exacta = solxi(t);
    
    % s exacta s = w'(a)
    s_exacta = 1/4;
end

function printResultados(nmet, errores_y, errores_z, errores_s)
    fprintf('Método = %d\n', nmet);
    fprintf('Error máx. en y = %13.4e\n', max(errores_y));
    fprintf('Error máx. en z = %13.4e\n', max(errores_z));
    fprintf('Error mín. en s = %13.4e\n\n', min(errores_s));
end

function [y_metodos, z_metodos, F, Fp, s_vector] = compararTodos(w0, wf, z0, t, tau, N, nmax, tol, s0)
    y_metodos = zeros(2, N+1, 4);
    z_metodos = zeros(2, N+1, 4);
    F = NaN(1, nmax, 4);
    Fp = NaN(1, nmax, 4);
    s_vector = NaN(1, nmax, 4);
    
    for m = 1:4
        z_metodos(:, 1, m) = z0;
        s = s0;
        i = 0;
        while i < nmax
            i = i + 1;
            s_vector(1, i, m) = s;
            y0 = [w0; s];
            y_metodos(:, 1, m) = y0;
            
            [y_metodos(:, :, m), z_metodos(:, :, m)] = runMetodosNumericos(m, t, y_metodos(:, :, m), z_metodos(:, :, m), tau, N);
            
            F(1, i, m) = y_metodos(1, N+1, m) - wf;
            Fp(1, i, m) = z_metodos(1, N+1, m);
            
            D = F(1, i, m)/Fp(1, i, m);
            if abs(D) <= tol
                break;
            end
            s = s - D;
        end
        
        if i == nmax
            fprintf('El método %d no converge para el s0 dado.\n', m);
        end
    end
    return
end
