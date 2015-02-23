;
; Elaborado en base a estas referencias
;
;     http://chrispurdie.com/wp-content/uploads/2012/12/7seg1_WEB.jpg
;     http://www.ascii-code.com/
;
; r16 <- ascii2display(r17)
;
; Coloca en r16 la  representación en display del valor ascii  r17, si r17 no
; es un valor ascii válido  imprimible, entonces coloca la representación de
; '?' en r16. Se debe llamar REQUIRE_ASCII2DISPLAY para expandir el código de
; manera global.
;
; Ciclos: 26-40
; Stack: 4
;

.macro REQUIRE_ASCII2DISPLAY
	rjmp _ascii2display_init

_ascii2display_table:
	;
	; El primer elemento de la tabla es ' ', el  valor ascii 0x20, pero
	; en realidad el primer elemento se direcciona con 0x0, entonces se
	; debe restar 0x20 o ' ' por este offset cuando se carga com lpm.
	;
	;   0bHABCDEFG, 0bHABCDEFG, 0bHABCDEFH, 0bHABCDEFG
	.db 0b00000000, 0b10100000, 0b00100010, 0b00110110 ; !"#
	.db 0b01001011, 0b01011010, 0b01101111, 0b00000010 ;$%&'
	.db 0b01001110, 0b01111000, 0b01100011, 0b00000111 ;()*+
	.db 0b00011000, 0b00000001, 0b10000000, 0b00100001 ;,-./
	.db 0b01111110, 0b00110000, 0b01101101, 0b01111001 ;0123
	.db 0b00110011, 0b01011011, 0b01011111, 0b01110000 ;4567
	.db 0b01111111, 0b01111011, 0b00001001, 0b00011001 ;89:;
	.db 0b01000011, 0b01000001, 0b01100001, 0b01100101 ;<=>?
	.db 0b01111101, 0b01110111, 0b00011111, 0b01001110 ;@ABC
	.db 0b00111101, 0b01001111, 0b01000111, 0b01011110 ;DEFG
	.db 0b00010111, 0b00000110, 0b00111100, 0b01010111 ;HIJK
	.db 0b00001110, 0b01010100, 0b01110110, 0b01111110 ;LMNO
	.db 0b01100111, 0b01110011, 0b01100110, 0b01011011 ;PQRS
	.db 0b00001111, 0b00111110, 0b00111010, 0b00101010 ;TUVW
	.db 0b00110111, 0b00111011, 0b01101001, 0b01001110 ;XYZ[
	.db 0b00000011, 0b01111000, 0b01100010, 0b00001000 ;\]^_
	.db 0b00100000                                     ;`abc

_ascii2display_init:
	push r17
	push ZL
	push ZH
	push r0


	; Caracteres antes del espacio ' ' no se pueden imprimir
	cpi r17, ' '                      ;  if (ascii < ' ')
		brlo _ascii2display_unk   ;      return unk;


	; Último caracter imprimible de la tabla básica de ASCII
	cpi r17, '~'
		brlo _ascii2display_known
		breq _ascii2display_last
		brge _ascii2display_unk


_ascii2display_known:
	cpi r17, 'a'          ;
	brlo PC+2             ; Corrige para letras minúsculas
	subi r17, 'a' - 'A'   ;


	;
	; Dado que  solo podemos imprimir  del ' ' en  adelante, reacomodamos
	; acorde a nuestra tabla trunca, ' ' empieza en 0x0, no en 0x20. Pero
	; antes guardamos  los registros que  usaremos en la pila  para poder
	; recuperarlos después.
	;

	clr r0
	ldi ZL,  low(2*_ascii2display_table)
	ldi ZH, high(2*_ascii2display_table)
	add ZL, r17
	adc ZH, r0
	sbiw ZL, ' ' ; Reacomoda a -0x20 por la tabla trunca
	lpm r16, Z   ; switch (r17) { case ' ': ... break; ... case 'A': ... }

	rjmp _ascii2display_end


_ascii2display_last:
	; En vez de cargar el valor de la tabla, lo hacemos inmediatamente
	ldi r16, 0b00000001
	rjmp _ascii2display_end


_ascii2display_unk:
	; En vez de cargar el valor de la tabla, lo hacemos inmediatamente
	ldi r16, 0b01100101
	rjmp _ascii2display_end


_ascii2display_end:
	pop r0
	pop ZH
	pop ZL
	pop r17
.endmacro
