% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoTiro/tree/main

function graficarTodo(t, tol, y_exacta, xi_exacta, s_exacta, s_vector, F, Fp, y_metodos, z_metodos, N)
    colors = ["#0072BD", "#D95319", "#EDB120", "#7E2F8E"];
    
    % Figure 1: Soluciones
    figure;
    hold on;
    plot(t, y_exacta, 'k-', 'LineWidth', 1.5);
    for m = 1:4
        plot(t, y_metodos(1, :, m), 'Color', colors(m), 'LineWidth', 1);
    end
    hold off;
    title('Soluciones numéricas vs excata');
    xlabel('Tiempo t');
    ylabel('y');
    legend({'Solución exacta', 'Método E. Explícito', 'Método R. Trap. Explícita', 'Método E. Implícito', 'Método R. Trap.'}, 'Location', 'best');
    grid on;

    % Figure 2: y errores
    figure;
    hold on;
    for m = 1:4
        semilogy(t, abs(y_exacta-y_metodos(1, :, m)), 'Color', colors(m));
        yline(abs(y_exacta(1, N+1)-y_metodos(1, N+1, m)), '--');
    end
    set(gca, 'YScale', 'log');
    hold off;
    title('Error entre la sol. exacta y numérica');
    xlabel('Tiempo t');
    ylabel('Error');
    legend({'Método E. Explícito', '', 'Método R. Trap. Explícita', '', 'Método E. Implícito', '', 'Método R. Trap.', ''}, 'Location', 'best');
    grid off;

    % Figure 3: z errores
    figure;
    hold on;
    for m = 1:4
        semilogy(t, abs(xi_exacta-z_metodos(1, :, m)), 'Color', colors(m));
        yline(abs(xi_exacta(1, N+1)-z_metodos(1, N+1, m)), '--');
    end
    set(gca, 'YScale', 'log');
    hold off;
    title('Error entre la sol. al PVI xi exacta y cada método');
    xlabel('Tiempo t');
    ylabel('Error');
    legend({'Método E. Explícito', '', 'Método R. Trap. Explícita', '', 'Método E. Implícito', '', 'Método R. Trap.', ''}, 'Location', 'best');
    grid off;
    
    % Figure 4: Funciones de tiro
    figure;
        hold on;
        for m=1:4
            s = rmmissing(s_vector(1, :, m));
            xline(s(end), 'r--');
            FF = rmmissing(F(1, :, m));
            [ss, ids] = sort(s);
            FF = FF(ids);
            plot(ss, FF, 'Color', colors(m));
        end
        xline(s_exacta, 'g--');
        hold off;
        title('Función de tiro para cada método');
        xlabel('s');
        ylabel('F(s)')
        legend({'', 'Método E. Explícito', '', 'Método R. Trap. Explícita', '', 'Método E. Implícito', '', 'Método R. Trap.', 's exacto'}, 'Location', 'best');
        grid on;

    % Figure 5: |F/Fp|
    figure;
    subplot(2, 1, 1);
    hold on;
    for m = 1:4
        s = rmmissing(s_vector(1, :, m));
        xline(s(end), 'r--');
        FF = rmmissing(F(1, :, m));
        FFp = rmmissing(Fp(1, :, m));
        [ss, ids] = sort(s);
        FF = FF(ids);
        FFp = FFp(ids);
        plot(ss, abs(FF./FFp), 'Color', colors(m));   
    end
    xline(s_exacta, 'g--');
    %yline(tol, '--');
    hold off;
    title('|F/Fp| vs. s para cada método');
    legend({'','Método E. Explícito', '', 'Método R. Trap. Explícita', '', 'Método E. Implícito', '', 'Método R. Trap.', 's exacto'}, 'Location', 'best');
    xlabel('s');
    ylabel("|F(s)/F'(s)|");
    grid on;

    subplot(2, 1, 2);
    hold on;
    for m = 1:4
        s = rmmissing(s_vector(1, :, m));
        FF = rmmissing(F(1, :, m));
        FFp = rmmissing(Fp(1, :, m));
        plot(1:length(s), abs(FF./FFp), 'Color', colors(m));
    end
    yline(tol, 'r--')
    hold off;
    title('|F/Fp| vs. iteraciones para cada método');
    legend({'Método E. Explícito', 'Método R. Trap. Explícita', 'Método E. Implícito',  'Método R. Trap.', 'TOL'}, 'Location', 'best');
    xlabel('Número de iteraciones');
    ylabel("|F(s)/F'(s)|");
    grid on;
end