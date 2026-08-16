/* LUA - a LUA scriptable GTK+ engine
 * Copyright (C) 2006 Daniel Borgmann <daniel.borgmann@gmail.com>
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


#include <gtk/gtk.h>
#include <cairo.h>
#include <math.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "lua_style.h"
#include "lua_rc_style.h"

#include "lua_utils.h"
#include "misc_utils.h"

/* #define DEBUG 1 */

#define DETAIL(xx)   ((detail) && (!strcmp(xx, detail)))

#define DRAW_ARGS    GtkStyle       *style, \
                     GdkWindow      *window, \
                     GtkStateType    state_type, \
                     GtkShadowType   shadow_type, \
                     GdkRectangle   *area, \
                     GtkWidget      *widget, \
                     const gchar    *detail, \
                     gint            x, \
                     gint            y, \
                     gint            width, \
                     gint            height

G_DEFINE_DYNAMIC_TYPE (LuaStyle, lua_style, GTK_TYPE_STYLE)

static gchar *
get_name_for_state (gint state)
{
	switch (state)
	{
	case GTK_STATE_NORMAL:
		return g_strdup ("NORMAL");
		break;
	case GTK_STATE_SELECTED:
		return g_strdup ("SELECTED");
		break;
	case GTK_STATE_ACTIVE:
		return g_strdup ("ACTIVE");
		break;
	case GTK_STATE_PRELIGHT:
		return g_strdup ("PRELIGHT");
		break;
	case GTK_STATE_INSENSITIVE:
		return g_strdup ("INSENSITIVE");
		break;
	}
	
	g_printf ("Warning: Unknown state: %d\n", state);
	return NULL;
}

static void
push_color (lua_State *L, CairoColor *color)
{
	/* put a color value into a table on top of the stack */
	lua_newtable (L);
	lua_pushnumber (L, 1);
	lua_pushnumber (L, color->r);
	lua_settable (L, -3);
	lua_pushnumber (L, 2);
	lua_pushnumber (L, color->g);
	lua_settable (L, -3);
	lua_pushnumber (L, 3);
	lua_pushnumber (L, color->b);
	lua_settable (L, -3);
	lua_pushnumber (L, 4);
	lua_pushnumber (L, color->a);
	lua_settable (L, -3);
}

static void
lua_style_push_widget_params (LuaStyle *style, GtkWidget *widget, GtkStateType state_type)
{
	g_return_if_fail (style);
	g_return_if_fail (style->L);
	g_return_if_fail (widget);
	
	/* If there is already a table at the top of the stack, re-use it so custom
	 * parameters can be added beforehand.
	 */
	if (!lua_istable (style->L, -1))
		lua_newtable (style->L);
	
	if (widget && GE_IS_ENTRY (widget))
		state_type = GTK_WIDGET_STATE (widget);

	lua_pushstring (style->L, get_name_for_state (state_type));
	lua_setfield (style->L, -2, "state");
	
	lua_pushboolean (style->L, state_type == GTK_STATE_PRELIGHT);
	lua_setfield (style->L, -2, "prelight");
	
	lua_pushboolean (style->L, state_type == GTK_STATE_INSENSITIVE);
	lua_setfield (style->L, -2, "insensitive");
	
	if (widget && GE_IS_TOGGLE_BUTTON (widget))
		lua_pushboolean (style->L, gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (widget)));
	else
		lua_pushboolean (style->L, state_type == GTK_STATE_ACTIVE);
	lua_setfield (style->L, -2, "active");
	
	lua_pushboolean (style->L, widget && GTK_WIDGET_HAS_FOCUS (widget));
	lua_setfield (style->L, -2, "has_focus");
	
	lua_pushnumber (style->L, (int)widget);
	lua_setfield (style->L, -2, "uid");
	
	lua_setglobal (style->L, "widget");
}

static gboolean
lua_style_draw (LuaStyle *style, GtkWidget *widget, GtkStateType state_type,
                gchar *name, gint width, gint height)
{
	g_return_if_fail (style);
	g_return_if_fail (style->L);

	lua_style_push_widget_params (style, widget, state_type);

	lua_pcall (style->L, 0, 0, 0);

    lua_getglobal (style->L, g_strconcat ("draw_", name));
    
    
    if (!lua_isfunction (style->L, -1))
    	return FALSE;
    	
    lua_pushnumber (style->L, width);
    lua_pushnumber (style->L, height);
    
    if (lua_pcall (style->L, 2, 1, 0))
    {
    	g_printf ("%s failed: %s\n", g_strconcat ("draw_", name), lua_tostring (style->L, -1));
    	return FALSE;
    }
    
    return TRUE;
}

static lua_State *
lua_style_prepare_lua (LuaStyle *style)
{
	lua_State *L;
	gchar *themepath;
	gchar *state;
	int i;

	g_return_if_fail (style);
	
	L = lua_open ();
	luaopen_base (L);
	luaopen_math (L);
	luaopen_draw (L);
	
	themepath = misc_utils_locate_theme_path (style->theme);
	if (!themepath)
	{
		g_printf ("Warning: Failed to locate Lua script for '%s'\n", style->theme);
		return L;
	}
	
	if (luaL_loadfile (L, themepath))
		g_printf ("%s\n", lua_tostring(L, -1));
	g_free (themepath);

	/* create global color table */
	lua_newtable (L);

	lua_newtable (L);
	for (i = 0; i < 5; i++)
	{
		state = get_name_for_state (i);
		push_color (L, &style->colors.bg[i]);
		lua_setfield (L, -2, state);
	}
	lua_setfield (L, -2, "bg");
	
	lua_newtable (L);
	for (i = 0; i < 5; i++)
	{
		state = get_name_for_state (i);
		push_color (L, &style->colors.base[i]);
		lua_setfield (L, -2, state);
	}
	lua_setfield (L, -2, "base");
	
	lua_newtable (L);
	for (i = 0; i < 5; i++)
	{
		state = get_name_for_state (i);
		push_color (L, &style->colors.text[i]);
		lua_setfield (L, -2, state);
		g_free (state);
	}
	lua_setfield (L, -2, "text");
	
	lua_setglobal (L, "colors");
    
	return L;
}

static cairo_t *
lua_style_prepare_cairo (LuaStyle *style, GdkWindow *window, GdkRectangle *area, gint x, gint y)
{
	cairo_t *cr;
	g_return_if_fail (style);
	g_return_if_fail (style->L);
	
	cr = gdk_cairo_create (window);
	cairo_set_source_rgb (cr, 0, 0, 0);
	cairo_set_line_width (cr, 1);
	cairo_set_line_cap (cr, CAIRO_LINE_CAP_SQUARE);
	cairo_set_line_join (cr, CAIRO_LINE_JOIN_MITER);
	if (area)
	{
		cairo_rectangle (cr, area->x, area->y, area->width, area->height);
		cairo_clip (cr);
	}
	cairo_translate (cr, x, y);
	lua_utils_push_pointer (style->L, "cairo", cr);
	
	return cr;
}

static void
lua_style_close_cairo (LuaStyle *style)
{
	cairo_t *cr;
	cairo_pattern_t *pattern;
	g_return_if_fail (style);
	g_return_if_fail (style->L);
	
	cr = lua_utils_fetch_pointer (style->L, "cairo");
	pattern = lua_utils_fetch_pointer (style->L, "pattern");
	
	if (pattern)
	{
		cairo_pattern_destroy (pattern);
		lua_utils_push_pointer (style->L, "pattern", NULL);
	}
		
	if (cr)
	{
		cairo_destroy (cr);
		lua_utils_push_pointer (style->L, "cairo", NULL);
	}
}


static void
lua_style_draw_flat_box (DRAW_ARGS)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->draw_flat_box (style, window, state_type,
	                             shadow_type,
	                             area, widget, detail,
	                             x, y, width, height);
}

static void
lua_style_draw_shadow (DRAW_ARGS)
{
	LuaStyle *lua_style = LUA_STYLE (style);
	gboolean processed = FALSE;
	
	lua_style_prepare_cairo (lua_style, window, area, x, y);
	
	if (DETAIL ("entry"))
	{
		if (GE_IS_SPIN_BUTTON (widget))
			processed = lua_style_draw (lua_style, widget, state_type, "spin_button_entry", width, height);
		else if (widget && ge_is_in_combo_box (widget))
		{
			/* force a redraw on the entire combo to handle focus changes */
			void *p = lua_utils_fetch_pointer (lua_style ->L, "in_combo_box_redraw");
			if (widget != p)
			{
				lua_utils_push_pointer (lua_style->L, "in_combo_box_redraw", widget);
				gtk_widget_queue_draw (widget->parent);
			}
			else if (p != NULL)
				lua_utils_push_pointer (lua_style->L, "in_combo_box_redraw", NULL);

			processed = lua_style_draw (lua_style, widget, state_type, "combo_box_entry", width, height);
		}
		
		if (!processed)
			lua_style_draw (lua_style, widget, state_type, "entry", width, height);
	}
	
	lua_style_close_cairo (lua_style);
}

static void 
lua_style_draw_box_gap (DRAW_ARGS,
	                    GtkPositionType gap_side,
	                    gint            gap_x,
	                    gint            gap_width)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->draw_box_gap (style, window, state_type, shadow_type,
	                            area, widget, detail,
	                            x, y, width, height,
	                            gap_side, gap_x, gap_width);
}

static void
lua_style_draw_extension (DRAW_ARGS, GtkPositionType gap_side)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->draw_extension (style, window, state_type, shadow_type, area,
	                              widget, detail, x, y, width, height,
	                              gap_side);
}

static void 
lua_style_draw_handle (DRAW_ARGS, GtkOrientation orientation)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->draw_handle (style, window, state_type, shadow_type, area,
	                               widget, detail, x, y, width, height,
	                               orientation);
}

static void
lua_style_draw_box (DRAW_ARGS)
{
	cairo_t *cr;
	LuaStyle *lua_style = LUA_STYLE (style);
	gboolean processed = FALSE;
	gint tmp;
	
	SANITIZE_SIZE;
	
	cr = lua_style_prepare_cairo (lua_style, window, area, x, y);
	
	if (widget && GE_IS_RANGE (widget) && GTK_RANGE (widget)->orientation != GTK_ORIENTATION_HORIZONTAL)
	{
		cairo_translate (cr, 0, height);
		cairo_rotate (cr, -G_PI * 0.5);
		tmp = width;
		width = height;
		height = tmp;
	}
		
	if (widget && GE_IS_PROGRESS_BAR (widget))
	{
		switch (gtk_progress_bar_get_orientation (GTK_PROGRESS_BAR (widget)))
		{
		case GTK_PROGRESS_BOTTOM_TO_TOP:
		case GTK_PROGRESS_TOP_TO_BOTTOM:
			cairo_translate (cr, 0, height);
			cairo_rotate (cr, -G_PI * 0.5);
			tmp = width;
			width = height;
			height = tmp;
		}
	
		switch (gtk_progress_bar_get_orientation (GTK_PROGRESS_BAR (widget)))
		{
		case GTK_PROGRESS_RIGHT_TO_LEFT:
		case GTK_PROGRESS_TOP_TO_BOTTOM:
			cairo_translate (cr, width, 0);
			cairo_scale (cr, -1, 1);
		}
	}
	
	if (DETAIL ("button") || DETAIL ("buttondefault") || DETAIL ("spinbutton") || DETAIL ("optionmenu"))
	{
		if (widget && widget->parent && (GE_IS_TREE_VIEW(widget->parent) ||
		    GE_IS_CLIST (widget->parent) || ge_object_is_a ((GObject*)widget->parent, "ETree")))
		{
			gint columns = 0;
			gint column_index = 0;
			gboolean resizable = TRUE;
			
			if (GE_IS_TREE_VIEW (widget->parent))
			{
				GList *list, *list_start;
				list_start = list = gtk_tree_view_get_columns (GTK_TREE_VIEW(widget->parent));
				
				do
				{
					GtkTreeViewColumn *column = GTK_TREE_VIEW_COLUMN (list->data);
					if (column->button == widget)
					{
						column_index = columns;
						resizable = column->resizable;
					}
					if (column->visible)
						columns++;
				} while ((list = g_list_next (list)));
				
				g_list_free (list_start);
			}
			else if (GE_IS_CLIST (widget->parent))
			{
				int i;
				columns = GTK_CLIST (widget->parent)->columns;
				
				for (i = 0; i < columns; i++)
				{
					if (GTK_CLIST (widget->parent)->column[i].button == widget)
					{
						column_index = i;
						break;
					}
				}
			}
			
			lua_newtable (lua_style->L);
			lua_pushboolean (lua_style->L, resizable);
			lua_setfield (lua_style->L, -2, "resizable");
			
			if (column_index == 0)
				lua_pushstring (lua_style->L, "first");
			else if (column_index == columns - 1)
				lua_pushstring (lua_style->L, "last");
			else
				lua_pushstring (lua_style->L, "middle");
			lua_setfield (lua_style->L, -2, "position");
			
			processed = lua_style_draw (lua_style, widget, state_type, "column_header", width, height);
		} 
		else if (DETAIL ("spinbutton"))
			processed = lua_style_draw (lua_style, widget, state_type, "spin_button", width, height);
		else if (widget && ge_is_in_combo_box (widget))
		{
			gboolean combo_has_focus = FALSE;
			
			if (ge_is_combo_box_entry (widget))
				combo_has_focus = GTK_WIDGET_HAS_FOCUS (gtk_bin_get_child (GTK_BIN (ge_find_combo_box_widget_parent (widget))));
				
			if (ge_is_combo (widget))
				combo_has_focus = GTK_WIDGET_HAS_FOCUS (GTK_COMBO (ge_find_combo_box_widget_parent (widget))->entry);
		
			lua_newtable (lua_style->L);
			lua_pushboolean (lua_style->L, combo_has_focus);
			lua_setfield (lua_style->L, -2, "parent_has_focus");
			processed = lua_style_draw (lua_style, widget, state_type, "combo_box_button", width, height);
		}
		else if (DETAIL ("optionmenu"))
			processed = lua_style_draw (lua_style, widget, state_type, "option_menu", width, height);
	
		if (!processed)
			processed = lua_style_draw (lua_style, widget, state_type, "button", width, height);
	}
	else if (DETAIL ("menubar"))
		processed = lua_style_draw (lua_style, widget, state_type, "menubar", width, height);
	else if (DETAIL ("menuitem"))
		processed = lua_style_draw (lua_style, widget, state_type, "menuitem", width, height);
	else if (DETAIL ("menu"))
		processed = lua_style_draw (lua_style, widget, state_type, "menu", width, height);
	else if (DETAIL ("trough") && widget && GE_IS_PROGRESS_BAR (widget))
		processed = lua_style_draw (lua_style, widget, state_type, "progressbar_tray", width, height);
	else if (DETAIL ("trough") && widget && (GE_IS_VSCROLLBAR (widget) || GE_IS_HSCROLLBAR (widget)))
		processed = lua_style_draw (lua_style, widget, state_type, "scrollbar_tray", width, height);
	else if (detail && g_str_has_prefix (detail, "trough") && GE_IS_SCALE (widget))
	{
		lua_newtable (lua_style->L);
		lua_pushboolean (lua_style->L, DETAIL ("trough-lower"));
		lua_setfield (lua_style->L, -2, "lower");
		processed = lua_style_draw (lua_style, widget, state_type, "scale_tray", width, height);
	}
	else if (DETAIL ("bar"))
		processed = lua_style_draw (lua_style, widget, state_type, "progressbar", width, height);
	else if (DETAIL ("hscrollbar") || DETAIL ("vscrollbar") || DETAIL ("slider") || DETAIL ("stepper"))
	{
		if (DETAIL ("slider"))
			processed = lua_style_draw (lua_style, widget, state_type, "scrollbar", width, height);
		else
		{
			processed = lua_style_draw (lua_style, widget, state_type, "scrollbar_stepper", width, height);
			
			if (!processed)
			{
				processed = lua_style_draw (lua_style, widget, state_type, "button", width, height);
			}
		}
	}
	else if (DETAIL ("hscale") || DETAIL ("vscale"))
		processed = lua_style_draw (lua_style, widget, state_type, "scale", width, height);
	else if (DETAIL ("toolbar") || DETAIL ("handlebox_bin") || DETAIL ("dockitem_bin"))
		processed = lua_style_draw (lua_style, widget, state_type, "toolbar", width, height);
	
	if (!processed)
	{
		//g_printf ("DRAW BOX: Unrecognized detail string: %s\n", detail);
		lua_style_close_cairo (lua_style);
		GTK_STYLE_CLASS (lua_style_parent_class)->draw_box (style, window, state_type, shadow_type, area,
		                        widget, detail, x, y, width, height);
	}
    
	lua_style_close_cairo (lua_style);
}

static void
lua_style_draw_slider (DRAW_ARGS, GtkOrientation orientation)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->draw_slider (style, window, state_type, shadow_type, area,
	                           widget, detail, x, y, width, height, orientation);
}

static void
lua_style_draw_option (DRAW_ARGS)
{
	LuaStyle *lua_style = LUA_STYLE(style);
	
	/* sanitize size to be rectangular */
	if (width > height) {
		x += (width - height) / 2;
		width = height;
	} else if (height > width) {
		y += (height - width) / 2;
		height = width;
	}
	
	lua_style_prepare_cairo (lua_style, window, area, x, y);
	
	lua_newtable (lua_style->L);
	lua_pushboolean (lua_style->L, shadow_type == GTK_SHADOW_IN || shadow_type == GTK_SHADOW_ETCHED_IN);
	lua_setfield (lua_style->L, -2, "draw_mark");
	lua_pushboolean (lua_style->L, shadow_type == GTK_SHADOW_ETCHED_IN);
	lua_setfield (lua_style->L, -2, "inconsistent");
	lua_pushboolean (lua_style->L, widget && widget->parent && GTK_IS_MENU(widget->parent));
	lua_setfield (lua_style->L, -2, "in_menu");
	
	lua_style_draw (lua_style, widget, state_type, "radiobutton", width, height);
	
    lua_style_close_cairo (lua_style);
}

static void
lua_style_draw_check (DRAW_ARGS)
{
	LuaStyle *lua_style = LUA_STYLE(style);
	
	/* sanitize size to be rectangular */
	if (width > height) {
		x += (width - height) / 2;
		width = height;
	} else if (height > width) {
		y += (height - width) / 2;
		height = width;
	}
	
	lua_style_prepare_cairo (lua_style, window, area, x, y);
	
	lua_newtable (lua_style->L);
	lua_pushboolean (lua_style->L, shadow_type == GTK_SHADOW_IN || shadow_type == GTK_SHADOW_ETCHED_IN);
	lua_setfield (lua_style->L, -2, "draw_mark");
	lua_pushboolean (lua_style->L, shadow_type == GTK_SHADOW_ETCHED_IN);
	lua_setfield (lua_style->L, -2, "inconsistent");
	lua_pushboolean (lua_style->L, DETAIL("cellcheck"));
	lua_setfield (lua_style->L, -2, "in_cell");
	lua_pushboolean (lua_style->L, widget && widget->parent && GTK_IS_MENU(widget->parent));
	lua_setfield (lua_style->L, -2, "in_menu");
	
	lua_style_draw (lua_style, widget, state_type, "checkbox", width, height);
	
    lua_style_close_cairo (lua_style);
}

static void
lua_style_draw_tab (DRAW_ARGS)
{
}

static void
lua_style_draw_vline (GtkStyle               *style,
                      GdkWindow              *window,
                      GtkStateType            state_type,
                      GdkRectangle           *area,
                      GtkWidget              *widget,
                      const gchar            *detail,
                      gint                    y1,
                      gint                    y2,
                      gint                    x)
{
	gint tmp, width, height;
	cairo_t *cr;
	LuaStyle *lua_style = LUA_STYLE (style);
	cr = lua_style_prepare_cairo (lua_style, window, area, x, y1);
	
	width = y2-y1;
	height = 2;
	
	cairo_translate (cr, 0, width);
	cairo_rotate (cr, -G_PI * 0.5);
	
	lua_newtable (lua_style->L);
	lua_pushstring (lua_style->L, "vertical");
	lua_setfield (lua_style->L, -2, "orientation");
	lua_style_draw (lua_style, widget, state_type, "separator", width, height);
	
	lua_style_close_cairo (lua_style);
}

static void
lua_style_draw_hline (GtkStyle               *style,
                      GdkWindow              *window,
                      GtkStateType            state_type,
                      GdkRectangle           *area,
                      GtkWidget              *widget,
                      const gchar            *detail,
                      gint                    x1,
                      gint                    x2,
                      gint                    y)
{
	cairo_t *cr;
	LuaStyle *lua_style = LUA_STYLE (style);
	cr = lua_style_prepare_cairo (lua_style, window, area, x1, y);
	
	// FIXME: otherwise the clip is only one pixel high, how did clearlooks fix this?
	cairo_reset_clip (cr);
	
	lua_newtable (lua_style->L);
	lua_pushstring (lua_style->L, "horizontal");
	lua_setfield (lua_style->L, -2, "orientation");
	lua_style_draw (lua_style, widget, state_type, "separator", x2-x1, 2);
	
	lua_style_close_cairo (lua_style);
}

static void 
lua_style_draw_shadow_gap (DRAW_ARGS,
                           GtkPositionType gap_side,
                           gint            gap_x,
                           gint            gap_width)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->draw_shadow_gap (style, window, state_type, shadow_type, area,
	                               widget, detail, x, y, width, height,
	                               gap_side, gap_x, gap_width);
}

static void
lua_style_draw_resize_grip (GtkStyle       *style,
                            GdkWindow      *window,
                            GtkStateType    state_type,
                            GdkRectangle   *area,
                            GtkWidget      *widget,
                            const gchar    *detail,
                            GdkWindowEdge   edge,
                            gint            x,
                            gint            y,
                            gint            width,
                            gint            height)
{
}

static void
lua_style_draw_arrow (GtkStyle  *style,
                      GdkWindow     *window,
                      GtkStateType   state_type,
                      GtkShadowType  shadow,
                      GdkRectangle  *area,
                      GtkWidget     *widget,
                      const gchar   *detail,
                      GtkArrowType   arrow_type,
                      gboolean       fill,
                      gint           x,
                      gint           y,
                      gint           width,
                      gint           height)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->draw_arrow (style, window, state_type, shadow, area,
	                          widget, detail, arrow_type, fill,
	                          x, y, width, height);
}

static void
lua_style_init_from_rc (GtkStyle   *style,
                        GtkRcStyle *rc_style)
{
	LuaStyle *lua_style = LUA_STYLE (style);

	GTK_STYLE_CLASS (lua_style_parent_class)->init_from_rc (style, rc_style);
	
	lua_style->theme = LUA_RC_STYLE (rc_style)->theme;
}

static void
lua_style_realize (GtkStyle *style)
{
	LuaStyle *lua_style = LUA_STYLE (style);
	double shades[] = {1.15, 0.95, 0.896, 0.82, 0.7, 0.665, 0.5, 0.45, 0.4};
	CairoColor spot_color;
	CairoColor bg_normal;
	double contrast;
	int i;
	
	GTK_STYLE_CLASS (lua_style_parent_class)->realize (style);
	
	/* Lighter to darker */
	ge_gdk_color_to_cairo (&style->bg[GTK_STATE_NORMAL], &bg_normal);

	for (i = 0; i < 9; i++)
	{
		ge_shade_color(&bg_normal, (shades[i]-0.7) * contrast + 0.7, &lua_style->colors.shade[i]);
	}
		
	ge_gdk_color_to_cairo (&style->bg[GTK_STATE_SELECTED], &spot_color);
	
	ge_shade_color(&spot_color, 1.42, &lua_style->colors.spot[0]);
	ge_shade_color(&spot_color, 1.05, &lua_style->colors.spot[1]);
	ge_shade_color(&spot_color, 0.65, &lua_style->colors.spot[2]);
	
	for (i=0; i<5; i++)
	{
		ge_gdk_color_to_cairo (&style->bg[i], &lua_style->colors.bg[i]);
		ge_gdk_color_to_cairo (&style->base[i], &lua_style->colors.base[i]);
		ge_gdk_color_to_cairo (&style->text[i], &lua_style->colors.text[i]);
	}
	
	lua_style->L = lua_style_prepare_lua (lua_style);
}


static void
lua_style_draw_focus (GtkStyle *style, GdkWindow *window, GtkStateType state_type,
                      GdkRectangle *area, GtkWidget *widget, const gchar *detail,
                      gint x, gint y, gint width, gint height)
{
}

static void
lua_style_copy (GtkStyle *style, GtkStyle *src)
{
	GTK_STYLE_CLASS (lua_style_parent_class)->copy (style, src);
}

static void
lua_style_unrealize (GtkStyle *style)
{
	LuaStyle *lua_style = LUA_STYLE (style);
	
	GTK_STYLE_CLASS (lua_style_parent_class)->unrealize (style);
	
	if (lua_style->L)
		lua_close (lua_style->L);
}

static void
lua_style_init (LuaStyle *style)
{
}

static void
lua_style_class_init (LuaStyleClass *klass)
{
	GtkStyleClass *style_class = GTK_STYLE_CLASS (klass);
	
	style_class->copy             = lua_style_copy;
	style_class->realize          = lua_style_realize;
	style_class->unrealize        = lua_style_unrealize;
	style_class->init_from_rc     = lua_style_init_from_rc;
	
	style_class->draw_handle      = lua_style_draw_handle;
	style_class->draw_slider      = lua_style_draw_slider;
	style_class->draw_shadow_gap  = lua_style_draw_shadow_gap;
	style_class->draw_focus       = lua_style_draw_focus;
	style_class->draw_box         = lua_style_draw_box;
	style_class->draw_shadow      = lua_style_draw_shadow;
	style_class->draw_box_gap     = lua_style_draw_box_gap;
	style_class->draw_extension   = lua_style_draw_extension;
	style_class->draw_option      = lua_style_draw_option;
	style_class->draw_check       = lua_style_draw_check;
	style_class->draw_flat_box    = lua_style_draw_flat_box;
	style_class->draw_tab         = lua_style_draw_tab;
	style_class->draw_vline       = lua_style_draw_vline;
	style_class->draw_hline       = lua_style_draw_hline;
	style_class->draw_resize_grip = lua_style_draw_resize_grip;
	style_class->draw_arrow       = lua_style_draw_arrow;
	/*style_class->render_icon      = lua_style_draw_render_icon;*/
}

static void
lua_style_class_finalize (LuaStyleClass *klass)
{
}

void
lua_style_register_types (GTypeModule *module)
{
	lua_style_register_type (module);
}

