const std = @import("std");
const mandel = @import("mandel.zig");

pub fn main() !void {
    std.debug.print("Hello world\n", .{});

    const height: i32 = 250 * 5;
    const width: i32 = 312 * 5;

    try mandel.generateImage(
        -2.0,
        2.0,
        2.0,
        -2.0,
        height,
        width,
    );

    // try mandel.generateImage(
    //     -0.77568373 + (-0.005) - 0.005,
    //     0.1364678 + (0.005) - 0.002,
    //     -0.77568373 + (0.008) - 0.005,
    //     0.1364678 - (0.005) - 0.002,
    //     height,
    //     width,
    // );
}
