file := $d/ascii2display.avr
${file}.hex: AVRA := ${AVRA} -D TEST_ASCII2DISPLAY=1
${file}.fst: $f
${file}.fst: SIM_CYCLES := 3000
${file}.fst: SIM_REG += --register ${PORTB}
${file}.fst: SIM_REG += --register ${PORTD}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst


file := $d/display-mux.avr
${file}.hex: AVRA := ${AVRA} -D TEST_DISPLAY_MUX=1
${file}.fst: $f
${file}.fst: SIM_CYCLES := 3000
${file}.fst: SIM_REG += --register ${PORTB}
${file}.fst: SIM_REG += --register ${PORTD}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst


file := $d/uart0.avr
${file}.hex: AVRA := ${AVRA} -D TEST_UART0=1
${file}.hex: $f
AVR_HEX += ${file}.hex
