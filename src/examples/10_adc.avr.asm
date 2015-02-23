;
; Uso del  ADC en  modo simple,  imprime los 8  MSB's en  PORTB inmediatamente
; después de hacer cada conversión. AGND está conectado a GND, AVCC a VCC y
; un  voltaje entre  0 y  VCC va  en PC0,  esta configuración  no es  la más
; óptima debido al ruido que interfiere en el ADC.
;

.include "m48def.inc"

.org 0x0
	rjmp reset

reset:
	ldi r17, high(RAMEND)
	ldi r16,  low(RAMEND)
	out SPH, r17
	out SPL, r16

	ldi r16, 0xff
	out DDRB, r16
	ldi r16, 0xf0
	out PORTB, r16

	; Usa AVcc como referencia, ajustado a la izquierda en PC0
	ldi r16, (1 << REFS0) | (1 << ADLAR)
	sts ADMUX, r16
	; Habilita el ADC y usa un preescalador de ADC /16
	ldi r16, (1 << ADEN) | (1 << ADPS2)
	sts ADCSRA, r16

main:
	; Habilita ADSC (sin alterar otros valores)
	lds r16, ADCSRA
	ori r16, (1 << ADSC)
	sts ADCSRA, r16

wait_adc:
	; Espera hasta que la bandera de conversión completada se habilite
	lds r16, ADCSRA
	sbrs r16, ADSC
		rjmp wait_adc

	; Lee ADC, descarta dos LSB (ajustado a la izquierda)
	lds r16, ADCL
	lds r16, ADCH
	out PORTB, r16

	rjmp main
