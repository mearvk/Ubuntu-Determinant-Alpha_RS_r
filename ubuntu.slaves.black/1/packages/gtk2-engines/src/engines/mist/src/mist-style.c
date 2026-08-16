/* Mist theme for gtk, based on thinice, based on raster's Motif theme
 * and the Metal theme.

Mist Author: Dave Camp <dave@ximian.com>
Thinice Authors: Tim Gerla <timg@rrv.net>
                 Tomas Ögren <stric@ing.umu.se>
 */

#include <math.h>
#include <string.h>
#include <gtk/gtk.h>
#include <cairo.h>

#include "mist-style.h"
#include "mist-rc-style.h"

#define YTHICKNESS(style) (style->ythickness)
#define XTHICKNESS(style) (style->xthickness)

G_DEFINE_DYNAMIC_TYPE (MistStyle, mist_style, GTK_TYPE_STYLE)

static void mist_style_init       (MistStyle      *style);
static void mist_style_class_init (MistStyleClass *klass);

void
mist_style_register_types (GTypeModule *module)
{
	mist_style_register_type (module);
}

static GtkShadowType
mist_get_shadow_type (GtkStyle *style, const char *detail, GtkShadowType requested)
{
	GtkShadowType retval = GTK_SHADOW_NONE;
	
	if (requested != GTK_SHADOW_NONE) {
		retval = GTK_SHADOW_ETCHED_IN;
	}
	
	if (CHECK_DETAIL(detail, "dockitem")
	    || CHECK_DETAIL(detail, "handlebox_bin")) {
		retval = GTK_SHADOW_NONE;
	} else if (CHECK_DETAIL(detail, "spinbutton_up")
		   || CHECK_DETAIL(detail, "spinbutton_down")) {
		retval = GTK_SHADOW_OUT;
	} else if (CHECK_DETAIL(detail, "button") 
		   || CHECK_DETAIL(detail, "togglebutton") 
		   || CHECK_DETAIL(detail, "notebook") 
		   || CHECK_DETAIL(detail, "optionmenu")) {
		retval = requested;
	} else if (CHECK_DETAIL(detail, "menu")) {
		retval = GTK_SHADOW_ETCHED_IN;
	}
	
	return retval;
}

static void
mist_dot (cairo_t *cr,
	  CairoColor *color1,
	  CairoColor *color2,
	  int x,
	  int y)
{
	ge_cairo_set_color (cr, color1);
	cairo_rectangle (cr, x + 1, y + 1, 1, 1);
	cairo_rectangle (cr, x + 1, y, 1, 1);
	cairo_rectangle (cr, x, y + 1, 1, 1);
	cairo_fill (cr);

	ge_cairo_set_color (cr, color2);
	cairo_rectangle (cr, x - 1, y - 1, 1, 1);
	cairo_rectangle (cr, x - 1, y, 1, 1);
	cairo_rectangle (cr, x, y - 1, 1, 1);
	cairo_fill (cr);
}

static void
mist_draw_border (GtkStyle *style,
		       cairo_t *cr,
		       GtkStateType state_type,
		       GtkShadowType shadow_type,
		       int x, 
		       int y, 
		       int width, 
		       int height)
{
	MistStyle *mist_style = MIST_STYLE (style);

	CairoColor color1;
	CairoColor color2;
	
	g_return_if_fail(shadow_type != GTK_SHADOW_NONE);
	
	switch (shadow_type) {
	case GTK_SHADOW_ETCHED_IN :
	case GTK_SHADOW_ETCHED_OUT :
		color1 = mist_style->color_cube.dark[state_type];
		color2 = mist_style->color_cube.dark[state_type];
		break;
	case GTK_SHADOW_OUT :
		color1 = mist_style->color_cube.light[state_type];
		color2 = mist_style->color_cube.dark[state_type];
		break;
	case GTK_SHADOW_IN :
		color1 = mist_style->color_cube.dark[state_type];
		color2 = mist_style->color_cube.light[state_type];
		break;
	case GTK_SHADOW_NONE :
	default :
		color1 = mist_style->color_cube.bg[state_type];
		color2 = mist_style->color_cube.bg[state_type];
		
	}
	
	ge_cairo_simple_border (cr, &color1, &color2, x, y, width, height, FALSE); 
}

static void
mist_style_draw_hline(GtkStyle *style,
           GdkWindow *window,
           GtkStateType state_type,
           GdkRectangle *area,
           GtkWidget *widget,
           const char *detail,
           int x1,
           int x2,
           int y)
{
	MistStyle *mist_style = MIST_STYLE (style);

	int thickness_light;
	int thickness_dark;
	int i;
	cairo_t *cr;

	CHECK_ARGS
	
	cr = ge_gdk_drawable_to_cairo (window, area);

	if (CHECK_DETAIL(detail, "hseparator") 
	    || CHECK_DETAIL(detail, "menuitem") 
	    || CHECK_DETAIL(detail, "slider")
	    || CHECK_DETAIL(detail, "vscale")) 
	{
		ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);	

		cairo_move_to (cr, x1 + 0.5, y + 0.5);
		cairo_line_to (cr, x2 - 0.5, y + 0.5);
		cairo_stroke (cr);
	} else {
		thickness_light = YTHICKNESS(style) / 2;
		thickness_dark = YTHICKNESS(style) - thickness_light;
		
		for (i = 0; i < thickness_dark; i++) {
			ge_cairo_set_color(cr, &mist_style->color_cube.light[state_type]);	
	
			cairo_move_to (cr, x2 - i - 0.5, y + i + 0.5);
			cairo_line_to (cr, x2 + 0.5, y + i + 0.5);
			cairo_stroke (cr);

			ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);	
	
			cairo_move_to (cr, x1 + 0.5, y + i + 0.5);
			cairo_line_to (cr, x2 - i - 0.5, y + i + 0.5);
			cairo_stroke (cr);
		}
		
		y += thickness_dark;
		for (i = 0; i < thickness_light; i++) {
			ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);	
	
			cairo_move_to (cr, x1 + 0.5, y + i + 0.5);
			cairo_line_to (cr, x1 + thickness_light - i - 0.5, y + i + 0.5);
			cairo_stroke (cr);

			ge_cairo_set_color(cr, &mist_style->color_cube.light[state_type]);	
	
			cairo_move_to (cr, x1 + thickness_light - i - 0.5, y + i + 0.5);
			cairo_line_to (cr, x2 + 0.5, y + i + 0.5);
			cairo_stroke (cr);
		}
	}
	
	cairo_destroy(cr);
}

static void
mist_style_draw_vline(GtkStyle *style,
           GdkWindow *window,
           GtkStateType state_type,
           GdkRectangle *area,
           GtkWidget *widget,
           const char *detail,
           int y1,
           int y2,
           int x)
{
	MistStyle *mist_style = MIST_STYLE (style);

	int thickness_light;
	int thickness_dark;
	int i;
	cairo_t *cr;

	CHECK_ARGS
	
	cr = ge_gdk_drawable_to_cairo (window, area);
	
	if (CHECK_DETAIL(detail, "vseparator") 
	    || CHECK_DETAIL(detail, "toolbar") 
	    || CHECK_DETAIL(detail, "slider") 
	    || CHECK_DETAIL(detail, "hscale")) 
	{
		ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);	

		cairo_move_to (cr, x + 0.5, y1 + 0.5);
		cairo_line_to (cr, x + 0.5, y2 - 0.5);
		cairo_stroke (cr);
	} else {
		thickness_light = XTHICKNESS(style) / 2;
		thickness_dark = XTHICKNESS(style) - thickness_light;
		
		for (i = 0; i < thickness_dark; i++) {
			ge_cairo_set_color(cr, &mist_style->color_cube.light[state_type]);	
	
			cairo_move_to (cr, x + i + 0.5, y2 - i - 0.5);
			cairo_line_to (cr, x + i + 0.5, y2 + 0.5);
			cairo_stroke (cr);

			ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);	
	
			cairo_move_to (cr, x + i + 0.5, y1 + 0.5);
			cairo_line_to (cr, x + i + 0.5, y2 - i - 0.5);
			cairo_stroke (cr);
		}
		
		x += thickness_dark;
		for (i = 0; i < thickness_light; i++) {
			ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);	
	
			cairo_move_to (cr, x + i + 0.5, y1 + 0.5);
			cairo_line_to (cr, x + i + 0.5, y1 + thickness_light - i - 0.5);
			cairo_stroke (cr);

			ge_cairo_set_color(cr, &mist_style->color_cube.light[state_type]);	
	
			cairo_move_to (cr, x + i + 0.5, y1 + thickness_light - i - 0.5);
			cairo_line_to (cr, x + i + 0.5, y2 - 0.5);
			cairo_stroke (cr);
		}
	}
	
	cairo_destroy(cr);
}

static void
mist_style_draw_shadow(GtkStyle *style,
	    GdkWindow *window,
	    GtkStateType state_type,
	    GtkShadowType shadow_type,
	    GdkRectangle *area,
	    GtkWidget *widget,
	    const char *detail,
	    int x,
	    int y,
	    int width,
	    int height)
{
	MistStyle *mist_style = MIST_STYLE (style);
	cairo_t *cr;

	CHECK_ARGS	
	SANITIZE_SIZE

	shadow_type = mist_get_shadow_type (style, detail, shadow_type);

	if (shadow_type == GTK_SHADOW_NONE)
		return;

	cr = ge_gdk_drawable_to_cairo (window, area);

	if (state_type == GTK_STATE_INSENSITIVE) {
		shadow_type = GTK_SHADOW_ETCHED_IN;
	}
	
	if (CHECK_DETAIL(detail, "frame") && widget && widget->parent && GE_IS_STATUSBAR (widget->parent)) {
		ge_cairo_set_color(cr, &mist_style->color_cube.dark[GTK_STATE_NORMAL]);	

		cairo_move_to (cr, x + 0.5, y + 0.5);
		cairo_line_to (cr, x + width - 0.5, y + 0.5);
		cairo_stroke (cr);
	} else {
		mist_draw_border (style, cr, state_type,
				       shadow_type,x, y, width, height);
	}

	cairo_destroy(cr);
}

static void
mist_style_draw_polygon(GtkStyle *style,
             GdkWindow *window,
             GtkStateType state_type,
             GtkShadowType shadow_type,
             GdkRectangle *area,
             GtkWidget *widget,
             const char *detail,
             GdkPoint *points,
             int npoints,
             int fill)
{
	MistStyle *mist_style = MIST_STYLE (style);

	static const gdouble pi_over_4 = G_PI_4;
	static const gdouble pi_3_over_4 = G_PI_4 * 3;
	
	CairoColor           *color1;
	CairoColor           *color2;
	CairoColor           *color3;
	CairoColor           *color4;
	gdouble            angle;
	int                xadjust;
	int                yadjust;
	int                i;
	cairo_t           *cr;

	CHECK_ARGS
	g_return_if_fail(points != NULL);
	
	switch (shadow_type) {
	case GTK_SHADOW_IN:
		color1 = &mist_style->color_cube.light[state_type];
		color2 = &mist_style->color_cube.dark[state_type];
		color3 = &mist_style->color_cube.light[state_type];
		color4 = &mist_style->color_cube.dark[state_type];
		break;
	case GTK_SHADOW_ETCHED_IN:
		color1 = &mist_style->color_cube.light[state_type];
		color2 = &mist_style->color_cube.dark[state_type];
		color3 = &mist_style->color_cube.dark[state_type];
		color4 = &mist_style->color_cube.light[state_type];
		break;
	case GTK_SHADOW_OUT:
		color1 = &mist_style->color_cube.dark[state_type];
		color2 = &mist_style->color_cube.light[state_type];
		color3 = &mist_style->color_cube.dark[state_type];
		color4 = &mist_style->color_cube.light[state_type];
		break;
	case GTK_SHADOW_ETCHED_OUT:
		color1 = &mist_style->color_cube.dark[state_type];
		color2 = &mist_style->color_cube.light[state_type];
		color3 = &mist_style->color_cube.light[state_type];
		color4 = &mist_style->color_cube.dark[state_type];
		break;
	default:
		return;
	}

	cr = ge_gdk_drawable_to_cairo (window, area);
	
	if (fill)
		ge_cairo_polygon(cr, &mist_style->color_cube.bg[state_type], points, npoints);
	
	npoints--;
	
	for (i = 0; i < npoints; i++) {
		if ((points[i].x == points[i + 1].x) &&
		    (points[i].y == points[i + 1].y)) {
			angle = 0;
		} else {
			angle = atan2(points[i + 1].y - points[i].y,
				      points[i + 1].x - points[i].x);
		}
		
		if ((angle > -pi_3_over_4) && (angle < pi_over_4)) {
			if (angle > -pi_over_4) {
				xadjust = 0;
				yadjust = 1;
			} else {
				xadjust = 1;
				yadjust = 0;
			}

			ge_cairo_line(cr, color1,
				      points[i].x - xadjust, 
				      points[i].y - yadjust,
				      points[i + 1].x - xadjust, 
				      points[i + 1].y - yadjust);
			ge_cairo_line(cr, color3,
				      points[i].x, points[i].y,
				      points[i + 1].x, points[i + 1].y);
		}
		else {
			if ((angle < -pi_3_over_4) || (angle > pi_3_over_4)) {
				xadjust = 0;
				yadjust = 1;
			} else {
				xadjust = 1;
				yadjust = 0;
			}
			
			ge_cairo_line(cr, color4,
				      points[i].x + xadjust, 
				      points[i].y + yadjust,
				      points[i + 1].x + xadjust, 
				      points[i + 1].y + yadjust);
			ge_cairo_line(cr, color2,
				      points[i].x, points[i].y,
				      points[i + 1].x, points[i + 1].y);
		}
	}

	cairo_destroy(cr);
}

static void
mist_style_draw_diamond(GtkStyle * style,
             GdkWindow * window,
             GtkStateType state_type,
             GtkShadowType shadow_type,
             GdkRectangle * area,
             GtkWidget * widget,
             const char *detail,
             int x,
             int y,
             int width,
             int height)
{
	MistStyle *mist_style = MIST_STYLE (style);

	int half_width;
	int half_height;
	cairo_t *cr;
	
	CHECK_ARGS
	SANITIZE_SIZE
	
	half_width = width / 2;
	half_height = height / 2;

	cr = ge_gdk_drawable_to_cairo (window, area);

	switch (shadow_type) {
	case GTK_SHADOW_IN:
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + 2, y + half_height,
			      x + half_width, y + height - 2);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + half_width, y + height - 2,
			      x + width - 2, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + 1, y + half_height,
			      x + half_width, y + height - 1);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + half_width, y + height - 1,
			      x + width - 1, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x, y + half_height,
			      x + half_width, y + height);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + half_width, y + height,
			      x + width, y + half_height);
		
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + 2, y + half_height,
			      x + half_width, y + 2);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + half_width, y + 2,
			      x + width - 2, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + 1, y + half_height,
			      x + half_width, y + 1);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + half_width, y + 1,
			      x + width - 1, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x, y + half_height,
			      x + half_width, y);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + half_width, y,
			      x + width, y + half_height);
		break;
	case GTK_SHADOW_OUT:
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + 2, y + half_height,
			      x + half_width, y + height - 2);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + half_width, y + height - 2,
			      x + width - 2, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + 1, y + half_height,
			      x + half_width, y + height - 1);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + half_width, y + height - 1,
			      x + width - 1, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x, y + half_height,
			      x + half_width, y + height);
		ge_cairo_line(cr, &mist_style->color_cube.dark[state_type],
			      x + half_width, y + height,
			      x + width, y + half_height);
		
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + 2, y + half_height,
			      x + half_width, y + 2);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + half_width, y + 2,
			      x + width - 2, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + 1, y + half_height,
			      x + half_width, y + 1);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + half_width, y + 1,
			      x + width - 1, y + half_height);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x, y + half_height,
			      x + half_width, y);
		ge_cairo_line(cr, &mist_style->color_cube.light[state_type],
			      x + half_width, y,
			      x + width, y + half_height);
		break;
	default:
		break;
	}

	cairo_destroy(cr);
}

static void
mist_style_draw_box(GtkStyle *style,
         GdkWindow *window,
         GtkStateType state_type,
         GtkShadowType shadow_type,
         GdkRectangle *area,
         GtkWidget *widget,
         const char *detail,
         int x,
         int y,
         int width,
         int height)
{
	MistStyle *mist_style = MIST_STYLE (style);

	CairoColor *light, *dark;
	cairo_t *cr;
	
	CHECK_ARGS
	SANITIZE_SIZE

	if (CHECK_DETAIL(detail, "menuitem") && state_type == GTK_STATE_PRELIGHT) {
		state_type = GTK_STATE_SELECTED;
	}

	light = &mist_style->color_cube.light[state_type];
	dark = &mist_style->color_cube.dark[state_type];

	cr = ge_gdk_drawable_to_cairo (window, area);
	
	if (CHECK_DETAIL(detail, "optionmenutab")) {
		ge_cairo_line(cr, dark, x - 5, y, x - 5, y + height);
		
		gtk_paint_arrow (style, window, state_type, shadow_type, area, 
				 widget, detail, GTK_ARROW_DOWN, TRUE,
				 x + 1, y + 1, width - 2, height - 2);
	} else if (CHECK_DETAIL(detail, "trough")) {
		ge_cairo_set_color(cr, &mist_style->color_cube.bg[state_type]);	
		cairo_rectangle(cr, x, y, width - 1, height - 1);
		cairo_fill(cr);

		ge_cairo_set_color(cr, dark);	
		ge_cairo_stroke_rectangle(cr, x + 0.5, y + 0.5, width - 1, height - 1);
	} else if (CHECK_DETAIL(detail, "menubar")
		   || CHECK_DETAIL(detail, "dockitem_bin") 
		   || CHECK_DETAIL(detail, "dockitem") 
		   || CHECK_DETAIL(detail, "toolbar") 
		   || CHECK_DETAIL(detail, "handlebox")) {
		if (shadow_type != GTK_SHADOW_NONE) {
			ge_cairo_line (cr, 
				       &mist_style->color_cube.dark[GTK_STATE_NORMAL], 
				       x, y + height - 1, 
				       x + width - 1, y + height - 1);

		}
	} else  if (CHECK_DETAIL(detail, "bar")) {
		if (width > 1 && height > 1) {
			ge_cairo_set_color(cr, &mist_style->color_cube.base[GTK_STATE_SELECTED]);	
			cairo_rectangle(cr, x + 1, y + 1, width - 2, height - 2);
			cairo_fill(cr);
		}
	

		ge_cairo_simple_border (cr, 
			   &mist_style->color_cube.dark[GTK_STATE_SELECTED],
			   &mist_style->color_cube.dark[GTK_STATE_SELECTED],
			   x, y, width, height, 
			   FALSE); 

	} else if (CHECK_DETAIL(detail, "buttondefault")) {
		ge_cairo_set_color(cr, &mist_style->color_cube.fg[GTK_STATE_NORMAL]);	
		ge_cairo_stroke_rectangle(cr, x + 0.5, y + 0.5, width - 1, height - 1);
	} else {
		/* Make sure stepper and slider outlines "overlap" - taken from
		 * bluecurve */
		if (CHECK_DETAIL(detail, "slider") && widget && GE_IS_RANGE (widget)) {
			GtkAdjustment *adj = GTK_RANGE (widget)->adjustment;
			if (adj->value <= adj->lower &&
			    (GTK_RANGE (widget)->has_stepper_a ||
			     GTK_RANGE (widget)->has_stepper_b)) {
				if (GE_IS_VSCROLLBAR (widget)) {
					height += 1;
					if (!gtk_range_get_inverted (GTK_RANGE (widget)))
						y -= 1;
				} else if (GE_IS_HSCROLLBAR (widget)) {
					width += 1;
					if (!gtk_range_get_inverted (GTK_RANGE (widget)))
						x -= 1;
				}
			}
			
			if (adj->value >= adj->upper - adj->page_size &&
			    (GTK_RANGE (widget)->has_stepper_c ||
			     GTK_RANGE (widget)->has_stepper_d)) {
				if (GE_IS_VSCROLLBAR (widget)) {
					height += 1;
					if (gtk_range_get_inverted (GTK_RANGE (widget)))
						y -= 1;
				} else if (GE_IS_HSCROLLBAR (widget)) {
					width += 1;
					if (gtk_range_get_inverted (GTK_RANGE (widget)))
						x -= 1;
				}
			}
		}
		
		gtk_style_apply_default_background(style, window,
						   widget && !GTK_WIDGET_NO_WINDOW(widget),
						   state_type, area,
						   x, y, width, height);

		shadow_type = mist_get_shadow_type (style, detail, shadow_type);
		if (state_type == GTK_STATE_INSENSITIVE && shadow_type != GTK_SHADOW_NONE) {
			shadow_type = GTK_SHADOW_ETCHED_IN;
		}
		if (shadow_type != GTK_SHADOW_NONE) {
			mist_draw_border (style, cr,
					       state_type, 
					       shadow_type,
					       x, y, width, height);
		}
	}

	cairo_destroy(cr);
}

static void
mist_style_draw_check(GtkStyle *style,
           GdkWindow *window,
           GtkStateType state_type,
           GtkShadowType shadow_type,
           GdkRectangle *area,
           GtkWidget *widget,
           const char *detail,
           int x,
           int y,
           int width,
           int height)
{
	MistStyle *mist_style = MIST_STYLE (style);
	cairo_t *cr;

	SANITIZE_SIZE

	cr = ge_gdk_drawable_to_cairo (window, area);

	ge_cairo_set_color(cr, &mist_style->color_cube.base[state_type == GTK_STATE_INSENSITIVE ? GTK_STATE_INSENSITIVE : GTK_STATE_NORMAL ]);	
	cairo_rectangle(cr, x + 1, y + 1, width - 3, height - 3);
	cairo_fill(cr);

	ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);	
	ge_cairo_stroke_rectangle(cr, x + 0.5, y + 0.5, width - 2, height - 2);
	
	if (shadow_type == GTK_SHADOW_IN) {
		if (state_type == GTK_STATE_INSENSITIVE)
			ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);
		else
			ge_cairo_set_color(cr, &mist_style->color_cube.base[GTK_STATE_SELECTED]);
		cairo_rectangle(cr, x + 2, y + 2, width - 5, height - 5);
		cairo_fill(cr);
	} else if (shadow_type == GTK_SHADOW_ETCHED_IN) { /* inconsistent */
#define gray50_width 2
#define gray50_height 2
		GdkBitmap *stipple;
		GdkGC *gc = style->base_gc[GTK_STATE_SELECTED];
		static const char gray50_bits[] = {
			0x02, 0x01
		};

		stipple = gdk_bitmap_create_from_data (window,
						       gray50_bits, 
						       gray50_width,
						       gray50_height);
  
		if (area)
			gdk_gc_set_clip_rectangle (gc, area);

		gdk_gc_set_fill (gc, GDK_STIPPLED);
		gdk_gc_set_stipple (gc, stipple);
		gdk_draw_rectangle(window, gc,
				   TRUE, x + 2, y + 2, width - 5, height - 5);
		gdk_gc_set_fill (gc, GDK_SOLID);

		if (area)
			gdk_gc_set_clip_rectangle (gc, NULL);
#undef gray50_width
#undef gray50_height 
	}

	cairo_destroy(cr);
}

static void
mist_style_draw_option(GtkStyle *style,
            GdkWindow *window,
            GtkStateType state_type,
            GtkShadowType shadow_type,
            GdkRectangle *area,
            GtkWidget *widget,
            const char *detail,
            int x,
            int y,
            int width,
            int height)
{
	MistStyle *mist_style = MIST_STYLE (style);
	cairo_t *cr;

	SANITIZE_SIZE

	cr = ge_gdk_drawable_to_cairo (window, area);

	cairo_arc(cr, x + floor(width/2), y + floor(height/2), floor(width/2) - 0.5, 0 , 2 * G_PI);
	ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type == GTK_STATE_INSENSITIVE ? GTK_STATE_INSENSITIVE : GTK_STATE_NORMAL]);	
	cairo_stroke (cr);
	
	cairo_arc(cr, x + floor(width/2), y + floor(height/2), floor(width/2) - 0.5, 0 , 2 * G_PI);
	ge_cairo_set_color(cr, &mist_style->color_cube.base[state_type == GTK_STATE_INSENSITIVE ? GTK_STATE_INSENSITIVE : GTK_STATE_NORMAL]);	
	cairo_fill (cr);

	cairo_arc(cr, x + floor(width/2), y + floor(height/2), floor(width/2) - 0.5, 0 , 2 * G_PI);
	cairo_set_source_rgba(cr, 0, 0, 0, 0.35); 
	cairo_stroke (cr);

	if (shadow_type == GTK_SHADOW_ETCHED_IN)
	{
		/* inconsistent */
		/* Rough logic, just make  thickness 1/3 height */
		int line_width = ceil((height + 1)/3);

		/* Force Thickness Even */
		line_width -= (line_width % 2);

		cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
		cairo_set_line_width (cr, line_width + ((height % 2)?1:0));

		cairo_move_to(cr, x + line_width - ((height % 2)?0.5:0), y + floor(height/2));
		cairo_line_to(cr, x + width - line_width + ((height % 2)?0.5:0), y + floor(height/2));

		ge_cairo_set_color(cr, &mist_style->color_cube.bg[GTK_STATE_SELECTED]);	
		cairo_stroke (cr);
	}
	else if (shadow_type == GTK_SHADOW_IN)
	{
		/* checked */
		if (state_type == GTK_STATE_INSENSITIVE)
			ge_cairo_set_color(cr, &mist_style->color_cube.dark[state_type]);
		else
			ge_cairo_set_color(cr, &mist_style->color_cube.base[GTK_STATE_SELECTED]);
		cairo_arc(cr, x + floor(width/2), y + floor(height/2), floor((width - 7)/2) + 1, 0 , 2 * G_PI);
		cairo_fill (cr);
	}

	cairo_destroy(cr);
}

static void
mist_style_draw_shadow_gap(GtkStyle *style,
                GdkWindow *window,
                GtkStateType state_type,
                GtkShadowType shadow_type,
                GdkRectangle *area,
                GtkWidget *widget,
                const char *detail,
                int x,
                int y,
                int width,
                int height,
                GtkPositionType gap_side,
                int gap_x,
                int gap_width)
{
	MistStyle *mist_style = MIST_STYLE (style);

	CairoColor *color1 = NULL;
	CairoColor *color2 = NULL;
	cairo_t *cr;
	gint start;
	
	g_return_if_fail (window != NULL);
	
	SANITIZE_SIZE
	shadow_type = mist_get_shadow_type (style, detail, shadow_type);
	
	cr = ge_gdk_drawable_to_cairo (window, area);

	switch (shadow_type) {
	case GTK_SHADOW_NONE:
		/* need to destroy the cairo context. */
		cairo_destroy (cr);
		return;
	case GTK_SHADOW_IN:
		color1 = &mist_style->color_cube.dark[state_type];
		color2 = &mist_style->color_cube.light[state_type];
		break;
	case GTK_SHADOW_OUT:
		color1 = &mist_style->color_cube.light[state_type];
		color2 = &mist_style->color_cube.dark[state_type];
		break;
	case GTK_SHADOW_ETCHED_IN:
	case GTK_SHADOW_ETCHED_OUT:
		color1 = &mist_style->color_cube.dark[state_type];
		color2 = &mist_style->color_cube.dark[state_type];
	}
	
	cairo_set_fill_rule (cr, CAIRO_FILL_RULE_EVEN_ODD);
	cairo_rectangle (cr, x, y, width, height);
	
	switch (gap_side) {
        case GTK_POS_TOP:
        	start = MAX (1, gap_x + 1);
        	cairo_rectangle (cr, x + start, y, MIN(width-1, gap_x+gap_width - 1) - start, 1);
		break;
        case GTK_POS_BOTTOM:
        	start = MAX (1, gap_x + 1);
        	cairo_rectangle (cr, x + start, y + height - 1, MIN(width-1, gap_x+gap_width - 1) - start, 1);
		break;
        case GTK_POS_LEFT:
        	start = MAX (1, gap_x + 1);
        	cairo_rectangle (cr, x, y + start, 1, MIN(width-1, gap_x+gap_width - 1) - start);
		break;
        case GTK_POS_RIGHT:
        	start = MAX (1, gap_x + 1);
        	cairo_rectangle (cr, x + width - 1, y + start, 1, MIN(width-1, gap_x+gap_width - 1) - start);
        	break;
	}
	cairo_clip (cr);
	cairo_new_path (cr);
	ge_cairo_simple_border (cr, color1, color2, x, y, width, height, FALSE);
	
	cairo_destroy(cr);
}

static void
mist_style_draw_box_gap(GtkStyle *style,
	     GdkWindow *window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle *area,
	     GtkWidget *widget,
	     const char *detail,
	     int x,
	     int y,
	     int width,
	     int height,
	     GtkPositionType gap_side,
	     int gap_x,
	     int gap_width)
{
	SANITIZE_SIZE

	gtk_style_apply_default_background(style, window,
					   widget && !GTK_WIDGET_NO_WINDOW(widget),
					   state_type, area,
					   x, y, width, height);

	mist_style_draw_shadow_gap (style, window, state_type, shadow_type,
			 area, widget, detail, x, y, width, height, 
			 gap_side, gap_x, gap_width);
}

static void
mist_style_draw_extension(GtkStyle *style,
               GdkWindow *window,
               GtkStateType state_type,
               GtkShadowType shadow_type,
               GdkRectangle *area,
               GtkWidget *widget,
               const char *detail,
               int x,
               int y,
               int width,
               int height,
               GtkPositionType gap_side)
{
	cairo_t *canvas;
	CairoColor *background, *light, *dark;

	CHECK_ARGS
	SANITIZE_SIZE


	background = &MIST_STYLE(style)->color_cube.bg[state_type];
	light = &MIST_STYLE(style)->color_cube.light[state_type];
	dark = &MIST_STYLE(style)->color_cube.dark[state_type];
	
	canvas = ge_gdk_drawable_to_cairo (window, area);

	if ((!style->bg_pixmap[state_type]) || GDK_IS_PIXMAP(window)) 
	{
		ge_cairo_set_color(canvas, background);	

		cairo_rectangle(canvas, x, y, width, height);
		cairo_fill(canvas);
	} else {
		gtk_style_apply_default_background
			(style, window,
			 widget && !GTK_WIDGET_NO_WINDOW(widget),
			 state_type, area, x, y, width, height);
	}
	
	cairo_rectangle (canvas, x, y, width, height);
	cairo_clip (canvas);
	
	switch(gap_side) {
	case GTK_POS_BOTTOM:
		height++;
		break;
	case GTK_POS_TOP:
		y--;
		height++;
		break;
	case GTK_POS_RIGHT:
		width++;
		break;
	case GTK_POS_LEFT:
		x--;
		width++;
		break;
	}

	ge_cairo_simple_border (canvas, light, dark, x, y, width, height, FALSE);
	cairo_destroy(canvas);
}

static void
mist_style_draw_handle(GtkStyle *style,
            GdkWindow *window,
            GtkStateType state_type,
            GtkShadowType shadow_type,
            GdkRectangle *area,
            GtkWidget *widget,
            const char *detail,
            int x,
            int y,
            int width,
            int height,
            GtkOrientation orientation)
{
	MistStyle *mist_style = MIST_STYLE (style);

	CairoColor *light, *dark;
	GdkRectangle dest;
	int modx, mody;
	cairo_t *cr;
	
	CHECK_ARGS
	SANITIZE_SIZE

	if (!ge_is_panel_widget_item (widget) && !ge_object_is_a ((GObject*)widget, "PanelToplevel"))
		gtk_paint_box(style, window, state_type, shadow_type, area, widget,
			      detail, x, y, width, height);
	
	light = &mist_style->color_cube.light[state_type];
	dark = &mist_style->color_cube.dark[state_type];
	
	orientation = GTK_ORIENTATION_HORIZONTAL;
	if (height > width)
		orientation = GTK_ORIENTATION_VERTICAL;
	
	x += XTHICKNESS(style);
	y += YTHICKNESS(style);
	dest.x = x;
	dest.y = y;
	dest.width = width - (XTHICKNESS(style) * 2);
	dest.height = height - (YTHICKNESS(style) * 2);
	
	if (orientation == GTK_ORIENTATION_HORIZONTAL) { 
		modx = 4; mody = 0; 
	} else { 
		modx = 0; mody = 4;
	}
	
	cr = ge_gdk_drawable_to_cairo (window, &dest);

	mist_dot(cr,
		 light, dark,
		 x + width / 2 - modx,
		 y + height / 2 - mody);
	mist_dot(cr,
		 light, dark,
		 x + width / 2,
		 y + height / 2);
	mist_dot(cr,
		 light, dark,
		 x + width / 2 + modx,
		 y + height / 2 + mody);
	
	cairo_destroy(cr);
}

static void
mist_style_draw_resize_grip(GtkStyle *style,
		 GdkWindow *window,
		 GtkStateType state_type,
		 GdkRectangle *area,
		 GtkWidget *widget,
		 const char *detail,
		 GdkWindowEdge edge,
		 int x,
		 int y,
		 int width,
		 int height)
{
	MistStyle *mist_style = MIST_STYLE (style);

	CairoColor *light, *dark;
	int xi, yi;
	int max_x, max_y;
	int threshold;
	cairo_t *cr;
	
	CHECK_ARGS
	SANITIZE_SIZE
	
	switch (edge) {
	case GDK_WINDOW_EDGE_NORTH_WEST:
		/* make it square */
		if (width < height) {
			height = width;
		}
		else if (height < width) {
			width = height;
		}
		break;
	case GDK_WINDOW_EDGE_NORTH:
		if (width < height) {
			height = width;
		}
		break;
	case GDK_WINDOW_EDGE_NORTH_EAST:
		/* make it square, aligning to top right */
		if (width < height) {
			height = width;
		} else if (height < width) {
			x += (width - height);
			width = height;
		}
		break;
	case GDK_WINDOW_EDGE_WEST:
		if (height < width) {
			width = height;
		}
		break;
	case GDK_WINDOW_EDGE_EAST:
		/* aligning to right */
		if (height < width) {
			x += (width - height);
			width = height;
		}
		break;
	case GDK_WINDOW_EDGE_SOUTH_WEST:
		/* make it square, aligning to bottom left */
		if (width < height) {
			y += (height - width);
			height = width;
		} else if (height < width) {
			width = height;
		}
		break;
	case GDK_WINDOW_EDGE_SOUTH:
		/* align to bottom */
		if (width < height) {
			y += (height - width);
			height = width;
		}
		break;
	case GDK_WINDOW_EDGE_SOUTH_EAST:
		/* make it square, aligning to bottom right */
		if (width < height) {
			y += (height - width);
			height = width;
		} else if (height < width) {
			x += (width - height);
			width = height;
		}
		break;
	default:
		g_assert_not_reached ();
	}
	
	gtk_style_apply_default_background (style, window, FALSE,
					    state_type, area,
					    x, y, width, height);

	light = &mist_style->color_cube.light[state_type];
	dark = &mist_style->color_cube.dark[state_type];

	max_x = (width - 2) / 5;
	max_y = (height - 2) / 5;
	
	threshold = max_x;
	
	cr = ge_gdk_drawable_to_cairo (window, area);

	for (xi = 0; xi <= max_x; xi++) {
		for (yi = 0; yi <= max_y; yi++) {
			gboolean draw_dot;
			
			switch (edge) {
			case GDK_WINDOW_EDGE_NORTH:
			case GDK_WINDOW_EDGE_WEST:
			case GDK_WINDOW_EDGE_EAST:
			case GDK_WINDOW_EDGE_SOUTH:
				draw_dot = TRUE;
				break;
			case GDK_WINDOW_EDGE_NORTH_WEST:
				draw_dot = (xi + yi <= threshold);
				break;
			case GDK_WINDOW_EDGE_NORTH_EAST:
				draw_dot = (xi >= yi);
				break;
			case GDK_WINDOW_EDGE_SOUTH_WEST:
				draw_dot = (xi <= yi);
				break;
			case GDK_WINDOW_EDGE_SOUTH_EAST:
				draw_dot = (xi + yi >= threshold);
				break;
			default:
				g_assert_not_reached ();
			}
			
			if (draw_dot) {
				mist_dot(cr,
					 light, dark,
					 x + (xi * 5) + 1,
					 y + (yi * 5) + 1);
			}
		}
	}

	cairo_destroy(cr);
}

#ifdef GTK_DISABLE_DEPRECATED
#ifdef GDK_DISABLE_DEPRECATED
#define DISABLE_CUSTOM_STRING_DRAWING 1
#warning Disabling custom string drawing so that no deprecated API is used.
#endif /* GDK_DISABLE_DEPRECATED */
#endif /* GTK_DISABLE_DEPRECATED */

#ifndef DISABLE_CUSTOM_STRING_DRAWING
static void
mist_style_draw_string (GtkStyle      *style,
	     GdkWindow     *window,
	     GtkStateType   state_type,
	     GdkRectangle  *area,
	     GtkWidget     *widget,
	     const char    *detail,
	     int            x,
	     int            y,
	     const char    *string)
{
	CHECK_ARGS
	
	if (area) {
		gdk_gc_set_clip_rectangle (style->fg_gc[state_type], area);
	}	
	
	gdk_draw_string (window,
			 gtk_style_get_font (style),
			 style->fg_gc[state_type], x, y, string);
	
	if (area) {
		gdk_gc_set_clip_rectangle (style->fg_gc[state_type], NULL);
	}
}
#endif /* DISABLE_CUSTOM_STRING_DRAWING */


static void
mist_style_draw_layout (GtkStyle        *style,
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
	
	CHECK_ARGS
	
	gc = use_text ? style->text_gc[state_type] : style->fg_gc[state_type];
	
	if (area) {
		gdk_gc_set_clip_rectangle (gc, area);
	}
	
	gdk_draw_layout (window, gc, x, y, layout);
	
	if (area) {
		gdk_gc_set_clip_rectangle (gc, NULL);
	}
}

static GdkPixbuf *
set_transparency (const GdkPixbuf *pixbuf, gdouble alpha_percent)
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
              int width,
              int height)
{
	if (width == gdk_pixbuf_get_width (src) &&
	    height == gdk_pixbuf_get_height (src)) {
		return g_object_ref (src);
	} else {
		return gdk_pixbuf_scale_simple (src,
						width, height,
						GDK_INTERP_BILINEAR);
	}
}

static GdkPixbuf *
mist_style_render_icon (GtkStyle            *style,
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
		GTK_NOTE (MULTIHEAD,
			  g_warning ("Using the default screen for gtk_default_render_icon()"));
	}
	
  
	if (size != (GtkIconSize) -1 && !gtk_icon_size_lookup_for_settings (settings, size, &width, &height)) {
		g_warning (G_STRLOC ": invalid icon size '%d'", size);
		return NULL;
	}

	/* If the size was wildcarded, and we're allowed to scale, then scale; otherwise,
	 * leave it alone.
	 */
	if (size != (GtkIconSize)-1 && gtk_icon_source_get_size_wildcarded (source))
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
	}
	else
		stated = scaled;
  
  return stated;
}

static void
mist_style_draw_focus (GtkStyle *style,
		       GdkWindow *window,
		       GtkStateType state_type,
		       GdkRectangle *area,
		       GtkWidget *widget,
		       const gchar *detail,
		       gint x,
		       gint y,
		       gint width,
		       gint height)
{
	MistStyle *mist_style = MIST_STYLE (style);
	CairoColor *dark;
	cairo_t *cr;

	CHECK_ARGS
	SANITIZE_SIZE

	cr = ge_gdk_drawable_to_cairo (window, area);
	cairo_translate (cr, 0.5, 0.5);
	width--; height--;

	dark = &mist_style->color_cube.dark[state_type];
	ge_cairo_set_color (cr, dark);
	cairo_rectangle (cr, x, y, width, height);
	cairo_stroke (cr);
	cairo_destroy (cr);
}

static void
mist_style_init (MistStyle *style)
{
}

static void
mist_style_realize (GtkStyle * style)
{
  MistStyle *mist_style = MIST_STYLE (style);
 
  GTK_STYLE_CLASS (mist_style_parent_class)->realize (style);
 
  ge_gtk_style_to_cairo_color_cube (style, &mist_style->color_cube);
}

static void
mist_style_class_init (MistStyleClass *klass)
{
	GtkStyleClass *style_class = GTK_STYLE_CLASS (klass);
	
	style_class->realize = mist_style_realize;

	style_class->draw_hline = mist_style_draw_hline;
	style_class->draw_vline = mist_style_draw_vline;
	style_class->draw_shadow = mist_style_draw_shadow;
	style_class->draw_polygon = mist_style_draw_polygon;
	style_class->draw_diamond = mist_style_draw_diamond;
	style_class->draw_box = mist_style_draw_box;
	style_class->draw_tab = mist_style_draw_box;
	style_class->draw_check = mist_style_draw_check;
	style_class->draw_option = mist_style_draw_option;
	style_class->draw_shadow_gap = mist_style_draw_shadow_gap;
	style_class->draw_box_gap = mist_style_draw_box_gap;
	style_class->draw_extension = mist_style_draw_extension;
	style_class->draw_handle = mist_style_draw_handle;
	style_class->draw_resize_grip = mist_style_draw_resize_grip;
#ifndef DISABLE_CUSTOM_STRING_DRAWING
	style_class->draw_string = mist_style_draw_string;
#endif
	style_class->draw_layout = mist_style_draw_layout;
	style_class->render_icon = mist_style_render_icon;
	style_class->draw_focus = mist_style_draw_focus;
}

static void
mist_style_class_finalize (MistStyleClass *klass)
{
}
