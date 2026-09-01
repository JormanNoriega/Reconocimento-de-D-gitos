clc;
clear;
close all;

%% 1. CARGAR DATOS DESDE JSON

entrada = double(jsondecode(fileread('entradas.json')))';
salida  = double(jsondecode(fileread('salidas.json')))';

%% 2. VERIFICAR DIMENSIONES

disp('==========================================');
disp('DATOS DE ENTRADA');
disp('==========================================');

disp(entrada);
fprintf('Dimensiones de entrada: %d x %d\n', ...
    size(entrada,1), size(entrada,2));

disp('==========================================');
disp('DATOS DE SALIDA');
disp('==========================================');

disp(salida);
fprintf('Dimensiones de salida: %d x %d\n', ...
    size(salida,1), size(salida,2));

if ~isequal(size(entrada), [20 10])
    error('La entrada debe ser de 20 x 10.');
end

if ~isequal(size(salida), [10 10])
    error('La salida debe ser de 10 x 10.');
end

%% 3. CREAR RED NEURONAL

red = newff( ...
    [zeros(20,1) ones(20,1)], ...
    [10 10], ...
    {'logsig' 'purelin'}, ...
    'trainlm');

red.trainParam.epochs = 10000;
red.trainParam.goal = 1e-6;
red.trainParam.show = 100;

%% 4. ENTRENAMIENTO

disp('==========================================');
disp('INICIANDO ENTRENAMIENTO');
disp('==========================================');

[red, tr] = train(red, entrada, salida);

disp('ENTRENAMIENTO FINALIZADO');

%% 5. EVALUACION DE LOS PATRONES ORIGINALES

resultado = red(entrada);

[~, reconocidos] = max(resultado);
reconocidos = reconocidos - 1;

errorFinal = perform(red, salida, resultado);

disp('==========================================');
disp('RESULTADOS');
disp('==========================================');

disp('Digitos reconocidos:');
disp(reconocidos);

fprintf('Error final: %.10f\n', errorFinal);

%% 6. COMPARACION

disp('==========================================');
disp('COMPARACION');
disp('==========================================');

correctos = 0;

for i = 1:10

    esperado = i - 1;
    reconocido = reconocidos(i);

    if esperado == reconocido
        estado = 'CORRECTO';
        correctos = correctos + 1;
    else
        estado = 'INCORRECTO';
    end

    fprintf( ...
        'Digito %d -> Esperado: %d | Reconocido: %d | %s\n', ...
        esperado, esperado, reconocido, estado);
end

porcentaje = correctos / 10 * 100;

fprintf('\nCorrectos: %d de 10\n', correctos);
fprintf('Porcentaje: %.2f%%\n', porcentaje);

%% 7. PRUEBAS DE ROBUSTEZ

disp('==========================================');
disp('PRUEBAS DE ROBUSTEZ');
disp('==========================================');

digitosPrueba = [0 4 8];
nivelesRuido = [1 2 3];

resultadosRuido = zeros(3,3);

for n = 1:length(nivelesRuido)

    bits = nivelesRuido(n);
    correctosRuido = 0;

    fprintf('\n--- %d BIT(S) ALTERADO(S) ---\n', bits);

    for d = 1:length(digitosPrueba)

        digito = digitosPrueba(d);

        patronOriginal = entrada(:, digito + 1);
        patronRuido = patronOriginal;

        posiciones = randperm(20, bits);

        for p = 1:bits
            patronRuido(posiciones(p)) = ...
                1 - patronRuido(posiciones(p));
        end

        resultadoRuido = red(patronRuido);

        [~, clase] = max(resultadoRuido);
        reconocidoRuido = clase - 1;

        if reconocidoRuido == digito
            estado = 'CORRECTO';
            correctosRuido = correctosRuido + 1;
        else
            estado = 'INCORRECTO';
        end

        fprintf( ...
            'Digito %d | Posiciones: ', digito);

        fprintf('%d ', posiciones);

        fprintf( ...
            '| Reconocido: %d | %s\n', ...
            reconocidoRuido, estado);

        disp('Matriz 5x4 con ruido:');

        matrizRuido = reshape(patronRuido, 4, 5)';
        disp(matrizRuido);

    end

    porcentajeRuido = ...
        correctosRuido / length(digitosPrueba) * 100;

    resultadosRuido(n,:) = ...
        [bits correctosRuido porcentajeRuido];

    fprintf( ...
        'Resultado: %d/%d correctos - %.2f%%\n', ...
        correctosRuido, ...
        length(digitosPrueba), ...
        porcentajeRuido);
end

%% 8. RESUMEN DE ROBUSTEZ

disp('==========================================');
disp('RESUMEN DE ROBUSTEZ');
disp('==========================================');

fprintf('Bits | Correctos | Porcentaje\n');
fprintf('-----------------------------\n');

for i = 1:3

    fprintf( ...
        '%4d | %9d | %.2f%%\n', ...
        resultadosRuido(i,1), ...
        resultadosRuido(i,2), ...
        resultadosRuido(i,3));

end

%% 9. PESOS Y BIAS

disp('==========================================');
disp('PESOS CAPA OCULTA');
disp('==========================================');

disp(red.IW{1,1});

disp('==========================================');
disp('PESOS CAPA DE SALIDA');
disp('==========================================');

disp(red.LW{2,1});

disp('==========================================');
disp('BIAS CAPA OCULTA');
disp('==========================================');

disp(red.b{1});

disp('==========================================');
disp('BIAS CAPA DE SALIDA');
disp('==========================================');

disp(red.b{2});

%% 10. GRAFICA DEL ENTRENAMIENTO

figure;
plotperform(tr);
title('Error de entrenamiento');
xlabel('Epocas');
ylabel('Error');
grid on;

%% 11. RESUMEN FINAL

disp('==========================================');
disp('RESUMEN FINAL');
disp('==========================================');

fprintf('Arquitectura: 20 - 10 - 10\n');
fprintf('Capa oculta: logsig\n');
fprintf('Capa salida: purelin\n');
fprintf('Entrenamiento: trainlm\n');
fprintf('Error final: %.10f\n', errorFinal);
fprintf('Reconocimiento: %.2f%%\n', porcentaje);

disp('==========================================');
disp('ENTRENAMIENTO Y PRUEBAS FINALIZADOS');
disp('==========================================');