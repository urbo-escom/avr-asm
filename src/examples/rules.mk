file := $d/00_counter.avr
${file}.fst: $f
${file}.fst: SIM_CYCLES := 100
${file}.fst: SIM_REG += --register ${DDRB}
${file}.fst: SIM_REG += --register ${PORTB}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst


file := $d/01_counter-with-vars.avr
${file}.fst: $f
${file}.fst: SIM_CYCLES := 1000000
${file}.fst: SIM_REG := --register ${PORTB7}
${file}.fst: SIM_REG += --register ${PORTB6}
${file}.fst: SIM_REG += --register ${PORTB5}
${file}.fst: SIM_REG += --register ${PORTB4}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst


file := $d/02_string.avr
${file}.fst: $f
${file}.fst: SIM_CYCLES := 500
${file}.fst: SIM_REG := --register ${PORTB}
${file}.fst: SIM_REG += --register ${PORTD}
AVR_HEX += ${file}.hex
AVR_FST += ${file}.fst
