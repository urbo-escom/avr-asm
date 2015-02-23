;
; Macros  para  multiplexar varios  displays  (de  1  a 8)  con  transistores,
; por  default  son  displays  de   cátodo  común  y  transistores  NPN,  la
; activación de los displays y transistores  siempre se hace con un 1 lógico
; independientemente del tipo de display y transistor porque internamente se
; hace el complemento dependiendo del tipo de cada uno.
;
; REQUIRE_DISPLAY_MUX_CONF
; Se expande al código para configurar los puertos
;
; REQUIRE_DISPLAY_MUX_NEXT
; Se expande al código para seleccionar el siguiente display
;
; Ejemplo:
;
;     ; Antes de llamar a REQUIRE
;     .define DISPLAY_MUX_OUT_PORT    (PORTB)
;     ; .define DISPLAY_MUX_OUT_ACTIVE_LOW ; Opcional, displays de ánodo
;     ; .define DISPLAY_MUX_SELECT_ACTIVE_LOW ; Opcional transistores PNP
;     .define DISPLAY_MUX_SELECT_LEN  (3)
;     .define DISPLAY_MUX_SELECT_PORT (PORTD)
;     .define DISPLAY_MUX_SELECT_PINS ((1 << 7) | (1 << 6) | (1 << 5))
;             DISPLAY_MUX_SELECT_SEQ: .db (1 << 7), (1 << 6), (1 << 5), 0
;     .dseg
;             ; En algún punto este arreglo debe ser rellenado
;             DISPLAY_MUX_SELECT_VALUES: .byte DISPLAY_MUX_SELECT_LEN
;             DISPLAY_MUX_SELECT_INDEX:  .byte 1
;     .cseg
;
; define 3  displays de cátodo  común y transistores  NPN, en PORTB  y PORTD
; respectivamente con la secuencia de selección PD7 -> PD6 -> PD5:
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


.macro REQUIRE_DISPLAY_MUX_CONF
	push r16

	; Configura la salida principal sin activar
		ldi r16, 0xff
		out DISPLAY_MUX_OUT_PORT - 1, r16
		.ifdef DISPLAY_MUX_OUT_ACTIVE_LOW
			ldi r16, 0xff
		.else
			ldi r16, 0x00
		.endif
		out DISPLAY_MUX_OUT_PORT, r16


	; Configura los selectores de display
		ldi r16, DISPLAY_MUX_SELECT_PINS
		.ifdef DISPLAY_MUX_SELECT_ACTIVE_LOW
			com r16
		.endif
		out DISPLAY_MUX_SELECT_PORT - 1, r16


	ldi r16, 0
	sts DISPLAY_MUX_SELECT_INDEX, r16

	pop r16
.endmacro


.macro REQUIRE_DISPLAY_MUX_NEXT
	push r16
	push r17
	push ZL
	push ZH


	; Desactiva el display primero
	.ifdef DISPLAY_MUX_OUT_ACTIVE_LOW
		ldi r17, 0xff
	.else
		ldi r17, 0x00
	.endif
	out DISPLAY_MUX_OUT_PORT, r17


	; Selecciona el siguiente display
	lds r16, DISPLAY_MUX_SELECT_INDEX
	ldi r17, 0
	ldi ZH, high(2*DISPLAY_MUX_SELECT_SEQ)
	ldi ZL,  low(2*DISPLAY_MUX_SELECT_SEQ)
	add ZL, r16
	add ZH, r17
	lpm r17, Z
	.ifdef DISPLAY_MUX_SELECT_ACTIVE_LOW
		com r17
	.endif
	out DISPLAY_MUX_SELECT_PORT, r17


	; Reactiva el display con el valor que hay en el índice
	lds r16, DISPLAY_MUX_SELECT_INDEX
	ldi r17, 0
	ldi ZH, high(DISPLAY_MUX_SELECT_VALUES)
	ldi ZL,  low(DISPLAY_MUX_SELECT_VALUES)
	add ZL, r16
	adc ZH, r17
	ld r17, Z
	.ifdef DISPLAY_MUX_OUT_ACTIVE_LOW
		com r17
	.endif
	out DISPLAY_MUX_OUT_PORT, r17


	; Incrementa el índice o vuelve a 0 si ya llegamos al final
	lds r16, DISPLAY_MUX_SELECT_INDEX
	inc r16
	cpi r16, DISPLAY_MUX_SELECT_LEN
	brlo _display_mux_next_sts_index
		ldi r16, 0
	_display_mux_next_sts_index:
	sts DISPLAY_MUX_SELECT_INDEX, r16


	pop ZH
	pop ZL
	pop r17
	pop r16
.endmacro
