#include <stdio.h>

#define N 4096

int count_ascii_chars(FILE *fp) {
	char buffor[N];
	int r;
	int counter = 0;

	do {
		r = fread(buffor, sizeof(char), N, fp);

		for (int i = 0; i < r; i++) {
			switch (buffor[i]) {
				case '0':
					counter++;
					break;
				case '1':
					counter++;
					break;
				case ' ': break;
				case '\n': break;
				default:
					return -1;
			}
		}

	} while (r != 0);

	return counter;
}

int main(int argc, char **argv) {
	if (argc != 2) {
		printf("Usage: %s <filename>\n", argv[0]);
		return 1;
	}

	const char *filename = argv[1];
	FILE *fp = fopen(filename, "r");

	int is_ascii = count_ascii_chars(fp);

	if (is_ascii < 0) {
		fseek(fp, 0, SEEK_END);
		int len = ftell(fp);
		printf("no\n%d", len);
		return 0;
	} else {
		printf("yes\n%d", is_ascii);
		return 1;
	}
}

