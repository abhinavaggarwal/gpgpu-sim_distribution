#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

__global__ void saxpy(int n, float *x)
{
  __shared__ float A[1000];
  int id = blockIdx.x*blockDim.x + threadIdx.x;
  float a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
  if (id == 0) {
	for (int i = 0 ; i < 1000 ; i += 8) {
		a = A[i];
		b = A[i + 1];
		c = A[i + 2];
		d = A[i + 3];
		e = A[i + 4];
		f = A[i + 5];
		g = A[i + 6];
		h = A[i + 7];
	}
	*x = a + b + c + d + e + f + g + h;
  }
}

int main(void)
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
  cudaMalloc(&d_dummy, sizeof(float));
  saxpy<<<1, 8>>>(N, d_dummy);
  cudaMemcpy(h_dummy, d_dummy, sizeof(float), cudaMemcpyDeviceToHost);
  printf("%f\n", *h_dummy);
}
