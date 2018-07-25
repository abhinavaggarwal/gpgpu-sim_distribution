#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

__global__ void saxpy(unsigned num_rd_streams, unsigned addr1, unsigned addr2, unsigned addr3, unsigned addr4, unsigned addr5, unsigned addr6, unsigned addr7, unsigned addr8, unsigned rd_stream_length, unsigned num_wr_streams, unsigned wr_stream_length)
{
	int id = threadIdx.x;
	if (id <= 8) {
		for (int i = 0; i < 1000 - 8; i += 8) {
			unsigned a;
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
			asm ("ld.shared.u32 %0, [%1];" : "=r"(a) : "r"(id) );
		}
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
	// cudaMalloc(&d_x, 2*sizeof(unsigned));
	for (int i = 1 ; i <= N ; i++)
		h_x[i-1] = (unsigned)i;
	cudaMemcpy(d_x, h_x, N*sizeof(unsigned), cudaMemcpyHostToDevice);
	saxpy<<<1, 8>>>(8, 100, 100, 100, 100, 100, 100, 100, 100, 1000, 0, 1000);
}
