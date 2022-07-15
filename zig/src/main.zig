const std = @import("std");

const WIDTH = 4.0;
const HEIGHT = 2.0;

const RESOLUTION = 512;

const MAX_ITERATIONS = 1000;

pub fn main() anyerror!void {
    const PIX_WIDTH = @floatToInt(usize, WIDTH) * RESOLUTION;
    const PIX_HEIGHT = @floatToInt(usize, HEIGHT) * RESOLUTION;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const leaked = gpa.deinit();
        if (leaked) @panic("Mem leaked");
    }

    var iters = try allocator.alloc(u32, PIX_WIDTH * PIX_HEIGHT);
    defer allocator.free(iters);

    {
        var xi: usize = 0;
        while (xi < PIX_WIDTH) : (xi += 1) {
            var yi: usize = 0;
            while (yi < PIX_HEIGHT) : (yi += 1) {
                const x0: f64 = -WIDTH / 2.0 + @intToFloat(f64, xi) / @intToFloat(f64, RESOLUTION);
                const y0: f64 = -HEIGHT / 2.0 + @intToFloat(f64, yi) / @intToFloat(f64, RESOLUTION);

                var iter: u32 = 0;
                var x: f64 = 0.0;
                var y: f64 = 0.0;
                while (iter < MAX_ITERATIONS) {
                    var xtemp: f64 = x * x - y * y + x0;
                    y = 2.0 * x * y + y0;
                    x = xtemp;
                    iter += 1;

                    if (x * x + y * y > 4.0)
                        break;
                }

                iters[xi * PIX_HEIGHT + yi] = iter;
            }
        }
    }

    const file = try std.fs.cwd().createFile("plot.ppm", .{});
    defer file.close();

    const writer = file.writer();
    try writer.print("P3\n{} {}\n255\n", .{ PIX_WIDTH, PIX_HEIGHT });

    {
        var yi: i32 = PIX_HEIGHT - 1;
        while (yi >= 0) : (yi -= 1) {
            var xi: i32 = 0;
            while (xi < PIX_WIDTH) : (xi += 1) {
                var color = iters[@intCast(usize, xi * PIX_HEIGHT + yi)] * 255;
                color /= MAX_ITERATIONS;

                try writer.print("0 0 {}\n", .{color});
            }
        }
    }
}
