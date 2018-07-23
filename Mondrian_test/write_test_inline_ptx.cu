#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

__global__ void saxpy(unsigned num_rd_streams, unsigned rd_stream_length, unsigned num_wr_streams, unsigned addr1, unsigned addr2, unsigned addr3, unsigned addr4, unsigned addr5, unsigned addr6, unsigned addr7, unsigned addr8, unsigned wr_stream_length)
{
	unsigned long long id = blockIdx.x * blockDim.x + threadIdx.x;
	if (id <= 8) {
		for (unsigned i = 0; i < 1000 - 8; i += 8) {
			asm volatile ("st.shared.u32 [%%rd1], 4;");
			asm volatile ("st.shared.u32 [%%rd1], 4;");
			asm volatile ("st.shared.u32 [%%rd1], 4;");
			asm volatile ("st.shared.u32 [%%rd1], 4;");
			asm volatile ("st.shared.u32 [%%rd1], 4;");
			asm volatile ("st.shared.u32 [%%rd1], 4;");
			asm volatile ("st.shared.u32 [%%rd1], 4;");
			asm volatile ("st.shared.u32 [%%rd1], 4;");
		}
	}
}

int main(int argc, char *argv[])
{
	unsigned N = 1000;
	unsigned *d_x = (unsigned *)100;
	unsigned *h_x;
	h_x = (unsigned *)malloc(N*8*sizeof(unsigned));
	cudaMemcpy(d_x, h_x, N*sizeof(unsigned), cudaMemcpyHostToDevice);
	saxpy<<<1, 8>>>(0, 1000, 8, 100, 4100, 8100, 12100, 16100, 20100, 24100, 28100, 1000);
	cudaMemcpy(h_x, d_x, N*8*sizeof(unsigned), cudaMemcpyDeviceToHost);
	for (unsigned i = 0 ; i < 8000 ; i++) {
		printf("%u\n", *(h_x + i));
	}	
}
