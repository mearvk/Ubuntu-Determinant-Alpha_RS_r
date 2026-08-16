/* gtk-engines - a collection of drawing engines for GTK+ 
 * Copyright (C) 2007 Benjamin Berg <benjamin@sipsolutions.net>
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
#include <string.h>
#include <stdlib.h>

typedef enum {
	WIDGET_NULL,
	WIDGET_SCROLLBAR,
	WIDGET_TOGGLE_BUTTON,
	WIDGET_STATUS_BAR,
	WIDGET_TREE_VIEW,
	WIDGET_TREE_VIEW_HEADER,
	WIDGET_SCALE,
	WIDGET_PROGRESS_BAR,
	WIDGET_MENUBAR,
	WIDGET_MENUBAR_ITEM,
#ifndef GTK_DISABLE_DEPRECATED
	WIDGET_OPTION_MENU,
#endif /* GTK_DISABLE_DEPRECATED */
	WIDGET_TOOLBAR,
	WIDGET_DEFAULT_BUTTON
} WidgetType;

#define WIDGET_COUNT (WIDGET_DEFAULT_BUTTON+1)
#define WIDGET_ALL (-1)


GType
widget_type_get_type (void)
{
	static GType type = 0;
	if (type == 0) {
		static const GEnumValue values[] = {
			{ WIDGET_NULL, "WIDGET_NULL", "NULL" },
			{ WIDGET_SCROLLBAR, "WIDGET_SCROLLBAR", "GtkScrollBar" },
			{ WIDGET_TOGGLE_BUTTON, "WIDGET_TOGGLE_BUTTON", "GtkToggleButton" },
			{ WIDGET_STATUS_BAR, "WIDGET_STATUS_BAR", "GtkStatusBar" },
			{ WIDGET_TREE_VIEW, "WIDGET_TREE_VIEW", "GtkTreeView" },
			{ WIDGET_TREE_VIEW_HEADER, "WIDGET_TREE_VIEW_HEADER", "GtkTreeView-header" },
			{ WIDGET_SCALE, "WIDGET_SCALE", "GtkScale" },
			{ WIDGET_PROGRESS_BAR, "WIDGET_PROGRESS_BAR", "GtkProgessBar" },
			{ WIDGET_MENUBAR, "WIDGET_MENUBAR", "GtkMenubar" },
			{ WIDGET_MENUBAR_ITEM, "WIDGET_MENUBAR_ITEM", "GtkMenubar-item" },
#ifndef GTK_DISABLE_DEPRECATED
			{ WIDGET_OPTION_MENU, "WIDGET_OPTION_MENU", "GtkOptionMenu" },
#endif
			{ WIDGET_TOOLBAR, "WIDGET_TOOLBAR", "GtkToolbar" },
			{ WIDGET_DEFAULT_BUTTON, "WIDGET_DEFAULT_BUTTON", "GtkButton-has-default" },
			{ 0, NULL, NULL }
		};
	type = g_enum_register_static ("WidgeType", values);
	}
	return type;
}

GType
bool_get_type (void)
{
	static GType type = 0;
	if (type == 0) {
		static const GEnumValue values[] = {
			{ 0, "BOOL_FALSE", "False" },
			{ 1, "BOOL_TRUE", "True" },
			{ 0, NULL, NULL }
		};
		type = g_enum_register_static ("GtkBoolDummyType", values);
	}
	return type;
}


#define WIDGET_TYPE (widget_type_get_type ())
#define BOOL_TYPE (bool_get_type ())


typedef enum {
	FUNCTION_ARROW		= 1 << 0,
	FUNCTION_BOX		= 1 << 1,
	FUNCTION_SHADOW		= 1 << 2,
	FUNCTION_BOX_GAP	= 1 << 3,
	FUNCTION_SHADOW_GAP	= 1 << 4,
	FUNCTION_CHECK		= 1 << 5,
	FUNCTION_EXPANDER	= 1 << 6,
	FUNCTION_EXTENSION	= 1 << 7,
	FUNCTION_FLAT_BOX	= 1 << 8,
	FUNCTION_FOCUS		= 1 << 9,
	FUNCTION_HANDLE		= 1 << 10,
	FUNCTION_HLINE		= 1 << 11,
	FUNCTION_VLINE		= 1 << 12,
	FUNCTION_OPTION		= 1 << 13,
	FUNCTION_RESIZE_GRIP	= 1 << 14,
	FUNCTION_SLIDER		= 1 << 15,
	FUNCTION_TAB		= 1 << 16,

	FUNCTION_ALL		= -1
} FunctionType;
#define FUNCTION_LAST FUNCTION_BOX

GtkWidget *window;
GtkWidget *box;
GtkWidget *widgets[WIDGET_COUNT];

typedef struct {
	FunctionType     function;
	WidgetType       widget;
	gchar           *detail;
	GtkStateType     state;
	GtkShadowType    shadow;
	GtkArrowType     arrow_type;
	gboolean         fill;
	GtkPositionType  gap_side;
	GtkOrientation   orientation;
	GtkExpanderStyle expander_style;
	GdkWindowEdge    edge;
} Test;

#define ARROW_ALL (-1)
#define STATE_ALL (-1)
#define SHADOW_ALL (-1)
#define FILL_ALL (-1)
#define EXPANDER_ALL (-1)
#define EDGE_ALL (-1)
#define GAP_SIDE_ALL (-1)
#define ORIENTATION_ALL (-1)

#define CELL_DETAILS_SIDE(detail) detail ":" detail "_start" ":" detail "_middle" ":" detail "_end"
#define CELL_DETAILS_SORTED(detail) CELL_DETAILS_SIDE(detail) ":" CELL_DETAILS_SIDE(detail "_sorted")
#define CELL_DETAILS_RULED(detail) CELL_DETAILS_SORTED(detail) ":" CELL_DETAILS_SORTED(detail "_ruled")
#define CELL_DETAILS CELL_DETAILS_RULED("cell_even") ":" CELL_DETAILS_RULED("cell_odd")
#define CHECK_AND_RADIO_DETAILS "NULL:cellcheck:cellradio:check:checkbutton:radiobutton"
#define EXPANDER_DETAILS "NULL:expander" /* also in common details list ... */
#define ARROW_DETAILS "NULL:arrow:tab:optionmenutab"
#define COMMON_DETAILS "NULL:arrow:bar:base:button:buttondefault:combo_entry_button:dockitem:dockitem_bin:entry:entry_bg:frame:handle:handlebox:handlebox_bin:hpaned:hruler:hscale:hscrollbar:hseparator:label:menu:menubar:menuitem:metacity:notebook:option:optionmenu:optionmenutab:paned:scrolled_window:slider:spinbutton:spinbutton_arrow:spinbutton_down:spinbutton_up:stepper:tab:text:togglebutton:togglebuttondefault:toolbar:tooltip:treeitem:treeview:trough:viewport:viewportbin:vpaned:vruler:vscale:vscrollbar:vseparator:expander:iconview-drop-indicator:icon_view_item:icon_view:entry-progress"

/* The following explicitly does not test EVERY combination, as that would be
 * overkill, and would take a lot longer. */
static Test tests[] = {
	{	/* ARROW */
		FUNCTION_ARROW,
		WIDGET_NULL,
		ARROW_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		ARROW_ALL,
		FILL_ALL,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{	/* things with gaps */
		FUNCTION_BOX_GAP | FUNCTION_SHADOW_GAP | FUNCTION_EXTENSION,
		WIDGET_NULL,
		COMMON_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GAP_SIDE_ALL,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{	/* expander */
		FUNCTION_EXPANDER,
		WIDGET_NULL,
		EXPANDER_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		EXPANDER_ALL,
		GDK_WINDOW_EDGE_SOUTH
	},
	{	/* handle, slider (+orientation wildcarded) */
		FUNCTION_HANDLE | FUNCTION_SLIDER,
		WIDGET_NULL,
		COMMON_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		ORIENTATION_ALL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{	/* resize grip (+edge wildcarded) */
		FUNCTION_RESIZE_GRIP,
		WIDGET_NULL,
		COMMON_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		EDGE_ALL
	},
	{	/* check and radio */
		FUNCTION_CHECK | FUNCTION_OPTION,
		WIDGET_NULL,
		CHECK_AND_RADIO_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{	/* cell flat box */
		FUNCTION_FLAT_BOX,
		WIDGET_NULL,
		CELL_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{	/* GENERIC STUFF (will be duplicated somewhat, but *shrug*) */
		FUNCTION_ALL ^ (FUNCTION_ARROW | FUNCTION_BOX_GAP | FUNCTION_SHADOW_GAP | FUNCTION_EXTENSION | FUNCTION_EXPANDER | FUNCTION_HANDLE | FUNCTION_SLIDER | FUNCTION_RESIZE_GRIP | FUNCTION_CHECK | FUNCTION_OPTION),
		WIDGET_NULL,
		COMMON_DETAILS,
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},


	/* The above brute force stuff does not hit enough code paths because it always
	 * passes in a NULL widget. The following rules are more specilized to hit certain
	 * code paths inside gtk-engines. Anyone forking may need to add own special things. */

	{
		FUNCTION_FOCUS,
		WIDGET_DEFAULT_BUTTON,
		"NULL:button:add-mode:colorwheel_dark:colorwheel_light",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX,
		WIDGET_DEFAULT_BUTTON,
		"NULL:button:buttondefault:togglebutton:togglebuttondefault",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX,
		WIDGET_TOGGLE_BUTTON,
		"NULL:button:buttondefault:togglebutton:togglebuttondefault",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX,
		WIDGET_TREE_VIEW_HEADER,
		"NULL:button:buttondefault",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_SHADOW,
		WIDGET_STATUS_BAR,
		"NULL:frame",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX | FUNCTION_SLIDER,
		WIDGET_SCALE,
		"NULL:slider:stepper:trough:hscale:vscale",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX | FUNCTION_SLIDER,
		WIDGET_SCROLLBAR,
		"NULL:slider:stepper:trough:hscrollbar:vscrollbar",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX,
		WIDGET_PROGRESS_BAR,
		"NULL:trough:bar",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX,
		WIDGET_MENUBAR_ITEM,
		"NULL:menuitem",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
#ifndef GTK_DISABLE_DEPRECATED
	{
		FUNCTION_BOX,
		WIDGET_OPTION_MENU,
		"NULL:optionmenu",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
	{
		FUNCTION_BOX,
		WIDGET_OPTION_MENU,
		"NULL:optionmenu",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},
#endif /* GTK_DISABLE_DEPRECATED */
	{
		FUNCTION_BOX,
		WIDGET_TOOLBAR,
		"NULL:toolbar:handle",
		STATE_ALL,
		SHADOW_ALL,
		GTK_ARROW_UP,
		TRUE,
		GTK_POS_TOP,
		GTK_ORIENTATION_HORIZONTAL,
		GTK_EXPANDER_EXPANDED,
		GDK_WINDOW_EDGE_SOUTH
	},

};

#define ENUM_NEXT(enum_type, ind, target)				\
	do {								\
		GEnumClass *enum_class = g_type_class_ref (enum_type);	\
		if (initial || values[ind] >= enum_class->n_values - 1) { \
			values[ind] = 0;				\
		} else {						\
			done = FALSE;					\
			values[ind]++;					\
		}							\
									\
		target = enum_class->values[values[ind]].value;		\
		g_type_class_unref (enum_class);			\
		if (!done && !initial)					\
			goto end;					\
	} while(0)

static gboolean
get_next_combination (Test *wildcard_test, Test *test, gboolean initial)
{
	gint i;
	gchar *cur_pos, *col_pos;
	gboolean done = !initial;
	static gint values[10];
	
	test->function = wildcard_test->function;
	
	if (wildcard_test->widget == WIDGET_ALL)
		ENUM_NEXT (WIDGET_TYPE, 0, test->widget);
	else
		test->widget = wildcard_test->widget;

	if (wildcard_test->state == STATE_ALL)
		ENUM_NEXT (GTK_TYPE_STATE_TYPE, 1, test->state);
	else
		test->state = wildcard_test->state;

	if (wildcard_test->shadow == SHADOW_ALL)
		ENUM_NEXT (GTK_TYPE_SHADOW_TYPE, 2, test->shadow);
	else
		test->shadow = wildcard_test->shadow;

	if (wildcard_test->arrow_type == ARROW_ALL)
		ENUM_NEXT (GTK_TYPE_ARROW_TYPE, 3, test->arrow_type);
	else
		test->arrow_type = wildcard_test->arrow_type;

	if (wildcard_test->fill == FILL_ALL)
		ENUM_NEXT (BOOL_TYPE, 4, test->fill);
	else
		test->fill = wildcard_test->fill;

	if (wildcard_test->gap_side == GAP_SIDE_ALL)
		ENUM_NEXT (GTK_TYPE_POSITION_TYPE, 5, test->gap_side);
	else
		test->gap_side = wildcard_test->gap_side;

	if (wildcard_test->orientation == ORIENTATION_ALL)
		ENUM_NEXT (GTK_TYPE_ORIENTATION, 6, test->orientation);
	else
		test->orientation = wildcard_test->orientation;

	if (wildcard_test->expander_style == EXPANDER_ALL)
		ENUM_NEXT (GTK_TYPE_EXPANDER_STYLE, 7, test->expander_style);
	else
		test->expander_style = wildcard_test->expander_style;

	if (wildcard_test->edge == EDGE_ALL)
		ENUM_NEXT (GDK_TYPE_WINDOW_EDGE, 8, test->edge);
	else
		test->edge = wildcard_test->edge;
	
end:
	/* the detail is a : seperated list ... */
	if (initial) {
		values[9] = 0;
	} else {
		/* increase, if nothing else got changed. */
		if (done)
			values[9]++;
	}
	i = 0;
	cur_pos = wildcard_test->detail;
	
	while (i < values[9] && cur_pos) {
		cur_pos = strchr (cur_pos, ':');
		if (cur_pos != NULL) cur_pos++;
		i++;
	}
	if (cur_pos == NULL) {
		values[9] = 0;
		cur_pos = wildcard_test->detail;
		if (done)
			return TRUE;
	} else {
		/* not done, as we moved on */
		done = FALSE;
	}
	if (cur_pos != NULL) {
		col_pos = strchr (cur_pos, ':');
		if (col_pos == NULL)
			test->detail = g_strdup (cur_pos);
		else
			test->detail = g_strndup (cur_pos, col_pos - cur_pos);
	} else
		test->detail = NULL;
	
	/* replace "NULL" with a NULL pointer */
	if (test->detail && strcmp (test->detail, "NULL") == 0) {
		g_free (test->detail);
		test->detail = NULL;
	}
	
	return done;
}

static void
run_functions (Test *test)
{
	GtkStyle *style = window->style;
	GdkWindow *mywindow = window->window;
	
	if (widgets[test->widget]) {
		style = widgets[test->widget]->style;
		mywindow = widgets[test->widget]->window;
	}
	
	if (test->function & FUNCTION_ARROW)
		gtk_paint_arrow (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, test->arrow_type, test->fill, 0, 0, 10, 10);

	if (test->function & FUNCTION_BOX)
		gtk_paint_box (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10);

	if (test->function & FUNCTION_SHADOW)
		gtk_paint_shadow (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10);

	if (test->function & FUNCTION_BOX_GAP)
		gtk_paint_box_gap (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10, test->gap_side, 0, 100);

	if (test->function & FUNCTION_SHADOW_GAP)
		gtk_paint_shadow_gap (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10, test->gap_side, 0, 100);


	if (test->function & FUNCTION_CHECK)
		gtk_paint_check (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10);
		
	if (test->function & FUNCTION_EXPANDER)
		gtk_paint_expander (style, mywindow, test->state, NULL, widgets[test->widget], test->detail, 10, 10, test->expander_style);

	if (test->function & FUNCTION_EXTENSION)
		gtk_paint_extension (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10, test->gap_side);

	if (test->function & FUNCTION_FLAT_BOX)
		gtk_paint_flat_box (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10);

	if (test->function & FUNCTION_FOCUS)
		gtk_paint_focus (style, mywindow, test->state, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10);

	if (test->function & FUNCTION_HANDLE)
		gtk_paint_handle (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10, test->orientation);

	if (test->function & FUNCTION_OPTION)
		gtk_paint_option (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10);

	if (test->function & FUNCTION_RESIZE_GRIP)
		gtk_paint_resize_grip (style, mywindow, test->state, NULL, widgets[test->widget], test->detail, test->edge, 0, 0, 10, 10);

	if (test->function & FUNCTION_SLIDER)
		gtk_paint_slider (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10, test->orientation);

	if (test->function & FUNCTION_TAB)
		gtk_paint_tab (style, mywindow, test->state, test->shadow, NULL, widgets[test->widget], test->detail, 0, 0, 10, 10);


	if (test->function & FUNCTION_HLINE)
		gtk_paint_hline (style, mywindow, test->state, NULL, widgets[test->widget], test->detail, 1, 10, 4);

	if (test->function & FUNCTION_VLINE)
		gtk_paint_vline (style, mywindow, test->state, NULL, widgets[test->widget], test->detail, 1, 10, 4);
}

static void
run_test (gint test)
{
	Test current_test = {0};
	gint initial = TRUE;
	
	while (!get_next_combination (&tests[test], &current_test, initial)) {
		initial = FALSE;
		run_functions (&current_test);
		g_free (current_test.detail);
	}
}

static void
create_testwidgets ()
{
	GtkWidget *treeview;
	GtkListStore *store;
	GtkCellRenderer *renderer;
	
	widgets[WIDGET_NULL] = NULL;
	widgets[WIDGET_SCROLLBAR] = gtk_vscrollbar_new (NULL);
	widgets[WIDGET_TOGGLE_BUTTON] = gtk_toggle_button_new_with_label ("blah");
	widgets[WIDGET_STATUS_BAR] = gtk_statusbar_new ();


	treeview = gtk_tree_view_new ();
	
	/* set up the treeview */
	renderer = gtk_cell_renderer_text_new ();
	gtk_tree_view_insert_column_with_attributes (GTK_TREE_VIEW (treeview),
	                                             -1, "Column1", renderer,  
	                                             "text", 0, NULL);
	renderer = gtk_cell_renderer_text_new ();
	gtk_tree_view_insert_column_with_attributes (GTK_TREE_VIEW (treeview),
	                                             -1, "Column2", renderer,  
	                                             "text", 0, NULL);
	store = gtk_list_store_new (2, G_TYPE_STRING, G_TYPE_STRING);
	gtk_tree_view_set_model (GTK_TREE_VIEW (treeview), GTK_TREE_MODEL (store));

	widgets[WIDGET_TREE_VIEW] = treeview;
	/* lets abuse the private API ... */
	widgets[WIDGET_TREE_VIEW_HEADER] = gtk_tree_view_get_column (GTK_TREE_VIEW (treeview), 0)->button;
	
	
	widgets[WIDGET_SCALE] = gtk_hscale_new_with_range (0, 1, 0.1);
	widgets[WIDGET_PROGRESS_BAR] = gtk_progress_bar_new ();
	widgets[WIDGET_MENUBAR] = gtk_menu_bar_new ();
	widgets[WIDGET_MENUBAR_ITEM] = gtk_menu_item_new_with_label ("blah");
	gtk_menu_shell_append (GTK_MENU_SHELL (widgets[WIDGET_MENUBAR]), widgets[WIDGET_MENUBAR_ITEM]);
#ifndef GTK_DISABLE_DEPRECATED
	widgets[WIDGET_OPTION_MENU] = gtk_option_menu_new ();
#else
#warning Not testing engines against GtkOptionMenu
#endif /* GTK_DISABLE_DEPRECATED */
	widgets[WIDGET_TOOLBAR] = gtk_toolbar_new ();
	widgets[WIDGET_DEFAULT_BUTTON] = gtk_button_new_with_label ("blah");
	/* nasty but *shrug* */
	GTK_WIDGET_SET_FLAGS(widgets[WIDGET_DEFAULT_BUTTON], GTK_CAN_DEFAULT);
	GTK_WIDGET_SET_FLAGS(widgets[WIDGET_DEFAULT_BUTTON], GTK_HAS_DEFAULT);
}

int
main (int argc, char **argv)
{
        gchar *new_default_files[1] = {NULL};
	GtkSettings *settings;
	gint i;
	gtk_init (&argc, &argv);
        
        /* we get a gtkrc from GTK2_RC_FILES, remove the users theme ... */
        settings = gtk_settings_get_default ();
        g_object_set (settings, "gtk-theme-name", "Raleigh", NULL);
        
	create_testwidgets ();

	window = gtk_window_new (GTK_WINDOW_POPUP);
	box = gtk_vbox_new (FALSE, 0);
	
	gtk_container_add ((GtkContainer*)window, box);
	
	for (i = 0; i < WIDGET_COUNT; i++) {
		if (widgets[i] && !widgets[i]->parent)
			gtk_box_pack_end (GTK_BOX (box), widgets[i], FALSE, FALSE, 0);
	}

	while (gdk_events_pending ())
		gtk_main_iteration_do (FALSE);
	
	gtk_widget_show_all (window);
	while (gdk_events_pending ())
		gtk_main_iteration_do (FALSE);
	
	for (i = 0; i < G_N_ELEMENTS (tests); i++)
		run_test (i);
	
	/* remove the rc file again. This should cause an unload of the engine
	 * and destruction of all engine objects. */
        gtk_rc_set_default_files (new_default_files);
	gtk_rc_reparse_all_for_settings (settings, TRUE);

	gtk_widget_hide (window);
	gtk_widget_unmap (window);

	while (gdk_events_pending ())
		gtk_main_iteration_do (FALSE);

	gtk_widget_destroy (window);

	while (gdk_events_pending ())
		gtk_main_iteration_do (FALSE);

	/* TODO: It would be really cool to check if there is no
	 * loaded engine at this point. */

	/*
	 * HRM: Calling the follwing causes an assertion failure inside cairo here -- 01.10.2010, Benjamin
	cairo_debug_reset_static_data ();
	*/

	return 0;
}
