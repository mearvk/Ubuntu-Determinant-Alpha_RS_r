/* Glide - a cairo based GTK+ engine
 * Copyright (C) 2006 Andrew Johnson <acjgenius@earthlink.net>
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
 */


#include <string.h>
#include "glide_gtk2_engine.h"
#include "glide_gtk2_support.h"
#include "glide_gtk2_drawing.h"

/***********************************************
 * glide_draw_vline -
 *  
 *   the Function used to draw horizontal spacers.
 ***********************************************/
void
glide_draw_hline (GtkStyle * style,
	    GdkWindow * window,
	    GtkStateType state_type,
	    GdkRectangle * area,
	    GtkWidget * widget,
	    const gchar * detail, 
            gint x1,
            gint x2, 
            gint y)
{
  GlideStyle *glide_style = GLIDE_STYLE (style);
  cairo_t *canvas;

  CHECK_ARGS
 
  canvas = ge_gdk_drawable_to_cairo (window, area);

  do_glide_draw_line(canvas, 
                       &glide_style->color_cube.dark[state_type], 
                       &glide_style->color_cube.light[state_type], 
                       area, 
                       x1, x2, y, 
                       TRUE);

  cairo_destroy(canvas);
}
 
/***********************************************
 * glide_draw_vline -
 *  
 *   the Function used to draw vertical spacers.
 ***********************************************/
void
glide_draw_vline (GtkStyle * style,
	    GdkWindow * window,
	    GtkStateType state_type,
	    GdkRectangle * area,
	    GtkWidget * widget,
	    const gchar * detail, 
            gint y1, 
            gint y2, 
            gint x)
{
  GlideStyle *glide_style = GLIDE_STYLE (style);
  cairo_t *canvas;

  if (ge_is_combo_box(widget, FALSE) && (!ge_is_combo_box_entry(widget)))
    return;
 
  CHECK_ARGS
 
  canvas = ge_gdk_drawable_to_cairo (window, area);

  do_glide_draw_line(canvas, 
                       &glide_style->color_cube.dark[state_type], 
                       &glide_style->color_cube.light[state_type], 
                       area, 
                       y1, y2, x, 
                       FALSE);

  cairo_destroy(canvas);
}
  
/***********************************************
 * glide_draw_check -
 *  
 *   the Function used to draw all check boxes.
 ***********************************************/
void
glide_draw_check (GtkStyle * style,
	    GdkWindow * window,
	    GtkStateType state,
	    GtkShadowType shadow,
	    GdkRectangle * area,
	    GtkWidget * widget,
	    const gchar * detail, 
            gint x, 
            gint y, 
            gint width, 
            gint height)
{
	GlideStyle *glide_style = GLIDE_STYLE (style);
	cairo_t *canvas;
	gboolean inconsistent;

	CHECK_ARGS
	SANITIZE_SIZE

	if (GE_IS_CHECK_MENU_ITEM(widget)) 
	{
		x -= 1;
		y -= 1;
		width += 2;
		height += 2;
	} 
	else if (GE_IS_CELL_RENDERER_TOGGLE(widget) || CHECK_DETAIL(detail, "cellcheck"))
	{
		x -= 1;
		y -= 1;
		width += 2;
		height += 2;
	}

 
	canvas = ge_gdk_drawable_to_cairo (window, area);

	ge_cairo_set_color(canvas, &glide_style->color_cube.base[state]);

	cairo_rectangle(canvas, x, y, width - 1, height - 1);

	cairo_fill(canvas);

	inconsistent = shadow == GTK_SHADOW_ETCHED_IN;

	if ((shadow == GTK_SHADOW_IN) || (inconsistent))
	{
		if (inconsistent)
		{
			gdouble radius = (MIN(width, height)/2) - 2;
			gdouble line_width = (radius/2.0);

			cairo_set_line_cap(canvas, CAIRO_LINE_CAP_SQUARE);
			cairo_set_line_width (canvas, floor(line_width));

			cairo_move_to(canvas, x + floor(width/2 - radius + line_width), y + floor(height/2.0));
			cairo_line_to(canvas, x + ceil(width/2 + radius - line_width), y + floor(height/2.0));

			if (state==GTK_STATE_INSENSITIVE)
			{
				ge_cairo_set_color(canvas, &glide_style->color_cube.dark[state]);	
			}
			else
			{
				ge_cairo_set_color(canvas, &glide_style->color_cube.text[state]);	
			}

			cairo_stroke (canvas);
		}
		else
		{
			if (state==GTK_STATE_INSENSITIVE)
			{
				do_glide_draw_check (canvas, &glide_style->color_cube.dark[state],
								x + 2, y + 2, width - 4, height - 4);
			}
			else
			{
				do_glide_draw_check (canvas, &glide_style->color_cube.text[state],
								x + 2, y + 2, width - 4, height - 4);
			}
		}
	}
 
	if (state!=GTK_STATE_PRELIGHT)
		state = GTK_STATE_NORMAL;
	
	do_glide_draw_border(canvas, &glide_style->color_cube.bg[state],
				GLIDE_BEVEL_STYLE_SMOOTHER, GLIDE_BORDER_TYPE_IN,
				x, y, width, height);


	cairo_destroy(canvas);
}
 
/***********************************************
 * glide_draw_option -
 *  
 *   the Function used to draw all Option boxes
 ***********************************************/
void
glide_draw_option (GtkStyle * style,
	     GdkWindow * window,
	     GtkStateType state,
	     GtkShadowType shadow,
	     GdkRectangle * area,
	     GtkWidget * widget,
	     const gchar * detail, 
             gint x,
             gint y, 
             gint width, 
             gint height)
{
	GlideCheckState check_state;

	GlideStyle *glide_style;
 
	CairoColor *base;
	CairoColor *fill_color;
	CairoColor *check_color; 

	GlideBevelStyle bevel_style;
	GlideBorderType border_type;

	cairo_t *canvas;

	/***********************************************/
	/* GTK Sanity Checks                           */
	/***********************************************/
	CHECK_ARGS
	SANITIZE_SIZE 


	/***********************************************/
	/* GTK Special Cases - adjust Size/Offset      */
	/***********************************************/
	if (GE_IS_CELL_RENDERER_TOGGLE(widget) || CHECK_DETAIL(detail, "cellradio"))
        {
		x -= 1;
		y -= 1;
		width += 2;
		height += 2;
	}

	switch (shadow)
	{
	case GTK_SHADOW_ETCHED_IN:
		check_state = GLIDE_CHECK_INCONSISTENT;
		break;
	case GTK_SHADOW_IN:
		check_state = GLIDE_CHECK_ON;
		break;
	case GTK_SHADOW_OUT:
		check_state = GLIDE_CHECK_OFF;
		break;
	default:
		g_return_if_reached ();
	}

	/***********************************************/
	/* Appearance                                  */
	/***********************************************/


		/***********************************************/
		/* Colors                                      */
		/***********************************************/
		glide_style = GLIDE_STYLE (style);
 
		base = &glide_style->color_cube.bg[state];
		fill_color = &glide_style->color_cube.base[state];
		check_color = &glide_style->color_cube.text[state]; 

		if (state == GTK_STATE_INSENSITIVE)
		{
			check_color = &glide_style->color_cube.dark[state];	
		}


		/***********************************************/
		/* Style                                       */
		/***********************************************/
		bevel_style = GLIDE_BEVEL_STYLE_SMOOTHER;
		border_type = GLIDE_BORDER_TYPE_IN;

	/***********************************************/
	/* Draw Option                                 */
	/***********************************************/
	canvas = ge_gdk_drawable_to_cairo (window, area);

	do_glide_draw_round_option(canvas, base, fill_color, check_color, 
					bevel_style, border_type, check_state,
					x, y, width, height);

	cairo_destroy(canvas);
}
 
/***********************************************
 * glide_draw_arrow -
 *  
 *   the Function used to draw all arrows
 *  
 *   Glide Arrows have 2 looks, Normal 
 *   & Insensitive 
 ***********************************************/
void
glide_draw_arrow (GtkStyle * style,
	    GdkWindow * window,
	    GtkStateType state,
	    GtkShadowType shadow,
	    GdkRectangle * area,
	    GtkWidget * widget,
	    const gchar * detail,
	    GtkArrowType arrow_type,
	    gboolean fill, 
            gint x, 
            gint y, 
            gint width, 
            gint height)
{
	gboolean button_in;
	gint child_offset_x, child_offset_y;

	GlideStyle *glide_style;

	cairo_t *canvas;

	/***********************************************/
	/* GTK Sanity Checks                           */
	/***********************************************/
	CHECK_ARGS
	SANITIZE_SIZE

	/***********************************************/
	/* GTK Arrow Special Cases - adjust Size/Offset*/
	/***********************************************/
	button_in = (shadow == GTK_SHADOW_IN);
	child_offset_x = child_offset_y = 1;
 
	if ((ge_is_combo_box(widget, FALSE) 
			&& !ge_is_combo_box_entry(widget))
		|| (CHECK_DETAIL (detail, "spinbutton")))
	{
		return;
 	}

	if ((CHECK_DETAIL (detail, "vscrollbar"))
		|| (CHECK_DETAIL (detail, "hscrollbar"))
		|| GE_IS_SCROLLBAR(widget))
	{
		if (arrow_type == GTK_ARROW_LEFT)
		{
			x -= 1;
		}

		if (arrow_type == GTK_ARROW_UP)
		{
			y -= 1;
		}

		width += 1;
		height += 1;

		if (button_in)
		{
			/* Arrows offset down/right on button press */
			x += child_offset_x;
			y += child_offset_y;
		}
	}


	if (CHECK_DETAIL (detail, "spinbutton_arrow"))
	{
		x += 2;
		y += 2;
		width -= 4;
		height -= 4;

		if (button_in)
		{
			/* Arrows offset down/right on button press */
			x += child_offset_x;
			y += child_offset_y;
		}
	}

	if (ge_is_in_combo_box (widget))
	{
		if (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_RTL)
		{
			x += 2;
		}

		/* Glide prefers to have smaller arrows relative too size
		* for ComboBox/ComboBoxEntry, because its cleaner,
		* even though it seems slightly inconsistant.
		*/
		y += 1;
		width -= 2;
		height -= 2;

		if (button_in)
		{
			/* Arrows offset down/right on button press */
			x += child_offset_x;
			y += child_offset_y;
		}
	}

	if (CHECK_DETAIL(detail, "menuitem"))
	{
		x -= 1;
	}

	if (CHECK_DETAIL (detail, "arrow"))
	{
		x += (width%2)?0:1;
	}

	/***********************************************/
	/* Draw Arrow                                  */
	/***********************************************/
	glide_style = GLIDE_STYLE (style);

	canvas = ge_gdk_drawable_to_cairo (window, area);

	if (state == GTK_STATE_INSENSITIVE)
	{
		do_glide_draw_arrow (canvas, &glide_style->color_cube.light[state], arrow_type, TRUE, x+1, y+1, width, height);
		do_glide_draw_arrow (canvas, &glide_style->color_cube.dark[state], arrow_type, TRUE, x, y, width, height);
	}
	else
	{
		do_glide_draw_arrow (canvas, &glide_style->color_cube.fg[state], arrow_type, TRUE, x, y, width, height);
	}

	cairo_destroy(canvas);
}
 
/***********************************************
 * glide_draw_shadow -
 *  
 *   Function used to draw the Shadow/Border
 *   for most widgets/widget parts.
 *  
 *   The Glide Shadow is primarily constructed
 *   with an outside border of light/extra_dark
 *   and an internal border of bg/dark.
 ***********************************************/
void
glide_draw_shadow (GtkStyle * style,
	     GdkWindow * window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle * area,
	     GtkWidget * widget,
	     const gchar * detail, 
             gint x, 
             gint y, 
             gint width, 
             gint height)
{
	GlideBevelStyle bevel_style;
	GlideBorderType border_type;

	cairo_t *canvas;
 	CairoColor *background;

	CHECK_ARGS
	SANITIZE_SIZE

	/***********************************************/
	/* GTK Special Cases - adjust Size/Type        */
	/***********************************************/
	bevel_style = GLIDE_BEVEL_STYLE_DEFAULT;
	if (CHECK_DETAIL (detail, "buttondefault"))
	{
		return;
	}
 
	if ((CHECK_DETAIL (detail, "entry")) && (widget) && (ge_is_in_combo_box (widget)))
	{	
		GObject *combo_parent = G_OBJECT(ge_find_combo_box_widget_parent(widget));
		GtkWidget *button = g_object_get_data(combo_parent, "button");

		if (GE_IS_WIDGET(button))
		{
			gtk_widget_queue_draw_area(button, button->allocation.x, button->allocation.y, 
							button->allocation.width, button->allocation.height);
		}

		g_object_set_data(combo_parent, "entry", widget);
	}

	if (shadow_type == GTK_SHADOW_IN)
	{
		if (CHECK_DETAIL (detail, "button"))
		{
			state_type = GTK_STATE_NORMAL;
			bevel_style = GLIDE_BEVEL_STYLE_SMOOTH;
		}
       
		if (((CHECK_DETAIL (detail, "entry"))
			|| (CHECK_DETAIL (detail, "frame")))
			&& widget && 
			((GE_IS_SPIN_BUTTON (widget))
				|| (ge_is_in_combo_box (widget))))
		{
			/* The Combo/ComboBoxEntry button and the SpinButton Steppers should apear
			* to be inset into the entry, as opposed to next to it, so we fake it
			* by drawing an extra 2 pixels here to ignore the right(or left)
			* edge, which will be drawn by the buttons.
			*/
 
			width += 4;
			if ((widget) && (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_RTL))
			{
					x -= 4;
			}
		}
	}

	/***********************************************/
	/* Convert Shadow Type To Border Type          */
	/***********************************************/
	switch (shadow_type)
	{
		case GTK_SHADOW_ETCHED_IN:
			border_type = GLIDE_BORDER_TYPE_ETCHED;
		break;

		case GTK_SHADOW_ETCHED_OUT:
			border_type = GLIDE_BORDER_TYPE_ENGRAVED;
		break;

		case GTK_SHADOW_IN:
			border_type = GLIDE_BORDER_TYPE_IN;
		break;

		case GTK_SHADOW_OUT:
			border_type = GLIDE_BORDER_TYPE_OUT;
		break;

		default:
			border_type = GLIDE_BORDER_TYPE_NONE;
		break;
	}

	/***********************************************/
	/* Draw Border                                 */
	/***********************************************/
	canvas = ge_gdk_drawable_to_cairo (window, area);
 	background = &GLIDE_STYLE (style)->color_cube.bg[state_type];

	do_glide_draw_border(canvas, background, bevel_style, border_type, x, y, width, height);

	cairo_destroy(canvas);
}
 
/***********************************************
 * glide_draw_combobox_button-
 *   
 *   Function used to draw the ComboBox button
 *   "inset" into "entry. 
 *
 *   Slightly Evil Hack #1
 ***********************************************/
static void
glide_draw_combobox_button (GtkStyle * style,
		      GdkWindow * window,
		      GtkStateType state_type,
		      GtkShadowType shadow_type,
		      GdkRectangle * area,
		      GtkWidget * widget,
		      const gchar * detail,
		      gint x, 
                      gint y, 
                      gint width, 
                      gint height)
{
		GlideStyle *glide_style = GLIDE_STYLE (style);

  /* The Combo/ComboBoxEntry button should apear to be inset into the entry, 
   * as opposed to next to it, so we fake it by drawing an entry fill
   * then an entry border - but 2 pixels bigger so it overlaps real border
   * and so left( or right) edge doesn't actually get drawn on screen;
   * and THEN draw the button, but essentially 4 pixels smaller.
   */
  GtkStyle * parent_style = style;
  GtkStateType parent_state = state_type;

  gboolean entry_focused = FALSE;
  gint focus_line_width = 0, focus_padding = 0, focus = 0, thick = 2;
  gboolean interior_focus = TRUE;

  g_object_set_data(G_OBJECT(ge_find_combo_box_widget_parent(widget)), "button", widget);

  if (GTK_WIDGET_HAS_FOCUS(widget))
  {
	gtk_widget_style_get (widget, "focus_line_width", &focus_line_width, NULL);
	gtk_widget_style_get (widget, "focus_padding", &focus_padding, NULL);
	gtk_widget_style_get (widget, "interior_focus", &interior_focus, NULL);

	if (!interior_focus)
	{
		focus = -(focus_line_width);
		if (focus == 0)
		{
			focus = -1;
		}
		entry_focused = TRUE;
	}
  }
  else
  {
		GList *child=NULL,*children = gtk_container_get_children (GTK_CONTAINER(widget->parent));

		for (child = children; child; child = child->next)
		{
			if (GE_IS_ENTRY(child->data) && GTK_WIDGET_HAS_FOCUS(child->data))
			{
				gtk_widget_style_get (widget, "focus_line_width", &focus_line_width, NULL);
				gtk_widget_style_get (widget, "focus_padding", &focus_padding, NULL);
				gtk_widget_style_get (widget, "interior_focus", &interior_focus, NULL);

				if (!interior_focus)
				{
					focus = focus_line_width;
					if (focus == 0)
					{
						focus = 1;
					}
					entry_focused = TRUE;
				}
				focus_padding = 0;
			}
		}

		g_list_free(children);
	}

  if ((!(widget)) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
    {
      cairo_t *canvas;

      if (ge_is_combo_box_entry (widget)
          || ge_is_combo_box (widget, TRUE))
        {
          if (!ge_is_combo_box_entry (widget))
            {
              if ((widget->parent))
                {
                  gtk_widget_ensure_style(widget->parent);

                  parent_style = widget->parent->style;
                  parent_state = widget->parent->state;
                }

	      if (parent_state != GTK_STATE_INSENSITIVE)
                parent_state = GTK_STATE_NORMAL;

/*#warning FIXME - gdk_draw_rectangle*/
	      gdk_draw_rectangle (window,
	      	                  parent_style->base_gc[parent_state],
			          TRUE, x - 2, y, width + 2, height);

            }
          else
            glide_draw_flat_box(style, window, parent_state,
			        GTK_SHADOW_NONE, area, widget, "entry_bg", x - 2,
			        y, width + 2, height);
 
	      if (parent_state != GTK_STATE_INSENSITIVE)
                parent_state = GTK_STATE_NORMAL;

          glide_draw_shadow (style, window, parent_state, GTK_SHADOW_IN,
  		            area, widget, "combo_box_entry", x - thick*2 - focus - focus_padding, y + focus - focus_padding, 
				width + thick*2 + focus_padding*2, height - focus*2 + focus_padding*2);
        }
#ifndef GTK_DISABLE_DEPRECATED
      else if (ge_is_combo(widget))
        {
          GtkWidget *entry = widget;

	  if (GE_IS_WIDGET(widget) && GE_IS_WIDGET(widget->parent) && GE_IS_ENTRY(GTK_COMBO (widget->parent)->entry))
            {
               entry = GTK_COMBO (widget->parent)->entry;
               gtk_widget_ensure_style(entry);

               parent_style = entry->style;
               parent_state = entry->state;
             }
          else if (GE_IS_WIDGET(widget->parent))
            {
               entry = widget->parent;
               gtk_widget_ensure_style(entry);

               parent_style = entry->style;
               parent_state = entry->state;
            }
 
            parent_state = GTK_STATE_NORMAL;

          gtk_paint_flat_box (parent_style, window, parent_state,
	 		      GTK_SHADOW_NONE, area, entry, "entry_bg", x - 2,
			      y, width + 2, height);

          {
            GdkRectangle shadow, clip;
          
            shadow.x = x - 2;
            shadow.y = y;
            shadow.width = width + 2;
            shadow.height = height;
          
/*		#warning FIXME - gdk_rectangle_intersect*/
           if (area)
              gdk_rectangle_intersect(area, &shadow, &clip);
            else
              clip = shadow;

            gtk_paint_shadow (parent_style, window, parent_state, GTK_SHADOW_IN,
	 	              &clip, entry, "combo_box_entry", x - thick*2 - focus - focus_padding, y + focus - focus_padding, 
				width + thick*2 + focus_padding*2, height - focus*2 + focus_padding*2);
          }
        }
#else
#warning Disabling GtkCombo support because GTK_DISABLE_DEPRECATED is enabled.
#endif /* GTK_DISABLE_DEPRECATED */
      else
        {
          GtkWidget *parent = widget;
      
          if (widget->parent)
            parent = widget->parent;
        
          if ((parent))
            {
              gtk_widget_ensure_style(parent);

              parent_style = parent->style;
              parent_state = parent->state;
            }

          if (parent_state != GTK_STATE_INSENSITIVE)
            parent_state = GTK_STATE_NORMAL;

          gtk_paint_flat_box (parent_style, window, parent_state,
			      GTK_SHADOW_NONE, area, parent, "entry_bg", x - 2,
			      y, width + 2, height);
          gtk_paint_shadow (parent_style, window, parent_state, GTK_SHADOW_IN,
		   	    area, parent, "combo_box_entry", x - thick*2 - focus - focus_padding, y + focus - focus_padding, 
				width + thick*2 + focus_padding*2, height - focus*2 + focus_padding*2);
        }
 
	canvas = ge_gdk_drawable_to_cairo (window, area);

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x + focus, y + thick + focus,
                             width - thick - focus*2, height - thick*2 - focus*2);

        glide_draw_shadow (style, window, state_type, shadow_type, area,
		          widget, detail, x + focus, y + thick + focus, width - thick - focus*2, height - 2*thick - focus*2);

#if 0
      glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "comboarrow", GTK_ARROW_DOWN, TRUE,  x + focus + 6, y + thick + focus + 5, width - thick - focus*2 - 12, height - 2*thick - focus*2 - 10);
#endif
	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x + focus, y + thick + focus, width - thick - focus*2, height - 2*thick - focus*2);

      cairo_destroy(canvas);

      if (entry_focused)
      {
             glide_draw_focus(style, window, state_type, area, widget, "combo_entry_button", x - 2, y, width + 2, height);
      }
    } 
  else
    {
      cairo_t *canvas;

      focus_padding = -focus_padding;

      if (ge_is_combo_box_entry (widget)
          || ge_is_combo_box (widget, TRUE))
        {
          if (!ge_is_combo_box_entry (widget))
            {
              if ((widget->parent))
                {
                  gtk_widget_ensure_style(widget->parent);

                  parent_style = widget->parent->style;
                  parent_state = widget->parent->state;
                }

              if (parent_state != GTK_STATE_INSENSITIVE)
                parent_state = GTK_STATE_NORMAL;

/*#warning FIXME - gdk_draw_rectangle*/
	      gdk_draw_rectangle (window, parent_style->base_gc[parent_state],
			          TRUE, x + focus - focus_padding, y + focus - focus_padding, 
                                        width + thick*2 - focus + focus_padding*2, height - focus*2 + focus_padding*2);
            }
          else
            {
              if (parent_state != GTK_STATE_INSENSITIVE)
                parent_state = GTK_STATE_NORMAL;

            glide_draw_flat_box (style, window, parent_state,
	  	                GTK_SHADOW_NONE, area, widget, "entry_bg", 
				x + focus - focus_padding, y + focus - focus_padding, 
				width + thick*2 - focus + focus_padding*2, height - focus*2 + focus_padding*2);
	     }

	      if (parent_state != GTK_STATE_INSENSITIVE)
                parent_state = GTK_STATE_NORMAL;

          glide_draw_shadow (style, window, parent_state, GTK_SHADOW_IN,
	  		    area, widget, "combo_box_entry",
                                x + focus - focus_padding, y + focus - focus_padding, 
                                width + thick*2 - focus + focus_padding*2, height - focus*2 + focus_padding*2);
        }
#ifndef GTK_DISABLE_DEPRECATED
      else if (ge_is_combo(widget))
        {
          GtkWidget *entry = widget;

	  if (GE_IS_WIDGET(widget) && GE_IS_WIDGET(widget->parent) && GE_IS_ENTRY(GTK_COMBO (widget->parent)->entry))
            {
               entry = GTK_COMBO (widget->parent)->entry;
               gtk_widget_ensure_style(entry);

               parent_style = entry->style;
               parent_state = entry->state;
             }
          else if (GE_IS_WIDGET(widget->parent))
            {
               entry = widget->parent;
               gtk_widget_ensure_style(entry);

               parent_style = entry->style;
               parent_state = entry->state;
            }
  
           if (parent_state != GTK_STATE_INSENSITIVE)
             parent_state = GTK_STATE_NORMAL;

           gtk_paint_flat_box (parent_style, window, parent_state,
			       GTK_SHADOW_NONE, area, entry, "entry_bg", 
				x + focus - focus_padding, y + focus - focus_padding, 
				width + thick*2 - focus + focus_padding*2, height - focus*2 + focus_padding*2);
           gtk_paint_shadow (parent_style, window, parent_state, GTK_SHADOW_IN,
			     area, entry, "combo_box_entry", 
                                x + focus - focus_padding, y + focus - focus_padding, 
                                width + thick*2 - focus + focus_padding*2, height - focus*2 + focus_padding*2);
        }
#else
#warning Disabling GtkCombo support because GTK_DISABLE_DEPRECATED is enabled.
#endif /* GTK_DISABLE_DEPRECATED */
      else
        {
          GtkWidget *parent = widget;
      
          if (widget->parent)
            parent = widget->parent;
        
          if ((parent))
            {
              gtk_widget_ensure_style(parent);

              parent_style = parent->style;
              parent_state = parent->state;
            }

          if (parent_state != GTK_STATE_INSENSITIVE)
            parent_state = GTK_STATE_NORMAL;

          gtk_paint_flat_box (parent_style, window, parent_state,
			      GTK_SHADOW_NONE, area, parent, "entry_bg", 
				x + focus - focus_padding, y + focus - focus_padding, 
				width + thick*2 - focus + focus_padding*2, height - focus*2 + focus_padding*2);
          gtk_paint_shadow (parent_style, window, parent_state, GTK_SHADOW_IN,
		   	    area, parent, "combo_box_entry", 
                                x + focus - focus_padding, y + focus - focus_padding, 
                                width + thick*2 - focus + focus_padding*2, height - focus*2 + focus_padding*2);
        }
 
	canvas = ge_gdk_drawable_to_cairo (window, area);

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x + thick + focus, y + thick + focus, width - thick - focus*2, height - 2*thick - focus*2);

        glide_draw_shadow (style, window, state_type, shadow_type, area,
		          widget, detail, x + thick + focus, y + thick + focus, width - thick - focus*2, height - 2*thick - focus*2);

#if 0
      glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "comboarrow", GTK_ARROW_DOWN, TRUE,  x + thick + focus + 6, y + thick + focus + 5, width - thick - focus*2 - 12, height - 2*thick - focus*2 - 10);
#endif
	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x + thick + focus, y + thick + focus, width - thick - focus*2, height - 2*thick - focus*2);

	cairo_destroy(canvas);

      if (entry_focused)
      {
             glide_draw_focus(style, window, state_type, area, widget, "combo_entry_button", x, y, width, height);
      }
    }
}
 
/***********************************************
 * glide_draw_spinbutton_stepper-
 *  
 *   Function used to draw the spinbutton 
 *   steppers "inset" into entry.
 *  
 *   Slightly Evil Hack #2
 ***********************************************/
static void
glide_draw_spinbutton_stepper (GtkStyle * style,
			 GdkWindow * window,
			 GtkStateType state_type,
			 GtkShadowType shadow_type,
			 GdkRectangle * area,
			 GtkWidget * widget,
			 const gchar * detail,
			 gint x, 
                         gint y, 
                         gint width, 
                         gint height)
{
		GlideStyle *glide_style = GLIDE_STYLE (style);

  GdkRectangle spin_area;
 
  /* The SpinButton Steppers should apear to be inset into the entry, 
   * as opposed to next to it, so we fake it by drawing en entry fill
   * and then entry border - but 2 pixels bigger so it overlaps real border
   * and so left( or right) edge doesn't actually get drawn on screen -
   * and THEN draw the Stepper. Since we have two steppers this is slightly
   * more complicated because we can only do half for each stepper.
   */
 
  GtkStateType parent_state = widget ? GTK_WIDGET_STATE(widget) : GTK_STATE_NORMAL;
  gboolean entry_focused = FALSE;
  gint focus_line_width = 0, focus_padding = 0, focus = 0, thick = 2;
  gboolean interior_focus = TRUE;
  cairo_t *canvas;

  spin_area.x = x;
  spin_area.y = y;
  spin_area.width = width;
  spin_area.height = height;
 
  if (widget && GTK_WIDGET_HAS_FOCUS(widget))
  {
	gtk_widget_style_get (widget, "focus_line_width", &focus_line_width, NULL);
	gtk_widget_style_get (widget, "focus_padding", &focus_padding, NULL);
	gtk_widget_style_get (widget, "interior_focus", &interior_focus, NULL);

	if (!interior_focus)
	{
		focus = focus_line_width;
		if (focus == 0)
		{
			focus = 1;
		}
		entry_focused = TRUE;
	}
  }

  if (parent_state!= GTK_STATE_INSENSITIVE)
  {
	parent_state = GTK_STATE_NORMAL;
  }

  if ((!(widget)) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
   {
      if (CHECK_DETAIL (detail, "spinbutton_up"))
	{
	  glide_draw_flat_box (style, window, parent_state,
			      GTK_SHADOW_NONE, &spin_area, widget,
			      "entry_bg", 
				x - thick, y + focus, width + thick - focus, height - focus*2);

	  glide_draw_shadow (style, window, parent_state, GTK_SHADOW_IN, &spin_area, widget, detail, 
                                x - thick, y + focus, width + thick - focus, height + thick - focus);

	canvas = ge_gdk_drawable_to_cairo (window, area);

	if (!((width + thick) % 2) && !focus)
	{
		x += 1;
		width -= 1;
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x, y + thick + focus, width - thick - focus, height - thick - focus); 

                                 	
	  glide_draw_shadow (style, window, state_type, shadow_type, area, widget, detail,
                                x, y + thick + focus, width - thick - focus, height - thick - focus);

	if (!widget || (widget->requisition.height / 2) != (widget->requisition.height + 1) / 2)
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_UP, TRUE,
					x + thick/2, y + thick + 1, width - thick*2, height - thick*2 + 1);
	}
	else
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_UP, TRUE,
					x + thick/2, y + thick + 1, width - thick*2, height - thick*2);
	}
	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x, y + thick + focus, width - thick - focus, height - thick - focus);

	cairo_destroy(canvas);

          if (entry_focused)
            {
              glide_draw_focus(style, window, parent_state, area, widget, detail, x - thick, y, width + thick, height + thick);
            }
	}
      else
	{
	  glide_draw_flat_box (style, window, parent_state,
			      GTK_SHADOW_NONE, &spin_area, widget,
			      "entry_bg", x - thick, y, width + thick - focus, height - focus);

	  glide_draw_shadow (style, window, parent_state, GTK_SHADOW_IN, &spin_area, widget, detail,  
			    x - thick, y - thick, width + thick - focus, height + thick - focus);

	canvas = ge_gdk_drawable_to_cairo (window, area);

	if (!((width + thick) % 2) && !focus)
	{
		x += 1;
		width -= 1;
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x, y + thick, width - thick - focus, height - thick*2 - focus);

	  glide_draw_shadow (style, window, state_type, shadow_type, area, widget, detail,
			    x, y , width - thick - focus, height - thick - focus);

	if (!widget || (widget->requisition.height / 2) != (widget->requisition.height + 1) / 2)
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_DOWN, TRUE,
					x + thick/2, y + thick/2 + 1 - focus, width - thick*2, height - thick*2 - 2);
	}
	else
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_DOWN, TRUE,
					x + thick/2, y + thick/2 - focus, width - thick*2, height - thick*2);
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x, y , width - thick - focus, height - thick - focus);
	cairo_destroy(canvas);

          if (entry_focused)
            {
              glide_draw_focus(style, window, parent_state, area, widget, detail, x - thick, y, width + thick, height);
            }
	}
    }
  else
    {
      if (CHECK_DETAIL (detail, "spinbutton_up"))
	{
	  glide_draw_flat_box (style, window, parent_state,
			      GTK_SHADOW_NONE, &spin_area, widget,
			      "entry_bg", x + focus, y + focus, width + thick*2 - focus, height - focus);
	  glide_draw_shadow (style, window, parent_state, GTK_SHADOW_IN, &spin_area, widget, detail, 
				x + focus, y + focus, width + thick*2 - focus, height + thick - focus);

	canvas = ge_gdk_drawable_to_cairo (window, area);

	if (!((width + thick) % 2) && !focus)
	{
		width -= 1;
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x + thick + focus, y + thick + focus, width - thick - focus, height - thick - focus);


	  glide_draw_shadow (style, window, state_type, shadow_type, area, widget, detail, 
				x + thick + focus, y + thick + focus , width - thick - focus, height - thick - focus);

	if ((widget->requisition.height / 2) != (widget->requisition.height + 1) / 2)
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_UP, TRUE,
					x + thick + focus, y + thick - 1 + focus, width - thick, height - thick + 1);
	}
	else
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_UP, TRUE,
					x + thick + focus, y + thick, width - thick, height - thick);
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x + thick + focus, y + thick + focus , width - thick - focus, height - thick - focus);
	cairo_destroy(canvas);
          if (entry_focused)
            {
              glide_draw_focus(style, window, parent_state, area, widget, detail, x, y, width + thick*2, height + thick);
            }
	}
      else
	{
	  glide_draw_flat_box (style, window, parent_state,
			      GTK_SHADOW_NONE, &spin_area, widget,
			      "entry_bg",x + focus, y, width + thick*2 - focus, height - focus);
	  glide_draw_shadow (style, window, parent_state, GTK_SHADOW_IN, &spin_area, widget, detail, 
				x + focus , y - thick, width + thick*2 - focus, height + thick - focus);
	canvas = ge_gdk_drawable_to_cairo (window, area);

	if (!((width + thick) % 2) && !focus)
	{
		width -= 1;
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x + thick + focus, y, width - thick - focus, height - thick - focus);

	  glide_draw_shadow (style, window, state_type, shadow_type, area, widget, detail, 
                                x + thick + focus, y, width - thick - focus, height - thick - focus);


	if ((widget->requisition.height / 2) != (widget->requisition.height + 1) / 2)
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_DOWN, TRUE,
					x + thick + focus, y + 1 - focus, width - thick, height - thick - 2);
	}
	else
	{
		glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "spinbutton_arrow", GTK_ARROW_DOWN, TRUE,
					x + thick + focus, y, width - thick, height - thick);
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x + thick + focus, y, width - thick - focus, height - thick - focus);

	cairo_destroy(canvas);


          if (entry_focused)
            {
              glide_draw_focus(style, window, parent_state, area, widget, detail, x, y - thick, width + thick*2, height + thick);
            }
	}
    }
}
 
/***********************************************
 * glide_draw_box -
 *  
 *   Function used to draw the box portion of 
 *   general widgets (buttons, entries).
 *
 *  In general this is the same as calling
 *  apply background and then draw shadow,
 *  so the bulk of this routine is actually
 *  to handle drawing the peculiarities of
 *  specific widgets which don't follow this 
 *  in glide.
 ***********************************************/
void
glide_draw_box (GtkStyle * style,
	  GdkWindow * window,
	  GtkStateType state_type,
	  GtkShadowType shadow_type,
	  GdkRectangle * area,
	  GtkWidget * widget,
	  const gchar * detail, 
          gint x, 
          gint y, 
          gint width, 
          gint height)
{
  GlideStyle *glide_style = GLIDE_STYLE (style);
  GlideBorderType border_type;
  cairo_t *canvas;
 
  CHECK_ARGS
  SANITIZE_SIZE

  if (GE_IS_MENU_SHELL(widget))
    {
      glide_gtk2_engine_hack_menu_shell_setup(widget);
    }  
 

  if (CHECK_DETAIL (detail, "menuitem"))
    shadow_type = GTK_SHADOW_OUT;
 
	/***********************************************/
	/* Convert Shadow Type To Border Type          */
	/***********************************************/
	switch (shadow_type)
	{
		case GTK_SHADOW_ETCHED_IN:
			border_type = GLIDE_BORDER_TYPE_ETCHED;
		break;

		case GTK_SHADOW_ETCHED_OUT:
			border_type = GLIDE_BORDER_TYPE_ENGRAVED;
		break;

		case GTK_SHADOW_IN:
			border_type = GLIDE_BORDER_TYPE_IN;
		break;

		case GTK_SHADOW_OUT:
			border_type = GLIDE_BORDER_TYPE_OUT;
		break;

		default:
			border_type = GLIDE_BORDER_TYPE_NONE;
		break;
	}

  canvas = ge_gdk_drawable_to_cairo (window, area);

  if ((CHECK_DETAIL (detail, "vscrollbar"))  || (CHECK_DETAIL (detail, "hscrollbar")))
    {
      gboolean vertical = CHECK_DETAIL (detail, "vscrollbar");

      ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[vertical][state_type]), x-1, y-1, width+1, height+1);
 
	do_glide_draw_border(canvas, &glide_style->color_cube.bg[state_type],
				GLIDE_BEVEL_STYLE_SMOOTHER, border_type,
				x, y, width, height);

	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,vertical), x, y, width, height);

    }
  else if (detail && g_str_has_prefix (detail, "trough")) /* accept trough side details */
    {
	if (GE_IS_SCALE (widget)) 
	{
		gint vborder, hborder;
		
		/* calculate h/vborder, minimum width is 6 pixel */
		if GE_IS_HSCALE (widget)
		{
			vborder = MIN(8, (height - 6) / 2);
			hborder = 1;
		}
		else
		{
			vborder = 1;
			hborder = MIN(8, (width - 6) / 2);
		}

		ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, GTK_STATE_NORMAL,
		                      glide_style->bg_solid[GTK_STATE_NORMAL]), x, y, width, height);

		ge_cairo_pattern_fill(canvas, glide_style->bg_solid[GTK_STATE_ACTIVE], 
		                      x+hborder, y+vborder, width-hborder*2, height-vborder*2);

		if (CHECK_DETAIL (detail, "trough-lower"))
			ge_cairo_pattern_fill(canvas, glide_style->bg_gradient[TRUE][GTK_STATE_SELECTED], 
			                      x + hborder, y+vborder, width - hborder*2, height-vborder*2);

		ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, "menuitem",FALSE), 
				      x+hborder, y+vborder, width-hborder*2, height-vborder*2);

		do_glide_draw_border(canvas, &glide_style->color_cube.bg[GTK_STATE_NORMAL],
				     GLIDE_BEVEL_STYLE_SMOOTHER, GLIDE_BORDER_TYPE_IN,
				     x+hborder, y+vborder, width-hborder*2, height-vborder*2);
	} 
	else 
	{
		ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_solid[state_type]), 
						x, y, width, height);

		do_glide_draw_border(canvas, &glide_style->color_cube.bg[GTK_STATE_NORMAL],
					GLIDE_BEVEL_STYLE_DEFAULT, GLIDE_BORDER_TYPE_IN,
					x, y, width, height);
	}
}
  else if ((CHECK_DETAIL (detail, "toolbar"))
	   || (CHECK_DETAIL (detail, "menubar"))
	   || (GE_IS_BONOBO_TOOLBAR (widget))
	   || (CHECK_DETAIL (detail, "dockitem"))
	   || (CHECK_DETAIL (detail, "dockitem_bin"))
	   || (CHECK_DETAIL (detail, "handlebox_bin"))
	   || (CHECK_DETAIL (detail, "handlebox")))
    {
      if (((CHECK_DETAIL (detail, "dockitem_bin")) && 
           (GE_IS_BONOBO_DOCK_ITEM(widget))) || 
          ((widget) && (ge_is_bonobo_dock_item(widget->parent))))
	{	  
	  GList *children = NULL, *child = NULL;
	  GtkWidget *dockitem = widget;
	  gboolean has_grip = FALSE, ltr = TRUE;
	  
	  if ((!GE_IS_BONOBO_DOCK_ITEM(widget)) && (!GE_IS_BOX(widget)))
	    dockitem = widget->parent;
	    
	  has_grip = GE_IS_CONTAINER(dockitem);
	  
	  ltr = (!widget) || (gtk_widget_get_direction (dockitem) == GTK_TEXT_DIR_LTR);
	  
	  if (has_grip)
	  {
            has_grip = FALSE;
            
            children = gtk_container_get_children(GTK_CONTAINER(dockitem));
                          
            for (child = g_list_first(children); child; child = g_list_next(child))
              {
	        if (GE_IS_BONOBO_DOCK_ITEM_GRIP(child->data))
                  has_grip = (GTK_WIDGET_VISIBLE(child->data) && 
                              GTK_WIDGET_REALIZED(child->data) && 
                              GTK_WIDGET(child->data)->allocation.width > 1) &&
                              (GTK_WIDGET(child->data)->allocation.height > 1);
              }	            
 
            if (children)   
  	      g_list_free(children);
          }
          
          if (has_grip)
            {
	      /* bonobo dock items draw the handle bar grip different from
	       * other toolbars - namely it draws the bin the whole size
	       * and then the handle bar on top, which make the edge overlap 
	       * look wrong, especially relative to bonobo toolbars and
	       * gtk handle bars etc. luckily the handle bar size
	       * is fixed at 10, and the orientation can be grabbed
	       * via gobject, so we just make sure the bin is drawn
	       * NEXT to the handle bar, not beneath it
	       */
	       
   	      GtkOrientation tmp = GTK_ORIENTATION_HORIZONTAL;
 
	      if GE_IS_HBOX(dockitem)
	        tmp = GTK_ORIENTATION_VERTICAL;
	      else if (GE_IS_BONOBO_DOCK_ITEM(dockitem))
	        g_object_get (dockitem, "orientation", &tmp, NULL);
 
	      if (tmp == GTK_ORIENTATION_HORIZONTAL)
	        {
	          if (dockitem == widget)
	            {
	              x += 8*ltr;
	              width -= 8;
	            }
	        }
	      else
	        {
	          if (dockitem == widget)
	            {
	              y += 8;
	              height -= 8;
	            }
	        }
	    }    
	}

      ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_solid[state_type]), x, y, width, height);
  
      /* If this is a menu embedded in the gnome-panel, we don't
       *  draw a border since it looks cleaner without one.
       */
      if ((shadow_type != GTK_SHADOW_NONE) && (widget) && (widget->parent) &&
	  ((!((CHECK_DETAIL (detail, "menubar")) && 
	  ge_is_panel_widget_item (widget)))))
        {
	  cairo_save(canvas);
          cairo_rectangle(canvas, x, y, width, height);
          cairo_clip(canvas);


	do_glide_draw_border(canvas, &glide_style->color_cube.bg[state_type],
					GLIDE_BEVEL_STYLE_DEFAULT, GLIDE_BORDER_TYPE_OUT,
					x, y,                                   
					width, 
					height);
          cairo_restore(canvas);
        }
    }
  else if ((CHECK_DETAIL (detail, "menuitem")))
    { 
	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x, y, width, height);

	do_glide_draw_border(canvas, &glide_style->color_cube.bg[state_type],
					GLIDE_BEVEL_STYLE_FLAT, GLIDE_BORDER_TYPE_IN,
					x, y, width, height);

	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x, y, width, height);
    }
  else if ((CHECK_DETAIL (detail, "bar"))
	   && (widget && GE_IS_PROGRESS_BAR (widget)))
    { 
gboolean vertical = TRUE;
			switch (GTK_PROGRESS_BAR(widget)->orientation) 
			{
				case GTK_PROGRESS_LEFT_TO_RIGHT:
				case GTK_PROGRESS_RIGHT_TO_LEFT:
					vertical = FALSE;
				break;
	
				case GTK_PROGRESS_BOTTOM_TO_TOP:
				case GTK_PROGRESS_TOP_TO_BOTTOM:
					vertical = TRUE;
				break;
			}   

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, GTK_STATE_SELECTED, glide_style->bg_gradient[!vertical][GTK_STATE_SELECTED]), x+1, y+1, width-2, height-2);
	do_glide_draw_border(canvas, &glide_style->color_cube.bg[GTK_STATE_SELECTED],
				GLIDE_BEVEL_STYLE_NONE, GLIDE_BORDER_TYPE_OUT,
				x+1, y+1, width-2, height-2);

	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,vertical), x+1, y+1, width-2, height-2);
    }
  else if ((CHECK_DETAIL (detail, "button")) && widget
	   && ge_is_in_combo_box (widget))
    {
      /* ComboBox Buttons are an especially complex case
       * so call our special function for them.
       */
      glide_draw_combobox_button (style, window, state_type, shadow_type, area,
			    widget, detail, x, y, width, height);
    }
  else if ((CHECK_DETAIL (detail, "spinbutton_up"))
	   || (CHECK_DETAIL (detail, "spinbutton_down")))
    {
      /* SpinButton Steppers are an especially complex case
       * so call our special function for them.
       */
      glide_draw_spinbutton_stepper (style, window, state_type, shadow_type, area,
			       widget, detail, x, y, width, height);
    }
  else
    {
      /* default box apearance */
      ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[FALSE][state_type]), x, y, width, height);

      glide_draw_shadow (style, window, state_type, shadow_type, area,
			widget, detail, x, y, width, height);

	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,FALSE), x, y, width, height);
    }

      /* Paint a triangle here instead of in "buttondefault"
         which is drawn _behind_ the current button */
      if ((CHECK_DETAIL (detail, "button")) && widget && GE_WIDGET_HAS_DEFAULT (widget))
        {
          cairo_save(canvas);

          ge_cairo_set_color(canvas, &glide_style->color_cube.bg[GTK_STATE_SELECTED]);
          cairo_move_to(canvas, x+2.5, y+2.5);
          cairo_line_to(canvas, x+11.5, y+2.5);
          cairo_line_to(canvas, x+2.5, y+11.5);
          cairo_line_to(canvas, x+2.5, y+2.5);
	  cairo_fill(canvas);

          cairo_set_line_width (canvas, 1);

          ge_cairo_set_color(canvas, &glide_style->color_cube.dark[state_type]);
	  cairo_move_to(canvas, x + 2.5, y + 12);
	  cairo_line_to(canvas, x + 2.5, y + 2.5);
  	  cairo_line_to(canvas, x + 12, y + 2.5);
	  cairo_stroke(canvas);

          ge_cairo_set_color(canvas, &glide_style->color_cube.light[state_type]);
          cairo_move_to(canvas, x+12, y+2.5);
          cairo_line_to(canvas, x+2.5, y+12);
	  cairo_stroke(canvas);

          cairo_restore(canvas);
        }
 
  if (CHECK_DETAIL(detail, "optionmenu") ||  (CHECK_DETAIL(detail, "button") && 
       (ge_is_combo_box(widget, FALSE)) && !(ge_is_combo_box_entry(widget))))
    {
      GtkRequisition indicator_size;
      GtkBorder indicator_spacing;
      gint vline_x;
 
      if (state_type != GTK_STATE_INSENSITIVE)
        state_type = GTK_STATE_NORMAL;
 
      ge_option_menu_get_props (widget, &indicator_size, &indicator_spacing);
 
      if ((!widget) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_RTL))
	vline_x = x + indicator_size.width + indicator_spacing.left + indicator_spacing.right;
      else
	vline_x = x + width - (indicator_size.width + indicator_spacing.left + 
                               indicator_spacing.right) - style->xthickness;

      do_glide_draw_line(canvas, &glide_style->color_cube.dark[state_type], &glide_style->color_cube.light[state_type], 
                           area, y + style->ythickness + 1, y + height - style->ythickness - 2, 
                           vline_x, FALSE);
 
      if ((widget) && (gtk_widget_get_direction (GTK_WIDGET (widget)) == GTK_TEXT_DIR_RTL))
         x +=  indicator_spacing.right + style->xthickness;
      else
         x += width - indicator_size.width - indicator_spacing.right - style->xthickness;
 
      y += ((height - indicator_size.height) / 2) + 1;
 
      width = indicator_size.width;
      height = indicator_size.height;
 
      glide_draw_arrow (style, window, state_type, shadow_type, area, NULL, "optionmenu", 
	                      GTK_ARROW_DOWN, TRUE,  x,  y,  width,  height);
   }

   cairo_destroy(canvas);
}
 
/* Draw Function For Boxes Traditionally Either Without Borders, 
		or With A Single Pixel Line */

void
glide_draw_flat_box (GtkStyle * style,
	  GdkWindow * window,
	  GtkStateType state_type,
	  GtkShadowType shadow_type,
	  GdkRectangle * area,
	  GtkWidget * widget,
	  const gchar * detail, 
          gint x, 
          gint y, 
          gint width, 
          gint height)
{
	/*#warning FIXME - FINISH draw_flat_box*/
	if (CHECK_DETAIL(detail, "tooltip"))
	{
		GlideStyle *glide_style = GLIDE_STYLE (style);
		cairo_t *canvas;

		CHECK_ARGS
		SANITIZE_SIZE

		canvas = ge_gdk_drawable_to_cairo (window, area);

		ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_solid[state_type]), 
						x, y, width, height);

		do_glide_draw_border(canvas, &glide_style->color_cube.bg[state_type],
					GLIDE_BEVEL_STYLE_FLAT, GLIDE_BORDER_TYPE_IN,
					x, y, width, height);

		cairo_destroy(canvas);
	}
	else
	{
		GtkStyleClass *glide_parent_class;
		glide_parent_class = GTK_STYLE_CLASS (g_type_class_peek_parent (G_OBJECT_GET_CLASS(style)));
		glide_parent_class->draw_flat_box (style, window, state_type, shadow_type, area,
							widget, detail, x, y, width, height);
	}
}

/***********************************************
 * glide_draw_tab -
 *  
 *   Function pretty much only called to draw 
 *   the arrow "tab" in the option menu
 ***********************************************/
void
glide_draw_tab (GtkStyle * style,
	  GdkWindow * window,
	  GtkStateType state,
	  GtkShadowType shadow,
	  GdkRectangle * area,
	  GtkWidget * widget,
	  const gchar * detail, 
          gint x, 
          gint y, 
          gint width, 
          gint height)
{
}
 
/***********************************************
 * glide_draw_slider -
 *  
 *   Function which draws scale/scrollbar slider
 ***********************************************/
void
glide_draw_slider (GtkStyle * style,
	     GdkWindow * window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle * area,
	     GtkWidget * widget,
	     const gchar * detail,
	     gint x,
	     gint y, 
             gint width, 
             gint height, 
             GtkOrientation orientation)
{
	GlideStyle *glide_style = GLIDE_STYLE (style);
	cairo_t *canvas;
 
	CHECK_ARGS
	SANITIZE_SIZE
 
	canvas = ge_gdk_drawable_to_cairo (window, area);

	ge_cairo_pattern_fill(canvas,DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_gradient[orientation == GTK_ORIENTATION_VERTICAL][state_type]), x, y, width, height);

	do_glide_draw_border(canvas, &glide_style->color_cube.bg[state_type],
				(GE_IS_SCROLLBAR(widget))?GLIDE_BEVEL_STYLE_SMOOTHER:GLIDE_BEVEL_STYLE_DEFAULT, GLIDE_BORDER_TYPE_OUT,
				x, y, width, height);

	if (!GE_IS_SCALE(widget))
	{
		do_glide_draw_grip (canvas,
					&glide_style->color_cube.light[state_type],
					&glide_style->color_cube.dark[state_type],
					x, y, width, height, orientation == GTK_ORIENTATION_VERTICAL);

		ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,orientation == GTK_ORIENTATION_VERTICAL), x, y, width, height);
	}
	else
	{
		ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,orientation != GTK_ORIENTATION_VERTICAL), x, y, width, height);
	}

	cairo_destroy(canvas);
}

void
glide_draw_box_gap (GtkStyle * style, 
                 GdkWindow * window, 
		 GtkStateType state_type, 
		 GtkShadowType shadow_type, 
		 GdkRectangle * area, 
		 GtkWidget * widget, 
		 const gchar * detail, 
		 gint x, 
		 gint y, 
		 gint width, 
		 gint height, 
		 GtkPositionType gap_side, 
		 gint gap_pos, 
		 gint gap_size)
{
	GlideStyle *glide_style = GLIDE_STYLE (style);
	cairo_t *canvas;

	CHECK_ARGS
	SANITIZE_SIZE

	canvas = ge_gdk_drawable_to_cairo (window, area);

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, glide_style->bg_solid[state_type]), x, y, width, height);

	glide_draw_shadow_gap (style, window, state_type, shadow_type, area, widget, detail, 
					x, y, width, height, gap_side, gap_pos, gap_size);

	cairo_destroy(canvas);
}
 
void
glide_draw_shadow_gap (GtkStyle * style, 
                 GdkWindow * window, 
		 GtkStateType state_type, 
		 GtkShadowType shadow_type, 
		 GdkRectangle * area, 
		 GtkWidget * widget, 
		 const gchar * detail, 
		 gint x, 
		 gint y, 
		 gint width, 
		 gint height, 
		 GtkPositionType gap_side, 
		 gint gap_pos, 
		 gint gap_size)
{
	GlideSide side;
	GlideBorderType border_type;
	GlideBevelStyle bevel_style;
	cairo_t *canvas;


	/***********************************************/
	/* GTK Sanity Checks                           */
	/***********************************************/
	CHECK_ARGS
	SANITIZE_SIZE 

	if (shadow_type == GTK_SHADOW_NONE)
		return;

	/***********************************************/
	/* GTK Special Cases - adjust Size/Offset      */
	/***********************************************/
	side = GLIDE_SIDE_NONE;

	if (gap_size > 0)
	{
		switch (gap_side)
		{
			case GTK_POS_BOTTOM:
				side = GLIDE_SIDE_BOTTOM;
			break;

			case GTK_POS_TOP:
				side = GLIDE_SIDE_TOP;
			break;

			case GTK_POS_RIGHT:
				side = GLIDE_SIDE_RIGHT;
			break;

			case GTK_POS_LEFT:
				side = GLIDE_SIDE_LEFT;
			break;

			default:
			break;
		}

		switch (side)
		{
			case GLIDE_SIDE_BOTTOM:
				if (((gap_pos + gap_size) != width) && ((gap_pos) != 0))
				{
					gap_pos -= 1;
					gap_size += 1;
				}
			case GLIDE_SIDE_TOP:
				if ((gap_pos + gap_size) == width)
				{
					gap_pos -= 1;
				}

				gap_size += 1;
			break;

			case GLIDE_SIDE_RIGHT:
				if (((gap_pos + gap_size) != height) && ((gap_pos) != 0))
				{
					gap_pos -= 1;
					gap_size += 1;
				}
			case GLIDE_SIDE_LEFT:
				if ((gap_pos + gap_size) == height)
				{
					gap_pos -= 1;
				}

				gap_size += 1;
			break;

			default:
			break;
		}
	
		gap_pos += 1; 
		gap_size -= 2;
	}


	/***********************************************/
	/* Convert Shadow Type To Border Type          */
	/***********************************************/
	switch (shadow_type)
	{
		case GTK_SHADOW_ETCHED_IN:
			border_type = GLIDE_BORDER_TYPE_ETCHED;
		break;

		case GTK_SHADOW_ETCHED_OUT:
			border_type = GLIDE_BORDER_TYPE_ENGRAVED;
		break;

		case GTK_SHADOW_IN:
			border_type = GLIDE_BORDER_TYPE_IN;
		break;

		case GTK_SHADOW_OUT:
			border_type = GLIDE_BORDER_TYPE_OUT;
		break;

		default:
			border_type = GLIDE_BORDER_TYPE_NONE;
		break;
	}


	/***********************************************/
	/* Draw Border                                 */
	/***********************************************/
	bevel_style = GLIDE_BEVEL_STYLE_DEFAULT;

	canvas = ge_gdk_drawable_to_cairo (window, area);

	do_glide_draw_border_with_gap(canvas, 
					&GLIDE_STYLE(style)->color_cube.bg[state_type], 
					bevel_style, border_type, 
					x, y, width, height, 
					side, gap_pos, gap_size);

	cairo_destroy(canvas);
}

/***********************************************
 * glide_draw_extension -
 *  
 *   Function which draws notebook extensions -
 *   aka, tabs.
 *
 *  This routine is so complex mostly because
 *  it tries to draw a faked 1-2 pixel rounded
 *  corner.
 ***********************************************/
void
glide_draw_extension (GtkStyle * style,
		GdkWindow * window,
		GtkStateType state_type,
		GtkShadowType shadow_type,
		GdkRectangle * area,
		GtkWidget * widget,
		const gchar * detail,
		gint x,
		gint y, 
                gint width, 
                gint height, 
                GtkPositionType gap_side)
{
	GlideStyle *glide_style = GLIDE_STYLE (style);

	gint widget_x = 0, widget_y = 0, widget_width = 0, widget_height = 0;

	GdkRectangle clip, shadow;
	CairoPattern *pattern;

	gint gap_pos = 0, gap_shrink = 0;

	GlideSide side;
	GlideBorderType border_type;
	GlideBevelStyle bevel_style;
	cairo_t *canvas;

	CHECK_ARGS
	SANITIZE_SIZE

	shadow.x = x;
	shadow.y = y;
	shadow.width = width;
	shadow.height = height;
 	clip = shadow;

	/* GTK doesn't overlap Extensions and Notebooks,
		but rather a tab is drawn with a "gap" side.

		Instead of long draw cases per gap side,
		call standard draw, but clipped to size,
		and overdraw edge thickness + one on gap side.
 
		To fake the apearance of overlap on edge aligned tabs
		increase clip by one on gap side. */

	if (widget && (GE_IS_NOTEBOOK (widget)))
	{
		widget_x = (widget->allocation.x + GTK_CONTAINER (widget)->border_width);
		widget_y = (widget->allocation.y + GTK_CONTAINER (widget)->border_width);
		widget_width = (widget->allocation.width - 2*GTK_CONTAINER (widget)->border_width);
		widget_height = (widget->allocation.height - 2*GTK_CONTAINER (widget)->border_width);
	}

	pattern = glide_style->bg_solid[state_type];

	if ((widget && GE_IS_NOTEBOOK (widget)) && (state_type==GTK_STATE_NORMAL))
	{ 
		pattern = glide_style->active_tab_gradient[gap_side][state_type];
		gap_pos = 1;
		gap_shrink = 2;
	}

	switch (gap_side)
	{
		case GTK_POS_TOP:
			if (GTK_CHECK_VERSION(2,10,0) || 
				((widget && GE_IS_NOTEBOOK (widget)) && 
				((x==widget_x) || 
				((x + width) == (widget_x + widget_width)))))
			{
				clip.y -= 1;
				clip.height += 2;

				if (!GTK_CHECK_VERSION(2,10,0))
				{
					height -= 1;
				}
			}
			
			y -= 3;
			height += 3;
		break;

		case GTK_POS_LEFT:
			if (GTK_CHECK_VERSION(2,10,0) || 
				((widget && GE_IS_NOTEBOOK (widget)) && 
				((y==widget_y) || 
				((y + height) == (widget_y + widget_height)))))
			{
				clip.x -= 1;
				clip.width += 2;

				if (!GTK_CHECK_VERSION(2,10,0))
				{
					x -= 1;
				}
			}

			x -= 3;
			width += 3;
		break;

		default:
		case GTK_POS_BOTTOM:
			if (GTK_CHECK_VERSION(2,10,0) || 
				((widget && GE_IS_NOTEBOOK (widget)) && 
				((x==widget_x) || 
				((x + width) == (widget_x + widget_width)))))
			{
				clip.height += 1;
				gap_shrink-=2;
			}

			height += 3;
		break;

		case GTK_POS_RIGHT:
			if (GTK_CHECK_VERSION(2,10,0) || 
				((widget && GE_IS_NOTEBOOK (widget)) && 
				((y==widget_y) || 
				((y + height) == (widget_y + widget_height)))))
			{
				clip.width += 1;
				gap_shrink-=2;
			}
			width += 3;
		break;
	}

	/***********************************************/
	/* GTK Special Cases - adjust Size/Offset      */
	/***********************************************/
	side = GLIDE_SIDE_NONE;

	switch (gap_side)
	{
		case GTK_POS_BOTTOM:
			side = GLIDE_SIDE_BOTTOM;
		break;

		case GTK_POS_TOP:
			side = GLIDE_SIDE_TOP;
		break;

		case GTK_POS_RIGHT:
			side = GLIDE_SIDE_RIGHT;
		break;

		case GTK_POS_LEFT:
			side = GLIDE_SIDE_LEFT;
		break;

		default:
		break;
	}

	/***********************************************/
	/* Convert Shadow Type To Border Type          */
	/***********************************************/
	switch (shadow_type)
	{
		case GTK_SHADOW_ETCHED_IN:
			border_type = GLIDE_BORDER_TYPE_ETCHED;
		break;

		case GTK_SHADOW_ETCHED_OUT:
			border_type = GLIDE_BORDER_TYPE_ENGRAVED;
		break;

		case GTK_SHADOW_IN:
			border_type = GLIDE_BORDER_TYPE_IN;
		break;

		case GTK_SHADOW_OUT:
			border_type = GLIDE_BORDER_TYPE_OUT;
		break;

		default:
			border_type = GLIDE_BORDER_TYPE_NONE;
		break;
	}


	/***********************************************/
	/* Draw Border                                 */
	/***********************************************/
	bevel_style = GLIDE_BEVEL_STYLE_DEFAULT;
	canvas = ge_gdk_drawable_to_cairo (window, area);

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, pattern), shadow.x, shadow.y, shadow.width, shadow.height);

	cairo_rectangle(canvas, clip.x, clip.y, clip.width, clip.height);
	cairo_clip(canvas);

	do_glide_draw_border_with_gap(canvas, 
					&GLIDE_STYLE(style)->color_cube.bg[state_type], 
					bevel_style, border_type, 
					x, y, width, height, side, 
					gap_pos, (((side==GLIDE_SIDE_TOP) || (side==GLIDE_SIDE_BOTTOM))?width:height)-gap_shrink);

	cairo_destroy(canvas);

}
 
/***********************************************
 * glide_draw_handle -
 *  
 *   Function which draws Handle box-
 *   aka toolbar drag grip/paned drag grip
 ***********************************************/
void
glide_draw_handle (GtkStyle * style,
	     GdkWindow * window,
	     GtkStateType state_type,
	     GtkShadowType shadow_type,
	     GdkRectangle * area,
	     GtkWidget * widget,
	     const gchar * detail,
	     gint x,
	     gint y, 
             gint width, 
             gint height, 
             GtkOrientation orientation)
{
  GlideStyle *glide_style = GLIDE_STYLE (style);
  cairo_t *canvas;

  CHECK_ARGS
  SANITIZE_SIZE
  
  if (GE_IS_BONOBO_DOCK_ITEM_GRIP(widget) && 
     (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_RTL) && 
      orientation == (GTK_ORIENTATION_HORIZONTAL))
  {
    x = widget->parent->allocation.width - widget->allocation.width;
    y = widget->parent->allocation.height - widget->allocation.height;
    width = widget->allocation.width;
    height = widget->allocation.height;
    
    area = NULL;
  }

      canvas = ge_gdk_drawable_to_cairo (window, area);
 
      if (GE_IS_HANDLE_BOX (widget))
	{
	  /* handle box apears to be broken in that
	   * it doesn't pass the orientation properly,
	   * but always passes as vertical, so we look
	   * it up ourselves.
	   */
	  switch (gtk_handle_box_get_handle_position
		  (GTK_HANDLE_BOX (widget)))
	    {
	    case GTK_POS_LEFT:
	    case GTK_POS_RIGHT:
	      orientation = GTK_ORIENTATION_VERTICAL;
	      break;
 
	    case GTK_POS_TOP:
	    case GTK_POS_BOTTOM:
	      orientation = GTK_ORIENTATION_HORIZONTAL;
	      break;
	    }
	}
      else
	{
	  if ((CHECK_DETAIL (detail, "handlebox")
	       && (!GE_IS_HANDLE_BOX_ITEM (widget))))
	    {
	      /* panel_applet_frame used by the panel is broken,
	       * always passes orientation == horizontal 
	       * since we don't know anything about the panel
	       * here, we just determine orientation by size.
	       *
	       * If this is on a PanelWidget, we also offset the 
	       * actual drag bar by 2 pixels, since we draw
	       * a line next to it instead of drawing a border
	       * around it.
	       */
	      if (width < height)
		{
		  orientation = GTK_ORIENTATION_HORIZONTAL;
		  if (ge_is_panel_widget_item (widget))
		    x += 2;
		}
	      else
		{
		  orientation = GTK_ORIENTATION_VERTICAL;
		  if (ge_is_panel_widget_item (widget))
		    y += 2;
		}
	    }
	}

	ge_cairo_pattern_fill(canvas, DEFAULT_BACKGROUND_PATTERN(glide_style, state_type, (GE_IS_PANED(widget))?glide_style->bg_solid[state_type]: 
				glide_style->bg_gradient[orientation == (GTK_ORIENTATION_VERTICAL)][state_type]), x, y, width, height);

      if (ge_is_panel_widget_item (widget)
	  && (CHECK_DETAIL (detail, "handlebox")
	      && (!GE_IS_HANDLE_BOX_ITEM (widget)))
	  && (!(GE_IS_HANDLE_BOX (widget))))
	{
		/* draw the drag bar */
		if (orientation == GTK_ORIENTATION_VERTICAL)
		{          
			ge_cairo_simple_border (canvas, &glide_style->color_cube.light[state_type],
							&glide_style->color_cube.dark[state_type],
							x + style->xthickness + 1, y + height / 2 - 1,
							width - style->xthickness - 3, 3, FALSE);
		}
		else
		{
			ge_cairo_simple_border (canvas, &glide_style->color_cube.light[state_type],
							&glide_style->color_cube.dark[state_type], x + width / 2 - 1,
							y + style->ythickness + 1, 3,
							height - style->ythickness - 3, FALSE);
		}

		/* If this is on a PanelWidget, we draw a line 
		* next to it instead of drawing a border around it.
		*/
		if (orientation == GTK_ORIENTATION_VERTICAL)
		{
			ge_cairo_line (canvas, &glide_style->color_cube.dark[state_type], x + 1, y + 0,
					x + width - 2, y + 0);
			ge_cairo_line (canvas, &glide_style->color_cube.light[state_type], x + 1,
					y + 1, x + width - 2, y + 1);
		}
		else
		{
			ge_cairo_line (canvas, &glide_style->color_cube.dark[state_type], x + 0, y + 1,
					x + 0, y + height - 2);
			ge_cairo_line (canvas, &glide_style->color_cube.light[state_type], x + 1,
					y + 1, x + 1, y + height - 2);
		}
	}
      else
	{
	  gboolean skip_shadow = FALSE;
 
	do_glide_draw_grip (canvas,
			&glide_style->color_cube.light[GTK_STATE_NORMAL],
			&glide_style->color_cube.dark[GTK_STATE_NORMAL],
			x, y, width, height, orientation == GTK_ORIENTATION_VERTICAL);

          if (GE_IS_BONOBO_DOCK_ITEM_GRIP(widget))
            {
              if GE_IS_BOX(widget->parent)
                {
                  GList *children = NULL, *child = NULL;
 
                  children = gtk_container_get_children(GTK_CONTAINER(widget->parent));
              
                  for (child = g_list_first(children); child; child = g_list_next(child))
                    {
	              if (GE_IS_BOX(child->data))
	                {
	                  skip_shadow = TRUE;
	                  child = NULL;
	                }
                    }	 
                             
                  if (children)   
  	            g_list_free(children);
                }
            }  
          else
		skip_shadow = GE_IS_PANED(widget);

          if (!skip_shadow)
            {
		do_glide_draw_border(canvas, &glide_style->color_cube.bg[state_type],
				GLIDE_BEVEL_STYLE_DEFAULT, GLIDE_BORDER_TYPE_OUT,
				x, y, width, height);
            }
	ge_cairo_pattern_fill(canvas, DEFAULT_OVERLAY_PATTERN(glide_style, detail,orientation == GTK_ORIENTATION_VERTICAL), x, y, width, height);
	}
 
	cairo_destroy(canvas);			          
}

void
glide_draw_focus(GtkStyle *style,
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
	GlideStyle *glide_style = GLIDE_STYLE (style);

	gboolean interior_focus = FALSE;
	gint line_width = 1;

	CHECK_ARGS

	/* Fallback on GTK's Line Pattern */
	if (widget)
	{
		gtk_widget_style_get (widget, "focus-line-width", &line_width, NULL);

		gtk_widget_style_get (widget, "interior_focus", &interior_focus, NULL);
	}


	if (interior_focus)
	{
		GtkStyleClass *glide_parent_class;
		glide_parent_class = GTK_STYLE_CLASS (g_type_class_peek_parent (G_OBJECT_GET_CLASS(style)));
		glide_parent_class->draw_focus(style, window, state_type, area, widget, detail, x, y, width, height);
	}
	else
	{
		cairo_t *canvas = ge_gdk_drawable_to_cairo (window, area);

		ge_cairo_set_color(canvas, &glide_style->color_cube.bg[GTK_STATE_SELECTED]);
		cairo_set_line_width(canvas, line_width);

	 	if (CHECK_DETAIL(detail, "button") && (ge_is_in_combo_box (widget)))
		{
			gint thick = 2;
			GtkWidget *entry;

			if ((!widget) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
			{
				ge_cairo_stroke_rectangle(canvas, x - thick + line_width*2, y + thick, width - line_width*2, height - thick*2);
			}
			else
			{
				ge_cairo_stroke_rectangle(canvas, x + thick, y + thick, width - line_width*2, height - thick*2);
			}

			entry = g_object_get_data(G_OBJECT(ge_find_combo_box_widget_parent (widget)), "entry");
		}
	 	else if (CHECK_DETAIL(detail, "entry") && (GE_IS_SPIN_BUTTON(widget)) )
		{
			if ((!widget) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
			{
				ge_cairo_stroke_rectangle(canvas, x + 0.5, y + 0.5, width + line_width - 1, height - 1);
			}
			else
			{
				ge_cairo_stroke_rectangle(canvas, x - line_width + 0.5, y + 0.5, width + line_width - 1, height - 1);
			}
		}
 		else if (CHECK_DETAIL(detail, "entry") && (ge_is_in_combo_box (widget)))
		{
			GtkWidget *button = g_object_get_data(G_OBJECT(ge_find_combo_box_widget_parent (widget)), "button");

			if (GE_IS_WIDGET(button))
			{
				gtk_widget_queue_draw_area(button, button->allocation.x, button->allocation.y, 
								button->allocation.width, button->allocation.height);
			}

			if ((!widget) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
			{
				ge_cairo_stroke_rectangle(canvas, x + 0.5, y + 0.5, width + line_width - 1, height - 1);
			}
			else
			{
				ge_cairo_stroke_rectangle(canvas, x - line_width + 0.5, y + 0.5, width + line_width - 1, height - 1);
			}
		}
		else if (CHECK_DETAIL(detail, "spinbutton_up"))
		{
			if ((!widget) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
			{
				cairo_rectangle(canvas, x + line_width, y, width - line_width, height);
			}
			else
			{
				cairo_rectangle(canvas, x, y, width - line_width, height);
			}

			cairo_clip(canvas);
			ge_cairo_stroke_rectangle(canvas, x + 0.5, y + 0.5, width - 1, height + line_width - 1);
		} 
	        else if (CHECK_DETAIL(detail, "spinbutton_down"))
		{
			if ((!widget) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
			{
				cairo_rectangle(canvas, x + line_width, y, width - line_width, height);
			}
			else
			{
				cairo_rectangle(canvas, x, y, width - line_width, height);
			}		

			cairo_clip(canvas);
			ge_cairo_stroke_rectangle(canvas, x + 0.5, y - line_width  + 0.5, width - 1, height + line_width - 1);
		} 
	        else if (CHECK_DETAIL(detail, "combo_entry_button"))
		{
			if ((!widget) || (gtk_widget_get_direction (widget) == GTK_TEXT_DIR_LTR))
			{
				cairo_rectangle(canvas, x + line_width, y, width - line_width, height + 1);
				cairo_clip(canvas);

				ge_cairo_stroke_rectangle(canvas, x + 0.5, y + 0.5, width - 1, height - 1);
			}
			else
			{
				cairo_rectangle(canvas, x, y, width, height + 1);
				cairo_clip(canvas);

				ge_cairo_stroke_rectangle(canvas, x+0.5, y+0.5, width + line_width - 1, height - 1);
			}
		}
		else
		{
  			ge_cairo_stroke_rectangle(canvas, x+0.5, y+0.5, width-1, height-1);
		}

		cairo_destroy(canvas);
	}
}

void
glide_draw_layout (GtkStyle        *style,
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
	use_text &= !ge_is_combo_box(widget, FALSE);

/*	#warning FIXME - gdk gdk gdk*/

	gc = use_text ? style->text_gc[state_type] : style->fg_gc[state_type];
	
	if (area) 
	{
		gdk_gc_set_clip_rectangle (gc, area);
	}

	if ((state_type==GTK_STATE_INSENSITIVE) && !use_text)
	{
		gdk_draw_layout_with_colors(window, gc, x+1, y+1, layout, &style->light[state_type], NULL);
		gdk_draw_layout_with_colors(window, gc, x, y, layout, &style->dark[state_type], NULL);	
	}
	else
	{	
		gdk_draw_layout (window, gc, x, y, layout);
	}

	if (area) 
	{
		gdk_gc_set_clip_rectangle (gc, NULL);
	}
}
