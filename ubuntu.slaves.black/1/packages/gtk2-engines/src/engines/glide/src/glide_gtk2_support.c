/* Glide - a cairo based GTK+ engine
 * Copyright (C) 2006 Andrew Johnson <acjgenius@earthlink.net>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * Project contact: <gnome-themes-list@gnome.org>
 *
 */


#include "glide_gtk2_engine.h"
#include "glide_gtk2_support.h"
#include "glide_gtk2_drawing.h"

static gdouble default_shades_table[] = 
{
	0.66667,	/* DARKER	*/
	1.5,		/* LIGHTER	*/
	0.112,		/* REDMOND	*/
	0.8,		/* DARK		*/
	1.2		/* LIGHT	*/
};

void
ge_blend_color(const CairoColor *color1, const CairoColor *color2, CairoColor *composite)
{
	g_return_if_fail (color1 && color2 && composite);

	composite->r = (color1->r + color2->r)/2;	
	composite->g = (color1->g + color2->g)/2;	
	composite->b = (color1->b + color2->b)/2;	
	composite->a = (color1->a + color2->a)/2;	
}

typedef struct 
{
	cairo_path_t *clip;

	gint num_layers;
	cairo_pattern_t **layers;
} GlideFill;

static void 
glide_simple_border_gap_clip(cairo_t *canvas,
				gint x,
				gint y,
				gint width,
				gint height,

				GlideSide gap_side,
				gint gap_pos,
				gint gap_size)
{
	if (gap_side == GLIDE_SIDE_NONE)
	{
		return;
	}

	cairo_set_line_width(canvas, 1.0);

	switch (gap_side)
	{
		default:
		case GLIDE_SIDE_TOP:
			cairo_move_to(canvas, x, y);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x + gap_pos + gap_size, y);
			cairo_line_to(canvas, x + gap_pos + gap_size, y + 3);
			cairo_line_to(canvas, x + gap_pos, y + 3);
			cairo_line_to(canvas, x + gap_pos, y);
			cairo_line_to(canvas, x, y);
		break;

		case GLIDE_SIDE_LEFT:
			cairo_move_to(canvas, x, y);
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + 3, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + 3, y + gap_pos);
			cairo_line_to(canvas, x, y + gap_pos);
			cairo_line_to(canvas, x, y);
		break;

		case GLIDE_SIDE_BOTTOM:
			cairo_move_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x, y);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x + gap_pos, y + height);
			cairo_line_to(canvas, x + gap_pos, y + height - 3);
			cairo_line_to(canvas, x + gap_pos + gap_size, y + height - 3);
			cairo_line_to(canvas, x + gap_pos + gap_size, y + height);
			cairo_line_to(canvas, x + width, y + height);
		break;

		case GLIDE_SIDE_RIGHT:
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x, y);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x + width, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + width - 3, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + width - 3, y + gap_pos);
			cairo_line_to(canvas, x + width, y + gap_pos);
			cairo_line_to(canvas, x + width, y);
		break;
	}

	cairo_clip(canvas);
}

void 
do_glide_draw_border_with_gap(cairo_t *canvas,
					CairoColor *base,
					GlideBevelStyle bevel_style,
					GlideBorderType border_type,
					gint x,
					gint y,
					gint width,
					gint height,
					GlideSide gap_side,
					gint gap_pos,
					gint gap_size)
{
	CairoColor color1, color2, color3, color4;
	gboolean inner_overlap = FALSE, outer_overlap = FALSE;

	CairoColor darktone, lighttone, redmondtone;/*, icetone, coldtone,;*/
	CairoColor midtone;/*, black = {0, 0, 0, 1};*/

	if ((border_type == GLIDE_BORDER_TYPE_NONE) 
		|| (bevel_style == GLIDE_BEVEL_STYLE_NONE)) 
	{
		return;
  	}

	ge_shade_color(base, default_shades_table[0], &darktone);

	if (bevel_style == GLIDE_BEVEL_STYLE_FLAT) 
	{
		if (gap_size)
		{
			cairo_save(canvas);

			glide_simple_border_gap_clip(canvas, x, y, width, height, gap_side, gap_pos, gap_size);
		}

		ge_cairo_simple_border(canvas, &darktone, &darktone, x, y, width, height, (gap_side == GLIDE_SIDE_NONE) || ((gap_side == GLIDE_SIDE_BOTTOM) && (gap_size != width)) || ((gap_side == GLIDE_SIDE_RIGHT) && (gap_pos != 0)));

		if (gap_size)
		{
			cairo_restore(canvas);
		}

		return;
	}   
    	
	ge_shade_color(base, default_shades_table[1], &lighttone);

	switch (border_type)
	{
		case GLIDE_BORDER_TYPE_ENGRAVED:
			outer_overlap = TRUE;
			inner_overlap = TRUE;

		case GLIDE_BORDER_TYPE_ETCHED:
		{
			if (bevel_style == GLIDE_BEVEL_STYLE_SMOOTHER)
			{
				ge_shade_color(base, default_shades_table[3], &darktone);
				ge_shade_color(base, default_shades_table[4], &lighttone);
			}

			color1 = lighttone;
			color2 = darktone;
	
			if (border_type == GLIDE_BORDER_TYPE_ENGRAVED)
			{
				CairoColor tmp;

				tmp = color2;
				color2 = color1;
				color1 = tmp;							
			}

			if (gap_size)
			{
				cairo_save(canvas);
				glide_simple_border_gap_clip(canvas, x, y, width, height, gap_side, gap_pos, gap_size);
			}

			ge_cairo_simple_border(canvas, &color2, &color1, x, y, width, height, outer_overlap);

			if (gap_size)
			{
				cairo_restore(canvas);
				cairo_save(canvas);
				glide_simple_border_gap_clip(canvas, x, y, width, height, gap_side, gap_pos + 1, gap_size - 2);
			}

			ge_cairo_simple_border(canvas, &color1, &color2, x+1, y+1, width-2, height-2, inner_overlap);

			if (gap_size)
			{
				cairo_restore(canvas);
			}
		}	
		break;
      
		case GLIDE_BORDER_TYPE_IN:
		case GLIDE_BORDER_TYPE_OUT:
		{
			gboolean invert_in = TRUE;

			if ((bevel_style == GLIDE_BEVEL_STYLE_THINICE)) 
			{
				color1 = darktone;
				color2 = lighttone;
				
				if (border_type == GLIDE_BORDER_TYPE_OUT)
				{
					CairoColor tmp;

					tmp = color2;
					color2 = color1;
					color1 = tmp;							
				}

				if (gap_size)
				{
					cairo_save(canvas);
					glide_simple_border_gap_clip(canvas, x, y, width, height, gap_side, gap_pos, gap_size);
				}

				ge_cairo_simple_border(canvas, &color1, &color2, x, y, width, height, 						(gap_side == GLIDE_SIDE_NONE) || ((gap_side == GLIDE_SIDE_BOTTOM) && (gap_size != width)) || ((gap_side == GLIDE_SIDE_RIGHT) && (gap_pos != 0)));
				if (gap_size)
				{
					cairo_restore(canvas);
				}
			} 
			else 
			{
				switch (bevel_style)
				{            
					case GLIDE_BEVEL_STYLE_REDMOND :
						ge_shade_color(base, default_shades_table[2], &redmondtone);

						if (border_type == GLIDE_BORDER_TYPE_IN)
						{
							color1 = darktone;
							color2 = redmondtone;
							color3 = lighttone;
							color4 = *base;
						} 
						else
						{
							color1 = lighttone;
							color2 = *base;
							color3 = redmondtone;
							color4 = darktone;
						}
						
						outer_overlap = (gap_side == GLIDE_SIDE_NONE) || ((gap_side == GLIDE_SIDE_BOTTOM) && (gap_size != width)) || ((gap_side == GLIDE_SIDE_RIGHT) && (gap_pos != 0));
						inner_overlap = FALSE;
						invert_in = FALSE;
					break;

					case GLIDE_BEVEL_STYLE_SMOOTHER :
						ge_shade_color(base, default_shades_table[3], &darktone);
						ge_shade_color(base, default_shades_table[4], &lighttone);
					case GLIDE_BEVEL_STYLE_SMOOTH :
					default :
						ge_blend_color(&darktone, &lighttone, &midtone);

						if (border_type == GLIDE_BORDER_TYPE_IN)
						{
							color1 = midtone;
							color2 = darktone;
							color3 = lighttone;
							color4 = (bevel_style==GLIDE_BEVEL_STYLE_SMOOTHER)?*base:midtone;

							outer_overlap = FALSE;
							inner_overlap = TRUE;
						}
						else
						{						
							color1 = midtone;
							color2 = lighttone;
							color3 = darktone;
							color4 = (bevel_style==GLIDE_BEVEL_STYLE_SMOOTHER)?*base:midtone;

							outer_overlap = TRUE;
							inner_overlap = (gap_side == GLIDE_SIDE_NONE) || 
										((gap_side == GLIDE_SIDE_BOTTOM) && (gap_size != width)) || ((gap_side == GLIDE_SIDE_RIGHT) && (gap_pos != 0));
						}
						
						invert_in = FALSE;
					break;
				} 

				if ((invert_in) && (border_type == GLIDE_BORDER_TYPE_IN))
				{
					CairoColor tmp;

					tmp = color3;
					color3 = color1;
					color1 = tmp;							

					tmp = color4;
					color4 = color2;
					color2 = tmp;							
				}

				if (gap_size)
				{
					cairo_save(canvas);
					glide_simple_border_gap_clip(canvas, x, y, width, height, gap_side, gap_pos, gap_size);
				}

				ge_cairo_simple_border(canvas, &color1, &color3, x, y, width, height, outer_overlap);

				if (gap_size)
				{
					cairo_restore(canvas);
					cairo_save(canvas);
					glide_simple_border_gap_clip(canvas, x, y, width, height, gap_side, gap_pos + 1, gap_size - 2);
				}
		
				ge_cairo_simple_border(canvas, &color2, &color4, x+1, y+1, width-2, height-2, inner_overlap);

				if (gap_size)
				{
					cairo_restore(canvas);
				}
			} 	
		}	
		break;

		default:
		break;
	}
}

void 
do_glide_draw_border(cairo_t *canvas,
			CairoColor *base,
                        GlideBevelStyle bevel_style,
                        GlideBorderType border_type,
			gint x,
			gint y,
			gint width,
			gint height)

{
	do_glide_draw_border_with_gap(canvas, base, bevel_style, border_type, 
					x, y, width, height, GLIDE_SIDE_NONE, 0, 0);
}

/*#warning - do_glide_draw_option_check needs smarter sizing - perhaps draw check at base size, and scale/translate? */
static void 
do_glide_draw_option_check(cairo_t *canvas,
				CairoColor *check_color,
        	                GlideCheckState check_state,
				gint center_x,
				gint center_y,
				gint radius)
{
	cairo_save(canvas);

	ge_cairo_set_color(canvas, check_color);	

	switch (check_state)
	{
		case GLIDE_CHECK_ON:
		{
			cairo_arc(canvas, center_x, center_y, radius*0.68, 0, 2 * G_PI);
			cairo_fill(canvas);
		}
		break;

		case GLIDE_CHECK_INCONSISTENT:
		{
			gdouble line_width = radius;

			cairo_set_line_cap(canvas, CAIRO_LINE_CAP_ROUND);
			cairo_set_line_width (canvas, line_width);

			cairo_move_to(canvas, center_x - radius + line_width/2, center_y);
			cairo_line_to(canvas, center_x + radius - line_width/2, center_y);

			cairo_stroke (canvas);
		}
		break;

		case GLIDE_CHECK_OFF:
		default:
		{
		}
		break;
	}
	
	cairo_restore(canvas);
}

void 
do_glide_draw_round_option(cairo_t *canvas,
				CairoColor *base,
				CairoColor *fill_color,
				CairoColor *check_color,
        	                GlideBevelStyle bevel_style,
                	        GlideBorderType border_type,
				GlideCheckState check_state,
				gint x,
				gint y,
				gint width,
				gint height)
{
	CairoColor outer_color1, outer_color2, inner_color1, inner_color2;

	CairoColor darktone, lighttone, redmondtone;/*, icetone, coldtone;*/
	CairoColor midtone;/*, black = {0, 0, 0, 1};*/

	gint center_x = x + floor(width/2);
	gint center_y = y + floor(height/2);
	gint radius = floor(MIN(width,height)/2) + 1.5;


	cairo_save(canvas);

	if ((border_type == GLIDE_BORDER_TYPE_NONE) 
		|| (bevel_style == GLIDE_BEVEL_STYLE_NONE)) 
	{
		ge_cairo_set_color(canvas, fill_color);
		cairo_arc(canvas, center_x, center_y, radius, 0, 2 * G_PI);
		cairo_fill(canvas);

		do_glide_draw_option_check(canvas, check_color, check_state, center_x, center_y, radius - 1);

		cairo_restore(canvas);

		return;
  	}

	ge_shade_color(base, default_shades_table[0], &darktone);

	if (bevel_style == GLIDE_BEVEL_STYLE_FLAT) 
	{
		do_glide_draw_simple_circle (canvas, &darktone, &darktone, 
						center_x, center_y, radius);

		ge_cairo_set_color(canvas, fill_color);
		cairo_arc(canvas, center_x, center_y, radius - 1, 0, 2 * G_PI);
		cairo_fill(canvas);

		do_glide_draw_option_check(canvas, check_color, check_state, center_x, center_y, radius - 2);

		cairo_restore(canvas);
		return;
	}   
    	
	ge_shade_color(base, default_shades_table[1], &lighttone);
	cairo_set_line_width (canvas, 1);

	switch (border_type)
	{
		case GLIDE_BORDER_TYPE_ENGRAVED:
		case GLIDE_BORDER_TYPE_ETCHED:
		{
			if (border_type == GLIDE_BORDER_TYPE_ENGRAVED)
			{
				outer_color1 = lighttone;
				outer_color2 = darktone;

				inner_color1 = darktone;
				inner_color2 = lighttone;	
			}
			else			
			{
				outer_color1 = darktone;
				outer_color2 = lighttone;

				inner_color1 = lighttone;
				inner_color2 = darktone;	
			}

			do_glide_draw_simple_circle (canvas, &outer_color1, &outer_color2, 
								center_x, center_y, radius);
			do_glide_draw_simple_circle (canvas, &inner_color1, &inner_color2, 
								center_x, center_y, radius - 1);		

			ge_cairo_set_color(canvas, fill_color);
			cairo_arc(canvas, center_x, center_y, radius - 2, 0, 2 * G_PI);
			cairo_fill(canvas);

			do_glide_draw_option_check(canvas, check_color, check_state, center_x, center_y, radius - 3);
		}	
		break;
      
		case GLIDE_BORDER_TYPE_IN:
		case GLIDE_BORDER_TYPE_OUT:
		{
			gboolean invert_in = TRUE;

			if ((bevel_style == GLIDE_BEVEL_STYLE_THINICE)) 
			{
				outer_color1 = darktone;
				outer_color2 = lighttone;
				
				if (border_type == GLIDE_BORDER_TYPE_OUT)
				{
					CairoColor tmp;

					tmp = outer_color1;
					outer_color1 = outer_color2;
					outer_color2 = tmp;							
				}

				do_glide_draw_simple_circle (canvas, &outer_color1, &outer_color2, 
								center_x, center_y, radius);

				ge_cairo_set_color(canvas, fill_color);
				cairo_arc(canvas, center_x, center_y, radius - 1, 0, 2 * G_PI);
				cairo_fill(canvas);

				do_glide_draw_option_check(canvas, check_color, check_state, center_x, center_y, radius - 2);
			} 
			else 
			{
				switch (bevel_style)
				{            
					case GLIDE_BEVEL_STYLE_REDMOND :
						ge_shade_color(base, default_shades_table[2], &redmondtone);

						if (border_type == GLIDE_BORDER_TYPE_IN)
						{
							outer_color1 = darktone;
							inner_color1 = redmondtone;
							outer_color2 = lighttone;
							inner_color2 = *base;
						} 
						else
						{
							outer_color1 = lighttone;
							inner_color1 = *base;
							outer_color2 = redmondtone;
							inner_color2 = darktone;
						}
						
						invert_in = FALSE;
					break;

					case GLIDE_BEVEL_STYLE_SMOOTHER :
						ge_shade_color(base, default_shades_table[3], &darktone);
						ge_shade_color(base, default_shades_table[4], &lighttone);
					case GLIDE_BEVEL_STYLE_SMOOTH :
					default :
						ge_blend_color(&darktone, &lighttone, &midtone);

						if (border_type == GLIDE_BORDER_TYPE_IN)
						{
							outer_color1 = midtone;
							inner_color1 = darktone;
							outer_color2 = lighttone;
							inner_color2 = (bevel_style==GLIDE_BEVEL_STYLE_SMOOTHER)?*base:midtone;
						}
						else
						{						
							outer_color1 = midtone;
							inner_color1 = lighttone;
							outer_color2 = darktone;
							inner_color2 = (bevel_style==GLIDE_BEVEL_STYLE_SMOOTHER)?*base:midtone;
						}
						
						invert_in = FALSE;
					break;
				} 

				if ((invert_in) && (border_type == GLIDE_BORDER_TYPE_IN))
				{
					CairoColor tmp;

					tmp = outer_color2;
					outer_color2 = outer_color1;
					outer_color1 = tmp;							

					tmp = inner_color2;
					inner_color2 = inner_color1;
					inner_color1 = tmp;							
				}

				do_glide_draw_simple_circle (canvas, &outer_color1, &outer_color2, 
								center_x, center_y, radius);
				do_glide_draw_simple_circle (canvas, &inner_color1, &inner_color2, 
								center_x, center_y, radius - 1);

				ge_cairo_set_color(canvas, fill_color);
				cairo_arc(canvas, center_x, center_y, radius - 2, 0, 2 * G_PI);
				cairo_fill(canvas);

				do_glide_draw_option_check(canvas, check_color, check_state, center_x, center_y, radius - 3);
			} 	
		}	
		break;

		default:
		break;
	}

	cairo_restore(canvas);
}

/***********************************************
 * do_glide_draw_check -
 *  
 *   A simple routine to draw a redmond style
 *   check mark using the passed Color.
 *  
 *   It originated in Smooth-Engine.
 ***********************************************/
void
do_glide_draw_check (cairo_t *canvas,
                       CairoColor * color,
                       gint x, 
                       gint y, 
                       gint width, 
                       gint height)
{ 
/*

EVEN - 

    0   1   2   3   4   5   6   7   8   9
  +---+---+---+---+---+---+---+---+---+---+
0 |   |   |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+---+
1 |   |   |   |   |   |   |   |   | x |   |
  +---+---+---+---+---+---+---+---+---+---+
2 |   |   |   |   |   |   |   | x | x |   |
  +---+---+---+---+---+---+---+---+---+---+
3 |   |   |   |   |   |   | x | x | x |   |
  +---+---+---+---+---+---+---+---+---+---+
4 |   | x |   |   |   | x | x | x |   |   |
  +---+---+---+---+---+---+---+---+---+---+
5 |   | x | x |   | x | x | x |   |   |   |
  +---+---+---+---+---+---+---+---+---+---+
6 |   | x | x | x | x | x |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+---+
7 |   |   | x | x | x |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+---+
8 |   |   |   | x |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+---+
9 |   |   |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+---+

ODD -

    0   1   2   3   4   5   6   7   8
  +---+---+---+---+---+---+---+---+---+
0 |   |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+
1 |   |   |   |   |   |   |   | x |   |
  +---+---+---+---+---+---+---+---+---+
2 |   |   |   |   |   |   | x | x |   |
  +---+---+---+---+---+---+---+---+---+
3 |   | x |   |   |   | x | x | x |   |
  +---+---+---+---+---+---+---+---+---+
4 |   | x | x |   | x | x | x |   |   |
  +---+---+---+---+---+---+---+---+---+
5 |   | x | x | x | x | x |   |   |   |
  +---+---+---+---+---+---+---+---+---+
6 |   |   | x | x | x |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+
7 |   |   |   | x |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+
8 |   |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+---+

*/
  gint odd = 0;
  gdouble left, top;
  gint scale, factor;

  scale = MIN(width, height);

  factor = 10;

  if ((odd = (scale % 2)))
  {
    factor -= 1;
  }

  if (scale <= (factor + 2))
    scale = factor;

  left = x + floor((width - scale) / 2) + 0.5;
  top = y + floor((height - scale) / 2) + 0.5;

  cairo_save(canvas);

  ge_cairo_set_color(canvas, color);	
  cairo_set_line_width(canvas, 0.5);

  cairo_move_to(canvas, left + floor((1*scale)/factor), top + floor(((4-odd)*scale)/factor)); /*(1,4-odd)*/
  cairo_line_to(canvas, left + floor((1*scale)/factor), top + floor(((6-odd)*scale)/factor)); /*(1,6-odd)*/
  cairo_line_to(canvas, left + floor((3*scale)/factor), top + floor(((8-odd)*scale)/factor)); /*(3,8-odd)*/
  cairo_line_to(canvas, left + floor(((8-odd)*scale)/factor), top + floor((3*scale)/factor)); /*(8-odd,3)*/
  cairo_line_to(canvas, left + floor(((8-odd)*scale)/factor), top + floor((1*scale)/factor)); /*(8-odd,1)*/
  cairo_line_to(canvas, left + floor((3*scale)/factor), top + floor(((6-odd)*scale)/factor)); /*(3,6-odd)*/
  cairo_line_to(canvas, left + floor((1*scale)/factor), top + floor(((4-odd)*scale)/factor)); /*(1,4-odd)*/

  cairo_fill_preserve(canvas);
  cairo_stroke(canvas);

  cairo_restore(canvas);
}
 
void
do_glide_draw_simple_circle (cairo_t *canvas,
                     	  		CairoColor * tl,
                       			CairoColor * br,
					gint center_x, 
					gint center_y, 
					gint radius)
{ 
      cairo_new_path (canvas);

      cairo_move_to(canvas, center_x + (radius + 2), center_y + (radius + 2));
      cairo_line_to(canvas, center_x + (radius + 2)*sin(G_PI/4.0), center_y - (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x - (radius + 2)*sin(G_PI/4.0), center_y + (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x + (radius + 2), center_y + (radius + 2));

      cairo_close_path (canvas);

      cairo_save(canvas);

      cairo_clip (canvas);

      ge_cairo_set_color(canvas, br);
      cairo_arc(canvas, center_x, center_y, radius, 0,  2*G_PI);
      cairo_fill(canvas);

      cairo_restore(canvas);

      cairo_save(canvas);
      cairo_new_path (canvas);

      cairo_move_to(canvas, center_x - (radius + 2), center_y - (radius + 2));
      cairo_line_to(canvas, center_x + (radius + 2)*sin(G_PI/4.0), center_y - (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x - (radius + 2)*sin(G_PI/4.0), center_y + (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x - (radius + 2), center_y - (radius + 2));

      cairo_close_path (canvas);

      cairo_clip (canvas);

      ge_cairo_set_color(canvas, tl); 
      cairo_arc(canvas, center_x, center_y, radius, 0, 2*G_PI);
      cairo_fill(canvas);

      cairo_restore(canvas);
}

/***********************************************
 * do_glide_draw_arrow -
 *  
 *   A simple routine to draw a redmond style
 *   arrow using the passed GC.
 *  
 *   Taken in part from smooth, it was based on 
 *   XFCE's & CleanIce draw arrow routines, 
 *   both which  were based on ThinIce's.
 ***********************************************/
void
do_glide_draw_arrow (cairo_t *canvas,
               CairoColor * color,
               GtkArrowType arrow_type,
               gboolean fill,
               gint x, 
               gint y, 
               gint width, 
               gint height)
{
	gint aw = width, ah = height;
 	GdkPoint points[3];

	switch (arrow_type)
	{
		case GTK_ARROW_UP:
		case GTK_ARROW_DOWN:
		{
			gdouble tmp=((aw+1)/2) - ((height%2)?1:0);
       
			if (tmp > ah) 
			{
				aw = 2*ah - 1 - ((height%2)?1:0);
				ah = (aw+1)/2;
			} 
			else 
			{
				ah = (gint) tmp;
				aw = 2*ah - 1;
			}  
 
			if ((aw < 5) || (ah < 3)) 
			{
				aw = 5;
				ah = 3;
			}
 
			x += (width - aw) / 2 ;
			y += (height - ah) / 2;
			width = aw;
			height = ah;
 		
			width += width % 2 - 1;

			points[0].x = x;
			points[1].x = x + width - 1;
			points[2].x = x + ((height - 1) - (height - (1 + width / 2)));

			points[0].y = points[1].y = y;
			points[2].y = y + height - 1;

			if (arrow_type == GTK_ARROW_UP)
			{
				gint flip = points[1].y;

				points[0].y = points[1].y = points[2].y;
				points[2].y = flip;
			}
		}
		break;

		case GTK_ARROW_LEFT:
		case GTK_ARROW_RIGHT:
		{
			gdouble tmp=((ah+1)/2) - ((width%2)?1:0);
 
			if (tmp > aw) 
			{
				ah = 2*aw - 1 - ((width%2)?1:0);
				aw = (ah+1)/2;
			} 
			else 
			{
				aw = (gint) tmp;
				ah = 2*aw - 1;
			}  
 
			if ((ah < 5) || (aw < 3)) 
			{
				ah = 5;
				aw = 3;
			}
 
			x += (width - aw) / 2 ;
			y += (height - ah) / 2;
			width = aw;
			height = ah;
 
			height += height % 2 - 1;

			points[0].y = y;
			points[1].y = y + height - 1;
			points[2].y = y + ((width - 1) - (width - (1 + height / 2)));

			points[0].x = points[1].x = x;
			points[2].x = x + width - 1;

			if (arrow_type == GTK_ARROW_LEFT)
			{
				gint flip = points[0].x;

				points[0].x = points[1].x = points[2].x;
				points[2].x = flip;
			}
		}
		break;

		default:
		{
			return;
		}
	}

	cairo_save(canvas);

	ge_cairo_set_color(canvas, color);	
	cairo_set_line_width (canvas, 0.5);

	cairo_move_to(canvas, points[0].x + 0.5, points[0].y + 0.5);
	cairo_line_to(canvas, points[1].x + 0.5, points[1].y + 0.5);
	cairo_line_to(canvas, points[2].x + 0.5, points[2].y + 0.5);
	cairo_line_to(canvas, points[0].x + 0.5, points[0].y + 0.5);

	if (fill)
	{
		cairo_stroke_preserve(canvas);

		cairo_fill(canvas);
	}
	else
	{
		cairo_stroke(canvas);
	}

	cairo_restore(canvas);
}
 
/***********************************************
 * do_glide_draw_line -
 *  
 *   A simple routine to draw a redmond style
 *   spacer line.
 ***********************************************/
void
do_glide_draw_line(cairo_t *canvas,
             CairoColor * dark,
             CairoColor * light,
             GdkRectangle * area,
             gint start,
             gint end,
             gint base,
             gboolean horizontal)
{  
  cairo_set_line_width (canvas, 1);

  if (horizontal) 
    {
      ge_cairo_set_color(canvas, dark);	
      cairo_move_to(canvas, start + 1.5, base + 0.5);
      cairo_line_to(canvas, end - 1.5, base + 0.5);
      cairo_stroke(canvas);

      ge_cairo_set_color(canvas, light);	
      cairo_move_to(canvas, start + 1.5, base + 1.5);
      cairo_line_to(canvas, end - 1.5, base + 1.5);
      cairo_stroke(canvas);
    } 
  else 
    {
      ge_cairo_set_color(canvas, dark);	
      cairo_move_to(canvas, base + 0.5, start + 1.5);
      cairo_line_to(canvas, base + 0.5, end - 1.5);
      cairo_stroke(canvas);

      ge_cairo_set_color(canvas, light);	
      cairo_move_to(canvas, base + 1.5, start + 1.5);
      cairo_line_to(canvas, base + 1.5, end - 1.5);
      cairo_stroke(canvas);
    }
}
 
static void
do_glide_draw_dot (cairo_t *canvas,
			CairoColor * light,
			CairoColor * dark,
			CairoColor * mid,
			gint x,
			gint y)
{
	ge_cairo_set_color(canvas, dark);	
	cairo_rectangle (canvas, x - 1, y - 1, 1, 1);
	cairo_rectangle (canvas, x - 0, y - 1, 1, 1);
	cairo_rectangle (canvas, x - 1, y - 0, 1, 1);
	cairo_fill(canvas);

	ge_cairo_set_color(canvas, light);	
	cairo_rectangle (canvas, x + 1, y + 1, 1, 1);
	cairo_rectangle (canvas, x + 0, y + 1, 1, 1);
	cairo_rectangle (canvas, x + 1, y + 0, 1, 1);
	cairo_fill(canvas);

	ge_cairo_set_color(canvas, mid);	
	cairo_rectangle (canvas, x + 1, y - 1, 1, 1);
	cairo_rectangle (canvas, x - 1, y + 1, 1, 1);
	cairo_fill(canvas);
}

void
do_glide_draw_grip (cairo_t *canvas,
			CairoColor * light,
			CairoColor * dark,
			gint x,
			gint y,
			gint width,
			gint height,
			gboolean vertical)
{
	gint modx=0, mody=0;
	CairoColor mid;
	
	if (vertical) 
		mody = 5; 
	else
		modx = 5;
	
	cairo_save(canvas);

	cairo_set_line_width (canvas, 0.5);
	cairo_set_antialias(canvas, CAIRO_ANTIALIAS_NONE);

	ge_blend_color(dark, light, &mid);	

	do_glide_draw_dot (canvas,
		 light, dark, &mid,
		 x + width / 2 - modx + 1,
		 y + height / 2 - mody);
	do_glide_draw_dot (canvas,
		 light, dark, &mid,
		 x + width / 2 + 1,
		 y + height / 2);
	do_glide_draw_dot (canvas,
		 light, dark, &mid,
		 x + width / 2 + modx + 1,
		 y + height / 2 + mody);

	cairo_restore(canvas);
}

/***********************************************/
/* MenuShell/MenuBar Item Prelight Workaround  */
/***********************************************/
 
/***********************************************
 * gtk_menu_shell_cleanup_signals -
 *  
 *   Cleanup/remove Menu Shell signals
 ***********************************************/
static void
glide_gtk2_engine_hack_menu_shell_cleanup(GtkWidget *widget)
{
  if (GE_IS_MENU_BAR(widget))
    {
      gint id = 0;
 
      id = (gint)g_object_steal_data (G_OBJECT(widget), "GLIDE_MENU_SHELL_MOTION_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
                                             
      id = (gint)g_object_steal_data (G_OBJECT(widget), "GLIDE_MENU_SHELL_LEAVE_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
     
      id = (gint)g_object_steal_data (G_OBJECT(widget), "GLIDE_MENU_SHELL_DESTROY_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
       
      id = (gint)g_object_steal_data (G_OBJECT(widget), "GLIDE_MENU_SHELL_STYLE_SET_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
       
      g_object_steal_data (G_OBJECT(widget), "GLIDE_MENU_SHELL_HACK_SET");      
    }
}

/***********************************************
 * glide_gtk2_engine_hack_menu_shell_style_set -
 *  
 *   Style set signal to ensure menushell signals
 *   get cleaned up if the theme changes
 ***********************************************/
static gboolean 
glide_gtk2_engine_hack_menu_shell_style_set(GtkWidget *widget,
                         GtkStyle *previous_style,
                         gpointer user_data)
{
  glide_gtk2_engine_hack_menu_shell_cleanup(widget);
  
  return FALSE;
}
 
/***********************************************
 * gtk_menu_shell_destroy -
 *  
 *   Destroy signal to ensure menushell signals
 *   get cleaned if it is destroyed
 ***********************************************/
static gboolean    
glide_gtk2_engine_hack_menu_shell_destroy(GtkWidget *widget,
                       GdkEvent *event,
                       gpointer user_data)
{
 glide_gtk2_engine_hack_menu_shell_cleanup (widget);
  
  return FALSE;
}
 
/***********************************************
 * glide_gtk2_engine_hack_menu_shell_motion -
 *  
 *   Motion signal to ensure menushell items
 *   prelight state changes on mouse move.
 ***********************************************/
static gboolean 
glide_gtk2_engine_hack_menu_shell_motion(GtkWidget *widget, 
                      GdkEventMotion *event, 
                      gpointer user_data)
{
  if (GE_IS_MENU_SHELL(widget))
    {
      gint pointer_x, pointer_y;
      GdkModifierType pointer_mask;
      GList *children = NULL, *child = NULL;
     
      gdk_window_get_pointer(widget->window, &pointer_x, &pointer_y, &pointer_mask);
	    
      if (GE_IS_CONTAINER(widget))
        {
          children = gtk_container_get_children(GTK_CONTAINER(widget));
              
          for (child = g_list_first(children); child; child = g_list_next(child))
            {
	      if ((child->data) && GE_IS_WIDGET(child->data) && 
                  (GTK_WIDGET_STATE(GTK_WIDGET(child->data)) != GTK_STATE_INSENSITIVE))
	        {
	          if ((pointer_x >= GTK_WIDGET(child->data)->allocation.x) && 
	              (pointer_y >= GTK_WIDGET(child->data)->allocation.y) &&
	              (pointer_x < (GTK_WIDGET(child->data)->allocation.x + 
	                              GTK_WIDGET(child->data)->allocation.width)) && 
	              (pointer_y < (GTK_WIDGET(child->data)->allocation.y +
	                              GTK_WIDGET(child->data)->allocation.height)))
	            {
                      gtk_widget_set_state (GTK_WIDGET(child->data), GTK_STATE_PRELIGHT);
	            }
	          else
                    {
                      gtk_widget_set_state (GTK_WIDGET(child->data), GTK_STATE_NORMAL);
                    }
                 }
             }	            
         
           if (children)   
             g_list_free(children);
        }
    }
 
  return FALSE;
}
 
/***********************************************
 * gtk_menu_shell_leave -
 *  
 *   Leave signal to ensure menushell items
 *   normal state on mouse leave.
 ***********************************************/
static gboolean 
glide_gtk2_engine_hack_menu_shell_leave(GtkWidget *widget, 
                      GdkEventCrossing *event,
                      gpointer user_data)
{
  if (GE_IS_MENU_SHELL(widget))
    {
      GList *children = NULL, *child = NULL;
 
      if (GE_IS_CONTAINER(widget))
        {
          children = gtk_container_get_children(GTK_CONTAINER(widget));
              
          for (child = g_list_first(children); child; child = g_list_next(child))
            {
	      if ((child->data) && GE_IS_MENU_ITEM(child->data) && 
                  (GTK_WIDGET_STATE(GTK_WIDGET(child->data)) != GTK_STATE_INSENSITIVE))
	        {
                  if ((!GE_IS_MENU(GTK_MENU_ITEM(child->data)->submenu)) || 
                      (!(GTK_WIDGET_REALIZED(GTK_MENU_ITEM(child->data)->submenu) && 
                         GTK_WIDGET_VISIBLE(GTK_MENU_ITEM(child->data)->submenu) &&
                         GTK_WIDGET_REALIZED(GTK_MENU(GTK_MENU_ITEM(child->data)->submenu)->toplevel) &&
                         GTK_WIDGET_VISIBLE(GTK_MENU(GTK_MENU_ITEM(child->data)->submenu)->toplevel))))
	          {
                    gtk_widget_set_state (GTK_WIDGET(child->data), GTK_STATE_NORMAL);
                  }
                }	            
            }         
            
          if (children)   
  	    g_list_free(children);
        }
    }
 
  return FALSE;
}
 
/***********************************************
 * gtk_menu_shell_setup_signals -
 *  
 *   Setup Menu Shell with signals to ensure
 *   prelight works on items
 ***********************************************/
void
glide_gtk2_engine_hack_menu_shell_setup(GtkWidget *widget)
{
  if (GE_IS_MENU_BAR(widget))
    {
      gint id = 0;
 
      if (!g_object_get_data(G_OBJECT(widget), "GLIDE_MENU_SHELL_HACK_SET"))
      {
        id = g_signal_connect(G_OBJECT(widget), "motion-notify-event",
                                             (GCallback)glide_gtk2_engine_hack_menu_shell_motion,
                                             NULL);
                                  
        g_object_set_data(G_OBJECT(widget), "GLIDE_MENU_SHELL_MOTION_ID", (gpointer)id);
        
        id = g_signal_connect(G_OBJECT(widget), "leave-notify-event",
                                             (GCallback)glide_gtk2_engine_hack_menu_shell_leave,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "GLIDE_MENU_SHELL_LEAVE_ID", (gpointer)id);
                                             
        id = g_signal_connect(G_OBJECT(widget), "destroy-event",
                                             (GCallback)glide_gtk2_engine_hack_menu_shell_destroy,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "GLIDE_MENU_SHELL_DESTROY_ID", (gpointer)id);
 
        g_object_set_data(G_OBJECT(widget), "GLIDE_MENU_SHELL_HACK_SET", (gpointer)1);
        
        id = g_signal_connect(G_OBJECT(widget), "style-set",
                                             (GCallback)glide_gtk2_engine_hack_menu_shell_style_set,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "GLIDE_MENU_SHELL_STYLE_SET_ID", (gpointer)id);
      }
    }  
}
