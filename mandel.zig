const std = @import("std");
const heap = std.heap;

const images = @import("images.zig");

pub fn generateImage(
    x1: f64,
    y1: f64,
    x2: f64,
    y2: f64,
    height: i32,
    width: i32,
) !void {
    const allocator = heap.c_allocator;

    var pixels = try allocator.alloc(images.Pixel, @intCast(height * width));
    defer allocator.free(pixels);

    var z_real: f64 = x1;
    var z_imag: f64 = y1;
    const dx: f64 = (x2 - x1) / @as(f64, @floatFromInt(width));
    const dy: f64 = (y2 - y1) / @as(f64, @floatFromInt(height));
    var idx: usize = 0;

    for (0..@intCast(height)) |_| {
        for (0..@intCast(width)) |_| {
            const count: u8 = iterCount(z_real, z_imag);

            pixels[idx] = images.Pixel{
                .r = count,
                .g = count *% 4,
                .b = count *% 8,
            };

            z_real += dx;
            idx += 1;
        }

        z_imag += dy;
        z_real = x1;
    }

    try images.newBMP(height, width, pixels);
}

fn iterCount(cr: f64, ci: f64) u8 {
    var zr: f64 = cr;
    var zi: f64 = ci;
    const max_iter: u8 = 255;

    for (0..max_iter) |i| {
        const zr_sq: f64 = zr * zr;
        const zi_sq: f64 = zi * zi;

        if (zr_sq + zi_sq >= 4) {
            return @intCast(i);
        }

        zi = 2.0 * zr * zi;
        zr = zr_sq - zi_sq;
        zr += cr;
        zi += ci;
    }

    return 0;
}
