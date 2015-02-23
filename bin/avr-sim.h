#ifndef AVR_SIM_H
#define AVR_SIM_H

#include <stddef.h>

#define DEFAULT_FREQ (1000000L)
#define DEFAULT_CYCLES (1000L)
#define MINIMUM_ADDR (0x20)

#define MAX_STR_LEN (4096)
#define MAX_REG_SIZE (32)


struct avr_sim_addr {
	char name[MAX_STR_LEN];
	unsigned int addr;
	int bit_start;
	int bit_end;
};


enum avr_sim_type {
	AVR_SIM_TYPE_UNKNOWN = 0,
	AVR_SIM_TYPE_HEX,
	AVR_SIM_TYPE_ELF
};


struct avr_sim_args {
	char src[MAX_STR_LEN];
	char vcd[MAX_STR_LEN];
	char mmcu[MAX_STR_LEN];
	int sim_type;
	unsigned long freq;
	unsigned long cycles;


	struct avr_sim_addr reg[MAX_REG_SIZE];
	int reg_size;

	char** argv;
	int errnum;
};


enum avr_sim_err {
	AVR_SIM_ERR_NONE = 0,

	AVR_SIM_ERR_NO_SRC,
	AVR_SIM_ERR_NO_MMCU,
	AVR_SIM_ERR_MISSING,
	AVR_SIM_ERR_BAD_FREQ,
	AVR_SIM_ERR_BAD_CYCLES,
	AVR_SIM_ERR_UNKNOWN_ARG,

	AVR_SIM_ERR_REG_MAX,
	AVR_SIM_ERR_REG_BAD_ADDR,
	AVR_SIM_ERR_REG_NO_ADDR,

	AVR_SIM_ERR_SIZE
};


/* return 0 on success, AVR_SIM_ERR on error */
extern int avr_sim_parse(struct avr_sim_args*);


/* copy error string given the AVR_SIM_ERR number */
extern void avr_sim_strerror(char*, size_t, struct avr_sim_args*);


#endif /* AVR_SIM_H */
