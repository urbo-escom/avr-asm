#!/bin/sh
#
# This script generates include files for the AVR Assembler (avra) and command
# line parameters, as makefile variables, for the simavr-based simulator.
#
# In assembly:
#
#     .equ NAME = VALUE for memory/extended/io/bits
#     .def NAME = REG for registers
#
# In makefiles:
#
#     NAME := --addr VALUE --name NAME for extended/io
#     NAME := --addr VALUE:BIT --name NAME for bits
#

if [ "$1" = "--makefile" ]; then
	print_comment='printf "# "; print'
	print_memory=''
	print_register=''
	print_extended='print $2 " := --addr " $1 " --name " $2'
	print_io='print $2 " := --addr " $1 " --name " $2'
	print_bit='print $i " := --addr " $1 ":" (10 - i) " --name " $i'
else
	echo ".device ATmega48"
	print_comment='printf "; "; print'
	print_memory='print ".equ " $1 " = (" $3 ")"'
	print_register='print ".def " $1 " = " $3'
	print_extended='print ".equ " $2 " = (" $1 ")"'
	print_io='print ".equ " $2 " = (" $1 " - 0x20)"'
	print_bit='print "\t.equ " $i " = (" (10 - i) ")"'
fi

awk_script='
BEGIN {
	memory = 0;
	register = 0;
	extended = 0;
	io = 0;
}

/^# Memory #$/    { memory = 1; register = 0; extended = 0; io = 0; }
/^# Registers #$/ { memory = 0; register = 1; extended = 0; io = 0; }
/^# Extended #$/  { memory = 0; register = 0; extended = 1; io = 0; }
/^# IO #$/        { memory = 0; register = 0; extended = 0; io = 1; }

3 == NF && !/^#/ && memory   { '${print_memory}'; }
3 == NF && !/^#/ && register { '${print_register}'; }
2 == NF && !/^#/ && extended { '${print_extended}'; }
2 == NF && !/^#/ && io       { '${print_io}'; }

10 == NF && !/^#/ && extended {
	if ("-" != $2)
		'${print_extended}';
	for (i = 3; i <= 10; i++)
		if ($i != "-")
			'${print_bit}';
}
10 == NF && !/^#/ && io       {
	if ("-" != $2)
		'${print_io}';
	for (i = 3; i <= 10; i++)
		if ($i != "-")
			'${print_bit}';
}

/^$/ { print; }

/^#/{ '${print_comment}'; }
'

cat << EOF | awk "${awk_script}"
# Memory #


# 11.1 Interrupt Vectors in ATmega48

RESET_int        = 0x000
INT0_int         = 0x001
INT1_int         = 0x002
PCINT0_int       = 0x003
PCINT1_int       = 0x004
PCINT2_int       = 0x005
WDT_int          = 0x006
TIMER2_COMPA_int = 0x007
TIMER2_COMPB_int = 0x008
TIMER2_OVF_int   = 0x009
TIMER1_CAPT_int  = 0x00A
TIMER1_COMPA_int = 0x00B
TIMER1_COMPB_int = 0x00C
TIMER1_OVF_int   = 0x00D
TIMER0_COMPA_int = 0x00E
TIMER0_COMPB_int = 0x00F
TIMER0_OVF_int   = 0x010
SPI_STC_int      = 0x011
USART_RX_int     = 0x012
USART_UDRE_int   = 0x013
USART_TX_int     = 0x014
ADC_int          = 0x015
EE_READY_int     = 0x016
ANALOG_COMP_int  = 0x017
TWI_int          = 0x018
SPM_READY_int    = 0x019


IOEND   = 0x0ff
RAMSIZE = 0x200
RAMEND  = 0x2ff

# Registers #

XL = r26
XH = r27

YL = r28
YH = r29

ZL = r30
ZH = r31

# Extended #

0xC6     UDR0
0xC5   UBRR0H
0xC4   UBRR0L


0xC2   UCSR0C UMSEL01 UMSEL00   UPM01   UPM00   USBS0  UCSZ01  UCSZ00  UCPOL0
0xC2        -       -       -       -       -       -  UDORD0  UCPHA0       -
0xC1   UCSR0B  RXCIE0  TXCIE0  UDRIE0   RXEN0   TXEN0  UCSZ02   RXB80   TXB80
0xC0   UCSR0A    RXC0    TXC0   UDRE0     FE0    DOR0    UPE0    U2X0   MPCM0


0xBD    TWAMR   TWAM6   TWAM5   TWAM4   TWAM3   TWAM2   TWAM1   TWAM0       -
0xBC     TWCR   TWINT    TWEA   TWSTA   TWSTO    TWWC    TWEN       -    TWIE
0xBB     TWDR
0xBA     TWAR    TWA6    TWA5    TWA4    TWA3    TWA2    TWA1    TWA0   TWGCE
0xB9     TWSR    TWS7    TWS6    TWS5    TWS4    TWS3       -   TWPS1   TWPS0
0xB8     TWBR


0xB6     ASSR       -   EXCLK     AS2  TCN2UB OCR2AUB OCR2BUB TCR2AUB TCR2BUB


0xB4    OCR2B
0xB3    OCR2A
0xB2    TCNT2
0xB1   TCCR2B   FOC2A   FOC2B       -       -   WGM22    CS22    CS21    CS20
0xB0   TCCR2A  COM2A1  COM2A0  COM2B1  COM2B0       -       -   WGM21   WGM20


0x8B   OCR1BH
0x8A   OCR1BL
0x89   OCR1AH
0x88   OCR1AL
0x87    ICR1H
0x86    ICR1L
0x85   TCNT1H
0x84   TCNT1L


0x82   TCCR1C   FOC1A   FOC1B       -       -       -       -       -       -
0x81   TCCR1B   ICNC1   ICES1       -   WGM13   WGM12    CS12    CS11    CS10
0x80   TCCR1A  COM1A1  COM1A0  COM1B1  COM1B0       -       -   WGM11   WGM10
0x7F    DIDR1       -       -       -       -       -       -   AIN1D   AIN0D
0x7E    DIDR0       -       -   ADC5D   ADC4D   ADC3D   ADC2D   ADC1D   ADC0D


0x7C    ADMUX   REFS1   REFS0   ADLAR       -    MUX3    MUX2    MUX1    MUX0
0x7B   ADCSRB       -    ACME       -       -       -   ADTS2   ADTS1   ADTS0
0x7A   ADCSRA    ADEN    ADSC   ADATE    ADIF    ADIE   ADPS2   ADPS1   ADPS0
0x79     ADCH
0x78     ADCL


0x70   TIMSK2       -       -       -       -       -  OCIE2B  OCIE2A   TOIE2
0x6F   TIMSK1       -       -   ICIE1       -       -  OCIE1B  OCIE1A   TOIE1
0x6E   TIMSK0       -       -       -       -       -  OCIE0B  OCIE0A   TOIE0
0x6D   PCMSK2 PCINT23 PCINT22 PCINT21 PCINT20 PCINT19 PCINT18 PCINT17 PCINT16
0x6C   PCMSK1       - PCINT14 PCINT13 PCINT12 PCINT11 PCINT10  PCINT9  PCINT8
0x6B   PCMSK0  PCINT7  PCINT6  PCINT5  PCINT4  PCINT3  PCINT2  PCINT1  PCINT0


0x69    EICRA       -       -       -       -   ISC11   ISC10   ISC01   ISC00
0x68    PCICR       -       -       -       -       -   PCIE2   PCIE1   PCIE0


0x66   OSCCAL


0x64      PRR   PRTWI  PRTIM2  PRTIM0       -  PRTIM1   PRSPI PRUSART0  PRADC


0x61    CLKPR  CLKPCE       -       -       -  CLKPS3  CLKPS2  CLKPS1  CLKPS0
0x60   WDTCSR    WDIF    WDIE    WDP3    WDCE     WDE    WDP2    WDP1    WDP0


# IO #


0x5F     SREG  SREG_I  SREG_T  SREG_H  SREG_S  SREG_V  SREG_N  SREG_Z  SREG_C
0x5E      SPH       -       -       -       -       -       -     SP9     SP8
0x5D      SPL     SP7     SP6     SP5     SP4     SP3     SP2     SP1     SP0


0x57   SPMCSR   SPMIE       -   SIGRD       -  BLBSET   PGWRT   PGERS   SPMEN


0x55    MCUCR       -    BODS   BODSE     PUD       -       -   IVSEL    IVCE
0x54    MCUSR       -       -       -       -    WDRF    BORF   EXTRF    PORF
0x53     SMCR       -       -       -       -     SM2     SM1     SM0      SE


0x50     ACSR     ACD    ACBG     ACO     ACI    ACIE    ACIC   ACIS1   ACIS0


0x4E     SPDR
0x4D     SPSR    SPIF    WCOL       -       -       -       -       -   SPI2X
0x4C     SPCR    SPIE     SPE    DORD    MSTR    CPOL    CPHA    SPR1    SPR0
0x4B   GPIOR2
0x4A   GPIOR1


0x48    OCR0B
0x47    OCR0A
0x46    TCNT0
0x45   TCCR0B   FOC0A   FOC0B       -       -   WGM02    CS02    CS01    CS00
0x44   TCCR0A  COM0A1  COM0A0  COM0B1  COM0B0       -       -   WGM01   WGM00
0x43    GTCCR     TSM       -       -       -       -       -  PSRASY PSRSYNC
0x42    EEARH
0x41    EEARL
0x40     EEDR


0x3F     EECR       -       -   EEPM1   EEPM0   EERIE   EEMPE    EEPE    EERE
0x3E   GPIOR0
0x3D    EIMSK       -       -       -       -       -       -    INT1    INT0
0x3C     EIFR       -       -       -       -       -       -   INTF1   INTF0
0x3B    PCIFR       -       -       -       -       -   PCIF2   PCIF1   PCIF0


0x37    TIFR2       -       -       -       -       -   OCF2B   OCF2A    TOV2
0x36    TIFR1       -       -    ICF1       -       -   OCF1B   OCF1A    TOV1
0x35    TIFR0       -       -       -       -       -   OCF0B   OCF0A    TOV0


0x2B    PORTD  PORTD7  PORTD6  PORTD5  PORTD4  PORTD3  PORTD2  PORTD1  PORTD0
0x2A     DDRD    DDD7    DDD6    DDD5    DDD4    DDD3    DDD2    DDD1    DDD0
0x29     PIND   PIND7   PIND6   PIND5   PIND4   PIND3   PIND2   PIND1   PIND0


0x28    PORTC       -  PORTC6  PORTC5  PORTC4  PORTC3  PORTC2  PORTC1  PORTC0
0x27     DDRC       -    DDC6    DDC5    DDC4    DDC3    DDC2    DDC1    DDC0
0x26     PINC       -   PINC6   PINC5   PINC4   PINC3   PINC2   PINC1   PINC0


0x25    PORTB  PORTB7  PORTB6  PORTB5  PORTB4  PORTB3  PORTB2  PORTB1  PORTB0
0x24     DDRB    DDB7    DDB6    DDB5    DDB4    DDB3    DDB2    DDB1    DDB0
0x23     PINB   PINB7   PINB6   PINB5   PINB4   PINB3   PINB2   PINB1   PINB0
EOF
