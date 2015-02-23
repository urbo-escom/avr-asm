;
; Se hará uso del apuntador de pila (para rcall's y ret's) junto con el uso
; de variables en SRAM para este ejemplo
;
.include "m48def.inc"

.org 0x0
	; Brincamos al reset, nos saltamos todo el siguiente código
	rjmp reset

;
; Declara un  segmento de datos  para que contenga un  contador de 16  bits Al
; final, count, como  cualquier etiqueta, se expande a un  valor numérico que
; indica la dirección que  ocupa, en este caso al ser  el inicio del segmento
; de datos, su valor es 0x100. Por lo general, sería útil incluir el tamaño
; de cada variable en un .equ pero no incluiremos eso en este ejemplo básico.
; Las variables  `foo` y  `bar` solo están  para ilustrar, no  se usan  en el
; resto del código.
;

.dseg
	count: .byte 2 ; 0x100
	foo:   .byte 3 ; 0x102
	bar:   .byte 4 ; 0x105

;
; Esto  no ocupa  espacio en  el código  ensamblado. Sirve  de ayuda  para no
; preocuparnos por  los rangos de  una variable, por  ejemplo si lo  hacemos a
; "mano",  podemos declarar  count  con  `equ count  =  (0x100)`, pero  cuando
; declaremos  más  variables debemos  calcular  los  offsets que  ocupa  cada
; variable o podríamos sobreescribir valores a la hora de usarlas.
;
;     .equ count      = (0x100)                ; 0x100-0x101
;     .equ count_size = (2)
;     .equ foo        = (count + count_size)   ; 0x102-0x104
;     .equ foo_size   = (3)
;     .equ bar        = (foo + foo_size)       ; 0x105-0x106
;     .equ bar_size   = (2)
;     .equ BAD        = (0x103)                ; 0x103 !!! Just NO
;
; Esa sería una forma de declarar variables, pero es más largo y si borramos
; por ejemplo  a `foo`, tendríamos  que modificar bar.  A parte de  que `BAD`
; ocuparía espacio usado por `foo`. Con la directiva dseg sería:
;
;     .dseg:
;     .equ count_size = 2
;     .equ foo_size   = 3
;     .equ bar_size   = 2
;             count: .byte count_size  ; 0x100
;             foo:   .byte foo_size    ;
;             bar:   .byte bar_size    ;
;
; Además otra ventaja de .dseg es que el ensamblador por lo regular muestra
; información acerca del uso del segmento de datos.
;

; Vuelve al segmento de código
.cseg
count_init:
	;
	; Inicializa el contador con  la instruction de guardado directamente
	; a SRAM, guardamos  el primer byte (0) y luego  el segundo (1), con
	; sts y lds.  Se puede pensar en count+i como  acceder un arreglo con
	; count[i]. Nada nos impide escribir en count+2, solo son constantes,
	; debemos ser cuidadosos de donde escribimos!
	;
	ldi r16, 0
	sts count + 0, r16   ;  count[0] = 0
	sts count + 1, r16   ;  count[1] = 0
	sts count + 2, r16   ;  count[2] = 0 !!! Podría ser otra variable
	ret

; Incrementa el contador
count_inc:
	;
	; Carga el  contador a los registros  r16:r17 y súmale 1.  La primer
	; suma es +1, la  otra (con adc)  es +0 y sirve para propagar el bit
	; de acarreo si es que lo hay. Los comentarios a  la derecha indican
	; el número de ciclos que toma cada instrucción.
	;
	; lds es la instrucción inversa a sts
	;
	ldi r20, 1          ; 1
	ldi r21, 0          ; 1
	lds r16, count + 0  ; 2, r16 es el byte menos significativo
	lds r17, count + 1  ; 2, r17 es el byte más significativo
	add r16, r20        ; 1
	adc r17, r21        ; 1, r17:r16 tienen el incremento
	;
	; Guarda el incremento
	; r16 y r17 conservan los valores (se usan en main)
	;
	sts count + 0, r16  ; 2
	sts count + 1, r17  ; 2

	ret  ; 4, 16 en total, más abajo retomaremos este valor

reset:
	ldi r16, high(RAMEND)
	ldi r17,  low(RAMEND)
	out SPH, r16
	out SPL, r17

	ldi r16, 0xff
	ldi r17, 0
	out DDRB, r16
	out PORTB, r17

	rcall count_init

main:
	;
	; Aquí  volveremos   a  incluir  el   número  de  ciclos   de  cada
	; instrucción, dado  que un contador  de 16 bits causa  sobreflujo a
	; las  2^16  cuentas o  a  las  65536  cuentas, si  multiplicamos  la
	; cantidad  de  tiempo  que  nos  toma hacer  una  cuenta  por  2^16,
	; obtendremos la cantidad de tiempo total  en que se tarda en prender
	; y apagar el bit más significativo (sobreflujo)
	;
	rcall count_inc ; 3 + 16, debido a count_inc
	out PORTB, r17  ; 1
	rjmp main       ; 2, 22 us en total
	;
	; 22*2^16 us = 1441792 us =~ 1.4 s
	; Que se tarde 1.4 s en prender Y apagar (0.7 s Y 0.7s) significa que
	; el parpadeo  es visible a simple  vista, es por eso  que hacemos un
	; out PORTB,  r17, siendo r17  el byte más significativo.  Los pines
	; del 7 al 4 pueden ser conectados a unos leds (y sin delay).
	;
	; Podríamos tener más control sobre este tiempo pero cada ciclo que
	; nos tardemos de más o de menos nos  suma o resta 65536 us o 65 ms.
	; Para  evitar  ese  tipo  de problemas  (entre  otros)  existen  los
	; temporizadores.
	;
