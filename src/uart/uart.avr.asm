;
; Test de UART con interrupciones, hace un echo de lo que mandes
;

.include "m48def.inc"

.define F_CPU (1000000)
.define UART_BAUD_RATE (4800)


.org 0x00
	rjmp reset

.org USART_RX_INT
	rjmp rx_ready


.org 0x20
.include "uart.avr.inc"

; Configuración para leer y escribir en 8N1 con interrupción en lectura
.define UART_CONF (UART_READ_WRITE | UART_READ_READY_INT | UART_8N1_MODE)


reset:
	ldi r17, high(RAMEND)
	ldi r16,  low(RAMEND)
	out SPH, r17
	out SPH, r16

	uart_set_conf UART_CONF
	sei

main:
	rjmp main


rx_ready:
	lds r16, UDR0
	rcall uart_write_char
	reti
