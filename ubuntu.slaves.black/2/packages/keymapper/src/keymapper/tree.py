# tree.py
# represent a decision tree to decide between key maps

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\

This code examines a list of keyboard maps and generates a decision tree
which distinguishes between them in as few steps a possible.

    => class Tree

The resulting tree has redundant nodes. As it makes sense to keep file
sizes down, the redundant nodes are eliminated by turning the tree into
a directed acyclic graph.

    => Node.simplify().

The graph is then traversed in depth-first order, except that entries
which are referred to multiple times are processed only after their last
parent has been processed.

    => Node.seq*().

This traversal generates a list of steps, all of which only refer to
steps following them. A program which processed that list thus does
not need to save any state between steps.

"""

from __future__ import print_function, division

from functools import reduce
from operator import attrgetter
import sys
from time import time
from unicodedata import category

from keymapper.equiv import get_sym, chartype
from keymapper.keymap import SymSet

# follow what's happening?
trace = False
last_trace = 0

interactive = False

charhash = {}


def chartype(c):
    if c in charhash:
        return charhash[c]
    charhash[c] = h = category(c)[0]
    return h


class NoShownSyms(Exception):
    """A step doesn't actually display anything"""

    pass


class DupKeycode(Exception):
    """A key code has been added to a Choice node twice"""

    pass


class AlgorithmProblem(Exception):
    """The symbol selector was unable to find a solution"""

    pass


def sorted_maps(maps):
    return sorted(maps, key=attrgetter("name"))


class Reporter(object):
    """The interface for the output of the resulting decision tree"""

    def init(self):
        """Do preprocessing"""
        pass

    def exit(self):
        """Do postprocessing"""
        pass

    def step(self, stepnr):
        """Start a new step"""
        pass

    def keymap(self, map):
        """This steps selects a unique keymap"""
        raise NotImplementedError

    def symbols(self, symbols):
        """Start a choice: display these symbols"""
        raise NotImplementedError

    def choice(self, code, nextstep):
        """Choice: This keycode leads to that step"""
        raise NotImplementedError

    def ask(self, sym, no, yes):
        """Ask whether that symbol is visible"""
        raise NotImplementedError

    def ask_no_alt(self, sym, no, yes):
        """Ask whether that symbol is visible on primary keys"""
        raise NotImplementedError

    def finish(self):
        """Conclude this step"""
        pass


def gen_report(tree, reporter):
    """Generate a report"""
    reporter.init()
    tree.report(reporter)
    reporter.exit()


class Node(object):
    """a generic node in the keymap decision tree"""

    def __init__(self, maps):
        self.delay = 0
        self.maps = maps

    def __eq__(self, other):
        """Compare this node to another"""
        if self.__class__ is not other.__class__:
            return False
        return True

    def __ne__(self, other):
        """Compare this node to another"""
        return not self.__eq__(other)

    def simplify(self, cache):
        """Check whether this node is redundant"""
        self = self._simplify(cache)
        if self is None:
            return None
        key = self.key()
        if key in cache:
            return cache[key]
        cache[key] = self
        return self

    def report(self, gen):
        """Emit this node"""
        raise NotImplementedError

    def children(self):
        """Iterates over this node's immediate children"""
        raise StopIteration

    def key(self):
        """Return a string declaring this operation"""
        raise NotImplementedError

    def __str__(self):
        try:
            return "<" + self.key() + ">"
        except NotImplementedError:
            object.__str__(self)

    # Serialize this tree. We walk it twice, counting the number of parents.
    # The first pass increments a counter and numbers the nodes. The second
    # pass decrements and prints when a node is visited for the last time.
    #
    # Usage: tree.seq1(0)
    #        for node in tree.seq2():
    #            do_something_with(node)

    def seq1(self, nr):
        """Serialization, step 1: number nodes and count the parents"""
        # print("K %02d: %s :: %s" % (nr,repr(self),str(self)))
        self.delay += 1
        if self.delay > 1:
            return nr
        self.step = nr
        nr += 1
        for c in self:  # iterates the children
            if c is not None:
                nr = c.seq1(nr)
        self.maxstep = nr
        return nr

    def seq2(self):
        """Serialization, step 2: iterate over this node, if visited from its last parent"""
        # print("N %02d/%02d: %s :: %s" % (self.step,self.delay,repr(self),str(self)))
        if not self.delay:
            raise AssertionError("called seq2() before calling seq1()")

        self.delay -= 1
        if self.delay:
            return
        yield self
        for c in self:  # iterates over child nodes
            if c is not None:
                for n in c.seq2():
                    yield n

    def visible_syms(self, keys):
        """List symbols which actually correspond to keycodes"""
        num = 0
        for sym, codes in keys:
            seen = SymSet()
            for s in get_sym(sym):
                for m in self.maps:
                    if s not in m.seen:
                        continue
                    if s in seen:
                        continue
                    seen.add(s)
                    break
            for s in sorted(seen):
                num += 1
                yield s, codes
        if not num:
            raise NoShownSyms


class Choice(Node):
    """a node in the keymap decision tree which asks for one of a number
    of symbols and selects by the keycode that's returned"""

    def __init__(self, maps, sym2codes, code2map):
        Node.__init__(self, maps)
        self.sym2codes = sym2codes  # list of symbols to display => key codes
        self.children = code2map  # key code => node or keymap

    def __iter__(self):
        return iter(self.children.values())

    def __eq__(self, other):
        if not Node.__eq__(self, other):
            return False
        if len(self.sym2codes) != len(other.sym2codes):
            return False
        if len(self.children) != len(other.children):
            return False
        for sym in self.sym2codes:
            if sym not in other.sym2codes:
                return False
        for code, node in self.children.items():
            if code not in other.children:
                return False
            if node != other.children[code]:
                return False
        return True

    def __ne__(self, other):
        return not self.__eq__(other)

    def key(self):
        syms = [sym for sym in self.sym2codes]
        syms.sort()
        ret = (
            "Q:"
            + ":".join(["".join(get_sym(s)) for s in self.sym2codes])
            + ":"
        )
        codes = sorted(self.children)
        for code in codes:
            ret += "%d<%s>" % (code, self.children[code].key())
        return ret

    def _simplify(self, cache):
        """Try to make this node smaller"""
        for code, node in self.children.items():
            if node:
                node = node.simplify(cache)
            if node:
                self.children[code] = node
            else:
                del self.children[code]

        # Throw this node away if it doesn't decide anything any more
        uniq = None
        for child in self.children.values():
            if not uniq:
                uniq = child
            elif uniq != child:
                return self
        return uniq

    def filter(self, maps):
        """Drop branches not in map list"""
        for code, node in self.children.items():
            if node:
                node = node.filter(maps)
            if not node:
                del self.children[code]

        # Throw this node away if it doesn't decide anything any more
        if not self.children:
            return None
        return self

    def report(self, gen):
        gen.step(self.step)

        gen.symbols(self.visible_syms(self.sym2codes.items()))
        for code, node in self.children.items():
            gen.choice(code, node)
        gen.finish()


class Ask(Node):
    """a node in the keymap decision tree which asks whether a given keyboard symbol exists"""

    def __init__(self, maps, sym, no, yes):
        Node.__init__(self, maps)
        self.sym = sym
        self.no = no
        self.yes = yes

    def __iter__(self):
        yield self.no
        yield self.yes

    def key(self):
        return "S%s<%s><%s>" % (self.sym, self.yes.key(), self.no.key())

    def __eq__(self, other):
        if not Node.__eq__(self, other):
            return False
        if self.sym != other.sym:
            return False
        if self.yes != other.yes:
            return False
        if self.no != other.no:
            return False
        return True

    def _simplify(self, cache):
        if self.yes:
            self.yes = self.yes.simplify(cache)
        if self.no:
            self.no = self.no.simplify(cache)
        if self.yes == self.no:
            return self.yes
        if self.yes and self.no:
            return self
        if self.no:
            return self.no
        return self.yes

    def filter(self, maps):
        if self.yes:
            self.yes = self.yes.filter(maps)
        if self.no:
            self.no = self.no.filter(maps)
        if not self.yes and not self.no:
            return None
        return self

    def report(self, gen):
        gen.step(self.step)
        gen.ask(
            [s for s, c in self.visible_syms([(self.sym, None)])],
            self.no,
            self.yes,
        )
        gen.finish()


class AskNoAlt(Ask):
    """same as Ask, not without Alt* keys"""

    def report(self, gen):
        gen.step(self.step)
        gen.ask_no_alt(
            [s for s, c in self.visible_syms([(self.sym, None)])],
            self.no,
            self.yes,
        )
        gen.finish()


class Found(Node):
    """A node which resolves to a single keymap"""

    def __init__(self, node):
        Node.__init__(self, [node])
        self.node = node
        self.maps = [node]

    def __iter__(self):
        return ().__iter__()

    def __eq__(self, other):
        if not Node.__eq__(self, other):
            return False
        if self.node != other.node:
            return False
        return True

    def _simplify(self, cache):
        if self.node is None:
            return None
        return self

    def filter(self, maps):
        print("%s %s" % (self.node, maps))
        if self.node.name not in maps:
            return None
        return self

    def report(self, gen):
        gen.step(self.step)
        gen.keymap(self.node)
        gen.finish()

    def key(self):
        return "M<%s>" % self.node.name


# Special exceptions for signalling that there's no possible choice.


class NoMapping(Exception):
    pass


class SingleMapping(Exception):
    pass


class SingleMappingNoAlt(Exception):
    pass


# The main code starts here.


class Tree(object):
    """encapsulates a keymap decision tree."""

    def __init__(self):
        self.maps = set()  # list of keyboards
        self.symbols = {}  # symbol => [nummaps,sumpriority]
        self._id = 0
        self.interactively_skipped = set()

    def add(self, map):
        """add a keymap to the list"""
        self.maps.add(map)

    def __iter__(self):
        return iter(self.maps)

    def gen_tree(self, *filter):
        """generate a decision tree"""
        cache = {}

        self.tree = self._gen_tree(self.maps)
        self.tree = self.tree.simplify(cache)
        if self.tree and filter:
            self.tree.filter(filter)

    def report(self, gen):
        """Emit the generated nodes by passing them to a generator."""
        self.tree.seq1(0)
        for n in self.tree.seq2():
            n.report(gen)
        if interactive and self.interactively_skipped:
            print(
                "Skipped these keymaps interactively:", end="", file=sys.stderr
            )
            print(" ".join(self.interactively_skipped), file=sys.stderr)

    def _gen_tree(self, maps, xsyms=None):
        """One step of the selection algorithm."""

        if not len(maps):
            return None
        if len(maps) == 1:
            # This construct simply extracts the one set member ...
            return Found([m for m in maps][0])

        _id = self._id
        self._id += 1

        if not xsyms:
            xsyms = frozenset()
        # major speed-up: find the set of symbols which don't make a difference
        xsyms = drop_sym(maps, xsyms)

        syms = set()  # selected symbols
        codes = {}  # keycode => number of selected keymaps
        for alt in range(2):  # Try to get one alternate mapping
            steps = 0  # for reporting
            bt_steps = 0  # for limiting backtracks
            bt_level = None
            if trace > 1:
                if alt:
                    print(
                        "*** Alternate:",
                        " ".join(["".join(get_sym(s)) for s in sorted(syms)]),
                    )
                else:
                    print(
                        "*** Start:",
                        _id,
                        len(maps),
                        "maps:",
                        ",".join([m.name for m in sorted_maps(maps)]),
                    )
            try:
                open_map = frozenset(maps)
                track = []
                # List of backtracking iterators and the environment they
                # need to choose from. Backtracking is necessary because
                # a selection might exhaust all possible keymaps except
                # for one which happens to be a subset of another.

                chooser = None
                while open_map:
                    # Check if we overdid it
                    steps += 1
                    if alt and steps > 1000:
                        break

                    if not chooser:
                        global last_trace
                        if (
                            trace > 2
                            or trace
                            and time() - last_trace > 3
                            and len(open_map) > 2
                        ):
                            print(
                                "Step %d %d: choose from %s"
                                % (
                                    steps,
                                    len(track),
                                    ",".join(
                                        [m.name for m in sorted_maps(open_map)]
                                    ),
                                )
                            )
                            last_trace = time()
                        chooser = choose_sym(
                            open_map,
                            syms.union(xsyms),
                            xcode=codes,
                            all_maps=maps,
                            alt=alt,
                            depth=len(track),
                        )

                    while True:
                        # Loop invariant:
                        # open_map contains the keymaps for which we
                        # need to find a symbol selecting from them.
                        # syms: the keys selecting from maps no longer in open_map
                        # codes: the possible keycodes of these syms
                        #        => the list of maps they might refer to.

                        try:
                            if trace > 2:
                                print("track len", len(track), end="")
                            sym, do_single = next(chooser)

                        except StopIteration:
                            # This chooser is unable to return a
                            # suitable choice, so backtrack.
                            if trace > 1:
                                print(
                                    "exhausted",
                                    ",".join(
                                        [m.name for m in sorted_maps(open_map)]
                                    ),
                                )
                            if not track:
                                raise AlgorithmProblem(syms, maps, open_map)

                            # Check if we need to backtrack more aggressively.
                            # Otherwise we run for *ages*.
                            bt_steps += 1
                            if bt_steps > 100000:
                                bt_steps = 0
                                if bt_level is None or bt_level > len(track):
                                    bt_level = len(track)
                                    if trace > 1:
                                        print("Backtrack stepup", bt_level)
                                else:
                                    track = track[0:bt_level]
                                    # Drop off if we stepped way back
                                    # one and two levels
                                    if bt_level <= 1:
                                        bt_level = None
                                    else:
                                        bt_level = bt_level - 1
                                if trace > 1:
                                    print("Backtrack stepdown", bt_level)

                            chooser, syms, codes, open_map = track.pop()
                            if trace > 1:
                                print(
                                    "... back to",
                                    ",".join(
                                        [m.name for m in sorted_maps(open_map)]
                                    ),
                                )

                        except AlgorithmProblem:
                            raise AlgorithmProblem(syms, maps, open_map)

                        else:
                            if trace > 2:
                                print("got", str(sym), end="")
                            # We have a possible candidate.
                            try:
                                # Get the list of keymaps chosen by it
                                map_no = sym2maps(sym, maps, do_single)
                                if trace > 2:
                                    print(
                                        "OK, no_map",
                                        ",".join(
                                            [
                                                m.name
                                                for m in sorted_maps(map_no)
                                            ]
                                        ),
                                    )
                                break

                            except NoMapping:
                                # Try again / backtrack if this symbol
                                # doesn't actually affect our current
                                # choices.
                                if trace > 2:
                                    print("no mapping")
                                continue

                            except (SingleMapping, SingleMappingNoAlt) as exc:
                                # This is a possible yes/no question.
                                # If that's the best we can do, OK.
                                map_yes, map_no = exc.args
                                if trace > 2:
                                    if exc == SingleMapping:
                                        print("single mapping:", end="")
                                    else:
                                        print("single mapping no alt:", end="")
                                    print(
                                        "yes",
                                        len(map_yes),
                                        "no",
                                        len(map_no),
                                        "open",
                                        len(open_map),
                                        "track",
                                        len(track),
                                    )
                                if not track:
                                    if exc == SingleMapping:
                                        return Ask(
                                            maps,
                                            sym,
                                            yes=self._gen_tree(map_yes),
                                            no=self._gen_tree(map_no),
                                        )
                                    else:
                                        return AskNoAlt(
                                            maps,
                                            sym,
                                            yes=self._gen_tree(map_yes),
                                            no=self._gen_tree(map_no),
                                        )

                                        # Otherwise, try to add the symbol's
                                        # code as-is, assuming that it helps.
                                if map_yes & open_map:
                                    break
                                continue

                    new_codes = dict(codes)  # shallow copy
                    broken = False
                    for map in maps:
                        if broken:
                            break
                        if sym in map.sym2code:
                            for cd in map.sym2cod[sym]:
                                new_codes[cd] = 1 + new_codes.get(cd, 0)
                                if new_codes[cd] == len(maps):
                                    # This keycode now selects from all the
                                    # keymaps, which is not helpful -- prssing
                                    # that key would give us the whole
                                    # map again => endless loop.
                                    broken = True
                                    break
                    if broken:
                        if alt:
                            # If we just try to get a redundant mapping,
                            # end the process here.
                            break
                        # Otherwise, try again / backtrack.
                        if trace > 2:
                            print("no go")
                        continue

                        # remember the
                    track.append((chooser, syms, codes, open_map))
                    codes = new_codes
                    open_map &= map_no
                    syms.add(sym)
                    chooser = None

            except AlgorithmProblem as exc:
                # We get here if there's no possible choice.
                if alt:
                    # If we already have a completed pass through the
                    # list, that doesn't matter.
                    break

                (syms, maps, open_map) = exc.args

                print(
                    "These keymaps appear to be indistinguishable:",
                    ",".join([m.name for m in sorted_maps(open_map)]),
                    file=sys.stderr,
                )
                if trace:
                    for m in sorted_maps(open_map):
                        print(m.dump(), file=sys.stderr)
                if interactive:
                    print(
                        "Enter a preferred keymap (or nothing to quit):",
                        file=sys.stderr,
                    )
                    while True:
                        line = sys.stdin.readline().strip()
                        if line:
                            for m in sorted_maps(open_map):
                                if m.name == line:
                                    for other in open_map:
                                        if other.name != line:
                                            self.interactively_skipped.add(
                                                other.name
                                            )
                                    return Found(m)
                            else:
                                print("%s not found." % line, file=sys.stderr)
                        else:
                            print("OK, giving up.", file=sys.stderr)
                            print(
                                "Skipped these keymaps interactively:",
                                end="",
                                file=sys.stderr,
                            )
                            print(
                                " ".join(self.interactively_skipped),
                                file=sys.stderr,
                            )
                            break
                sys.exit(1)

        # Now build a Choice node from what we have found.
        data = {}
        codes = {}
        sym2codes = {}
        for sym in syms:
            if sym not in sym2codes:
                sym2codes[sym] = []
            for map in maps:
                if sym not in map.sym2cod:
                    continue
                for code in map.sym2cod[sym]:
                    if code not in codes:
                        codes[code] = set()
                    codes[code].add(map)
                    if code not in sym2codes[sym]:
                        sym2codes[sym].append(code)

        if trace > 1:
            print("***", _id)
            for code, map in sorted(codes.items()):
                print(code, map)
            print(
                "*** end ***",
                _id,
                len(maps),
                "***",
                " ".join(
                    [
                        "%s:%s"
                        % (s, ",".join(["".join(get_sym(cc)) for cc in c]))
                        for s, c in sorted(sym2codes.items())
                    ]
                ),
            )
            print()
        for code, map in sorted(codes.items()):
            codes[code] = self._gen_tree(map)

        ch = Choice(maps, sym2codes, codes)
        return ch


def choose_sym(maps, xsym=(), xcode=(), all_maps=(), alt=0, depth=None):
    """Find the 'best' symbol in a set of keymaps"""
    # symbol => [ preference, number of keymaps with that symbol,
    #             mapping keycode => number of keyboards with that mapping
    symdata = {}
    # same, but without "alt" keys
    symdata_no_alt = {}

    supermaps = set()
    do_log = 0
    if depth is not None:
        if depth >= 2:
            depth = None  # 10*depth
        elif depth == 1:
            do_log = 2
            depth = 30
        else:  # 0
            do_log = 1
            depth = 10

    # If any of these maps is a subset of one of all_maps, drop out.
    # Reason: We can't put up a "do you have this key" question now.
    for m in sorted_maps(maps):
        for am in sorted_maps(all_maps):
            if m.is_submap(am):
                if am not in maps:
                    return
                supermaps.add(am)

    # Otherwise, filter supermaps
    if len(maps) - len(supermaps) <= 1:
        supermaps = ()

    for map in sorted_maps(maps):
        if map in supermaps:
            continue
        for sym in sorted(map.symbols()):
            if sym in xsym:
                continue
            if sym not in symdata:
                symdata[sym] = [0, 0, {}]
            data = symdata[sym]
            pri = 0

            # Heuristic: We try to block keys on ALT mappings, which
            # have values smaller than zero, by never raising the value
            # if it ever goes below zero
            # if data[0] >= 0:
            #     if pri is None:
            #         pass
            #     data[0] += pri
            #     if pri >= 0 and data[0] < 0:
            #         data[0] = 0
            # else:
            #     if pri < 0:
            #         data[0] += pri

            for s in get_sym(sym):

                if len(s) != 1:
                    pri += 100
                elif ord(s) > 0x40 and ord(s) <= 0x5A:
                    if alt:
                        pri += 300
                    else:
                        pri += 2000
                elif ord(s) > 0x60 and ord(s) <= 0x7A:
                    if alt:
                        pri += 300
                    else:
                        pri += 2000
                elif ord(s) <= 32 or ord(s) == 127:
                    pri += -100000  # ... likewise ...
                else:
                    cat = chartype(s)[0]
                    if cat == "L":
                        if alt:
                            pri += 600
                        else:
                            pri += 1500
                    elif cat == "Z" or cat == "C" or cat == "U":
                        pri -= 100000  # shouldn't happen, but ...
                    elif cat == "M":
                        pri -= 10000  # non-spacing modifiers
                    elif cat == "S":
                        pri += 100  # includes spacing modifiers
                    else:
                        pri += 200  # whatever's left

            data[0] += pri // len(get_sym(sym)) + map.priority(sym)

            for code in map.sym2cod[sym]:
                # This check must not be done here.
                # It blocks the "raise AlgorithmProblem" later if we
                # have two maps A:sym=(code1,code2) and B:sym=(code1)
                # and code1 is in xcodes.

                # if code in xcode: continue

                if code not in data[2]:
                    data[2][code] = 0

                data[1] += 1
                data[2][code] += 1

                # Duplicate of the same, for the non-alt case
        for sym in sorted(map.symbols_no_alt()):
            if sym in xsym:
                continue
            if sym not in symdata_no_alt:
                symdata_no_alt[sym] = [0, 0, {}]
            data_no_alt = symdata_no_alt[sym]
            pri = 0

            # Heuristic: We try to block keys on ALT mappings, which
            # have values smaller than zero, by never raising the value
            # if it ever goes below zero
            # if data_no_alt[0] >= 0:
            #     if pri is None:
            #         pass
            #     data_no_alt[0] += pri
            #     if pri >= 0 and data_no_alt[0] < 0:
            #         data_no_alt[0] = 0
            #     else:
            #         if pri < 0:
            #             data_no_alt[0] += pri

            for s in get_sym(sym):

                if len(s) != 1:
                    pri += 100
                elif ord(s) > 0x40 and ord(s) <= 0x5A:
                    if alt:
                        pri += 300
                    else:
                        pri += 2000
                elif ord(s) > 0x60 and ord(s) <= 0x7A:
                    if alt:
                        pri += 300
                    else:
                        pri += 2000
                elif ord(s) <= 32 or ord(s) == 127:
                    pri += -100000  # ... likewise ...
                else:
                    cat = chartype(s)[0]
                    if cat == "L":
                        if alt:
                            pri += 600
                        else:
                            pri += 1500
                    elif cat == "Z" or cat == "C" or cat == "U":
                        pri -= 100000  # shouldn't happen, but ...
                    elif cat == "M":
                        pri -= 10000  # non-spacing modifiers
                    elif cat == "S":
                        pri += 100  # includes spacing modifiers
                    else:
                        pri += 200  # whatever's left

            data_no_alt[0] += pri // len(get_sym(sym)) + map.priority(sym)

            for code in map.sym2cod_no_alt[sym]:
                if code not in data_no_alt[2]:
                    data_no_alt[2][code] = 0

                data_no_alt[1] += 1
                data_no_alt[2][code] += 1

    syms = []
    syms_no_alt = []
    xxsyms = set()

    for sym, (pri, sum, codes) in sorted(symdata.items()):
        if not codes.values():
            continue
        # if len([v for v in codes.values() if v == len(maps)]):
        #     continue
        for c in codes:
            if c in xcode:
                xxsyms.add(sym)
                break

        # This is the max number of keymaps which have that symbol
        # on the same key.
        maxcodes = reduce(max, [num for num in codes.values()])
        nfull = 0
        for map in all_maps:
            if sym in map.sym2cod:
                nfull += 1

        # Count the number of symbols which actually appear
        nsym = 0
        for c in get_sym(sym):
            for m in all_maps:
                if c in m.seen:
                    nsym += 1
                    break
        # adjust for capital letters
        if nsym == 2:
            nsym = 1

        # heuristics:
        # Prefer symbols that appear in all maps (slightly).
        # Prefer symbols that don't appear in maps we already selected.
        # Prefer symbols that appear in many keyboards.
        # Prefer symbols which result in many small subtrees,
        #   i.e. the number of maps having that symbol on the same
        #        keycode is small.
        # Prefer non-ambiguous symbols.
        pri -= 50 * (len(maps) - sum)
        pri -= 500 * (nfull - sum)
        pri += 100 * len(codes)
        pri -= 1000 * maxcodes
        pri -= 500 * nsym
        syms.append((-pri, sym))

    # Duplicate of the same, for the non-alt case
    for sym, (pri, sum, codes) in sorted(symdata_no_alt.items()):
        if not codes.values():
            continue
        for c in codes:
            if c in xcode:
                xxsyms.add(sym)
                break

        maxcodes = reduce(max, [num for num in codes.values()])
        nfull = 0
        for map in all_maps:
            if sym in map.sym2cod_no_alt:
                nfull += 1

        nsym = 0
        for c in get_sym(sym):
            for m in all_maps:
                if c in m.seen:
                    nsym += 1
                    break
        if nsym == 2:
            nsym = 1

        pri -= 50 * (len(maps) - sum)
        pri -= 500 * (nfull - sum)
        pri += 100 * len(codes)
        pri -= 1000 * maxcodes
        pri -= 500 * nsym
        syms_no_alt.append((-pri, sym))

    syms.sort()
    syms_no_alt.sort()
    # print()
    # print(syms)
    # for m in maps:
    #     print(m.dump())
    # print()

    # First, generate normal "press a key" choices.
    nret = 0
    for pri, sym in syms:
        if sym not in xxsyms:
            if trace > 2:
                print("check", str(sym), end="")
            if do_log and trace > 1:
                print("Return1", do_log, "".join(get_sym(sym)))
            yield sym, None
            if depth:
                nret += 1
                if nret > depth:
                    break

    # If that didn't work, use excluded keycodes
    if not alt:
        nret = 0
        for pri, sym in syms:
            if sym in xxsyms:
                if trace > 2:
                    print("check", str(sym), end="")
                if do_log and trace > 1:
                    print("Return2", do_log, "".join(get_sym(sym)))
                yield sym, None
                if depth:
                    nret += 1
                    if nret > depth:
                        break

    # If that didn't work, generate yes/no questions for non-ALT keys.
    for pri, sym in syms_no_alt:
        if symdata_no_alt[sym][1] < len(maps) - len(supermaps):
            # ... but only if there are keyboards for which the answer is 'no'.
            if do_log and trace > 1:
                print("Return3", do_log, "".join(get_sym(sym)))
            yield sym, SingleMappingNoAlt

            # If that didn't work, generate yes/no questions.
    for pri, sym in syms:
        if symdata[sym][1] < len(maps) - len(supermaps):
            # ... but only if there are keyboards for which the answer is 'no'.
            if do_log and trace > 1:
                print("Return4", do_log, "".join(get_sym(sym)))
            yield sym, SingleMapping

    if do_log and trace > 1:
        print("ReturnEnd", do_log)


def drop_sym(maps, xsym):
    """Find those symbol in a set of keymaps"""
    return xsym


def sym2maps(sym, maps, choose):
    """Returns a list keycode => maps with the symbol on that key"""
    codes = set()
    xmaps = set()
    xmaps_no_alt = set()
    altmaps = set()

    for map in maps:
        if not sym in map.sym2cod:
            xmaps.add(map)
            xmaps_no_alt.add(map)
            continue
        if not sym in map.sym2cod_no_alt:
            xmaps_no_alt.add(map)
        for code, mod in map.sym2code[sym]:
            codes.add(code)
            if mod.pri < 0:
                altmaps.add(code)

    # If there's less than two choices, return via an exception.
    if len(codes) == 0:
        if trace > 3:
            print("unknown,", end="")
        raise NoMapping(sym)
    if choose or len(codes) == 1:
        if not xmaps or (choose == SingleMappingNoAlt and not xmaps_no_alt):
            if trace > 3:
                if len(codes) == 1:
                    print("same,", end="")
                else:
                    print("choice,", end="")
            raise NoMapping(sym)
        if choose:
            if trace > 3:
                print("single,", end="")
            if choose == SingleMappingNoAlt:
                raise choose(maps - xmaps_no_alt, xmaps_no_alt)
            else:
                raise choose(maps - xmaps, xmaps)

    # If the symbol occurs with normal AND AltGr mappings,
    # ignore the AltGr stuff -- the symbol may not actually be
    # printed on the key...
    if xmaps > altmaps:
        xmaps -= altmaps

    return xmaps
