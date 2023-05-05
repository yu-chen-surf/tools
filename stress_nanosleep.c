// C Program to demonstrate
// use of nanosleep
#include <stdio.h>
#include <time.h>

int main(int argc, char *argv)
{
	int response;
	struct timespec remaining, request = { 0, 100 };

	while (1) {
		request.tv_sec = 0;
		request.tv_nsec = 100;
		response = nanosleep(&request, &remaining);
	}
	return 0;
}
