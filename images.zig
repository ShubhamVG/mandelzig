const std = @import("std");

// bf means bitmap file
const BMPHeader = struct {
    bf_type: u16 = 0x4d42, // "BM"
    bf_size: u32,
    bf_reserved: u32 = 0,
    bf_offBits: u32 = 54, // 14 of bf_header + 40 of bi_header
};

// bi means bitmap info (header)
const BMPInfoHeader = struct {
    bi_size: u32 = 40,
    bi_width: i32,
    bi_height: i32,
    bi_planes: u16 = 1,
    bi_bit_count: u16 = 24, // 24 for rgb and 32 for rgba and does not include padding
    bi_compression: u32 = 0,
    bi_image_size: u32,
    bi_horizontal_resolution: i32 = 11811,
    bi_vertical_resolution: i32 = 11811,
    bi_color_palette: u32 = 0,
    bi_color_important: u32 = 0,
};

pub const Pixel = struct { b: u8, g: u8, r: u8 };

pub fn newBMP(
    height: i32,
    width: i32,
    pixels: []Pixel,
) !void {
    const file = try std.fs.cwd().createFile(
        "output.bmp",
        .{ .read = false },
    );

    defer file.close();

    const writer = file.writer();
    var bw = std.io.bufferedWriter(writer);
    const w = bw.writer();

    const img_size: u32 = @intCast(height * width);
    const bmp_header = BMPHeader{ .bf_size = 14 + 40 + img_size };
    const bmp_info_header = BMPInfoHeader{
        .bi_width = width,
        .bi_height = height,
        .bi_image_size = img_size,
    };

    // writing bitmap file header
    try w.writeAll(std.mem.asBytes(&bmp_header.bf_type));
    try w.writeAll(std.mem.asBytes(&bmp_header.bf_size));
    try w.writeAll(std.mem.asBytes(&bmp_header.bf_reserved));
    try w.writeAll(std.mem.asBytes(&bmp_header.bf_offBits));

    // writing bitmap info header
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_size));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_width));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_height));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_planes));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_bit_count));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_compression));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_image_size));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_horizontal_resolution));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_vertical_resolution));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_color_palette));
    try w.writeAll(std.mem.asBytes(&bmp_info_header.bi_color_important));

    // writing pixels with padding
    const padding: usize = @intCast(@mod(@mod((4 - width * @sizeOf(Pixel)), 4), 4));
    var i: usize = 1;

    for (pixels) |pixel| {
        try w.writeByte(pixel.r);
        try w.writeByte(pixel.g);
        try w.writeByte(pixel.b);

        if (i == width) {
            i = 0;
            try w.writeByteNTimes(0x00, padding);
        } else {
            i += 1;
        }
    }

    try bw.flush();
}

const BMPError = error{};
