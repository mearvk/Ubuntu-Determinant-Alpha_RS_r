/*
 * cmd-icon-gen.c — Generate 24x24 BMP icon for .cmd executables
 *
 * Produces the standard .cmd file icon:
 *   - Royal blue outer ring (authority frame)
 *   - Hazy pink abstract ring (soft intermediary)
 *   - Red ring (energy boundary)
 *   - White ring (native clarity)
 *   - Wholesome pink center (warm heart)
 *   - 3D cube in bottom-right corner
 *   - Clear, glossy, square footprint
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * License: GPL-2.0 WITH Classpath-exception-2.0
 * Edition: Galactic Cherry Marvell 98
 * Target: SecureJDK 28 (.cmd format)
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>

#define ICON_SIZE 24
#define BMP_HEADER_SIZE 54
#define PIXEL_DATA_SIZE (ICON_SIZE * ICON_SIZE * 3)
#define FILE_SIZE (BMP_HEADER_SIZE + PIXEL_DATA_SIZE)

/* Color definitions (BGR format for BMP) */
typedef struct { uint8_t b, g, r; } pixel_t;

/* Royal Blue: #4169E1 → BGR: 0xE1, 0x69, 0x41 */
static const pixel_t ROYAL_BLUE     = { 0xE1, 0x69, 0x41 };

/* Hazy Pink: #FFB6C1 → BGR: 0xC1, 0xB6, 0xFF */
static const pixel_t HAZY_PINK      = { 0xC1, 0xB6, 0xFF };

/* Crimson Red: #DC143C → BGR: 0x3C, 0x14, 0xDC */
static const pixel_t CRIMSON_RED    = { 0x3C, 0x14, 0xDC };

/* White: #FFFFFF → BGR: 0xFF, 0xFF, 0xFF */
static const pixel_t WHITE          = { 0xFF, 0xFF, 0xFF };

/* Wholesome Pink: #FFB7C5 → BGR: 0xC5, 0xB7, 0xFF */
static const pixel_t WHOLESOME_PINK = { 0xC5, 0xB7, 0xFF };

/* Cube colors (dark blue face, medium blue face, light blue highlight) */
static const pixel_t CUBE_DARK      = { 0xA0, 0x30, 0x20 }; /* dark navy */
static const pixel_t CUBE_MID       = { 0xC0, 0x50, 0x30 }; /* medium blue */
static const pixel_t CUBE_LIGHT     = { 0xE0, 0x80, 0x50 }; /* lighter face */

/* Gloss highlight */
static const pixel_t GLOSS_WHITE    = { 0xFF, 0xFF, 0xF8 };

/* Background (transparent represented as specific key color) */
static const pixel_t BACKGROUND     = { 0xF0, 0xF0, 0xF0 };


static pixel_t blend(pixel_t base, pixel_t overlay, float alpha)
{
    pixel_t result;
    result.r = (uint8_t)(base.r * (1.0f - alpha) + overlay.r * alpha);
    result.g = (uint8_t)(base.g * (1.0f - alpha) + overlay.g * alpha);
    result.b = (uint8_t)(base.b * (1.0f - alpha) + overlay.b * alpha);
    return result;
}

static float distance_from_center(int x, int y)
{
    float cx = (ICON_SIZE - 1) / 2.0f;
    float cy = (ICON_SIZE - 1) / 2.0f;
    float dx = x - cx;
    float dy = y - cy;
    return sqrtf(dx * dx + dy * dy);
}

static int is_in_square(int x, int y, int margin)
{
    return (x >= margin && x < ICON_SIZE - margin &&
            y >= margin && y < ICON_SIZE - margin);
}

/*
 * Draw the cube motif in the bottom-right corner.
 * A small isometric cube suggests Java/JVM heritage.
 * Occupies roughly pixels (17,17) to (22,22).
 */
static void draw_cube(pixel_t pixels[ICON_SIZE][ICON_SIZE])
{
    /* Cube is 5x5 pixel area in bottom-right */
    int cx = 19; /* cube center x */
    int cy = 19; /* cube center y */

    /* Top face (lightest) */
    pixels[cy - 2][cx]     = CUBE_LIGHT;
    pixels[cy - 2][cx + 1] = CUBE_LIGHT;
    pixels[cy - 1][cx - 1] = CUBE_LIGHT;
    pixels[cy - 1][cx]     = CUBE_LIGHT;
    pixels[cy - 1][cx + 1] = CUBE_LIGHT;
    pixels[cy - 1][cx + 2] = CUBE_LIGHT;

    /* Right face (medium) */
    pixels[cy][cx + 1]     = CUBE_MID;
    pixels[cy][cx + 2]     = CUBE_MID;
    pixels[cy + 1][cx + 1] = CUBE_MID;
    pixels[cy + 1][cx + 2] = CUBE_MID;
    pixels[cy + 2][cx + 1] = CUBE_MID;

    /* Left face (darkest) */
    pixels[cy][cx - 1]     = CUBE_DARK;
    pixels[cy][cx]         = CUBE_DARK;
    pixels[cy + 1][cx - 1] = CUBE_DARK;
    pixels[cy + 1][cx]     = CUBE_DARK;
    pixels[cy + 2][cx]     = CUBE_DARK;
}

/*
 * Apply a gloss/shine effect to the upper-left quadrant.
 * Simulates a clear, glossy surface.
 */
static void apply_gloss(pixel_t pixels[ICON_SIZE][ICON_SIZE])
{
    for (int y = 2; y < 9; y++) {
        for (int x = 2; x < 9; x++) {
            float dist = distance_from_center(x, y);
            if (dist < 10.0f && is_in_square(x, y, 1)) {
                float alpha = 0.15f * (1.0f - dist / 10.0f);
                /* Stronger gloss near top-left */
                float corner_dist = sqrtf((float)(x * x + y * y));
                alpha *= (1.0f - corner_dist / 14.0f);
                if (alpha > 0.0f) {
                    pixels[y][x] = blend(pixels[y][x], GLOSS_WHITE, alpha);
                }
            }
        }
    }
}

/*
 * Generate the ring-based icon.
 *
 * From outside in (using square distance from edge for square footprint):
 *   Edge 0-2:  Royal blue outer ring (corner-aware, authority)
 *   Edge 3-5:  Hazy pink ring (abstract, soft)
 *   Edge 6-8:  Red ring (energy)
 *   Edge 9-10: White ring (native clarity)
 *   Center:    Wholesome pink (warm heart)
 */
static void generate_icon(pixel_t pixels[ICON_SIZE][ICON_SIZE])
{
    float center = (ICON_SIZE - 1) / 2.0f;

    for (int y = 0; y < ICON_SIZE; y++) {
        for (int x = 0; x < ICON_SIZE; x++) {
            /* Use Chebyshev distance (square rings) with slight rounding */
            int dx = abs(x - (int)center);
            int dy = abs(y - (int)center);
            int edge_dist_sq = (dx > dy) ? dx : dy; /* Chebyshev for square */
            float edge_dist_circ = distance_from_center(x, y); /* Euclidean for rounding */

            /* Blend between square and circular for "rounded square" feel */
            float dist = 0.7f * edge_dist_sq + 0.3f * (edge_dist_circ * (ICON_SIZE / 2.0f - 1) / center);

            pixel_t color;

            if (dist >= 10.5f) {
                /* Outside the icon — background */
                color = BACKGROUND;
            } else if (dist >= 9.0f) {
                /* Outer ring: Royal blue with corner emphasis */
                color = ROYAL_BLUE;
                /* Slightly darker at corners for "cornered" look */
                if (dx > 8 && dy > 8) {
                    color = blend(ROYAL_BLUE, CUBE_DARK, 0.3f);
                }
            } else if (dist >= 7.0f) {
                /* Second ring: Hazy pink (abstract/translucent feel) */
                /* Add slight noise/haze by varying alpha based on position */
                float haze = 0.7f + 0.3f * sinf(x * 1.5f + y * 0.7f);
                color = blend(WHITE, HAZY_PINK, haze);
            } else if (dist >= 5.5f) {
                /* Third ring: Crimson red (energy boundary) */
                color = CRIMSON_RED;
            } else if (dist >= 4.0f) {
                /* Fourth ring: White (native clarity) */
                color = WHITE;
            } else {
                /* Center: Wholesome pink (warm heart) */
                color = WHOLESOME_PINK;
                /* Slight radial gradient toward center for depth */
                float center_factor = 1.0f - (dist / 4.0f);
                color = blend(color, WHITE, center_factor * 0.2f);
            }

            pixels[y][x] = color;
        }
    }

    /* Draw the 3D cube in the bottom-right */
    draw_cube(pixels);

    /* Apply glossy highlight */
    apply_gloss(pixels);
}

static void write_bmp(const char *filename, pixel_t pixels[ICON_SIZE][ICON_SIZE])
{
    FILE *f = fopen(filename, "wb");
    if (!f) {
        fprintf(stderr, "Error: cannot open '%s' for writing\n", filename);
        exit(1);
    }

    /* BMP row stride must be multiple of 4 bytes */
    int row_stride = ((ICON_SIZE * 3 + 3) / 4) * 4;
    int padding = row_stride - (ICON_SIZE * 3);
    int pixel_data_size = row_stride * ICON_SIZE;
    int file_size = BMP_HEADER_SIZE + pixel_data_size;

    /* BMP File Header (14 bytes) */
    uint8_t header[54] = {0};
    header[0] = 'B';
    header[1] = 'M';
    header[2] = (file_size) & 0xFF;
    header[3] = (file_size >> 8) & 0xFF;
    header[4] = (file_size >> 16) & 0xFF;
    header[5] = (file_size >> 24) & 0xFF;
    /* reserved: 6-9 = 0 */
    header[10] = BMP_HEADER_SIZE; /* pixel data offset */
    header[11] = 0;
    header[12] = 0;
    header[13] = 0;

    /* BMP Info Header (40 bytes) */
    header[14] = 40; /* header size */
    header[18] = ICON_SIZE & 0xFF; /* width */
    header[19] = (ICON_SIZE >> 8) & 0xFF;
    header[22] = ICON_SIZE & 0xFF; /* height */
    header[23] = (ICON_SIZE >> 8) & 0xFF;
    header[26] = 1; /* color planes */
    header[28] = 24; /* bits per pixel */
    /* compression: 0 (none) at offset 30 */
    header[34] = pixel_data_size & 0xFF;
    header[35] = (pixel_data_size >> 8) & 0xFF;
    header[36] = (pixel_data_size >> 16) & 0xFF;
    header[37] = (pixel_data_size >> 24) & 0xFF;
    /* resolution: 2835 pixels/meter (~72 DPI) */
    header[38] = 0x13; header[39] = 0x0B;
    header[42] = 0x13; header[43] = 0x0B;

    fwrite(header, 1, 54, f);

    /* BMP stores rows bottom-to-top */
    uint8_t pad_bytes[4] = {0};
    for (int y = ICON_SIZE - 1; y >= 0; y--) {
        for (int x = 0; x < ICON_SIZE; x++) {
            fwrite(&pixels[y][x], 1, 3, f);
        }
        if (padding > 0) {
            fwrite(pad_bytes, 1, padding, f);
        }
    }

    fclose(f);
}

static void print_usage(const char *progname)
{
    fprintf(stderr,
        "cmd-icon-gen — Generate 24x24 BMP icon for .cmd executables\n"
        "Usage: %s [options] -o <output.bmp>\n"
        "\n"
        "Options:\n"
        "  -o <file>           Output BMP file (required)\n"
        "  --accent=<color>    Override center color (hex, e.g. FFB7C5)\n"
        "  --cube-position=br  Cube position: br, bl, tr, tl (default: br)\n"
        "  --no-cube           Omit the cube motif\n"
        "  --no-gloss          Omit the gloss effect\n"
        "  --help              Show this help\n"
        "\n"
        "Standard icon: Royal blue outer ring, hazy pink ring, red ring,\n"
        "white native ring, wholesome pink center, 3D cube bottom-right.\n"
        "24x24 pixels, clear and glossy, square footprint.\n"
        "\n"
        "Copyright (C) 2026 MEARVK LLC\n",
        progname);
}

int main(int argc, char **argv)
{
    const char *output_file = NULL;
    int no_cube = 0;
    int no_gloss = 0;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
            output_file = argv[++i];
        } else if (strcmp(argv[i], "--no-cube") == 0) {
            no_cube = 1;
        } else if (strcmp(argv[i], "--no-gloss") == 0) {
            no_gloss = 1;
        } else if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            print_usage(argv[0]);
            return 0;
        }
    }

    if (!output_file) {
        fprintf(stderr, "Error: output file required (-o <file.bmp>)\n");
        print_usage(argv[0]);
        return 1;
    }

    pixel_t pixels[ICON_SIZE][ICON_SIZE];
    memset(pixels, 0, sizeof(pixels));

    generate_icon(pixels);

    if (no_cube) {
        /* Re-render center area over cube region */
        /* (already handled by generate_icon; cube drawn after) */
        /* Actually just skip — re-generate without cube */
        memset(pixels, 0, sizeof(pixels));
        /* Regenerate rings only */
        float center = (ICON_SIZE - 1) / 2.0f;
        for (int y = 0; y < ICON_SIZE; y++) {
            for (int x = 0; x < ICON_SIZE; x++) {
                int dx = abs(x - (int)center);
                int dy = abs(y - (int)center);
                int edge_dist_sq = (dx > dy) ? dx : dy;
                float edge_dist_circ = distance_from_center(x, y);
                float dist = 0.7f * edge_dist_sq + 0.3f * (edge_dist_circ * (ICON_SIZE / 2.0f - 1) / center);
                pixel_t color;
                if (dist >= 10.5f) color = BACKGROUND;
                else if (dist >= 9.0f) { color = ROYAL_BLUE; if (dx > 8 && dy > 8) color = blend(ROYAL_BLUE, CUBE_DARK, 0.3f); }
                else if (dist >= 7.0f) { float haze = 0.7f + 0.3f * sinf(x * 1.5f + y * 0.7f); color = blend(WHITE, HAZY_PINK, haze); }
                else if (dist >= 5.5f) color = CRIMSON_RED;
                else if (dist >= 4.0f) color = WHITE;
                else { color = WHOLESOME_PINK; float cf = 1.0f - (dist / 4.0f); color = blend(color, WHITE, cf * 0.2f); }
                pixels[y][x] = color;
            }
        }
    }

    if (!no_gloss) {
        apply_gloss(pixels);
    }

    write_bmp(output_file, pixels);

    printf("Generated: %s (%dx%d, 24-bit BMP, %d bytes)\n",
           output_file, ICON_SIZE, ICON_SIZE,
           BMP_HEADER_SIZE + (((ICON_SIZE * 3 + 3) / 4) * 4) * ICON_SIZE);

    return 0;
}
