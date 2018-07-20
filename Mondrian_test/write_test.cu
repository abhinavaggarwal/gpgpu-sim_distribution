#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

__global__ void saxpy(unsigned num_rd_streams, unsigned num_wr_streams, unsigned addr1, unsigned addr2, unsigned addr3, unsigned addr4, unsigned addr5, unsigned addr6, unsigned addr7, unsigned addr8, int dummy)
{
	__shared__ float A[1000];
	int id = blockIdx.x*blockDim.x + threadIdx.x;
	for (int i = 0; i < 1000 - 8; i += 8) {
		A[id + 8*i*dummy] = i + 8;
		A[id + 1*i*dummy] = i + 1;
		A[id + 2*i*dummy] = i + 2;
		A[id + 3*i*dummy] = i + 3;
		A[id + 4*i*dummy] = i + 4;
		A[id + 5*i*dummy] = i + 5;
		A[id + 6*i*dummy] = i + 6;
		A[id + 7*i*dummy] = i + 7;
	}
}

int main(int argc, char *argv[])
{
	int N = 1000;
	float *d_x = (float *)100;
	float *h_x;
	h_x = (float *)malloc(N*8*sizeof(float));
	cudaMemcpy(d_x, h_x, N*sizeof(float), cudaMemcpyHostToDevice);
	saxpy<<<1, 8>>>(0, 8, 100, 4100, 8100, 12100, 16100, 20100, 24100, 28100, atoi(argv[1]));
	cudaMemcpy(h_x, d_x, N*8*sizeof(float), cudaMemcpyDeviceToHost);
	for (unsigned i = 0 ; i < 8000 ; i++) {
		printf("%f\n", *(h_x + i));
	}	
}
