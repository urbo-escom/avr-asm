#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

#include "avr-sim.h"


#define check(expr, err) do { if (!(expr)) { return err; } } while (0)
#define ERR(err) (AVR_SIM_ERR_ ## err)


extern void avr_sim_strerror(char* s, size_t l, struct avr_sim_args *p) {
	char aux[2*MAX_STR_LEN] = {0};
	char* n = "(null)";
	char* arg = NULL;

	if (NULL != p->argv && NULL != *p->argv) {
		if (MAX_STR_LEN <= strlen(*p->argv)) {
			sprintf(aux,
			"Argument too large in size '%*s' ... %d bytes",
			10, *p->argv, (int)strlen(*p->argv));
			strncpy(s, aux, l);
			return;
		}
		arg = *p->argv;
	} else {
		arg = n;
	}

	#define print(fmt, arg) sprintf(aux, fmt, arg); break
	switch (p->errnum) {
	case AVR_SIM_ERR_NONE:
	default:
		print("%s", "None");


	case AVR_SIM_ERR_NO_SRC:
		print("%s", "No source file (hex|elf) file provided");

	case AVR_SIM_ERR_NO_MMCU:
		print("%s", "No microcontroller name specified");

	case AVR_SIM_ERR_MISSING:
		print("Missing argument for '%s'", arg);

	case AVR_SIM_ERR_BAD_FREQ:
		print("Bad frequency '%s'", arg);

	case AVR_SIM_ERR_BAD_CYCLES:
		print("Bad cycles '%s'", arg);

	case AVR_SIM_ERR_UNKNOWN_ARG:
		print("Unknown argument '%s'", arg);


	case AVR_SIM_ERR_REG_MAX:
		print("Max registers reached %d", MAX_REG_SIZE);

	case AVR_SIM_ERR_REG_BAD_ADDR:
		print("Bad addr '%s' not in form ADDR:[0-7]:[0-7]", arg);

	case AVR_SIM_ERR_REG_NO_ADDR:
		print("Missing address after '%s' option", arg);
	}
	#undef print

	strncpy(s, aux, l);
}


static int avr_sim_parse_reg(struct avr_sim_args*);
static void avr_sim_parse_build_missing(struct avr_sim_args*);

extern int avr_sim_parse(struct avr_sim_args *p)
{
	#define is(l, sh) (!strcmp(l, *p->argv) || !strcmp(sh, *p->argv))

	for (p->argv++; NULL != *p->argv; p->argv++) {
		     if (!strcmp("--hex", *p->argv)) {
			p->sim_type = AVR_SIM_TYPE_HEX;
		}


		else if (!strcmp("--elf", *p->argv)) {
			p->sim_type = AVR_SIM_TYPE_ELF;
		}


		else if (is("--src", "-i")) {
			check(NULL != *(++p->argv),
				(p->argv--, p->errnum = ERR(MISSING)));
			strncpy(p->src, *p->argv, sizeof(p->src));
		}


		else if (is("--vcd", "-o")) {
			check(NULL != *(++p->argv),
				(p->argv--, p->errnum = ERR(MISSING)));
			strncpy(p->vcd, *p->argv, sizeof(p->vcd));
		}


		else if (is("--mmcu", "-m")) {
			check(NULL != *(++p->argv),
				(p->argv--, p->errnum = ERR(MISSING)));
			strncpy(p->mmcu, *p->argv, sizeof(p->mmcu));
		}


		else if (is("--freq", "-f")) {
			check((errno = 0, NULL != *(++p->argv)),
				(p->argv--, p->errnum = ERR(MISSING)));
			p->freq = strtoul(*p->argv, NULL, 10);
			check(ERANGE != errno, p->errnum = ERR(BAD_FREQ));
		}


		else if (is("--cycles", "-c")) {
			check((errno = 0, NULL != *(++p->argv)),
				(p->argv--, p->errnum = ERR(MISSING)));
			p->cycles = strtoul(*p->argv, NULL, 10);
			check(ERANGE != errno, p->errnum = ERR(BAD_CYCLES));
		}


		else if (is("--register", "-R")) {
			int err;
			check(!(err = avr_sim_parse_reg(p)), p->errnum = err);
		}


		else {
			return p->errnum = ERR(UNKNOWN_ARG);
		}
	}

	#undef is

	if (0 == strlen(p->src))
		return p->errnum = ERR(NO_SRC);

	if (0 == strlen(p->mmcu))
		return p->errnum = ERR(NO_MMCU);

	if (0L == p->freq)
		p->freq = DEFAULT_FREQ;

	if (0L == p->cycles)
		p->cycles = DEFAULT_CYCLES;

	avr_sim_parse_build_missing(p);

	return p->errnum = 0;
}


static void avr_sim_parse_build_missing(struct avr_sim_args* p)
{
	int i;


	if (NULL != strrchr(p->src, '.') &&
	0 == strcmp(".hex", strrchr(p->src, '.'))) {
		if (AVR_SIM_TYPE_UNKNOWN == p->sim_type)
			p->sim_type = AVR_SIM_TYPE_HEX;
	} else {
		if (AVR_SIM_TYPE_UNKNOWN == p->sim_type)
			p->sim_type = AVR_SIM_TYPE_ELF;
	}


	if (0 == strlen(p->vcd)) {
		char* dot;
		strncpy(p->vcd, p->src, sizeof(p->vcd));
		if (NULL != (dot = strrchr(p->vcd, '.')))
			strncpy(dot, ".vcd", 5);
		else
			strncpy(strrchr(p->vcd, '\0'), ".vcd", 5);
	}


	for (i = 0; i < p->reg_size; i++)
		if (0 == strlen(p->reg[i].name))
			sprintf(p->reg[i].name, "0x%x", p->reg[i].addr);
}


static int avr_sim_parse_addr(struct avr_sim_addr*, const char*);


static int avr_sim_parse_reg(struct avr_sim_args *p)
{
	struct avr_sim_addr *r = NULL;
	int name = 0;
	int addr = 0;


	check(p->reg_size < MAX_REG_SIZE, p->errnum = ERR(REG_MAX));
	r = &p->reg[p->reg_size];


	for (p->argv++; !(name && addr) && NULL != *p->argv; p->argv++) {
		if (!strcmp("--name", *p->argv)) {
			check(NULL != *(++p->argv),
				(p->argv--, p->errnum = ERR(MISSING)));
			strncpy(r->name, *p->argv, sizeof(r->name));
			name = 1;
		}


		else if (!strcmp("--addr", *p->argv)) {
			check(NULL != *(++p->argv),
				(p->argv--, p->errnum = ERR(MISSING)));
			check(!avr_sim_parse_addr(r, *p->argv),
				p->errnum = ERR(REG_BAD_ADDR));
			addr = 1;
		}


		else {
			break;
		}
	}

	check(addr, (NULL == *p->argv ? p->argv--:p->argv,
		p->errnum = ERR(REG_NO_ADDR)));
	p->argv--;
	p->reg_size++;
	return 0;
}


/* ADDR:[0-7]:[0-7] */
static int avr_sim_parse_addr(struct avr_sim_addr *r, const char* s)
{
	char aux[sizeof("0xffff:0:0")] = {0};
	int i = 0;
	int sep = 0;
	char b0, b1;


	while (i < (sizeof(aux) - 1) && '\0' != *s) {
		if (!isspace(*s)) {
			if (':' == *s)
				sep++;
			aux[i++] = *s;
		}
		s++;
	}


	if ((i == (sizeof(aux) - 1) && '\0' != *s))
		return 1;


	i = sscanf(aux, "%x:%c:%c", &r->addr, &b0, &b1);

	if (r->addr < MINIMUM_ADDR || 0 == i || EOF == i
	|| (1 == i && 0 != sep)
	|| (2 == i && 1 != sep)
	|| (3 == i && 2 != sep))
		return 1;


	switch (i) {
	default: return 0;


	case 1:
		r->bit_start = 0;
		r->bit_end = 7;
		return 0;


	case 2:
		if (b0 < '0' || '7' < b0)
			return 1;
		r->bit_start = b0 - '0';
		r->bit_end   = b0 - '0';
		return 0;


	case 3:
		if (b0 < '0' || '7' < b0 || b1 < '0' || '7' < b1)
			return 1;
		if (b0 <= b1) {
			r->bit_start = b0 - '0';
			r->bit_end   = b1 - '0';
		} else {
			r->bit_end   = b0 - '0';
			r->bit_start = b1 - '0';
		}
		return 0;
	}
}
