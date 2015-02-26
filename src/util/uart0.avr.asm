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
; Acerca de la fórmula para calcular UBRR0
;
;     20.3.1  Internal Clock Generation - The Baud Rate Generator
;         Table 20-1 Equations for Calculating Baud Rate Register Setting
;


.ifdef TEST_UART0
	.include "m48def.inc"
	.org 0x00
		rjmp reset
	.org USART_RX_INT
		rjmp rx_ready
	.org 0x20
.endif


; UCSR0A Doble velocidad
.define UART0_DOUBLE_SPEED    ((1 << U2X0) << 0)

; UCSR0B Modos de lectura y/o escritura
.define UART0_READ            ((1 << RXEN0) << 8)
.define UART0_WRITE           ((1 << TXEN0) << 8)
.define UART0_READ_WRITE      (UART0_READ | UART0_WRITE)

; UCSR0B Interrupciones para cuando podemos *empezar* a leer o escribir
.define UART0_READ_READY_INT  ((1 << RXCIE0) << 8)
.define UART0_WRITE_READY_INT ((1 << UDRIE0) << 8)
.define UART0_WRITE_DONE_INT  ((1 << TXCIE0) << 8)

; UCSR0C Modo 8N1 asíncrono
.define UART0_8N1_MODE        (((1 << UCSZ01) | (1 << UCSZ00)) << 16)


;
; MACRO REQUIRE_UART0_CONF
;
; Configura el uart, ejemplo:
;
;     REQUIRE_UART0_CONF \
;             UART0_DOUBLE_SPEED | \
;             UART0_READ_WRITE | \
;             UART0_READ_READY_INT | \
;             UART0_8N1_MODE
;

.macro REQUIRE_UART0_CONF
	push r16
	push r17

	; Baudrate
	.ifdef F_CPU
	.else
		.error "Missing F_CPU (micro frequency)"
	.endif
	.ifdef UART0_BAUD_RATE
	.else
		.error "Missing UART0_BAUD_RATE"
	.endif
	ldi r17, high((F_CPU/(16*UART0_BAUD_RATE)) - 1)
	ldi r16,  low((F_CPU/(16*UART0_BAUD_RATE)) - 1)
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
; uart0_read_char -> r16
;
; Lee un byte del UART en modo polling (bloquea hasta terminar) y lo almacena
; en r16.
;

uart0_read_char:
	; RXC0 es 1 cuando el buffer (UDR0) está listo para lectura
	lds r16, UCSR0A
	sbrs r16, RXC0
		rjmp uart0_read_char

	lds r16, UDR0
	ret


;
; uart0_write_char <- r16
;
; Escribe el byte de r16 en el UART en modo polling (bloquea hasta terminar).
;

uart0_write_char:
	; UDRE0 es 1 cuando el buffer (UDR0) está listo para escritura
	push r16
	lds r16, UCSR0A
	sbrs r16, UDRE0
		rjmp uart0_write_char

	pop r16
	sts UDR0, r16
	ret

;
; Test de UART  con interrupciones, te regresa  un cifrado rot13 de  lo que le
; mandes. Para comprobar que  si funciona (o que al menos  hace un cifrado que
; es su mismo inverso), manda de vuelta lo que regrese, por ejemplo:
;
;     TX> hello
;     RX> uryyb
;
; si escribimos 'uryyb' de vuelta:
;
;     TX> uryyb
;     RX> hello
;
;
; Para rot13, ver:
;
;     http://en.wikipedia.org/wiki/ROT13
;


.ifdef TEST_UART0
	.define F_CPU (1000000)
	.define UART0_BAUD_RATE (4800)
	;
	; Configuración para leer y escribir en 8N1
	; con interrupción en lectura
	;
	.define UART0_CONF ( \
		UART0_READ_WRITE | \
		UART0_READ_READY_INT | \
		UART0_8N1_MODE)

	reset:
		ldi r17, high(RAMEND)
		ldi r16,  low(RAMEND)
		out SPH, r17
		out SPL, r16

		REQUIRE_UART0_CONF UART0_CONF
		sei

	main:
		rjmp main


	rx_ready:
		lds r16, UDR0

	_rx_ready_uppercase:
		cpi r16, 'A'
			brlo _rx_ready_echo
		cpi r16, 'Z' + 1
			brsh _rx_ready_lowercase
		cpi r16, 'M' + 1
			brsh _rx_ready_sub
		rjmp _rx_ready_sum

	_rx_ready_lowercase:
		cpi r16, 'a'
			brlo _rx_ready_echo
		cpi r16, 'z' + 1
			brsh _rx_ready_echo
		cpi r16, 'm' + 1
			brsh _rx_ready_sub
		rjmp _rx_ready_sum

	_rx_ready_sum:
		subi r16, -13
		rjmp _rx_ready_echo
	_rx_ready_sub:
		subi r16, 13
		rjmp _rx_ready_echo
	_rx_ready_echo:
		rcall uart0_write_char
		reti
.endif ; TEST_UART0
