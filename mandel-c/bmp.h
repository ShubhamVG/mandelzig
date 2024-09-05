#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct __attribute__((__packed__)) {
	uint16_t bf_type;
	uint32_t bf_size;
	uint32_t bf_reserved;
	uint32_t bf_offbits;
} BMPHeader;

typedef struct __attribute__((__packed__)) {
	uint32_t bi_size;
	int32_t bi_width;
	int32_t bi_height;
	uint16_t bi_planes;
	uint16_t bi_bitcount;
	uint32_t bi_compression;
	uint32_t bi_image_size;
	int32_t bi_hor_res;
	int32_t bi_vert_res;
	uint32_t bi_color_palette;
	uint32_t bi_color_imp;
} BMPInfoHeader;

typedef struct __attribute__((__packed__)) {
	uint8_t b;
	uint8_t g;
	uint8_t r;
} Pixel;

void newBMP(int32_t width, int32_t height, Pixel* pixels) {
	uint32_t img_size = (uint32_t) (width * height);

	BMPHeader header;
	header.bf_type = 0x4d42;
	header.bf_size = 14 + 40 + img_size;
	header.bf_reserved = 0;
	header.bf_offbits = 54;
	
	BMPInfoHeader info_header;
	info_header.bi_size = 40;
	info_header.bi_width = width;
	info_header.bi_height = height;
	info_header.bi_planes = 1;
	info_header.bi_bitcount = 24;
	info_header.bi_compression = 0;
	info_header.bi_image_size = img_size;
	info_header.bi_hor_res = 11811;
	info_header.bi_vert_res = 11811;
	info_header.bi_color_palette = 0;
	info_header.bi_color_imp = 0;

	FILE* output = fopen("output.bmp", "w");
	fwrite(&header, sizeof(BMPHeader), 1, output);
	fwrite(&info_header, sizeof(BMPInfoHeader), 1, output);

	size_t pixel_size = sizeof(Pixel);
	int padding = (4 - (width * pixel_size) % 4) % 4;
	int32_t i = 0;

	for (uint32_t idx = 0; idx < img_size; idx++) {
		Pixel pixel = pixels[idx];
		fwrite(&pixel, pixel_size, 1, output);

		if (i == width) {
			i = 0;
			const uint8_t zero_byte = 0x00;
			fwrite(&zero_byte, 1, padding, output);
		} else {
			i++;
		}
	}

	fclose(output);
}
