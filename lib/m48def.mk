# # Memory #


# # 11.1 Interrupt Vectors in ATmega48




# # Registers #




# # Extended #

UDR0 := --addr 0xC6 --name UDR0
UBRR0H := --addr 0xC5 --name UBRR0H
UBRR0L := --addr 0xC4 --name UBRR0L


UCSR0C := --addr 0xC2 --name UCSR0C
UMSEL01 := --addr 0xC2:7 --name UMSEL01
UMSEL00 := --addr 0xC2:6 --name UMSEL00
UPM01 := --addr 0xC2:5 --name UPM01
UPM00 := --addr 0xC2:4 --name UPM00
USBS0 := --addr 0xC2:3 --name USBS0
UCSZ01 := --addr 0xC2:2 --name UCSZ01
UCSZ00 := --addr 0xC2:1 --name UCSZ00
UCPOL0 := --addr 0xC2:0 --name UCPOL0
UDORD0 := --addr 0xC2:2 --name UDORD0
UCPHA0 := --addr 0xC2:1 --name UCPHA0
UCSR0B := --addr 0xC1 --name UCSR0B
RXCIE0 := --addr 0xC1:7 --name RXCIE0
TXCIE0 := --addr 0xC1:6 --name TXCIE0
UDRIE0 := --addr 0xC1:5 --name UDRIE0
RXEN0 := --addr 0xC1:4 --name RXEN0
TXEN0 := --addr 0xC1:3 --name TXEN0
UCSZ02 := --addr 0xC1:2 --name UCSZ02
RXB80 := --addr 0xC1:1 --name RXB80
TXB80 := --addr 0xC1:0 --name TXB80
UCSR0A := --addr 0xC0 --name UCSR0A
RXC0 := --addr 0xC0:7 --name RXC0
TXC0 := --addr 0xC0:6 --name TXC0
UDRE0 := --addr 0xC0:5 --name UDRE0
FE0 := --addr 0xC0:4 --name FE0
DOR0 := --addr 0xC0:3 --name DOR0
UPE0 := --addr 0xC0:2 --name UPE0
U2X0 := --addr 0xC0:1 --name U2X0
MPCM0 := --addr 0xC0:0 --name MPCM0


TWAMR := --addr 0xBD --name TWAMR
TWAM6 := --addr 0xBD:7 --name TWAM6
TWAM5 := --addr 0xBD:6 --name TWAM5
TWAM4 := --addr 0xBD:5 --name TWAM4
TWAM3 := --addr 0xBD:4 --name TWAM3
TWAM2 := --addr 0xBD:3 --name TWAM2
TWAM1 := --addr 0xBD:2 --name TWAM1
TWAM0 := --addr 0xBD:1 --name TWAM0
TWCR := --addr 0xBC --name TWCR
TWINT := --addr 0xBC:7 --name TWINT
TWEA := --addr 0xBC:6 --name TWEA
TWSTA := --addr 0xBC:5 --name TWSTA
TWSTO := --addr 0xBC:4 --name TWSTO
TWWC := --addr 0xBC:3 --name TWWC
TWEN := --addr 0xBC:2 --name TWEN
TWIE := --addr 0xBC:0 --name TWIE
TWDR := --addr 0xBB --name TWDR
TWAR := --addr 0xBA --name TWAR
TWA6 := --addr 0xBA:7 --name TWA6
TWA5 := --addr 0xBA:6 --name TWA5
TWA4 := --addr 0xBA:5 --name TWA4
TWA3 := --addr 0xBA:4 --name TWA3
TWA2 := --addr 0xBA:3 --name TWA2
TWA1 := --addr 0xBA:2 --name TWA1
TWA0 := --addr 0xBA:1 --name TWA0
TWGCE := --addr 0xBA:0 --name TWGCE
TWSR := --addr 0xB9 --name TWSR
TWS7 := --addr 0xB9:7 --name TWS7
TWS6 := --addr 0xB9:6 --name TWS6
TWS5 := --addr 0xB9:5 --name TWS5
TWS4 := --addr 0xB9:4 --name TWS4
TWS3 := --addr 0xB9:3 --name TWS3
TWPS1 := --addr 0xB9:1 --name TWPS1
TWPS0 := --addr 0xB9:0 --name TWPS0
TWBR := --addr 0xB8 --name TWBR


ASSR := --addr 0xB6 --name ASSR
EXCLK := --addr 0xB6:6 --name EXCLK
AS2 := --addr 0xB6:5 --name AS2
TCN2UB := --addr 0xB6:4 --name TCN2UB
OCR2AUB := --addr 0xB6:3 --name OCR2AUB
OCR2BUB := --addr 0xB6:2 --name OCR2BUB
TCR2AUB := --addr 0xB6:1 --name TCR2AUB
TCR2BUB := --addr 0xB6:0 --name TCR2BUB


OCR2B := --addr 0xB4 --name OCR2B
OCR2A := --addr 0xB3 --name OCR2A
TCNT2 := --addr 0xB2 --name TCNT2
TCCR2B := --addr 0xB1 --name TCCR2B
FOC2A := --addr 0xB1:7 --name FOC2A
FOC2B := --addr 0xB1:6 --name FOC2B
WGM22 := --addr 0xB1:3 --name WGM22
CS22 := --addr 0xB1:2 --name CS22
CS21 := --addr 0xB1:1 --name CS21
CS20 := --addr 0xB1:0 --name CS20
TCCR2A := --addr 0xB0 --name TCCR2A
COM2A1 := --addr 0xB0:7 --name COM2A1
COM2A0 := --addr 0xB0:6 --name COM2A0
COM2B1 := --addr 0xB0:5 --name COM2B1
COM2B0 := --addr 0xB0:4 --name COM2B0
WGM21 := --addr 0xB0:1 --name WGM21
WGM20 := --addr 0xB0:0 --name WGM20


OCR1BH := --addr 0x8B --name OCR1BH
OCR1BL := --addr 0x8A --name OCR1BL
OCR1AH := --addr 0x89 --name OCR1AH
OCR1AL := --addr 0x88 --name OCR1AL
ICR1H := --addr 0x87 --name ICR1H
ICR1L := --addr 0x86 --name ICR1L
TCNT1H := --addr 0x85 --name TCNT1H
TCNT1L := --addr 0x84 --name TCNT1L


TCCR1C := --addr 0x82 --name TCCR1C
FOC1A := --addr 0x82:7 --name FOC1A
FOC1B := --addr 0x82:6 --name FOC1B
TCCR1B := --addr 0x81 --name TCCR1B
ICNC1 := --addr 0x81:7 --name ICNC1
ICES1 := --addr 0x81:6 --name ICES1
WGM13 := --addr 0x81:4 --name WGM13
WGM12 := --addr 0x81:3 --name WGM12
CS12 := --addr 0x81:2 --name CS12
CS11 := --addr 0x81:1 --name CS11
CS10 := --addr 0x81:0 --name CS10
TCCR1A := --addr 0x80 --name TCCR1A
COM1A1 := --addr 0x80:7 --name COM1A1
COM1A0 := --addr 0x80:6 --name COM1A0
COM1B1 := --addr 0x80:5 --name COM1B1
COM1B0 := --addr 0x80:4 --name COM1B0
WGM11 := --addr 0x80:1 --name WGM11
WGM10 := --addr 0x80:0 --name WGM10
DIDR1 := --addr 0x7F --name DIDR1
AIN1D := --addr 0x7F:1 --name AIN1D
AIN0D := --addr 0x7F:0 --name AIN0D
DIDR0 := --addr 0x7E --name DIDR0
ADC5D := --addr 0x7E:5 --name ADC5D
ADC4D := --addr 0x7E:4 --name ADC4D
ADC3D := --addr 0x7E:3 --name ADC3D
ADC2D := --addr 0x7E:2 --name ADC2D
ADC1D := --addr 0x7E:1 --name ADC1D
ADC0D := --addr 0x7E:0 --name ADC0D


ADMUX := --addr 0x7C --name ADMUX
REFS1 := --addr 0x7C:7 --name REFS1
REFS0 := --addr 0x7C:6 --name REFS0
ADLAR := --addr 0x7C:5 --name ADLAR
MUX3 := --addr 0x7C:3 --name MUX3
MUX2 := --addr 0x7C:2 --name MUX2
MUX1 := --addr 0x7C:1 --name MUX1
MUX0 := --addr 0x7C:0 --name MUX0
ADCSRB := --addr 0x7B --name ADCSRB
ACME := --addr 0x7B:6 --name ACME
ADTS2 := --addr 0x7B:2 --name ADTS2
ADTS1 := --addr 0x7B:1 --name ADTS1
ADTS0 := --addr 0x7B:0 --name ADTS0
ADCSRA := --addr 0x7A --name ADCSRA
ADEN := --addr 0x7A:7 --name ADEN
ADSC := --addr 0x7A:6 --name ADSC
ADATE := --addr 0x7A:5 --name ADATE
ADIF := --addr 0x7A:4 --name ADIF
ADIE := --addr 0x7A:3 --name ADIE
ADPS2 := --addr 0x7A:2 --name ADPS2
ADPS1 := --addr 0x7A:1 --name ADPS1
ADPS0 := --addr 0x7A:0 --name ADPS0
ADCH := --addr 0x79 --name ADCH
ADCL := --addr 0x78 --name ADCL


TIMSK2 := --addr 0x70 --name TIMSK2
OCIE2B := --addr 0x70:2 --name OCIE2B
OCIE2A := --addr 0x70:1 --name OCIE2A
TOIE2 := --addr 0x70:0 --name TOIE2
TIMSK1 := --addr 0x6F --name TIMSK1
ICIE1 := --addr 0x6F:5 --name ICIE1
OCIE1B := --addr 0x6F:2 --name OCIE1B
OCIE1A := --addr 0x6F:1 --name OCIE1A
TOIE1 := --addr 0x6F:0 --name TOIE1
TIMSK0 := --addr 0x6E --name TIMSK0
OCIE0B := --addr 0x6E:2 --name OCIE0B
OCIE0A := --addr 0x6E:1 --name OCIE0A
TOIE0 := --addr 0x6E:0 --name TOIE0
PCMSK2 := --addr 0x6D --name PCMSK2
PCINT23 := --addr 0x6D:7 --name PCINT23
PCINT22 := --addr 0x6D:6 --name PCINT22
PCINT21 := --addr 0x6D:5 --name PCINT21
PCINT20 := --addr 0x6D:4 --name PCINT20
PCINT19 := --addr 0x6D:3 --name PCINT19
PCINT18 := --addr 0x6D:2 --name PCINT18
PCINT17 := --addr 0x6D:1 --name PCINT17
PCINT16 := --addr 0x6D:0 --name PCINT16
PCMSK1 := --addr 0x6C --name PCMSK1
PCINT14 := --addr 0x6C:6 --name PCINT14
PCINT13 := --addr 0x6C:5 --name PCINT13
PCINT12 := --addr 0x6C:4 --name PCINT12
PCINT11 := --addr 0x6C:3 --name PCINT11
PCINT10 := --addr 0x6C:2 --name PCINT10
PCINT9 := --addr 0x6C:1 --name PCINT9
PCINT8 := --addr 0x6C:0 --name PCINT8
PCMSK0 := --addr 0x6B --name PCMSK0
PCINT7 := --addr 0x6B:7 --name PCINT7
PCINT6 := --addr 0x6B:6 --name PCINT6
PCINT5 := --addr 0x6B:5 --name PCINT5
PCINT4 := --addr 0x6B:4 --name PCINT4
PCINT3 := --addr 0x6B:3 --name PCINT3
PCINT2 := --addr 0x6B:2 --name PCINT2
PCINT1 := --addr 0x6B:1 --name PCINT1
PCINT0 := --addr 0x6B:0 --name PCINT0


EICRA := --addr 0x69 --name EICRA
ISC11 := --addr 0x69:3 --name ISC11
ISC10 := --addr 0x69:2 --name ISC10
ISC01 := --addr 0x69:1 --name ISC01
ISC00 := --addr 0x69:0 --name ISC00
PCICR := --addr 0x68 --name PCICR
PCIE2 := --addr 0x68:2 --name PCIE2
PCIE1 := --addr 0x68:1 --name PCIE1
PCIE0 := --addr 0x68:0 --name PCIE0


OSCCAL := --addr 0x66 --name OSCCAL


PRR := --addr 0x64 --name PRR
PRTWI := --addr 0x64:7 --name PRTWI
PRTIM2 := --addr 0x64:6 --name PRTIM2
PRTIM0 := --addr 0x64:5 --name PRTIM0
PRTIM1 := --addr 0x64:3 --name PRTIM1
PRSPI := --addr 0x64:2 --name PRSPI
PRUSART0 := --addr 0x64:1 --name PRUSART0
PRADC := --addr 0x64:0 --name PRADC


CLKPR := --addr 0x61 --name CLKPR
CLKPCE := --addr 0x61:7 --name CLKPCE
CLKPS3 := --addr 0x61:3 --name CLKPS3
CLKPS2 := --addr 0x61:2 --name CLKPS2
CLKPS1 := --addr 0x61:1 --name CLKPS1
CLKPS0 := --addr 0x61:0 --name CLKPS0
WDTCSR := --addr 0x60 --name WDTCSR
WDIF := --addr 0x60:7 --name WDIF
WDIE := --addr 0x60:6 --name WDIE
WDP3 := --addr 0x60:5 --name WDP3
WDCE := --addr 0x60:4 --name WDCE
WDE := --addr 0x60:3 --name WDE
WDP2 := --addr 0x60:2 --name WDP2
WDP1 := --addr 0x60:1 --name WDP1
WDP0 := --addr 0x60:0 --name WDP0


# # IO #


SREG := --addr 0x5F --name SREG
SREG_I := --addr 0x5F:7 --name SREG_I
SREG_T := --addr 0x5F:6 --name SREG_T
SREG_H := --addr 0x5F:5 --name SREG_H
SREG_S := --addr 0x5F:4 --name SREG_S
SREG_V := --addr 0x5F:3 --name SREG_V
SREG_N := --addr 0x5F:2 --name SREG_N
SREG_Z := --addr 0x5F:1 --name SREG_Z
SREG_C := --addr 0x5F:0 --name SREG_C
SPH := --addr 0x5E --name SPH
SP9 := --addr 0x5E:1 --name SP9
SP8 := --addr 0x5E:0 --name SP8
SPL := --addr 0x5D --name SPL
SP7 := --addr 0x5D:7 --name SP7
SP6 := --addr 0x5D:6 --name SP6
SP5 := --addr 0x5D:5 --name SP5
SP4 := --addr 0x5D:4 --name SP4
SP3 := --addr 0x5D:3 --name SP3
SP2 := --addr 0x5D:2 --name SP2
SP1 := --addr 0x5D:1 --name SP1
SP0 := --addr 0x5D:0 --name SP0


SPMCSR := --addr 0x57 --name SPMCSR
SPMIE := --addr 0x57:7 --name SPMIE
SIGRD := --addr 0x57:5 --name SIGRD
BLBSET := --addr 0x57:3 --name BLBSET
PGWRT := --addr 0x57:2 --name PGWRT
PGERS := --addr 0x57:1 --name PGERS
SPMEN := --addr 0x57:0 --name SPMEN


MCUCR := --addr 0x55 --name MCUCR
BODS := --addr 0x55:6 --name BODS
BODSE := --addr 0x55:5 --name BODSE
PUD := --addr 0x55:4 --name PUD
IVSEL := --addr 0x55:1 --name IVSEL
IVCE := --addr 0x55:0 --name IVCE
MCUSR := --addr 0x54 --name MCUSR
WDRF := --addr 0x54:3 --name WDRF
BORF := --addr 0x54:2 --name BORF
EXTRF := --addr 0x54:1 --name EXTRF
PORF := --addr 0x54:0 --name PORF
SMCR := --addr 0x53 --name SMCR
SM2 := --addr 0x53:3 --name SM2
SM1 := --addr 0x53:2 --name SM1
SM0 := --addr 0x53:1 --name SM0
SE := --addr 0x53:0 --name SE


ACSR := --addr 0x50 --name ACSR
ACD := --addr 0x50:7 --name ACD
ACBG := --addr 0x50:6 --name ACBG
ACO := --addr 0x50:5 --name ACO
ACI := --addr 0x50:4 --name ACI
ACIE := --addr 0x50:3 --name ACIE
ACIC := --addr 0x50:2 --name ACIC
ACIS1 := --addr 0x50:1 --name ACIS1
ACIS0 := --addr 0x50:0 --name ACIS0


SPDR := --addr 0x4E --name SPDR
SPSR := --addr 0x4D --name SPSR
SPIF := --addr 0x4D:7 --name SPIF
WCOL := --addr 0x4D:6 --name WCOL
SPI2X := --addr 0x4D:0 --name SPI2X
SPCR := --addr 0x4C --name SPCR
SPIE := --addr 0x4C:7 --name SPIE
SPE := --addr 0x4C:6 --name SPE
DORD := --addr 0x4C:5 --name DORD
MSTR := --addr 0x4C:4 --name MSTR
CPOL := --addr 0x4C:3 --name CPOL
CPHA := --addr 0x4C:2 --name CPHA
SPR1 := --addr 0x4C:1 --name SPR1
SPR0 := --addr 0x4C:0 --name SPR0
GPIOR2 := --addr 0x4B --name GPIOR2
GPIOR1 := --addr 0x4A --name GPIOR1


OCR0B := --addr 0x48 --name OCR0B
OCR0A := --addr 0x47 --name OCR0A
TCNT0 := --addr 0x46 --name TCNT0
TCCR0B := --addr 0x45 --name TCCR0B
FOC0A := --addr 0x45:7 --name FOC0A
FOC0B := --addr 0x45:6 --name FOC0B
WGM02 := --addr 0x45:3 --name WGM02
CS02 := --addr 0x45:2 --name CS02
CS01 := --addr 0x45:1 --name CS01
CS00 := --addr 0x45:0 --name CS00
TCCR0A := --addr 0x44 --name TCCR0A
COM0A1 := --addr 0x44:7 --name COM0A1
COM0A0 := --addr 0x44:6 --name COM0A0
COM0B1 := --addr 0x44:5 --name COM0B1
COM0B0 := --addr 0x44:4 --name COM0B0
WGM01 := --addr 0x44:1 --name WGM01
WGM00 := --addr 0x44:0 --name WGM00
GTCCR := --addr 0x43 --name GTCCR
TSM := --addr 0x43:7 --name TSM
PSRASY := --addr 0x43:1 --name PSRASY
PSRSYNC := --addr 0x43:0 --name PSRSYNC
EEARH := --addr 0x42 --name EEARH
EEARL := --addr 0x41 --name EEARL
EEDR := --addr 0x40 --name EEDR


EECR := --addr 0x3F --name EECR
EEPM1 := --addr 0x3F:5 --name EEPM1
EEPM0 := --addr 0x3F:4 --name EEPM0
EERIE := --addr 0x3F:3 --name EERIE
EEMPE := --addr 0x3F:2 --name EEMPE
EEPE := --addr 0x3F:1 --name EEPE
EERE := --addr 0x3F:0 --name EERE
GPIOR0 := --addr 0x3E --name GPIOR0
EIMSK := --addr 0x3D --name EIMSK
INT1 := --addr 0x3D:1 --name INT1
INT0 := --addr 0x3D:0 --name INT0
EIFR := --addr 0x3C --name EIFR
INTF1 := --addr 0x3C:1 --name INTF1
INTF0 := --addr 0x3C:0 --name INTF0
PCIFR := --addr 0x3B --name PCIFR
PCIF2 := --addr 0x3B:2 --name PCIF2
PCIF1 := --addr 0x3B:1 --name PCIF1
PCIF0 := --addr 0x3B:0 --name PCIF0


TIFR2 := --addr 0x37 --name TIFR2
OCF2B := --addr 0x37:2 --name OCF2B
OCF2A := --addr 0x37:1 --name OCF2A
TOV2 := --addr 0x37:0 --name TOV2
TIFR1 := --addr 0x36 --name TIFR1
ICF1 := --addr 0x36:5 --name ICF1
OCF1B := --addr 0x36:2 --name OCF1B
OCF1A := --addr 0x36:1 --name OCF1A
TOV1 := --addr 0x36:0 --name TOV1
TIFR0 := --addr 0x35 --name TIFR0
OCF0B := --addr 0x35:2 --name OCF0B
OCF0A := --addr 0x35:1 --name OCF0A
TOV0 := --addr 0x35:0 --name TOV0


PORTD := --addr 0x2B --name PORTD
PORTD7 := --addr 0x2B:7 --name PORTD7
PORTD6 := --addr 0x2B:6 --name PORTD6
PORTD5 := --addr 0x2B:5 --name PORTD5
PORTD4 := --addr 0x2B:4 --name PORTD4
PORTD3 := --addr 0x2B:3 --name PORTD3
PORTD2 := --addr 0x2B:2 --name PORTD2
PORTD1 := --addr 0x2B:1 --name PORTD1
PORTD0 := --addr 0x2B:0 --name PORTD0
DDRD := --addr 0x2A --name DDRD
DDD7 := --addr 0x2A:7 --name DDD7
DDD6 := --addr 0x2A:6 --name DDD6
DDD5 := --addr 0x2A:5 --name DDD5
DDD4 := --addr 0x2A:4 --name DDD4
DDD3 := --addr 0x2A:3 --name DDD3
DDD2 := --addr 0x2A:2 --name DDD2
DDD1 := --addr 0x2A:1 --name DDD1
DDD0 := --addr 0x2A:0 --name DDD0
PIND := --addr 0x29 --name PIND
PIND7 := --addr 0x29:7 --name PIND7
PIND6 := --addr 0x29:6 --name PIND6
PIND5 := --addr 0x29:5 --name PIND5
PIND4 := --addr 0x29:4 --name PIND4
PIND3 := --addr 0x29:3 --name PIND3
PIND2 := --addr 0x29:2 --name PIND2
PIND1 := --addr 0x29:1 --name PIND1
PIND0 := --addr 0x29:0 --name PIND0


PORTC := --addr 0x28 --name PORTC
PORTC6 := --addr 0x28:6 --name PORTC6
PORTC5 := --addr 0x28:5 --name PORTC5
PORTC4 := --addr 0x28:4 --name PORTC4
PORTC3 := --addr 0x28:3 --name PORTC3
PORTC2 := --addr 0x28:2 --name PORTC2
PORTC1 := --addr 0x28:1 --name PORTC1
PORTC0 := --addr 0x28:0 --name PORTC0
DDRC := --addr 0x27 --name DDRC
DDC6 := --addr 0x27:6 --name DDC6
DDC5 := --addr 0x27:5 --name DDC5
DDC4 := --addr 0x27:4 --name DDC4
DDC3 := --addr 0x27:3 --name DDC3
DDC2 := --addr 0x27:2 --name DDC2
DDC1 := --addr 0x27:1 --name DDC1
DDC0 := --addr 0x27:0 --name DDC0
PINC := --addr 0x26 --name PINC
PINC6 := --addr 0x26:6 --name PINC6
PINC5 := --addr 0x26:5 --name PINC5
PINC4 := --addr 0x26:4 --name PINC4
PINC3 := --addr 0x26:3 --name PINC3
PINC2 := --addr 0x26:2 --name PINC2
PINC1 := --addr 0x26:1 --name PINC1
PINC0 := --addr 0x26:0 --name PINC0


PORTB := --addr 0x25 --name PORTB
PORTB7 := --addr 0x25:7 --name PORTB7
PORTB6 := --addr 0x25:6 --name PORTB6
PORTB5 := --addr 0x25:5 --name PORTB5
PORTB4 := --addr 0x25:4 --name PORTB4
PORTB3 := --addr 0x25:3 --name PORTB3
PORTB2 := --addr 0x25:2 --name PORTB2
PORTB1 := --addr 0x25:1 --name PORTB1
PORTB0 := --addr 0x25:0 --name PORTB0
DDRB := --addr 0x24 --name DDRB
DDB7 := --addr 0x24:7 --name DDB7
DDB6 := --addr 0x24:6 --name DDB6
DDB5 := --addr 0x24:5 --name DDB5
DDB4 := --addr 0x24:4 --name DDB4
DDB3 := --addr 0x24:3 --name DDB3
DDB2 := --addr 0x24:2 --name DDB2
DDB1 := --addr 0x24:1 --name DDB1
DDB0 := --addr 0x24:0 --name DDB0
PINB := --addr 0x23 --name PINB
PINB7 := --addr 0x23:7 --name PINB7
PINB6 := --addr 0x23:6 --name PINB6
PINB5 := --addr 0x23:5 --name PINB5
PINB4 := --addr 0x23:4 --name PINB4
PINB3 := --addr 0x23:3 --name PINB3
PINB2 := --addr 0x23:2 --name PINB2
PINB1 := --addr 0x23:1 --name PINB1
PINB0 := --addr 0x23:0 --name PINB0
