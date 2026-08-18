# -*- cperl -*-
use strict;
use warnings;
use 5.010;

use Test::More;   # see done_testing()
use Test::Differences;

require_ok( 'Dpkg::Copyright::Scanner' );

# __pack_copyright tests

my @tests = (
    [
        '2002-06 Charles Kerr <charles@rebelbase.com>',
        '2002-2006, Charles Kerr <charles@rebelbase.com>'
    ],
    [
        '2011 Heinrich Muller <henmull@src.gnome.org> / 2002-2006 Charles Kerr <charles@rebelbase.com>',
        "2011, Heinrich Muller <henmull\@src.gnome.org>\n 2002-2006, Charles Kerr <charles\@rebelbase.com>"
    ],
    [
        '2002-6 Charles Kerr <charles@rebelbase.com> / 2002, 2003, 2004, 2005, 2007, 2008, 2010 Free Software / 2011 Heinrich Muller <henmull@src.gnome.org> / 2002 vjt (irssi project)',
        "2011, Heinrich Muller <henmull\@src.gnome.org>\n 2002-2006, Charles Kerr <charles\@rebelbase.com>\n 2002-2005, 2007, 2008, 2010, Free Software\n 2002, vjt (irssi project)"
    ],
    [
        q!2004-2015, Oliva f00 Oberto / 2001-2010, Paul bar Stevenson !,
        "2004-2015, Oliva f00 Oberto\n 2001-2010, Paul bar Stevenson"
    ],
    [
        '2005, Thomas Fuchs (http://script.aculo.us, http://mir.aculo.us) / 2005, Michael Schuerig (http://www.schuerig.de/michael/) / 2005, Jon Tirsen (http://www.tirsen.com)',
        "2005, Thomas Fuchs (http://script.aculo.us, http://mir.aculo.us)\n 2005, Michael Schuerig (http://www.schuerig.de/michael/)\n 2005, Jon Tirsen (http://www.tirsen.com)"
    ],
    [
        '1998 Brian Bassett <brian@butterfly.ml.org>
2002 Noel Koethe <noel@debian.org>
2003-2010 Jonathan Oxer <jon@debian.org>
2006-2010 Jose Luis Tallon <jltallon@adv-solutions.net>
2010 Nick Leverton <nick@leverton.org>
2011-2014 Dominique Dumont <dod@debian.org>',
        '2011-2014, Dominique Dumont <dod@debian.org>
 2010, Nick Leverton <nick@leverton.org>
 2006-2010, Jose Luis Tallon <jltallon@adv-solutions.net>
 2003-2010, Jonathan Oxer <jon@debian.org>
 2002, Noel Koethe <noel@debian.org>
 1998, Brian Bassett <brian@butterfly.ml.org>',
    ]
);

foreach my $t (@tests) {
    my ($in,$expect) = @$t;
    my $label = length $in > 50 ? substr($in,0,30).'...' : $in ;
    eq_or_diff(Dpkg::Copyright::Scanner::__pack_copyright($in),$expect,"__pack_copyright '$label'");
}


done_testing();
