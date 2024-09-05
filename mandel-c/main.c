#include "bmp.h"
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

uint8_t iterCount(double, double);
void generateImage(double x1, double y1, double x2, double y2, int32_t width, int32_t height);

int main(void) {
	const int32_t height = 250 * 8;
	const int32_t width = 312 * 8;

	// const double x1 = -2.0;
	// const double y1 = 2.0;
	// const double x2 = 2.0;
	// const double y2 = -2.0;

	const double x1 = 0.77568373 - 0.005 - 0.005;
	const double y1 = 0.1364678 + 0.005 - 0.002;
	const double x2 = -0.77568373 + 0.008 - 0.005;
	const double y2 = 0.1364678 - 0.005 - 0.002;

	generateImage(x1, x2, y1, y2, width, height);
}

void generateImage(double x1, double y1, double x2, double y2, int32_t width, int32_t height) {
	size_t img_size = (size_t) (width * height);
	Pixel* pixels = (Pixel*) malloc(img_size * sizeof(Pixel));

	double z_real = x1;
	double z_imag = y1;
	double dx = (x2 - x1) / (double) width;
	double dy = (y2 - y1) / (double) height;
	
	size_t idx = 0;

	for (int32_t i = 0; i < height; i++) {
		for (int32_t j = 0; j < width; j++) {
			uint8_t count = iterCount(z_real, z_imag);

			pixels[idx].b = count;
			pixels[idx].g = count * 4;
			pixels[idx].r = count * 9;

			z_real += dx;
			idx++;
		}

		z_imag += dy;
		z_real = x1;
	}

	newBMP(width, height, pixels);

	free(pixels);
}

uint8_t iterCount(double cr, double ci) {
	double zr = cr;
	double zi = ci;

	for (uint8_t i = 0; i < 255; i++) {
		double zr_sq = zr * zr;
		double zi_sq = zi * zi;

		if (zr_sq + zi_sq >= 4) {
			return i;
		}

		zi = 2 * zr * zi;
		zr = zr_sq - zi_sq;
		zr += cr;
		zi += ci;
	}

	return 0;
}
