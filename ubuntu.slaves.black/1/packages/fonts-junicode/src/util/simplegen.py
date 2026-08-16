import fontforge
import sys
CURRENT_FONT = fontforge.open(sys.argv[1])
CURRENT_FONT.generate(sys.argv[2],flags=('round','omit-instructions','opentype','dummy-dsig'))
