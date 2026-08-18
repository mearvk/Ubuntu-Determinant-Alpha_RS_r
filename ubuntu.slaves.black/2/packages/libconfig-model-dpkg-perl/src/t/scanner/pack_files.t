# -*- cperl -*-
use strict;
use warnings;
use 5.010;

use Test::More;                 # see done_testing()
use Test::Differences;
use YAML::XS;

require_ok( 'Dpkg::Copyright::Scanner' );

my @tests = (
    [
        'dir with one file',
        "---
data-impl:
  defgroup.h: 1
",
        [['1', 'data-impl/defgroup.h']] ,
    ],
    [
        'dir with several files',
        "---
data:
  cert-store.cc: 5
  cert-store.h: 5
  defgroup.h: 1
  parts.cc: 3
  parts.h: 3
",
        [
            [ 5, 'data/cert-store.cc', 'data/cert-store.h'],
            [ 1, 'data/defgroup.h'],
            [ 3, 'data/parts.cc', 'data/parts.h']
        ]
    ],
    [
        'dir with subdirs',
        "
---
'*': 0
pan:
  '*': 4
  data:
    cert-store.cc: 5
    cert-store.h: 5
    defgroup.h: 1
    parts.cc: 3
    parts.h: 3
  data-impl:
    defgroup.h: 1
  general:
    debug.cc: 1
    defgroup.h: 1
    e-util.cc: 8
    e-util.h: 8
  gui:
    action-manager.h: 1
    defgroup.h: 1
    e-action-combo-box.c: 18
    e-action-combo-box.h: 18
    e-charset-combo-box.c: 17
    e-charset-combo-box.h: 17
  icons:
    '*': 4
",
        [
            [ 0,'*'                                                             ],
            [ 4,'pan/*'                                                         ],
            [ 1,'pan/data-impl/defgroup.h'                                      ],
            [ 5,'pan/data/cert-store.cc','pan/data/cert-store.h'                ],
            [ 1,'pan/data/defgroup.h'                                           ],
            [ 3,'pan/data/parts.cc','pan/data/parts.h'                          ],
            [ 1,'pan/general/debug.cc','pan/general/defgroup.h'                 ],
            [ 8,'pan/general/e-util.cc','pan/general/e-util.h'                  ],
            [ 1,'pan/gui/action-manager.h','pan/gui/defgroup.h'                 ],
            [ 18,'pan/gui/e-action-combo-box.c','pan/gui/e-action-combo-box.h'  ],
            [ 17,'pan/gui/e-charset-combo-box.c','pan/gui/e-charset-combo-box.h'],
            [ 4,'pan/icons/*'                                                   ],
        ]
    ],
    [
        'interspersed copyrights',
        "---
include:
  SDL.h: 2
  SDL_copying.h: 2
  SDL_cpuinfo.h: 2
  SDL_egl.h: 3
  SDL_endian.h: 2
  SDL_mutex.h: 2
  SDL_name.h: 0
  SDL_opengl.h: 2
  SDL_opengles.h: 2
  SDL_opengles2.h: 3
  SDL_pixels.h: 2
  SDL_render.h: 2
  SDL_revision.h: 0
  SDL_rwops.h: 2
  close_code.h: 2
",
        [
           [ 2,'include/SDL.h','include/SDL_copying.h','include/SDL_cpuinfo.h','include/SDL_endian.h','include/SDL_mutex.h','include/SDL_opengl.h','include/SDL_opengles.h','include/SDL_pixels.h','include/SDL_render.h','include/SDL_rwops.h','include/close_code.h'],
           [ 3,'include/SDL_egl.h','include/SDL_opengles2.h'],
           [ 0,'include/SDL_name.h','include/SDL_revision.h'],
        ]
    ]

);

foreach my $t (@tests) {
    my ($label,$in,$expect) = @$t;
    my @res = Dpkg::Copyright::Scanner::__pack_files(Load($in));
    eq_or_diff(\@res,$expect,"__pack_files $label");
}


done_testing();
