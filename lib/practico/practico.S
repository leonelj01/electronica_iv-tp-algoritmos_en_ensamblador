
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
    add     r0, r1
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
    mov     r2, #0                  // Inicializa el índice actual a 0
    mov     r3, #0                  // Inicializa la parte baja del acumulador a 0
    mov     r4, #0                  // Inicializa la parte alta del acumulador a 0


bucle_1:

    cmp     r2, r0                  // Compara el índice actual con el tamaño del arreglo
    bge     fin_1                   // Si el índice actual es mayor que el tamaño del arreglo finaliza el bucle

    ldr r5, [r1, r2, lsl #2]        // Carga el elemento actual del arreglo en r5
    
    cmp     r5, #0                  // determino si el numero en positivo o negativo
    blt     negativo

    adds    r3, r5                 // Suma el elemento actual a la parte baja del acumulador
    adc     r4, #0                 // Suma el acarreo a la parte alta del acumulador

    b       incremento             // actualiza el indice

negativo:
    adds    r3, r5
    adc     r4, #-1

    bal     incremento              // actualiza el indice

incremento:
    add     r2, #1
    b       bucle_1
    
fin_1:
    mov     r0, r3                  // Devuelve la parte baja del resultado en r0
    mov     r1, r4                  // Devuelve la parte alta del resultado en r1
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
    mov     r2, #0                  //Inicializa el índice del máximo a 0
    ldr     r3, [r1]                //Carga el primer elemento en r3
    mov     r4, #1                  //Inicializa el índice actual a 1

    cmp     r0, #1
    ble     fin_2

bucle_2:
    ldr     r5, [r1, r4, lsl #2]    //Carga el elemento actual en r5
    cmp     r3, r5                  //Compara el máximo actual con el elemento actual
    blt     actualizar              //Si el máximo actual es menor que el elemento actual, actualiza el máximo
    b       fin_actualizar            //Si no, termina la actualización

actualizar:
    mov     r3, r5                  //Actualiza el máximo actual
    mov     r2, r4                  //Actualiza el índice del máximo

fin_actualizar:
    add     r4, #1                  //Incrementa el índice actual
    cmp     r4, r0                  //Compara el índice actual con el tamaño del arreglo
    blt     bucle_2                 //Si el índice actual es menor que el tamaño del arreglo, continúa el bucle

fin_2:
    mov     r0, r2                  //Devuelve la posición del máximo en r0
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
    // defino los registros a utilizar
    mov     r4, r0
    mov     r5, r1
    sub     r6, r4, #1

bucle_3:

    cmp     r6, #0                      // compara r6 con 0
    ble     fin_3                       // si r6 es menor que 0 entonces finaliza el proceso

    add     r0, r6, #1                  
    mov     r1, r5
    bl      posicion_maximo             // llamo a la subrutina sumatoria 

    ldr     r7, [r5, r6, lsl #2]
    ldr     r8, [r5, r0, lsl #2]
    str     r7, [r5, r0, lsl #2]
    str     r8, [r5, r6, lsl #2]
    sub     r6, #1

    b bucle_3

fin_3:
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
