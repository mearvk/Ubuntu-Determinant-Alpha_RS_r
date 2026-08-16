from fontTools.ttLib import TTFont
import sys
import re

__usage__ = """
-----
USAGE:
python ubuntu0.8fix.py version-number font|fonts

eg:
python ubuntu0.8fix.py 0.82 font.ttf

python ubuntu0.8fix.py 0.82 font.ttf font2.ttf


-----
VERSION-NUMBER:
Version number must be X.XX format. It must
consist of three digits and include a period
after the first digit.
"""


def usage():
    print __usage__


def modify_version_glyph(glyph, version_number):

    '''Increase Ubuntu version number glyph'''

    mapping = {
                '.': 'period',
                '0': 'zerosuperior',
                '1': 'onesuperior',
                '2': 'twosuperior',
                '3': 'threesuperior',
                '4': 'foursuperior',
                '5': 'fivesuperior',
                '6': 'sixsuperior',
                '7': 'sevensuperior',
                '8': 'eightsuperior',
                '9': 'ninesuperior'
                }

    for component, value in zip(glyph.components, str(version_number)):
        component.glyphName = mapping[value]


def main():
    #Handle no bash queries
    if len(sys.argv) == 1:
        usage()
        quit()

    #Handle invalid version numbers
    if len(sys.argv[1]) != 4:
        print 'Invalid version number!'
        usage()
        quit()

    try:
        float(sys.argv[1])
    except ValueError:
        print 'Invalid version number!'
        usage()
        quit()

    font_version = sys.argv[1]
    font_paths = sys.argv[2:]


    for font_path in font_paths:
        if not '.ttf' in font_path:
            print 'ttfs only'
            break

        font = TTFont(font_path, recalcBBoxes=False)
        outfile = font_path[:-4] + '#.ttf'

        font['cmap']
        font['head'].fontRevision = float(font_version)

        #---Mac Names---
        #Update Unique ID
        old_id = font['name'].getName(3, 1, 0, 0).string
        new_id = re.sub(r'[0-9]+\.[0-9]+', str(font_version), old_id)
        font['name'].getName(3, 1, 0, 0).string = new_id

        #Update Version
        ver_m = 'Version %s' % font_version
        font['name'].getName(5, 1, 0, 0).string = ver_m

        #---Windows Names---
        enc = font['name'].getName(5, 3, 1, 1033).getEncoding()

        #Update Unqiue ID
        font['name'].getName(3, 3, 1, 1033).string = new_id.encode(enc)

        #Update Version
        ver_w = str(font_version).encode(enc)
        font['name'].getName(5, 3, 1, 1033).string = ver_w

        #Increase version number glyph if the fonts are not monospace
        if not 'Mono' in font['name'].getName(1, 1, 0, 0).string:
            version_glyph = font['glyf']['uniEFFD']
            font_version_g = font_version+'0'
            modify_version_glyph(version_glyph, font_version_g)

        font.save(outfile)
        print 'Done %s' % font['name'].getName(4, 1, 0, 0).string


if __name__ == '__main__':
    main()
