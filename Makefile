.SUFFIXES:
MK_FILES :=
MK_FILES += lib/rules.mk
MK_FILES += bin/rules.mk

SRC_DIR := src
SRC_DIRS :=
SRC_DIRS += util/
SRC_DIRS += display/
SRC_DIRS += examples/
SRC_DIRS += project/
SRC_DIRS += string/
SRC_DIRS += uart/
SRC_DIRS += adc/
SRC_DIRS := $(addprefix src/, ${SRC_DIRS})

MK_FILES += $(addsuffix rules.mk, ${SRC_DIRS})

AVR_HEX :=
AVR_FST :=

rwildcard = $(foreach file, $(wildcard $(addsuffix *, $1)), \
		$(filter $(subst *, %, $2), ${file}) \
		$(call rwildcard, ${file}/, $2))


$(foreach f, ${MK_FILES}, \
	$(foreach d, $(patsubst %/,%,$(dir $f)), \
	$(eval -include $f)))


$(foreach hex, ${AVR_HEX}, $(eval ${hex}: lib/m48def.inc))
$(foreach fst, ${AVR_FST}, $(eval ${fst}: lib/m48def.mk))


$(foreach asm, $(call rwildcard, ${SRC_DIRS}, *.asm), \
	$(eval .PHONY: install-${asm:%.asm=%.hex}) \
	$(eval install-${asm:%.asm=%.hex}: ${asm:%.asm=%.hex} ; \
		$${AVRDUDE_INSTALL_FLASH}))


.DEFAULT_GOAL = all
.PHONY: all
.PHONY: all-hex
.PHONY: all-fst
.PHONY: clean

all: all-hex all-fst

all-hex: ${AVR_HEX}

all-fst: ${AVR_FST}

clean:
	rm -f $(strip $(wildcard tmp/* $(sort \
		${AVR_HEX} \
		${AVR_FST} \
	)))
