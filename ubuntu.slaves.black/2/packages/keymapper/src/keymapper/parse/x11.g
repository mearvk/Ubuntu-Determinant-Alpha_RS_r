"""
This code implements a parser for Linux keyboard maps.
"""

%%

parser x11map:
    ignore:	"[ \n\r\t]+"
	ignore:	"(#|!).*"
	ignore:	"\/\/.*"

	token EOF:	"$"
	token INCLUDE:	"include"
	token SETMODWHAT:	"SetMods\\.[a-zA-Z0-9_]+"
	token KEYWHAT:	"key\\.[a-zA-Z0-9_]+"
	token HEX:	"0x[a-zA-Z0-9]+"
	token UNI:	"U[0-9A-Fa-f]{4}"
	token UNI3:	"U[0-9A-Fa-f]{3}"
	token SYM:	"[a-zA-Z0-9_]+"
	token NUM:	"[-+]?[0-9_]+"
	#token _CHAR1: "'([0-7]){1,3}'"
	#token _CHAR2: "'\\\\.'"
	#token _CHAR3: "'.'"
	#token PLUS:	"\\+"
	token _STRLITERAL: '\'([^\\n\'\\\\]|\\\\.)*\'|"([^\\n"\\\\]|\\\\.)*"'
	token _KEYLITERAL: '<[A-Za-z0-9]+>'

	rule STRLITERAL: _STRLITERAL {{ return eval(_STRLITERAL,{},{}) }}
	rule KEYLITERAL: _KEYLITERAL {{ return _KEYLITERAL[1:-1] }}

	rule map<<name>>: one_map<<name>>* EOF
	
	rule one_map<<name>>: {{ default = False }} {{ hidden = False }}
			( "partial"
			| "default" {{ default=True }} 
			| "hidden" {{ hidden=True }} 
			)*
			mods*
			"xkb_symbols" STRLITERAL {{ sub=STRLITERAL }}
			{{ data = X11Keymap(name,sub) }}
			"{"
				( incl<<data>> | entry<<data>>
				  | setmod | vmod | naming | modmap | keyset ) *
			"}"
			{{ known[(name,sub)] =  data }}
			{{ if default: known[name] = data }}
			";"

	rule naming: "[Nn]ame" "\\[" SYM "\\]" "=" STRLITERAL ";" 

	rule modmap: "modifier_map" SYM "{" symkey ( "," ? symkey ) * "}" ";"
	#rule modmap: "modifier_map" SYM "{" SYM ( "," SYM ) * "}" ";"
	rule symkey: SYM | _KEYLITERAL
	rule vmod: "virtual_modifiers" SYM ";"
	rule setmod:  SETMODWHAT "=" SYM ";"


	rule keyset: KEYWHAT ( "\\[" SYM "\\]" ) ? "=" STRLITERAL ";"


	rule mods: "keypad_keys" | "function_keys"
			| "alphanumeric_keys" | "modifier_keys" | "alternate_group"
	rule incl<<data>>: "include" STRLITERAL {{ data.append(STRLITERAL) }}

	rule entry<<data>>: {{ rep=UseOld }}
		( ( "replace" | "override" ) {{ rep=UseNew }} ) ?
		"key" KEYLITERAL {{ k=[rep,KEYLITERAL] }}
		"{" stuffgroup<<k>>
		    ( "," {{ k.append(Restart) }} stuffgroup<<k>> ) *
		"}" ";" {{ data.append(k) }}

	rule stuffgroup<<k>>: stuff | group<<k>>
	rule stuff: stuffsym | stuffvirt | stufftype | stuffover
	rule stuffsym: "symbols" "\\[" SYM "\\]" "="
		"\\[" ( SYM ( "," SYM ) * ) ? "\\]"
	rule stuffvirt: "virtualMods" "=" SYM
	rule stufftype: "type" ( "\\[" SYM "\\]" ) ? "=" STRLITERAL
	rule stuffover: "overlay[12]" "=" KEYLITERAL

	rule group<<k>>: "\\[" ( sym {{ if sym: k.append(sym) }}
			( "," ? sym {{ if sym: k.append(sym) }} ) * ) ? 
			"\\]"

	rule sym: "NoSymbol" {{ return None }}
			| "SetMods" "\\(" SYM "=" SYM "\\)" {{ return None }}
			| "LockGroup" "\\(" SYM "=" NUM "\\)" {{ return None }}
			| UNI {{ return eval('u"\\u%s"' % (UNI[1:]),{},{}) }}
			| UNI3 {{ return eval('u"\\u0%s"' % (UNI3[1:]),{},{}) }}
			| HEX {{ return eval('u"\\U%08x"' % (eval(HEX)-0x1000000,),{},{}) }}
			| SYM {{ return lookup_symbol(SYM) }}
 	
%%

from keymapper.parse.linuxsyms import lookup_symbol, SymbolNotFound
from os.path import exists, join, curdir
from gzip import GzipFile
from keymapper.keymap import Keymap, Modifier, STD, SHIFT, ALT, ALTSHIFT
import os, re

symfile = "/usr/share/misc/keymap.xkeys"
if exists("data/xkeys") and exists("gen_keymap"):
    symfile = "data/xkeys"

xsyms = {}


def read_map():
    f = open(symfile)
    for l in f:
        l = l.strip()
        comment = l.find("#")
        if comment > -1:
            l = l[:comment]
        l = l.strip()
        if l == "":
            continue
        s, d = l.split()
        xsyms[s] = eval("0x" + d, {}, {})


read_map()
del read_map

defmap = "us"
defkey = "pc101"

dirs = []


def add_dir(d):
    """Helper to add a directory to the search path"""
    dirs.append(d)


class BadStep(Exception):
    pass


class NoFileFound(Exception):
    pass


class FileProblem(Exception):
    pass


class TooManySyms(Exception):
    pass


class Restart:  # Marker
    pass


class UseOld:
    pass


class UseNew:
    pass


def get_file(name):
    """Find a keymap file"""
    global dirs
    if not dirs:
        dirs = ("/usr/lib/X11/xkb/symbols",)
    for end in ("", ".gz"):
        for dir in dirs:
            n = os.path.join(dir, name + end)
            if exists(n):
                if n.endswith(".gz"):
                    f = GzipFile(n, "rb")
                else:
                    f = open(n, "r")
                return f

    raise NoFileFound(name)


m_incl2 = re.compile("^(.+)\\((.+)\\)$")
next_mod = {STD: SHIFT, SHIFT: ALT, ALT: ALTSHIFT, ALTSHIFT: ALT}


class X11Keymap(Keymap):
    """submap with interesting features for generating X11 maps"""

    def __init__(self, name, sub=None):
        Keymap.__init__(self, name + "(" + sub + ")")
        self.map_vector = []
        self.steps = []
        self.build_done = False

    def append(self, what):
        self.steps.append(what)

    def build_map(self, to_map=None, keymap=None):
        if to_map is None:
            if self.build_done:
                return
            to_map = self

        if keymap is None:
            keymap = {}
        for s in self.steps:
            if isinstance(s, list) or isinstance(s, tuple):
                rep = s[0]
                code = s[1]
                try:
                    code = xsyms[code]
                except KeyError:
                    continue
                s = s[2:]
                if rep == UseOld and code in keymap:
                    continue
                keymap[code] = s

            elif isinstance(s, basestring):
                # include file. Can be "name(sub)".
                m = m_incl2.match(s)
                if m:
                    s = (m.group(1), m.group(2))
                    if s not in known:
                        parse_file(s[0], s[1])
                else:
                    if s not in known:
                        parse_file(s)

                known[s].build_map(to_map, keymap)
            else:
                raise BadStep

        if to_map == self and not self.build_done:
            self.build_done = True
            s = (defmap, defkey)
            if s not in known:
                parse_file(defmap, defkey)
            known[s].build_map(to_map, keymap)

        for code, keys in keymap.items():
            mod = STD
            for k in keys:
                if k == Restart:
                    # mod=STD # heuristic
                    continue
                to_map.add(k, code, mod)
                mod = next_mod[mod]


known = {}


def parse_file(name, sub=None):
    if sub:
        k = (name, sub)
    else:
        m = m_incl2.match(name)
        if m:
            (name, sub) = (m.group(1), m.group(2))
            k = (name, sub)
        else:
            k = name

    if s not in known:
        f = get_file(name)
        parser = x11map(x11mapScanner("", file=f, filename=name))

        try:
            parser.map(name)
        except SymbolNotFound as e:
            print("Keysym '%s' not found" % e.args, file=sys.stderr)
            print(parser._scanner, file=sys.stderr)
            raise FileProblem(name)
        except runtime.SyntaxError as e:
            runtime.print_error(e, parser._scanner, max_ctx=1)
            raise FileProblem(name)
        except runtime.NoMoreTokens:
            print(
                "Could not complete parsing; stopped around here:",
                file=sys.stderr,
            )
            print(parser._scanner, file=sys.stderr)
            raise FileProblem(name)

    try:
        map = known[k]
    except KeyError:
        return None
    map.build_map()
    return map
