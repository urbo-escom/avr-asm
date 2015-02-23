/*
 *
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <errno.h>

#include "libserialport.h"
#include "uart-8n1.c"

#define check(label, expr) do { if (!(expr)) goto label; } while (0)

static struct sp_port* uart_init_8n1(int *argc, char*** argv);

int main(int argc, char** argv)
{
	struct sp_port* port;
	int i;
	char buf[1024];

	port = uart_init_8n1(&argc, &argv);

	printf("Please no more than %lu bytes!\n", sizeof(buf) - 1);
	printf("Type .quit to exit\n");
	for (;;) {
		int buf_len;

		printf("TX> ");

		fgets(buf, sizeof(buf), stdin);
		buf_len = strlen(buf);
		if (0 < buf_len && '\n' == buf[buf_len - 1])
			buf[buf_len-- - 1] = '\0';
		if (!strcmp(buf, ".quit")) {
			puts("Bye");
			break;
		}
		sp_blocking_write(port, buf, buf_len, 100);

		printf("RX> ");
		fflush(stdout);
		sp_blocking_read(port, buf, buf_len, 100);
		printf("%*s\n", buf_len, buf);
	}

	sp_close(port);
	sp_free_port(port);
	return EXIT_SUCCESS;
}
