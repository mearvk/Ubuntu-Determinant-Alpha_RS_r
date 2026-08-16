/* High Contrast - a cairo based GTK+ engine
 * Copyright (C) 2003 Sun Microsystems Inc.
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


#include "hc_gtk2_engine.h"
#include "hc_gtk2_support.h"
#include "hc_gtk2_drawing.h"

void 
hc_simple_border_gap_clip(cairo_t *canvas,
			  gint border_thickness,

			  gint x,
			  gint y,
			  gint width,
			  gint height,

			  GtkPositionType gap_side,
			  gint gap_pos,
			  gint gap_size)
{
	switch (gap_side)
	{
		default:
		case GTK_POS_TOP:
			cairo_move_to(canvas, x, y);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x + gap_pos + gap_size, y);
			cairo_line_to(canvas, x + gap_pos + gap_size, y + border_thickness + 1);
			cairo_line_to(canvas, x + gap_pos, y + border_thickness + 1);
			cairo_line_to(canvas, x + gap_pos, y);
			cairo_close_path(canvas);
		break;

		case GTK_POS_LEFT:
			cairo_move_to(canvas, x, y);
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + border_thickness + 1, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + border_thickness + 1, y + gap_pos);
			cairo_line_to(canvas, x, y + gap_pos);
			cairo_close_path(canvas);
		break;

		case GTK_POS_BOTTOM:
			cairo_move_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x, y);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x + gap_pos, y + height);
			cairo_line_to(canvas, x + gap_pos, y + height - border_thickness - 1);
			cairo_line_to(canvas, x + gap_pos + gap_size, y + height - border_thickness - 1);
			cairo_line_to(canvas, x + gap_pos + gap_size, y + height);
			cairo_close_path(canvas);
		break;

		case GTK_POS_RIGHT:
			cairo_line_to(canvas, x + width, y);
			cairo_line_to(canvas, x, y);
			cairo_line_to(canvas, x, y + height);
			cairo_line_to(canvas, x + width, y + height);
			cairo_line_to(canvas, x + width, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + width - border_thickness - 1, y + gap_pos + gap_size);
			cairo_line_to(canvas, x + width - border_thickness - 1, y + gap_pos);
			cairo_line_to(canvas, x + width, y + gap_pos);
			cairo_close_path(canvas);
		break;
	}

	cairo_clip(canvas);
}

/***********************************************
 * do_hc_draw_arrow -
 *  
 *   A simple routine to draw a hc style
 *   arrow using the passed Color.
 *  
 *   Taken in part from smooth, it was based on 
 *   XFCE's & CleanIce draw arrow routines, 
 *   both which  were based on ThinIce's.
 ***********************************************/
void
do_hc_draw_arrow (cairo_t *canvas,
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
	cairo_close_path(canvas);

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
 
void do_hc_draw_line (cairo_t *cr,
			CairoColor *color,
			gdouble thickness,
			gdouble x1,
			gdouble y1,
			gdouble x2,
			gdouble y2)
{ 
	cairo_save(cr);

	ge_cairo_set_color(cr, color);	
	cairo_set_line_width (cr, thickness);
	cairo_set_line_cap(cr, CAIRO_LINE_CAP_BUTT);

	cairo_move_to(cr, x1, y1);
	cairo_line_to(cr, x2, y2);

	cairo_stroke(cr);

	cairo_restore(cr);
}
 
void
do_hc_draw_dot (cairo_t *canvas,
			CairoColor * light,
			CairoColor * dark,
			gint x,
			gint y)
{
	ge_cairo_set_color (canvas, dark);
	cairo_rectangle (canvas, x - 1, y - 1, 1, 1);
	cairo_rectangle (canvas, x - 1, y, 1, 1);
	cairo_rectangle (canvas, x, y - 1, 1, 1);
	cairo_fill (canvas);

	ge_cairo_set_color (canvas, light);	
	cairo_rectangle (canvas, x + 1, y + 1, 1, 1);
	cairo_rectangle (canvas, x + 1, y, 1, 1);
	cairo_rectangle (canvas, x, y + 1, 1, 1);
	cairo_fill (canvas);
}

/***********************************************/
/* MenuShell/MenuBar Item Prelight Workaround  */
/***********************************************/
 
/***********************************************
 * hc_gtk2_engine_hack_menu_shell_style_set -
 *  
 *   Style set signal to ensure menushell signals
 *   get cleaned up if the theme changes
 ***********************************************/
static gboolean 
hc_gtk2_engine_hack_menu_shell_style_set(GtkWidget *widget,
                         GtkStyle *previous_style,
                         gpointer user_data)
{
  hc_gtk2_engine_hack_menu_shell_cleanup_signals(widget);
  
  return FALSE;
}
 
/***********************************************
 * hc_gtk2_engine_hack_menu_shell_destroy -
 *  
 *   Destroy signal to ensure menushell signals
 *   get cleaned if it is destroyed
 ***********************************************/
static gboolean    
hc_gtk2_engine_hack_menu_shell_destroy(GtkWidget *widget,
                       GdkEvent *event,
                       gpointer user_data)
{
  hc_gtk2_engine_hack_menu_shell_cleanup_signals(widget);
  
  return FALSE;
}
 
/***********************************************
 * hc_gtk2_engine_hack_menu_shell_motion -
 *  
 *   Motion signal to ensure menushell items
 *   prelight state changes on mouse move.
 ***********************************************/
static gboolean 
hc_gtk2_engine_hack_menu_shell_motion(GtkWidget *widget, 
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
 * hc_gtk2_engine_hack_menu_shell_leave -
 *  
 *   Leave signal to ensure menushell items
 *   normal state on mouse leave.
 ***********************************************/
static gboolean 
hc_gtk2_engine_hack_menu_shell_leave(GtkWidget *widget, 
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
 * hc_gtk2_engine_menu_shell_setup_signals -
 *  
 *   Setup Menu Shell with signals to ensure
 *   prelight works on items
 ***********************************************/
void
hc_gtk2_engine_hack_menu_shell_setup_signals(GtkWidget *widget)
{
  if (GE_IS_MENU_BAR(widget))
    {
      gint id = 0;
 
      if (!g_object_get_data(G_OBJECT(widget), "HC_MENU_SHELL_HACK_SET"))
      {
        id = g_signal_connect(G_OBJECT(widget), "motion-notify-event",
                                             (GCallback)hc_gtk2_engine_hack_menu_shell_motion,
                                             NULL);
                                  
        g_object_set_data(G_OBJECT(widget), "HC_MENU_SHELL_MOTION_ID", (gpointer)id);
        
        id = g_signal_connect(G_OBJECT(widget), "leave-notify-event",
                                             (GCallback)hc_gtk2_engine_hack_menu_shell_leave,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "HC_MENU_SHELL_LEAVE_ID", (gpointer)id);
                                             
        id = g_signal_connect(G_OBJECT(widget), "destroy-event",
                                             (GCallback)hc_gtk2_engine_hack_menu_shell_destroy,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "HC_MENU_SHELL_DESTROY_ID", (gpointer)id);
 
        g_object_set_data(G_OBJECT(widget), "HC_MENU_SHELL_HACK_SET", (gpointer)1);
        
        id = g_signal_connect(G_OBJECT(widget), "style-set",
                                             (GCallback)hc_gtk2_engine_hack_menu_shell_style_set,
                                             NULL);
        g_object_set_data(G_OBJECT(widget), "HC_MENU_SHELL_STYLE_SET_ID", (gpointer)id);
      }
    }  
}
 
/***********************************************
 * hc_gtk2_engine_hack_menu_shell_cleanuo_signals -
 *  
 *   Cleanup/remove Menu Shell signals
 ***********************************************/
void
hc_gtk2_engine_hack_menu_shell_cleanup_signals(GtkWidget *widget)
{
  if (GE_IS_MENU_BAR(widget))
    {
      gint id = 0;
 
      id = (gint)g_object_steal_data (G_OBJECT(widget), "HC_MENU_SHELL_MOTION_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
                                             
      id = (gint)g_object_steal_data (G_OBJECT(widget), "HC_MENU_SHELL_LEAVE_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
     
      id = (gint)g_object_steal_data (G_OBJECT(widget), "HC_MENU_SHELL_DESTROY_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
       
      id = (gint)g_object_steal_data (G_OBJECT(widget), "HC_MENU_SHELL_STYLE_SET_ID");
      g_signal_handler_disconnect(G_OBJECT(widget), id);
       
      g_object_steal_data (G_OBJECT(widget), "HC_MENU_SHELL_HACK_SET");      
    }
}
