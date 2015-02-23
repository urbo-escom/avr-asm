AVR Assembler
-------------

Códigos de  lenguaje ensamblador para  AVR's. A  menos que se  especifique lo
contrario, todos los ejemplos asumen:


 - Uso del atmega48/atmega48p/atmega48pa
 - Frequencia de reloj de 1 Mhz. (1 us por ciclo)


El código viene acompañado (cuando sea  aplicable) de un `.hex` y un `.fst`,
los `.hex` se pueden quemar directamente  al microcontrolador y los `.fst` son
simulaciones que pueden ser vistas en  [GTKWave] o cualquier otro programa que
lea Fast Simulation  Traces. Para hacer nuevas simulaciones  se requiere linux
(ver más abajo).


Cuando  se hable  de  la hoja  de  datos, se  habla de  esta  [hoja] de  datos
específicamente, algunas notas útiles de  Atmel se han coleccionado en forma
de script en [doc/atmel-doc.sh](doc/atmel-doc.sh).


[VCD]: doc/vcd.md
[hoja]: http://www.atmel.com/images/doc2545.pdf
[GTKWave]: http://gtkwave.sourceforge.net/


Ensamblar y Simular (solo en linux)
-----------------------------------
Los programas usados para ensamblar y simular son:

   - [avra]
   - [simavr]
   - [avr-libc]
   - [GTKWave]

Para  ensamblar se  necesita [avra]  y  para simular  se usa  la librería  de
[simavr],  por  el momento  solo  simula  `.elf`  creados por  [avr-libc],  el
programa tiene fallas con archivos `.hex`,  la librería de [simavr] sí puede
correrlos, el problema está en el programa no en la librería.


Hay diferencias entre [avra] y el ensamblador  de Atmel, así que si se quiere
usar el de Atmel hay que  cambiar varias partes de los códigos, [avra-readme]
explica las diferencias.


La  manera más  fácil para  saber como  usar el  programa de  simulación es
corriendo Make  y viendo la  invocación del programa porque  falta documentar
las opciones.


De la simulación, se genera un archivo `.vcd` pero este se convierte a `.fst`
usando el programa `vcd2fst` incluido con [GTKWave].


En teoría  [avra] y [simavr]  pueden ser  compilados en Windows  y [avr-libc]
está disponible  como [WinAVR],  por lo  que también  se podría  usar todo,
exactamente como está, en Windows.


Para agregar más simulaciones consulta el [Makefile](Makefile) y los archivos
`rules.mk`, como [examples/rules.mk](examples/rules.mk).


[avra]: http://avra.sourceforge.net/
[avra-readme]: http://avra.sourceforge.net/README.html
[simavr]: https://github.com/buserror/simavr
[avr-libc]: http://www.nongnu.org/avr-libc/
[WinAVR]: http://sourceforge.net/projects/winavr/files/


[bin/](bin/)
------------

   - [avr-sim](bin/avr-sim-main.c), simulador [simavr], por ahora solo
   simula archivos `.elf`.

   - [hex2asm](bin/hex2asm),  un desensamblador  que usa la  salida de
   `avr-objdump`  junto con  `grep` y  `awk` para  generar ensamblador
   compatible con  `avr-as` que a  su vez, junto con  `avr-ld`, genera
   archivos `.elf`.
