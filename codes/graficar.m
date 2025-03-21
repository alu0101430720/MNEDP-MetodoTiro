% MIT License
% Copyright (c) 2025 Carlos Yanes Pérez
% https://github.com/alu0101430720/MNEDP-MetodoTiro/tree/main

function graficar(i, t, s, w0, wf, tol, nmax, y_exacta, s_exacta, errores_y, errores_z, s_vector, F, Fp, tiros)
    % Figure 1: Tiros y solucion
    leyendas_tiros = "Tiro " + string(1:i-1);
    figure;
    hold on;
    plot(t, y_exacta, 'k-', 'LineWidth', 1.5);
    for j = 1:i-1
        plot(t, tiros(1,:, j), '--', 'LineWidth', 1);
    end
    plot(t, tiros(1,:, i), 'g', 'LineWidth', 1.5);
    
    yline(w0, '--', 'LineWidth', 0.5);
    yline(wf, '--', 'LineWidth', 0.5);
    hold off;
    title(['Solución. Número de tiros ', num2str(i)]);
    xlabel('Tiempo t');
    ylabel('w(t)');
    legend(['Solución exacta', leyendas_tiros, 'Solución numérica'], 'Location', 'best');
    grid on;

    % Figure 2: Errores
    figure;
    hold on;
    for j = 1:i
        semilogy(t, abs(y_exacta-tiros(1,:, j)));
    end
    set(gca, 'YScale', 'log');
    hold off;
    title('Error entre la sol. exacta y cada tiro');
    xlabel('Tiempo t');
    ylabel('Error');
    leyendas_tiros = "Tiro " + string(1:i-1);
    legend([leyendas_tiros, 'Solución numérica'], 'Location', 'best');
    grid off;

    % Figure 3: Errores subplots
    figure;
    subplot(3,1,1);
    plot(t, errores_y);
    title('Subplot 1: Error de la sol en el último tiro');
            
    subplot(3,1,2);
    plot(t, errores_z);
    title('Subplot 2: Error de xi en el último tiro');
            
    subplot(3,1,3);
    plot(1:nmax, abs(s_exacta - s_vector));
    title('Subplot 3: Error de s');

    % Figure 4: Funcion de tiro
    s_vector = rmmissing(s_vector);
    F = rmmissing(F);
    [ss_vector, ids] = sort(s_vector); % Ordenar
    FF = F(ids); % Ordenar en funcion del orden de ss_vector
    figure;
    hold on;
    xline(s, 'r--');
    xline(s_exacta, 'g--');
    plot(ss_vector, FF);
    hold off;
    title('Función de tiro');
    xlabel('s');
    ylabel('F(s)');
    grid on;
    
    % Figure 5: |F/Fp|
    Fp = rmmissing(Fp);
    FFp = Fp(ids); % Ordenar en funcion del orden de ss_vector
    figure;
    subplot(2, 1, 1);
    hold on;
    xline(s, 'r--');
    xline(s_exacta, 'g--');
    plot(ss_vector, abs(FF./FFp));
    hold off;
    title("|F(s)/F'(s)| vs. s aprox.");
    xlabel('s');
    ylabel("|F(s)/F'(s)|");
    grid on;

    subplot(2, 1, 2);
    hold on;
    plot(1:length(s_vector), abs(F./Fp));
    yline(tol, 'r--');
    hold off;
    title("|F(s)/F'(s)| vs. iteraciones");
    xlabel('Iteraciones del método de tiro');
    ylabel("|F(s)/F'(s)|");
    grid on;
end