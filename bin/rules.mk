#
# Burn hex into avr device
#

AVRDUDE            ?= avrdude
AVRDUDE_PROGRAMMER ?= usbasp
AVR_MMCU_AVRDUDE   ?= m48pa

AVRDUDE_INSTALL = ${AVRDUDE} \
	-c ${AVRDUDE_PROGRAMMER} \
	-p ${AVR_MMCU_AVRDUDE} \
	-U flash:w:$<:i


#
# Compile avr code with AVRA
#

AVRA ?= avra
AVRA_LIB_ALL := lib
avra_inc_lib = $(strip $(foreach lib, $1, -I ${lib}))

%.hex: %.asm
	${AVRA} $(call avra_inc_lib, ${AVRA_LIB_ALL} ${AVRA_LIB}) $< && \
	${RM} $*.cof \
	${RM} $*.obj \
	${RM} $*.eep.hex


#
# Simulate avr code in an hex/elf  file with simavr, changing the timescale of
# the vcd  file to  micro-seconds (us)  because simavr  hardcodes nano-seconds
# (ns) in the file.
#

SIM_VCD      := $d/avr-sim
AVR_MMCU_SIM := atmega48

%.fst: %.vcd
	vcd2fst -v $< -f $@

%.vcd: %.elf ${SIM_VCD}
	${SIM_VCD} \
	--vcd $@ \
	--src $< \
	--mmcu ${AVR_MMCU_SIM} \
	--freq $(strip $(if ${SIM_FREQ},${SIM_FREQ}, 1000000L)) \
	--cycles $(strip $(if ${SIM_CYCLES}, ${SIM_CYCLES}, 1000L)) \
	$(strip ${SIM_REG}) && \
	sed -i "s/timescale 1ns/timescale 1us/; s/\(#.*\)000/\1/g" \
		$@

${SIM_VCD}: $d/avr-sim-main.c $d/avr-sim-arg.c
	gcc -Wall -Werror -static \
	-o $@ $^ \
	-lsimavr -lelf

$d/avr-sim-main.c: $d/avr-sim.h
$d/avr-sim-arg.c: $d/avr-sim.h


#
# If we  want to  simulate an  elf file  instead of  an hex  file, we  have to
# decompile the hex file into asm code and recompile it with avr-libc
#
# See avr-as --help in -mmcu option for more mmcu types
#

AVR_LD  ?= avr-ld
AVR_ASM ?= avr-as

AVR_MMCU_ASM     ?= avr4
AVR_MMCU_OBJDUMP ?= avr4

HEX_ASM := $d/hex2asm

%.elf: %.o
	${AVR_LD} \
	-o $@ $<

%.o: %.S
	${AVR_ASM} -mmcu=${AVR_MMCU_ASM} \
	-o $@ $<

%.S: %.hex ${HEX_ASM}
	${HEX_ASM} -m ${AVR_MMCU_OBJDUMP} \
	$< > $@
