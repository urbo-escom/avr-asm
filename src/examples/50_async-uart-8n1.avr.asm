;
; Uso   de  UART   en  modo   polling,   es  decir   sin  interrupciones,   el
; microcontrolador leerá  un byte  y lo  regresará inmediatamante  sin hacer
; nada más.
;
;        AVR                   USART to PC
;     +-------+               +-----------+      PC
;     |       |               |           |   +------+
;     | TX ------->  ----RX----->       ----->|      |
;     | RX <-------  <---TX------       <-----|      |
;     |       |               |           |   +------+
;     +-------+               +-----------+
;
; Consulta la hoja de datos para ver los pines de TX/RX y también para saber:
;
; Acerca de como calcular BAUD_PRESCALE (ver más abajo):
;
;     20.3.1  Internal Clock Generation - The Baud Rate Generator
;         Table 20-1 Equations for Calculating Baud Rate Register Setting
;
; Acerca de como incrementar la velocida en modo asíncrono:
;
;     20.3.2  Double Speed Operation (U2Xn)
;
; Acerca de como inicializar UART y ejemplos en C/ASM:
;
;     20.5    USART Initialization
;
; Acerca de como enviar y recibir datos y ejemplos en C/ASM:
;
;     20.6    Data Transmission - The USART Transmitter
;     20.6.1  Sending Frames with 5 to 8 Data Bit
;     20.7    Data Reception - The USART Receiver
;     20.7.1  Receiving Frames with 5 to 8 Data Bits
;
; Acerca de los valores de BAUD_RATE, doble velocidad y porcentaje de errores
;
;     20.11   Examples of Baud Rate Setting
;

.include "m48def.inc"

;
; Quitar comentario para probar la doble velocidad
;.define DOUBLE_SPEED (1)
;

.ifndef DOUBLE_SPEED
.equ BAUD_RATE = (4800)
.else
.equ BAUD_RATE = (9600)
.endif

.equ CLOCK = (1000000)
.equ BAUD_PRESCALE = ((CLOCK/(16*BAUD_RATE)) - 1)

.org 0x0
	rjmp reset

reset:
	ldi r17, high(RAMEND)
	ldi r16,  low(RAMEND)
	out SPH, r17
	out SPL, r16


_uart_set_baud_rate:
	ldi r17, high(BAUD_PRESCALE)
	ldi r16,  low(BAUD_PRESCALE)
	sts UBRR0H, r17
	sts UBRR0L, r16

.ifdef DOUBLE_SPEED
_uart_set_double_speed:
	ldi r16, (1 << U2X0)
	sts UCSR0A, r16
.endif

_uart_set_rx_tx:
	ldi r16, (1 << RXEN0) + (1 << TXEN0)
	sts UCSR0B, r16

_uart_set_8n1:
	ldi r16, (1 << UCSZ01) + (1 << UCSZ00)
	sts UCSR0C, r16

	rjmp main

usart_rx:
	lds r16, UCSR0A
	sbrs r16, RXC0
		rjmp usart_rx

	lds r17, UDR0
	ret

usart_tx:
	lds r16, UCSR0A
	sbrs r16, UDRE0
		rjmp usart_tx

	sts UDR0, r17
	ret

main:
	rcall usart_rx
	rcall usart_tx
	rjmp main
