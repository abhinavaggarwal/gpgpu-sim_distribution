#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

__global__ void saxpy(unsigned num_streams, unsigned addr1, unsigned addr2, unsigned addr3, unsigned addr4, unsigned addr5, unsigned addr6, unsigned addr7, unsigned addr8, int dummy, float *x)
{
	__shared__ float A[1000];
	int id = blockIdx.x*blockDim.x + threadIdx.x;
	float a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
	for (int i = 0; i < 1000 - 8; i += 8) {
		a = A[id + 8*i*dummy];
		b = A[id + 1*i*dummy];
		c = A[id + 2*i*dummy];
		d = A[id + 3*i*dummy];
		e = A[id + 4*i*dummy];
		f = A[id + 5*i*dummy];
		g = A[id + 6*i*dummy];
		h = A[id + 7*i*dummy];
	}
	x[id] = a + b + c + d + e + f + g + h;
}

int main(int argc, char *argv[])
{
	int N = 1000;
	// Perform SAXPY on 1M elements
	float *h_x = (float *)malloc(N*sizeof(float));
	float *d_x = (float *)100;
	float *d_x_copy;
	cudaMalloc(&d_x_copy, N*sizeof(float));
	// cudaMalloc(&d_x, 2*sizeof(float));
	for (int i = 1 ; i <= N ; i++)
		h_x[i-1] = (float)i;
	cudaMemcpy(d_x, h_x, N*sizeof(float), cudaMemcpyHostToDevice);
	float *h_dummy = (float *)malloc(sizeof(float));
	float *d_dummy;
	cudaMalloc(&d_dummy, 8*sizeof(float));
	saxpy<<<1, 8>>>(8, 100, 100, 100, 100, 100, 100, 100, 100, atoi(argv[1]), d_dummy);
	//cudaMemcpy(h_dummy, d_dummy, sizeof(float), cudaMemcpyDeviceToHost);
	printf("%f\n", *h_dummy);
}
