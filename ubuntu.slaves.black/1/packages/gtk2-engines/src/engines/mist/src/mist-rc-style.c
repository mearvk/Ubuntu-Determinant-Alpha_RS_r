#include "mist-rc-style.h"
#include "mist-style.h"

G_DEFINE_DYNAMIC_TYPE (MistRcStyle, mist_rc_style, GTK_TYPE_RC_STYLE)

static guint     mist_rc_style_parse        (GtkRcStyle       *rc_style,
					     GtkSettings      *settings,
					     GScanner         *scanner);
static void      mist_rc_style_merge        (GtkRcStyle       *dest,
					     GtkRcStyle       *src);
static GtkStyle *mist_rc_style_create_style (GtkRcStyle       *rc_style);

void
mist_rc_style_register_types (GTypeModule *module)
{
	mist_rc_style_register_type (module);
}

static void
mist_rc_style_init (MistRcStyle *style)
{
}

static void
mist_rc_style_class_init (MistRcStyleClass *klass)
{
	GtkRcStyleClass *rc_style_class = GTK_RC_STYLE_CLASS (klass);
	
	rc_style_class->parse = mist_rc_style_parse;
	rc_style_class->merge = mist_rc_style_merge;
	rc_style_class->create_style = mist_rc_style_create_style;
}

static void
mist_rc_style_class_finalize (MistRcStyleClass *klass)
{
}

static guint
mist_rc_style_parse (GtkRcStyle *rc_style,
			GtkSettings  *settings,
			GScanner   *scanner)
{
	static GQuark scope_id = 0;
	guint old_scope;
	guint token;
	
	/* Set up a new scope in this scanner. */
	
	if (!scope_id)
		scope_id = g_quark_from_string("mist_theme_engine");
	
	/* If we bail out due to errors, we *don't* reset the scope, so the
	 * error messaging code can make sense of our tokens.
	 */
	old_scope = g_scanner_set_scope(scanner, scope_id);
	
	/* We're ready to go, now parse the top level */
	
	token = g_scanner_peek_next_token(scanner);
	while (token != G_TOKEN_RIGHT_CURLY) {
		switch (token) {
		default :
			token = G_TOKEN_RIGHT_CURLY;
		}
		token = g_scanner_peek_next_token (scanner);
		if (token != G_TOKEN_NONE) {
			return token;
		}
	}
	
	g_scanner_get_next_token(scanner);
	
	g_scanner_set_scope(scanner, old_scope);
	
	return G_TOKEN_NONE;
}

static void
mist_rc_style_merge (GtkRcStyle * dest,
		     GtkRcStyle * src)
{
	GTK_RC_STYLE_CLASS (mist_rc_style_parent_class)->merge (dest, src);
}

/* Create an empty style suitable to this RC style
 */
static GtkStyle *
mist_rc_style_create_style (GtkRcStyle *rc_style)
{
  void *ptr;
  ptr = GTK_STYLE (g_object_new (MIST_TYPE_STYLE, NULL));
  return (GtkStyle *)ptr;
}
