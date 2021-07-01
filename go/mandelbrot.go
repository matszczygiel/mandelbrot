package main

import (
	"bufio"
	"fmt"
	"os"
)

const WIDTH = 4.0
const HEIGHT = 4.0

const RESOLUTION = 512

const MAX_ITERATIONS = 1000

func main() {
	const width int = WIDTH * RESOLUTION
	const height int = HEIGHT * RESOLUTION

	var iterations [width * height]int

	for xi := 0; xi < width; xi++ {
		for yi := 0; yi < height; yi++ {
			x0 := -float64(WIDTH)/2.0 + float64(xi)/float64(RESOLUTION)
			y0 := -float64(HEIGHT)/2.0 + float64(yi)/float64(RESOLUTION)

			iter := 0
			x := 0.0
			y := 0.0

			for iter < MAX_ITERATIONS {
				xtemp := x*x - y*y + x0
				y = 2.0*x*y + y0
				x = xtemp

				iter++

				if x*x+y*y > 4.0 {
					break
				}
			}

			iterations[xi*height+yi] = iter
		}
	}

	file, err := os.Create("plot.ppm")
	check(err)

	write := bufio.NewWriter(file)

	_, err = write.WriteString(fmt.Sprintf("P3\n%d %d\n255\n", width, height))
	check(err)

	for yi := height - 1; yi >= 0; yi-- {
		for xi := 0; xi < width; xi++ {
			color := iterations[xi*height+yi] * 255 / MAX_ITERATIONS

			_, err = write.WriteString(fmt.Sprintf("0 0 %d\n", color))
			check(err)
		}
	}

	err = write.Flush()
	check(err)

	err = file.Close()
	check(err)

}

func check(e error) {
	if e != nil {
		panic(e)
	}
}
