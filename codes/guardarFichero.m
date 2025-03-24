function guardarFichero(met, N, s, error_y, error_z, error_s)
    % Guardas los resultados
        % Resultados a almacenar
        resultados = [met, N, error_y, error_z, error_s]; 
        nombres_variables = {'Metodo', 'N', 'max_error_y', 'max_error_z', 'min_error_s'};
        s = string(s);
        % Nombre del archivo
        filename = sprintf('resultados_N%d_s%s.txt', N, s); 
        existe=exist(filename);
        if existe == 0
            fprintf('Se creará el fichero %s', filename);
            accion = 'w';
            % Abrir fichero
            fid = fopen(filename, accion);
            
            % Escribir nombres de las variables con ancho fijo para alinear las columnas
            fprintf(fid, '%-13s%-13s%-13s%-13s%-13s\n', nombres_variables{:});
            
            % Escribir los resultados
            fprintf(fid, '%-13d%-13d%-13.4e%-13.4e%-13.4e\n', resultados);
        elseif existe == 2
            fprintf('El fichero %s existe, elija una opción:\n', filename);
            disp('')
            disp('1) Sobreescribir información.')
            disp('2) Agregar información (por omisión).')
            disp('')
            res = input('Opción: ');
            if res == 1
                accion = 'w';
                % Abrir fichero
                fid = fopen(filename, accion);
                
                % Escribir nombres de las variables con ancho fijo para alinear las columnas
                fprintf(fid, '%-13s%-13s%-13s%-13s%-13s\n', nombres_variables{:});
            
                % Escribir los resultados
                fprintf(fid, '%-13d%-13d%-13.4e%-13.4e%-13.4e\n', resultados);
            else
               accion = 'a';
               % Abrir fichero
               fid = fopen(filename, accion);
                
               % Escribir los resultados
               fprintf(fid, '%-13d%-13d%-13.4e%-13.4e%-13.4e\n', resultados); 
            end
            
        end
         
            
            % Cerrar el archivo
            fclose(fid);
        
        
        disp(['Resultados guardados en el archivo: ', filename]);
end 