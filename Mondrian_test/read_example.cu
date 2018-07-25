#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

__global__ void saxpy(unsigned num_rd_streams, unsigned addr1, unsigned addr2, unsigned addr3, unsigned addr4, unsigned addr5, unsigned addr6, unsigned addr7, unsigned addr8, unsigned rd_stream_length, unsigned num_wr_streams, unsigned wr_stream_length, unsigned *x)
{
	int id = threadIdx.x;
	if (id <= 0) {
		unsigned a;
		asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
		x[0] = a;
		asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
		x[1] = a;
	}
}

int main(int argc, char *argv[])
{
	int N = 1000;
	// Perform SAXPY on 1M elements
	unsigned *h_x = (unsigned *)malloc(N*sizeof(unsigned));
	unsigned *d_x = (unsigned *)100;
	unsigned *d_x_copy;
	cudaMalloc(&d_x_copy, N*sizeof(unsigned));
	for (int i = 1 ; i <= N ; i++)
		h_x[i-1] = (unsigned)i;
	cudaMemcpy(d_x, h_x, N*sizeof(unsigned), cudaMemcpyHostToDevice);
	unsigned *h_dummy, *d_dummy;
	cudaMalloc(&d_dummy, 2*sizeof(unsigned));
	h_dummy = (unsigned *)malloc(2*sizeof(unsigned));
	saxpy<<<1, 8>>>(8, 100, 100, 100, 100, 100, 100, 100, 100, 1000, 0, 1000, d_dummy);
	cudaMemcpy(h_dummy, d_dummy, 2*sizeof(unsigned), cudaMemcpyDeviceToHost);
	printf("%u\n", h_dummy[0]);
	printf("%u\n", h_dummy[1]);
}
