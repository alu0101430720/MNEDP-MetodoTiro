function guardarFichero_siempre(met, N, s, error_y, error_z, error_s)
    % Guardas los resultados
       % Resultados a almacenar
       resultados = [met, N, error_y, error_z, error_s]; 
       nombres_variables = {'Metodo', 'N', 'max_error_y', 'max_error_z', 'min_error_s'};
       s = string(s);
       % Nombre del archivo
       filename = sprintf('resultados_N%d_s%s_2.txt', N, s); 
       existe=exist(filename);

       accion = 'a';
       % Abrir fichero
       fid = fopen(filename, accion);
                
       % Escribir nombres de las variables con ancho fijo para alinear las columnas
       if existe == 0
           fprintf(fid, '%-13s%-13s%-13s%-13s%-13s\n', nombres_variables{:});
       end 
       % Escribir los resultados
       fprintf(fid, '%-13d%-13d%-13.4e%-13.4e%-13.4e\n', resultados);
         
            
        % Cerrar el archivo
        fclose(fid);
        
        
        disp(['Resultados guardados en el archivo: ', filename]);
end 