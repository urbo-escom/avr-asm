-include $d/m48def.mk

#
# m48def.sh contains the register details  for the AVR Assembler constants and
# the parameters (register names and addresses) for the simulation.
#

$d/m48def.inc: $d/m48def.sh
	$< > $@

$d/m48def.mk: $d/m48def.sh
	$< --makefile > $@
