/* Industrial - a cairo based GTK+ engine
 * Copyright (C) 2001 Red Hat, Inc.
 * Copyright (C) 2002 Ximian, Inc.
 * Copyright (C) 2006-2007 Benjamin Berg <benjamin@sipsolutions.net>
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
 *
 * Written by Owen Taylor <otaylor@redhat.com>
 * modified by Alexander Larsson <alexl@redhat.com>
 * modified by Christopher James Lahey <clahey@ximian.com>
 * modified by Benjamin Berg <benjamin@sipsolutions.net>
 *
 */


#include "industrial_style.h"
#include "industrial_rc_style.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <ge-support.h>
#include <cairo.h>
#include <math.h>
#include <stdio.h>

#define LINE_OPACITY 0.4
#define HANDLE_OPACITY 0.38
#define BUTTON_DEPRESSED_SHADOW_OPACITY_1 0.14
#define BUTTON_DEPRESSED_SHADOW_OPACITY_2 0.07
#define DEFAULT_SHADOW_OPACITY 0.26
#define MENUITEM_BORDER_OPACITY 0.38
#define STANDARD_BORDER_OPACITY 0.38
#define BUTTON_BORDER_OPACITY 0.38
#define TROUGH_BG_OPACITY 0.15
#define TROUGH_BORDER_OPACITY 0.21
#define MENUBAR_BORDER_OPACITY 0.07

#define GET_ROUNDED_BUTTONS(style) (INDUSTRIAL_STYLE (style)->rounded_buttons)
#define GET_REAL_OPACITY(style, orig_opacity) (CLAMP ((orig_opacity) * INDUSTRIAL_STYLE (style)->contrast, 0.0, 1.0))
#define GET_HINT(style) (INDUSTRIAL_STYLE (style)->hint)

#define IF_ROUNDED(style, rounded, otherwise) (GET_ROUNDED_BUTTONS (style) ? rounded : otherwise)

G_DEFINE_DYNAMIC_TYPE (IndustrialStyle, industrial_style, GTK_TYPE_STYLE)

static void
draw_rounded_gradient (cairo_t    *cr,
		       gint        x,
		       gint	   y,
		       gint        width,
		       gint        height,
		       gfloat      gradient_width,
		       gfloat      inner_radius,
		       gfloat      outer_radius,
		       CairoColor *inner_color,
		       CairoColor *outer_color)
{
	cairo_pattern_t *pattern;
	cairo_matrix_t matrix;
	
	cairo_save (cr);
	cairo_translate (cr, x, y);

	/* either we need an inner_radius of 0px, or gradient_width must be
	 * exactly outer_radius - inner_radius. I have no idea how I could
	 * handle the other cases. (and I don't need them) */
	if (gradient_width == -1) {
		gradient_width = outer_radius - inner_radius;
	} else {
		/* we can't handle a specific gradient width and inner_radius */
		if (gradient_width != outer_radius - inner_radius) {
			inner_radius = 0;
		}
	}

	if (inner_radius != 0.0 || outer_radius != 0.0) {
		/* setup a clip region for the gradient area, this is important for the edges. */
		cairo_save (cr);
		
		cairo_set_fill_rule (cr, CAIRO_FILL_RULE_EVEN_ODD);

		ge_cairo_rounded_rectangle (cr, 0, 0, width, height, outer_radius, CR_CORNER_ALL);
		ge_cairo_rounded_rectangle (cr, gradient_width, gradient_width,
					    width - 2 * gradient_width,
					    height - 2 * gradient_width,
					    inner_radius, CR_CORNER_ALL);

		cairo_clip (cr);

		cairo_set_fill_rule (cr, CAIRO_FILL_RULE_WINDING);

		/* create radial gradient */
		pattern = cairo_pattern_create_radial (0, 0, 0, 0, 0, outer_radius);

		/* XXX: Shouldn't it work to set the first radius in create_radial
		 * to inner_radius instead of this hack? */
		ge_cairo_pattern_add_color_stop_color (pattern, 0, inner_color);
		ge_cairo_pattern_add_color_stop_color (pattern,
						       inner_radius / outer_radius,
						       inner_color);
		ge_cairo_pattern_add_color_stop_color (pattern, 1, outer_color);
		cairo_set_source (cr, pattern);
		cairo_pattern_destroy (pattern);

		/* move to each corner, and draw it. (as everything is clipped, this is OK to do) */
		cairo_save (cr);
		cairo_rectangle (cr, 0, 0, outer_radius, outer_radius);
		cairo_matrix_init_translate (&matrix, -outer_radius, -outer_radius);
		cairo_pattern_set_matrix (pattern, &matrix);
		cairo_fill (cr);
		cairo_restore (cr);

		cairo_save (cr);
		cairo_rectangle (cr, width - outer_radius, 0, outer_radius, outer_radius);
		cairo_matrix_init_translate (&matrix, outer_radius - width, -outer_radius);
		cairo_pattern_set_matrix (pattern, &matrix);
		cairo_fill (cr);
		cairo_restore (cr);

		cairo_save (cr);
		cairo_rectangle (cr, width - outer_radius, height - outer_radius,
				 outer_radius, outer_radius);
		cairo_matrix_init_translate (&matrix, outer_radius - width,
					     outer_radius - height);
		cairo_pattern_set_matrix (pattern, &matrix);
		cairo_fill (cr);
		cairo_restore (cr);

		cairo_save (cr);
		cairo_rectangle (cr, 0, height - outer_radius, outer_radius, outer_radius);
		cairo_matrix_init_translate (&matrix, -outer_radius, outer_radius - height);
		cairo_pattern_set_matrix (pattern, &matrix);
		cairo_fill (cr);
		cairo_restore (cr);
		
		cairo_restore (cr);
	}

	/* The _rounded_ part of the corners are drawn at this point ... */
	
	/* create linear gradient */
	pattern = cairo_pattern_create_linear (0, 0, 0, gradient_width);
	ge_cairo_pattern_add_color_stop_color (pattern, 0, inner_color);
	ge_cairo_pattern_add_color_stop_color (pattern, 1, outer_color);
	cairo_set_source (cr, pattern);
	cairo_pattern_destroy (pattern);

	/* draw those gradients */
	cairo_save (cr);
	
	/* This is not perfect, as drawing twice with 0.5 opacity is not the same
	 * as drawing once with full opacity ... */
	/* TOP */
	cairo_move_to (cr, outer_radius, 0);
	cairo_line_to (cr, outer_radius, outer_radius);
	cairo_line_to (cr, gradient_width, gradient_width);
	cairo_line_to (cr, width - gradient_width, gradient_width);
	cairo_line_to (cr, width - outer_radius, outer_radius);
	cairo_line_to (cr, width - outer_radius, 0);
	cairo_close_path (cr);
	
	/* cairo_rectangle (cr, outer_radius, 0, width - 2 * outer_radius,
			 gradient_width); */
	cairo_matrix_init_rotate (&matrix, G_PI);
	cairo_matrix_translate (&matrix, 0, -gradient_width);
	cairo_pattern_set_matrix (pattern, &matrix);
	cairo_fill (cr);
	cairo_restore (cr);

	cairo_save (cr);
	
	/* RIGHT */
	cairo_move_to (cr, width, outer_radius);
	cairo_line_to (cr, width - outer_radius, outer_radius);
	cairo_line_to (cr, width - gradient_width, gradient_width);
	cairo_line_to (cr, width - gradient_width, height - gradient_width);
	cairo_line_to (cr, width - outer_radius, height - outer_radius);
	cairo_line_to (cr, width, height - outer_radius);
	cairo_close_path (cr);
	
	/* cairo_rectangle (cr, width - outer_radius, outer_radius, outer_radius,
			 height - 2 * outer_radius); */
	cairo_matrix_init_rotate (&matrix, G_PI_2);
	cairo_matrix_translate (&matrix, -width + gradient_width, -gradient_width);
	cairo_pattern_set_matrix (pattern, &matrix);
	cairo_fill (cr);
	cairo_restore (cr);

	cairo_save (cr);

	/* BOTTOM */
	cairo_move_to (cr, outer_radius, height);
	cairo_line_to (cr, outer_radius, height - outer_radius);
	cairo_line_to (cr, gradient_width, height - gradient_width);
	cairo_line_to (cr, width - gradient_width, height - gradient_width);
	cairo_line_to (cr, width - outer_radius, height - outer_radius);
	cairo_line_to (cr, width - outer_radius, height);
	cairo_close_path (cr);

	/* cairo_rectangle (cr, outer_radius, height - gradient_width,
			 width - 2 * outer_radius, gradient_width); */
	cairo_matrix_init_rotate (&matrix, 0);
	cairo_matrix_translate (&matrix, 0, -height + gradient_width);
	cairo_pattern_set_matrix (pattern, &matrix);
	cairo_fill (cr);
	cairo_restore (cr);

	cairo_save (cr);
	/* LEFT */
	cairo_move_to (cr, 0, height - outer_radius);
	cairo_line_to (cr, outer_radius, height - outer_radius);
	cairo_line_to (cr, gradient_width, height - gradient_width);
	cairo_line_to (cr, gradient_width, gradient_width);
	cairo_line_to (cr, outer_radius, outer_radius);
	cairo_line_to (cr, 0, outer_radius);
	cairo_close_path (cr);

	/* cairo_rectangle (cr, 0, outer_radius, gradient_width,
			 height - 2 * outer_radius); */
	cairo_matrix_init_rotate (&matrix, -G_PI_2);
	cairo_matrix_translate (&matrix, -gradient_width, 0);
	cairo_pattern_set_matrix (pattern, &matrix);
	cairo_fill (cr);
	cairo_restore (cr);

	cairo_restore (cr);
}

/* The fill will only be drawn if fill != NULL.
 * radius should be 1.5/2.5 for 1px/2px corners. */
static void
draw_rounded_rect (cairo_t     *cr,
		   gint         x,
		   gint         y,
		   gint         width,
		   gint         height,
		   gdouble      radius,
		   CairoColor  *bevel,
		   CairoColor  *fill,
		   CairoCorners corners)
{
	CairoColor real_bevel = *bevel;
	
	if (fill) {
		/* This fill is a little optimized in most cases, to only draw a pixel aligned rect.
		 * To prevent errors, we need to adjust the bevel color ... */
		
		if (radius <= 2.5 && fill->a == 1.0) {
			real_bevel.a = 1;
			real_bevel.r = fill->r * (1.0 - bevel->a) + bevel->r * bevel->a;
			real_bevel.g = fill->g * (1.0 - bevel->a) + bevel->g * bevel->a;
			real_bevel.b = fill->b * (1.0 - bevel->a) + bevel->b * bevel->a;

			/* At least with a radius like this, the corner pixel will still be
			 * painted by the stroke ... using a rect here should be fine. */
			cairo_rectangle (cr, x + 1, y + 1, width -2, height - 2);
		} else {
			ge_cairo_rounded_rectangle (cr, x, y, width, height, radius,
						    corners);
		}

		ge_cairo_set_color (cr, fill);
		cairo_fill (cr);
	}

	ge_cairo_set_color (cr, &real_bevel);
	ge_cairo_rounded_rectangle (cr, x + 0.5, y + 0.5, width - 1, height - 1,
				    radius, corners);
	cairo_stroke (cr);
}

/* #define names assume vertical */
#define HANDLE_HEIGHT (4 * 4 + 1 + 2)
#define HANDLE_WIDTH (4 + 1 + 2)

static void
draw_grid_cairo (cairo_t    *cr,
		 CairoColor *color,
		 gint        x,
		 gint        y,
		 gint        width,
		 gint        height)
{
	gint xpos, ypos;
	gboolean indented = FALSE;
	CairoColor c = *color;
	gfloat alpha1 = color->a;
	gfloat alpha2 = color->a * 0.5;
	
	cairo_save (cr);

	/* walk trough the rows */
	/* for speed reasons, replaced with code to paint the 5 pixel manually.
	 * First paint the center ones, then the others */
	for (ypos = y + 1; ypos < y + height; ypos += 2) {
		xpos = x;
		if (!indented)
			xpos += 1;
		else
			xpos += 3;

		for (; xpos < x + width; xpos += 4) {
			cairo_rectangle (cr, xpos, ypos, 1, 1);	
		}

		indented = !indented;
	}
	c.a = alpha1;
	ge_cairo_set_color (cr, &c);
	cairo_fill (cr);
	
	indented = FALSE;
	for (ypos = y + 1; ypos < y + height; ypos += 2) {
		xpos = x;
		if (!indented)
			xpos += 1;
		else
			xpos += 3;

		for (; xpos < x + width; xpos += 4) {
			cairo_rectangle (cr, xpos - 1, ypos, 1, 1);
			cairo_rectangle (cr, xpos, ypos - 1, 1, 1);
			cairo_rectangle (cr, xpos + 1, ypos, 1, 1);
			cairo_rectangle (cr, xpos, ypos + 1, 1, 1);
		}

		indented = !indented;
	}
	c.a = alpha2;
	ge_cairo_set_color (cr, &c);
	cairo_fill (cr);

	cairo_restore (cr);
}

/**************************************************************************/

static void
draw_hline (GtkStyle     *style,
	    GdkWindow    *window,
	    GtkStateType  state_type,
	    GdkRectangle *area,
	    GtkWidget    *widget,
	    const gchar  *detail,
	    gint          x1,
	    gint          x2,
	    gint          y)
{
	CairoColor color;
	cairo_t *cr;

#ifdef DEBUG
	printf ("draw_hline: %p %p %s %i %i %i\n", widget, window, detail, x1,
		x2, y);
#endif

	CHECK_ARGS
	
	/* Move the seperator line in menus down by 1 pixel. */
	if (CHECK_DETAIL (detail, "menuitem"))
		y++;

	ge_gdk_color_to_cairo (&style->fg[state_type], &color);
	color.a = GET_REAL_OPACITY(style, LINE_OPACITY);

	cr = ge_gdk_drawable_to_cairo (window, area);
	ge_cairo_set_color (cr, &color);

	cairo_move_to (cr, x1 + 0.5, y + 0.5);
	cairo_line_to (cr, x2 + 0.5, y + 0.5);

	cairo_stroke (cr);

	cairo_destroy (cr);
}

/**************************************************************************/

static void
draw_handle (GtkStyle      *style,
	     GdkWindow     *window,
	     GtkStateType   state_type,
	     GtkShadowType  shadow_type,
	     GdkRectangle  *area,
	     GtkWidget     *widget,
	     const gchar   *detail,
	     gint           x,
	     gint           y,
	     gint           width,
	     gint           height,
	     GtkOrientation orientation)
{
	int handle_width, handle_height, maxwidth, maxheight;
	CairoColor color;
	cairo_t *cr;

	CHECK_ARGS
	SANITIZE_SIZE
	
#ifdef DEBUG
	 printf ("%s: %p %p %s %i %i %i %i  %i\n", __FUNCTION__, widget,
		 window, detail, x, y, width, height, orientation);
#endif

	gtk_paint_box (style, window, state_type, shadow_type, area, widget,
		       detail, x, y, width, height);

	if (!CHECK_DETAIL (detail, "paned")) {
		x += 2;
		y += 2;
		width -= 4;
		height -= 4;
	}
	
	if (shadow_type == GTK_SHADOW_NONE) {
		maxwidth = width;
		maxheight = height;
	} else {
		maxwidth = width - 2;
		maxheight = height - 2;
	}

	if (orientation == GTK_ORIENTATION_HORIZONTAL) {
		handle_width = MIN (maxwidth, HANDLE_HEIGHT);
		handle_height = MIN (maxheight, HANDLE_WIDTH);
	} else {
		handle_width = MIN (maxwidth, HANDLE_WIDTH);
		handle_height = MIN (maxheight, HANDLE_HEIGHT);
	}

	if (handle_width <= 0 || handle_height <= 0)
		return;

	x += (width - handle_width) / 2;
	y += (height - handle_height) / 2;

	ge_gdk_color_to_cairo (&style->fg[state_type], &color);

	color.a = GET_REAL_OPACITY (style, HANDLE_OPACITY);

	cr = ge_gdk_drawable_to_cairo (window, area);

	draw_grid_cairo (cr, &color, x, y, handle_width, handle_height);

	cairo_destroy (cr);
}

/**************************************************************************/

static void
draw_vline (GtkStyle     *style,
	    GdkWindow    *window,
	    GtkStateType  state_type,
	    GdkRectangle *area,
	    GtkWidget    *widget,
	    const gchar  *detail,
	    gint          y1,
	    gint          y2,
	    gint          x)
{
	CairoColor color;
	cairo_t *cr;

#ifdef DEBUG
	printf ("%s: %p %p %s %i %i %i\n", __FUNCTION__, widget, window, detail,
		y1, y2, x);
#endif

	CHECK_ARGS
	
	ge_gdk_color_to_cairo (&style->fg[state_type], &color);
	color.a = GET_REAL_OPACITY (style, LINE_OPACITY);

	cr = ge_gdk_drawable_to_cairo (window, area);
	ge_cairo_set_color (cr, &color);

	cairo_move_to (cr, x + 0.5, y1 + 0.5);
	cairo_line_to (cr, x + 0.5, y2 + 0.5);

	cairo_stroke (cr);

	cairo_destroy (cr);
}

/**************************************************************************/
static void
draw_slider (GtkStyle      *style,
	     GdkWindow     *window,
	     GtkStateType   state_type,
	     GtkShadowType  shadow_type,
	     GdkRectangle  *area,
	     GtkWidget     *widget,
	     const gchar   *detail,
	     gint           x,
	     gint           y,
	     gint           width,
	     gint           height,
	     GtkOrientation orientation)
{
	int handle_width, handle_height;
	CairoColor color;
	cairo_t *cr;

#ifdef DEBUG
	printf ("%s: %p %p %s %i %i %i %i  %i\n", __FUNCTION__, widget, window,
		detail, x, y, width, height, orientation);
#endif

	CHECK_ARGS
	SANITIZE_SIZE
	
	/* This makes the slider overlay the stepper buttons at the sides. XXX */
	if (widget && GE_IS_SCROLLBAR (widget)) {
		GtkAdjustment *adjustment = GTK_RANGE (widget)->adjustment;

		/* If all of these values are 0, don't do anything.  This fixes mozilla/galeon scrollbars. */
		if (adjustment->value ||
		    adjustment->lower ||
		    adjustment->upper ||
		    adjustment->step_increment ||
		    adjustment->page_increment ||
		    adjustment->page_size) {
			if ((adjustment->value <= adjustment->lower) &&
			    (GTK_RANGE (widget)->has_stepper_a || GTK_RANGE (widget)->has_stepper_b)) {
				if (orientation == GTK_ORIENTATION_VERTICAL) {
					if (!gtk_range_get_inverted (GTK_RANGE (widget)))
						y--;
					height++;
				} else {
					if (!gtk_range_get_inverted (GTK_RANGE (widget)))
						x--;
					width++;
				}
			}
			if ((adjustment->value >= adjustment->upper - adjustment->page_size) &&
			    (GTK_RANGE (widget)->has_stepper_a || GTK_RANGE (widget)->has_stepper_b)) {
				if (orientation == GTK_ORIENTATION_VERTICAL) {
					if (gtk_range_get_inverted (GTK_RANGE (widget)))
						y--;
					height++;
				} else {
					if (gtk_range_get_inverted (GTK_RANGE (widget)))
						x--;
					width++;
				}
			}
		}
	}

	gtk_paint_box (style, window, state_type, shadow_type,
		       area, widget, detail, x, y, width, height);

	if (orientation == GTK_ORIENTATION_HORIZONTAL) {
		handle_width = MIN (width - 2, HANDLE_HEIGHT);
		handle_height = MIN (height - 2, HANDLE_WIDTH);
	} else {
		handle_width = MIN (width - 2, HANDLE_WIDTH);
		handle_height = MIN (height - 2, HANDLE_HEIGHT);
	}

	x += (width - handle_width) / 2;
	y += (height - handle_height) / 2;

	ge_gdk_color_to_cairo (&style->fg[state_type], &color);
	color.a = GET_REAL_OPACITY (style, HANDLE_OPACITY);
	cr = ge_gdk_drawable_to_cairo (window, area);

	draw_grid_cairo (cr, &color, x, y, handle_width, handle_height);

	cairo_destroy (cr);
}

static void
real_draw_box (GtkStyle      *style,
	       cairo_t       *cr,
	       GdkWindow     *window,
	       GtkStateType   state_type,
	       GtkShadowType  shadow_type,
	       GdkRectangle  *area,
	       GtkWidget     *widget,
	       const gchar   *detail,
	       gint           x,
	       gint           y,
	       gint           width,
	       gint           height,
	       gboolean       fill)
{
	/* For the shadow_type == GTK_SHADOW_NONE case we try to do some magic ...
	 * Buttons are drawn normally, but without any shadow effects, and most
	 * important, for unkown stuff we fall back to flat_box. */
	cairo_save (cr);

	if (CHECK_DETAIL (detail, "button") && ge_check_hint (GE_HINT_TREEVIEW_HEADER, GET_HINT (style), widget)) {
		CairoColor bg;
		CairoColor fg;
		
		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
		ge_gdk_color_to_cairo (&style->fg[state_type], &fg);
		
		cairo_rectangle (cr, x, y, width, height);
		ge_cairo_set_color (cr, &bg);
		cairo_fill (cr);
		
		if (shadow_type == GTK_SHADOW_OUT) {
			CairoColor inner, outer;
			cairo_pattern_t *pattern;
			
			ge_gdk_color_to_cairo (&style->fg[state_type], &inner);
			ge_gdk_color_to_cairo (&style->fg[state_type], &outer);
			inner.a = 0;
			outer.a = 0.1; /* XXX: Same as for buttons! */
			
			pattern = cairo_pattern_create_linear (x, height - 5, x, height - 1);
			ge_cairo_pattern_add_color_stop_color (pattern, 0.0, &inner);
			ge_cairo_pattern_add_color_stop_color (pattern, 1.0, &outer);
			cairo_set_source (cr, pattern);
			
			cairo_rectangle (cr, x, height - 5, width, 4.0);
			cairo_fill (cr);
			cairo_pattern_destroy (pattern);


			cairo_move_to (cr, x + 0.5, y + 0.5);
			cairo_line_to (cr, x + width - 0.5, y + 0.5);
			fg.a = BUTTON_BORDER_OPACITY * 0.05;
			ge_cairo_set_color (cr, &fg);
			cairo_stroke (cr);
		}

		cairo_move_to (cr, x + 0.5, height - 0.5);
		cairo_line_to (cr, x + width - 0.5, height - 0.5);
		fg.a = BUTTON_BORDER_OPACITY;
		ge_cairo_set_color (cr, &fg);
		cairo_stroke (cr);
		
		/* XXX: do not draw the line for the last column, if the headers are not resizeable. */
		if (ge_widget_is_ltr (widget)) {
			cairo_move_to (cr, x + width - 1.5, y + 5.5); /* 1.5 or 0.5? */
			cairo_line_to (cr, x + width - 1.5, y + height - 5.5);
		} else {
			cairo_move_to (cr, x + 1.5, y + 5.5);
			cairo_line_to (cr, x + 1.5, y + height - 5.5);
		}
		cairo_stroke (cr);
		
	} else if (CHECK_DETAIL (detail, "button") ||
	           CHECK_DETAIL (detail, "togglebutton") ||
	           CHECK_DETAIL (detail, "optionmenu")) {
		CairoColor bg;
		CairoColor fg;
		CairoCorners corners = CR_CORNER_ALL;

		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
		ge_gdk_color_to_cairo (&style->fg[state_type], &fg);
		
		/* So we don't need to use transparency in the border,
		 * hack this here. If it doesn't work correctly, it won't
		 * look too bad. */
		if (widget && GE_WIDGET_HAS_DEFAULT (widget))
			fg.a = GET_REAL_OPACITY (style, 1.0);
		else
			fg.a = GET_REAL_OPACITY (style, BUTTON_BORDER_OPACITY);


		if (ge_check_hint (GE_HINT_COMBOBOX_ENTRY, GET_HINT (style), widget)) {
			if (ge_widget_is_ltr (widget))
				corners = CR_CORNER_TOPRIGHT | CR_CORNER_BOTTOMRIGHT;
			else
				corners = CR_CORNER_TOPLEFT | CR_CORNER_BOTTOMLEFT;
		}
		if (!GET_ROUNDED_BUTTONS (style))
			corners = CR_CORNER_NONE;

		draw_rounded_rect (cr, x, y, width, height, 2.5, &fg, &bg, corners);

		if (shadow_type == GTK_SHADOW_IN) {
			gint slope = MIN (width / 2, height / 2);
			CairoColor inner;
			CairoColor outer;

			ge_gdk_color_to_cairo (&style->fg[state_type], &inner);
			ge_gdk_color_to_cairo (&style->fg[state_type], &outer);
			/* XXX: some way to calculate these would be nice. */
			inner.a = 0.0;
			outer.a = GET_REAL_OPACITY (style, BUTTON_BORDER_OPACITY * 0.7); /* XXX */

			cairo_save (cr);
			cairo_move_to (cr, x, y + height);
			cairo_line_to (cr, x + slope, y + height - slope);
			cairo_line_to (cr, x + width - slope, y + slope);
			cairo_line_to (cr, x + width, y);
			cairo_line_to (cr, x, y);
			cairo_close_path (cr);
			cairo_clip (cr);

			draw_rounded_gradient (cr, x + 1, y + 1,
					       width - 2, height - 2, 3.0,
					       0.5, IF_ROUNDED (style, 2.5, 0), &inner,
					       &outer);

			cairo_restore (cr);
		}

		/* Only draw shadow if button is large enough to fit it. */
		if (width > 18 && height > 18 && shadow_type != GTK_SHADOW_NONE) {
			gint slope = MIN (width / 2, height / 2);
			CairoColor inner;
			CairoColor outer;

			/* Offset shadow if depressed. */
			if (shadow_type == GTK_SHADOW_IN) {
				x++;
				y++;
			}

			ge_gdk_color_to_cairo (&style->fg[state_type], &inner);
			ge_gdk_color_to_cairo (&style->fg[state_type], &outer);
			inner.a = 0;
			outer.a = GET_REAL_OPACITY (style, 0.1);	/* XXX: #define this? */

			cairo_save (cr);
			cairo_move_to (cr, x, y + height);
			cairo_line_to (cr, x + slope, y + height - slope);
			cairo_line_to (cr, x + width - slope, y + slope);
			cairo_line_to (cr, x + width, y);
			cairo_line_to (cr, x + width, y + height);
			cairo_close_path (cr);
			cairo_clip (cr);

			draw_rounded_gradient (cr, x + 1, y + 1,
					       width - 2, height - 2, 4, 0,
					       IF_ROUNDED (style, 2.5, 0), &inner, &outer);
			cairo_restore (cr);
		}

		/* fake a line inside the optionmenu */
		if (CHECK_DETAIL (detail, "optionmenu")) {
			gint vline_x;
			gint spacing;
			GtkRequisition indicator_size;
			GtkBorder indicator_spacing;

			ge_option_menu_get_props (widget, &indicator_size,
						  &indicator_spacing);
			spacing = indicator_size.width;
			spacing +=
			    indicator_spacing.left + indicator_spacing.right;
			spacing += style->xthickness;
			/* seems to be 2px ... where do those come from? */
			spacing -= 2;

			if (ge_widget_is_ltr (widget))
				vline_x = x + width - spacing;
			else
				vline_x = x + spacing;

			gtk_paint_vline (style, window, state_type, area,
					 widget, detail,
					 y + style->ythickness + 4,
					 y + height - style->ythickness - 4,
					 vline_x);
		}
	} else if (CHECK_DETAIL (detail, "buttondefault") ||
		   CHECK_DETAIL (detail, "togglebuttondefault")) {
		CairoColor shadow_inner;
		CairoColor shadow_outer;
		CairoColor fg;
		gfloat inner_radius;
		gint shadow_size;
		GtkBorder default_border;

		ge_button_get_default_border (widget, &default_border);
		shadow_size = MIN (MIN (default_border.left, default_border.right),
		                   MIN (default_border.top, default_border.bottom));

		inner_radius = GET_ROUNDED_BUTTONS (style) ? 2.5 : 0;

		ge_gdk_color_to_cairo (&style->fg[state_type], &fg);

		/* draw the shadow around this. */
		shadow_outer = fg;
		shadow_inner = fg;
		shadow_outer.a = 0;
		shadow_inner.a = GET_REAL_OPACITY (style, DEFAULT_SHADOW_OPACITY);

		draw_rounded_gradient (cr, x, y, width, height, -1, inner_radius,
				       shadow_size + inner_radius,
				       &shadow_inner, &shadow_outer);
	} else if (CHECK_DETAIL (detail, "menuitem")) {
		CairoCorners corners;
		CairoColor bevel;
		CairoColor bg;

		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);

		/* for some reason, industrial always uses GTK_STATE_NORMAL here, can't change that
		 * without breaking compatibility. */
		ge_gdk_color_to_cairo (&style->fg[GTK_STATE_NORMAL], &bevel);
		bevel.a = GET_REAL_OPACITY (style, MENUITEM_BORDER_OPACITY);

		corners = GET_ROUNDED_BUTTONS (style) ? CR_CORNER_ALL : CR_CORNER_NONE;

		if (fill)
			draw_rounded_rect (cr, x, y, width, height, 1.5,
					   &bevel, &bg, corners);
		else
			draw_rounded_rect (cr, x, y, width, height, 1.5,
					   &bevel, NULL, corners);
	} else if (CHECK_DETAIL (detail, "trough")
		   || CHECK_DETAIL (detail, "trough-lower")
		   || CHECK_DETAIL (detail, "trough-upper")
		   || CHECK_DETAIL (detail, "trough-fill-level")
		   || CHECK_DETAIL (detail, "trough-fill-level-full")
		   || CHECK_DETAIL (detail, "menu")
		   || CHECK_DETAIL (detail, "dockitem_bin")
		   || CHECK_DETAIL (detail, "handlebox_bin")
		   || CHECK_DETAIL (detail, "toolbar")
		   || CHECK_DETAIL (detail, "dockitem")
		   || ge_object_is_a (G_OBJECT (widget), "PanelAppletFrame")) {
		CairoColor bevel;
		CairoColor bg;

		if (fill) {
			if (CHECK_DETAIL (detail, "trough") ||
			    CHECK_DETAIL (detail, "trough-lower") ||
			    CHECK_DETAIL (detail, "trough-upper") ||
			    CHECK_DETAIL (detail, "trough-fill-level") ||
			    CHECK_DETAIL (detail, "trough-fill-level-full")) {
				CairoColor bg_color;

				/* Troughs cannot be transparent!
				 * This is a hack to fix this by filling with a solid color first. */
				ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &bg_color);
				ge_cairo_set_color (cr, &bg_color);
				cairo_rectangle (cr, x, y, width, height);
				cairo_fill (cr);

				/* Troughs always draw with state ACTIVE or INSENSITIVE,
				 * so this sets the state to NORMAL to get the correct colors. */
				if (state_type == GTK_STATE_ACTIVE) {
					state_type = GTK_STATE_NORMAL;
				}
				
				/* XXX: This might need improvement, at least now it is "implemented" */
				if (CHECK_DETAIL (detail, "trough-lower") ||
				    CHECK_DETAIL (detail, "trough-fill-level") || CHECK_DETAIL (detail, "trough-fill-level-full")) {
					ge_gdk_color_to_cairo (&style->bg[GTK_STATE_SELECTED], &bg);
				} else {
					ge_gdk_color_to_cairo (&style->fg[state_type], &bg);
					
					bg.a = GET_REAL_OPACITY (style, TROUGH_BG_OPACITY);
					
					/* Compose the color here instead leaving the work to
					 * cairo/xserver which doesn't know that this is a solid
					 * color. */
					bg.r = bg.r * bg.a + bg_color.r * (1 - bg.a);
					bg.g = bg.g * bg.a + bg_color.g * (1 - bg.a);
					bg.b = bg.b * bg.a + bg_color.b * (1 - bg.a);
					bg.a = 1.0;
				}

				ge_gdk_color_to_cairo (&style->fg[state_type],  &bevel);
				bevel.a = GET_REAL_OPACITY (style, TROUGH_BORDER_OPACITY);
			} else {
				ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
				ge_gdk_color_to_cairo (&style->fg[state_type], &bevel);
				bevel.a = GET_REAL_OPACITY (style, TROUGH_BORDER_OPACITY);
			}
			draw_rounded_rect (cr, x, y, width, height, 1.5,
					   &bevel, &bg, IF_ROUNDED (style, CR_CORNER_ALL, CR_CORNER_NONE));
		}
	} else if (CHECK_DETAIL (detail, "menubar")) {
		CairoColor bg;
		CairoColor bevel;

		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
		ge_gdk_color_to_cairo (&style->fg[state_type], &bevel);
		bevel.a = GET_REAL_OPACITY (style, MENUBAR_BORDER_OPACITY);
		
		/* ignore the menubar if the shadow is NONE. This is the case for the
		 * mainmenu applet and the task selector. */
		if (shadow_type == GTK_SHADOW_NONE)
			return;

		if (fill)
			draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
					   &bevel, &bg, CR_CORNER_ALL);
		else
			draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
					   &bevel, NULL, CR_CORNER_ALL);
	} else if (CHECK_DETAIL (detail, "spinbutton_up")
		   || CHECK_DETAIL (detail, "spinbutton_down")) {
		/* XXX: This results in basically drawing nothing, right? */
		if (CHECK_DETAIL (detail, "spinbutton_up")) {
			x += 1;
			y += 1;
			width -= 2;
			height -= 1;
		} else {
			x += 1;
			width -= 2;
			height -= 1;
		}

		GTK_STYLE_CLASS (industrial_style_parent_class)->draw_flat_box (style, window, state_type,
					     shadow_type, area, widget, detail,
					     x, y, width, height);
	} else if (CHECK_DETAIL (detail, "slider")
		   || CHECK_DETAIL (detail, "stepper")
		   || CHECK_DETAIL (detail, "vscrollbar")
		   || CHECK_DETAIL (detail, "hscrollbar")) {
		CairoColor bevel, bg;
		/* The original had some weird stuff here, which would draw the bottom/right
		 * lines different then the top/left ones. I just dropped this. */

		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
		ge_gdk_color_to_cairo (&style->fg[state_type], &bevel);
		bevel.a = GET_REAL_OPACITY (style, 0.5); /* XXX: #define this? */

		/* XXX: fill can never be FALSE, right? */
		if (fill)
			draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
					   &bevel, &bg, CR_CORNER_ALL);
		else
			draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
					   &bevel, NULL, CR_CORNER_ALL);
	} else if (CHECK_DETAIL (detail, "entry")) {
		CairoCorners corners = CR_CORNER_ALL;
		CairoColor bevel, bg, base;

		ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &bg);
		ge_gdk_color_to_cairo (&style->base[state_type], &base);

		/* Fill the background as it is initilized to base[NORMAL].
		 * Relevant GTK+ bug: http://bugzilla.gnome.org/show_bug.cgi?id=513471
		 * The fill only happens if no hint has been added by some application
		 * that is faking GTK+ widgets. */
		if (!widget || !g_object_get_data(G_OBJECT (widget), "transparent-bg-hint"))
		{
			cairo_rectangle (cr, x, y, width, height);
			ge_cairo_set_color (cr, &bg);
			cairo_fill (cr);
		}
		
		if (ge_check_hint (GE_HINT_SPINBUTTON, GET_HINT (style), widget) ||
		    ge_check_hint (GE_HINT_COMBOBOX_ENTRY, GET_HINT (style), widget)) {
			/* effectively cut one side off. */
			width += 2;
			if (!ge_widget_is_ltr (widget))
				x -= 2;
		}
		
		
		ge_gdk_color_to_cairo (&style->fg[state_type], &bevel);
		bevel.a = GET_REAL_OPACITY (style, STANDARD_BORDER_OPACITY);

		draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
				   &bevel, &base, corners);
	} else {
		CairoColor bevel, bg;
		CairoCorners corners = CR_CORNER_ALL;
		
		if (CHECK_DETAIL (detail, "spinbutton")) {
			if (ge_widget_is_ltr (widget))
				corners = CR_CORNER_TOPRIGHT | CR_CORNER_BOTTOMRIGHT;
			else
				corners = CR_CORNER_TOPLEFT | CR_CORNER_BOTTOMLEFT;
		}

		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
		
		ge_gdk_color_to_cairo (&style->fg[state_type], &bevel);
		bevel.a = GET_REAL_OPACITY (style, STANDARD_BORDER_OPACITY);

		if (fill) {
			if (shadow_type != GTK_SHADOW_NONE) {
				draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
						   &bevel, &bg, corners);
			} else {
				GTK_STYLE_CLASS (industrial_style_parent_class)->draw_flat_box (style, window, state_type, shadow_type, area, widget, detail, x, y, width, height);
			}
		} else if (shadow_type != GTK_SHADOW_NONE) {
			draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
					   &bevel, NULL, corners);
		}
	}

	cairo_restore (cr);
}

static void
draw_box (GtkStyle      *style,
	  GdkWindow     *window,
	  GtkStateType   state_type,
	  GtkShadowType  shadow_type,
	  GdkRectangle  *area,
	  GtkWidget     *widget,
	  const gchar   *detail,
	  gint           x,
	  gint           y,
	  gint           width,
	  gint           height)
{
	cairo_t *cr;
#ifdef DEBUG
	printf ("draw_box: %p %p %s %i %i %i %i\n", widget, window, detail, x,
		y, width, height);
#endif
	CHECK_ARGS
	SANITIZE_SIZE
	
	cr = ge_gdk_drawable_to_cairo (window, area);

	real_draw_box (style, cr, window, state_type, shadow_type, area, widget,
		       detail, x, y, width, height, TRUE);

	cairo_destroy (cr);
}

static void
draw_focus (GtkStyle      *style,
            GdkWindow     *window,
            GtkStateType   state_type,
            GdkRectangle  *area,
            GtkWidget     *widget,
            const gchar   *detail,
            gint           x,
            gint           y,
            gint           width,
            gint           height)
{
	/* we draw a custom focus for entries ... */
	if (CHECK_DETAIL (detail, "entry")) {
		cairo_t *cr;
		CairoColor border;
		CairoCorners corners = CR_CORNER_ALL;
		
		SANITIZE_SIZE
		CHECK_ARGS

		if (ge_check_hint (GE_HINT_COMBOBOX_ENTRY, GET_HINT (style), widget) ||
		    ge_check_hint (GE_HINT_SPINBUTTON, GET_HINT (style), widget)) {
			if (ge_widget_is_ltr (widget))
				corners = CR_CORNER_TOPLEFT | CR_CORNER_BOTTOMLEFT;
			else
				corners = CR_CORNER_TOPRIGHT | CR_CORNER_BOTTOMRIGHT;
		}
		
		cr = ge_gdk_drawable_to_cairo (window, area);
		ge_gdk_color_to_cairo (&style->bg[GTK_STATE_SELECTED], &border);
		
		ge_cairo_rounded_rectangle (cr, x + 1, y + 1, width - 2, height - 2, IF_ROUNDED (style, 1.5, 0), corners);
		ge_cairo_set_color (cr, &border);
		cairo_set_line_width (cr, 2.0);
		cairo_stroke (cr);	
		
		cairo_destroy (cr);
		
		return;
	}
	
	GTK_STYLE_CLASS (industrial_style_parent_class)->draw_focus (style, window, state_type, area, widget, detail, x, y, width, height);
}

static void
draw_shadow (GtkStyle      *style,
	     GdkWindow     *window,
	     GtkStateType   state_type,
	     GtkShadowType  shadow_type,
	     GdkRectangle  *area,
	     GtkWidget     *widget,
	     const gchar   *detail,
	     gint           x,
	     gint           y,
	     gint           width,
	     gint           height)
{
	cairo_t *cr;
#ifdef DEBUG
	printf ("draw_shadow: %p %p %s %i %i %i %i\n", widget, window, detail,
		x, y, width, height);
#endif
	CHECK_ARGS
	SANITIZE_SIZE
	
	cr = ge_gdk_drawable_to_cairo (window, area);

	real_draw_box (style, cr, window, state_type, shadow_type, area, widget,
		       detail, x, y, width, height, FALSE);

	cairo_destroy (cr);
}

/**************************************************************************/

static void
real_draw_box_gap (GtkStyle       *style,
		   cairo_t        *cr,
		   GdkWindow      *window,
		   GtkStateType    state_type,
		   GtkShadowType   shadow_type,
		   GdkRectangle   *area,
		   GtkWidget      *widget,
		   const gchar    *detail,
		   gint            x,
		   gint            y,
		   gint            width,
		   gint            height,
		   GtkPositionType gap_side,
		   gint            gap_x,
		   gint            gap_width,
		   gboolean        fill)
{
	CairoColor bevel, bg;
	gint gap_maxwidth = 0;

	cairo_save (cr);

	switch (gap_side) {
	case GTK_POS_TOP:
	case GTK_POS_BOTTOM:
		gap_maxwidth = width;
		break;
	case GTK_POS_LEFT:
	case GTK_POS_RIGHT:
		gap_maxwidth = height;
		break;
	default:
		g_assert_not_reached();
	}

	gap_x -= 1;
	gap_width += 2;

	if (gap_x < 0) {
		gap_width += gap_x;
		gap_x = 0;
	}
	if (gap_x + gap_width > gap_maxwidth) {
		gap_width = gap_maxwidth - gap_x;
	}

	ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
	ge_gdk_color_to_cairo (&style->fg[state_type], &bevel);
	bevel.a = GET_REAL_OPACITY (style, STANDARD_BORDER_OPACITY);

	/* clip the gap area */
	cairo_save (cr);
	cairo_set_fill_rule (cr, CAIRO_FILL_RULE_EVEN_ODD);

	switch (gap_side) {
	case GTK_POS_TOP:
		cairo_rectangle (cr, x + gap_x, y, gap_width, 1);
		break;
	case GTK_POS_BOTTOM:
		cairo_rectangle (cr, x + gap_x, y + height - 1, gap_width, 1);
		break;
	case GTK_POS_LEFT:
		cairo_rectangle (cr, x, y + gap_x, 1, gap_width);
		break;
	case GTK_POS_RIGHT:
		cairo_rectangle (cr, x + width - 1, y + gap_x, 1, gap_width);
		break;
	}

	ge_cairo_set_color (cr, &bg);
	if (fill)
		cairo_fill_preserve (cr);

	cairo_rectangle (cr, x, y, width, height);
	cairo_clip (cr);

	/* reset fill rule */
	cairo_set_fill_rule (cr, CAIRO_FILL_RULE_WINDING);

	if (fill)
		draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
		                   &bevel, &bg, CR_CORNER_ALL);
	else
		draw_rounded_rect (cr, x, y, width, height, IF_ROUNDED (style, 1.5, 0),
		                   &bevel, NULL, CR_CORNER_ALL);
	cairo_restore (cr);

	/* and draw two dots on both sides of the gap. */
	switch (gap_side) {
	case GTK_POS_TOP:
		cairo_rectangle (cr, x + gap_x, y, 1, 1);
		cairo_rectangle (cr, x + gap_x + gap_width - 1, y, 1, 1);
		break;
	case GTK_POS_BOTTOM:
		cairo_rectangle (cr, x + gap_x, y + height - 1, 1, 1);
		cairo_rectangle (cr, x + gap_x + gap_width - 1, y + height - 1, 1, 1);
		break;
	case GTK_POS_LEFT:
		cairo_rectangle (cr, x, y + gap_x, 1, 1);
		cairo_rectangle (cr, x, y + gap_x + gap_width - 1, 1, 1);
		break;
	case GTK_POS_RIGHT:
		cairo_rectangle (cr, x + width - 1, y + gap_x, 1, 1);
		cairo_rectangle (cr, x + width - 1, y + gap_x + gap_width - 1, 1, 1);
		break;
	}
	ge_cairo_set_color (cr, &bevel);
	cairo_fill (cr);

	cairo_restore (cr);
}

static void
draw_box_gap (GtkStyle      *style,
	      GdkWindow     *window,
	      GtkStateType   state_type,
	      GtkShadowType  shadow_type,
	      GdkRectangle  *area,
	      GtkWidget     *widget,
	      const gchar   *detail,
	      gint            x,
	      gint            y,
	      gint            width,
	      gint            height,
	      GtkPositionType gap_side,
	      gint            gap_x,
	      gint            gap_width)
{
	cairo_t *cr;

#ifdef DEBUG
	printf ("%s: %p %p %s %i %i %i %i  %i\n", __FUNCTION__, widget, window,
		detail, x, y, width, height, gap_side);
#endif

	if (shadow_type == GTK_SHADOW_NONE)
		return;

	CHECK_ARGS
	SANITIZE_SIZE
	
	cr = ge_gdk_drawable_to_cairo (window, area);

	real_draw_box_gap (style, cr, window, state_type, shadow_type, area,
			   widget, detail, x, y, width, height, gap_side, gap_x,
			   gap_width, TRUE);

	cairo_destroy (cr);
}

static void
draw_shadow_gap (GtkStyle       *style,
		 GdkWindow      *window,
		 GtkStateType    state_type,
		 GtkShadowType   shadow_type,
		 GdkRectangle   *area,
		 GtkWidget      *widget,
		 const gchar    *detail,
		 gint            x,
		 gint            y,
		 gint            width,
		 gint            height,
		 GtkPositionType gap_side,
		 gint            gap_x,
		 gint            gap_width)
{
	cairo_t *cr;

#ifdef DEBUG
	printf ("%s: %p %p %s %i %i %i %i  %i\n", __FUNCTION__, widget, window,
		detail, x, y, width, height, gap_side);
#endif

	if (shadow_type == GTK_SHADOW_NONE)
		return;

	cr = ge_gdk_drawable_to_cairo (window, area);

	real_draw_box_gap (style, cr, window, state_type, shadow_type, area,
			   widget, detail, x, y, width, height, gap_side, gap_x,
			   gap_width, FALSE);

	cairo_destroy (cr);
}

static void
draw_extension (GtkStyle       *style,
		GdkWindow      *window,
		GtkStateType    state_type,
		GtkShadowType   shadow_type,
		GdkRectangle   *area,
		GtkWidget      *widget,
		const gchar    *detail,
		gint            x,
		gint            y,
		gint            width,
		gint            height,
		GtkPositionType gap_side)
{
	CairoCorners corners = CR_CORNER_ALL;
	cairo_t *cr;
	cairo_pattern_t *pattern = NULL;
	CairoColor bevel;
	CairoColor bg;

#ifdef DEBUG
	printf ("%s: %p %p %s %i %i %i %i  %i\n", __FUNCTION__, widget, window,
		detail, x, y, width, height, gap_side);
#endif

	if (shadow_type == GTK_SHADOW_NONE)
		return;

	corners = GET_ROUNDED_BUTTONS (style) ? CR_CORNER_ALL : CR_CORNER_NONE;

	cr = ge_gdk_drawable_to_cairo (window, area);
	cairo_rectangle (cr, x, y, width, height);
	cairo_clip (cr);

	ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
	ge_gdk_color_to_cairo (&style->fg[state_type], &bevel);
	bevel.a = GET_REAL_OPACITY (style, STANDARD_BORDER_OPACITY);

	switch (gap_side) {
	case GTK_POS_TOP:
		draw_rounded_rect (cr, x, y - 3, width, height + 3, 1.5,
		                   &bevel, &bg, corners);
		pattern = cairo_pattern_create_linear (x, y, x, y + 4);
		cairo_rectangle (cr, x, y, width, 4);
		break;
	case GTK_POS_BOTTOM:
		draw_rounded_rect (cr, x, y, width, height + 3, 1.5,
		                   &bevel, &bg, corners);
		pattern = cairo_pattern_create_linear (x, y + height, x, y + height - 4);
		cairo_rectangle (cr, x, y + height - 4, width, 4);
		break;
	case GTK_POS_LEFT:
		draw_rounded_rect (cr, x - 3, y, width + 3, height, 1.5,
		                   &bevel, &bg, corners);
		pattern = cairo_pattern_create_linear (x, y, x + 4, y);
		cairo_rectangle (cr, x, y, 4, height);
		break;
	case GTK_POS_RIGHT:
		draw_rounded_rect (cr, x, y, width + 3, height, 1.5,
		                   &bevel, &bg, corners);
		pattern = cairo_pattern_create_linear (x + width, y, x + width - 4, y);
		cairo_rectangle (cr, x + width - 4, y, 4, height);
		break;
	}

	if (state_type != GTK_STATE_NORMAL) {
		bevel.a *= 0.3;
		ge_cairo_pattern_add_color_stop_color (pattern, 0, &bevel);

		bevel.a = 0;
		ge_cairo_pattern_add_color_stop_color (pattern, 1, &bevel);

		cairo_set_source (cr, pattern);
		cairo_fill (cr);
	}

	cairo_pattern_destroy (pattern);
	cairo_destroy (cr);
}

static void
draw_check (GtkStyle * style,
	    GdkWindow * window,
	    GtkStateType state_type,
	    GtkShadowType shadow_type,
	    GdkRectangle * area,
	    GtkWidget * widget,
	    const gchar * detail, gint x, gint y, gint width, gint height)
{
	gint check_size;
	cairo_t *cr;
	CairoColor fg, bg;

#ifdef DEBUG
	printf ("%s: %p %p %s %i %i %i %i\n", __FUNCTION__, widget, window,
		detail, x, y, width, height);
#endif

	cr = ge_gdk_drawable_to_cairo (window, area);
	if (state_type == GTK_STATE_NORMAL) {
		ge_gdk_color_to_cairo (&style->text[state_type], &fg);
		ge_gdk_color_to_cairo (&style->base[state_type], &bg);
	} else {
		ge_gdk_color_to_cairo (&style->fg[state_type], &fg);
		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
	}

	check_size = width > height ? height : width;
	/* center the check */
	x += (width - check_size) / 2;
	y += (height - check_size) / 2;

	width = check_size;
	height = check_size;

	fg.a = GET_REAL_OPACITY (style, DEFAULT_SHADOW_OPACITY);
	draw_rounded_rect (cr, x, y, width, height, 1.5,
	                   &fg, &bg, GET_ROUNDED_BUTTONS (style) ? CR_CORNER_ALL : CR_CORNER_NONE);

	cairo_save (cr);
	fg.a = fg.a * 0.3;
	
	cairo_move_to (cr, x, y + check_size);
	cairo_line_to (cr, x + check_size, y);
	cairo_line_to (cr, x, y);
	cairo_close_path (cr);
	cairo_clip (cr);
	
	draw_rounded_rect (cr, x + 1, y + 1, width - 2, height - 2, 1.5,
	                   &fg, NULL, GET_ROUNDED_BUTTONS (style) ? CR_CORNER_ALL : CR_CORNER_NONE);
	cairo_restore (cr);

	cairo_translate (cr, x + 2.0, y + 2.0);

	cairo_scale (cr, (check_size - 4) / 7., (check_size - 4) / 7.);

	fg.a = GET_REAL_OPACITY (style, 1.0);
	ge_cairo_set_color (cr, &fg);

	/* draw the interior */
	if (shadow_type == GTK_SHADOW_IN) {
		cairo_move_to (cr, 0.0, 4.1);
		cairo_line_to (cr, 2.8, 6.65);
		cairo_curve_to (cr, 3.7, 5.2, 5.0, 2.65, 6.9, 1.4);
		cairo_line_to (cr, 6.4, 0.6);
		cairo_curve_to (cr, 4.5, 1.9, 3.55, 3.4, 2.6, 4.7);
		cairo_line_to (cr, 0.8, 3);
		cairo_close_path (cr);

		cairo_fill (cr);
	} else if (shadow_type == GTK_SHADOW_ETCHED_IN) {
		cairo_set_line_width (cr, 2.0);
		cairo_set_line_cap (cr, CAIRO_LINE_CAP_BUTT);
		cairo_move_to (cr, 0.0, 3.5);
		cairo_line_to (cr, 7.0, 3.5);

		cairo_stroke (cr);
	}

	cairo_destroy (cr);
}

static void
draw_option (GtkStyle * style,
	     GdkWindow * window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle * area,
	     GtkWidget * widget,
	     const gchar * detail, gint x, gint y, gint width, gint height)
{
	cairo_t *cr;
	CairoColor fg, bg;
	gfloat radius;
	gfloat xc, yc;

#ifdef DEBUG
	printf ("%s: %p %p %s %i %i %i %i\n", __FUNCTION__, widget, window,
		detail, x, y, width, height);
#endif

	cr = ge_gdk_drawable_to_cairo (window, area);
	if (state_type == GTK_STATE_NORMAL) {
		ge_gdk_color_to_cairo (&style->base[state_type], &bg);
		ge_gdk_color_to_cairo (&style->text[state_type], &fg);
	} else {
		ge_gdk_color_to_cairo (&style->bg[state_type], &bg);
		ge_gdk_color_to_cairo (&style->fg[state_type], &fg);
	}

	radius = MIN (width, height) / 2.0;

	xc = x + width / 2.0;
	yc = y + height / 2.0;
	cairo_arc (cr, xc, yc, radius - 0.5, 0, 2 * G_PI);

	ge_cairo_set_color (cr, &bg);
	cairo_fill (cr);

	fg.a = GET_REAL_OPACITY (style, 0.5);	/* XXX: #define this? */
	ge_cairo_set_color (cr, &fg);

	/* XXX: There should be another shadow ... */
	cairo_save (cr);
	
	cairo_set_fill_rule (cr, CAIRO_FILL_RULE_EVEN_ODD);
	
	cairo_arc (cr, xc, yc, radius, 0, 2 * G_PI);
	cairo_arc (cr, xc + 0.2, yc + 0.2, radius - 1.2, 0, 2 * G_PI);

	cairo_fill (cr);
	
	cairo_restore (cr);

	if (shadow_type == GTK_SHADOW_IN) {
		cairo_pattern_t *pattern;
		fg.a = GET_REAL_OPACITY (style, 1.0);

		ge_cairo_set_color (cr, &fg);
		cairo_arc (cr, xc, yc, radius - 3, 0, 2 * G_PI);
		cairo_fill (cr);

		pattern =
		    cairo_pattern_create_radial (xc, yc, 0, xc, yc, radius - 4);

		bg.a = 0;
		ge_cairo_pattern_add_color_stop_color (pattern, 0, &bg);
		bg.a = GET_REAL_OPACITY (style, 0.7);	/* XXX: #define this? */
		ge_cairo_pattern_add_color_stop_color (pattern, 1, &bg);

		cairo_set_source (cr, pattern);
		cairo_pattern_destroy (pattern);

		cairo_move_to (cr, xc, yc);
		cairo_arc (cr, xc, yc, radius - 4, G_PI - G_PI_4,
			   3 * G_PI_2 + G_PI_4);
		cairo_close_path (cr);
		cairo_fill (cr);
	} else if (shadow_type == GTK_SHADOW_ETCHED_IN) {
		/* XXX: inconsistent state needs sanity check */
		cairo_set_line_width (cr, 2.0);
		cairo_set_line_cap (cr, CAIRO_LINE_CAP_BUTT);
		cairo_move_to (cr, xc - radius + 2, yc);
		cairo_line_to (cr, xc + radius - 2, yc);

		cairo_stroke (cr);
	}
	cairo_destroy (cr);
}

static GdkPixbuf*
set_transparency (const GdkPixbuf *pixbuf,
		  gdouble          alpha_percent)
{
	GdkPixbuf *target;
	guchar *data, *current;
	guint x, y, rowstride, height, width;

	g_return_val_if_fail (pixbuf != NULL, NULL);
	g_return_val_if_fail (GDK_IS_PIXBUF (pixbuf), NULL);

	/* Returns a copy of pixbuf with it's non-completely-transparent pixels to
	   have an alpha level "alpha_percent" of their original value. */

	target = gdk_pixbuf_add_alpha (pixbuf, FALSE, 0, 0, 0);

	if (alpha_percent == 1.0)
		return target;
	width = gdk_pixbuf_get_width (target);
	height = gdk_pixbuf_get_height (target);
	rowstride = gdk_pixbuf_get_rowstride (target);
	data = gdk_pixbuf_get_pixels (target);

	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			/* The "4" is the number of chars per pixel, in this case, RGBA,
			   the 3 means "skip to the alpha" */
			current = data + (y * rowstride) + (x * 4) + 3;
			*(current) = (guchar) (*(current) * alpha_percent);
		}
	}

	return target;
}

static GdkPixbuf*
scale_or_ref (GdkPixbuf *src,
              gint       width,
              gint       height)
{
	if (width == gdk_pixbuf_get_width (src) &&
	    height == gdk_pixbuf_get_height (src)) {
		return g_object_ref (src);
	} else {
		return gdk_pixbuf_scale_simple (src, width, height, GDK_INTERP_BILINEAR);
	}
}

static GdkPixbuf*
render_icon (GtkStyle            *style,
	     const GtkIconSource *source,
	     GtkTextDirection     direction,
	     GtkStateType         state,
	     GtkIconSize          size,
	     GtkWidget           *widget,
	     const char          *detail)
{
	int width = 1;
	int height = 1;
	GdkPixbuf *scaled;
	GdkPixbuf *stated;
	GdkPixbuf *base_pixbuf;
	GdkScreen *screen;
	GtkSettings *settings;

	/* Oddly, style can be NULL in this function, because
	 * GtkIconSet can be used without a style and if so
	 * it uses this function.
	 */

	base_pixbuf = gtk_icon_source_get_pixbuf (source);

	g_return_val_if_fail (base_pixbuf != NULL, NULL);

	if (widget && gtk_widget_has_screen (widget)) {
		screen = gtk_widget_get_screen (widget);
		settings = gtk_settings_get_for_screen (screen);
	} else if (style->colormap) {
		screen = gdk_colormap_get_screen (style->colormap);
		settings = gtk_settings_get_for_screen (screen);
	} else {
		settings = gtk_settings_get_default ();
		GTK_NOTE (MULTIHEAD, g_warning ("Using the default screen for gtk_default_render_icon()"));
	}

	if (size != (GtkIconSize) - 1
	    && !gtk_icon_size_lookup_for_settings (settings, size, &width, &height)) {
		g_warning (G_STRLOC ": invalid icon size '%d'", size);
		return NULL;
	}

	/* If the size was wildcarded, and we're allowed to scale, then scale; otherwise,
	 * leave it alone.
	 */
	if (size != (GtkIconSize) - 1
	    && gtk_icon_source_get_size_wildcarded (source))
		scaled = scale_or_ref (base_pixbuf, width, height);
	else
		scaled = g_object_ref (base_pixbuf);

	/* If the state was wildcarded, then generate a state. */
	if (gtk_icon_source_get_state_wildcarded (source)) {
		if (state == GTK_STATE_INSENSITIVE) {
			stated = set_transparency (scaled, 0.3);
			gdk_pixbuf_saturate_and_pixelate (stated, stated,
							  0.1, FALSE);

			g_object_unref (scaled);
		} else if (state == GTK_STATE_PRELIGHT) {
			stated = gdk_pixbuf_copy (scaled);

			gdk_pixbuf_saturate_and_pixelate (scaled, stated,
							  1.2, FALSE);

			g_object_unref (scaled);
		} else {
			stated = scaled;
		}
	} else
		stated = scaled;

	return stated;
}

/* Non-drawing stuff */

void
industrial_style_register_types (GTypeModule *module)
{
	industrial_style_register_type (module);
}

static void
industrial_style_copy (GtkStyle * style, GtkStyle * src)
{
	IndustrialStyle *industrial_style = INDUSTRIAL_STYLE (style);
	IndustrialStyle *industrial_src = INDUSTRIAL_STYLE (src);

	industrial_style->contrast = industrial_src->contrast;
	industrial_style->rounded_buttons = industrial_src->rounded_buttons;

	GTK_STYLE_CLASS (industrial_style_parent_class)->copy (style, src);
}

static void
industrial_style_init_from_rc (GtkStyle * style, GtkRcStyle * rc_style)
{
	IndustrialStyle *industrial_style = INDUSTRIAL_STYLE (style);
	GTK_STYLE_CLASS (industrial_style_parent_class)->init_from_rc (style, rc_style);

	industrial_style->contrast = INDUSTRIAL_RC_STYLE (rc_style)->contrast;
	industrial_style->rounded_buttons = INDUSTRIAL_RC_STYLE (rc_style)->rounded_buttons;
	industrial_style->hint = INDUSTRIAL_RC_STYLE (rc_style)->hint;
}

static void
industrial_style_init (IndustrialStyle * style)
{
	style->contrast = 1.0;
	style->rounded_buttons = TRUE;
	style->hint = 0;
}

static void
industrial_style_class_init (IndustrialStyleClass * klass)
{
	GtkStyleClass *style_class = GTK_STYLE_CLASS (klass);

	style_class->copy = industrial_style_copy;
	style_class->init_from_rc = industrial_style_init_from_rc;

	style_class->draw_focus = draw_focus;

	style_class->draw_handle = draw_handle;
	style_class->draw_vline = draw_vline;
	style_class->draw_hline = draw_hline;
	style_class->draw_slider = draw_slider;

	style_class->draw_check = draw_check;
	style_class->draw_box = draw_box;
	style_class->draw_shadow = draw_shadow;
	style_class->draw_box_gap = draw_box_gap;
	style_class->draw_shadow_gap = draw_shadow_gap;
	style_class->draw_extension = draw_extension;
	style_class->draw_option = draw_option;
	style_class->render_icon = render_icon;
}

static void
industrial_style_class_finalize (IndustrialStyleClass *klass)
{
}
