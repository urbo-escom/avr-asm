;
; En este  ejemplo mostraremos un arreglo  de caracteres en PORTB  uno por uno
; indicando el índice en  PORTD, vamos a mostrar los valores  ascii, no en un
; display de siete segmentos.
;

.include "m48def.inc"

.org 0x0
	rjmp reset

; Arreglo de caracteres en memoria de programa con el que inicializaremos buf
default_buf:
	.db "Foxtrot Uniform Charlie Kilo",0,0

; El arreglo de caracteres está sin inicializar
.dseg
.equ BUF_SIZE = (64)
	buf: .byte BUF_SIZE

.cseg

reset:
	ldi r17, high(RAMEND)
	ldi r16,  low(RAMEND)
	out SPH, r17
	out SPL, r16

	ldi r16, 0xff
	out DDRB, r16
	out DDRD, r16

	; Inicializa el arreglo con un valor en memoria de programa
	rcall init_buf

	rjmp _main_reset
main:
	; Vamos a tratar el arreglo de caracteremos como lo haríamos en C
	cpi r16, 0        ; if (r16 == '\0')
	breq _main_reset  ;     goto reset

	out PORTB, r16
	out PORTD, r17

	ld r16, Z+  ; r16++
	inc r17     ; r17++
	rjmp main

_main_reset:
	; Ponemos una marca para identificar mejor el arreglo en la simulación
	ldi r18, 0xff
	out PORTB, r18
	;
	; Cargar de  SRAM es distinto  de cargar  de la memoria  de programa,
	; contrasta ld con lpm, en lpm se debe multiplicar por 2.
	;
	ldi ZH, high(buf)
	ldi ZL,  low(buf)
	ld r16, Z+
	ldi r17, 0
	rjmp main


;
; Como  en C,  debemos  cuidar de  no  escribir en  direcciones  fuera de  las
; permitidas o corremos el riesgo de alterar otras variables (en este pequeño
; ejemplo no importa).  También tomamos en cuenta que '\0'  marca el final de
; un arreglo de caracteres.
;

init_buf:
	; Apuntamos Z a la dirección del arreglo en memoria de programa
	ldi ZH, high(2*default_buf)  ; Z = default_buf
	ldi ZL,  low(2*default_buf)

	; Apunta Y a la dirección del arreglo en SRAM
	ldi YH, high(buf) ; Y = buf
	ldi YL,  low(buf)

	ldi r17, 0
_init_buf_loop:
	; No debemos pasarnos del límite del arreglo, contando '\0'
	cpi r17, (BUF_SIZE - 1)
	brge _init_buf_end

	; r16 = *Z++
	lpm r16, Z+

	; Debemos detenernos si llegamos al final del arreglo a copiar
	cpi r16, 0
	breq _init_buf_end

	; *Y++ = r16
	st Y+, r16
	inc r17
	rjmp _init_buf_loop

_init_buf_end:
	ldi r16, 0   ; Agrega el caracter nulo '\0'
	st Y, r16    ;
	ret
