;
; Macros sobrecargadas
;
; El ensamblador avra tiene soporte para macros sobrecargadas, para declarar
; una macro de este modo, primero se debe definir la macro con su nombre
; simple, después se deben definir las sobrecargas como macros añadiendo
; uno o varios sufijos al nombre de la macro que indican su firma:
;
;     Sufijo _i
;         Valores inmediatos (constantes)
;
;     Sufijos _8,_16,_24,_32,_40,_48,_56,_64
;         Registros declarados con `.def`, _8 es un registro, _16 son dos, etc.
;
;     Sufijo _v
;         Para parámetros vacíos
;
; La sintaxis para invocar una macro sobrecargada es
;
;     macro_name [param0, param1, ..., paramN]
;
; Los parámetros pueden ser constantes, pueden estar vacíos o pueden ser
; conjuntos de registros separados por `:` como
;
;     macro_name [param0, temp0:temp1, temp2:temp3, temp0, temp0:temp3]
;
; Tal vez sea un bug, pero si  algún parametro no es reconocido como vacío o
; como un registro  entonces lo considera un valor inmediato,  lo cual permite
; pasar  instrucciones (algunas  incompletas) como  `out PORTB`  o `push  r16`
; mientras no contengan comas. Esto permite crear algunas macros interesantes.
;
; Ver:
;
;     http://avra.sourceforge.net/README.html#_macro_features
;


.ifdef  MACROS_AVR_INC
.else
.define MACROS_AVR_INC

;
; map_w [inst, a[:b[:c[:d]]]]
; map_w [inst, a[:b[:c[:d]]], d[:e[:f[:g]]]]]
; map_w [inst, a[:b[:c[:d]]], constant]
; map_w [inst, constant, a[:b[:c[:d]]]]
;
; En el  caso de  1 parámetro  aplica `inst` a  cada registro,  en caso  de 2
; parámetros aplica  `inst` al primer  registro del primer parámetro  con el
; primer registro del segundo parámetro, el segundo con el segundo, etc.
;
; El caso  de 3  parámetros es  igual que  para 2  excepto que  `constant` se
; divide en  tantas partes como  registros tenga  el otro parámetro,  el byte
; más  significativo  se aplica  con  el  primer  registro, el  segundo  más
; significativo con el segundo registro, etc.
;
	;------------------------------------------------------------------
	.macro map_w
		.message "Missing arguments for map_w"
	.endmacro
	;------------------------------------------------------------------
		.macro map_w_i_8
			@0 @1
		.endmacro
		.macro map_w_i_16
			@0 @1
			@0 @2
		.endmacro
		.macro map_w_i_24
			@0 @1
			@0 @2
			@0 @3
		.endmacro
		.macro map_w_i_32
			@0 @1
			@0 @2
			@0 @3
			@0 @4
		.endmacro
	;------------------------------------------------------------------
		.macro map_w_i_8_8
			@0 @1, @2
		.endmacro
		.macro map_w_i_16_16
			@0 @1, @3
			@0 @2, @4
		.endmacro
		.macro map_w_i_24_24
			@0 @1, @4
			@0 @2, @5
			@0 @3, @6
		.endmacro
		.macro map_w_i_32_32
			@0 @1, @5
			@0 @2, @6
			@0 @3, @7
			@0 @4, @8
		.endmacro
	;------------------------------------------------------------------
		.macro map_w_i_8_i
			@0 @1,   low(@2)
		.endmacro
		.macro map_w_i_16_i
			@0 @1,  high(@3)
			@0 @2,   low(@3)
		.endmacro
		.macro map_w_i_24_i
			@0 @1, byte3(@4)
			@0 @2,  high(@4)
			@0 @3,   low(@4)
		.endmacro
		.macro map_w_i_32_i
			@0 @1, byte4(@5)
			@0 @2, byte3(@5)
			@0 @3,  high(@5)
			@0 @4,   low(@5)
		.endmacro
	;------------------------------------------------------------------
		.macro map_w_i_i_8
			@0   low(@1), @2
		.endmacro
		.macro map_w_i_i_16
			@0  high(@1), @2
			@0   low(@1), @3
		.endmacro
		.macro map_w_i_i_24
			@0 byte3(@1), @2
			@0  high(@1), @3
			@0   low(@1), @4
		.endmacro
		.macro map_w_i_i_32
			@0 byte4(@1), @2
			@0 byte3(@1), @3
			@0  high(@1), @4
			@0   low(@1), @5
		.endmacro
	;------------------------------------------------------------------


;
; in_w  [a:[b:[c:[d]]], constant]
; out_w [constant, a:[b:[c:[d]]]]
; lds_w [a:[b:[c:[d]]], constant]
; sts_w [constant, a:[b:[c:[d]]]]
;
; Carga o guarda de SRAM, el tamaño  de la variable se obtiene del número de
; registros que  se pasen, `constant`  debe ser  la dirección del  byte menos
; significativo.
;
; Las  macros respetan  el  orden  de lectura/escritura  de  las variables  de
; 16-bits, que es leer el byte  menos significativo primero y escribir el byte
; más significativo primero.
;
	;------------------------------------------------------------------
	.macro in_w
		.message "Missing arguments for in_w"
	.endmacro
	;------------------------------------------------------------------
		.macro in_w_8_i
			in @0, @1 + 0
		.endmacro
	;------------------------------------------------------------------
		.macro in_w_16_i
			in @1, @2 + 0
			in @0, @2 + 1
		.endmacro
	;------------------------------------------------------------------
		.macro in_w_24_i
			in @2, @3 + 0
			in @1, @3 + 1
			in @0, @3 + 2
		.endmacro
	;------------------------------------------------------------------
		.macro in_w_32_i
			in @3, @4 + 0
			in @2, @4 + 1
			in @1, @4 + 2
			in @0, @4 + 3
		.endmacro
	;------------------------------------------------------------------
	;------------------------------------------------------------------
	.macro out_w
		.message "Missing arguments for out_w"
	.endmacro
	;------------------------------------------------------------------
		.macro out_w_i_8
			out @0 + 0, @1
		.endmacro
	;------------------------------------------------------------------
		.macro out_w_i_16
			out @0 + 1, @1
			out @0 + 0, @2
		.endmacro
	;------------------------------------------------------------------
		.macro out_w_i_24
			out @0 + 2, @1
			out @0 + 1, @2
			out @0 + 0, @3
		.endmacro
	;------------------------------------------------------------------
		.macro out_w_i_32
			out @0 + 3, @1
			out @0 + 2, @2
			out @0 + 1, @3
			out @0 + 0, @4
		.endmacro
	;------------------------------------------------------------------
	;------------------------------------------------------------------
	.macro lds_w
		.message "Missing arguments for lds_w"
	.endmacro
	;------------------------------------------------------------------
		.macro lds_w_8_i
			lds @0, @1 + 0
		.endmacro
	;------------------------------------------------------------------
		.macro lds_w_16_i
			lds @1, @2 + 0
			lds @0, @2 + 1
		.endmacro
	;------------------------------------------------------------------
		.macro lds_w_24_i
			lds @2, @3 + 0
			lds @1, @3 + 1
			lds @0, @3 + 2
		.endmacro
	;------------------------------------------------------------------
		.macro lds_w_32_i
			lds @3, @4 + 0
			lds @2, @4 + 1
			lds @1, @4 + 2
			lds @0, @4 + 3
		.endmacro
	;------------------------------------------------------------------
	;------------------------------------------------------------------
	.macro sts_w
		.message "Missing arguments for sts_w"
	.endmacro
	;------------------------------------------------------------------
		.macro sts_w_i_8
			sts @0 + 0, @1
		.endmacro
	;------------------------------------------------------------------
		.macro sts_w_i_16
			sts @0 + 1, @1
			sts @0 + 0, @2
		.endmacro
	;------------------------------------------------------------------
		.macro sts_w_i_24
			sts @0 + 2, @1
			sts @0 + 1, @2
			sts @0 + 0, @3
		.endmacro
	;------------------------------------------------------------------
		.macro sts_w_i_32
			sts @0 + 3, @1
			sts @0 + 2, @2
			sts @0 + 1, @3
			sts @0 + 0, @4
		.endmacro
	;------------------------------------------------------------------
	;------------------------------------------------------------------


;
; ldi_w [a[:b], const]
; ldi_w [a[:b], [inst0 op0, const0, ..., inst3 op3, const3]]
;
; Es  una forma  corta de  hacer múltiples  out's o  sts's usando  los mismos
; registros.
;
; En el caso de  2 parámetros carga una constante de 16  u 8 bits dependiendo
; del número de registros en el primer parámetro.
;
; En el caso de 2n  + 1 parámetros, con 1 <= n <= 4,  en donde cada insti sea
; out o sts, guarda consti en su  respectivo opi, cargando primero consti en 1
; o 2 registros dependiendo del número de registros en el primer parámetro y
; después guardando  a opi  de acuerdo  a insti.  Cuando se  especifiquen dos
; registros, cada opi  se considerará una variable de 16-bits  y se guardará
; el byte más significativo primero (opi + 1).
;
	;------------------------------------------------------------------
	;------------------------------------------------------------------
	.macro ldi_w
		.message "Missing arguments for ldi_w"
	.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_8_i
			ldi @0,  low(@1)
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_16_i
			ldi @0, high(@2)
			ldi @1,  low(@3)
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_8_i_i
			ldi @0, @2
			@1, @0
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_16_i_i
			ldi @0, high(@3)
			ldi @1,  low(@3)
			@2 + 1, @0
			@2 + 0, @1
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_8_i_i_i_i
			ldi_w [@0, @1, @2]
			ldi_w [@0, @3, @4]
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_16_i_i_i_i
			ldi_w [@0:@1, @2, @3]
			ldi_w [@0:@1, @4, @5]
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_8_i_i_i_i_i_i
			ldi_w [@0, @1, @2]
			ldi_w [@0, @3, @4]
			ldi_w [@0, @5, @6]
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_16_i_i_i_i_i_i
			ldi_w [@0:@1, @2, @3]
			ldi_w [@0:@1, @4, @5]
			ldi_w [@0:@1, @6, @7]
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_8_i_i_i_i_i_i_i_i
			ldi_w [@0, @1, @2]
			ldi_w [@0, @3, @4]
			ldi_w [@0, @5, @6]
			ldi_w [@0, @7, @8]
		.endmacro
	;------------------------------------------------------------------
		.macro ldi_w_16_i_i_i_i_i_i_i_i
			ldi_w [@0:@1, @2, @3]
			ldi_w [@0:@1, @4, @5]
			ldi_w [@0:@1, @6, @7]
			ldi_w [@0:@1, @8, @9]
		.endmacro
	;------------------------------------------------------------------
	;------------------------------------------------------------------


;
; Define todos los registros para  que funcionen con macros sobrecargadas. XL,
; XH, YL, YH, ZL  y ZH ya están definidas para r26, r27,  r28, r29, r30 y r31
; por lo que esos nombres deberían ser usados en vez de r26-r31.
;
; Ver:
;     http://sourceforge.net/p/avra/mailman/message/243266/
;     http://sourceforge.net/p/avra/bugs/27/
;
	;------------------------------------------------------------------
		.def r0=r0
		.def r1=r1
		.def r2=r2
		.def r3=r3
		.def r4=r4
		.def r5=r5
		.def r6=r6
		.def r7=r7
		.def r8=r8
		.def r9=r9
		.def r10=r10
		.def r11=r11
		.def r12=r12
		.def r13=r13
		.def r14=r14
		.def r15=r15
		.def r16=r16
		.def r17=r17
		.def r18=r18
		.def r19=r19
		.def r20=r20
		.def r21=r21
		.def r22=r22
		.def r23=r23
		.def r24=r24
		.def r25=r25
	;------------------------------------------------------------------

.endif ; MACROS_AVR_INC
