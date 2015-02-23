Leyendo un VCD
--------------

Los VCD's  producidos por `simavr` son  sencillos, aún así el  formato está
disponible en  Internet si se quiere  profundizar. Veamos un ejemplo  que solo
muestra señales lógicas (todas las  simulaciones de los códigos ensamblador
que hay aquí hasta la fecha son del tipo lógico).

El formato puede verse aqui:

http://web.archive.org/web/20120323132708/http://www.beyondttl.com/vcd.php

Las primeras partes  de un VCD comienzan  indicando la escala de  tiempo en la
que están:

	$timescale 1us $end

indica un micro segundo de escala,  después de otras declaraciones viene algo
similar a esto:

	$var wire 8 ! PINB $end
	$var wire 8 " DDRB $end
	$var wire 8 # PORTB $end
	$var wire 1 $ PC0 $end

que indican  tres señales de  8 bits y  una señal de  1 bit con  los nombres
PINB, DDRB, PORTB y PC0 en este  ejemplo, además declara que las señales son
identificadas con los caracteres simples  `!`, `"`, `#` y `$` respectivamente.
Estos últimos  caracteres son los  que veremos posteriormente en  el archivo,
hay que  notar que cuando las  señales son de  1 bit, éstas se  escriben sin
espacios al lado derecho de su valor, mientras que las de varios bits dejan un
espacio, por ejemplo:

	$dumpvars
	bxxxxxxxx !
	bxxxxxxxx "
	bxxxxxxxx #
	x$
	$end

marca que al  inicio de la simulación las cuatro  señales están indefinidas
(`x`). Luego  sigue el cuerpo  de la simulación o  la simulación en  sí, el
paso del tiempo viene marcado tomando  en cuenta el `$timescale` en una línea
así:

	#8

a la  cual le deben  seguir los  valores de la  señales que cambiaron  en ese
momento siguiendo el mismo formato  del `$dumpvars`. Si ninguna señal cambió
entonces no debería de existir esa marca de tiempo, es decir los VCD's marcan
los cambios  de las señales  (son Value Change Dumps)  no los valores  de las
señales en cada marca de tiempo. En concreto:

	$dumpvars
	bxxxxxxxx !
	bxxxxxxxx "
	bxxxxxxxx #
	x$
	$end
	#8
	b11111111 "
	#9
	b00000000 #
	#10
	b00000000 !
	1$
	#12
	0$

indica que al inicio de la simulación, los valores de `!`, `"`, `#` y `$` son
indefinidos, `"` se  mantiene indefinido hasta cambiar a `b11111111`  en 8 us,
`#` se mantiene indefinido hasta cambiar a `b00000000` en 9 us, `!` igual pero
hasta 10us y `$` cambia a `1` en 10 us y después a `0` en 12 us.
