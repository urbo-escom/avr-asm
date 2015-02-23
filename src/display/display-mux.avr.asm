.include "m48def.inc"
.include "display-mux.avr.inc"

.org 0x00
	rjmp reset


.org 0x20
.define DISPLAY_MUX_OUT_PORT    (PORTB)
.define DISPLAY_MUX_SELECT_LEN  (3)
.define DISPLAY_MUX_SELECT_PORT (PORTD)
.define DISPLAY_MUX_SELECT_PINS ((1 << 7) | (1 << 6) | (1 << 5))
        DISPLAY_MUX_SELECT_SEQ: .db (1 << 7), (1 << 6), (1 << 5), 0
.dseg
	DISPLAY_MUX_SELECT_VALUES: .byte DISPLAY_MUX_SELECT_LEN
	DISPLAY_MUX_SELECT_INDEX:  .byte 1
.cseg


reset:
	ldi r17, high(RAMEND)
	ldi r16,  low(RAMEND)
	out SPH, r17
	out SPL, r16

	rcall display_mux_conf

	ldi r16, 0x33
	sts DISPLAY_MUX_SELECT_VALUES + 0, r16
	ldi r16, 0x44
	sts DISPLAY_MUX_SELECT_VALUES + 1, r16
	ldi r16, 0x55
	sts DISPLAY_MUX_SELECT_VALUES + 2, r16

main:
	rcall display_mux_next
	rjmp main


display_mux_conf:
	REQUIRE_DISPLAY_MUX_CONF
	ret

display_mux_next:
	REQUIRE_DISPLAY_MUX_NEXT
	ret
