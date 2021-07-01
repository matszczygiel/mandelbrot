use std::io::Write;

const WIDTH: f64 = 4.0;
const HEIGHT: f64 = 2.0;

const RESOLUTION: u64 = 512;

const MAX_ITERATIONS: u64 = 1000;

fn main() {
    // old();
    new();
}

fn new() {
    const PIX_WIDTH: u64 = (WIDTH * RESOLUTION as f64) as _;
    const PIX_HEIGHT: u64 = (HEIGHT * RESOLUTION as f64) as _;

    let iterations: Vec<_> = (0..PIX_WIDTH)
        .flat_map(|xi| {
            let x0 = -WIDTH / 2.0 + xi as f64 / RESOLUTION as f64;

            (0..PIX_HEIGHT).map(move |yi| {
                let y0 = -HEIGHT / 2.0 + yi as f64 / RESOLUTION as f64;

                let mut iter = 0;
                let mut x = 0.0;
                let mut y = 0.0;

                while iter < MAX_ITERATIONS {
                    let xtemp = x * x - y * y + x0;
                    y = 2.0 * x * y + y0;
                    x = xtemp;

                    iter += 1;

                    if x * x + y * y > 4.0 {
                        break;
                    }
                }

                iter
            })
        })
        .collect();

    let file = std::fs::File::create("plot.ppm").unwrap();
    let mut buf = std::io::BufWriter::new(file);

    write!(buf, "P3\n{} {}\n255\n", PIX_WIDTH, PIX_HEIGHT).unwrap();

    for yi in (0..PIX_HEIGHT).rev() {
        for xi in 0..PIX_WIDTH {
            let color = iterations[(xi * PIX_HEIGHT + yi) as usize] * 255 / MAX_ITERATIONS;

            writeln!(buf, "0 0 {}", color).unwrap();
        }
    }
}

fn old() {
    const PIX_WIDTH: u64 = (WIDTH * RESOLUTION as f64) as _;
    const PIX_HEIGHT: u64 = (HEIGHT * RESOLUTION as f64) as _;

    let mut iterations = vec![0; (PIX_WIDTH * PIX_HEIGHT) as usize];

    for xi in 0..PIX_WIDTH {
        for yi in 0..PIX_HEIGHT {
            let x0 = -WIDTH / 2.0 + xi as f64 / RESOLUTION as f64;
            let y0 = -HEIGHT / 2.0 + yi as f64 / RESOLUTION as f64;

            let mut iter = 0;
            let mut x = 0.0;
            let mut y = 0.0;

            while iter < MAX_ITERATIONS {
                let xtemp = x * x - y * y + x0;
                y = 2.0 * x * y + y0;
                x = xtemp;

                iter += 1;

                if x * x + y * y > 4.0 {
                    break;
                }

                iterations[(xi * PIX_HEIGHT + yi) as usize] = iter;
            }
        }
    }

    let file = std::fs::File::create("plot.ppm").unwrap();
    let mut buf = std::io::BufWriter::new(file);

    write!(buf, "P3\n{} {}\n255\n", PIX_WIDTH, PIX_HEIGHT).unwrap();

    for yi in (0..PIX_HEIGHT).rev() {
        for xi in 0..PIX_WIDTH {
            let color = iterations[(xi * PIX_HEIGHT + yi) as usize] * 255 / MAX_ITERATIONS;

            writeln!(buf, "0 0 {}", color).unwrap();
        }
    }
}
