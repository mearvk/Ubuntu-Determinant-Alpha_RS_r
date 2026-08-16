#include "crux-draw.h"
#include "crux-style.h"

#include <ge-support.h>

#include <stdio.h>
#include <math.h>
#include <string.h>

#define DEBUG 0

#define DETAIL(xx) ((detail) != 0 && strcmp (xx, detail) == 0)

#define OUTLINE_SHADE 0.5

#define CRUX_LIGHT(xx, yy) ge_shade_color (&xx, 1.5, &yy) /* yy.r = xx.r + 56/255.0;yy.g = xx.g + 47/255.0;yy.b = xx.b + 45/255.0; */
#define CRUX_DARK(xx, yy) ge_shade_color (&xx, 0.9, &yy) /* yy.r = xx.r - 25/255.0;yy.g = xx.g - 27/255.0;yy.b = xx.b - 21/255.0; */

static GtkStyleClass *parent_style_class;

static void
draw_hline (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail,
	    gint x1, gint x2, gint y);

static void
draw_vline (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GdkRectangle *area,
	    GtkWidget *widget, const gchar *detail, gint y1, gint y2, gint x);

static void
draw_shadow (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail, gint x, gint y, gint width, gint height);

static void
draw_box (GtkStyle *style,
	  GdkWindow *window,
	  GtkStateType state_type,
	  GtkShadowType shadow_type,
	  GdkRectangle *area,
	  GtkWidget *widget,
	  const gchar *detail, gint x, gint y, gint width, gint height);

static void
draw_arrow (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GtkShadowType shadow_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail,
	    GtkArrowType arrow_type,
	    gint fill, gint x, gint y, gint width, gint height);

static void
draw_check (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GtkShadowType shadow_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail, gint x, gint y, gint width, gint height);
static void
draw_option (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail, gint x, gint y, gint width, gint height);

static void
draw_tab (GtkStyle *style,
	  GdkWindow *window,
	  GtkStateType state_type,
	  GtkShadowType shadow_type,
	  GdkRectangle *area,
	  GtkWidget *widget,
	  const gchar *detail, gint x, gint y, gint width, gint height);

static void
draw_shadow_gap (GtkStyle *style,
		 GdkWindow *window,
		 GtkStateType state_type,
		 GtkShadowType shadow_type,
		 GdkRectangle *area,
		 GtkWidget *widget,
		 const gchar *detail,
		 gint x,
		 gint y,
		 gint width,
		 gint height,
		 GtkPositionType gap_side, gint gap_x, gint gap_width);

static void
draw_box_gap (GtkStyle *style,
	      GdkWindow *window,
	      GtkStateType state_type,
	      GtkShadowType shadow_type,
	      GdkRectangle *area,
	      GtkWidget *widget,
	      const gchar *detail,
	      gint x,
	      gint y,
	      gint width,
	      gint height,
	      GtkPositionType gap_side, gint gap_x, gint gap_width);

static void
draw_extension (GtkStyle *style,
		GdkWindow *window,
		GtkStateType state_type,
		GtkShadowType shadow_type,
		GdkRectangle *area,
		GtkWidget *widget,
		const gchar *detail,
		gint x,
		gint y, gint width, gint height, GtkPositionType gap_side);

static void
draw_focus (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail,
	    gint x,
	    gint y,
	    gint width,
	    gint height);

static void
draw_slider (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail,
	     gint x,
	     gint y, gint width, gint height, GtkOrientation orientation);

static void
draw_handle (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail,
	     gint x,
	     gint y, gint width, gint height, GtkOrientation orientation);


static void
paint_shadow (cairo_t *cr, GtkStyle *style,
		    GtkStateType state_type,
		    GtkShadowType shadow_type,
		    gdouble x, gdouble y, gdouble width, gdouble height);


/* utility functions */

static inline void
debug (const char *fmt, ...)
{
    if (DEBUG)
    {
	va_list args;
	va_start (args, fmt);
	vfprintf (stderr, fmt, args);
	va_end (args);
    }
}

static void
paint_menuitem (cairo_t *cr, GtkStyle *style, GtkStateType state_type,
	gdouble x, gdouble y, gdouble width, gdouble height)
{
	cairo_pattern_t * crp;
	CairoColor c1;

	/* TODO: this is wasteful, since paint_shadow () adds an extra shadow that is
	 * drawn over by the gradient
	 */
	paint_shadow (cr, style, state_type, GTK_SHADOW_IN, x, y, width, height);

	x += 2.0; y += 2.0; width -= 4.0; height -= 4.0;

	ge_gdk_color_to_cairo (&style->bg[state_type], &c1);
	crp = cairo_pattern_create_linear (x, y, x, y + height);
	cairo_pattern_add_color_stop_rgb (crp, 0.0, c1.r, c1.g, c1.b);
	ge_shade_color (&c1, 1.3, &c1);
	cairo_pattern_add_color_stop_rgb (crp, 0.35, c1.r, c1.g, c1.b);
	cairo_pattern_add_color_stop_rgb (crp, 0.28, c1.r, c1.g, c1.b);
	ge_shade_color (&c1, 0.6, &c1);
	cairo_pattern_add_color_stop_rgb (crp, 1.0, c1.r, c1.g, c1.b);
	cairo_rectangle (cr, x, y, width, height);
	cairo_set_source (cr, crp);
	cairo_fill (cr);
	cairo_pattern_destroy (crp);
}

static void
paint_button (cairo_t *cr, GtkStyle *style,
		GtkStateType state_type, GtkShadowType shadow_type,
		gboolean has_focus, gboolean extra_shadow,
		gdouble x, gdouble y, gdouble width, gdouble height)
{
	gdouble radius = (extra_shadow) ? 3.5 : 2.5;
	cairo_pattern_t *crp;
	CairoColor base, inner_top, inner_bot, grad_top, grad_bot, stroke;
        gdouble h, s, b;

	if (shadow_type == GTK_SHADOW_NONE)
		return;

	/* calculate colours */
	ge_gdk_color_to_cairo (&style->bg[state_type], &base);
	ge_hsb_from_color (&base, &h, &s, &b);
	ge_color_from_hsb (h, s, b - 0.52, &stroke);

	if (extra_shadow)
	{
		/* extra shadow and focus indicator */
		if (has_focus)
		{
			CairoColor c;
			ge_gdk_color_to_cairo (&style->bg[GTK_STATE_SELECTED], &c);
			cairo_set_source_rgba (cr, c.r, c.g, c.b, 0.6);
		}
		else
		{
			if (state_type == GTK_STATE_INSENSITIVE)
				cairo_set_source_rgba (cr, 0, 0, 0, 0.05);
			else
				cairo_set_source_rgba (cr, 0, 0, 0, 0.1);
		}
		ge_cairo_rounded_rectangle (cr, x, y, width, height, radius, CR_CORNER_ALL);
		cairo_fill (cr);

		--radius;
		++x; ++y; width -= 2; height -= 2;
	}

	if (shadow_type == GTK_SHADOW_IN || shadow_type == GTK_SHADOW_ETCHED_IN)
	{
		/* outline */
		if (state_type == GTK_STATE_INSENSITIVE)
			gdk_cairo_set_source_color (cr, &style->fg [state_type]);
		else
			ge_cairo_set_color (cr, &stroke);
		ge_cairo_rounded_rectangle (cr, x, y, width, height, radius, CR_CORNER_ALL);
		cairo_fill (cr);

		++x; ++y; width -= 2; height -= 2;

		ge_cairo_rounded_rectangle (cr, x, y, width, height, radius, CR_CORNER_ALL);
		if (state_type != GTK_STATE_INSENSITIVE)
		{
			/* gradient fill */
			crp = cairo_pattern_create_linear (x, y, x, y +height);
			ge_color_from_hsb (h, s, b - 0.05, &grad_top);
			ge_color_from_hsb (h, s, b - 0.2, &grad_bot);
			cairo_pattern_add_color_stop_rgb (crp, 0.0, grad_top.r, grad_top.g, grad_top.b);
			cairo_pattern_add_color_stop_rgb (crp, 0.3, grad_top.r, grad_top.g, grad_top.b);
			cairo_pattern_add_color_stop_rgb (crp, 0.9, grad_bot.r, grad_bot.g, grad_bot.b);
			cairo_pattern_add_color_stop_rgb (crp, 1.0, grad_bot.r, grad_bot.g, grad_bot.b);
			cairo_set_source (cr, crp);
			cairo_fill (cr);
			cairo_pattern_destroy (crp);
		}
		else
		{
			ge_cairo_set_color (cr, &base);
			cairo_fill (cr);
		}

		x += 0.5; y += 0.5; height--; width--;

		/* inside shadow */
		--radius;
		cairo_move_to (cr, x, y + height);
		cairo_arc (cr, x + radius, y + radius, radius, G_PI, G_PI * 1.5);
		cairo_line_to (cr, x + width, y);
		if (state_type == GTK_STATE_INSENSITIVE)
			cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.1);
		else
			cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.2);
		cairo_stroke (cr);

		cairo_move_to (cr, x + 1.0, y + height);
		cairo_line_to (cr, x + 1.0, y + 1);
		cairo_line_to (cr, x + width, y + 1);
		cairo_line_to (cr, x + width, y + height);
		cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.05);
		cairo_stroke (cr);


		if (state_type == GTK_STATE_INSENSITIVE)
			return;

		cairo_rectangle (cr, x + 1.0, y + 1.0, width - 2, height - 1);
		cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.03);
		cairo_stroke (cr);
		return;
	}

	if (shadow_type == GTK_SHADOW_OUT || shadow_type == GTK_SHADOW_ETCHED_OUT)
	{
		if (state_type == GTK_STATE_INSENSITIVE)
		{
			/* disabled gray stroke */
			ge_cairo_rounded_rectangle (cr, x, y, width, height, radius, CR_CORNER_ALL);
			gdk_cairo_set_source_color (cr, &style->fg [state_type]);
			cairo_fill (cr);

			--radius;
			++x; ++y; width -= 2; height -= 2;

			ge_cairo_rounded_rectangle (cr, x, y, width, height , radius, CR_CORNER_ALL);
			gdk_cairo_set_source_color (cr, &style->bg [state_type]);
			cairo_fill (cr);

			return;
		}


		ge_color_from_hsb (h, s, b + 0.156, &inner_top);
		ge_color_from_hsb (h, s, b, &inner_bot);
		ge_color_from_hsb (h, s, b + 0.117, &grad_top);
		ge_color_from_hsb (h, s, b - 0.117, &grad_bot);

		/* border */
		ge_cairo_rounded_rectangle (cr, x, y, width, height, radius, CR_CORNER_ALL);
		ge_cairo_set_color (cr, &stroke);
		cairo_fill (cr);


		/* inner stroke */
		++x; ++y;
		width -= 2; height -= 2;
		--radius;

		crp = cairo_pattern_create_linear (x, y, x, y + height);
		cairo_pattern_add_color_stop_rgb (crp, 0.0, inner_top.r, inner_top.g, inner_top.b);
		cairo_pattern_add_color_stop_rgb (crp, 1.0, inner_bot.r, inner_bot.g, inner_bot.b);
		cairo_set_source (cr, crp);

		ge_cairo_rounded_rectangle (cr, x, y, width, height, radius, CR_CORNER_ALL);
		cairo_fill (cr);
		cairo_pattern_destroy (crp);


		/* gradient */
		x+=.5; y+=.5;
		width -= 1; height -= 1;

		crp = cairo_pattern_create_linear (x, y, x, y + height);
		cairo_pattern_add_color_stop_rgb (crp, 0.0, grad_top.r, grad_top.g, grad_top.b);
		cairo_pattern_add_color_stop_rgb (crp, 0.14, grad_top.r, grad_top.g, grad_top.b);
		cairo_pattern_add_color_stop_rgb (crp, 0.86, grad_bot.r, grad_bot.g, grad_bot.b);
		cairo_pattern_add_color_stop_rgb (crp, 1.0, grad_bot.r, grad_bot.g, grad_bot.b);
		cairo_set_source (cr, crp);

		cairo_rectangle (cr, x, y, width, height);
		cairo_fill (cr);
		cairo_pattern_destroy (crp);
	}
}

static void
paint_shadow (cairo_t *cr, GtkStyle *style,
		    GtkStateType state_type,
		    GtkShadowType shadow_type,
		    gdouble x, gdouble y, gdouble width, gdouble height)
{
	CairoColor bg, border;
	CairoColor tl, bl;

	ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
	ge_shade_color (&bg, OUTLINE_SHADE, &border); /* border */

	x += 0.5; y += 0.5; width--; height--;

	tl.r = 1; tl.g = 1; tl.b = 1; tl.a = 0.7;
	bl.r = 0; bl.g = 0; bl.b = 0; bl.a = 0.2;

	if (shadow_type == GTK_SHADOW_OUT)
	{
		ge_cairo_set_color (cr, &border);
		ge_cairo_stroke_rectangle (cr, x, y, width, height);
		x++; y++; width -= 2.0; height -= 2.0;
		ge_cairo_simple_border (cr, &tl, &bl, x, y, width +1, height +1, TRUE);
	}
	else if (shadow_type == GTK_SHADOW_IN)
	{
		ge_cairo_simple_border (cr, &bl, &tl, x, y, width +1, height +1, TRUE);
		x++; y++; width -= 2.0; height -= 2.0;
		ge_cairo_set_color (cr, &border);
		ge_cairo_stroke_rectangle (cr, x, y, width, height);
	}
	else if (shadow_type == GTK_SHADOW_ETCHED_IN)
	{
		ge_cairo_simple_border (cr, &bl, &tl, x, y, width +1, height +1, TRUE);
		x++; y++; width -= 2.0; height -= 2.0;
		ge_cairo_simple_border (cr, &tl, &bl, x, y, width +1, height +1, TRUE);
	}
	else if (shadow_type == GTK_SHADOW_ETCHED_OUT)
	{
		ge_cairo_simple_border (cr, &tl, &bl, x, y, width +1, height +1, TRUE);
		x++; y++; width -= 2.0; height -= 2.0;
		ge_cairo_simple_border (cr, &bl, &tl, x, y, width +1, height +1, TRUE);
	}

}

static void
paint_entry_shadow (cairo_t *cr, GtkStyle *style,
		    GtkStateType state_type,
		    gboolean focused,
		    gdouble x, gdouble y, gdouble width, gdouble height)
{

	cairo_pattern_t *crp;

	x += 0.5; y += 0.5;
	width -= 1.0; height -= 1.0;


	/* Outer Line */
	if (focused)
	{
		gdk_cairo_set_source_color (cr, &style->light[GTK_STATE_SELECTED]);
		ge_cairo_stroke_rectangle (cr, x, y, width, height);
	}
	else
	{
		crp = cairo_pattern_create_linear (x, y, x, y + height);
		/* TODO: Find a way to calculate these values */
		cairo_pattern_add_color_stop_rgb (crp, 0.0, 185/255.0, 189/255.0, 182/255.0);
		cairo_pattern_add_color_stop_rgb (crp, 1.0, 238/255.0, 238/255.0, 236/255.0);
		cairo_set_source (cr, crp);
		ge_cairo_stroke_rectangle (cr, x, y, width, height);
		cairo_pattern_destroy (crp);
	}

	/* inner Line */
	/* TODO: Find a way to calculate these values */
	if (state_type == GTK_STATE_INSENSITIVE)
		gdk_cairo_set_source_color (cr, &style->fg [state_type]);
	else
		cairo_set_source_rgb (cr, 54/255.0, 52/255.0, 54/255.0);

	ge_cairo_stroke_rectangle (cr, x + 1.0, y + 1.0, width - 2.0, height - 2.0);

	/* inner shadow */

	/* make sure background is initialised as shadow is only in top left */
	gdk_cairo_set_source_color (cr, &style->base[(state_type == GTK_STATE_INSENSITIVE) ? GTK_STATE_INSENSITIVE : GTK_STATE_NORMAL]);
	ge_cairo_stroke_rectangle (cr, x + 2.0, y + 2.0, width - 4.0, height - 4.0);

	/* draw shadow */
	cairo_move_to (cr, x + 2.0, y + height - 2.0);
	cairo_line_to (cr, x + 2.0, y + 2.0);
	cairo_line_to (cr, x + width - 2.0, y + 2.0);
	cairo_set_source_rgba (cr, 0, 0, 0, 0.12);
	cairo_stroke (cr);
}

static void
paint_scrollbar_trough (cairo_t *cr, GtkStyle *style, GtkStateType state_type, GtkOrientation orientation,
	gdouble x, gdouble y, gdouble width, gdouble height)
{
	cairo_pattern_t *crp;
	gdouble gradient_size;
	CairoColor bg, tl, br, outline;
	/* gradient_size is the size of the "shadow" at the ends of the trough
	 * it needs to be calculated so that it is a fixed size, since cairo takes a ratio when adding gradient stops
	 */

	#define OFFWHITE 238/255.0, 238/255.0, 238/255.0

	ge_gdk_color_to_cairo (&style->white, &br);
	ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
	ge_shade_color (&bg, 1.2, &tl);
	ge_shade_color (&bg, OUTLINE_SHADE, &outline);

	/* bevel */
	ge_cairo_simple_border (cr, &tl, &br, x, y, width, height, FALSE);

	/* set co-ordinates for line drawing */
	x += 0.5; y += 0.5; width -= 1.0; height -= 1.0;

	x += 1.0; y += 1.0; width -= 2.0; height -= 2.0;
	cairo_rectangle (cr, x, y, width, height);
	gdk_cairo_set_source_color (cr, &style->dark[state_type]);
	cairo_fill (cr);

	if (orientation == GTK_ORIENTATION_HORIZONTAL)
		cairo_rectangle (cr, x, y, width, height / 2 - 1);
	else
		cairo_rectangle (cr, x, y, width /2 - 1, height);

	cairo_set_source_rgb (cr, OFFWHITE);
	cairo_fill_preserve (cr);

	ge_cairo_set_color (cr, &outline);
	cairo_stroke (cr);


	if (orientation == GTK_ORIENTATION_HORIZONTAL)
		cairo_rectangle (cr, x, y + height / 2 + 1, width, height  / 2 -1);
	else
		cairo_rectangle (cr, x + width / 2 + 1, y, width / 2 - 1, height);

	cairo_set_source_rgb (cr, OFFWHITE);
	cairo_fill_preserve (cr);

	ge_cairo_set_color (cr, &outline);
	cairo_stroke (cr);

	if (orientation == GTK_ORIENTATION_HORIZONTAL)
	{
		crp = cairo_pattern_create_linear (x, y, x + width, y);
		gradient_size = 24 / width;
	}
	else
	{
		crp = cairo_pattern_create_linear (x, y, x, y + height);
		gradient_size = 24 / height;
	}


	/* set co-ordinates for fill drawing */
	x -= 0.5; y -= 0.5; width += 1.0; height += 1.0;

	cairo_rectangle (cr, x, y, width, height);
	cairo_pattern_add_color_stop_rgba (crp, 0.0, 0.0, 0.0, 0.0, 0.5);
	cairo_pattern_add_color_stop_rgba (crp, gradient_size, 0.0, 0.0, 0.0, 0.0);
	cairo_pattern_add_color_stop_rgba (crp, 1.0 - gradient_size, 0.0, 0.0, 0.0, 0.0);
	cairo_pattern_add_color_stop_rgba (crp, 1.0, 0.0, 0.0, 0.0, 0.5);

	cairo_set_source (cr, crp);
	cairo_fill (cr);
	cairo_pattern_destroy (crp);
}

static void
paint_scale_trough (cairo_t *cr, GtkStyle *style, GtkStateType state_type, GtkOrientation orientation,
	gdouble x, gdouble y, gdouble width, gdouble height)
{
	CairoColor c1, c2, bg, outline;
	cairo_pattern_t *crp;
	gdouble radius = 2.0;

	/* set up colours */
	/* calculate start and end colours for the gradient */
	ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &bg);
	ge_shade_color (&bg, 0.7, &c2); /* darken */
	ge_shade_color (&bg, 1.1, &c1); /* lighten */
	/* outline colour */
	ge_shade_color (&bg, OUTLINE_SHADE, &outline);



	/* set co-ordinates for line drawing */
	x += 0.5; y += 0.5; width -= 1.0; height -= 1.0;


	if (orientation == GTK_ORIENTATION_VERTICAL)
		crp = cairo_pattern_create_linear (x + 2.0, y, x + width - 2.0, y);
	else
		crp = cairo_pattern_create_linear (x, y+2.0, x, y+height-2.0);

	ge_cairo_rounded_rectangle (cr, x, y, width, height, radius, CR_CORNER_ALL);

	cairo_pattern_add_color_stop_rgb (crp, 0.0, c1.r, c1.g, c1.b);
	cairo_pattern_add_color_stop_rgb (crp, 1.0, c2.r, c2.g, c2.b);

	cairo_set_source (cr, crp);
	cairo_fill_preserve (cr);
	cairo_pattern_destroy (crp);

	/* dark gray */

	ge_cairo_set_color (cr, &outline);
	cairo_stroke (cr);

	ge_cairo_rounded_rectangle (cr, x+1.0, y+1.0, width-2.0, height-2.0, radius, CR_CORNER_ALL);
	crp = cairo_pattern_create_linear (x, y, x, y + height);
	cairo_pattern_add_color_stop_rgb (crp, 0.0, 1.0, 1.0, 1.0);
	cairo_pattern_add_color_stop_rgba (crp, 1.0, 1.0, 1.0, 1.0, 100/255.0);
	cairo_set_source (cr, crp);
	cairo_stroke (cr);

	ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &c2);
	ge_shade_color (&c2, 0.8, &c2); /* darken */
	cairo_set_source_rgb (cr, c2.r, c2.g, c2.b);
	if (orientation == GTK_ORIENTATION_VERTICAL)
	{
		cairo_move_to (cr, x + width + 1.0, y + radius);
		cairo_line_to (cr, x + width + 1.0, y + height - radius);
	}
	else
	{
		cairo_move_to (cr, x + radius, y + height + 1.0);
		cairo_line_to (cr, x + width - radius, y + height + 1.0);
	}
	cairo_stroke (cr);

	cairo_pattern_destroy (crp);

}

static void
paint_progress_bar (cairo_t *cr, GtkStyle *style, GtkStateType state_type, GtkProgressBarOrientation orientation,
		    gdouble x, gdouble y, gdouble width, gdouble height, gdouble fraction, CairoColor *base_color)
{
	cairo_pattern_t *crp;
	CairoColor c1, c2;

	cairo_rectangle (cr, x, y, width, height);

	ge_gdk_color_to_cairo (&style->base[GTK_STATE_SELECTED], &c1);
	CRUX_DARK(*base_color, c2);
	CRUX_LIGHT(*base_color, c1);
	if (orientation == GTK_PROGRESS_LEFT_TO_RIGHT || orientation == GTK_PROGRESS_RIGHT_TO_LEFT)
		crp = cairo_pattern_create_linear (x, y, x, y + height);
	else
		crp = cairo_pattern_create_linear (x, y, x + width, y);

	cairo_pattern_add_color_stop_rgb (crp, 0.0, c1.r, c1.g, c1.b);
	cairo_pattern_add_color_stop_rgb (crp, 1.0, c2.r, c2.g, c2.b);

	cairo_set_source (cr, crp);
	cairo_fill (cr);
	cairo_pattern_destroy (crp);

	/* set co-ordinates for line drawing */
	x += 0.5; y += 0.5; width -= 1.0; height -= 1.0;

	if (fraction < 1.0)
	{
		switch (orientation)
		{
			case GTK_PROGRESS_LEFT_TO_RIGHT: width--; break;
			case GTK_PROGRESS_RIGHT_TO_LEFT: x++; width--; break;
			case GTK_PROGRESS_TOP_TO_BOTTOM: height--; break;
			case GTK_PROGRESS_BOTTOM_TO_TOP: y++; height--; break;
		}
	}



	/* bevel */
	cairo_rectangle (cr, x, y, width, height);
	crp = cairo_pattern_create_linear (x, y, x, y + height);
	cairo_pattern_add_color_stop_rgba (crp, 0.0, 1.0, 1.0, 1.0, .3);
	cairo_pattern_add_color_stop_rgba (crp, 1.0, 1.0, 1.0, 1.0, 0.1);
	cairo_set_source (cr, crp);
	cairo_stroke (cr);

	cairo_pattern_destroy (crp);


	/* end cap */

	if (fraction < 1.0)
	{
		cairo_set_source_rgb (cr, c2.r, c2.g, c2.b);
		switch (orientation)
		{
			case GTK_PROGRESS_LEFT_TO_RIGHT:
				cairo_move_to (cr, x + width + 1.0, y);
				cairo_line_to (cr, x + width + 1.0, y + height);
				break;
			case GTK_PROGRESS_RIGHT_TO_LEFT:
				cairo_move_to (cr, x - 1.0, y);
				cairo_line_to (cr, x - 1.0, y + height);
				break;
			case GTK_PROGRESS_TOP_TO_BOTTOM:
				cairo_move_to (cr, x, y + height + 1.0);
				cairo_line_to (cr, x + width, y + height + 1.0);
				break;
			case GTK_PROGRESS_BOTTOM_TO_TOP:
				cairo_move_to (cr, x, y - 1.0);
				cairo_line_to (cr, x + width, y - 1.0);
				break;
		}
		cairo_stroke (cr);
	}


	/* draw the end cap shadow
	 * TODO: create shadows for all progress bars (currently only works for left to right)
	 *
	 * three lines of alpha: 0.22, 0.12, 0.03
	 * TODO: this doesn't work quite right, as the top part of the shadow
	 *       is already drawn by draw_box (), so the corner looks too dark
	 */

	if (orientation == GTK_PROGRESS_LEFT_TO_RIGHT)
	{
		cairo_set_source_rgba (cr, 0, 0, 0, .22);
		cairo_move_to (cr, x + width + 2.0, y);
		cairo_line_to (cr, x + width + 2.0, y + height);
		cairo_stroke (cr);

		cairo_set_source_rgba (cr, 0, 0, 0, .12);
		cairo_move_to (cr, x + width + 3.0, y);
		cairo_line_to (cr, x + width + 3.0, y + height);
		cairo_stroke (cr);

		cairo_set_source_rgba (cr, 0, 0, 0, .03);
		cairo_move_to (cr, x + width + 4.0, y);
		cairo_line_to (cr, x + width + 4.0, y + height);
		cairo_stroke (cr);
	}
}

/* style functions */

static void
draw_hline (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail,
	    gint x1, gint x2, gint y)
{
	CairoColor base, light, dark;
	cairo_t *cr;

	CHECK_ARGS

	debug ("draw_hline: detail=%s state=%d x1=%d x2=%d y=%d\n",
		detail, state_type, x1, x2, y);

	cr = ge_gdk_drawable_to_cairo (window, area);
	ge_gdk_color_to_cairo (&style->bg[state_type], &base);
	ge_shade_color (&base, 0.88, &dark);
	ge_shade_color (&base, 1.12, &light);
	ge_cairo_set_color (cr, &dark);
	cairo_move_to (cr, x1 + 0.5, y + 0.5);
	cairo_line_to (cr, x2 + 0.5, y + 0.5);
	cairo_stroke (cr);
	y++;
	ge_cairo_set_color (cr, &light);
	cairo_move_to (cr, x1 + 0.5, y + 0.5);
	cairo_line_to (cr, x2 + 0.5, y + 0.5);
	cairo_stroke (cr);
	cairo_destroy (cr);
}

static void
draw_vline (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GdkRectangle *area,
	    GtkWidget *widget, const gchar *detail, gint y1, gint y2, gint x)
{
	CairoColor base, light, dark;
	cairo_t *cr;

	CHECK_ARGS

	debug ("draw_vline: detail=%s state=%d x=%d y1=%d y2=%d\n",
		detail, state_type, x, y1, y2);

	cr = ge_gdk_drawable_to_cairo (window, area);
	ge_gdk_color_to_cairo (&style->bg[state_type], &base);
	ge_shade_color (&base, 0.88, &dark);
	ge_shade_color (&base, 1.12, &light);
	ge_cairo_set_color (cr, &dark);
	cairo_move_to (cr, x + 0.5, y1 + 0.5);
	cairo_line_to (cr, x + 0.5, y2 + 0.5);
	cairo_stroke (cr);
	x++;
	ge_cairo_set_color (cr, &light);
	cairo_move_to (cr, x + 0.5, y1 + 0.5);
	cairo_line_to (cr, x + 0.5, y2 + 0.5);
	cairo_stroke (cr);
	cairo_destroy (cr);
}

static void
draw_shadow (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail, gint x, gint y, gint width, gint height)
{
	cairo_t *cr;
	GdkRectangle area2;
	gboolean focused = FALSE;

	CHECK_ARGS
	SANITIZE_SIZE

	area2.x = x;
	area2.y = y;
	area2.width = width;
	area2.height = height;

	if (widget != 0 && !GTK_WIDGET_IS_SENSITIVE (widget))
		state_type = GTK_STATE_INSENSITIVE;

	debug ("draw_shadow: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
	        detail, state_type, shadow_type, x, y, width, height);

	if (widget != NULL && GTK_WIDGET_HAS_FOCUS (widget))
		focused = TRUE;

	if (widget && (GE_IS_COMBO (widget->parent) || GE_IS_COMBO_BOX_ENTRY (widget->parent)))
	{
		GtkWidget *button;
		if (ge_widget_is_ltr (widget))
			width += 2;
		else
		{
			x -= 3;
			width += 3;
		}

		if (area == NULL)
			area = &area2;
		g_object_set_data ((GObject*) widget->parent, "entry", widget);
		button = g_object_get_data ((GObject*) widget->parent, "button");
		if (GE_IS_WIDGET (button))
			gtk_widget_queue_draw_area (button,  button->allocation.x, button->allocation.y, button->allocation.width,button->allocation.height);
	}

	if (widget && GTK_IS_SPIN_BUTTON (widget))
	{
		if (ge_widget_is_ltr (widget))
			width += 2;
		else
		{
			x -= 3;
			width += 3;
		}

		if (area == NULL)
			area = &area2;
	}
	
	cr = ge_gdk_drawable_to_cairo (window, area);

	if (DETAIL ("entry"))
		paint_entry_shadow (cr, style, state_type, focused, x, y, width, height);
	else
		paint_shadow (cr, style, state_type, shadow_type, x, y, width, height);
	cairo_destroy (cr);
}

static void
draw_box (GtkStyle *style,
	  GdkWindow *window,
	  GtkStateType state_type,
	  GtkShadowType shadow_type,
	  GdkRectangle *area,
	  GtkWidget *widget,
	  const gchar *detail, gint x, gint y, gint width, gint height)
{

	cairo_t *cr;
	gdouble cx, cy, cw, ch;

	CHECK_ARGS
	SANITIZE_SIZE

    debug ("draw_box: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
	    detail, state_type, shadow_type, x, y, width, height);

	cr = ge_gdk_drawable_to_cairo (window, area);

	if (DETAIL ("spinbutton"))
	{
		gboolean focused = FALSE;
		if (widget) {
			state_type = GTK_WIDGET_STATE (widget);
			focused = GTK_WIDGET_HAS_FOCUS (widget);
		}
		width += 3;
		if (ge_widget_is_ltr (widget))
			x -= 3;

		paint_entry_shadow (cr, style, state_type, focused, x, y, width, height);

		cairo_destroy (cr);
		return;
	}

	/* no pressed state for scollbar buttons yet... */
	if (DETAIL ("vscrollbar") || DETAIL ("hscrollbar"))
		shadow_type = GTK_SHADOW_OUT;

	if (DETAIL ("button") || DETAIL ("optionmenu") || DETAIL ("spinbutton_down") || DETAIL ("spinbutton_up"))
	{
		gboolean extra_shadow = TRUE;
		gboolean focused = FALSE;

		if (widget)
			focused = GTK_WIDGET_HAS_FOCUS (widget);

		if (DETAIL ("spinbutton_down") || DETAIL ("spinbutton_up"))
		{
			/* add some padding */
			width -= 3;
			if (DETAIL ("spinbutton_up"))
			{
				y += 3;
				height -= 3;
			}
			else
			{
				y += 1;
				height -= 4;
			}
			if (!ge_widget_is_ltr (widget))
				x += 3;
			extra_shadow = FALSE;
		}

		if (widget && (GE_IS_COMBO (widget->parent) || GE_IS_COMBO_BOX_ENTRY (widget->parent)))
		{
			/* Combobox buttons */
			GtkWidget *entry;
			gboolean entry_focused = FALSE;

			if ((entry = g_object_get_data ((GObject*) widget->parent, "entry")))
			{
				entry_focused = (GTK_WIDGET_HAS_FOCUS (entry));
				state_type = GTK_WIDGET_STATE (entry);
			}

			if (state_type == GTK_STATE_INSENSITIVE)
				gdk_cairo_set_source_color (cr, &style->base[GTK_STATE_INSENSITIVE]);
			else
				gdk_cairo_set_source_color (cr, &style->base[GTK_STATE_NORMAL]);
			cairo_rectangle (cr, x, y, width, height);
			cairo_fill (cr);

			g_object_set_data ((GObject*) widget->parent, "button", widget);

			if (ge_widget_is_ltr (widget))
				paint_entry_shadow (cr, style, state_type, entry_focused, x - 4, y, width + 4, height);
			else
				paint_entry_shadow (cr, style, state_type, entry_focused, x, y, width + 4, height);

			x += 3; y += 3;
			width -= 6; height -= 6;
			extra_shadow = FALSE;
		}
		if (widget && (GE_IS_TREE_VIEW (widget->parent)))
		{
			/* Add some extra padding for treeview column buttons */
			if (state_type == GTK_STATE_INSENSITIVE)
				gdk_cairo_set_source_color (cr, &style->base[GTK_STATE_INSENSITIVE]);
			else
				gdk_cairo_set_source_color (cr, &style->base[GTK_STATE_NORMAL]);
			cairo_rectangle (cr, x, y, width, height);
			cairo_fill (cr);
					
			x += 1; y += 1;
			width -= 2; height -= 2;
			extra_shadow = FALSE;
		}
		paint_button (cr, style, state_type, shadow_type, focused, extra_shadow, x, y, width, height);
	}
	else if (DETAIL ("buttondefault"))
	{
		/* draw Default Button marking, but only when sensitive */
		if (state_type != GTK_STATE_INSENSITIVE)
		{
			CairoColor c;
			ge_gdk_color_to_cairo (&style->bg[GTK_STATE_SELECTED], &c);
			cairo_set_source_rgba (cr, c.r, c.g, c.b, 0.6);

			ge_cairo_rounded_rectangle (cr, x, y, width, height, 3.0, CR_CORNER_ALL);
			cairo_fill (cr);
		}
	}
	else if (DETAIL ("menuitem"))
		paint_menuitem (cr, style, state_type, x, y, width, height);
	else if (DETAIL ("menu"))
	{

		cx = x + 0.5; cy = y + 0.5; cw = width - 1.0; ch = height - 1.0;
		cairo_rectangle (cr, cx, cy, cw, ch);
		cairo_set_source_rgb (cr, 54/255.0, 52/255.0, 54/255.0);
		cairo_stroke (cr);

		cx++; cy++; cw -= 2.0; ch -= 2.0;

		gdk_cairo_set_source_color (cr, &style->light[state_type]);
		cairo_move_to (cr, cx, cy + ch);
		cairo_line_to (cr, cx, cy);
		cairo_line_to (cr, cx + cw, cy);
		cairo_stroke (cr);

		gdk_cairo_set_source_color (cr, &style->dark[state_type]);
		cairo_move_to (cr, cx + cw, cy);
		cairo_line_to (cr, cx + cw, cy + ch);
		cairo_line_to (cr, cx, cy + ch);
		cairo_stroke (cr);
	}
	else if (DETAIL ("bar") || DETAIL ("entry-progress"))
	{
		GtkProgressBarOrientation orientation;
		CairoColor base_color;
		gdouble fraction = 0;
		if (widget && GE_IS_PROGRESS_BAR (widget))
		{
			orientation = gtk_progress_bar_get_orientation (GTK_PROGRESS_BAR (widget));
			fraction = gtk_progress_bar_get_fraction (GTK_PROGRESS_BAR (widget));
		}
		else
			orientation = GTK_PROGRESS_LEFT_TO_RIGHT;

		if (DETAIL ("bar"))
			ge_gdk_color_to_cairo (&style->base[GTK_STATE_SELECTED], &base_color);
		else
			ge_gdk_color_to_cairo (&style->bg[state_type], &base_color);

		paint_progress_bar (cr, style, state_type, orientation, x, y, width, height, fraction, &base_color);
	}
	else if (DETAIL ("trough") && GE_IS_SCALE (widget))
	{
		GtkOrientation orientation;
		if (GE_IS_VSCALE (widget))
		{
			x += 1; width -= 2;
			orientation = GTK_ORIENTATION_VERTICAL;
		}
		else
		{
			y += 1; height -= 2;
			orientation = GTK_ORIENTATION_HORIZONTAL;
		}
		paint_scale_trough (cr, style, state_type, orientation, x, y, width, height);
	}
	else if (DETAIL ("trough") && GE_IS_SCROLLBAR (widget))
	{
		if (GE_IS_HSCROLLBAR (widget))
			paint_scrollbar_trough (cr, style, state_type, GTK_ORIENTATION_HORIZONTAL, x, y, width, height);
		else
			paint_scrollbar_trough (cr, style, state_type, GTK_ORIENTATION_VERTICAL, x, y, width, height);
	}
	else
	{
		/* fill  */
		cairo_rectangle (cr, x, y, width, height);

		if (DETAIL ("toolbar") || DETAIL ("menubar")
			|| DETAIL ("vscrollbar") || DETAIL ("hscrollbar")
			|| DETAIL ("handlebox_bin") || DETAIL ("dockitem"))
		{
			/* make the handle and child widget appear as one */
			if (widget && widget->parent && GTK_IS_HANDLE_BOX (widget->parent))
			{
				GtkPositionType position;
				position = gtk_handle_box_get_handle_position (GTK_HANDLE_BOX (widget->parent));
				if (!ge_widget_is_ltr (widget->parent))
				{
					if (position == GTK_POS_TOP) position = GTK_POS_BOTTOM;
					else if (position == GTK_POS_BOTTOM) position = GTK_POS_TOP;
					else if (position == GTK_POS_LEFT) position = GTK_POS_RIGHT;
					else if (position == GTK_POS_RIGHT) position = GTK_POS_LEFT;
				}
				switch (position)
				{
					case GTK_POS_TOP:
						y -= 3;
						height += 3;
						break;
					case GTK_POS_BOTTOM:
						height += 3;
						break;
					case GTK_POS_LEFT:
						x -= 3;
						width += 3;
						break;
					case GTK_POS_RIGHT:
						width += 3;
				}
			}

			if (shadow_type == GTK_SHADOW_OUT || shadow_type == GTK_SHADOW_ETCHED_OUT)
			{
				cairo_pattern_t *crp;
				CairoColor c1, c2;
				gdouble shade_v = 0.1;
				GtkOrientation gradient_orientation = GTK_ORIENTATION_HORIZONTAL;

				ge_gdk_color_to_cairo (&style->bg[state_type], &c1);
				if (DETAIL ("vscrollbar") || DETAIL ("hscrollbar"))
				{
					shade_v = 0.3;
					if (DETAIL ("vscrollbar"))
						gradient_orientation = GTK_ORIENTATION_VERTICAL;
				}
				if (gradient_orientation == GTK_ORIENTATION_HORIZONTAL)
					crp = cairo_pattern_create_linear (x, y, x, y + height);
				else
					crp = cairo_pattern_create_linear (x, y, x + width, y);
				ge_shade_color (&c1, 1.0 - shade_v, &c2);
				ge_shade_color (&c1, 1.0 + shade_v, &c1);
				/*
				cairo_pattern_add_color_stop_rgb (crp, 0.0, 238/255.0, 238/255.0, 236/255.0);
				cairo_pattern_add_color_stop_rgb (crp, 1.0, 185/255.0, 189/255.0, 182/255.0);
				*/
				cairo_pattern_add_color_stop_rgb (crp, 0.0, c1.r, c1.g, c1.b);
				cairo_pattern_add_color_stop_rgb (crp, 1.0, c2.r, c2.g, c2.b);
				cairo_set_source (cr, crp);
				cairo_fill (cr);
				cairo_pattern_destroy (crp);
			}
			else if (shadow_type == GTK_SHADOW_IN || shadow_type == GTK_SHADOW_ETCHED_IN)
			{
				/* cairo_set_source_rgb (cr, 196/255.0, 198/255.0, 192/255.0); */
				gdk_cairo_set_source_color (cr, &style->bg[state_type]);
				cairo_fill (cr);
			}
		}
		else
		{
			gdk_cairo_set_source_color (cr, &style->bg[state_type]);
			cairo_fill (cr);
		}

		if (GE_IS_PROGRESS_BAR (widget) && DETAIL ("trough"))
		{
			/* draw a shadow in progress bar troughs */
			cx = x + 1.5;
			cy = y + 1.5;
			cw = width - 3.0;
			ch = height - 3.0;
			cairo_move_to (cr, cx + 1.0, cy+ ch - 1.0);
			cairo_line_to (cr, cx + 1.0, cy+ 1.0);
			cairo_line_to (cr, cx + cw - 1.0, cy+ 1.0);
			cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.22);
			cairo_stroke (cr);

			cairo_move_to (cr, cx + 2.0, cy + ch - 1.0);
			cairo_line_to (cr, cx + 2.0, cy + 2.0);
			cairo_line_to (cr, cx + cw - 1.0, cy+ 2.0);
			cairo_line_to (cr, cx + cw - 1.0, cy+ ch - 1.0);
			cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.12);
			cairo_stroke (cr);

			cairo_rectangle (cr, cx + 3.0, cy + 3.0, cw - 5.0, ch - 4.0);
			cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.03);
			cairo_stroke (cr);
		}

		paint_shadow (cr, style, state_type, shadow_type, x, y, width, height);
	}

	cairo_destroy (cr);

}

static void
draw_arrow (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GtkShadowType shadow_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail,
	    GtkArrowType arrow_type,
	    gint fill, gint x, gint y, gint width, gint height)
{
	cairo_t *cr;

	CHECK_ARGS;
	debug ("draw_arrow: detail=%s state=%d shadow=%d arrow_type=%d x=%d y=%d w=%d h=%d\n",
	    detail, state_type, shadow_type, arrow_type, x, y, width, height);

	if (arrow_type == (GtkArrowType)4)/*NONE - new in GTK 2.10*/
		return;


	/* random adjustments... */
	if (DETAIL ("vscrollbar") || DETAIL ("hscrollbar"))
	{
		if (arrow_type == GTK_ARROW_DOWN)
			y++;
		else if (arrow_type == GTK_ARROW_RIGHT)
			x++;
	}

	if (DETAIL ("spinbutton"))
	{
		if (ge_widget_is_ltr (widget))
			x--;
		else
			x += 1;
		if (arrow_type == GTK_ARROW_UP)
			y++;
	}
	if (arrow_type == GTK_ARROW_UP || arrow_type == GTK_ARROW_DOWN)
	{
		x = x + width / 2 - 2;
		y = y + height / 2 - 2;
		height = 4; width = 5;
	}
	else if (arrow_type == GTK_ARROW_LEFT || GTK_ARROW_RIGHT)
	{
		x = x + width / 2 - 2;
		y = y + height / 2 - 2;
		height = 5; width = 4;
	}



	cr = ge_gdk_drawable_to_cairo (window, area);
	switch (arrow_type)
	{
		case GTK_ARROW_UP:
			cairo_move_to (cr, x, y + height);
			cairo_line_to (cr, x + width, y + height);
			cairo_line_to (cr, x + (width / 2.0), y);
			cairo_line_to (cr, x, y + height);
			break;
		default:
		case GTK_ARROW_DOWN:
			cairo_move_to (cr, x, y);
			cairo_line_to (cr, x + width, y);
			cairo_line_to (cr, x + (width / 2.0), y + height);
			cairo_line_to (cr, x, y);
			break;
		case GTK_ARROW_LEFT:
			cairo_move_to (cr, x + width, y);
			cairo_line_to (cr, x, y + (height / 2.0));
			cairo_line_to (cr, x + width, y + height);
			cairo_line_to (cr, x + width, y);
			break;
		case GTK_ARROW_RIGHT:
			cairo_move_to (cr, x, y);
			cairo_line_to (cr, x + width, y + (height / 2.0));
			cairo_line_to (cr, x, y + height);
			cairo_line_to (cr, x, y);
			break;
	}

	gdk_cairo_set_source_color (cr, &style->fg[state_type]);
	cairo_fill (cr);
	
	cairo_destroy (cr);

}

static void
draw_check (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GtkShadowType shadow_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail, gint x, gint y, gint width, gint height)
{
	cairo_t * cr;
	cairo_pattern_t *crp;
	CairoColor c1, bg, outline;
	gdouble cx, cy, cw, ch; /* co-ordinates for cairo */

	CHECK_ARGS
	SANITIZE_SIZE
	
	debug ("draw_check: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
	    detail, state_type, shadow_type, x, y, width, height);

	cr = ge_gdk_drawable_to_cairo (window, NULL);

	/* set up colours */
	ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &bg);
	/* outline colour */
	ge_shade_color (&bg, OUTLINE_SHADE, &outline);


	/* set up for line drawing */
	cx = x + 0.5; cy = y + 0.5;
	ch = height - 1.0; cw = width - 1.0;


	if (!GE_IS_MENU_ITEM (widget))
	{
		ge_cairo_rounded_rectangle (cr, cx, cy, cw, ch, 2.0, CR_CORNER_ALL);
		if (state_type == GTK_STATE_INSENSITIVE)
		{
			gdk_cairo_set_source_color (cr, &style->bg[state_type]);
			cairo_fill_preserve (cr);

			gdk_cairo_set_source_color (cr, &style->fg[state_type]);
			cairo_stroke (cr);

			/* prepare area for check mark */
			cx+= 2.0; cy+= 2.0; cw -= 4.0; ch -= 4.0;
		}
		else
		{
			/* create gradient */
			crp = cairo_pattern_create_linear (cx, cy, cx, cy + ch);

			ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &c1);
			ge_shade_color (&c1, 0.9, &c1); /* darken */

			if (state_type == GTK_STATE_ACTIVE)
			{
				cairo_pattern_add_color_stop_rgb (crp, 0.0, c1.r, c1.g, c1.b);
				cairo_pattern_add_color_stop_rgb (crp, 1.0, 1.0, 1.0, 1.0);
			}
			else
			{
				cairo_pattern_add_color_stop_rgb (crp, 0.0, 1.0, 1.0, 1.0);
				cairo_pattern_add_color_stop_rgb (crp, 1.0, c1.r, c1.g, c1.b);
			}
			cairo_set_source (cr, crp);
			cairo_fill_preserve (cr);
			cairo_pattern_destroy (crp);

			ge_cairo_set_color (cr, &outline);
			cairo_stroke (cr);

			/* inner hilight */
			cx+=1.0; cy+=1.0; cw -= 2.0; ch -= 2.0;
			ge_cairo_rounded_rectangle (cr, cx, cy, cw, ch, 1.0, CR_CORNER_ALL);
			cairo_set_source_rgba (cr, 1.0, 1.0, 1.0, 0.7);
			cairo_stroke (cr);

			/* prepare area for check mark */
			cx+=1.0; cy+=1.0; cw -= 2.0; ch -= 2.0;
		}
	}
	if (shadow_type == GTK_SHADOW_IN)
	{
		cairo_set_line_width (cr, 2.0);

		/* draw check mark shadow first */
		if (state_type != GTK_STATE_INSENSITIVE)
		{
			cy+=1.0;
			cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.3);
			cairo_move_to (cr, cx + floor(cw / 4), cy + ch / 2);
			cairo_line_to (cr, cx + floor(cw / 2), cy + floor(ch * 0.75));
			cairo_line_to (cr, cx + cw, cy + floor(ch / 4));
			cairo_stroke (cr);
			cy-=1.0;
		}
		if (state_type == GTK_STATE_INSENSITIVE)
			gdk_cairo_set_source_color (cr, &style->fg[state_type]);
		else
			gdk_cairo_set_source_color (cr, &style->bg[GTK_STATE_SELECTED]);

		/* draw check mark */
		/* use floor() so that we still end up with a .5 value when adding to the co-ordinate! */
		cairo_move_to (cr, cx + floor(cw / 4), cy + ch / 2);
		cairo_line_to (cr, cx + floor(cw / 2), cy + floor(ch * 0.75));
		cairo_line_to (cr, cx + cw, cy + floor(ch / 4));
		cairo_stroke (cr);
	}
	else if (shadow_type != GTK_SHADOW_OUT)
	{
		cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.3);
		cairo_rectangle (cr, x + width / 4, y + (height /3) + 0.5, width - (width / 2), height / 4);
		cairo_fill (cr);

		gdk_cairo_set_source_color (cr, &style->bg[GTK_STATE_SELECTED]);
		cairo_rectangle (cr, x + width / 4, y + (height /3), width - (width / 2), height / 4);
		cairo_fill (cr);
	}

	cairo_destroy (cr);
}

static void
draw_option (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail, gint x, gint y, gint width, gint height)
{
	cairo_t *cr;
	cairo_pattern_t *crp;
	gdouble cx, cy, radius; /* cairo co-ordinates */
	CairoColor c1, c2, bg, outline;

	CHECK_ARGS
	SANITIZE_SIZE
	
	debug ("draw_option: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
	    detail, state_type, shadow_type, x, y, width, height);

	cr = ge_gdk_drawable_to_cairo (window, area);

	/* set up colours */
	ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &bg);
	/* outline colour */
	ge_shade_color (&bg, OUTLINE_SHADE, &outline);
	/* gradient colours */
	ge_shade_color (&bg, 0.7, &c2);
	ge_gdk_color_to_cairo (&style->white, &c1);

	cx = x + (height / 2);
	cy = y + (height / 2);
	radius = (height / 2) - 0.5;

	if (!GE_IS_MENU_ITEM (widget))
	{
		cairo_arc (cr, cx, cy, radius, 0.0, G_PI * 2);

		if (state_type == GTK_STATE_INSENSITIVE)
		{
			gdk_cairo_set_source_color (cr, &style->bg[state_type]);
			cairo_fill_preserve (cr);

			gdk_cairo_set_source_color (cr, &style->fg[state_type]);
			cairo_stroke (cr);
		}
		else
		{
			crp = cairo_pattern_create_linear (x, y, x + height, y + height);
			if (state_type != GTK_STATE_ACTIVE)
			{
				/* out shadow */
				cairo_pattern_add_color_stop_rgb (crp, 0.2, c1.r, c1.g, c1.b);
				cairo_pattern_add_color_stop_rgb (crp, 1.0, c2.r, c2.g, c2.b);
			}
			else
			{
				/* in shadow */
				cairo_pattern_add_color_stop_rgb (crp, 0.0, c2.r, c2.g, c2.b);
				cairo_pattern_add_color_stop_rgb (crp, 1.0, c1.r, c1.g, c1.b);
			}
			cairo_set_source (cr, crp);
			cairo_fill_preserve (cr);
			cairo_pattern_destroy (crp);

			ge_cairo_set_color (cr, &outline);
			cairo_stroke (cr);

			cairo_arc (cr, cx, cy, radius - 1.0, 0.0, G_PI * 2);
			cairo_set_source_rgba (cr, 1.0, 1.0, 1.0, 0.5);
			cairo_stroke (cr);
		}
		/* only make the "dot" smaller if we have drawn a border */
		radius = radius / 2.0;
	}


	if (shadow_type == GTK_SHADOW_IN)
	{
		/* draw check mark */
		cairo_arc (cr, cx, cy, radius, 0.0, G_PI * 2);

		if (state_type == GTK_STATE_INSENSITIVE)
		{
			gdk_cairo_set_source_color (cr, &style->fg[state_type]);
			cairo_fill_preserve (cr);
			cairo_stroke (cr);
		}
		else
		{
			gdk_cairo_set_source_color (cr, &style->light[GTK_STATE_SELECTED]);
			cairo_fill_preserve (cr);

			gdk_cairo_set_source_color (cr, &style->dark[GTK_STATE_SELECTED]);
			cairo_stroke (cr);
		}
	}
	else if (shadow_type != GTK_SHADOW_OUT)
	{
		cairo_set_source_rgba (cr, 0.0, 0.0, 0.0, 0.3);
		cairo_rectangle (cr, x + width / 4, y + (height /3) + 0.5, width - (width / 2), height / 4);
		cairo_fill (cr);

		gdk_cairo_set_source_color (cr, &style->bg[GTK_STATE_SELECTED]);
		cairo_rectangle (cr, x + width / 4, y + (height /3), width - (width / 2), height / 4);
		cairo_fill (cr);
	}



	cairo_destroy (cr);
}

static void
draw_tab (GtkStyle *style,
	  GdkWindow *window,
	  GtkStateType state_type,
	  GtkShadowType shadow_type,
	  GdkRectangle *area,
	  GtkWidget *widget,
	  const gchar *detail, gint x, gint y, gint width, gint height)
{
    CHECK_ARGS
    SANITIZE_SIZE

	/* Draws an option menu tab (the up and down pointing arrows)
	 * TODO: Make this look neater
	 */
	debug ("draw_tab: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
	    detail, state_type, shadow_type, x, y, width, height);

	draw_arrow (style, window, state_type, shadow_type, area, widget, detail,
		    GTK_ARROW_UP, FALSE, x + (width / 2) - 2, y - (height / 2), 7, 7);

	draw_arrow (style, window, state_type, shadow_type, area, widget, detail,
		    GTK_ARROW_DOWN, FALSE, x + (width / 2) - 2, y + (height / 2), 7, 7);
}

static void
draw_shadow_gap (GtkStyle *style,
		 GdkWindow *window,
		 GtkStateType state_type,
		 GtkShadowType shadow_type,
		 GdkRectangle *area,
		 GtkWidget *widget,
		 const gchar *detail,
		 gint x,
		 gint y,
		 gint width,
		 gint height,
		 GtkPositionType gap_side, gint gap_x, gint gap_width)
{
    GdkRectangle rect;

    CHECK_ARGS
    SANITIZE_SIZE

    debug ("draw_shadow_gap: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
	    detail, state_type, shadow_type, x, y, width, height);

    gtk_paint_shadow (style, window, state_type, shadow_type, area, widget,
		      detail, x, y, width, height);

    switch (gap_side)
    {
    case GTK_POS_TOP:
	rect.x = x + gap_x;
	rect.y = y;
	rect.width = gap_width;
	rect.height = 2;
	break;
    default:
    case GTK_POS_BOTTOM:
	rect.x = x + gap_x;
	rect.y = y + height - 2;
	rect.width = gap_width;
	rect.height = 2;
	break;
    case GTK_POS_LEFT:
	rect.x = x;
	rect.y = y + gap_x;
	rect.width = 2;
	rect.height = gap_width;
	break;
    case GTK_POS_RIGHT:
	rect.x = x + width - 2;
	rect.y = y + gap_x;
	rect.width = 2;
	rect.height = gap_width;
	break;
    }

    gtk_style_apply_default_background (style, window, TRUE, state_type, area,
				    rect.x, rect.y, rect.width, rect.height);
}

static void
draw_box_gap (GtkStyle *style,
	      GdkWindow *window,
	      GtkStateType state_type,
	      GtkShadowType shadow_type,
	      GdkRectangle *area,
	      GtkWidget *widget,
	      const gchar *detail,
	      gint x,
	      gint y,
	      gint width,
	      gint height,
	      GtkPositionType gap_side, gint gap_x, gint gap_width)
{
    GdkRectangle rect;

    CHECK_ARGS
    SANITIZE_SIZE

	debug ("draw_box_gap: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
		detail, state_type, shadow_type, x, y, width, height);

	gtk_paint_box (style, window, state_type, shadow_type, area, widget,
			detail, x, y, width, height);


	switch (gap_side)
	{
		case GTK_POS_TOP:
			rect.x = x + gap_x + 1;
			rect.y = y;
			rect.width = gap_width - 2;
			rect.height = 2;
			break;
		default:
		case GTK_POS_BOTTOM:
			rect.x = x + gap_x + 1;
			rect.y = y + height - 2;
			rect.width = gap_width - 2;
			rect.height = 2;
			break;
		case GTK_POS_LEFT:
			rect.x = x;
			rect.y = y + gap_x + 1;
			rect.width = 2;
			rect.height = gap_width - 2;
			break;
		case GTK_POS_RIGHT:
			rect.x = x + width - 2;
			rect.y = y + gap_x + 1;
			rect.width = 2;
			rect.height = gap_width - 2;
			break;
	}

	gtk_style_apply_default_background (style, window, TRUE, state_type, area,
				    rect.x, rect.y, rect.width, rect.height);
}

static void
draw_extension (GtkStyle *style,
		GdkWindow *window,
		GtkStateType state_type,
		GtkShadowType shadow_type,
		GdkRectangle *area,
		GtkWidget *widget,
		const gchar *detail,
		gint x,
		gint y, gint width, gint height, GtkPositionType gap_side)
{
	cairo_t *cr;
	cairo_pattern_t *crp;
	CairoColor c1, c2, bg, outline;
	CairoCorners corners;
	gdouble radius = 2;

	debug ("draw_extension: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
		detail, state_type, shadow_type, x, y, width, height);

	cr = ge_gdk_drawable_to_cairo (window, area);

	/* set up colours */
	ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
	ge_shade_color (&bg, 1.1, &c1);
	c2.r = bg.r; c2.g = bg.g; c2.b = bg.b;

	/* make sure the correct area is clipped */
	cairo_rectangle (cr, x, y, width, height);
	cairo_clip (cr);

	/* outline colour */
	ge_shade_color (&bg, OUTLINE_SHADE, &outline);

	switch (gap_side)
	{
		case GTK_POS_TOP:
			/* bottom tab */
			y -= style->ythickness;
			height += style->ythickness;
			corners = CR_CORNER_BOTTOMLEFT + CR_CORNER_BOTTOMRIGHT;
			crp = cairo_pattern_create_linear (x, y + height, x, y);
			ge_shade_color (&c2, 0.8, &c1);
			break;
		default:
		case GTK_POS_BOTTOM:
			/* top tab */
			height += style->ythickness;
			corners = CR_CORNER_TOPLEFT + CR_CORNER_TOPRIGHT;
			crp = cairo_pattern_create_linear (x, y, x, y + height);
			break;
		case GTK_POS_LEFT:
			/* right tab */
			x -= style->xthickness;
			width += style->xthickness;
			corners = CR_CORNER_TOPRIGHT + CR_CORNER_BOTTOMRIGHT;
			crp = cairo_pattern_create_linear (x + width, y, x, y);
			break;
		case GTK_POS_RIGHT:
			/* left tab */
			width += style->xthickness;
			corners = CR_CORNER_BOTTOMLEFT + CR_CORNER_TOPLEFT;
			crp = cairo_pattern_create_linear (x, y, x + width, y);
			break;
	}

	ge_cairo_rounded_rectangle (cr, x + 0.5, y + 0.5, width - 1.0, height - 1.0, radius, corners);

	cairo_pattern_add_color_stop_rgb (crp, 0.0, c1.r, c1.g, c1.b);
	cairo_pattern_add_color_stop_rgb (crp, 0.3, c2.r, c2.g, c2.b);
	cairo_set_source (cr, crp);
	cairo_fill_preserve (cr);
	cairo_pattern_destroy (crp);

	ge_cairo_set_color (cr, &outline);
	cairo_stroke (cr);

	x++; y++; width -= 2.0; height -= 2.0;
	radius--;

	/* setup for stroke */
	cairo_translate (cr, 0.5, 0.5);
	width--; height--;

	if (state_type == GTK_STATE_NORMAL)
	{
		/* we want to draw outside the width/height now */
		cairo_reset_clip (cr);

		switch (gap_side)
		{
			/* top */
			case GTK_POS_BOTTOM:
				height++;
				cairo_move_to (cr, x, y + height);
				cairo_arc (cr, x + radius, y + radius, radius, G_PI, G_PI * 1.5);
				cairo_line_to (cr, x + width - radius, y);
				cairo_set_source_rgba (cr, 1, 1, 1, 0.7);
				cairo_stroke (cr);

				cairo_arc (cr, x + width - radius, y + radius, radius, G_PI * 1.5, 0);
				cairo_line_to (cr, x + width, y + height - 1);
				cairo_set_source_rgba (cr, 0, 0, 0, 0.2);
				cairo_stroke (cr);
				break;
			/* bottom */
			case GTK_POS_TOP:
				y -= 1; height += 1;
				cairo_move_to (cr, x, y);
				cairo_arc_negative (cr, x + radius, y + height - radius, radius, G_PI, G_PI * 0.5);
				cairo_set_source_rgba (cr, 1, 1, 1, 0.7);
				cairo_stroke (cr);

				cairo_move_to (cr, x + 1, y + height);
				cairo_line_to (cr, x + width - radius, y + height);
				cairo_arc_negative (cr, x + width - radius, y + height - radius, radius, G_PI * 0.5, 0);
				cairo_line_to (cr, x + width, y);
				cairo_set_source_rgba (cr, 0, 0, 0, 0.2);
				cairo_stroke (cr);
				break;
			/* right */
			case GTK_POS_LEFT:
				x -= 1; width += 1;
				cairo_move_to (cr, x, y);
				cairo_arc (cr, x + width - radius, y + radius, radius, G_PI * 1.5, 0);
				cairo_arc (cr, x + width - radius, y + height - radius, radius, 0, G_PI * 0.5);
				cairo_set_source_rgba (cr, 1, 1, 1, 0.7);
				cairo_stroke (cr);
				
				cairo_move_to (cr, x + width - 1, y + height);
				cairo_line_to (cr, x, y + height);
				cairo_set_source_rgba (cr, 0, 0, 0, 0.2);
				cairo_stroke (cr);
				break;
			/* left */
			case GTK_POS_RIGHT:
				width += 1;
				cairo_move_to (cr, x + width, y);
				cairo_arc_negative (cr, x + radius, y + radius, radius, G_PI * 1.5, G_PI);
				cairo_arc_negative (cr, x + radius, y + height - radius, radius, G_PI, G_PI * 0.5);
				cairo_set_source_rgba (cr, 1, 1, 1, 0.7);
				cairo_stroke (cr);

				cairo_move_to (cr, x + 1, y + height);
				cairo_line_to (cr, x + width, y + height);
				cairo_set_source_rgba (cr, 0, 0, 0, 0.2);
				cairo_stroke (cr);
				break;
		}
		
	}
	else
	{
		ge_cairo_rounded_rectangle (cr, x, y, width, height, 1.0, corners);
		cairo_set_source_rgba (cr, 1.0, 1.0, 1.0, 0.5); 
		cairo_stroke (cr);
	}



	cairo_destroy (cr);
}

static void
draw_focus (GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const gchar *detail, gint x, gint y, gint width, gint height)
{
    debug ("draw_focus: detail=%s x=%d y=%d w=%d h=%d\n",
	    detail, x, y, width, height);

	if (DETAIL ("entry"))
	{
		cairo_t *cr;
		cr = ge_gdk_drawable_to_cairo (window, area);
		cairo_rectangle (cr, x + 0.5, y + 0.5, width - 1.0, height - 1.0);
		gdk_cairo_set_source_color (cr, &style->base[GTK_STATE_SELECTED]);
		cairo_stroke (cr);
		cairo_destroy (cr);
		return;
	}

	/* buttons draw their own focus indicator */
	if (DETAIL ("button"))
		return;

	/* Make sure no widget is without a focus indicator! */
	parent_style_class->draw_focus(style, window, state_type, area, widget,
	                               detail, x, y, width, height);
}

static void
draw_slider (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail,
	     gint x,
	     gint y, gint width, gint height, GtkOrientation orientation)
{
	cairo_t *cr;
	cairo_pattern_t *crp;
	CairoColor c1, c2;
	gboolean is_scale = (DETAIL ("vscale") || DETAIL ("hscale"));

	CHECK_ARGS
	SANITIZE_SIZE

	debug ("draw_slider: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n", detail, state_type, shadow_type, x, y, width, height);

	cr = ge_gdk_drawable_to_cairo (window, area);


	ge_gdk_color_to_cairo (&style->bg[GTK_STATE_SELECTED], &c2);

	/* light */
	CRUX_LIGHT (c2, c1);

	if (state_type == GTK_STATE_PRELIGHT)
	{
		ge_shade_color (&c1, 1.2, &c1);
	}

	/* dark */
	CRUX_DARK (c2, c2);

	if (widget != NULL && GTK_WIDGET_HAS_FOCUS (widget))
	{
		ge_cairo_rounded_rectangle (cr, x+0.5, y+0.5, width-1.0, height-1.0, 2, CR_CORNER_ALL);
	}

	if (orientation == GTK_ORIENTATION_VERTICAL)
		crp = cairo_pattern_create_linear (x, y, x + width, y);
	else
		crp = cairo_pattern_create_linear (x, y, x, y + height);

	if (is_scale)
		ge_cairo_rounded_rectangle (cr, x+0.5, y+0.5, width-1.0, height-1.0, 2, CR_CORNER_ALL);
	else
		cairo_rectangle (cr, x + 0.5, y + 0.5, width - 1.0, height - 1.0);

	cairo_pattern_add_color_stop_rgb (crp, 0.0, c1.r, c1.g, c1.b);
	cairo_pattern_add_color_stop_rgb (crp, 1.0, c2.r, c2.g, c2.b);
	cairo_set_source (cr, crp);
	cairo_fill_preserve (cr);
	cairo_pattern_destroy (crp);

	cairo_set_source_rgb (cr, c2.r, c2.g, c2.b);
	cairo_stroke (cr);


	/* bevel */
	if (is_scale)
		ge_cairo_rounded_rectangle (cr, x+1.5, y+1.5, width-3.0, height-3.0, 2, CR_CORNER_ALL);
	else
		cairo_rectangle (cr, x+1.5, y+1.5, width-3.0, height-3.0);

	if (orientation == GTK_ORIENTATION_VERTICAL)
		crp = cairo_pattern_create_linear (x, y, x + width, y);
	else
		crp = cairo_pattern_create_linear (x, y, x, y + height);
	cairo_pattern_add_color_stop_rgba (crp, 0.0, 1.0, 1.0, 1.0, 0.2);
	cairo_pattern_add_color_stop_rgba (crp, 1.0, 1.0, 1.0, 1.0, 0.1);
	cairo_set_source (cr, crp);
	cairo_stroke (cr);

	cairo_pattern_destroy (crp);


	cairo_destroy (cr);
}

static void
draw_handle (GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const gchar *detail,
	     gint x,
	     gint y, gint width, gint height, GtkOrientation orientation)
{
    gint i, yy, xx;
    gint xthick, ythick;
    GdkGC *light_gc, *dark_gc;
    GdkRectangle dest;

    CHECK_ARGS
    SANITIZE_SIZE

    debug ("draw_handle: detail=%s state=%d shadow=%d x=%d y=%d w=%d h=%d\n",
	   detail, state_type, shadow_type, x, y, width, height);

    if (DETAIL ("dockitem") && state_type == GTK_STATE_NORMAL)
	state_type = GTK_STATE_ACTIVE;


    light_gc = style->light_gc[state_type];
    dark_gc = style->dark_gc[state_type];

    xthick = style->xthickness + 1;
    ythick = style->ythickness + 1;

    dest.x = x + xthick;
    dest.y = y + ythick;
    dest.width = width - (xthick * 2);
    dest.height = height - (ythick * 2);

    gdk_gc_set_clip_rectangle (light_gc, &dest);
    gdk_gc_set_clip_rectangle (dark_gc, &dest);

    /* ORIENTATION parameters is unreliable */
    if (height > width)
    {
	yy = y + height / 2 - 4;
	for (i = 0; i < 8; i += 2)
	{
	    gdk_draw_line (window, dark_gc, xthick, yy + i,
			   x + width - xthick, yy + i);
	    gdk_draw_line (window, light_gc, xthick, yy + i + 1,
			   x + width - xthick, yy + i + 1);
	}
    }
    else
    {
	xx = x + width / 2 - 4;
	for (i = 0; i < 8; i += 2)
	{
	    gdk_draw_line (window, dark_gc, xx + i, ythick,
			   xx + i, y + height - ythick);
	    gdk_draw_line (window, light_gc, xx + i + 1, ythick,
			   xx + i + 1, y + height - ythick);
	}
    }

    gdk_gc_set_clip_rectangle (light_gc, NULL);
    gdk_gc_set_clip_rectangle (dark_gc, NULL);
}

static void
draw_layout (GtkStyle        *style,
	     GdkWindow       *window,
	     GtkStateType     state_type,
	     gboolean         use_text,
	     GdkRectangle    *area,
	     GtkWidget       *widget,
	     const char      *detail,
	     int              x,
	     int              y,
	     PangoLayout      *layout)
{
	GdkGC *gc;
	
	g_return_if_fail (GTK_IS_STYLE (style));
	g_return_if_fail (window != NULL);
	
	gc = use_text ? style->text_gc[state_type] : style->fg_gc[state_type];
	
	if (area) {
		gdk_gc_set_clip_rectangle (gc, area);
	}
	
	gdk_draw_layout (window, gc, x, y, layout);
	
	if (area) {
		gdk_gc_set_clip_rectangle (gc, NULL);
	}
}


void
crux_draw_style_class_init (GtkStyleClass *style_class)
{

  parent_style_class = g_type_class_peek_parent(style_class);

  style_class->draw_hline = draw_hline;
  style_class->draw_vline = draw_vline;
  style_class->draw_shadow = draw_shadow;
  style_class->draw_arrow = draw_arrow;
  style_class->draw_box = draw_box;
  style_class->draw_check = draw_check;
  style_class->draw_option = draw_option;
  style_class->draw_tab = draw_tab;
  style_class->draw_shadow_gap = draw_shadow_gap;
  style_class->draw_box_gap = draw_box_gap;
  style_class->draw_extension = draw_extension;
  style_class->draw_focus = draw_focus;
  style_class->draw_slider = draw_slider;
  style_class->draw_handle = draw_handle;
  style_class->draw_layout = draw_layout;
}
