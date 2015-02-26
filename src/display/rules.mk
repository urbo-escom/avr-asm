file := $d/display-message.avr
${file}.hex: ${SRC_DIR}/util/ascii2display.avr.asm
${file}.hex: ${SRC_DIR}/util/display-mux.avr.asm
${file}.fst: $f
${file}.fst: AVRA := ${AVRA} -D DEBUG=1
${file}.fst: SIM_CYCLES := 5000000L
${file}.fst: SIM_REG += --register ${PORTB}
${file}.fst: SIM_REG += --register ${PORTD}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst
