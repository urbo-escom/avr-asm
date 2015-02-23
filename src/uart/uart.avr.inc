;
; # UART
;
; Rutinas y definiciones para configurar, leer y escribir en UART.
;
;        AVR                   UART to PC
;     +-------+               +----------+      PC
;     |       |               |          |   +------+
;     | TX ------->  ----RX----->      ----->|      |
;     | RX <-------  <---TX------      <-----|      |
;     |       |               |          |   +------+
;     +-------+               +----------+
;
; Consulta la hoja de datos para ver los pines de TX/RX y como referencia
; rápida está:
;
;     20 USART0
;         20.10 Register description
;
;

.ifndef _UART_INC_
.define _UART_INC_


;
; Acerca de la fórmula para calcular UBRR0
;
;     20.3.1  Internal Clock Generation - The Baud Rate Generator
;         Table 20-1 Equations for Calculating Baud Rate Register Setting
;

.define UART_UBRR0 ((F_CPU/(16*UART_BAUD_RATE)) - 1)


; UCSR0A Doble velocidad
.define UART_DOUBLE_SPEED    ((1 << U2X0) << 0)

; UCSR0B Modos de lectura y/o escritura
.define UART_READ            ((1 << RXEN0) << 8)
.define UART_WRITE           ((1 << TXEN0) << 8)
.define UART_READ_WRITE      (UART_READ | UART_WRITE)

; UCSR0B Interrupciones para cuando podemos *empezar* a leer o escribir
.define UART_READ_READY_INT  ((1 << RXCIE0) << 8)
.define UART_WRITE_READY_INT ((1 << UDRIE0) << 8)

; UCSR0C Modo 8N1 asíncrono
.define UART_8N1_MODE        (((1 << UCSZ01) | (1 << UCSZ00)) << 16)


;
; MACRO uart_set_conf
;
; Configura el uart, ejemplo:
;
;     uart_set_conf \
;         UART_DOUBLE_SPEED | \
;         UART_READ_WRITE | \
;         UART_READ_READY_INT | \
;         UART_8N1_MODE
;

.macro uart_set_conf
	push r16
	push r17

	; Baudrate
	ldi r17, high(UART_UBRR0)
	ldi r16,  low(UART_UBRR0)
	sts UBRR0H, r17
	sts UBRR0L, r16

	ldi r16, low(@0)
	sts UCSR0A, r16

	ldi r16, high(@0)
	sts UCSR0B, r16

	ldi r16, byte3(@0)
	sts UCSR0C, r16

	pop r17
	pop r16
.endmacro


;
; uart_read_char -> r16
;
; Lee un byte del UART en modo polling (bloquea hasta terminar) y lo almacena
; en r16.
;

uart_read_char:
	; RXC0 es 1 cuando el buffer (UDR0) está listo para lectura
	lds r16, UCSR0A
	sbrs r16, RXC0
		rjmp uart_read_char

	lds r16, UDR0
	ret


;
; uart_write_char <- r16
;
; Escribe el byte de r16 en el UART en modo polling (bloquea hasta terminar).
;

uart_write_char:
	; UDRE0 es 1 cuando el buffer (UDR0) está listo para escritura
	push r16
	lds r16, UCSR0A
	sbrs r16, UDRE0
		rjmp uart_write_char

	pop r16
	sts UDR0, r16
	ret

.endif ; _UART_INC_
