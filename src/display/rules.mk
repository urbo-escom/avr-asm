file := $d/ascii2display.avr
${file}.hex: AVRA_LIB := $d
${file}.fst: $f
${file}.fst: $d/ascii2display.avr.inc
${file}.fst: SIM_CYCLES := 3000
${file}.fst: SIM_REG += --register ${PORTB}
${file}.fst: SIM_REG += --register ${PORTD}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst


file := $d/display-message.avr
${file}.hex: AVRA_LIB := $d
${file}.hex: $d/ascii2display.avr.inc
${file}.hex: $d/display-mux.avr.inc
${file}.fst: $f
${file}.fst: AVRA := ${AVRA} -D DEBUG=1
${file}.fst: SIM_CYCLES := 5000000L
${file}.fst: SIM_REG += --register ${PORTB}
${file}.fst: SIM_REG += --register ${PORTD}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst


file := $d/display-mux.avr
${file}.hex: AVRA_LIB := $d
${file}.hex: ${file}.inc
${file}.fst: $f
${file}.fst: SIM_CYCLES := 3000
${file}.fst: SIM_REG += --register ${PORTB}
${file}.fst: SIM_REG += --register ${PORTD}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst
