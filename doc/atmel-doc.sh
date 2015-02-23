#!/bin/sh
#
# Search in google:
#
#     asm pdf site:www.atmel.com/images
#
set -x trace

_wget(){ wget -c -nH "$1" -O"$2"; }


# Datasheet for Atmega48/88/168
_wget http://www.atmel.com/images/doc2545.pdf 00_avr-atmega-48-88-168.pdf


# Assembler syntax and directives
_wget http://www.atmel.com/images/doc1022.pdf 10_avr-asm-guide.pdf


# Assembler instruction set and side effects
_wget http://www.atmel.com/images/doc0856.pdf 10_avr-instr-set.pdf


# Use of lpm instruction
_wget http://www.atmel.com/images/doc1233.pdf 20_avr-lpm.pdf


# 16-bit IO registers
_wget http://www.atmel.com/images/doc1493.pdf 20_avr-io-16-bit.pdf


# Timers
_wget http://www.atmel.com/images/doc2505.pdf 20_avr-timers.pdf


# SPI programming
_wget http://www.atmel.com/images/doc4348.pdf 30_avr-spi.pdf


# UART programming
_wget http://www.atmel.com/images/doc4346.pdf 30_avr-uart.pdf


# Multiplication instructions
_wget http://www.atmel.com/images/doc1631.pdf 90_avr-mult.pdf


# 16-bit arithmetic
_wget http://www.atmel.com/images/doc0937.pdf 90_avr-arith-16-bit.pdf


# BCD arithmetic
_wget http://www.atmel.com/images/doc0938.pdf 90_avr-arith-bcd.pdf


# Multiply and Divide routines
_wget http://www.atmel.com/images/doc0936.pdf 90_avr-mult-and-div.pdf
