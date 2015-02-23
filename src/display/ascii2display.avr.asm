.include "m48def.inc"
.include "ascii2display.avr.inc"

.org 0x0
	rjmp reset

.org 0x20

reset:
	ldi r17, high(RAMEND)
	ldi r16,  low(RAMEND)
	out SPH, r17
	out SPL, r16

	; Despliega el del display en PORTB y el ascii en PORTD
	ldi r17, 0xff
	out DDRB, r17
	out DDRD, r17
	ldi r16, 0x00
	out PORTB, r16
	out PORTD, r16

	ldi r17, 0

main:
	cpi r17, 0x60
		brge _main_clear_ascii

	ldi r16, 0       ;  Limpia PORTB para poder medir el
	out PORTB, r16   ;  tiempo  que tarda  ascii2display
	rcall ascii2display
	out PORTB, r16
	out PORTD, r17

	inc r17
	rjmp main

_main_clear_ascii:
	ldi r17, 0
	rjmp main


ascii2display:
	REQUIRE_ASCII2DISPLAY
	ret
