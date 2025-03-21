% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoTiro/tree/main

function [y, z] = runMetodosNumericos(nmet, t, y, z, tau, N)
    switch nmet
        case 1
            [y, z] = euler_exp(t, y, z, tau, N);
        case 2
            [y, z] = regla_trap_exp(t, y, z, tau, N);
        case 3
            [y, z] = euler_imp(t, y, z, tau, N);
        case 4
            [y, z] = regla_trap_imp(t, y, z, tau, N);
    end
end

% Metodos numericos
function [y, z] = euler_exp(t, y, z, tau, N)
    for k = 0:N-1
        f1 = der(t(k+1), y(:, k+1));
        ytau = y(:, k+1) + tau * f1;
        y(:, k+2) = ytau;
    %end
    
    %for k = 0:N-1
        g1 = zder(t(k+1), z(:, k+1), y(:, k+1));
        ztau = z(:, k+1) + tau * g1;
        z(:, k+2) = ztau;
    end
end

function [y, z] = regla_trap_exp(t, y, z, tau, N)
    for k = 0:N-1
        f1 = der(t(k+1), y(:, k+1));
        Y1 = y(:, k+1) + tau*f1;
        f2 = der(t(k+2), Y1);
        ytau = y(:, k+1) + tau * (f1 + f2) / 2;
        y(:, k+2) = ytau;
    %end
    
    %for k = 0:N-1
        g1 = zder(t(k+1), z(:, k+1), y(:, k+1));
        Z1 = z(:, k+1) + tau*g1;
        g2 = zder(t(k+2), Z1, y(:, k+2));
        ztau = z(:, k+1) + tau * (g1 + g2) / 2;
        z(:, k+2) = ztau;
    end
end

function [y, z] = euler_imp(t, y, z, tau, N)
    % Parametros para Newton
    max_newton_iter = 20;
    newton_tol = 1e-6;
    
    % Obtener y
    for k = 0:N-1
        % Valor inicial para Newton
        y_newton = y(:, k+1);
        
        % Iteraciones de Newton
        delta = 1;
        i = 0;
        while norm(delta, inf) > newton_tol
            i = i + 1;
            f2 = der(t(k+2), y_newton);
            F = y_newton - y(:, k+1) - tau * f2;
            
            jacobiano = eye(2) - tau * [0, 1; -2*y_newton(2)/t(k+2), -2*y_newton(1)/t(k+2)];
            
            delta = jacobiano \ F;
            
            % Actualizacion de la sol. de Newton
            y_newton = y_newton - delta;
            
            if i > max_newton_iter
                break;
            end
        end
        y(:, k+2) = y_newton;
    %end
    
    % Obtener z. Para cada t fijo se resuelve un sistema lineal.
    %for k = 0:N-1
        A = [1, -tau; 2*tau*y(2, k+2)/t(k+2), 1+2*tau*y(1,k+2)/t(k+2)];
        z(:, k+2) = A \ z(:, k+1);
    end
end

function [y, z] = regla_trap_imp(t, y, z, tau, N)
    % Parametros de Newton
    max_newton_iter = 20;
    newton_tol = 1e-6;
    
    % Obtener y
    for k = 0:N-1
        % Valor inicial para Newton
        y_newton = y(:, k+1);

        f1 = der(t(k+1), y(:, k+1));
        
        % Iteraciones de Newton
        delta = 1;
        i = 0;
        while norm(delta, inf) > newton_tol
            i = i + 1;
            f2 = der(t(k+2), y_newton);
            explicita_y = y(:, k+1) + tau * f1 / 2;
            F = y_newton - explicita_y - tau * f2 / 2;

            jacobiano = eye(2) - tau * [0, 1/2; -y_newton(2)/t(k+2), -y_newton(1)/t(k+2)];

            delta = jacobiano \ F;
            
            % Actualizacion de sol. de Newton
            y_newton = y_newton - delta;
            
            if i > max_newton_iter
                break;
            end
        end
        y(:, k+2) = y_newton;
    %end
    
    % Obtener z. Para cada t fijo se resuelve un sistema lineal.
    %for k = 0:N-1
        g1 = zder(t(k+1), z(:, k+1), y(:, k+1));
        explicita_z = z(:, k+1) + tau * g1 / 2;
        A = [1, -tau/2; tau*y(2, k+2)/t(k+2), 1+tau*y(1,k+2)/t(k+2)];
        z(:, k+2) = A \ explicita_z;
    end
end