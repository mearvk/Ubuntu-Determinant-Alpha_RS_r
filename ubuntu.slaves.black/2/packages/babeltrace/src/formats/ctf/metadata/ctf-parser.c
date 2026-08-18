/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 1

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "ctf-parser.y" /* yacc.c:339  */

/*
 * ctf-parser.y
 *
 * Common Trace Format Metadata Grammar.
 *
 * Copyright 2010 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdio.h>
#include <ctype.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <glib.h>
#include <errno.h>
#include <inttypes.h>
#include <babeltrace/list.h>
#include <babeltrace/babeltrace-internal.h>
#include "ctf-scanner.h"
#include "ctf-parser.h"
#include "ctf-ast.h"
#include "objstack.h"

BT_HIDDEN
int yydebug;

/* Join two lists, put "add" at the end of "head".  */
static inline void
_bt_list_splice_tail (struct bt_list_head *add, struct bt_list_head *head)
{
	/* Do nothing if the list which gets added is empty.  */
	if (add != add->next) {
		add->next->prev = head->prev;
		add->prev->next = head;
		head->prev->next = add->next;
		head->prev = add->prev;
	}
}

BT_HIDDEN
int yyparse(struct ctf_scanner *scanner, yyscan_t yyscanner);
BT_HIDDEN
int yylex(union YYSTYPE *yyval, yyscan_t yyscanner);
BT_HIDDEN
int yylex_init_extra(struct ctf_scanner *scanner, yyscan_t * ptr_yy_globals);
BT_HIDDEN
int yylex_destroy(yyscan_t yyscanner);
BT_HIDDEN
void yyrestart(FILE * in_str, yyscan_t yyscanner);
BT_HIDDEN
int yyget_lineno(yyscan_t yyscanner);
BT_HIDDEN
char *yyget_text(yyscan_t yyscanner);

static const char *node_type_to_str[] = {
#define ENTRY(S)	[S] = #S,
	FOREACH_CTF_NODES(ENTRY)
#undef ENTRY
};

/*
 * Static node for out of memory errors. Only "type" is used. lineno is
 * always left at 0. The rest of the node content can be overwritten,
 * but is never used.
 */
static struct ctf_node error_node = {
	.type = NODE_ERROR,
};

BT_HIDDEN
const char *node_type(struct ctf_node *node)
{
	if (node->type < NR_NODE_TYPES)
		return node_type_to_str[node->type];
	else
		return NULL;
}

void setstring(struct ctf_scanner *scanner, YYSTYPE *lvalp, const char *src)
{
	lvalp->s = objstack_alloc(scanner->objstack, strlen(src) + 1);
	strcpy(lvalp->s, src);
}

static
int str_check(size_t str_len, size_t offset, size_t len)
{
	/* check overflow */
	if (offset + len < offset)
		return -1;
	if (offset + len > str_len)
		return -1;
	return 0;
}

static
int bt_isodigit(int c)
{
	switch (c) {
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
		return 1;
	default:
		return 0;
	}
}

static
int parse_base_sequence(const char *src, size_t len, size_t pos,
		char *buffer, size_t *buf_len, int base)
{
	const size_t max_char = 3;
	int nr_char = 0;

	while (!str_check(len, pos, 1) && nr_char < max_char) {
		char c = src[pos++];

		if (base == 8) {
			if (bt_isodigit(c))
				buffer[nr_char++] = c;
			else
				break;
		} else if (base == 16) {
			if (isxdigit(c))
				buffer[nr_char++] = c;
			else
				break;

		} else {
			/* Unsupported base */
			return -1;
		}
	}
	assert(nr_char > 0);
	buffer[nr_char] = '\0';
	*buf_len = nr_char;
	return 0;
}

static
int import_basic_string(struct ctf_scanner *scanner, YYSTYPE *lvalp,
		size_t len, const char *src, char delim)
{
	size_t pos = 0, dpos = 0;

	if (str_check(len, pos, 1))
		return -1;
	if (src[pos++] != delim)
		return -1;

	while (src[pos] != delim) {
		char c;

		if (str_check(len, pos, 1))
			return -1;
		c = src[pos++];
		if (c == '\\') {
			if (str_check(len, pos, 1))
				return -1;
			c = src[pos++];

			switch (c) {
			case 'a':
				c = '\a';
				break;
			case 'b':
				c = '\b';
				break;
			case 'f':
				c = '\f';
				break;
			case 'n':
				c = '\n';
				break;
			case 'r':
				c = '\r';
				break;
			case 't':
				c = '\t';
				break;
			case 'v':
				c = '\v';
				break;
			case '\\':
				c = '\\';
				break;
			case '\'':
				c = '\'';
				break;
			case '\"':
				c = '\"';
				break;
			case '?':
				c = '?';
				break;
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			{
				char oct_buffer[4];
				size_t oct_len;

				if (parse_base_sequence(src, len, pos - 1,
						oct_buffer, &oct_len, 8))
					return -1;
				c = strtoul(&oct_buffer[0], NULL, 8);
				pos += oct_len - 1;
				break;
			}
			case 'x':
			{
				char hex_buffer[4];
				size_t hex_len;

				if (parse_base_sequence(src, len, pos,
						hex_buffer, &hex_len, 16))
					return -1;
				c = strtoul(&hex_buffer[0], NULL, 16);
				pos += hex_len;
				break;
			}
			default:
				return -1;
			}
		}
		if (str_check(len, dpos, 1))
			return -1;
		lvalp->s[dpos++] = c;
	}

	if (str_check(len, dpos, 1))
		return -1;
	lvalp->s[dpos++] = '\0';

	if (str_check(len, pos, 1))
		return -1;
	if (src[pos++] != delim)
		return -1;

	if (str_check(len, pos, 1))
		return -1;
	if (src[pos] != '\0')
		return -1;
	return 0;
}

int import_string(struct ctf_scanner *scanner, YYSTYPE *lvalp,
		const char *src, char delim)
{
	size_t len;

	len = strlen(src) + 1;
	lvalp->s = objstack_alloc(scanner->objstack, len);
	if (src[0] == 'L') {
		// TODO: import wide string
		printfl_error(yyget_lineno(scanner),
			"Wide string not supported yet.");
		return -1;
	} else {
		return import_basic_string(scanner, lvalp, len, src, delim);
	}
}

static void init_scope(struct ctf_scanner_scope *scope,
		       struct ctf_scanner_scope *parent)
{
	scope->parent = parent;
	scope->types = g_hash_table_new_full(g_str_hash, g_str_equal,
					     NULL, NULL);
}

static void finalize_scope(struct ctf_scanner_scope *scope)
{
	g_hash_table_destroy(scope->types);
}

static void push_scope(struct ctf_scanner *scanner)
{
	struct ctf_scanner_scope *ns;

	printf_debug("push scope\n");
	ns = malloc(sizeof(struct ctf_scanner_scope));
	init_scope(ns, scanner->cs);
	scanner->cs = ns;
}

static void pop_scope(struct ctf_scanner *scanner)
{
	struct ctf_scanner_scope *os;

	printf_debug("pop scope\n");
	os = scanner->cs;
	scanner->cs = os->parent;
	finalize_scope(os);
	free(os);
}

static int lookup_type(struct ctf_scanner_scope *s, const char *id)
{
	int ret;

	ret = (int) (long) g_hash_table_lookup(s->types, id);
	printf_debug("lookup %p %s %d\n", s, id, ret);
	return ret;
}

BT_HIDDEN
int is_type(struct ctf_scanner *scanner, const char *id)
{
	struct ctf_scanner_scope *it;
	int ret = 0;

	for (it = scanner->cs; it != NULL; it = it->parent) {
		if (lookup_type(it, id)) {
			ret = 1;
			break;
		}
	}
	printf_debug("is type %s %d\n", id, ret);
	return ret;
}

static void add_type(struct ctf_scanner *scanner, char *id)
{
	printf_debug("add type %s\n", id);
	if (lookup_type(scanner->cs, id))
		return;
	g_hash_table_insert(scanner->cs->types, id, id);
}

static struct ctf_node *make_node(struct ctf_scanner *scanner,
				  enum node_type type)
{
	struct ctf_node *node;

	node = objstack_alloc(scanner->objstack, sizeof(*node));
	if (!node) {
		printfl_fatal(yyget_lineno(scanner->scanner), "out of memory");
		return &error_node;
	}
	node->type = type;
	node->lineno = yyget_lineno(scanner->scanner);
	BT_INIT_LIST_HEAD(&node->tmp_head);
	bt_list_add(&node->siblings, &node->tmp_head);

	switch (type) {
	case NODE_ROOT:
		node->type = NODE_ERROR;
		printfn_fatal(node, "trying to create root node");
		break;

	case NODE_EVENT:
		BT_INIT_LIST_HEAD(&node->u.event.declaration_list);
		break;
	case NODE_STREAM:
		BT_INIT_LIST_HEAD(&node->u.stream.declaration_list);
		break;
	case NODE_ENV:
		BT_INIT_LIST_HEAD(&node->u.env.declaration_list);
		break;
	case NODE_TRACE:
		BT_INIT_LIST_HEAD(&node->u.trace.declaration_list);
		break;
	case NODE_CLOCK:
		BT_INIT_LIST_HEAD(&node->u.clock.declaration_list);
		break;
	case NODE_CALLSITE:
		BT_INIT_LIST_HEAD(&node->u.callsite.declaration_list);
		break;

	case NODE_CTF_EXPRESSION:
		BT_INIT_LIST_HEAD(&node->u.ctf_expression.left);
		BT_INIT_LIST_HEAD(&node->u.ctf_expression.right);
		break;
	case NODE_UNARY_EXPRESSION:
		break;

	case NODE_TYPEDEF:
		BT_INIT_LIST_HEAD(&node->u._typedef.type_declarators);
		break;
	case NODE_TYPEALIAS_TARGET:
		BT_INIT_LIST_HEAD(&node->u.typealias_target.type_declarators);
		break;
	case NODE_TYPEALIAS_ALIAS:
		BT_INIT_LIST_HEAD(&node->u.typealias_alias.type_declarators);
		break;
	case NODE_TYPEALIAS:
		break;

	case NODE_TYPE_SPECIFIER:
		break;
	case NODE_TYPE_SPECIFIER_LIST:
		BT_INIT_LIST_HEAD(&node->u.type_specifier_list.head);
		break;
	case NODE_POINTER:
		break;
	case NODE_TYPE_DECLARATOR:
		BT_INIT_LIST_HEAD(&node->u.type_declarator.pointers);
		break;

	case NODE_FLOATING_POINT:
		BT_INIT_LIST_HEAD(&node->u.floating_point.expressions);
		break;
	case NODE_INTEGER:
		BT_INIT_LIST_HEAD(&node->u.integer.expressions);
		break;
	case NODE_STRING:
		BT_INIT_LIST_HEAD(&node->u.string.expressions);
		break;
	case NODE_ENUMERATOR:
		BT_INIT_LIST_HEAD(&node->u.enumerator.values);
		break;
	case NODE_ENUM:
		BT_INIT_LIST_HEAD(&node->u._enum.enumerator_list);
		break;
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
		BT_INIT_LIST_HEAD(&node->u.struct_or_variant_declaration.type_declarators);
		break;
	case NODE_VARIANT:
		BT_INIT_LIST_HEAD(&node->u.variant.declaration_list);
		break;
	case NODE_STRUCT:
		BT_INIT_LIST_HEAD(&node->u._struct.declaration_list);
		BT_INIT_LIST_HEAD(&node->u._struct.min_align);
		break;

	case NODE_UNKNOWN:
	default:
		node->type = NODE_ERROR;
		printfn_fatal(node, "unknown node type '%d'", (int) type);
		break;
	}

	return node;
}

static int reparent_ctf_expression(struct ctf_node *node,
				   struct ctf_node *parent)
{
	switch (parent->type) {
	case NODE_EVENT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.event.declaration_list);
		break;
	case NODE_STREAM:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.stream.declaration_list);
		break;
	case NODE_ENV:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.env.declaration_list);
		break;
	case NODE_TRACE:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.trace.declaration_list);
		break;
	case NODE_CLOCK:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.clock.declaration_list);
		break;
	case NODE_CALLSITE:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.callsite.declaration_list);
		break;
	case NODE_FLOATING_POINT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.floating_point.expressions);
		break;
	case NODE_INTEGER:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.integer.expressions);
		break;
	case NODE_STRING:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.string.expressions);
		break;

	case NODE_ROOT:
	case NODE_CTF_EXPRESSION:
	case NODE_TYPEDEF:
	case NODE_TYPEALIAS_TARGET:
	case NODE_TYPEALIAS_ALIAS:
	case NODE_TYPEALIAS:
	case NODE_TYPE_SPECIFIER:
	case NODE_TYPE_SPECIFIER_LIST:
	case NODE_POINTER:
	case NODE_TYPE_DECLARATOR:
	case NODE_ENUMERATOR:
	case NODE_ENUM:
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
	case NODE_VARIANT:
	case NODE_STRUCT:
	case NODE_UNARY_EXPRESSION:
		return -EPERM;

	case NODE_UNKNOWN:
	default:
		printfn_fatal(node, "unknown node type '%d'", (int) parent->type);
		return -EINVAL;
	}
	return 0;
}

static int reparent_typedef(struct ctf_node *node, struct ctf_node *parent)
{
	switch (parent->type) {
	case NODE_ROOT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.root.declaration_list);
		break;
	case NODE_EVENT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.event.declaration_list);
		break;
	case NODE_STREAM:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.stream.declaration_list);
		break;
	case NODE_ENV:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.env.declaration_list);
		break;
	case NODE_TRACE:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.trace.declaration_list);
		break;
	case NODE_CLOCK:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.clock.declaration_list);
		break;
	case NODE_CALLSITE:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.callsite.declaration_list);
		break;
	case NODE_VARIANT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.variant.declaration_list);
		break;
	case NODE_STRUCT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u._struct.declaration_list);
		break;

	case NODE_FLOATING_POINT:
	case NODE_INTEGER:
	case NODE_STRING:
	case NODE_CTF_EXPRESSION:
	case NODE_TYPEDEF:
	case NODE_TYPEALIAS_TARGET:
	case NODE_TYPEALIAS_ALIAS:
	case NODE_TYPEALIAS:
	case NODE_TYPE_SPECIFIER:
	case NODE_TYPE_SPECIFIER_LIST:
	case NODE_POINTER:
	case NODE_TYPE_DECLARATOR:
	case NODE_ENUMERATOR:
	case NODE_ENUM:
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
	case NODE_UNARY_EXPRESSION:
		return -EPERM;

	case NODE_UNKNOWN:
	default:
		printfn_fatal(node, "unknown node type %d", parent->type);
		return -EINVAL;
	}
	return 0;
}

static int reparent_typealias(struct ctf_node *node, struct ctf_node *parent)
{
	switch (parent->type) {
	case NODE_ROOT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.root.declaration_list);
		break;
	case NODE_EVENT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.event.declaration_list);
		break;
	case NODE_STREAM:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.stream.declaration_list);
		break;
	case NODE_ENV:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.env.declaration_list);
		break;
	case NODE_TRACE:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.trace.declaration_list);
		break;
	case NODE_CLOCK:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.clock.declaration_list);
		break;
	case NODE_CALLSITE:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.callsite.declaration_list);
		break;
	case NODE_VARIANT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.variant.declaration_list);
		break;
	case NODE_STRUCT:
		_bt_list_splice_tail(&node->tmp_head, &parent->u._struct.declaration_list);
		break;

	case NODE_FLOATING_POINT:
	case NODE_INTEGER:
	case NODE_STRING:
	case NODE_CTF_EXPRESSION:
	case NODE_TYPEDEF:
	case NODE_TYPEALIAS_TARGET:
	case NODE_TYPEALIAS_ALIAS:
	case NODE_TYPEALIAS:
	case NODE_TYPE_SPECIFIER:
	case NODE_TYPE_SPECIFIER_LIST:
	case NODE_POINTER:
	case NODE_TYPE_DECLARATOR:
	case NODE_ENUMERATOR:
	case NODE_ENUM:
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
	case NODE_UNARY_EXPRESSION:
		return -EPERM;

	case NODE_UNKNOWN:
	default:
		printfn_fatal(node, "unknown node type '%d'", (int) parent->type);
		return -EINVAL;
	}
	return 0;
}

static int reparent_type_specifier(struct ctf_node *node,
				   struct ctf_node *parent)
{
	switch (parent->type) {
	case NODE_TYPE_SPECIFIER_LIST:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.type_specifier_list.head);
		break;

	case NODE_TYPE_SPECIFIER:
	case NODE_EVENT:
	case NODE_STREAM:
	case NODE_ENV:
	case NODE_TRACE:
	case NODE_CLOCK:
	case NODE_CALLSITE:
	case NODE_VARIANT:
	case NODE_STRUCT:
	case NODE_TYPEDEF:
	case NODE_TYPEALIAS_TARGET:
	case NODE_TYPEALIAS_ALIAS:
	case NODE_TYPE_DECLARATOR:
	case NODE_ENUM:
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
	case NODE_TYPEALIAS:
	case NODE_FLOATING_POINT:
	case NODE_INTEGER:
	case NODE_STRING:
	case NODE_CTF_EXPRESSION:
	case NODE_POINTER:
	case NODE_ENUMERATOR:
	case NODE_UNARY_EXPRESSION:
		return -EPERM;

	case NODE_UNKNOWN:
	default:
		printfn_fatal(node, "unknown node type '%d'", (int) parent->type);
		return -EINVAL;
	}
	return 0;
}

static int reparent_type_specifier_list(struct ctf_node *node,
					struct ctf_node *parent)
{
	switch (parent->type) {
	case NODE_ROOT:
		bt_list_add_tail(&node->siblings, &parent->u.root.declaration_list);
		break;
	case NODE_EVENT:
		bt_list_add_tail(&node->siblings, &parent->u.event.declaration_list);
		break;
	case NODE_STREAM:
		bt_list_add_tail(&node->siblings, &parent->u.stream.declaration_list);
		break;
	case NODE_ENV:
		bt_list_add_tail(&node->siblings, &parent->u.env.declaration_list);
		break;
	case NODE_TRACE:
		bt_list_add_tail(&node->siblings, &parent->u.trace.declaration_list);
		break;
	case NODE_CLOCK:
		bt_list_add_tail(&node->siblings, &parent->u.clock.declaration_list);
		break;
	case NODE_CALLSITE:
		bt_list_add_tail(&node->siblings, &parent->u.callsite.declaration_list);
		break;
	case NODE_VARIANT:
		bt_list_add_tail(&node->siblings, &parent->u.variant.declaration_list);
		break;
	case NODE_STRUCT:
		bt_list_add_tail(&node->siblings, &parent->u._struct.declaration_list);
		break;
	case NODE_TYPEDEF:
		parent->u._typedef.type_specifier_list = node;
		break;
	case NODE_TYPEALIAS_TARGET:
		parent->u.typealias_target.type_specifier_list = node;
		break;
	case NODE_TYPEALIAS_ALIAS:
		parent->u.typealias_alias.type_specifier_list = node;
		break;
	case NODE_ENUM:
		parent->u._enum.container_type = node;
		break;
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
		parent->u.struct_or_variant_declaration.type_specifier_list = node;
		break;
	case NODE_TYPE_DECLARATOR:
	case NODE_TYPE_SPECIFIER:
	case NODE_TYPEALIAS:
	case NODE_FLOATING_POINT:
	case NODE_INTEGER:
	case NODE_STRING:
	case NODE_CTF_EXPRESSION:
	case NODE_POINTER:
	case NODE_ENUMERATOR:
	case NODE_UNARY_EXPRESSION:
		return -EPERM;

	case NODE_UNKNOWN:
	default:
		printfn_fatal(node, "unknown node type '%d'", (int) parent->type);
		return -EINVAL;
	}
	return 0;
}

static int reparent_type_declarator(struct ctf_node *node,
				    struct ctf_node *parent)
{
	switch (parent->type) {
	case NODE_TYPE_DECLARATOR:
		parent->u.type_declarator.type = TYPEDEC_NESTED;
		parent->u.type_declarator.u.nested.type_declarator = node;
		break;
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.struct_or_variant_declaration.type_declarators);
		break;
	case NODE_TYPEDEF:
		_bt_list_splice_tail(&node->tmp_head, &parent->u._typedef.type_declarators);
		break;
	case NODE_TYPEALIAS_TARGET:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.typealias_target.type_declarators);
		break;
	case NODE_TYPEALIAS_ALIAS:
		_bt_list_splice_tail(&node->tmp_head, &parent->u.typealias_alias.type_declarators);
		break;

	case NODE_ROOT:
	case NODE_EVENT:
	case NODE_STREAM:
	case NODE_ENV:
	case NODE_TRACE:
	case NODE_CLOCK:
	case NODE_CALLSITE:
	case NODE_VARIANT:
	case NODE_STRUCT:
	case NODE_TYPEALIAS:
	case NODE_ENUM:
	case NODE_FLOATING_POINT:
	case NODE_INTEGER:
	case NODE_STRING:
	case NODE_CTF_EXPRESSION:
	case NODE_TYPE_SPECIFIER:
	case NODE_TYPE_SPECIFIER_LIST:
	case NODE_POINTER:
	case NODE_ENUMERATOR:
	case NODE_UNARY_EXPRESSION:
		return -EPERM;

	case NODE_UNKNOWN:
	default:
		printfn_fatal(node, "unknown node type '%d'", (int) parent->type);
		return -EINVAL;
	}
	return 0;
}

/*
 * set_parent_node
 *
 * Link node to parent. Returns 0 on success, -EPERM if it is not permitted to
 * create the link declared by the input, -ENOENT if node or parent is NULL,
 * -EINVAL if there is an internal structure problem.
 */
static int set_parent_node(struct ctf_node *node,
			 struct ctf_node *parent)
{
	if (!node || !parent)
		return -ENOENT;

	/* Note: Linking to parent will be done only by an external visitor */

	switch (node->type) {
	case NODE_ROOT:
		printfn_fatal(node, "trying to reparent root node");
		return -EINVAL;

	case NODE_EVENT:
		if (parent->type == NODE_ROOT) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u.root.event);
		} else {
			return -EPERM;
		}
		break;
	case NODE_STREAM:
		if (parent->type == NODE_ROOT) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u.root.stream);
		} else {
			return -EPERM;
		}
		break;
	case NODE_ENV:
		if (parent->type == NODE_ROOT) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u.root.env);
		} else {
			return -EPERM;
		}
		break;
	case NODE_TRACE:
		if (parent->type == NODE_ROOT) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u.root.trace);
		} else {
			return -EPERM;
		}
		break;
	case NODE_CLOCK:
		if (parent->type == NODE_ROOT) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u.root.clock);
		} else {
			return -EPERM;
		}
		break;
	case NODE_CALLSITE:
		if (parent->type == NODE_ROOT) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u.root.callsite);
		} else {
			return -EPERM;
		}
		break;

	case NODE_CTF_EXPRESSION:
		return reparent_ctf_expression(node, parent);
	case NODE_UNARY_EXPRESSION:
		if (parent->type == NODE_TYPE_DECLARATOR)
			parent->u.type_declarator.bitfield_len = node;
		else
			return -EPERM;
		break;

	case NODE_TYPEDEF:
		return reparent_typedef(node, parent);
	case NODE_TYPEALIAS_TARGET:
		if (parent->type == NODE_TYPEALIAS)
			parent->u.typealias.target = node;
		else
			return -EINVAL;
	case NODE_TYPEALIAS_ALIAS:
		if (parent->type == NODE_TYPEALIAS)
			parent->u.typealias.alias = node;
		else
			return -EINVAL;
	case NODE_TYPEALIAS:
		return reparent_typealias(node, parent);

	case NODE_POINTER:
		if (parent->type == NODE_TYPE_DECLARATOR) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u.type_declarator.pointers);
		} else
			return -EPERM;
		break;
	case NODE_TYPE_DECLARATOR:
		return reparent_type_declarator(node, parent);

	case NODE_TYPE_SPECIFIER_LIST:
		return reparent_type_specifier_list(node, parent);

	case NODE_TYPE_SPECIFIER:
		return reparent_type_specifier(node, parent);

	case NODE_FLOATING_POINT:
	case NODE_INTEGER:
	case NODE_STRING:
	case NODE_ENUM:
	case NODE_VARIANT:
	case NODE_STRUCT:
		return -EINVAL;	/* Dealt with internally within grammar */

	case NODE_ENUMERATOR:
		if (parent->type == NODE_ENUM) {
			_bt_list_splice_tail(&node->tmp_head, &parent->u._enum.enumerator_list);
		} else {
			return -EPERM;
		}
		break;
	case NODE_STRUCT_OR_VARIANT_DECLARATION:
		switch (parent->type) {
		case NODE_STRUCT:
			_bt_list_splice_tail(&node->tmp_head, &parent->u._struct.declaration_list);
			break;
		case NODE_VARIANT:
			_bt_list_splice_tail(&node->tmp_head, &parent->u.variant.declaration_list);
			break;
		default:
			return -EINVAL;
		}
		break;

	case NODE_UNKNOWN:
	default:
		printfn_fatal(node, "unknown node type '%d'", (int) parent->type);
		return -EINVAL;
	}
	return 0;
}

BT_HIDDEN
void yyerror(struct ctf_scanner *scanner, yyscan_t yyscanner, const char *str)
{
	printfl_error(yyget_lineno(scanner->scanner),
		"token \"%s\": %s\n",
		yyget_text(scanner->scanner), str);
}
 
BT_HIDDEN
int yywrap(void)
{
	return 1;
} 

#define reparent_error(scanner, str)				\
do {								\
	yyerror(scanner, scanner->scanner, YY_("reparent_error: " str)); \
	YYERROR;						\
} while (0)

static struct ctf_ast *ctf_ast_alloc(struct ctf_scanner *scanner)
{
	struct ctf_ast *ast;

	ast = objstack_alloc(scanner->objstack, sizeof(*ast));
	if (!ast)
		return NULL;
	ast->root.type = NODE_ROOT;
	BT_INIT_LIST_HEAD(&ast->root.tmp_head);
	BT_INIT_LIST_HEAD(&ast->root.u.root.declaration_list);
	BT_INIT_LIST_HEAD(&ast->root.u.root.trace);
	BT_INIT_LIST_HEAD(&ast->root.u.root.env);
	BT_INIT_LIST_HEAD(&ast->root.u.root.stream);
	BT_INIT_LIST_HEAD(&ast->root.u.root.event);
	BT_INIT_LIST_HEAD(&ast->root.u.root.clock);
	BT_INIT_LIST_HEAD(&ast->root.u.root.callsite);
	return ast;
}

int ctf_scanner_append_ast(struct ctf_scanner *scanner, FILE *input)
{
	/* Start processing new stream */
	yyrestart(input, scanner->scanner);
	if (yydebug)
		fprintf(stdout, "Scanner input is a%s.\n",
			isatty(fileno(input)) ? "n interactive tty" :
						" noninteractive file");
	return yyparse(scanner, scanner->scanner);
}

struct ctf_scanner *ctf_scanner_alloc(void)
{
	struct ctf_scanner *scanner;
	int ret;

	yydebug = babeltrace_debug;

	scanner = malloc(sizeof(*scanner));
	if (!scanner)
		return NULL;
	memset(scanner, 0, sizeof(*scanner));
	ret = yylex_init_extra(scanner, &scanner->scanner);
	if (ret) {
		printf_fatal("yylex_init error");
		goto cleanup_scanner;
	}
	scanner->objstack = objstack_create();
	if (!scanner->objstack)
		goto cleanup_lexer;
	scanner->ast = ctf_ast_alloc(scanner);
	if (!scanner->ast)
		goto cleanup_objstack;
	init_scope(&scanner->root_scope, NULL);
	scanner->cs = &scanner->root_scope;

	return scanner;

cleanup_objstack:
	objstack_destroy(scanner->objstack);
cleanup_lexer:
	ret = yylex_destroy(scanner->scanner);
	if (!ret)
		printf_fatal("yylex_destroy error");
cleanup_scanner:
	free(scanner);
	return NULL;
}

void ctf_scanner_free(struct ctf_scanner *scanner)
{
	int ret;

	if (!scanner)
		return;
	finalize_scope(&scanner->root_scope);
	objstack_destroy(scanner->objstack);
	ret = yylex_destroy(scanner->scanner);
	if (ret)
		printf_error("yylex_destroy error");
	free(scanner);
}


#line 1105 "ctf-parser.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 1
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_CTF_PARSER_H_INCLUDED
# define YY_YY_CTF_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INTEGER_LITERAL = 258,
    STRING_LITERAL = 259,
    CHARACTER_LITERAL = 260,
    LSBRAC = 261,
    RSBRAC = 262,
    LPAREN = 263,
    RPAREN = 264,
    LBRAC = 265,
    RBRAC = 266,
    RARROW = 267,
    STAR = 268,
    PLUS = 269,
    MINUS = 270,
    LT = 271,
    GT = 272,
    TYPEASSIGN = 273,
    COLON = 274,
    SEMICOLON = 275,
    DOTDOTDOT = 276,
    DOT = 277,
    EQUAL = 278,
    COMMA = 279,
    CONST = 280,
    CHAR = 281,
    DOUBLE = 282,
    ENUM = 283,
    ENV = 284,
    EVENT = 285,
    FLOATING_POINT = 286,
    FLOAT = 287,
    INTEGER = 288,
    INT = 289,
    LONG = 290,
    SHORT = 291,
    SIGNED = 292,
    STREAM = 293,
    STRING = 294,
    STRUCT = 295,
    TRACE = 296,
    CALLSITE = 297,
    CLOCK = 298,
    TYPEALIAS = 299,
    TYPEDEF = 300,
    UNSIGNED = 301,
    VARIANT = 302,
    VOID = 303,
    _BOOL = 304,
    _COMPLEX = 305,
    _IMAGINARY = 306,
    TOK_ALIGN = 307,
    IDENTIFIER = 308,
    ID_TYPE = 309,
    ERROR = 310
  };
#endif
/* Tokens.  */
#define INTEGER_LITERAL 258
#define STRING_LITERAL 259
#define CHARACTER_LITERAL 260
#define LSBRAC 261
#define RSBRAC 262
#define LPAREN 263
#define RPAREN 264
#define LBRAC 265
#define RBRAC 266
#define RARROW 267
#define STAR 268
#define PLUS 269
#define MINUS 270
#define LT 271
#define GT 272
#define TYPEASSIGN 273
#define COLON 274
#define SEMICOLON 275
#define DOTDOTDOT 276
#define DOT 277
#define EQUAL 278
#define COMMA 279
#define CONST 280
#define CHAR 281
#define DOUBLE 282
#define ENUM 283
#define ENV 284
#define EVENT 285
#define FLOATING_POINT 286
#define FLOAT 287
#define INTEGER 288
#define INT 289
#define LONG 290
#define SHORT 291
#define SIGNED 292
#define STREAM 293
#define STRING 294
#define STRUCT 295
#define TRACE 296
#define CALLSITE 297
#define CLOCK 298
#define TYPEALIAS 299
#define TYPEDEF 300
#define UNSIGNED 301
#define VARIANT 302
#define VOID 303
#define _BOOL 304
#define _COMPLEX 305
#define _IMAGINARY 306
#define TOK_ALIGN 307
#define IDENTIFIER 308
#define ID_TYPE 309
#define ERROR 310

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 1060 "ctf-parser.y" /* yacc.c:355  */

	long long ll;
	unsigned long long ull;
	char c;
	char *s;
	struct ctf_node *n;

#line 1263 "ctf-parser.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif



int yyparse (struct ctf_scanner *scanner, yyscan_t yyscanner);

#endif /* !YY_YY_CTF_PARSER_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 1279 "ctf-parser.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  72
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   2199

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  56
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  58
/* YYNRULES -- Number of rules.  */
#define YYNRULES  233
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  444

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   310

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,  1115,  1115,  1120,  1128,  1130,  1132,  1134,  1136,  1138,
    1140,  1142,  1144,  1146,  1148,  1150,  1152,  1154,  1156,  1158,
    1160,  1162,  1164,  1166,  1168,  1170,  1172,  1174,  1176,  1178,
    1180,  1188,  1194,  1200,  1206,  1212,  1218,  1224,  1228,  1236,
    1245,  1254,  1263,  1272,  1284,  1286,  1294,  1311,  1317,  1324,
    1326,  1328,  1330,  1332,  1334,  1336,  1338,  1349,  1359,  1369,
    1390,  1394,  1403,  1408,  1414,  1418,  1427,  1432,  1437,  1441,
    1450,  1455,  1460,  1464,  1473,  1478,  1483,  1487,  1496,  1501,
    1506,  1510,  1519,  1524,  1529,  1538,  1546,  1555,  1563,  1572,
    1580,  1589,  1597,  1599,  1607,  1612,  1617,  1622,  1627,  1632,
    1637,  1642,  1648,  1654,  1665,  1670,  1675,  1680,  1685,  1690,
    1695,  1700,  1705,  1710,  1715,  1720,  1725,  1731,  1737,  1745,
    1751,  1759,  1765,  1771,  1779,  1785,  1791,  1800,  1807,  1815,
    1823,  1829,  1835,  1843,  1852,  1864,  1869,  1874,  1881,  1889,
    1897,  1905,  1914,  1921,  1930,  1937,  1945,  1954,  1961,  1970,
    1980,  1985,  1990,  1996,  2003,  2010,  2018,  2025,  2033,  2039,
    2046,  2053,  2061,  2067,  2074,  2082,  2092,  2093,  2106,  2116,
    2127,  2137,  2147,  2168,  2177,  2185,  2196,  2205,  2210,  2224,
    2226,  2234,  2236,  2238,  2247,  2249,  2257,  2262,  2267,  2272,
    2277,  2283,  2289,  2295,  2304,  2306,  2314,  2316,  2325,  2330,
    2336,  2342,  2350,  2360,  2362,  2370,  2372,  2381,  2386,  2392,
    2400,  2410,  2412,  2420,  2426,  2432,  2443,  2445,  2453,  2460,
    2466,  2477,  2481,  2486,  2496,  2497,  2503,  2505,  2513,  2525,
    2537,  2548,  2558,  2568
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INTEGER_LITERAL", "STRING_LITERAL",
  "CHARACTER_LITERAL", "LSBRAC", "RSBRAC", "LPAREN", "RPAREN", "LBRAC",
  "RBRAC", "RARROW", "STAR", "PLUS", "MINUS", "LT", "GT", "TYPEASSIGN",
  "COLON", "SEMICOLON", "DOTDOTDOT", "DOT", "EQUAL", "COMMA", "CONST",
  "CHAR", "DOUBLE", "ENUM", "ENV", "EVENT", "FLOATING_POINT", "FLOAT",
  "INTEGER", "INT", "LONG", "SHORT", "SIGNED", "STREAM", "STRING",
  "STRUCT", "TRACE", "CALLSITE", "CLOCK", "TYPEALIAS", "TYPEDEF",
  "UNSIGNED", "VARIANT", "VOID", "_BOOL", "_COMPLEX", "_IMAGINARY",
  "TOK_ALIGN", "IDENTIFIER", "ID_TYPE", "ERROR", "$accept", "file",
  "keywords", "postfix_expression", "unary_expression",
  "unary_expression_or_range", "declaration", "event_declaration",
  "event_declaration_begin", "event_declaration_end", "stream_declaration",
  "stream_declaration_begin", "stream_declaration_end", "env_declaration",
  "env_declaration_begin", "env_declaration_end", "trace_declaration",
  "trace_declaration_begin", "trace_declaration_end", "clock_declaration",
  "clock_declaration_begin", "clock_declaration_end",
  "callsite_declaration", "callsite_declaration_begin",
  "callsite_declaration_end", "integer_declaration_specifiers",
  "declaration_specifiers", "type_declarator_list",
  "integer_type_specifier", "type_specifier", "struct_type_specifier",
  "struct_declaration_begin", "struct_declaration_end",
  "variant_type_specifier", "variant_declaration_begin",
  "variant_declaration_end", "enum_type_specifier",
  "struct_or_variant_declaration_list", "struct_or_variant_declaration",
  "alias_declaration_specifiers", "struct_or_variant_declarator_list",
  "struct_or_variant_declarator", "enumerator_list", "enumerator",
  "abstract_declarator_list", "abstract_declarator",
  "direct_abstract_declarator", "alias_abstract_declarator_list",
  "alias_abstract_declarator", "direct_alias_abstract_declarator",
  "declarator", "direct_declarator", "type_declarator",
  "direct_type_declarator", "pointer", "type_qualifier_list",
  "ctf_assignment_expression_list", "ctf_assignment_expression", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310
};
# endif

#define YYPACT_NINF -363

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-363)))

#define YYTABLE_NINF -33

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    1998,  -363,  -363,  -363,    45,    22,    92,    94,  -363,   146,
    -363,  -363,  -363,  -363,   165,   194,    59,   204,   207,   228,
    2088,  2088,  -363,    57,  -363,  -363,  -363,  -363,  -363,   397,
    -363,  -363,   449,  -363,   501,  -363,   553,  -363,   605,  -363,
    -363,  1938,  -363,  1679,  2145,    75,   150,  -363,  -363,  -363,
     657,   709,  -363,   761,  -363,   241,   241,  -363,  -363,  -363,
    -363,   813,  -363,   865,  1756,  1786,  -363,    66,    47,   145,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,  1281,    19,  1333,
    1333,   116,   218,   253,    45,  -363,  -363,    94,   305,   146,
     354,   387,   394,   443,  -363,   209,    59,  -363,  -363,  -363,
    2088,  2088,   450,    57,   502,   554,   606,   658,  -363,  -363,
     710,  -363,   131,    60,  -363,  2028,   449,   205,   234,  -363,
     501,   236,  -363,   553,   238,  -363,   605,  -363,  -363,  1816,
    -363,    30,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  -363,
    -363,  -363,   240,   243,   247,    48,  -363,  -363,  -363,   251,
    -363,  -363,  -363,  -363,  -363,  -363,  -363,    81,  -363,  1679,
    2145,  1679,  2145,  -363,   917,  -363,   969,  -363,  1021,  -363,
    -363,  1876,   252,  -363,   813,   254,  -363,   865,    35,    29,
    -363,   152,  -363,    54,     9,    36,  -363,   121,  -363,   271,
      39,   267,   274,   113,  -363,   132,  -363,  1906,  -363,   283,
    -363,   131,   131,  1756,  1786,  1281,   143,  1968,  2088,  1281,
    1816,  -363,   273,  -363,  -363,  -363,  -363,  -363,  -363,  -363,
    1786,   178,  1281,  1281,  1281,  1281,  -363,  1384,  1073,  1679,
    -363,  -363,    50,   300,    97,   349,  -363,  -363,  -363,  1876,
    1876,  -363,  2088,  2088,  1726,   246,  -363,  -363,  -363,  -363,
    -363,   286,  -363,  -363,   139,  2058,    35,  1177,    54,   292,
    -363,    36,  1281,   271,   294,   294,   289,   290,  1906,   291,
     299,  1906,  -363,  -363,  -363,   166,   295,   311,  -363,  -363,
    -363,  -363,  -363,  2118,  -363,  1786,   295,  -363,   185,  -363,
     303,  -363,  -363,  -363,  -363,  -363,  -363,  -363,  1125,   112,
    -363,  1435,  1679,  -363,  1486,  1679,   269,   279,  1756,  1786,
      37,  1281,  1816,  -363,   192,  -363,   313,   335,    43,   339,
    -363,  -363,  -363,  -363,  -363,  -363,  1846,  -363,  -363,   341,
    -363,  -363,   344,  -363,  -363,   294,   294,  -363,   294,   294,
    -363,  2058,  -363,   295,  -363,  1281,  -363,  -363,  1537,  -363,
     120,  -363,   138,   347,   348,   169,   202,   343,  -363,  1786,
     213,  -363,    33,  1281,  1281,   335,  1281,   181,  -363,  -363,
    -363,   215,  -363,   351,   350,  -363,  -363,  1906,  1906,  -363,
    -363,  -363,  -363,  1846,  -363,  -363,  -363,  1588,  -363,  1639,
    1281,  1281,  2058,  -363,  -363,   223,  -363,  -363,  -363,   356,
     352,   358,  -363,   181,  1229,   351,  -363,  -363,  1906,  1906,
    1906,  1906,   345,  -363,  -363,   364,   369,  1846,  -363,  -363,
    -363,  -363,  -363,  -363,   372,  -363,  -363,  -363,  -363,  -363,
    -363,   224,  -363,  -363
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,    88,   105,   110,     0,     0,     0,     0,   109,     0,
     107,   108,   106,   111,     0,   121,     0,     0,     0,     0,
       0,     0,   112,     0,   104,   113,   114,   115,   116,     0,
       2,    50,     0,    51,     0,    52,     0,    53,     0,    54,
      55,     0,    89,     0,     0,   162,   165,   124,    70,    62,
       0,     0,    66,     0,   135,   130,   131,   126,   166,    74,
      82,     0,    78,     0,   198,     0,   150,     0,     0,     0,
     125,   166,     1,     3,    34,    35,    36,     0,     0,     0,
       0,    88,   105,   110,    19,    26,    24,    16,   109,    17,
     107,   108,   106,   111,    25,   121,    21,    27,    29,    28,
       0,    23,   112,    20,   104,   113,   114,   115,    30,    31,
     116,    33,    44,     0,    60,     0,     0,     0,     0,    64,
       0,     0,    68,     0,     0,    72,     0,    49,    90,     0,
      91,   189,    22,     5,    10,    19,    16,     9,    17,     7,
       8,     6,    11,    18,    21,    23,    12,    20,     4,    13,
      14,    15,   186,   187,   188,     0,   184,    84,    94,     0,
      96,    97,    95,    98,    99,   100,   101,     0,    85,     0,
       0,     0,     0,   117,     0,   119,     0,   122,     0,   166,
     166,     0,     0,    80,     0,     0,    76,     0,   198,   221,
     199,     0,   194,   196,   198,     0,   218,     0,    92,   216,
       0,     0,     0,     0,   166,     0,   166,     0,    32,     0,
      63,    45,    46,   198,     0,     0,     0,     0,     0,     0,
       0,    61,     0,   226,    67,    65,    71,    69,    75,    73,
       0,     0,     0,     0,     0,     0,   152,     0,     0,     0,
      86,    87,     0,     0,     0,     0,   118,   120,   123,     0,
       0,   136,     0,     0,     0,   127,   167,    83,    81,    79,
      77,     0,   224,   222,     0,     0,   198,     0,   197,     0,
      57,     0,     0,   217,     0,     0,     0,     0,     0,     0,
       0,     0,   151,   137,    37,     0,   231,     0,    42,    43,
      39,    40,    41,   229,   228,     0,   232,   227,     0,    58,
      48,   193,   190,   191,   192,   158,   185,   102,     0,     0,
     154,     0,     0,   156,     0,     0,   128,   129,   198,     0,
       0,     0,     0,   213,     0,   179,   181,   211,     0,     0,
     200,   225,   223,   173,   175,   174,   207,   195,   202,     0,
     219,    93,     0,   166,   166,   142,   144,   140,   147,   149,
     145,     0,    38,   230,    56,     0,   103,   153,     0,   160,
       0,   163,     0,     0,     0,     0,     0,     0,   182,     0,
       0,   168,     0,     0,     0,   212,     0,   207,   176,   178,
     177,     0,   203,   205,   207,   201,   220,     0,     0,   166,
     166,   166,   166,   207,    47,   159,   155,     0,   157,     0,
       0,     0,     0,   170,   214,     0,   171,   180,   183,     0,
       0,     0,    59,   207,     0,   206,   138,   139,     0,     0,
       0,     0,   233,   161,   164,     0,     0,   207,   169,   215,
     132,   208,   204,   210,     0,   141,   143,   146,   148,   133,
     134,     0,   209,   172
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -363,  -363,   -29,   200,   -61,    34,   336,  -363,  -363,   264,
    -363,  -363,   261,  -363,  -363,   266,  -363,  -363,   265,  -363,
    -363,   203,  -363,  -363,   208,  -114,     0,  -127,  -148,   -31,
    -363,   190,    40,  -363,   -46,  -241,  -363,   -47,  -363,  -321,
    -363,    32,  -164,  -234,  -209,  -161,   214,  -362,  -342,    10,
      82,    73,  -189,   211,   -63,  -363,   -25,  -108
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    29,   111,   112,   113,   301,    30,    31,    32,   114,
      33,    34,   119,    35,    36,   122,    37,    38,   125,    39,
      63,   186,    40,    61,   183,   167,   115,   197,   168,    42,
      57,    58,   255,    70,    71,   283,    47,   181,   256,   336,
     324,   325,   155,   156,   191,   192,   193,   381,   382,   383,
     326,   327,   198,   199,   200,   264,   116,   117
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      41,   194,   231,   306,   285,   242,   269,   244,   222,   120,
     130,   123,   222,   126,   154,   222,   209,   188,   222,   241,
      64,    65,   204,   206,   207,   174,   176,   261,   178,    41,
     393,   422,    48,   130,   130,   411,   184,   347,   187,   210,
     350,   320,   189,   188,   195,   320,   189,   195,   189,   189,
     189,   320,   321,   232,   262,    43,   243,    66,   245,   236,
     267,   310,   190,   203,    44,   441,   222,    66,   222,    54,
     222,   432,   237,    67,   311,   309,   222,   306,   218,   222,
     306,   427,   341,   219,   130,   169,   323,   286,   190,   196,
     323,   239,   196,   296,   170,   241,   323,   241,    45,    46,
     213,   214,    49,   298,    50,   337,   240,   158,   313,   365,
      68,    69,    55,    56,   159,   160,   161,   162,   163,   201,
     202,   314,   -22,   357,   306,   194,   263,   164,   -22,   230,
     165,   396,   249,   250,   -22,   166,   358,   215,   -22,   -22,
     154,   270,   154,   216,   397,   271,   416,   417,   360,   398,
     194,   362,   189,   217,   287,    66,    51,   278,   294,   281,
     171,   205,   399,   306,   331,   306,   276,   277,   353,   172,
     265,   300,   300,   300,   300,    52,   266,   435,   436,   437,
     438,   254,   130,   130,   351,   279,   280,   402,   292,   377,
     266,   328,   366,   266,   189,   370,   288,   289,   299,   130,
     222,   332,   271,   194,    53,   354,   339,   254,   154,   271,
     154,   342,   371,   308,    59,   -18,   372,    60,   293,    53,
     295,   -18,   403,   130,    -5,   223,   271,   -18,   343,   344,
      -5,   -18,   -18,   406,   335,   412,    -5,   271,    62,   413,
      -5,    -5,   405,   428,   443,   179,   180,   271,   413,   254,
     254,    54,   318,   319,   224,   194,   226,   328,   228,   -10,
     368,   238,   130,   233,   130,   -10,   234,   302,   303,   304,
     235,   -10,   257,   384,   259,   -10,   -10,   272,   254,   211,
     212,   254,   154,   154,   274,   154,   154,   130,   130,   316,
     317,   275,   284,   297,   394,   330,   387,   388,   329,   389,
     390,   340,   391,   392,    66,   380,   345,   346,   348,   328,
     312,    -9,   408,   409,   384,   410,   349,    -9,   352,   271,
     335,   363,   369,    -9,   355,   240,   158,    -9,    -9,   154,
     384,   364,   373,   159,   160,   161,   162,   163,   130,   425,
     426,   374,   418,   419,   420,   421,   164,   376,   385,   165,
     384,   386,   404,   434,   166,   400,   401,   414,   377,   315,
      -7,   430,   380,   429,   384,    73,    -7,   431,   154,   413,
     154,   335,    -7,   439,   240,   158,    -7,    -7,   440,   442,
     221,   225,   159,   160,   161,   162,   163,   254,   254,   227,
     260,   229,   258,    -8,   415,   164,   380,    72,   165,    -8,
      -6,   375,   367,   166,   407,    -8,    -6,     0,   268,    -8,
      -8,   273,    -6,     0,     0,     0,    -6,    -6,   254,   254,
     254,   254,     1,     2,     3,     4,     5,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,   -11,
       0,    28,    74,    75,    76,   -11,   -12,    77,     0,     0,
      78,   -11,   -12,    79,    80,   -11,   -11,     0,   -12,     0,
       0,     0,   -12,   -12,    81,    82,    83,    84,    85,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,    74,    75,    76,     0,    -4,    77,
       0,     0,   118,     0,    -4,    79,    80,     0,     0,     0,
      -4,     0,     0,     0,    -4,    -4,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,    74,    75,    76,     0,
     -13,    77,     0,     0,   121,     0,   -13,    79,    80,     0,
       0,     0,   -13,     0,     0,     0,   -13,   -13,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,    74,    75,
      76,     0,   -14,    77,     0,     0,   124,     0,   -14,    79,
      80,     0,     0,     0,   -14,     0,     0,     0,   -14,   -14,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
      74,    75,    76,     0,   -15,    77,     0,     0,   173,     0,
     -15,    79,    80,     0,     0,     0,   -15,     0,     0,     0,
     -15,   -15,    81,    82,    83,    84,    85,    86,    87,    88,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,    74,    75,    76,     0,   -32,    77,     0,     0,
     175,     0,   -32,    79,    80,     0,     0,     0,   -32,     0,
       0,     0,   -32,   -32,    81,    82,    83,    84,    85,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,    74,    75,    76,     0,     0,    77,
       0,     0,   177,     0,     0,    79,    80,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,    74,    75,    76,     0,
       0,    77,     0,     0,   182,     0,     0,    79,    80,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,    74,    75,
      76,     0,     0,    77,     0,     0,   185,     0,     0,    79,
      80,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
      74,    75,    76,     0,     0,    77,     0,     0,   246,     0,
       0,    79,    80,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    81,    82,    83,    84,    85,    86,    87,    88,
      89,    90,    91,    92,    93,    94,    95,    96,    97,    98,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     109,   110,    74,    75,    76,     0,     0,    77,     0,     0,
     247,     0,     0,    79,    80,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    81,    82,    83,    84,    85,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   109,   110,    74,    75,    76,     0,     0,    77,
       0,     0,   248,     0,     0,    79,    80,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,    74,    75,    76,     0,
       0,    77,     0,     0,   307,     0,     0,    79,    80,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    81,    82,
      83,    84,    85,    86,    87,    88,    89,    90,    91,    92,
      93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
     103,   104,   105,   106,   107,   108,   109,   110,    74,    75,
      76,     0,     0,    77,     0,     0,   356,     0,     0,    79,
      80,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      81,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
      74,    75,    76,     0,   338,    77,     0,     0,     0,     0,
       0,    79,    80,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   132,   133,   134,   135,    85,    86,   136,   137,
     138,   139,   140,   141,   142,    94,   143,   144,    97,    98,
      99,     0,   145,   146,   147,   148,   149,   150,   151,   108,
     109,   208,    74,    75,    76,     0,   433,    77,     0,     0,
       0,     0,     0,    79,    80,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   132,   133,   134,   135,    85,    86,
     136,   137,   138,   139,   140,   141,   142,    94,   143,   144,
      97,    98,    99,     0,   145,   146,   147,   148,   149,   150,
     151,   108,   109,   208,    74,    75,    76,     0,     0,    77,
       0,     0,     0,     0,     0,    79,    80,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   132,   133,   134,   135,
      85,    86,   136,   137,   138,   139,   140,   141,   142,    94,
     143,   144,    97,    98,    99,     0,   145,   146,   147,   148,
     149,   150,   151,   108,   109,   208,    74,    75,    76,     0,
       0,    77,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   132,   133,
     134,   135,    85,    86,   136,   137,   138,   139,   140,   141,
     142,    94,   143,   144,    97,    98,    99,     0,   145,   146,
     147,   148,   149,   150,   151,   108,   109,   208,   131,     0,
       0,     0,     0,     0,     0,   305,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   132,
     133,   134,   135,    85,    86,   136,   137,   138,   139,   140,
     141,   142,    94,   143,   144,    97,    98,    99,     0,   145,
     146,   147,   148,   149,   150,   151,   108,   152,   153,   131,
       0,     0,     0,     0,     0,     0,   359,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     132,   133,   134,   135,    85,    86,   136,   137,   138,   139,
     140,   141,   142,    94,   143,   144,    97,    98,    99,     0,
     145,   146,   147,   148,   149,   150,   151,   108,   152,   153,
     131,     0,     0,     0,     0,     0,     0,   361,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   132,   133,   134,   135,    85,    86,   136,   137,   138,
     139,   140,   141,   142,    94,   143,   144,    97,    98,    99,
       0,   145,   146,   147,   148,   149,   150,   151,   108,   152,
     153,   131,     0,     0,     0,     0,     0,     0,   395,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   132,   133,   134,   135,    85,    86,   136,   137,
     138,   139,   140,   141,   142,    94,   143,   144,    97,    98,
      99,     0,   145,   146,   147,   148,   149,   150,   151,   108,
     152,   153,   131,     0,     0,     0,     0,     0,     0,   423,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   132,   133,   134,   135,    85,    86,   136,
     137,   138,   139,   140,   141,   142,    94,   143,   144,    97,
      98,    99,     0,   145,   146,   147,   148,   149,   150,   151,
     108,   152,   153,   131,     0,     0,     0,     0,     0,     0,
     424,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   132,   133,   134,   135,    85,    86,
     136,   137,   138,   139,   140,   141,   142,    94,   143,   144,
      97,    98,    99,   131,   145,   146,   147,   148,   149,   150,
     151,   108,   152,   153,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   132,   133,   134,   135,    85,    86,
     136,   137,   138,   139,   140,   141,   142,    94,   143,   144,
      97,    98,    99,     0,   145,   146,   147,   148,   149,   150,
     151,   108,   152,   153,   320,     0,     0,     0,     0,   189,
       0,     0,     0,     0,     0,   321,     0,     0,     0,     0,
       0,   128,     2,     3,     4,     0,     0,     7,     8,     9,
      10,    11,    12,    13,   188,    15,    16,     0,     0,   189,
       0,   322,    22,    23,    24,    25,    26,    27,     0,   323,
      28,   128,     2,     3,     4,     0,     0,     7,     8,     9,
      10,    11,    12,    13,   195,    15,    16,     0,     0,   189,
       0,     0,    22,    23,    24,    25,    26,    27,     0,   190,
      28,   128,     2,     3,     4,     0,     0,     7,     8,     9,
      10,    11,    12,    13,   195,    15,    16,     0,     0,   189,
       0,     0,    22,    23,    24,    25,    26,    27,     0,   196,
      28,     1,     2,     3,     4,     0,     0,     7,     8,     9,
      10,    11,    12,    13,   377,    15,    16,     0,     0,   189,
       0,     0,    22,    23,    24,    25,    26,    27,     0,   196,
      28,   378,     2,     3,     4,     0,     0,     7,     8,     9,
      10,    11,    12,    13,     0,    15,    16,   251,     0,     0,
       0,     0,    22,    23,    24,    25,    26,    27,     0,   379,
      28,     1,     2,     3,     4,     0,     0,     7,     8,     9,
      10,    11,    12,    13,     0,    15,    16,   282,     0,     0,
     252,   253,    22,    23,    24,    25,    26,    27,     0,     0,
      28,     1,     2,     3,     4,     0,     0,     7,     8,     9,
      10,    11,    12,    13,     0,    15,    16,     0,     0,     0,
     252,   253,    22,    23,    24,    25,    26,    27,   127,     0,
      28,     0,     0,   128,     2,     3,     4,     0,     0,     7,
       8,     9,    10,    11,    12,    13,     0,    15,    16,     0,
       0,     0,     0,   129,    22,    23,    24,    25,    26,    27,
       0,     0,    28,   132,   133,   134,   135,    85,    86,   136,
     137,   138,   139,   140,   141,   142,    94,   143,   144,    97,
      98,    99,     0,   145,   146,   147,   148,   149,   150,   151,
     108,   290,   291,     1,     2,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
       0,     0,    28,   128,     2,     3,     4,     0,     0,     7,
       8,     9,    10,    11,    12,    13,     0,    15,    16,     0,
       0,     0,     0,   220,    22,    23,    24,    25,    26,    27,
       0,     0,    28,   333,     2,     3,     4,     0,     0,     7,
       8,     9,    10,    11,    12,    13,     0,    15,    16,     0,
       0,     0,     0,     0,    22,    23,    24,    25,    26,    27,
       0,   334,    28,     1,     2,     3,     4,     0,     0,     7,
       8,     9,    10,    11,    12,    13,     0,    15,    16,     0,
       0,     0,     0,     0,    22,    23,    24,    25,    26,    27,
       0,     0,    28,   128,     2,     3,     4,     0,     0,     7,
       8,     9,    10,    11,    12,    13,     0,    15,    16,     0,
       0,     0,     0,     0,    22,    23,    24,    25,    26,    27,
     157,   158,    28,     0,     0,     0,     0,     0,   159,   160,
     161,   162,   163,     0,     0,     0,     0,     0,     0,     0,
       0,   164,     0,     0,   165,     0,     0,     0,     0,   166
};

static const yytype_int16 yycheck[] =
{
       0,    64,   129,   237,   213,   169,   195,   171,   116,    34,
      41,    36,   120,    38,    43,   123,    77,     8,   126,   167,
      20,    21,    68,    69,    71,    50,    51,   188,    53,    29,
     351,   393,    10,    64,    65,   377,    61,   278,    63,    20,
     281,     8,    13,     8,     8,     8,    13,     8,    13,    13,
      13,     8,    19,    23,    25,    10,   170,    10,   172,    11,
       6,    11,    53,    16,    19,   427,   174,    10,   176,    10,
     178,   413,    24,    16,    24,   239,   184,   311,    18,   187,
     314,   402,   271,    23,   115,    10,    53,   214,    53,    53,
      53,    10,    53,   220,    19,   243,    53,   245,    53,    54,
     100,   101,    10,   230,    10,   266,    25,    26,    11,   318,
      53,    54,    53,    54,    33,    34,    35,    36,    37,    53,
      54,    24,     6,    11,   358,   188,   189,    46,    12,   129,
      49,    11,   179,   180,    18,    54,    24,     6,    22,    23,
     169,    20,   171,    12,    24,    24,   387,   388,   312,    11,
     213,   315,    13,    22,   215,    10,    10,   204,   219,   206,
      10,    16,    24,   397,    25,   399,    53,    54,   295,    19,
      18,   232,   233,   234,   235,    10,    24,   418,   419,   420,
     421,   181,   213,   214,    18,    53,    54,    18,   217,     8,
      24,   254,   319,    24,    13,   322,    53,    54,    20,   230,
     308,   264,    24,   266,    10,    20,   267,   207,   237,    24,
     239,   272,    20,   238,    10,     6,    24,    10,   218,    10,
     220,    12,    20,   254,     6,    20,    24,    18,   274,   275,
      12,    22,    23,    20,   265,    20,    18,    24,    10,    24,
      22,    23,   369,    20,    20,    55,    56,    24,    24,   249,
     250,    10,   252,   253,    20,   318,    20,   320,    20,     6,
     321,    10,   293,    23,   295,    12,    23,   233,   234,   235,
      23,    18,    20,   336,    20,    22,    23,     6,   278,    79,
      80,   281,   311,   312,    17,   314,   315,   318,   319,   249,
     250,    17,     9,    20,   355,     9,   343,   344,    52,   345,
     346,     9,   348,   349,    10,   336,    17,    17,    17,   372,
      10,     6,   373,   374,   377,   376,    17,    12,     7,    24,
     351,    52,   322,    18,    21,    25,    26,    22,    23,   358,
     393,    52,    19,    33,    34,    35,    36,    37,   369,   400,
     401,     6,   389,   390,   391,   392,    46,     8,     7,    49,
     413,     7,     9,   414,    54,     8,     8,     6,     8,    10,
       6,     9,   393,     7,   427,    29,    12,     9,   397,    24,
     399,   402,    18,     9,    25,    26,    22,    23,     9,     7,
     116,   120,    33,    34,    35,    36,    37,   387,   388,   123,
     187,   126,   184,     6,   384,    46,   427,     0,    49,    12,
       6,   328,   320,    54,   372,    18,    12,    -1,   194,    22,
      23,   200,    18,    -1,    -1,    -1,    22,    23,   418,   419,
     420,   421,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,     6,
      -1,    54,     3,     4,     5,    12,     6,     8,    -1,    -1,
      11,    18,    12,    14,    15,    22,    23,    -1,    18,    -1,
      -1,    -1,    22,    23,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,     3,     4,     5,    -1,     6,     8,
      -1,    -1,    11,    -1,    12,    14,    15,    -1,    -1,    -1,
      18,    -1,    -1,    -1,    22,    23,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,     3,     4,     5,    -1,
       6,     8,    -1,    -1,    11,    -1,    12,    14,    15,    -1,
      -1,    -1,    18,    -1,    -1,    -1,    22,    23,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,     3,     4,
       5,    -1,     6,     8,    -1,    -1,    11,    -1,    12,    14,
      15,    -1,    -1,    -1,    18,    -1,    -1,    -1,    22,    23,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
       3,     4,     5,    -1,     6,     8,    -1,    -1,    11,    -1,
      12,    14,    15,    -1,    -1,    -1,    18,    -1,    -1,    -1,
      22,    23,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,     3,     4,     5,    -1,     6,     8,    -1,    -1,
      11,    -1,    12,    14,    15,    -1,    -1,    -1,    18,    -1,
      -1,    -1,    22,    23,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,     3,     4,     5,    -1,    -1,     8,
      -1,    -1,    11,    -1,    -1,    14,    15,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,     3,     4,     5,    -1,
      -1,     8,    -1,    -1,    11,    -1,    -1,    14,    15,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,     3,     4,
       5,    -1,    -1,     8,    -1,    -1,    11,    -1,    -1,    14,
      15,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
       3,     4,     5,    -1,    -1,     8,    -1,    -1,    11,    -1,
      -1,    14,    15,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,     3,     4,     5,    -1,    -1,     8,    -1,    -1,
      11,    -1,    -1,    14,    15,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,     3,     4,     5,    -1,    -1,     8,
      -1,    -1,    11,    -1,    -1,    14,    15,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,     3,     4,     5,    -1,
      -1,     8,    -1,    -1,    11,    -1,    -1,    14,    15,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,     3,     4,
       5,    -1,    -1,     8,    -1,    -1,    11,    -1,    -1,    14,
      15,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
       3,     4,     5,    -1,     7,     8,    -1,    -1,    -1,    -1,
      -1,    14,    15,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    -1,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,     3,     4,     5,    -1,     7,     8,    -1,    -1,
      -1,    -1,    -1,    14,    15,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    -1,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,     3,     4,     5,    -1,    -1,     8,
      -1,    -1,    -1,    -1,    -1,    14,    15,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    -1,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,     3,     4,     5,    -1,
      -1,     8,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    -1,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,     4,    -1,
      -1,    -1,    -1,    -1,    -1,    11,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    25,
      26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    -1,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,     4,
      -1,    -1,    -1,    -1,    -1,    -1,    11,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    -1,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
       4,    -1,    -1,    -1,    -1,    -1,    -1,    11,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      -1,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,     4,    -1,    -1,    -1,    -1,    -1,    -1,    11,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    -1,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,     4,    -1,    -1,    -1,    -1,    -1,    -1,    11,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,     4,    -1,    -1,    -1,    -1,    -1,    -1,
      11,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,     4,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    -1,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,     8,    -1,    -1,    -1,    -1,    13,
      -1,    -1,    -1,    -1,    -1,    19,    -1,    -1,    -1,    -1,
      -1,    25,    26,    27,    28,    -1,    -1,    31,    32,    33,
      34,    35,    36,    37,     8,    39,    40,    -1,    -1,    13,
      -1,    45,    46,    47,    48,    49,    50,    51,    -1,    53,
      54,    25,    26,    27,    28,    -1,    -1,    31,    32,    33,
      34,    35,    36,    37,     8,    39,    40,    -1,    -1,    13,
      -1,    -1,    46,    47,    48,    49,    50,    51,    -1,    53,
      54,    25,    26,    27,    28,    -1,    -1,    31,    32,    33,
      34,    35,    36,    37,     8,    39,    40,    -1,    -1,    13,
      -1,    -1,    46,    47,    48,    49,    50,    51,    -1,    53,
      54,    25,    26,    27,    28,    -1,    -1,    31,    32,    33,
      34,    35,    36,    37,     8,    39,    40,    -1,    -1,    13,
      -1,    -1,    46,    47,    48,    49,    50,    51,    -1,    53,
      54,    25,    26,    27,    28,    -1,    -1,    31,    32,    33,
      34,    35,    36,    37,    -1,    39,    40,    11,    -1,    -1,
      -1,    -1,    46,    47,    48,    49,    50,    51,    -1,    53,
      54,    25,    26,    27,    28,    -1,    -1,    31,    32,    33,
      34,    35,    36,    37,    -1,    39,    40,    11,    -1,    -1,
      44,    45,    46,    47,    48,    49,    50,    51,    -1,    -1,
      54,    25,    26,    27,    28,    -1,    -1,    31,    32,    33,
      34,    35,    36,    37,    -1,    39,    40,    -1,    -1,    -1,
      44,    45,    46,    47,    48,    49,    50,    51,    20,    -1,
      54,    -1,    -1,    25,    26,    27,    28,    -1,    -1,    31,
      32,    33,    34,    35,    36,    37,    -1,    39,    40,    -1,
      -1,    -1,    -1,    45,    46,    47,    48,    49,    50,    51,
      -1,    -1,    54,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    -1,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    25,    26,    27,    28,    29,    30,    31,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      -1,    -1,    54,    25,    26,    27,    28,    -1,    -1,    31,
      32,    33,    34,    35,    36,    37,    -1,    39,    40,    -1,
      -1,    -1,    -1,    45,    46,    47,    48,    49,    50,    51,
      -1,    -1,    54,    25,    26,    27,    28,    -1,    -1,    31,
      32,    33,    34,    35,    36,    37,    -1,    39,    40,    -1,
      -1,    -1,    -1,    -1,    46,    47,    48,    49,    50,    51,
      -1,    53,    54,    25,    26,    27,    28,    -1,    -1,    31,
      32,    33,    34,    35,    36,    37,    -1,    39,    40,    -1,
      -1,    -1,    -1,    -1,    46,    47,    48,    49,    50,    51,
      -1,    -1,    54,    25,    26,    27,    28,    -1,    -1,    31,
      32,    33,    34,    35,    36,    37,    -1,    39,    40,    -1,
      -1,    -1,    -1,    -1,    46,    47,    48,    49,    50,    51,
      25,    26,    54,    -1,    -1,    -1,    -1,    -1,    33,    34,
      35,    36,    37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    46,    -1,    -1,    49,    -1,    -1,    -1,    -1,    54
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    54,    57,
      62,    63,    64,    66,    67,    69,    70,    72,    73,    75,
      78,    82,    85,    10,    19,    53,    54,    92,    10,    10,
      10,    10,    10,    10,    10,    53,    54,    86,    87,    10,
      10,    79,    10,    76,    82,    82,    10,    16,    53,    54,
      89,    90,     0,    62,     3,     4,     5,     8,    11,    14,
      15,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    58,    59,    60,    65,    82,   112,   113,    11,    68,
     112,    11,    71,   112,    11,    74,   112,    20,    25,    45,
      85,     4,    25,    26,    27,    28,    31,    32,    33,    34,
      35,    36,    37,    39,    40,    45,    46,    47,    48,    49,
      50,    51,    53,    54,    58,    98,    99,    25,    26,    33,
      34,    35,    36,    37,    46,    49,    54,    81,    84,    10,
      19,    10,    19,    11,   112,    11,   112,    11,   112,    87,
      87,    93,    11,    80,   112,    11,    77,   112,     8,    13,
      53,   100,   101,   102,   110,     8,    53,    83,   108,   109,
     110,    53,    54,    16,    90,    16,    90,    93,    54,    60,
      20,    59,    59,    82,    82,     6,    12,    22,    18,    23,
      45,    65,   113,    20,    20,    68,    20,    71,    20,    74,
      82,    83,    23,    23,    23,    23,    11,    24,    10,    10,
      25,    84,    98,    81,    98,    81,    11,    11,    11,    93,
      93,    11,    44,    45,    82,    88,    94,    20,    80,    20,
      77,   101,    25,   110,   111,    18,    24,     6,   102,   108,
      20,    24,     6,   109,    17,    17,    53,    54,    93,    53,
      54,    93,    11,    91,     9,   100,    83,    60,    53,    54,
      53,    54,    58,    82,    60,    82,    83,    20,    83,    20,
      60,    61,    61,    61,    61,    11,    99,    11,   112,    98,
      11,    24,    10,    11,    24,    10,    88,    88,    82,    82,
       8,    19,    45,    53,    96,    97,   106,   107,   110,    52,
       9,    25,   110,    25,    53,    85,    95,   101,     7,    60,
       9,   108,    60,    90,    90,    17,    17,    91,    17,    17,
      91,    18,     7,    83,    20,    21,    11,    11,    24,    11,
      98,    11,    98,    52,    52,   100,    83,   106,    60,    82,
      83,    20,    24,    19,     6,   107,     8,     8,    25,    53,
      85,   103,   104,   105,   110,     7,     7,    93,    93,    90,
      90,    90,    90,    95,    60,    11,    11,    24,    11,    24,
       8,     8,    18,    20,     9,    83,    20,    97,    60,    60,
      60,   104,    20,    24,     6,   105,    91,    91,    93,    93,
      93,    93,   103,    11,    11,    60,    60,    95,    20,     7,
       9,     9,   104,     7,    60,    91,    91,    91,    91,     9,
       9,   103,     7,    20
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    56,    57,    57,    58,    58,    58,    58,    58,    58,
      58,    58,    58,    58,    58,    58,    58,    58,    58,    58,
      58,    58,    58,    58,    58,    58,    58,    58,    58,    58,
      58,    59,    59,    59,    59,    59,    59,    59,    59,    59,
      59,    59,    59,    59,    60,    60,    60,    61,    61,    62,
      62,    62,    62,    62,    62,    62,    62,    62,    62,    62,
      63,    63,    64,    65,    66,    66,    67,    68,    69,    69,
      70,    71,    72,    72,    73,    74,    75,    75,    76,    77,
      78,    78,    79,    80,    81,    81,    81,    81,    82,    82,
      82,    82,    83,    83,    84,    84,    84,    84,    84,    84,
      84,    84,    84,    84,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    86,    86,    86,
      86,    86,    86,    86,    86,    87,    88,    89,    89,    89,
      89,    89,    89,    89,    89,    89,    89,    89,    89,    89,
      90,    91,    92,    92,    92,    92,    92,    92,    92,    92,
      92,    92,    92,    92,    92,    92,    93,    93,    94,    94,
      94,    94,    94,    95,    95,    95,    95,    95,    95,    96,
      96,    97,    97,    97,    98,    98,    99,    99,    99,    99,
      99,    99,    99,    99,   100,   100,   101,   101,   102,   102,
     102,   102,   102,   103,   103,   104,   104,   105,   105,   105,
     105,   106,   106,   107,   107,   107,   108,   108,   109,   109,
     109,   110,   110,   110,   111,   111,   112,   112,   113,   113,
     113,   113,   113,   113
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     3,     4,     3,
       3,     3,     3,     3,     1,     2,     2,     3,     1,     2,
       1,     1,     1,     1,     1,     1,     5,     4,     4,     7,
       2,     3,     2,     2,     2,     3,     2,     2,     2,     3,
       2,     2,     2,     3,     2,     2,     3,     4,     1,     2,
       3,     4,     1,     2,     1,     1,     2,     2,     1,     1,
       2,     2,     1,     3,     1,     1,     1,     1,     1,     1,
       1,     1,     3,     4,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     3,     4,     3,
       4,     1,     3,     4,     2,     2,     2,     3,     4,     4,
       1,     1,     7,     8,     8,     1,     1,     3,     6,     6,
       4,     7,     4,     7,     4,     4,     7,     4,     7,     4,
       1,     1,     3,     5,     4,     6,     4,     6,     4,     6,
       5,     7,     1,     5,     7,     1,     0,     2,     3,     5,
       4,     4,     7,     1,     1,     1,     2,     2,     2,     1,
       3,     1,     2,     3,     1,     3,     1,     1,     1,     1,
       3,     3,     3,     3,     1,     3,     1,     2,     0,     1,
       3,     4,     3,     1,     3,     1,     2,     0,     3,     4,
       3,     1,     2,     1,     3,     4,     1,     2,     1,     3,
       4,     1,     2,     3,     1,     2,     2,     3,     3,     3,
       4,     3,     3,     6
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (scanner, yyscanner, YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, scanner, yyscanner); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct ctf_scanner *scanner, yyscan_t yyscanner)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  YYUSE (scanner);
  YYUSE (yyscanner);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, struct ctf_scanner *scanner, yyscan_t yyscanner)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep, scanner, yyscanner);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule, struct ctf_scanner *scanner, yyscan_t yyscanner)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              , scanner, yyscanner);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule, scanner, yyscanner); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, struct ctf_scanner *scanner, yyscan_t yyscanner)
{
  YYUSE (yyvaluep);
  YYUSE (scanner);
  YYUSE (yyscanner);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/*----------.
| yyparse.  |
`----------*/

int
yyparse (struct ctf_scanner *scanner, yyscan_t yyscanner)
{
/* The lookahead symbol.  */
int yychar;


/* The semantic value of the lookahead symbol.  */
/* Default value used for initialization, for pacifying older GCCs
   or non-GCC compilers.  */
YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);

    /* Number of syntax errors so far.  */
    int yynerrs;

    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex (&yylval, yyscanner);
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 1116 "ctf-parser.y" /* yacc.c:1646  */
    {
			if (set_parent_node((yyvsp[0].n), &ctf_scanner_get_ast(scanner)->root))
				reparent_error(scanner, "error reparenting to root");
		}
#line 3045 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 3:
#line 1121 "ctf-parser.y" /* yacc.c:1646  */
    {
			if (set_parent_node((yyvsp[0].n), &ctf_scanner_get_ast(scanner)->root))
				reparent_error(scanner, "error reparenting to root");
		}
#line 3054 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 4:
#line 1129 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3060 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 5:
#line 1131 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3066 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 6:
#line 1133 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3072 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 7:
#line 1135 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3078 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 8:
#line 1137 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3084 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 9:
#line 1139 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3090 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 10:
#line 1141 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3096 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 11:
#line 1143 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3102 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 12:
#line 1145 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3108 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 13:
#line 1147 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3114 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 14:
#line 1149 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3120 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 15:
#line 1151 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3126 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 16:
#line 1153 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3132 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 17:
#line 1155 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3138 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 18:
#line 1157 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3144 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 19:
#line 1159 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3150 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 20:
#line 1161 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3156 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 21:
#line 1163 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3162 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 22:
#line 1165 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3168 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 23:
#line 1167 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3174 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 24:
#line 1169 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3180 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 25:
#line 1171 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3186 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 26:
#line 1173 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3192 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 27:
#line 1175 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3198 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 28:
#line 1177 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3204 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 29:
#line 1179 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3210 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 30:
#line 1181 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.s) = yylval.s;		}
#line 3216 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 31:
#line 1189 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
		}
#line 3226 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 32:
#line 1195 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
		}
#line 3236 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 33:
#line 1201 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
		}
#line 3246 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 34:
#line 1207 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_UNSIGNED_CONSTANT;
			(yyval.n)->u.unary_expression.u.unsigned_constant = (yyvsp[0].ull);
		}
#line 3256 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 35:
#line 1213 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = (yyvsp[0].s);
		}
#line 3266 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 36:
#line 1219 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = (yyvsp[0].s);
		}
#line 3276 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 37:
#line 1225 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-1].n);
		}
#line 3284 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 38:
#line 1229 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_SBRAC;
			(yyval.n)->u.unary_expression.u.sbrac_exp = (yyvsp[-1].n);
			bt_list_splice(&((yyvsp[-3].n))->tmp_head, &((yyval.n))->tmp_head);
			bt_list_add_tail(&((yyval.n))->siblings, &((yyval.n))->tmp_head);
		}
#line 3296 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 39:
#line 1237 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
			(yyval.n)->u.unary_expression.link = UNARY_DOTLINK;
			bt_list_splice(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->tmp_head);
			bt_list_add_tail(&((yyval.n))->siblings, &((yyval.n))->tmp_head);
		}
#line 3309 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 40:
#line 1246 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
			(yyval.n)->u.unary_expression.link = UNARY_DOTLINK;
			bt_list_splice(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->tmp_head);
			bt_list_add_tail(&((yyval.n))->siblings, &((yyval.n))->tmp_head);
		}
#line 3322 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 41:
#line 1255 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
			(yyval.n)->u.unary_expression.link = UNARY_DOTLINK;
			bt_list_splice(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->tmp_head);
			bt_list_add_tail(&((yyval.n))->siblings, &((yyval.n))->tmp_head);
		}
#line 3335 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 42:
#line 1264 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
			(yyval.n)->u.unary_expression.link = UNARY_ARROWLINK;
			bt_list_splice(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->tmp_head);
			bt_list_add_tail(&((yyval.n))->siblings, &((yyval.n))->tmp_head);
		}
#line 3348 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 43:
#line 1273 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_UNARY_EXPRESSION);
			(yyval.n)->u.unary_expression.type = UNARY_STRING;
			(yyval.n)->u.unary_expression.u.string = yylval.s;
			(yyval.n)->u.unary_expression.link = UNARY_ARROWLINK;
			bt_list_splice(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->tmp_head);
			bt_list_add_tail(&((yyval.n))->siblings, &((yyval.n))->tmp_head);
		}
#line 3361 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 44:
#line 1285 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);				}
#line 3367 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 45:
#line 1287 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[0].n);
			if ((yyval.n)->u.unary_expression.type != UNARY_UNSIGNED_CONSTANT
				&& (yyval.n)->u.unary_expression.type != UNARY_SIGNED_CONSTANT) {
				reparent_error(scanner, "expecting numeric constant");
			}
		}
#line 3379 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 46:
#line 1295 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[0].n);
			if ((yyval.n)->u.unary_expression.type == UNARY_UNSIGNED_CONSTANT) {
				(yyval.n)->u.unary_expression.type = UNARY_SIGNED_CONSTANT;
				(yyval.n)->u.unary_expression.u.signed_constant =
					-((yyval.n)->u.unary_expression.u.unsigned_constant);
			} else if ((yyval.n)->u.unary_expression.type == UNARY_UNSIGNED_CONSTANT) {
				(yyval.n)->u.unary_expression.u.signed_constant =
					-((yyval.n)->u.unary_expression.u.signed_constant);
			} else {
				reparent_error(scanner, "expecting numeric constant");
			}
		}
#line 3397 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 47:
#line 1312 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			_bt_list_splice_tail(&((yyvsp[0].n))->tmp_head, &((yyval.n))->tmp_head);
			(yyvsp[0].n)->u.unary_expression.link = UNARY_DOTDOTDOT;
		}
#line 3407 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 48:
#line 1318 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);		}
#line 3413 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 49:
#line 1325 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[-1].n);	}
#line 3419 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 50:
#line 1327 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 3425 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 51:
#line 1329 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 3431 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 52:
#line 1331 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 3437 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 53:
#line 1333 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 3443 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 54:
#line 1335 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 3449 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 55:
#line 1337 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 3455 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 56:
#line 1339 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u._typedef.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-4].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 3470 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 57:
#line 1350 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u._typedef.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 3484 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 58:
#line 1360 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u._typedef.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-3].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 3498 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 59:
#line 1370 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEALIAS);
			(yyval.n)->u.typealias.target = make_node(scanner, NODE_TYPEALIAS_TARGET);
			(yyval.n)->u.typealias.alias = make_node(scanner, NODE_TYPEALIAS_ALIAS);

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u.typealias.target->u.typealias_target.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-5].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-4].n))->tmp_head, &((yyval.n))->u.typealias.target->u.typealias_target.type_declarators);

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u.typealias.alias->u.typealias_alias.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.typealias.alias->u.typealias_alias.type_declarators);
		}
#line 3520 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 60:
#line 1391 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_EVENT);
		}
#line 3528 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 61:
#line 1395 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_EVENT);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "event_declaration");
		}
#line 3538 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 62:
#line 1404 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 3544 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 63:
#line 1409 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 3550 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 64:
#line 1415 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STREAM);
		}
#line 3558 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 65:
#line 1419 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STREAM);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "stream_declaration");
		}
#line 3568 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 66:
#line 1428 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 3574 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 67:
#line 1433 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 3580 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 68:
#line 1438 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENV);
		}
#line 3588 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 69:
#line 1442 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENV);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "env declaration");
		}
#line 3598 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 70:
#line 1451 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 3604 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 71:
#line 1456 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 3610 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 72:
#line 1461 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TRACE);
		}
#line 3618 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 73:
#line 1465 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TRACE);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "trace_declaration");
		}
#line 3628 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 74:
#line 1474 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 3634 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 75:
#line 1479 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 3640 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 76:
#line 1484 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_CLOCK);
		}
#line 3648 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 77:
#line 1488 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_CLOCK);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "trace_declaration");
		}
#line 3658 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 78:
#line 1497 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 3664 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 79:
#line 1502 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 3670 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 80:
#line 1507 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_CALLSITE);
		}
#line 3678 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 81:
#line 1511 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_CALLSITE);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "trace_declaration");
		}
#line 3688 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 82:
#line 1520 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 3694 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 83:
#line 1525 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 3700 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 84:
#line 1530 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_CONST;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3713 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 85:
#line 1539 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			node = (yyvsp[0].n);
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3725 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 86:
#line 1547 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = (yyvsp[-1].n);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_CONST;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3738 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 87:
#line 1556 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-1].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3747 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 88:
#line 1564 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_CONST;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3760 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 89:
#line 1573 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			node = (yyvsp[0].n);
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3772 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 90:
#line 1581 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = (yyvsp[-1].n);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_CONST;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3785 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 91:
#line 1590 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-1].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 3794 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 92:
#line 1598 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 3800 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 93:
#line 1600 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->tmp_head);
		}
#line 3809 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 94:
#line 1608 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_CHAR;
		}
#line 3818 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 95:
#line 1613 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_SHORT;
		}
#line 3827 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 96:
#line 1618 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_INT;
		}
#line 3836 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 97:
#line 1623 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_LONG;
		}
#line 3845 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 98:
#line 1628 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_SIGNED;
		}
#line 3854 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 99:
#line 1633 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_UNSIGNED;
		}
#line 3863 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 100:
#line 1638 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_BOOL;
		}
#line 3872 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 101:
#line 1643 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_ID_TYPE;
			(yyval.n)->u.type_specifier.id_type = yylval.s;
		}
#line 3882 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 102:
#line 1649 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_INTEGER;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_INTEGER);
		}
#line 3892 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 103:
#line 1655 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_INTEGER;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_INTEGER);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)->u.type_specifier.node))
				reparent_error(scanner, "integer reparent error");
		}
#line 3904 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 104:
#line 1666 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_VOID;
		}
#line 3913 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 105:
#line 1671 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_CHAR;
		}
#line 3922 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 106:
#line 1676 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_SHORT;
		}
#line 3931 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 107:
#line 1681 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_INT;
		}
#line 3940 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 108:
#line 1686 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_LONG;
		}
#line 3949 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 109:
#line 1691 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_FLOAT;
		}
#line 3958 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 110:
#line 1696 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_DOUBLE;
		}
#line 3967 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 111:
#line 1701 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_SIGNED;
		}
#line 3976 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 112:
#line 1706 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_UNSIGNED;
		}
#line 3985 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 113:
#line 1711 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_BOOL;
		}
#line 3994 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 114:
#line 1716 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_COMPLEX;
		}
#line 4003 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 115:
#line 1721 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_IMAGINARY;
		}
#line 4012 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 116:
#line 1726 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_ID_TYPE;
			(yyval.n)->u.type_specifier.id_type = yylval.s;
		}
#line 4022 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 117:
#line 1732 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_FLOATING_POINT;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_FLOATING_POINT);
		}
#line 4032 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 118:
#line 1738 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_FLOATING_POINT;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_FLOATING_POINT);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)->u.type_specifier.node))
				reparent_error(scanner, "floating point reparent error");
		}
#line 4044 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 119:
#line 1746 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_INTEGER;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_INTEGER);
		}
#line 4054 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 120:
#line 1752 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_INTEGER;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_INTEGER);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)->u.type_specifier.node))
				reparent_error(scanner, "integer reparent error");
		}
#line 4066 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 121:
#line 1760 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_STRING;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_STRING);
		}
#line 4076 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 122:
#line 1766 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_STRING;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_STRING);
		}
#line 4086 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 123:
#line 1772 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_STRING;
			(yyval.n)->u.type_specifier.node = make_node(scanner, NODE_STRING);
			if (set_parent_node((yyvsp[-1].n), (yyval.n)->u.type_specifier.node))
				reparent_error(scanner, "string reparent error");
		}
#line 4098 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 124:
#line 1780 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_ENUM;
			(yyval.n)->u.type_specifier.node = (yyvsp[0].n);
		}
#line 4108 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 125:
#line 1786 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_VARIANT;
			(yyval.n)->u.type_specifier.node = (yyvsp[0].n);
		}
#line 4118 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 126:
#line 1792 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER);
			(yyval.n)->u.type_specifier.type = TYPESPEC_STRUCT;
			(yyval.n)->u.type_specifier.node = (yyvsp[0].n);
		}
#line 4128 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 127:
#line 1801 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 1;
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "struct reparent error");
		}
#line 4139 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 128:
#line 1808 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 1;
			(yyval.n)->u._struct.name = (yyvsp[-3].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "struct reparent error");
		}
#line 4151 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 129:
#line 1816 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 1;
			(yyval.n)->u._struct.name = (yyvsp[-3].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "struct reparent error");
		}
#line 4163 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 130:
#line 1824 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 0;
			(yyval.n)->u._struct.name = (yyvsp[0].s);
		}
#line 4173 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 131:
#line 1830 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 0;
			(yyval.n)->u._struct.name = (yyvsp[0].s);
		}
#line 4183 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 132:
#line 1836 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 1;
			bt_list_add_tail(&((yyvsp[-1].n))->siblings, &(yyval.n)->u._struct.min_align);
			if ((yyvsp[-5].n) && set_parent_node((yyvsp[-5].n), (yyval.n)))
				reparent_error(scanner, "struct reparent error");
		}
#line 4195 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 133:
#line 1844 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 1;
			(yyval.n)->u._struct.name = (yyvsp[-7].s);
			bt_list_add_tail(&((yyvsp[-1].n))->siblings, &(yyval.n)->u._struct.min_align);
			if ((yyvsp[-5].n) && set_parent_node((yyvsp[-5].n), (yyval.n)))
				reparent_error(scanner, "struct reparent error");
		}
#line 4208 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 134:
#line 1853 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_STRUCT);
			(yyval.n)->u._struct.has_body = 1;
			(yyval.n)->u._struct.name = (yyvsp[-7].s);
			bt_list_add_tail(&((yyvsp[-1].n))->siblings, &(yyval.n)->u._struct.min_align);
			if ((yyvsp[-5].n) && set_parent_node((yyvsp[-5].n), (yyval.n)))
				reparent_error(scanner, "struct reparent error");
		}
#line 4221 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 135:
#line 1865 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 4227 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 136:
#line 1870 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 4233 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 137:
#line 1875 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4244 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 138:
#line 1882 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.choice = (yyvsp[-4].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4256 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 139:
#line 1890 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.choice = (yyvsp[-4].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4268 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 140:
#line 1898 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.name = (yyvsp[-3].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4280 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 141:
#line 1906 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.name = (yyvsp[-6].s);
			(yyval.n)->u.variant.choice = (yyvsp[-4].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4293 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 142:
#line 1915 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 0;
			(yyval.n)->u.variant.name = (yyvsp[-3].s);
			(yyval.n)->u.variant.choice = (yyvsp[-1].s);
		}
#line 4304 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 143:
#line 1922 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.name = (yyvsp[-6].s);
			(yyval.n)->u.variant.choice = (yyvsp[-4].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4317 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 144:
#line 1931 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 0;
			(yyval.n)->u.variant.name = (yyvsp[-3].s);
			(yyval.n)->u.variant.choice = (yyvsp[-1].s);
		}
#line 4328 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 145:
#line 1938 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.name = (yyvsp[-3].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4340 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 146:
#line 1946 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.name = (yyvsp[-6].s);
			(yyval.n)->u.variant.choice = (yyvsp[-4].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4353 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 147:
#line 1955 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 0;
			(yyval.n)->u.variant.name = (yyvsp[-3].s);
			(yyval.n)->u.variant.choice = (yyvsp[-1].s);
		}
#line 4364 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 148:
#line 1962 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 1;
			(yyval.n)->u.variant.name = (yyvsp[-6].s);
			(yyval.n)->u.variant.choice = (yyvsp[-4].s);
			if ((yyvsp[-1].n) && set_parent_node((yyvsp[-1].n), (yyval.n)))
				reparent_error(scanner, "variant reparent error");
		}
#line 4377 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 149:
#line 1971 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_VARIANT);
			(yyval.n)->u.variant.has_body = 0;
			(yyval.n)->u.variant.name = (yyvsp[-3].s);
			(yyval.n)->u.variant.choice = (yyvsp[-1].s);
		}
#line 4388 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 150:
#line 1981 "ctf-parser.y" /* yacc.c:1646  */
    {	push_scope(scanner);	}
#line 4394 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 151:
#line 1986 "ctf-parser.y" /* yacc.c:1646  */
    {	pop_scope(scanner);	}
#line 4400 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 152:
#line 1991 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4410 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 153:
#line 1997 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			((yyval.n))->u._enum.container_type = (yyvsp[-3].n);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4421 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 154:
#line 2004 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-3].s);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4432 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 155:
#line 2011 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-5].s);
			((yyval.n))->u._enum.container_type = (yyvsp[-3].n);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4444 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 156:
#line 2019 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-3].s);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4455 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 157:
#line 2026 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-5].s);
			((yyval.n))->u._enum.container_type = (yyvsp[-3].n);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4467 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 158:
#line 2034 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4477 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 159:
#line 2040 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			((yyval.n))->u._enum.container_type = (yyvsp[-4].n);
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4488 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 160:
#line 2047 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-4].s);
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4499 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 161:
#line 2054 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-6].s);
			((yyval.n))->u._enum.container_type = (yyvsp[-4].n);
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4511 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 162:
#line 2062 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 0;
			(yyval.n)->u._enum.enum_id = (yyvsp[0].s);
		}
#line 4521 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 163:
#line 2068 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-4].s);
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4532 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 164:
#line 2075 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 1;
			(yyval.n)->u._enum.enum_id = (yyvsp[-6].s);
			((yyval.n))->u._enum.container_type = (yyvsp[-4].n);
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u._enum.enumerator_list);
		}
#line 4544 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 165:
#line 2083 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUM);
			(yyval.n)->u._enum.has_body = 0;
			(yyval.n)->u._enum.enum_id = (yyvsp[0].s);
		}
#line 4554 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 166:
#line 2092 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = NULL;	}
#line 4560 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 167:
#line 2094 "ctf-parser.y" /* yacc.c:1646  */
    {
			if ((yyvsp[-1].n)) {
				(yyval.n) = (yyvsp[-1].n);
				bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->tmp_head);
			} else {
				(yyval.n) = (yyvsp[0].n);
				bt_list_add_tail(&((yyval.n))->siblings, &((yyval.n))->tmp_head);
			}
		}
#line 4574 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 168:
#line 2107 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			(yyval.n) = make_node(scanner, NODE_STRUCT_OR_VARIANT_DECLARATION);
			((yyval.n))->u.struct_or_variant_declaration.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.struct_or_variant_declaration.type_declarators);
		}
#line 4588 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 169:
#line 2117 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u._typedef.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-4].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 4603 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 170:
#line 2128 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u._typedef.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 4617 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 171:
#line 2138 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			_bt_list_splice_tail(&((yyvsp[-3].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			((yyval.n))->u.struct_or_variant_declaration.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 4631 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 172:
#line 2148 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEALIAS);
			(yyval.n)->u.typealias.target = make_node(scanner, NODE_TYPEALIAS_TARGET);
			(yyval.n)->u.typealias.alias = make_node(scanner, NODE_TYPEALIAS_ALIAS);

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u.typealias.target->u.typealias_target.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-5].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-4].n))->tmp_head, &((yyval.n))->u.typealias.target->u.typealias_target.type_declarators);

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u.typealias.alias->u.typealias_alias.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.typealias.alias->u.typealias_alias.type_declarators);
		}
#line 4653 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 173:
#line 2169 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_CONST;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 4666 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 174:
#line 2178 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			node = (yyvsp[0].n);
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 4678 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 175:
#line 2186 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			add_type(scanner, (yyvsp[0].s));
			(yyval.n) = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_ID_TYPE;
			node->u.type_specifier.id_type = yylval.s;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 4693 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 176:
#line 2197 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			(yyval.n) = (yyvsp[-1].n);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_CONST;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 4706 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 177:
#line 2206 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-1].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 4715 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 178:
#line 2211 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *node;

			add_type(scanner, (yyvsp[0].s));
			(yyval.n) = (yyvsp[-1].n);
			node = make_node(scanner, NODE_TYPE_SPECIFIER);
			node->u.type_specifier.type = TYPESPEC_ID_TYPE;
			node->u.type_specifier.id_type = yylval.s;
			bt_list_add_tail(&node->siblings, &((yyval.n))->u.type_specifier_list.head);
		}
#line 4730 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 179:
#line 2225 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4736 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 180:
#line 2227 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->tmp_head);
		}
#line 4745 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 181:
#line 2235 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4751 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 182:
#line 2237 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4757 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 183:
#line 2239 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			if (set_parent_node((yyvsp[0].n), (yyvsp[-2].n)))
				reparent_error(scanner, "struct_or_variant_declarator");
		}
#line 4767 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 184:
#line 2248 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4773 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 185:
#line 2250 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->tmp_head);
		}
#line 4782 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 186:
#line 2258 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[0].s);
		}
#line 4791 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 187:
#line 2263 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[0].s);
		}
#line 4800 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 188:
#line 2268 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[0].s);
		}
#line 4809 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 189:
#line 2273 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[0].s);
		}
#line 4818 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 190:
#line 2278 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[-2].s);
			bt_list_splice(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u.enumerator.values);
		}
#line 4828 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 191:
#line 2284 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[-2].s);
			bt_list_splice(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u.enumerator.values);
		}
#line 4838 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 192:
#line 2290 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[-2].s);
			bt_list_splice(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u.enumerator.values);
		}
#line 4848 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 193:
#line 2296 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_ENUMERATOR);
			(yyval.n)->u.enumerator.id = (yyvsp[-2].s);
			bt_list_splice(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u.enumerator.values);
		}
#line 4858 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 194:
#line 2305 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4864 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 195:
#line 2307 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->tmp_head);
		}
#line 4873 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 196:
#line 2315 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4879 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 197:
#line 2317 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[0].n);
			bt_list_splice(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.pointers);
		}
#line 4888 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 198:
#line 2325 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
                        (yyval.n)->u.type_declarator.type = TYPEDEC_ID;
			/* id is NULL */
		}
#line 4898 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 199:
#line 2331 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_ID;
			(yyval.n)->u.type_declarator.u.id = (yyvsp[0].s);
		}
#line 4908 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 200:
#line 2337 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-1].n);
		}
#line 4918 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 201:
#line 2343 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-3].n);
			BT_INIT_LIST_HEAD(&((yyval.n))->u.type_declarator.u.nested.length);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.u.nested.length);
		}
#line 4930 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 202:
#line 2351 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-2].n);
			(yyval.n)->u.type_declarator.u.nested.abstract_array = 1;
		}
#line 4941 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 203:
#line 2361 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4947 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 204:
#line 2363 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->tmp_head);
		}
#line 4956 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 205:
#line 2371 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 4962 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 206:
#line 2373 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[0].n);
			bt_list_splice(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.pointers);
		}
#line 4971 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 207:
#line 2381 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
                        (yyval.n)->u.type_declarator.type = TYPEDEC_ID;
			/* id is NULL */
		}
#line 4981 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 208:
#line 2387 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-1].n);
		}
#line 4991 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 209:
#line 2393 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-3].n);
			BT_INIT_LIST_HEAD(&((yyval.n))->u.type_declarator.u.nested.length);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.u.nested.length);
		}
#line 5003 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 210:
#line 2401 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-2].n);
			(yyval.n)->u.type_declarator.u.nested.abstract_array = 1;
		}
#line 5014 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 211:
#line 2411 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 5020 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 212:
#line 2413 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[0].n);
			bt_list_splice(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.pointers);
		}
#line 5029 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 213:
#line 2421 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_ID;
			(yyval.n)->u.type_declarator.u.id = (yyvsp[0].s);
		}
#line 5039 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 214:
#line 2427 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-1].n);
		}
#line 5049 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 215:
#line 2433 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-3].n);
			BT_INIT_LIST_HEAD(&((yyval.n))->u.type_declarator.u.nested.length);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.u.nested.length);
		}
#line 5061 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 216:
#line 2444 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[0].n);	}
#line 5067 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 217:
#line 2446 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[0].n);
			bt_list_splice(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.pointers);
		}
#line 5076 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 218:
#line 2454 "ctf-parser.y" /* yacc.c:1646  */
    {
			add_type(scanner, (yyvsp[0].s));
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_ID;
			(yyval.n)->u.type_declarator.u.id = (yyvsp[0].s);
		}
#line 5087 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 219:
#line 2461 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-1].n);
		}
#line 5097 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 220:
#line 2467 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_TYPE_DECLARATOR);
			(yyval.n)->u.type_declarator.type = TYPEDEC_NESTED;
			(yyval.n)->u.type_declarator.u.nested.type_declarator = (yyvsp[-3].n);
			BT_INIT_LIST_HEAD(&((yyval.n))->u.type_declarator.u.nested.length);
			_bt_list_splice_tail(&((yyvsp[-1].n))->tmp_head, &((yyval.n))->u.type_declarator.u.nested.length);
		}
#line 5109 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 221:
#line 2478 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_POINTER);
		}
#line 5117 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 222:
#line 2482 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_POINTER);
			bt_list_splice(&((yyvsp[0].n))->tmp_head, &((yyval.n))->tmp_head);
		}
#line 5126 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 223:
#line 2487 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = make_node(scanner, NODE_POINTER);
			(yyval.n)->u.pointer.const_qualifier = 1;
			bt_list_splice(&((yyvsp[0].n))->tmp_head, &((yyval.n))->tmp_head);
		}
#line 5136 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 226:
#line 2504 "ctf-parser.y" /* yacc.c:1646  */
    {	(yyval.n) = (yyvsp[-1].n);	}
#line 5142 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 227:
#line 2506 "ctf-parser.y" /* yacc.c:1646  */
    {
			(yyval.n) = (yyvsp[-2].n);
			bt_list_add_tail(&((yyvsp[-1].n))->siblings, &((yyval.n))->tmp_head);
		}
#line 5151 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 228:
#line 2514 "ctf-parser.y" /* yacc.c:1646  */
    {
			/*
			 * Because we have left and right, cannot use
			 * set_parent_node.
			 */
			(yyval.n) = make_node(scanner, NODE_CTF_EXPRESSION);
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u.ctf_expression.left);
			if ((yyvsp[-2].n)->u.unary_expression.type != UNARY_STRING)
				reparent_error(scanner, "ctf_assignment_expression left expects string");
			_bt_list_splice_tail(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u.ctf_expression.right);
		}
#line 5167 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 229:
#line 2526 "ctf-parser.y" /* yacc.c:1646  */
    {
			/*
			 * Because we have left and right, cannot use
			 * set_parent_node.
			 */
			(yyval.n) = make_node(scanner, NODE_CTF_EXPRESSION);
			_bt_list_splice_tail(&((yyvsp[-2].n))->tmp_head, &((yyval.n))->u.ctf_expression.left);
			if ((yyvsp[-2].n)->u.unary_expression.type != UNARY_STRING)
				reparent_error(scanner, "ctf_assignment_expression left expects string");
			bt_list_add_tail(&((yyvsp[0].n))->siblings, &((yyval.n))->u.ctf_expression.right);
		}
#line 5183 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 230:
#line 2538 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			_bt_list_splice_tail(&((yyvsp[-3].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-1].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			((yyval.n))->u.struct_or_variant_declaration.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 5198 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 231:
#line 2549 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u._typedef.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-1].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 5212 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 232:
#line 2559 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			_bt_list_splice_tail(&((yyvsp[-2].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			(yyval.n) = make_node(scanner, NODE_TYPEDEF);
			((yyval.n))->u.struct_or_variant_declaration.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u._typedef.type_declarators);
		}
#line 5226 "ctf-parser.c" /* yacc.c:1646  */
    break;

  case 233:
#line 2569 "ctf-parser.y" /* yacc.c:1646  */
    {
			struct ctf_node *list;

			(yyval.n) = make_node(scanner, NODE_TYPEALIAS);
			(yyval.n)->u.typealias.target = make_node(scanner, NODE_TYPEALIAS_TARGET);
			(yyval.n)->u.typealias.alias = make_node(scanner, NODE_TYPEALIAS_ALIAS);

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u.typealias.target->u.typealias_target.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-4].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[-3].n))->tmp_head, &((yyval.n))->u.typealias.target->u.typealias_target.type_declarators);

			list = make_node(scanner, NODE_TYPE_SPECIFIER_LIST);
			(yyval.n)->u.typealias.alias->u.typealias_alias.type_specifier_list = list;
			_bt_list_splice_tail(&((yyvsp[-1].n))->u.type_specifier_list.head, &list->u.type_specifier_list.head);
			_bt_list_splice_tail(&((yyvsp[0].n))->tmp_head, &((yyval.n))->u.typealias.alias->u.typealias_alias.type_declarators);
		}
#line 5248 "ctf-parser.c" /* yacc.c:1646  */
    break;


#line 5252 "ctf-parser.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (scanner, yyscanner, YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (scanner, yyscanner, yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, scanner, yyscanner);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, scanner, yyscanner);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (scanner, yyscanner, YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, scanner, yyscanner);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, scanner, yyscanner);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
