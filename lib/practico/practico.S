
/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros r0 a r12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros r0 a r3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros r0 a r3 y el
 * registro r12 pueden cambiar su valor (y en particular, r0 contiene 
 * normalmente el valor devuelto), los registros r4 a r11 preservan
 * su valor.
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * Sumar dos enteros de 32 bit
 *  suma(2,3) => 5
 * Entrada
 *  a->r0, b->r1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  r0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}
    // Insertar código a continuación
    add r0, r1
    // retorno, antes r0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->r0    : Cantidad de números en registro r0, entero de 32 bit
 *  b->r1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  r1:r0 : Sumatoria, entero de 64 bit con signo 
 */
defun sumatoria
    push {r4-r11,lr}
    // Insertar código a continuación
    mov r2, #0                  // Inicializa el índice actual a 0
    mov r3, #0                  // Inicializa la parte baja del acumulador a 0
    mov r4, #0                  // Inicializa la parte alta del acumulador a 0

bucle_1:
    ldr r5, [r1, r2, lsl #2]    // Carga el elemento actual del arreglo en r5
    add r3, r5                 // Suma el elemento actual a la parte baja del acumulador
    adc r4, #0                  // Suma el acarreo a la parte alta del acumulador

    add r2, #1                  // Incrementa el índice actual
    cmp r2, r0                  // Compara el índice actual con el tamaño del arreglo
    blt bucle_1                   // Si el índice actual es menor que el tamaño del arreglo, continúa el bucle

fin_1:
    mov r0, r3                  // Devuelve la parte baja del resultado en r0
    mov r1, r4                  // Devuelve la parte alta del resultado en r1
    // retorno, antes r1:r0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun sumatoria

/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->r0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->r1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  r0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */
defun posicion_maximo
    push {r4-r11,lr}
    // Insertar código a continuación
    mov r2, #0                  //Inicializa el índice del máximo a 0
    ldr r3, [r1]                //Carga el primer elemento del arreglo en r3
    mov r4, #1                  //Inicializa el índice actual a 1

bucle_2:
    ldr r5, [r1, r4, lsl #2]    //Carga el elemento actual del arreglo en r5
    cmp r3, r5                  //Compara el máximo actual con el elemento actual
    blt actualizar              //Si el máximo actual es menor que el elemento actual, actualiza el máximo
    b fin_actualizar            //Si no, termina la actualización

actualizar:
    mov r3, r5                  //Actualiza el máximo actual
    mov r2, r4                  //Actualiza el índice del máximo

fin_actualizar:
    add r4, #1                  //Incrementa el índice actual
    cmp r4, r0                  //Compara el índice actual con el tamaño del arreglo
    blt bucle_2                 //Si el índice actual es menor que el tamaño del arreglo, continúa el bucle

fin:
    mov r0, r2                  //Devuelve la posición del máximo en r0
    // retorno, antes r0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7}//
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->r0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->r1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    // Insertar código a continuación
    mov r2, #0                              // Inicializar el índice i a 0

bucle_externo:
    mov r3, #0                              // Inicializar el índice j a 0

bucle_interno:
    ldr     r4, [r1, r3]                    // Cargar el elemento j del arreglo en r4
    ldr     r5, [r1, r3, lsl #2]            // Cargar el elemento j+1 del arreglo en r5
    add     r5, #1
    cmp     r4, r5                          // Comparar los elementos j y j+1
    blt     siguiente                       // Si el elemento j es menor, saltar al siguiente elemento
    str     r5, [r1, r3]                    // Si el elemento j es mayor, intercambiar los elementos
    str     r4, [r1, r3, lsl #2]

siguiente:
    add     r3, #1                          // Incrementar el índice j
    cmp     r3, r0                          // Comparar el índice j con el tamaño del arreglo
    blt     bucle_interno                   // Si el índice j es menor, volver al inicio del bucle interno

    add     r2, #1                          // Incrementar el índice i
    cmp     r2, r0                          // Comparar el índice i con el tamaño del arreglo
    blt     bucle_externo                   // Si el índice i es menor, volver al inicio del bucle externo

    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
