;
; Muestra un mensaje en un arreglo  de displays de siete segmentos, el mensaje
; no tiene que ser del mismo tamaño que el arreglo de displays. En el caso de
; ser del mismo o menor tamaño, el mensaje permanecerá estático.
;
; Cuando el  mensaje es  más grande,  éste se  exhibirá rotando  primero de
; izquierda a derecha y después de derecha a izquierda:
;
;        MESSAGE
;     +---+---+---+---+---+---+
;     | F | O | O | B | A | R |
;     +---+---+---+---+---+---+
;
;        DISPLAY
;     +---+---+---+    +---+---+---+    +---+---+---+    +---+---+---+
;     | F | O | O | -> | O | O | B | -> | O | B | A | -> | B | A | R |
;     +---+---+---+    +---+---+---+    +---+---+---+    +---+---+---+
;                                                              v
;     +---+---+---+    +---+---+---+    +---+---+---+    +---+---+---+
;     | F | O | O | <- | O | O | B | <- | O | B | A | <- | B | A | R |
;     +---+---+---+    +---+---+---+    +---+---+---+    +---+---+---+
;
; El circuito debe lucir así con displays de cátodo común, los transistores se
; usan como switches lógicos.
;
;     +-----+
;     | PB7 | ---<100>---* H     +---<A>---+     +---<A>---+     +---<A>---+
;     | PB6 | ---<100>---* A     |         |     |         |     |         |
;     | PB5 | ---<100>---* B     <F>     <B>     <F>     <B>     <F>     <B>
;     | PB4 | ---<100>---* C     |         |     |         |     |         |
;     | PB3 | ---<100>---* D     +---<G>---+     +---<G>---+     +---<G>---+
;     | PB2 | ---<100>---* E     |         |     |         |     |         |
;     | PB1 | ---<100>---* F     <E>     <C>     <E>     <C>     <E>     <C>
;     | PB0 | ---<100>---* G     |         |     |         |     |         |
;     |     |                    +-+-<D>--<H>    +-+-<D>--<H>    +-+-<D>--<H>
;     |     |                      |               |               |
;     |     |                    |/                |               |
;     | PD7 | ---<100>-----------|\e             |/                |
;     | PD6 | ---<100>-------------|-------------|\e             |/
;     | PD5 | ---<100>-------------|---------------|-------------|\e
;     +-----+                      |               |             |
;                                 GND             GND           GND
;

.include "m48def.inc"


; Controla la velocidad, en us, con la que rota el display
.equ SPEED = (1000000)


.org 0x0
	rjmp reset


;
; Rota el texto cada cierto tiempo, la rotación se lleva a cabo en memoria no
; en los puertos directamente. Por lo tanto el texto rotado se va a actualizar
; en la siguiente multiplexación.
;

.org TIMER1_COMPA_int
	rjmp display_rotate


;
; Multiplexa los  displays, los valores  de los  puertos se toman  de memoria,
; debe ser lo  más rápido posible, en  este caso se multiplexará  cada 2 ms
; aprox. completando una ronda cada 6 ms.
;

.org TIMER0_OVF_int
	rjmp display_mux_next


.dseg
	; Mensaje completo almacenado en memoria.
	.equ BUF_SIZE = (128)
	display_msg:        .byte BUF_SIZE
	display_msg_length: .byte 1


	; Almacena en donde nos encontramos en el mensaje
	display_msg_index: .byte 1


	; Almacena si venimos (0) o regresamos (1) en el mensaje
	display_direction: .byte 1


	; Valores de los displays, solo mostramos 3 a la vez
	.equ DISPLAY_SIZE = (3)
	display_val: .byte DISPLAY_SIZE


.cseg
.org 0x20
.include "ascii2display.avr.inc"

	;
	; Necesitamos un mensaje por default
	;
	; Nota importante:  El ensamblador  no produce strings  terminados con
	; '\0' (como en C), por lo que  SIEMPRE hay que incluirlo al final del
	; string. Va a ver casos en donde el ensamblador si lo inserta pero es
	; por padding nada más.
	;
	display_default_msg: .db "Foxtrot Uniform Charlie Kilo",0


reset:
	ldi r17, high(RAMEND)
	ldi r16,  low(RAMEND)
	out SPH, r17
	out SPL, r16

	cli
	rcall conf_display   ; Configura el I/O del display
	rcall display_init   ; e inicialízalo
	sei


main:
	rjmp main


conf_display:
	ldi r16, 0xff
	out DDRB, r16    ; PORTB para el display y
	out DDRD, r16    ; PORTD para la multiplexación
	ldi r16, 0
	out PORTB, r16
	out PORTD, r16


	;
	; Configura TIMER1 en modo CTC con  un preescalador de /64, para tener
	; algo de precisión dividimos el  tiempo requerido en us, por ejemplo
	; 1000000 s, entre el preescalador.
	;
	.equ TIMER1_1s = ((SPEED)/64)
	ldi r16, 0
	sts TCCR1A, r16
	ldi r16, (1 << WGM12) + (1 << CS11) + (1 << CS00)
	sts TCCR1B, r16

	ldi r16, high(TIMER1_1s)
	sts OCR1AH, r16
	ldi r16,  low(TIMER1_1s)
	sts OCR1AL, r16

	ldi r16, 0
	sts TCNT1H, r16
	sts TCNT1L, r16

	ldi r16, (1 << OCIE1A)
	sts TIMSK1, r16


	;
	; Configura  TIMER0 en modo Normal  con un  preescalador de /8,
	; un sobreflujo se debe producir cada 256*8 us = 2048 us ~ 2 ms
	;
	ldi r16, 0
	out TCCR0A, r16
	ldi r16, (1 << CS01)
	out TCCR0B, r16

	ldi r16, 0
	out TCNT0, r16

	ldi r16, (1 << TOIE0)
	sts TIMSK0, r16
	ret


display_init:
	; Inicializa todo a 0
	ldi r16, 0
	sts display_msg, r16
	sts display_msg_length, r16
	sts display_msg_index, r16
	sts display_direction, r16
	sts display_val + 0, r16
	sts display_val + 1, r16
	sts display_val + 2, r16


	;
	; Inicializa el mensaje en memoria con el otro mensaje que está
	; en memoria de programa.
	;
	; r16: caracter actual
	; r17: longitud del mensaje
	;
	ldi ZH, high(2*display_default_msg)
	ldi ZL,  low(2*display_default_msg)

	ldi YH, high(display_msg)
	ldi YL,  low(display_msg)


	ldi r17, 0
	_display_init_msg:
		cpi r17, (BUF_SIZE - 1)  ; El mensaje es demasiado grande,
		brge _display_init_end   ; y falta  el caracter  nulo '\0'

		lpm r16, Z+              ; if ('\0' == (r16 = *Z++))
		cpi r16, 0               ;     break;
		breq _display_init_end   ;

		st Y+, r16               ; *Y++ = r16
		inc r17                  ; r17++
		rjmp _display_init_msg   ;
	_display_init_end:
	sts display_msg_length, r17      ;
	ldi r16, 0                       ; Añade el caracter '\0' para que
	st Y, r16                        ; sea  una cadena  bien terminada


	; Copia los primeros tres caracteres del mensaje cargado
	ldi YH, high(display_msg)
	ldi YL,  low(display_msg)

	ldd r17, Y+0
	rcall ascii2display
	sts display_val+0, r16

	ldd r17, Y+1
	rcall ascii2display
	sts display_val+1, r16

	ldd r17, Y+2
	rcall ascii2display
	sts display_val+2, r16
	ret


display_rotate:
	lds r16, display_direction
	lds r17, display_msg_index
	lds r18, display_msg_length


	;
	; En ambas direcciones, cuando se  llegue al final izquierdo o derecho
	; y hagamos un cambio de rotación,  no vamos a actualizar los valores
	; del display hasta  la siguiente iteración, es decir,  el mensaje de
	; los "extremos"  va a  durar el  doble de tiempo  con respecto  a los
	; demás, va a parecer que se detiene un momento.
	;
	cpi r16, 0
		breq _display_rotate_right
	rjmp _display_rotate_left


	;
	; Para saber que hemos llegado  al final derecho, debemos preguntarnos
	; si estamos en los últimos 3 caracteres.
	;
	_display_rotate_right:
		mov r19, r18
		subi r19, 3
		cp r17, r19
		breq _display_rotate_next_left

		inc r17
	rjmp _display_rotate_load


		; Recordando que  el final  de una dirección  va a  durar dos
		; iteraciones.
		_display_rotate_next_left:
			ldi r16, 1
			sts display_direction, r16
		rjmp _display_rotate_load


	;
	; En el  caso de  la rotación  izquierda, es  más sencillo  saber si
	; hemos llegado al final: no podemos ir más bajo del índice 0.
	;
	_display_rotate_left:
		cpi r17, 0
		breq _display_rotate_next_right

		dec r17
	rjmp _display_rotate_load


		_display_rotate_next_right:
			ldi r16, 0
			sts display_direction, r16
		rjmp _display_rotate_load


	;
	; Al final  solo cargamos los nuevos  valores (o viejos en  el caso de
	; estar en el cambio de rotación) y listo.
	;
	_display_rotate_load:
		sts display_msg_index, r17

		ldi ZH, high(display_msg)
		ldi ZL,  low(display_msg)
		clr r0
		add ZL, r17
		adc ZH, r0

		ldd r17, Z+0
		rcall ascii2display
		sts display_val+0, r16

		ldd r17, Z+1
		rcall ascii2display
		sts display_val+1, r16

		ldd r17, Z+2
		rcall ascii2display
		sts display_val+2, r16
	reti


display_mux_next:
	in r16, PIND     ; Apaga cualquier valor que tengamos en el selector
	ldi r17, 0       ; de displays,  pero  antes hay que  guardarlo para
	out PORTD, r17   ; saber cual es el siguiente.


	cpi r16, (1 << 5)
		breq _display_mux_next_1


	cpi r16, (1 << 6)
		breq _display_mux_next_2


	cpi r16, (1 << 7)
		breq _display_mux_next_0


	_display_mux_next_0:
		ldi r16, (1 << 5)
		out PORTD, r16
		lds r16, display_val + 0
		out PORTB, r16
		reti


	_display_mux_next_1:
		ldi r16, (1 << 6)
		out PORTD, r16
		lds r16, display_val + 1
		out PORTB, r16
		reti


	_display_mux_next_2:
		ldi r16, (1 << 7)
		out PORTD, r16
		lds r16, display_val + 2
		out PORTB, r16
		reti
