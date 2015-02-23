;
; m48def.inc contiene  los nombres de  los registros de  acuerdo a la  hoja de
; datos, también contiene  el nombre del microcontrolador  y otras constantes
; útiles como RAMEND
;
.include "m48def.inc"

;
; La posición 0x0 es  la posición a la que el  microcontrolador va cuando es
; reseteado
;

.org 0x0
	rjmp reset

reset:
	;
	; Carga valores inmediatos (constantes) a los registros
	; high y low son funciones evaluadas en tiempo de ensamblamiento
	;
	ldi r16, high(RAMEND)
	ldi r17,  low(RAMEND)

	;
	; Modifica un registro  de IO con los valores cargados,  en este caso
	; la pila (aunque no la vamos a necesitar).
	;
	out SPH, r16
	out SPL, r17

	;
	; Marca todo PORTB como salida y coloca un 0 en él
	;
	; Ver la hoja de datos
	; 14.    I/O Ports
	; 14.2.1 Configuring the Pin
	;
	ldi r16, 0xff
	ldi r17, 0
	out DDRB, r16
	out PORTB, r17

main:
	;
	; Toma  el valor  de PORTB  mediante  PINB, incrementalo  y vuelve  a
	; colocarlo; in, inc  y out tardan 3  ciclos en total y  rjmp tarda 2
	; ciclos. Debería tardar 5 ciclos o 5 us en cambiar.
	;
	in r16, PINB
	inc r16
	out PORTB, r16
	rjmp main
