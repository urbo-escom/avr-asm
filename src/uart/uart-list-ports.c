/*
 * Librería `libserialport` para Linux/Windows (entre otros)
 *
 *     http://sigrok.org/wiki/Libserialport
 *
 * API
 *
 *     http://sigrok.org/api/libserialport/unstable/index.html
 *
 * Si se hace  una compilación cruzada desde Linux a  Windows, configure debe
 * invocarse así:
 *
 *     ./configure \
 *         --build i686-linux-gnu \
 *         --host x86_64-w64-mingw32 \
 *         --prefix /usr/x86_64-w64-mingw32/
 *
 * o  de   manera  similar  con   `i686-w64-mingw32`  pero  no   funciona  con
 * `i586-mingw32msvc`
 *
 * http://arrayfire.com/cross-compile-to-windows-from-linux/
 * http://www.gnu.org/software/automake/manual/html_node/Cross_002dCompilation.html
 *
 * Al compilar, se debe incluir el nombre de la librería como `-lserialport`,
 * seguido de la librería `-lsetupapi` y talvez `-lhid`.
 *
 * http://www.microchip.com/forums/m264386.aspx
 * http://forums.hackaday.com/viewtopic.php?f=5&t=2369
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <errno.h>

#include "libserialport.h"

static struct sp_port* uart_open_8n1(const char*, int);

static void uart_printf(const char* fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	fprintf(stderr, "[SERIAL]: ");
	vfprintf(stderr, fmt, ap);
	va_end(ap);
}

static int uart_list_ports(void);

#define check(label, expr) do { if (!(expr)) goto label; } while (0)

int main(int argc, char** argv)
{
	struct sp_port **list = NULL;
	struct sp_port **port = NULL;

	int i;
	for (i = 0; i < argc; i++)
		if (!strcmp("--verbose", argv[i]) || !strcmp("-v", argv[i]))
			sp_set_debug_handler(uart_printf);

	check(error, SP_OK == sp_list_ports(&list));
	for (port = list; NULL != *port; port++) {
		printf("%s: %s\n",
			sp_get_port_name(*port),
			sp_get_port_description(*port));

		switch(sp_get_port_transport(*port)) {
		case SP_TRANSPORT_NATIVE:
			printf("\tTransport: native\n");
			break;


		case SP_TRANSPORT_USB:
			printf("\tTransport: usb\n");
			printf("\tManufacturer: %s\n",
				sp_get_port_usb_manufacturer(*port));
			printf("\tProduct: %s\n",
				sp_get_port_usb_product(*port));
			printf("\tSerial: %s\n",
				sp_get_port_usb_serial(*port));
			break;


		case SP_TRANSPORT_BLUETOOTH:
			printf("\tTransport: bluetooth\n");
			printf("\tAddress: %s\n",
				sp_get_port_bluetooth_address(*port));
			break;
		}
	}

	sp_free_port_list(list);
	return EXIT_SUCCESS;

error:
	fprintf(stderr, "Cannot list serial ports!\n");
	return EXIT_FAILURE;
}
