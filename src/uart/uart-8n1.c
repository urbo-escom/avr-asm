/*
 * uart_init_8n1
 *
 * Inicializa un  puerto serial  en modo  8N1. Se  deben pasar  los argumentos
 * del  método  main,  al  ejecutarse, el  método  remueve  los  parámetros
 * pertinentes,  como  `-p|--port  <portname>`   y  `-s|--speed  <speed>`  con
 * excepción de `-v|--verbose`.
 *
 * Ejemplo de uso:
 *
 *     int main(int argc, char** argv)
 *     {
 *     ...
 *             struct sp_port* port = NULL;
 *             port = uart_printf(&argc, &argv);
 *     ...
 *             sp_close(port);
 *             sp_free_port(port);
 *     ...
 *     }
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <errno.h>

static void uart_printf(const char* fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	fprintf(stderr, "[SERIAL]: ");
	vfprintf(stderr, fmt, ap);
	va_end(ap);
}

#define check(label, expr) do { if (!(expr)) goto label; } while (0)

static struct sp_port* uart_init_8n1(int *argc, char*** argv)
{
	struct sp_port *port = NULL;
	const char* portname = NULL;
	int baudrate = 4800;
	int verbose = 0;
	int i;
	int j;

	i = j = 0;
	while (NULL != (*argv)[i]) {
	#define IS_ARG(lopt, shopt) ( \
		!strcmp(lopt, (*argv)[i]) || !strcmp(shopt, (*argv)[i]))

		if (IS_ARG("--port", "-p")) {
			check(missing_port, NULL != (*argv)[i + 1]);
			portname = (*argv)[i + 1];
			i += 2;
			*argc -= 2;
		} else if (IS_ARG("--speed", "-s")) {
			check(missing_speed, NULL != (*argv)[i + 1]);
			errno = 0;
			baudrate = strtoul((*argv)[i + 1], NULL, 10);
			check(missing_speed, ERANGE != errno);
			i += 2;
			*argc -= 2;
		} else if (IS_ARG("--verbose", "-v")) {
			sp_set_debug_handler(uart_printf);
			verbose++;
			i++;
			j++;
		} else {
			i++;
			j++;
		}

		(*argv)[j] = (*argv)[i];

	#undef IS_ARG
	}

	check(missing_port, NULL != portname);
	check(error, SP_OK == sp_get_port_by_name(portname, &port));
	check(error, SP_OK == sp_open(port, SP_MODE_READ_WRITE));
	check(error, SP_OK == sp_set_baudrate(port, baudrate));
	check(error, SP_OK == sp_set_bits(port, 8));
	check(error, SP_OK == sp_set_parity(port, SP_PARITY_NONE));
	check(error, SP_OK == sp_set_stopbits(port, 1));

	return port;


missing_port:
	fprintf(stderr, "Missing portname: -p|--port <portname>\n");
	exit(EXIT_FAILURE);


missing_speed:
	fprintf(stderr, "Missing baudrate: -s|--speed <baudrate>\n");
	exit(EXIT_FAILURE);


error:
	if (NULL != sp_last_error_message()) {
		fprintf(stderr, "%s: %s\n", portname, sp_last_error_message());
		if (!verbose)
			fprintf(stderr, "Use -v to get verbose output\n");
	}
	if (NULL != port) {
		sp_close(port);
		sp_free_port(port);
	}
	exit(EXIT_FAILURE);
}

#undef check
