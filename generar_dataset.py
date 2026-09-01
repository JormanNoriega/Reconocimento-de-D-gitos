import json


# ============================================================
# PATRONES DE LOS DIGITOS
# Cada digito se representa mediante una matriz 5x4
# ============================================================

PATTERNS = {

    0: [
        [0, 1, 1, 0],
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [0, 1, 1, 0]
    ],

    1: [
        [0, 0, 1, 0],
        [0, 1, 1, 0],
        [0, 0, 1, 0],
        [0, 0, 1, 0],
        [0, 1, 1, 1]
    ],

    2: [
        [1, 1, 1, 0],
        [0, 0, 0, 1],
        [0, 1, 1, 0],
        [1, 0, 0, 0],
        [1, 1, 1, 1]
    ],

    3: [
        [1, 1, 1, 0],
        [0, 0, 0, 1],
        [0, 1, 1, 0],
        [0, 0, 0, 1],
        [1, 1, 1, 0]
    ],

    4: [
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 1],
        [0, 0, 0, 1]
    ],

    5: [
        [1, 1, 1, 1],
        [1, 0, 0, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 1],
        [1, 1, 1, 0]
    ],

    6: [
        [0, 1, 1, 0],
        [1, 0, 0, 0],
        [1, 1, 1, 0],
        [1, 0, 0, 1],
        [0, 1, 1, 0]
    ],

    7: [
        [1, 1, 1, 1],
        [0, 0, 0, 1],
        [0, 0, 1, 0],
        [0, 1, 0, 0],
        [0, 1, 0, 0]
    ],

    8: [
        [0, 1, 1, 0],
        [1, 0, 0, 1],
        [0, 1, 1, 0],
        [1, 0, 0, 1],
        [0, 1, 1, 0]
    ],

    9: [
        [0, 1, 1, 0],
        [1, 0, 0, 1],
        [0, 1, 1, 1],
        [0, 0, 0, 1],
        [0, 1, 1, 0]
    ]
}


# ============================================================
# GENERAR ENTRADAS
# ============================================================
# Cada matriz 5x4 se convierte en un vector de 20 elementos.
#
# Orden:
# izquierda -> derecha
# arriba -> abajo
#
# Resultado:
# 10 vectores
# cada vector contiene 20 bits
# ============================================================

def generar_entradas():

    entradas = []

    for digito in range(10):

        vector = []

        for fila in range(5):

            for columna in range(4):

                vector.append(
                    PATTERNS[digito][fila][columna]
                )

        entradas.append(vector)

    return entradas


# ============================================================
# GENERAR SALIDAS
# ============================================================
# Cada digito tiene un vector one-hot de 10 posiciones.
#
# 0 -> [1,0,0,0,0,0,0,0,0,0]
# 1 -> [0,1,0,0,0,0,0,0,0,0]
# ...
# 9 -> [0,0,0,0,0,0,0,0,0,1]
# ============================================================

def generar_salidas():

    salidas = []

    for digito in range(10):

        vector = []

        for salida in range(10):

            vector.append(
                1 if digito == salida else 0
            )

        salidas.append(vector)

    return salidas


# ============================================================
# GUARDAR ARCHIVO JSON
# ============================================================

def guardar_json(nombre, datos):

    with open(nombre, "w", encoding="utf-8") as archivo:

        json.dump(
            datos,
            archivo,
            indent=4
        )


# ============================================================
# GENERAR ARCHIVOS
# ============================================================

entradas = generar_entradas()
salidas = generar_salidas()


guardar_json("entradas.json", entradas)
guardar_json("salidas.json", salidas)


# ============================================================
# VERIFICAR
# ============================================================

print("==========================================")
print("ARCHIVOS GENERADOS")
print("==========================================")

print(" - entradas.json")
print(" - salidas.json")

print()

print("==========================================")
print("DIMENSIONES")
print("==========================================")

print(
    f"entradas: {len(entradas)} x {len(entradas[0])}"
)

print(
    f"salidas:  {len(salidas)} x {len(salidas[0])}"
)

print()

print("==========================================")
print("VECTOR DE ENTRADA DEL DIGITO 0")
print("==========================================")

print(entradas[0])

print()

print("==========================================")
print("VECTOR DE ENTRADA DEL DIGITO 1")
print("==========================================")

print(entradas[1])

print()

print("==========================================")
print("SALIDA ESPERADA DEL DIGITO 0")
print("==========================================")

print(salidas[0])

print()

print("==========================================")
print("SALIDA ESPERADA DEL DIGITO 1")
print("==========================================")

print(salidas[1])