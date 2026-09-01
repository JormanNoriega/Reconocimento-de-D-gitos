clc;
clear;

%% 1. CARGAR DATOS DESDE JSON

entrada = double(jsondecode(fileread('entradas.json')))';
salida  = double(jsondecode(fileread('salidas.json')))';

%% 2. VERIFICAR DATOS

disp('==========================================');
disp('DATOS DE ENTRADA');
disp('==========================================');

disp(entrada);
fprintf('Dimensiones: %d x %d\n', size(entrada,1), size(entrada,2));

disp('==========================================');
disp('DATOS DE SALIDA');
disp('==========================================');

disp(salida);
fprintf('Dimensiones: %d x %d\n', size(salida,1), size(salida,2));

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

%% 5. EVALUAR DIGITOS ORIGINALES

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

    fprintf('Digito %d -> Esperado: %d | Reconocido: %d | %s\n', ...
        esperado, esperado, reconocido, estado);
end

porcentaje = correctos / 10 * 100;

fprintf('\nCorrectos: %d de 10\n', correctos);
fprintf('Porcentaje: %.2f%%\n', porcentaje);

%% 7. PRUEBA CON 1 BIT ALTERADO

disp('==========================================');
disp('PRUEBA CON 1 BIT ALTERADO');
disp('==========================================');

% Digito 0
vector = entrada(:,1);
vector(5) = 1 - vector(5);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 0 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

% Digito 4
vector = entrada(:,5);
vector(12) = 1 - vector(12);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 4 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

% Digito 8
vector = entrada(:,9);
vector(5) = 1 - vector(5);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 8 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

%% 8. PRUEBA CON 2 BITS ALTERADOS

disp('==========================================');
disp('PRUEBA CON 2 BITS ALTERADOS');
disp('==========================================');

% Digito 0
vector = entrada(:,1);
vector(2) = 1 - vector(2);
vector(14) = 1 - vector(14);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 0 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

% Digito 4
vector = entrada(:,5);
vector(12) = 1 - vector(12);
vector(20) = 1 - vector(20);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 4 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

% Digito 8
vector = entrada(:,9);
vector(15) = 1 - vector(15);
vector(17) = 1 - vector(17);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 8 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

%% 9. PRUEBA CON 3 BITS ALTERADOS

disp('==========================================');
disp('PRUEBA CON 3 BITS ALTERADOS');
disp('==========================================');

% Digito 0
vector = entrada(:,1);
vector(11) = 1 - vector(11);
vector(15) = 1 - vector(15);
vector(20) = 1 - vector(20);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 0 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

% Digito 4
vector = entrada(:,5);
vector(1) = 1 - vector(1);
vector(12) = 1 - vector(12);
vector(19) = 1 - vector(19);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 4 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

% Digito 8
vector = entrada(:,9);
vector(3) = 1 - vector(3);
vector(9) = 1 - vector(9);
vector(17) = 1 - vector(17);

resultadoRuido = red(vector);
[~, clase] = max(resultadoRuido);
reconocido = clase - 1;

fprintf('Digito esperado: 8 | Reconocido: %d\n', reconocido);
disp('Vector alterado:');
disp(vector');

%% 10. PESOS Y BIAS

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

%% 11. GRAFICA DEL ENTRENAMIENTO

figure;
plotperform(tr);
title('Error de entrenamiento');
grid on;

%% 12. RESUMEN FINAL

disp('==========================================');
disp('RESUMEN FINAL');
disp('==========================================');

fprintf('Arquitectura: 20 - 10 - 10\n');
fprintf('Capa oculta: logsig\n');
fprintf('Capa de salida: purelin\n');
fprintf('Entrenamiento: trainlm\n');
fprintf('Error final: %.10f\n', errorFinal);
fprintf('Reconocimiento: %.2f%%\n', porcentaje);

disp('==========================================');
disp('ENTRENAMIENTO Y PRUEBAS FINALIZADOS');
disp('==========================================');
