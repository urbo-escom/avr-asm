#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <assert.h>

#include "avr-sim.h"

#include "simavr/sim_avr.h"
#include "simavr/sim_elf.h"
#include "simavr/sim_hex.h"
#include "simavr/sim_io.h"
#include "simavr/sim_vcd_file.h"


static void print_params(struct avr_sim_args *p)
{
	int i;
	printf("sim: %s\n",
		AVR_SIM_TYPE_UNKNOWN == p->sim_type ? "Unknown":
		AVR_SIM_TYPE_HEX == p->sim_type ? "hex":"elf");
	printf("src: '%s'\n", p->src);
	printf("vcd: '%s'\n", p->vcd);
	printf("mmcu: '%s'\n", p->mmcu);
	printf("freq: %lu\n", p->freq);
	printf("cycles: %lu\n", p->cycles);
	for (i = 0; i < p->reg_size; i++)
		printf("reg[%d]: %s=0x%x:%d:%d\n", i,
			p->reg[i].name,
			p->reg[i].addr,
			p->reg[i].bit_start,
			p->reg[i].bit_end);
}


static void load_elf_file(struct elf_firmware_t*, struct avr_sim_args*);
static void load_hex_file(struct elf_firmware_t*, struct avr_sim_args*);
static void load_register_list(struct avr_t*, struct avr_sim_args*);
static void load_register(struct avr_t*, struct avr_sim_addr*);


int main(int argc, char** argv)
{
	struct avr_t* avr = NULL;
	struct avr_vcd_t vcd = {0};
	struct elf_firmware_t f = {{0}};
	struct avr_sim_args p = {{0}};
	unsigned long n;

	p.argv = argv;
	if (0 != avr_sim_parse(&p)) {
		char str[1024] = {0};
		avr_sim_strerror(str, 1024, &p);
		print_params(&p);
		printf("Error: %s\n", str);
		return 1;
	}
	print_params(&p);


	fprintf(stderr, "Loading as %s\n",
		AVR_SIM_TYPE_HEX == p.sim_type ? "hex":"elf");
	if (p.sim_type == AVR_SIM_TYPE_HEX)
		load_hex_file(&f, &p);
	else
		load_elf_file(&f, &p);


	fprintf(stderr, "Making mmcu '%s'\n", p.mmcu);
	if (NULL == (avr = avr_make_mcu_by_name(p.mmcu))) {
		fprintf(stderr, "Microcontroller '%s' not supported\n",
			p.mmcu);
		exit(1);
	}


	fprintf(stderr, "Initializing simavr\n");
	avr_init(avr);
	fprintf(stderr, "Loading firmware into simavr\n");
	avr_load_firmware(avr, &f);


	fprintf(stderr, "Writing VCD to '%s'\n", p.vcd);
	if (0 != avr_vcd_init(avr, p.vcd, (avr->vcd = &vcd), 1)) {
		fprintf(stderr, "Cannot write to '%s'\n", p.vcd);
		exit (1);
	}


	fprintf(stderr, "Loading registers to VCD\n");
	load_register_list(avr, &p);


	fprintf(stderr, "Starting VCD\n");
	avr_vcd_start(avr->vcd);
	for (n = 0L; n < p.cycles; n++) {
		int state = avr_run(avr);
		if (cpu_Done == state || cpu_Crashed == state)
			break;
	}


	fprintf(stderr, "Stopping VCD\n");
	avr_vcd_stop(avr->vcd);
	avr_vcd_close(avr->vcd);


	fprintf(stderr, "Closing simavr\n");
	avr_terminate(avr);

	return 0;
}


void load_elf_file(struct elf_firmware_t *f, struct avr_sim_args *p)
{
	if (-1 == elf_read_firmware(p->src, f)) {
		fprintf(stderr, "Unable to load firmware from file '%s'\n",
			p->src);
		exit(1);
	}
}


void load_hex_file(struct elf_firmware_t *f, struct avr_sim_args *p)
{
	uint32_t loadBase = AVR_SEGMENT_OFFSET_FLASH;
	ihex_chunk_p h = NULL;
	int s;
	int i;

	if ((s = read_ihex_chunks(p->src, &h)) <= 0) {
		fprintf(stderr, "Unable to load hex or empty file '%s'\n",
			p->src);
		exit(1);
	}

	fprintf(stderr, "Loaded %d section of ihex\n", s);
	for (i = 0; i < s; i++) {
		if (h[i].baseaddr < (1*1024*1024)) {
			f->flash = h[i].data;
			f->flashsize = h[i].size;
			f->flashbase = h[i].baseaddr;

			fprintf(stderr, "Load HEX flash %08x, %d\n",
				f->flashbase,
				f->flashsize);
		} else if (h[i].baseaddr >= AVR_SEGMENT_OFFSET_EEPROM ||
		h[i].baseaddr + loadBase >= AVR_SEGMENT_OFFSET_EEPROM) {
			f->eeprom = h[i].data;
			f->eesize = h[i].size;

			fprintf(stderr, "Load HEX eeprom %08x, %d\n",
				h[i].baseaddr,
				f->eesize);
		}
	}
}


static void load_register_list(struct avr_t *avr, struct avr_sim_args *p)
{
	int i;
	for (i = 0; i < p->reg_size; i++)
		load_register(avr, &p->reg[i]);
}


static void load_register(struct avr_t *avr, struct avr_sim_addr *r)
{
	int i;
	char aux[MAX_STR_LEN];


	fprintf(stderr, "Adding address 0x%x:%d:%d as %s\n",
		r->addr, r->bit_start, r->bit_end, r->name);

	if (0 == r->bit_start && 7 == r->bit_end) {
		avr_vcd_add_signal(avr->vcd,
			avr_iomem_getirq(avr, r->addr, NULL, 8),
			8, r->name);
	}


	else if (r->bit_start == r->bit_end) {
		sprintf(aux, "%s_%d", r->name, r->bit_start);
		avr_vcd_add_signal(avr->vcd,
			avr_iomem_getirq(avr, r->addr, NULL, r->bit_start),
			1, aux);
	}


	else for (i = r->bit_start; i <= r->bit_end; i++) {
		sprintf(aux, "%s_%d", r->name, i);
		avr_vcd_add_signal(avr->vcd,
			avr_iomem_getirq(avr, r->addr, NULL, i),
			1, aux);
	}
}
