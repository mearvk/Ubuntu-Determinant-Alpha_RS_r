/* gtk-clutter-embed.h: Embeddable ClutterStage
 *
 * Copyright © 2009 Red Hat, Inc
 * Copyright © 2010 OpenedHand
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library. If not see <http://www.fsf.org/licensing>.
 *
 * Authors:
 *   Alexander Larsson <alexl@redhat.com>
 *   Danielle Madeley <danielle.madeley@collabora.co.uk>
 */

#ifndef __GTK_CLUTTER_ACTOR_INTERNAL_H__
#define __GTK_CLUTTER_ACTOR_INTERNAL_H__

#include "gtk-clutter-actor.h"

G_BEGIN_DECLS

GtkWidget *_gtk_clutter_actor_get_embed (GtkClutterActor *actor);
void       _gtk_clutter_actor_update    (GtkClutterActor *actor,
					 gint             x,
					 gint             y,
					 gint             width,
					 gint             height);

G_END_DECLS

#endif /* __GTK_CLUTTER_ACTOR_INTERNAL_H__ */
