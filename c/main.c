#include <stdio.h>
#include <stdlib.h>

#define WIDTH 4.0
#define HEIGTH 2.0

#define RESOLUTION 512

#define MAX_ITERATIONS 1000

int main() {
  const int width = WIDTH * RESOLUTION;
  const int heigth = HEIGTH * RESOLUTION;

  int* iterations = malloc(width * heigth * sizeof(int)); 


  for(int xi = 0; xi < width; ++xi) {
    for(int yi = 0; yi < heigth; ++yi) {

      const double x0 = - WIDTH / 2.0 + (double)xi / (double)RESOLUTION;
      const double y0 = - HEIGTH / 2.0 + (double)yi / (double)RESOLUTION;

      int iteration = 0;
      double x = 0.0;
      double y = 0.0;

      while(iteration < MAX_ITERATIONS) {
        float xtemp = x * x - y * y + x0;
        y = 2.0 * x * y + y0;
        x = xtemp;
        ++iteration;

        if(x * x + y * y > 4.0) break;

      }

      iterations[xi * heigth + yi] = iteration;

    }
  }

  FILE* image = fopen("plot.ppm", "wb");
  fprintf(image, "P3\n%d %d\n255\n", width, heigth);

  for(int yi = heigth - 1; yi >= 0; --yi) {
    for(int xi = 0; xi < width; ++xi) {
      int color = iterations[xi * heigth + yi] * 255 / MAX_ITERATIONS;

      fprintf(image, "0 0 %d\n", color);
    }
  }

  fclose(image);
  free(iterations);

  return 0;
}
