
/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros R0 a R12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros R0 a R3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros R0 a R3 y el
 * registro R12 pueden cambiar su valor (y en particular, R0 contiene 
 * normalmente el valor devuelto), los registros R4 a R11 preservan
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
 *  a->R0, b->R1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  R0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}
    // Insertar código a continuación
    ADD     R0, R0, R1
    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->R0    : Cantidad de números en registro R0, entero de 32 bit
 *  b->R1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  R1:R0 : Sumatoria, entero de 64 bit con signo 
 */
defun sumatoria
    push {r4-r11,lr}
    // Insertar código a continuación

    // Inicializo los registros R2 y R3
    MOV     R2 #0
    MOV     R3 #0

    LOOP: 
        LDR     R4, R[1], #4 // carga el numero actual en R4

        ADD     R2, R2, R4
        ADC     R3, R3, #0

        SUB     R0, R0, #1

        BNE     LOOP
    
    MOV     R0, R2
    MOV     R1, R3
    // Retorno, antes R1:R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun sumatoria

/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->R0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  R0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */
defun posicion_maximo
    push {r4-r11,lr}
    // Insertar código a continuación

    // Inicializa R2 como el maximo actual y R3 como la posicion del maximo
    LDR     R2, [R1]    // carga el primer numero 
    MOV     R3, R1      // Guarda la poscicion del primer numero

    LOOP:
        LDR     R4, [R1], #4    // Carga el numero actual

        CMP     R2, R4  // Compara R4 con el maximo actual (R2)

        //Si R4 es mayor que R2, actualiza el maximo y su posicion
        IT      GT
        MOVGT   R2, R4
        MOVGT   R3, R1

        //Resto R0 y repite si aun hay numeros
        SUBS    R0, R0, #1
        BNE     LOOP
    
    MOV     R0, R3
    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7};
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->R0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    // Insertar código a continuación
    MOV     R2, #0

    outer_loop:
        MOV     R3, R2

    inner_loop:
        LDR     R4, [R1, R3, LSL #2]
        ADD     R3, R3, #1
        LDR     R5, [R1, R3, LSL #2]

        CMP     R4, R5
        IT      GT
        STRGT   R4, [R1, R3, LSL #2]
        STRGT   R5, [R1, R3, LSL #2, #-4]

        CMP     R3, RO
        BLT     inner_loop

        ADD     R2, R2, #1
        CMP     R2, R0
        BLT     outer_loop
    // Retorno
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
