"""
This code implements a parser for Linux keyboard maps.
"""

%%

parser linuxmap:
    ignore:	"[ \r\t]+"
    ignore:	"\\\\\\n"
	ignore:	"(#|!).*"

	token EOF:	"$"
	token EOL:	"\n"
	token BLANK:	"[ \t]"
	token INCLUDE:	"include[ \t]*"
	token _DECIMAL:	"[1-9][0-9]*"
	token _OCTAL:	"0[0-7]*"
	token _HEX:	"0[xX][0-9a-fA-F]+"
	token _UNICODE:	"U\\+([0-9a-fA-F]){4}"
	token LITERAL:	"[a-zA-Z][a-zA-Z_0-9]*"
	token OCTA:	"([0-7]){1,3}"
	token CHARSET:	"charset|Charset|CharSet|CHARSET"
	token KEYMAPS:	"keymaps|Keymaps|KeyMaps|KEYMAPS"
	token KEYCODE:	"keycode|Keycode|KeyCode|KEYCODE"
	token STRING:	"string|String|STRING"
	token EQUALS:	"="
	token COMMA:	","
	token PLAIN:	"plain|Plain|PLAIN"
	token SHIFT:	"shift|Shift|SHIFT"
	token CONTROL:	"control|Control|CONTROL"
	token ALT:	"alt|Alt|ALT"
	token ALTGR:	"altgr|Altgr|AltGr|ALTGR"
	token SHIFTL:	"shiftl|ShiftL|SHIFTL"
	token SHIFTR:	"shiftr|ShiftR|SHIFTR"
	token CTRLL:	"ctrll|CtrlL|CTRLL"
	token CTRLR:	"ctrlr|CtrlR|CTRLR"
	token ALT_IS_META:	"[aA][lL][tT][-_][iI][sS][-_][mM][eE][tT][aA]"
	token STRINGS:	"strings|Strings|STRINGS"
	token COMPOSE:	"compose|Compose|COMPOSE"
	token AS:	"as|As|AS"
	token USUAL:	"usual|Usual|USUAL"
	token FOR:	"for|For|FOR"
	token ON:	"on|On|ON"
	token TO:	"to|To|TO"
	token _CHAR1: "'([0-7]){1,3}'"
	token _CHAR2: "'\\\\.'"
	token _CHAR3: "'.'"
	token PLUS:	"\\+"
	token _STRLITERAL: '\'([^\\n\'\\\\]|\\\\.)*\'|"([^\\n"\\\\]|\\\\.)*"'

	rule DECIMAL: _DECIMAL {{ return int(_DECIMAL) }}
	rule OCTAL: _OCTAL {{ return eval(_OCTAL,{},{}) }}
	rule HEX: _HEX {{ return eval(_HEX,{},{}) }}
	rule UNICODE: _UNICODE {{ return eval("u'\\u%s'" % _UNICODE[2:],{},{}) }}
	rule CCHAR: _CHAR1 {{ return eval(_CHAR1,{},{}) }}
		| _CHAR2 {{ return _CHAR2[2] }}
		| _CHAR3 {{ return _CHAR3[1] }}

	rule NUMBER: DECIMAL {{ return DECIMAL }}
		| OCTAL {{ return OCTAL }}
		| HEX {{ return HEX }}

	rule STRLITERAL: _STRLITERAL {{ return eval(_STRLITERAL,{},{}) }}

	rule map<<data>>: {{ self.data = data }} line* EOF

	rule line		: EOL
		| charsetline
		| altismetaline
		| usualstringsline
		| keymapline
		| fullline
		| singleline
		| strline
		| compline
		| include

	rule include: "include" STRLITERAL
		{{ self._scanner.stack_input(file=get_file(STRLITERAL), filename=STRLITERAL) }}

	rule charsetline	: CHARSET STRLITERAL EOL
#			{
#			    set_charset(kbs_buf.kb_string);
#			}

	rule altismetaline	: ALT_IS_META EOL
#			{
#			    alt_is_meta = 1;
#			}
	
	rule usualstringsline: STRINGS AS USUAL EOL
#			{
#			    strings_as_usual();
#			}

	rule compline: COMPOSE ( usualcomposeline | composeline )
	rule usualcomposeline: AS USUAL ( FOR STRLITERAL ) ? EOL
#			{
#			    compose_as_usual(kbs_buf.kb_string);
#			}
#		  | COMPOSE AS USUAL EOL
#			{
#			    compose_as_usual(0);
#			}

#			{
#			    keymaps_line_seen = 1;
#			}

	rule keymapline	: KEYMAPS range ( COMMA range )*

	rule range		: NUMBER {{ n1 = NUMBER }}
				    ( "-" NUMBER {{ self.data.add_map_vector(n1,NUMBER) }} 
					  | {{ self.data.add_map_vector(n1) }} )
#			{
#			    int i;
#			    for (i = $1; i<= $3; i++)
#			      addmap(i,1);
#			}
#		| NUMBER
#			{
#			    addmap($1,1);
#			}

	rule strline		: STRING LITERAL EQUALS STRLITERAL EOL
#			{
#			    if (KTYP($2) != KT_FN)
#				lkfatal1("'%s' is not a function key symbol",
#					syms[KTYP($2)].table[KVAL($2)]);
#			    kbs_buf.kb_func = KVAL($2);
#			    addfunc(kbs_buf);
#			}

	rule composeline        : CCHAR {{ c1 = CCHAR }}
                                   CCHAR {{ c2 = CCHAR }}
								   TO ( CCHAR
                        {{ self.data.compose(c1, c2, CCHAR); }} 
		 | rvalue {{ self.data.compose(c1, c2, rvalue); }} ) EOL 
         
	rule singleline	:	{{ mods = 0; }}
		  modifiers KEYCODE NUMBER EQUALS rvalue EOL
			{{ self.data.add(rvalue, NUMBER, Modifier(modifiers)); }}

		| PLAIN KEYCODE NUMBER EQUALS rvalue EOL
			{{ self.data.add(rvalue, NUMBER, Modifier(())); }}

	rule modifiers	: {{ vals = [] }} modifier<<vals>>+ {{ return vals }}

	rule modifier<<vals>>	: mod {{ vals.append(mod) }}
	rule mod: SHIFT {{ return "shift" }}
		| CONTROL {{ return "control" }}
		| ALT {{ return "alt" }}
		| ALTGR	 {{ return "altgr" }}
		| SHIFTL {{ return "shiftL" }}
		| SHIFTR {{ return "shiftR" }}
		| CTRLL {{ return "controlL" }}
		| CTRLR {{ return "controlR" }}

	rule fullline: KEYCODE NUMBER EQUALS rvalue0<<NUMBER>> EOL
#	{
#	    int i, j;
#
#	    if (rvalct == 1) {
#	        /* Some files do not have a keymaps line, and
#		   we have to wait until all input has been read
#		   before we know which maps to fill. */
#	        key_is_constant[$2] = 1;
#	    
#		/* On the other hand, we now have include files,
#		   and it should be possible to override lines
#		   from an include file. So, kill old defs. */
#		for (j = 0; j < max_keymap; j++)
#		    if (defining[j])
#		        killkey($2, j);
#	    }
#	    if (keymaps_line_seen) {
#		i = 0;
#		for (j = 0; j < max_keymap; j++)
#		  if (defining[j]) {
#		      if (rvalct != 1 || i == 0)
#			addkey($2, j, (i < rvalct) ? key_buf[i] : K_HOLE);
#		      i++;
#		  }
#		if (i < rvalct)
#		    lkfatal0("too many (%d) entries on one line", rvalct);
#	    } else
#	      for (i = 0; i < rvalct; i++)
#		addkey($2, i, key_buf[i]);
#	}


	rule rvalue0<<code>>: {{ keys = self.data.get_map_vector() }}
						( rvalue
						{{ self.data.add_more(rvalue, code, keys) }} )*

	rule rvalue: rvalue2 {{ return rvalue2 }}
		| PLUS rvalue2 {{ return rvalue2 }}
			## TODO: caps lock

	rule rvalue2: NUMBER
			{{ return eval("u'\\u%04x'" % NUMBER, {},{}) }}
		| UNICODE
			{{ return UNICODE }}
		| LITERAL
			{{ return lookup_symbol(LITERAL) }}
#		| UNUMBER
#			{{ $$=add_number($1); }}

%%

from keymapper.parse.linuxsyms import lookup_symbol, SymbolNotFound
from os.path import exists, join, curdir
from gzip import GzipFile
from keymapper.keymap import Keymap, Modifier
import os

dirs = []


def add_dir(d):
    """Helper to add a directory to the search path"""
    dirs.append(d)


class NoFileFound(Exception):
    pass


class FileProblem(Exception):
    pass


class TooManySyms(Exception):
    pass


def get_file(name):
    """Find a keymap file"""
    global dirs
    if not dirs:
        dirs = (curdir,)
    for end in ("", ".kmap", ".kmap.gz", ".inc", ".inc.gz", ".gz"):
        for dir in dirs:
            n = os.path.join(dir, name + end)
            if exists(n):
                if n.endswith(".gz"):
                    f = GzipFile(n, "rb")
                else:
                    f = open(n, "r")
                return f

    raise NoFileFound(name)


class ConsoleKeymap(Keymap):
    """submap with interesting features for generating Linux console maps"""

    def __init__(self, *a, **k):
        Keymap.__init__(self, *a, **k)
        self.map_vector = []

    def add_map_vector(self, a, b=None):
        """add to the list of keymaps"""
        if b is None:
            b = a
        self.map_vector.append((a, b))

    def get_map_vector(self):
        v = self.map_vector
        if not v:
            v = ((0, 255),)

        for a, b in v:
            for i in range(a, b + 1):
                yield Modifier(bits=i)

    def compose(self, c1, c2, result):
        pass

    def add_more(self, rvalue, code, keys):
        try:
            mod = next(keys)
        except StopIteration:
            raise TooManySyms(code, rvalue)
        else:
            # print(rvalue, code, mod)
            self.add(rvalue, code, mod)


def parse_file(name, with_alt=True):
    f = get_file(name)
    keymap = ConsoleKeymap(name, with_alt=with_alt)
    parser = linuxmap(linuxmapScanner("", file=f, filename=name))

    try:
        parser.map(keymap)
    except SymbolNotFound as e:
        print("Keysym '%s' not found" % e.args, file=sys.stderr)
        print(parser._scanner, file=sys.stderr)
        raise FileProblem(name)
    except runtime.SyntaxError as e:
        runtime.print_error(e, parser._scanner, max_ctx=1)
        raise FileProblem(name)
    except runtime.NoMoreTokens:
        print(
            "Could not complete parsing; stopped around here:", file=sys.stderr
        )
        print(parser._scanner, file=sys.stderr)
        raise FileProblem(name)

    return keymap
