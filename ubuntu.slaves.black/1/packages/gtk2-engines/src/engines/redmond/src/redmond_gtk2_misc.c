/* Redmond95 - a cairo based GTK+ engine
 * Copyright (C) 2001 Red Hat, Inc.
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
 *
 * Written by Owen Taylor <otaylor@redhat.com>
 * modified by Andrew Johnson <ajgenius@ajgenius.us>
 * modified by Benjamin Berg <benjamin@sipsolutions.net>
 *
 */


#include "redmond_gtk2_engine.h"
#include "redmond_gtk2_drawing.h"
#include "redmond_gtk2_misc.h"
 
void
do_redmond_draw_masked_fill (cairo_t * cr,
                                  CairoPattern *mask,
                                  CairoColor * background,
                                  CairoColor * foreground,
                                  gint x,
                                  gint y, 
                                  gint width, 
                                  gint height)
{
	ge_cairo_set_color(cr, background);
	cairo_rectangle (cr, x, y, width, height);
	cairo_fill(cr);

	ge_cairo_set_color(cr, foreground);
	cairo_save (cr);
	cairo_rectangle (cr, x, y, width, height);
	cairo_clip (cr);
	cairo_mask (cr, mask->handle);
	cairo_restore (cr);
}
  
/***********************************************
 * do_redmond_draw_check -
 *  
 *   A simple routine to draw a redmond style
 *   check mark using the passed Color.
 *  
 *   It originated in Smooth-Engine.
 ***********************************************/
void
do_redmond_draw_check (cairo_t *canvas,
                       CairoColor * color,
                       gint x, 
                       gint y, 
                       gint width, 
                       gint height)
{ 
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
 
/***********************************************
 * do_redmond_draw_arrow -
 *  
 *   A simple routine to draw a redmond style
 *   arrow using the passed GC.
 *  
 *   Taken in part from smooth, it was based on 
 *   XFCE's & CleanIce draw arrow routines, 
 *   both which  were based on ThinIce's.
 ***********************************************/
void
do_redmond_draw_arrow (cairo_t *canvas,
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
 
void
do_redmond_draw_simple_circle (cairo_t *canvas,
                     	  		CairoColor * tl,
                       			CairoColor * br,
					gint center_x, 
					gint center_y, 
					gint radius)
{ 
      cairo_save(canvas);

      cairo_move_to(canvas, center_x + (radius + 2), center_y + (radius + 2));
      cairo_line_to(canvas, center_x + (radius + 2)*sin(G_PI/4.0), center_y - (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x - (radius + 2)*sin(G_PI/4.0), center_y + (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x + (radius + 2), center_y + (radius + 2));

      cairo_clip (canvas);

      ge_cairo_set_color(canvas, br);
      cairo_arc(canvas, center_x, center_y, radius, 0,  2*G_PI);
      cairo_fill(canvas);

      cairo_restore(canvas);

      cairo_save(canvas);

      cairo_move_to(canvas, center_x - (radius + 2), center_y - (radius + 2));
      cairo_line_to(canvas, center_x + (radius + 2)*sin(G_PI/4.0), center_y - (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x - (radius + 2)*sin(G_PI/4.0), center_y + (radius + 2)*cos(G_PI/4.0));
      cairo_line_to(canvas, center_x - (radius + 2), center_y - (radius + 2));

      cairo_clip (canvas);

      ge_cairo_set_color(canvas, tl); 
      cairo_arc(canvas, center_x, center_y, radius, 0, 2*G_PI);
      cairo_fill(canvas);

      cairo_restore(canvas);
}

/***********************************************
 * do_redmond_draw_line -
 *  
 *   A simple routine to draw a redmond style
 *   spacer line.
 ***********************************************/
void
do_redmond_draw_line(cairo_t *cr,
             CairoColor * dark,
             CairoColor * light,
             GdkRectangle * area,
             gint start,
             gint end,
             gint base,
             gboolean horizontal)
{  
  cairo_set_line_width (cr, 1);

  if (horizontal) 
    {
      ge_cairo_set_color(cr, dark);	
      cairo_move_to(cr, start + 1.5, base + 0.5);
      cairo_line_to(cr, end - 1.5, base + 0.5);
      cairo_stroke(cr);

      ge_cairo_set_color(cr, light);	
      cairo_move_to(cr, start + 1.5, base + 1.5);
      cairo_line_to(cr, end - 1.5, base + 1.5);
      cairo_stroke(cr);
    } 
  else 
    {
      ge_cairo_set_color(cr, dark);	
      cairo_move_to(cr, base + 0.5, start + 1.5);
      cairo_line_to(cr, base + 0.5, end - 1.5);
      cairo_stroke(cr);

      ge_cairo_set_color(cr, light);	
      cairo_move_to(cr, base + 1.5, start + 1.5);
      cairo_line_to(cr, base + 1.5, end - 1.5);
      cairo_stroke(cr);
    }
}
 
/***********************************************/
/* MenuShell/MenuBar Item Prelight Workaround  */
/***********************************************/
 
/***********************************************
 * redmond_gtk2_engine_hack_menu_shell_style_set -
 *  
 *   Style set signal to ensure menushell signals
 *   get cleaned up if the theme changes
 ***********************************************/
static gboolean 
redmond_gtk2_engine_hack_menu_shell_style_set(GtkWidget *widget,
                         GtkStyle *previous_style,
                         gpointer user_data)
{
  redmond_gtk2_engine_hack_menu_shell_cleanup_signals(widget);
  
  return FALSE;
}
 
/***********************************************
 * redmond_gtk2_engine_hack_menu_shell_destroy -
 *  
 *   Destroy signal to ensure menushell signals
 *   get cleaned if it is destroyed
 ***********************************************/
static gboolean    
redmond_gtk2_engine_hack_menu_shell_destroy(GtkWidget *widget,
                       GdkEvent *event,
                       gpointer user_data)
{
  redmond_gtk2_engine_hack_menu_shell_cleanup_signals(widget);
  
  return FALSE;
}
 
/***********************************************
 * redmond_gtk2_engine_hack_menu_shell_motion -
 *  
 *   Motion signal to ensure menushell items
 *   prelight state changes on mouse move.
 ***********************************************/
static gboolean 
redmond_gtk2_engine_hack_menu_shell_motion(GtkWidget *widget, 
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
 * redmond_gtk2_engine_hack_menu_shell_leave -
 *  
 *   Leave signal to ensure menushell items
 *   normal state on mouse leave.
 ***********************************************/
static gboolean 
redmond_gtk2_engine_hack_menu_shell_leave(GtkWidget *widget, 
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
 * redmond_gtk2_engine_menu_shell_setup_signals -
 *  
 *   Setup Menu Shell with signals to ensure
 *   prelight works on items
 ***********************************************/
void
redmond_gtk2_engine_hack_menu_shell_setup_signals(GtkWidget *widget)
{
  if (GE_IS_MENU_BAR(widget))
    {
      gint id = 0;
 
      if (!g_object_get_data(G_OBJECT(widget), "REDMOND_MENU_SHELL_HACK_SET"))
      {
        id = g_signal_connect(G_OBJECT(widget), "motion-notify-event",
                                             (GCallback)redmond_gtk2_engine_hack_menu_shell_motion,
                                             NULL);
                                  
        g_object_set_data(G_OBJECT(widget), "REDMOND_MENU_SHELL_MOTION_ID", (gpointer)id);
        
        id = g_signal_connect(G_OBJECT(widget), "leave-notify-event",
                                             (GCallback)redmond_gtk2_engine_hack_menu_shell_leave,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "REDMOND_MENU_SHELL_LEAVE_ID", (gpointer)id);
                                             
        id = g_signal_connect(G_OBJECT(widget), "destroy-event",
                                             (GCallback)redmond_gtk2_engine_hack_menu_shell_destroy,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "REDMOND_MENU_SHELL_DESTROY_ID", (gpointer)id);
 
        g_object_set_data(G_OBJECT(widget), "REDMOND_MENU_SHELL_HACK_SET", (gpointer)1);
        
        id = g_signal_connect(G_OBJECT(widget), "style-set",
                                             (GCallback)redmond_gtk2_engine_hack_menu_shell_style_set,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "REDMOND_MENU_SHELL_STYLE_SET_ID", (gpointer)id);
      }
    }  
}
 
/***********************************************
 * redmond_gtk2_engine_hack_menu_shell_cleanuo_signals -
 *  
 *   Cleanup/remove Menu Shell signals
 ***********************************************/
void
redmond_gtk2_engine_hack_menu_shell_cleanup_signals(GtkWidget *widget)
{
  if (GE_IS_MENU_BAR(widget))
    {
      gint id = 0;
 
      id = (gint)g_object_steal_data (G_OBJECT(widget), "REDMOND_MENU_SHELL_MOTION_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
                                             
      id = (gint)g_object_steal_data (G_OBJECT(widget), "REDMOND_MENU_SHELL_LEAVE_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
     
      id = (gint)g_object_steal_data (G_OBJECT(widget), "REDMOND_MENU_SHELL_DESTROY_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
       
      id = (gint)g_object_steal_data (G_OBJECT(widget), "REDMOND_MENU_SHELL_STYLE_SET_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
       
      g_object_steal_data (G_OBJECT(widget), "REDMOND_MENU_SHELL_HACK_SET");      
    }
}
