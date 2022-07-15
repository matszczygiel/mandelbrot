#include <fstream>
#include <vector>

#define WIDTH 4.0
#define HEIGHT 2.0

#define RESOLUTION 512

#define MAX_ITERATIONS 1000

int main() {
  constexpr int width = WIDTH * RESOLUTION;
  constexpr int height = HEIGHT * RESOLUTION;

  std::vector<int> iterations(width * height);


  for(int xi = 0; xi < width; ++xi) {
    for(int yi = 0; yi < height; ++yi) {

      const double x0 = - WIDTH / 2.0 + (double)xi / (double)RESOLUTION;
      const double y0 = - HEIGHT / 2.0 + (double)yi / (double)RESOLUTION;

      int iteration = 0;
      double x = 0.0;
      double y = 0.0;

      while(iteration < MAX_ITERATIONS) {
        double xtemp = x * x - y * y + x0;
        y = 2.0 * x * y + y0;
        x = xtemp;
        ++iteration;

        if(x * x + y * y > 4.0) break;

      }

      iterations[xi * height + yi] = iteration;

    }
  }

  std::ofstream image("plot.ppm");
  image << "P3\n" << width << ' ' << height << "\n255\n"; 

  for(int yi = height - 1; yi >= 0; --yi) {
    for(int xi = 0; xi < width; ++xi) {
      int color = iterations[xi * height + yi] * 255 / MAX_ITERATIONS;

      image << "0 0 " << color << '\n';
    }
  }

}
